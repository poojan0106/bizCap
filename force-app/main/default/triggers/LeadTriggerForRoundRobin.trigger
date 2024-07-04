/*
Created By: Princee Soni
Created Date : 15/10/2020
Purpose: Round Robin Assigment Logic
*/
trigger LeadTriggerForRoundRobin on Lead (before insert,before update,after update) {
    Public set<Lead> myLeadForEmail = new set<Lead>();
    if(System.label.TriggerRoundRobin == 'Active')
    {
        system.debug('LeadTriggerForRoundRobin :' + TRIGGER.NEW);
        if(Trigger.isUpdate && Trigger.IsBefore)
        {
            QueueSobject lstQueue = [select id,Queue.name,Queue.id from QueueSobject where Queue.name = :Label.Round_Robin LIMIT 1];
            system.debug('lstQueue : ' + lstQueue.Queue.Name);
            List<Lead> lstLead = new List<Lead>();
            for (Lead lead: Trigger.new) 
            {
                //Here we use the account id, to get the older version of record.
                Lead oldLead = Trigger.oldMap.get(lead.ID);
                System.debug('Trigger.oldMap.get(lead.ID)  N:::'+Trigger.oldMap.get(lead.ID));
                System.debug('lead.ownerId  N:::'+lead.ownerId);
                System.debug('oldLead.ownerId  N:::'+oldLead.ownerId);
                System.debug('lstQueue.Queue.id  N:::'+lstQueue.Queue.id);
                //once we get the older version, we can get any field's value from older version to compare.
                if(lead.ownerId != oldLead.ownerId && lead.ownerId == lstQueue.Queue.id)
                {
                    System.debug('--*Lead owner is changed*--');
                    System.debug('**Old Lead owner :'+oldLead.ownerId);
                    System.debug('**New Lead owner :'+lead.ownerId);
                    lstLead.add(lead);
                }
            }
            system.debug('LeadHandlerForRoundRobin.isFirstTimeBeforeUpdate : ' + LeadHandlerForRoundRobin.isFirstTimeBeforeUpdate);
            if(!lstLead.isEmpty() && lstLead.size()>0 && LeadHandlerForRoundRobin.isFirstTimeBeforeUpdate == true && LeadHandlerForRoundRobin.isFirstTime == true)
            {
                If(!checkRecursion.hasAlreadyRun())
                {
                    system.debug('Princee in before update');
                    LeadHandlerForRoundRobin.isFirstTimeBeforeUpdate = false;
                    //LeadHandlerForRoundRobin.MarkFirsttimeFlowAsTrue(lstLead);
                    //myLeadForEmail = LeadHandlerForRoundRobin.updateObjectData(lstLead);  
                    database.executebatch(new LeadHandlerBatchForRoundRobin(lstLead),1);
                }
                checkRecursion.setAlredyRun();
            }    
        }
    }
}