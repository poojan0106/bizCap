trigger TriggerLeadSourceAssignment on Lead_Source_Assignment__c (after insert) 
{

	TriggerSwitch__c checkForStatus = [select IsActive__c from TriggerSwitch__c
                                       where Name= 'TriggerLeadSourceAssignment'];
        
    if(checkForStatus.IsActive__c)
    {    
    if(trigger.isafter && trigger.isinsert)
    {
        List<Lead_Source_Assignment__c> lstLeadsrc=new list<Lead_Source_Assignment__c>();
        for(Lead_Source_Assignment__c lsa:trigger.new)
        {
            lstLeadsrc.add(lsa);
        }
        
        if(!lstLeadsrc.isEmpty() && lstLeadsrc.size() > 0)
        {
            HelperLeadSourceAssignment.CustomSharingCreation(lstLeadsrc);
        }
    }
    }
}