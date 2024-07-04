/*
Created By : Yogesh Baldaniya
Created date : 2/28/2020
Des :  Test Class for OpportunityTriggerHandler
Updated By : Nrupa Vora
Date : 12/10/2020
*/
@isTest
public class OpportunityTriggerHandlerTest {
    static testMethod void insertOpp()
    {
        Account acc = new account();
        acc.name='Yogesh';
        acc.Is_Converted__c = true; 
        insert acc; //insert record in Account  
        
        opportunity oppObj = new opportunity();
        oppObj.AccountId = acc.id; // assign above account id
        oppObj.Name = 'Test 28-10';
        oppObj.StageName = 'In progress';
        oppObj.CloseDate = System.today();
        oppObj.Bizcap_Lead_Ref__c = 'SFID001544';
        oppObj.Is_Converted__c = false;
        Insert oppObj;  // insert opportunity record   
        
        OpportunityTriggerHandler.isFirstTimeInsert = true;
        OpportunityTriggerHandler.isFirstTimeUpdate = true;
        oppObj.Name = 'Test 29-10';
        update oppObj;
        
        delete oppObj;
        
    }
    
   /* static testMethod void insertOpp2()
    {
        LIST<Opportunity> oppList = new LIST<Opportunity>(); // create list for opportunity
        
        opportunity oppObj = new opportunity();
        oppObj.Name = 'Test 28-9';
        oppObj.StageName = 'In progress';
        oppObj.CloseDate = System.today();
        Insert oppObj;  // insert opportunity record 
        
        BPU__c objBPU = new BPU__c();
        objBPU.Opportunity__c = oppObj.Id; // assign above account id
        objBPU.Stage__c = oppObj.StageName;
        insert objBPU; //  insert bpu record Related to opportunity 
        
        oppList.add(oppObj);
        
        for(opportunity opp : oppList)
        {
            opp.sub_stage__c = 'Contract sent to client';
        }
        System.debug(' $$$ oppList :'+oppList);
        
        if(oppList.size()>0 && oppList != null)
        {
            Update oppList;  //update opportunity record          
        }
        OpportunityTriggerHandler.isFirstTimeInsert = true;// set isFirstTimeInsert variable value is true in TriggerOpportunity
    }*/
}