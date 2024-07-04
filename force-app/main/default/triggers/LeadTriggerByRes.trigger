/*
* Created by: Yogesh
* Desc: to create BPU records from lead records
* Updated on" 20/02/2020
* LastModifyBy :- Ranjeet Kadam on 24 August 2020
*/ 
trigger LeadTriggerByRes on Lead (after insert, after Update, before Update, before delete) {
    
    if(System.label.TriggerActive == 'Active')
    {
        //CALLING METHOD ON AFTER INSERT
        if(Trigger.isAfter && Trigger.isInsert)
        {
            LeadTriggerHandler.insertBPU(TRIGGER.NEW);
        }
        
        //CALLING METHOD ON AFTER UPDATE
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            LIST<Lead> ListOfNotConvertedLeads = new List<Lead>();
            Map<Id, Lead> leadMap = new Map<Id, Lead>();
            for(Lead objLead : TRIGGER.NEW) 
            {
                if(objLead.isConverted == FALSE) 
                {
                    ListOfNotConvertedLeads.add(objLead);
                    leadMap.put(objLead.id, objLead);
                }
            }
            
            if(ListOfNotConvertedLeads != NULL && ListOfNotConvertedLeads.SIZE() > 0 && LeadTriggerHandler.isFirstTimeUpdate == TRUE)
            {
                LeadTriggerHandler.isFirstTimeUpdate = FALSE;
                LeadTriggerHandler.updateBPURecords(ListOfNotConvertedLeads, leadMap);
                //leadTriggerHandler.insertBPU(ListOfNotConvertedLeads);
            }
        }
        
        
        //CALLING METHOD ON BEFORE DELETE
        if(Trigger.isBefore && Trigger.isDelete)
        {
            System.debug('--Delete-' +Trigger.old);
            LeadTriggerHandler.deleteBPU(Trigger.old);
        }
        
        //CALLING METHOD ON BEFORE UPDATE
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            List<Lead> ConvertedLeadRec = new List<Lead>();
            List<Id> convertedOppIds = new List<Id>();
            List<Id> convertedAccIds = new List<id>();
            List<Id> convertedConIds = new List<id>();
            String LeadEmail;
            String LeadCompany;
            String LeadReference;
            
            for(Lead objLeads : TRIGGER.NEW)
            {
                if(objLeads.IsConverted == TRUE && objLeads.ConvertedAccountId != NULL 
                   && objLeads.ConvertedContactId != NULL && objLeads.ConvertedOpportunityId != NULL)
                {
                    ConvertedLeadRec.add(objLeads);   
                    convertedAccIds.add(objLeads.ConvertedAccountId);
                    convertedConIds.add(objleads.ConvertedContactId);
                    convertedOppIds.add(objLeads.ConvertedOpportunityId);
                    if(CreateTaskForOpportunity.isCreateTask == true)
                    {
                        Boolean triggervalue = true;
                        system.debug('calling from lead'+objLeads.ConvertedOpportunityId+' '+triggervalue);
                        CreateTaskForOpportunity.isCreateTask = false;
                        CreateTaskForOpportunity.createTask(objLeads.ConvertedOpportunityId, triggervalue);
                    }
                    LeadEmail = objLeads.Email;
                    LeadCompany = objLeads.Company;
                    LeadReference = objLeads.Bizcap_Lead_Ref__c;
                }
                /*else
                {
                LeadTriggerHandler.updateBPURecords(TRIGGER.NEW);
                system.debug('objLeads> before update>>'+objLeads.Lead_Sub_Status__c);
                }*/
            }
            
            if(ConvertedLeadRec != NULL && ConvertedLeadRec.SIZE() > 0 
               && convertedAccIds != NULL && convertedAccIds.SIZE() > 0 
               && convertedConIds != NULL && convertedConIds.SIZE() > 0 
               && convertedOppIds != NULL && convertedOppIds.SIZE() > 0 && LeadTriggerHandler.isFirstTimeBeforeUpdate == TRUE)
            {
                SYSTEM.debug('INSIDE BEOFRE UPDATE:::');
                LeadTriggerHandler.isFirstTimeBeforeUpdate = FALSE;
                LeadTriggerHandler.populateOppOnContacts(ConvertedLeadRec, convertedAccIds, convertedConIds, convertedOppIds, LeadEmail, LeadCompany, LeadReference);
            }
        }
    }
}