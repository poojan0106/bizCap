/*
Created By : Princee
Created date : 26/10/2020
Des :  Test Class for LeadTriggerFor Round robin logic
*/

@isTest
public class LeadTriggerForRoundRobinTest {
    
    static testMethod void insertLead() {  
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        
        User u3 = new User(Alias = 'standt', Email='dhairya@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='dhairya1456@testorg.com');
        insert u3;
        
        TriggerSwitch__c tgs = new TriggerSwitch__c();
        tgs.IsActive__c = true;
        tgs.Name = 'Trigger_Lead';
        insert tgs;
        
        TriggerSwitch__c tgs1 = new TriggerSwitch__c();
        tgs1.IsActive__c = true;
        tgs1.Name = 'Trigger_CustomSharingCriteria';
        insert tgs1;
			
			group intialgroup = new group(Name='leadShareGroup', DeveloperName='LeadGroup');
            insert intialgroup;
            
            list<Custom_Sharing_Criteria__c> cscList = new List<Custom_Sharing_Criteria__c>();
            
            Custom_Sharing_Criteria__c c1 = new Custom_Sharing_Criteria__c();
            c1.Lead_Source__c = '1st Street';
            c1.Source__c = 'Lead';
            c1.User_Group_ID__c = intialgroup.Id; 
            cscList.add(c1);
            
            Custom_Sharing_Criteria__c c2 = new Custom_Sharing_Criteria__c();
            c2.Lead_Source__c = '20/20 Finance Brokers';
            c2.User_Group_ID__c = intialgroup.Id; 
            c2.Source__c = 'Lead';
            cscList.add(c2);
            insert cscList;
            
            User u = new User(Alias = 'standt', Email='dhairya@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='dhairya123@testorg.com');
            insert u;
            User u2 = new User(Alias = 'standt', Email='princee@resonantcloud.info', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='princeesoni6173@abcd.com');
            insert u2;
            
            List<Lead> lstlead = new List<Lead>();
            set<Lead> setLead = new set<Lead>();
            Map<Id, Lead> leadMap = new Map<Id, Lead>();
            String currentUserId = UserInfo.getUserId();
            
            Id RecordTypeIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Online').getRecordTypeId();
            //List<RecordType> RT= [select id from RecordType where name = 'Aggregator'];
            system.debug('u:::'+u.id);
            Lead objlead = new Lead();
            objlead.LastName = 'Test';
            objlead.Company = 'Test';
            objlead.RecordTypeId =RecordTypeIdLead;
            objlead.Status = 'New';
            //objlead.Lead_Sub_Status__c = 'Received';
            objlead.LeadSource = '1st Street';
            objlead.OwnerId = u.id;
            insert objlead;
            
            Lead_Round_Robin_Assignment__c lr  = new Lead_Round_Robin_Assignment__c ();
            lr.Next_RR_User__c= u2.id;
            lr.Last_RR_Lead_Receiver__c = true;
            lr.Round_Robin_User__c = u.id;
            //lr.Next_RR_User_ID__c = u2.id;
            //lr.Round_Robin_User_ID__c =  u.id;
            insert lr;
            system.debug('lr :' + lr.Next_RR_User_ID__c);
            Lead_Round_Robin_Assignment__c lr2  = new Lead_Round_Robin_Assignment__c ();
            lr2.Next_RR_User__c = u.id;
            lr2.Last_RR_Lead_Receiver__c = false;
            lr2.Round_Robin_User__c = u2.id;
            //lr.Next_RR_User_ID__c = u.id;
            //lr.Round_Robin_User_ID__c =  u2.id;
            insert lr2;
            system.debug('u2 :' + u2.id);
            system.debug('lr2 :' + lr2.Next_RR_User_ID__c);
            
            QueueSobject lstQueue = [select id,Queue.name,Queue.id from QueueSobject where Queue.name = :Label.Round_Robin LIMIT 1];
            
            objlead.OwnerId = lstQueue.Queue.id;
            update objlead;
            
            //LeadTriggerHandler.isFirstTimeBeforeUpdate = true;
            //LeadTriggerHandler.isFirstTimeUpdate = true;
            
            lstlead.add(objlead);
            setLead.add(objlead);
            leadMap.put(objlead.id, objlead);
            
            //LeadHandlerForRoundRobin.isFirstTime = true;
            //LeadHandlerForRoundRobin.isFirstTimeafterUpdate =true;
            //LeadHandlerForRoundRobin.isFirstTimeBeforeUpdate = true;
            //LeadHandlerForRoundRobin.updateObjectData(lstlead);
            //LeadHandlerForRoundRobin.updateObjectData(lstLead);
            LeadHandlerForRoundRobin.sendEmailNotification(setLead);
            LeadHandlerBatchForRoundRobin lrr = new LeadHandlerBatchForRoundRobin(lstlead);
            
            
            /*Database.LeadConvert lc = new database.LeadConvert();
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

delete objLead1;*/
                
    }
    static testMethod void insertLead1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u3 = new User(Alias = 'standt', Email='dhairya@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='dhairya1456@testorg.com');
        insert u3;
        
        
        System.runAs(u3)
        {
            
            TriggerSwitch__c tgs = new TriggerSwitch__c();
            tgs.IsActive__c = true;
            tgs.Name = 'Trigger_Lead';
            insert tgs;
            
            TriggerSwitch__c tgs1 = new TriggerSwitch__c();
            tgs1.IsActive__c = true;
            tgs1.Name = 'Trigger_CustomSharingCriteria';
            insert tgs1;
            
            list<Custom_Sharing_Criteria__c> cscList = new List<Custom_Sharing_Criteria__c>();
            
            User u = new User(Alias = 'standt', Email='dhairya@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='dhairya123@testorg.com');
            insert u;
            User u2 = new User(Alias = 'standt', Email='princee@resonantcloud.info', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='princeesoni6173@abcd.com');
            insert u2;
            
            group intialgroup = new group(Name='leadShareGroup', DeveloperName='LeadGroup');
            insert intialgroup;
            
            Custom_Sharing_Criteria__c c1 = new Custom_Sharing_Criteria__c();
            c1.Lead_Source__c = '1st Street';
            c1.Source__c = 'Lead';
            c1.User_Group_ID__c = intialgroup.Id; 
            cscList.add(c1);
            
            Custom_Sharing_Criteria__c c2 = new Custom_Sharing_Criteria__c();
            c2.Lead_Source__c = '20/20 Finance Brokers';
            c2.User_Group_ID__c = intialgroup.Id; 
            c2.Source__c = 'Lead';
            cscList.add(c2);
            insert cscList;
            system.debug('---cscList---'+cscList);
            
            Id RecordTypeIdLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Online').getRecordTypeId();
            
            Lead objlead1 = new Lead();
            objlead1.LastName = 'Test1';
            objlead1.Company = 'Test';
            objlead1.RecordTypeId =RecordTypeIdLead;
            objlead1.Status = 'New';
            objlead1.LeadSource = '20/20 Finance Brokers';
            objlead1.OwnerId = u.id;
            insert objlead1;
            
            
            lead updateLead = new Lead(Id = objLead1.Id,LeadSource = '1st Street');
            update updateLead;
        }
    }
}