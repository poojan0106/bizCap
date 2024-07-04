/**
* @author AAkonsult Consulting
* @date 13/04/2017
*
* @group 
*
* @description A trigger framework with thanks to: https://github.com/kevinohara80/sfdc-trigger-framework
*
* @maintenance
*/


/* USAGE 
To create a trigger handler, you simply need to create a class that inherits from TriggerHandler.cls. Example:
public class OpportunityTriggerHandler extends TriggerHandler {

	private Map<Id, Opportunity> newOppMap;

  	public OpportunityTriggerHandler() {
    	this.newOppMap = (Map<Id, Opportunity>) Trigger.newMap;
  	}
  
  	public override void afterUpdate() {
    	//
  	}
}
*/

/* USAGE - Max Loop Count
To prevent recursion, you can set a max loop count for Trigger Handler. If this max is exceeded, and exception will be thrown. 
A great use case is when you want to ensure that your trigger runs once and only once within a single execution. Example:
public class OpportunityTriggerHandler extends TriggerHandler {

  	public OpportunityTriggerHandler() {
    	this.setMaxLoopCount(1);
  	}
  
  	public override void afterUpdate() {
    	List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Id IN :Trigger.newMap.keySet()];
    	update opps; // this will throw after this update
  	}
}
*/

/* USAGE - Bypass API
What if you want to tell other trigger handlers to halt execution? That's easy with the bypass api. Example:
public class OpportunityTriggerHandler extends TriggerHandler {
  
  	public override void afterUpdate() {
    	List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE Id IN :Trigger.newMap.keySet()];
    
    	Account acc = [SELECT Id, Name FROM Account WHERE Id = :opps.get(0).AccountId];

    	TriggerHandler.bypass('AccountTriggerHandler');

    	acc.Name = 'No Trigger';
    	update acc; // won't invoke the AccountTriggerHandler

    	TriggerHandler.clearBypass('AccountTriggerHandler');

    	acc.Name = 'With Trigger';
    	update acc; // will invoke the AccountTriggerHandler
  }
}
*/

/* USAGE - Example Account Trigger
	trigger AccountTrigger on Account(before delete) {
	    new AccountTriggerHandler().run();
	}
*/

/* USAGE - Example Account Trigger Handler
	public class AccountTriggerHandler extends AAkonsultTriggerHandler {
	    
	    public AccountTriggerHandler() {
	    	if(AAkonsultTriggerHandler.isDisabled()) {
	    		AAkonsultTriggerHandler.bypass('AccountTriggerHandler');
	    	}
	    }
	    
	    public override void beforeDelete() {
	    	for(Account account : (List<Account>) Trigger.old) {
	    		stopIndividualAccountDeletion(account);
	    	}
	    }

	    public void stopIndividualAccountDeletion(Account account) {
	    	if(account.Name == 'Individual') {
	    		account.addError('You can\'t delete the Individual account');
	    	}
	    }
	}
*/	

