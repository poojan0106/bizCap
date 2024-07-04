/*
Updated By : Nrupa Vora
Date : 12/10/2020
*/
trigger OpportunityTrigger on Opportunity (after insert , after update, before delete) {
    
    system.debug('$$$ call Opp Trigger :');
    if(Trigger.isAfter && Trigger.isInsert)
    {
        if(OpportunityTriggerHandler.isFirstTimeInsert == true)
        {
            system.debug('$$$ List is not null :');
            //OpportunityTriggerHandler.isFirstTimeInsert = false;
            OpportunityTriggerHandler.updateopps(TRIGGER.NEW);
            OpportunityTriggerHandler.UpdateSFID(TRIGGER.NEW);
            //OpportunityTriggerHandler.updateBPU(TRIGGER.NEW);
        }
    }
    
    //IS AFTER update
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        if(OpportunityTriggerHandler.isFirstTimeUpdate == true)
        {
            OpportunityTriggerHandler.isFirstTimeUpdate = false;
            //OpportunityTriggerHandler.UpdateSFID(trigger.new);
            OpportunityTriggerHandler.updateBPU(trigger.new);
            for(Opportunity objOps : TRIGGER.NEW)
            {
                CreateTaskForOpportunity.createTask(objOps.ID, true);
            }
            
        }
    }
    
    //CALLING METHOD ON BEFORE DELETE
    if(Trigger.isBefore && Trigger.isDelete)
    {
        System.debug('--Delete-' +Trigger.old);
        OpportunityTriggerHandler.deleteBPU(Trigger.old);
    }
}