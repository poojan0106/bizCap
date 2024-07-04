/*
Created By : Foram Rana
Created date : 2/11/2020
Des :  Test Class for LeadTriggerHandler
*/

@isTest
public class LeadTriggerHandlerTest {
    
    
    static testMethod void insertLead() {  
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User(Alias = 'standt', Email='dhairya@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='dhairya@testorg.com');
        System.runAs(u)
        {
            List<Lead> lstlead = new List<Lead>();
            Map<Id, Lead> leadMap = new Map<Id, Lead>();
            String currentUserId = UserInfo.getUserId();
            
            system.debug('u:::'+u.id);
            Lead objlead = new Lead();
            objlead.LastName = 'Test';
            objlead.Company = 'Test';
            objlead.Status = 'New';
            objlead.Lead_Sub_Status__c = 'Received';
            objlead.LeadSource = 'Ebroker';
            objLead.OwnerId = u.id;
            insert objlead;  
            
            LeadTriggerHandler.isFirstTimeBeforeUpdate = true;
            LeadTriggerHandler.isFirstTimeUpdate = true;
            
            lstlead.add(objlead);
            leadMap.put(objlead.id, objlead);
            //LeadTriggerHandler.updateBPURecords(lstlead);
            LeadTriggerHandler.updateBPURecords(lstlead, leadMap);
            //LeadTriggerHandler.afterConvertLeadPushEmailCmpOnBpu(lstlead);
            
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(objlead.Id);
            lc.ownerid = objLead.OwnerId;
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);     
            
            Lead objlead1= new Lead();
            objlead1.LastName = 'Test';
            objlead1.Company = 'Test';
            objlead1.Status = 'New';
            objlead1.Lead_Sub_Status__c = 'Received';
            objlead1.LeadSource = 'Ebroker';
            objLead1.OwnerId = currentUserId;
            objlead1.LastName = 'Test123';
            insert objLead1;
            
            objLead1.Status = 'Contacted';
            update objLead1;
            
            delete objLead1;
            
            
        }        
    }
}