public virtual class AAkonsultTriggerHandler {

	// static map of handlername, times run() was invoked
	private static Map<String, LoopCount> loopCountMap;
	private static Set<String> bypassedHandlers;

	// the current context of the trigger, overridable in tests
	@TestVisible
	private TriggerContext context;

	// the current context of the trigger, overridable in tests
	@TestVisible
	private Boolean isTriggerExecuting;

	// static initialization
	static {
		loopCountMap = new Map<String, LoopCount>();
		bypassedHandlers = new Set<String>();
	}

	private static Boolean triggerDisabled = false;

	// constructor
	public AAkonsultTriggerHandler() {
		this.setTriggerContext();
	}

	/***************************************
	* public instance methods
	***************************************/

	// main method that will be called during execution
  	public void run() {

    	if(!validateRun()) return;

    	addToLoopCount();
    	// dispatch to the correct handler method
    	if(this.context == TriggerContext.BEFORE_INSERT) {
      		this.beforeInsert();
    	} else if(this.context == TriggerContext.BEFORE_UPDATE) {
      		this.beforeUpdate();
    	} else if(this.context == TriggerContext.BEFORE_DELETE) {
      		this.beforeDelete();
    	} else if(this.context == TriggerContext.AFTER_INSERT) {
      		this.afterInsert();
    	} else if(this.context == TriggerContext.AFTER_UPDATE) {
      		this.afterUpdate();
    	} else if(this.context == TriggerContext.AFTER_DELETE) {
      		this.afterDelete();
    	} else if(this.context == TriggerContext.AFTER_UNDELETE) {
      		this.afterUndelete();
    	}
  	}

  	public void setMaxLoopCount(Integer max) {
    	String handlerName = getHandlerName();
    	if(!AAkonsultTriggerHandler.loopCountMap.containsKey(handlerName)) {
      		AAkonsultTriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
    	} else {
      		AAkonsultTriggerHandler.loopCountMap.get(handlerName).setMax(max);
    	}
  	}

  	public void clearMaxLoopCount() {
    	this.setMaxLoopCount(-1);
  	}

  	/***************************************
   	* public static methods
   	***************************************/

  	public static void bypass(String handlerName) {
    	AAkonsultTriggerHandler.bypassedHandlers.add(handlerName);
  	}

  	public static void clearBypass(String handlerName) {
    	AAkonsultTriggerHandler.bypassedHandlers.remove(handlerName);
  	}

  	public static Boolean isBypassed(String handlerName) {
    	return AAkonsultTriggerHandler.bypassedHandlers.contains(handlerName);
  	}

  	public static void clearAllBypasses() {
    	AAkonsultTriggerHandler.bypassedHandlers.clear();
  	}
  	public static Boolean isThisDisabled(string handlerName) {
  		return AAkonsultUtil.allTriggersDisabled(handlerName);
  	}
	  
  	public static Boolean isDisabled() {
  		return AAkonsultUtil.allTriggersDisabled('Default Settings');
  	}

  	/***************************************
   	* private instancemethods
   	***************************************/

  	@TestVisible
  	private void setTriggerContext() {
    	this.setTriggerContext(null, false);
  	}

  	@TestVisible
  	private void setTriggerContext(String ctx, Boolean testMode) {
    	if(!Trigger.isExecuting && !testMode) {
      		this.isTriggerExecuting = false;
      		return;
    	} else {
      		this.isTriggerExecuting = true;
    	}
    
    	if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) || (ctx != null && ctx == 'before insert')) {
      		this.context = TriggerContext.BEFORE_INSERT;
    	} else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) || (ctx != null && ctx == 'before update')){
      		this.context = TriggerContext.BEFORE_UPDATE;
    	} else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) || (ctx != null && ctx == 'before delete')) {
      		this.context = TriggerContext.BEFORE_DELETE;
    	} else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) || (ctx != null && ctx == 'after insert')) {
      		this.context = TriggerContext.AFTER_INSERT;
    	} else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) || (ctx != null && ctx == 'after update')) {
      		this.context = TriggerContext.AFTER_UPDATE;
    	} else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) || (ctx != null && ctx == 'after delete')) {
      		this.context = TriggerContext.AFTER_DELETE;
    	} else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) || (ctx != null && ctx == 'after undelete')) {
      		this.context = TriggerContext.AFTER_UNDELETE;
    	}
  	}

  	// increment the loop count
  	@TestVisible
  	private void addToLoopCount() {
    	String handlerName = getHandlerName();
    	if(AAkonsultTriggerHandler.loopCountMap.containsKey(handlerName)) {
      		Boolean exceeded = AAkonsultTriggerHandler.loopCountMap.get(handlerName).increment();
      		if(exceeded) {
        		Integer max = AAkonsultTriggerHandler.loopCountMap.get(handlerName).max;
        		throw new AAkonsultTriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
      		}
    	}
  	}

  	// make sure this trigger should continue to run
  	@TestVisible
  	private Boolean validateRun() {
    	if(!this.isTriggerExecuting || this.context == null) {
      		throw new AAkonsultTriggerHandlerException('Trigger handler called outside of Trigger execution');
    	}
    	if(AAkonsultTriggerHandler.bypassedHandlers.contains(getHandlerName())) {
      		return false;
    	}
    	return true;
  	}

  	@TestVisible
  	private String getHandlerName() {
    	return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
  	}

  	/***************************************
   	* context methods
   	***************************************/

  	// context-specific methods for override
	@TestVisible
	protected virtual void beforeInsert(){}
	@TestVisible
	protected virtual void beforeUpdate(){}
	@TestVisible
	protected virtual void beforeDelete(){}
	@TestVisible
	protected virtual void afterInsert(){}
	@TestVisible
	protected virtual void afterUpdate(){}
	@TestVisible
	protected virtual void afterDelete(){}
	@TestVisible
	protected virtual void afterUndelete(){}

  	/***************************************
   	* inner classes
   	***************************************/

  	// inner class for managing the loop count per handler
  	@TestVisible
  	private class LoopCount {
    	private Integer max;
    	private Integer count;

    	public LoopCount() {
      		this.max = 5;
      		this.count = 0;
    	}

    	public LoopCount(Integer max) {
      		this.max = max;
      		this.count = 0;
    	}

    	public Boolean increment() {
      		this.count++;
      		return this.exceeded();
    	}

    	public Boolean exceeded() {
      		if(this.max < 0) return false;
      		if(this.count > this.max) {
        		return true;
      		}
      		return false;
    	}

    	public Integer getMax() {
      		return this.max;
    	}

    	public Integer getCount() {
      		return this.count;
    	}

    	public void setMax(Integer max) {
      		this.max = max;
    	}
  	}

  	// possible trigger contexts
  	@TestVisible
  	private enum TriggerContext {
    	BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
    	AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
    	AFTER_UNDELETE
  	}

  	// exception class
  	public class AAkonsultTriggerHandlerException extends Exception {}
}