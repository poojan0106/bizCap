/*
 * Created by: Dhairya Shah
 * Date: 12th june 2020
 * Desc: Creating task
 */ 
trigger OpportunityTask on Opportunity (after insert) {
    
    if(trigger.isAfter && trigger.Isinsert)
    {
        for(Opportunity objOps : TRIGGER.NEW)
        {
            if(objOps.StageName == 'In progress' && objOps.Sub_stage__c == 'Contract requested' 
               && objOps.Is_Converted__c == false && objOps.Task_contract_send_sent_for_mo__c == false && CreateTaskForOpportunity.isCreateTask == true)
            {
                Boolean triggervalue = false;
                system.debug('calling from Opportunity'+triggervalue+' '+objOps.id);
                CreateTaskForOpportunity.isCreateTask = false;
                CreateTaskForOpportunity.createTask(objOps.id, triggervalue);
            }
        }
        //
    }

}