global with sharing class FormStackLeadProcessor  Implements Schedulable, Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts, Database.RaisesPlatformEvents {

    private static FINAL integer batchFequency = 600;
    public static FINAL integer MAX_PER_BATCH = 50;
    public static final String CRON_NAME = 'FormStackLeadProcessor';
            
    // Thanks to https://bitplex.me/2010/05/scheduling-apex-jobs-every-10-minutes.html for inspiration
     global void Execute(SchedulableContext SC){
                                     
        //Build the system time of now + batchFequency seconds to schedule the batch apex.
        String chron_exp = cron_exp();

        FormStackLeadProcessor batchProcess = new FormStackLeadProcessor();
        string cronId;
        try {
            cronId = System.schedule('FormStackLeadProcessor' + system.now().getTime(),chron_exp, batchProcess);               
        } catch (Exception e) {
            AAkonsultUtil.errorLog('System.schedule','System.schedule(FormStackLeadProcessor' + system.now().getTime()+chron_exp+', batchProcess)',e.getMessage() );            
        }

        // Delete/ Abort the Schedule as this is scheduled by the previous Batch on its finish
        Id cronTrigId = sc.getTriggerId();
        
        try {
            System.abortJob(cronTrigId);
        } catch (Exception e) {
            AAkonsultUtil.errorLog('System.abortJob','System.abortJob('+cronTrigId+')',e.getMessage() );            
        }

        FormStackLeadProcessor BatchProcessor = new FormStackLeadProcessor();
        BatchProcessor.query=queryDetail();
        ID batchprocessid;
        
        if (AAkonsultUtil.checkBatchProcessorRunning('FormStackLeadProcessor') < 2) {  // just in case held up
            try { 
                batchprocessid = Database.executeBatch(BatchProcessor,(MAX_PER_BATCH) );
            } catch (Exception e) {
                AAkonsultUtil.errorLog('FormStackLeadProcessor.schedule','submit batch',e.getMessage());                  
            }
        }
  
     }     

    public static string cron_exp() { 
        //Build the system time of now + batchFequency seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(batchFequency);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        return chron_exp;
    }   

    global String query;

    // This batch routine is required as triggers may not be able to update all records, due to salesforce limits.  This acts as a daily cleanup.
    // http://www.salesforce.com/us/developer/docs/apexcode/index_Left.htm#CSHID=apex_batch_interface.htm|StartTopic=Content%2Fapex_batch_interface.htm|SkinName=webhelp

    global database.querylocator start(Database.BatchableContext BC){
 
        return Database.getQueryLocator(queryDetail());
    }
    
    public string queryDetail() {
         
        string thisQuery=query;
        if (thisQuery == null || thisQuery == '') {
            thisQuery='Select Id,Form_Update_URL__c from Lead where Form_Update_URL__c = null and CreatedDate = LAST_N_DAYS:5';
        }
        
        return thisQuery;
    }   
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
 
	  	URLUpdate(scope);

    }
    
    global void finish(Database.BatchableContext BC){               
        
    }
    
    public void URLUpdate(List<Lead> leadList){

        list<string> ids = new list<string>();
        for ( Lead l  : leadList) { 
            ids.add(l.id); 
        } 
        if (!system.test.IsRunningTest() ) {
            try {
                VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'Lead' ,  'Form_Update_URL__c' ,  'a0o6F00000lK8RxQAK' ,  ids,null );  
            } catch (Exception e) {
                AAkonsultUtil.errorLog('FormStackLeadProcessor.schedule','submit batch',e.getMessage());                  
            }
        }

    }    
}