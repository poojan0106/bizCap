/*
Created by : Nrupa vora
Date 20-11-2020
Purpose: Round Robin Assigment Logic ffrom TriggerClass to BatchClass
*/
global class LeadHandlerBatchForRoundRobin implements Database.Batchable<sObject>,Database.Stateful
{
    global List<sObject> LeadList;
    global list<Lead> lstRRLeadToUpdate = new list<Lead>(); 
    global set<Lead> Leadmailsend = new set<lead>();
    global LeadHandlerBatchForRoundRobin(List<Lead> SentLeads)
    {
        if(SentLeads != null && SentLeads.size()>0)
        {
            LeadList = SentLeads;
        }
    }
    
    //Initial stage
    //global Database.QueryLocator start(Database.BatchableContext BC)
    //return Database.getQueryLocator([SELECT id,firstname,email from contact where id in:LeadList]);
    
    global List<Lead> start(Database.BatchableContext BC)
    {
        return LeadList;
    }
    
    //Main functionality
    global void execute(Database.BatchableContext BC, List<lead> scope) {     
        //Call class method
        set<Lead> leadset =new set<Lead>();
        leadset = LeadHandlerForRoundRobin.updateObjectData(scope);
        if(leadset != null && leadset.size()>0)
        {
            lstRRLeadToUpdate.addAll(leadset);
            Leadmailsend.addAll(leadset);
            System.debug('leadset Added'+leadset);
        }
    }
    
    //Final Action
    global void finish(Database.BatchableContext BC)
    {
        System.debug('lstRRLeadToUpdate sizeeee N:::'+lstRRLeadToUpdate.size());
        if(lstRRLeadToUpdate != null && lstRRLeadToUpdate.size()>0)
        {
            System.debug('final lstRRLeadToUpdate N:::'+lstRRLeadToUpdate[0].OwnerId);
            update lstRRLeadToUpdate;
        }
        if(Leadmailsend != null && Leadmailsend.size()>0)
        {
            LeadHandlerForRoundRobin.sendEmailNotification(Leadmailsend);
        }
    }
}