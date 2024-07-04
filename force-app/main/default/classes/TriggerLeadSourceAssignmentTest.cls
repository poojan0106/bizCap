/**
* Description		:	Test Class to cover TriggerLeadSourceAssignment, Trigger_CustomSharingCriteria,
						HelperLeadSourceAssignment, BatchCustomSharingCriteria, BatchCustomSharingForOpportunity, Trigger_Lead, Trigger_Opportunity, Persistence.
*
*	
* Author			: Lokesh Tewari
* Coverage			: above 80% for all the 8 classes
**/
@isTest
public class TriggerLeadSourceAssignmentTest 
{
    //private static final userRole testUserRole = [Select id,Name,DeveloperName from userRole where DeveloperName='Account_Managers'  limit 1];
    public static testMethod void testMethod1() 
    {
        TriggerSwitch__c tc1 = new TriggerSwitch__c();
        tc1.Name = 'TriggerLeadSourceAssignment';
        tc1.IsActive__c = True;
        insert tc1;
        
        TriggerSwitch__c tc2 = new TriggerSwitch__c();
        tc2.Name = 'Trigger_CustomSharingCriteria';
        tc2.IsActive__c = True;
        insert tc2;
        
        TriggerSwitch__c tc3 = new TriggerSwitch__c();
        tc3.Name = 'Trigger_Lead';
        tc3.IsActive__c = True;
        insert tc3;
        
        TriggerSwitch__c tc4 = new TriggerSwitch__c();
        tc4.Name = 'Trigger_Opportunity';
        tc4.IsActive__c = True;
        insert tc4;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'First',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;        
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u1;
        
        
        
        Lead_Source_Assignment__c lsa=new Lead_Source_Assignment__c();    
        lsa.Name='1st Street';
        lsa.Assign_Lead_to_Record_Owner__c=false;
        lsa.Lead_Source_Assignment__c=u.id;
        lsa.Country__c = 'Australia';
        insert lsa;
        
        
        List<Custom_Sharing_Criteria__c> lstCSC = new List<Custom_Sharing_Criteria__c>();
        
        Custom_Sharing_Criteria__c csc = new Custom_Sharing_Criteria__c();
        csc.Source__c='Lead';
        csc.User_Group_ID__c = u.id;
        csc.Lead_Source__c = '1st Street';
        //insert csc;
        lstCSC.add(csc);
        
                
        Custom_Sharing_Criteria__c csc1 = new Custom_Sharing_Criteria__c();
        csc1.Source__c='Lead';
        csc1.Lead_Source__c = '1st Street';
        csc1.User_Group_ID__c = u1.id;
        //insert csc1;
        lstCSC.add(csc1);
      
        
        Custom_Sharing_Criteria__c csc2 = new Custom_Sharing_Criteria__c();
        csc2.Source__c='Lead';
        csc2.Lead_Source__c = '1st Street';
        csc2.User_Group_ID__c = u1.id;
        //insert csc2;
        lstCSC.add(csc2);
        
          
        Custom_Sharing_Criteria__c csc3 = new Custom_Sharing_Criteria__c();
        csc3.Source__c='Lead';
        csc3.User_Group_ID__c = u.id;
        csc3.Lead_Source__c = '1st Street';
        //insert csc3;
        lstCSC.add(csc3);
        
        insert lstCSC;
        
        Lead ld=new lead();
        ld.LeadSource='1st Street';
        ld.LastName='Test 1';
        ld.company='RCS';
        insert ld;
    }
    
    public static testMethod void testMethod2() 
    {
        TriggerSwitch__c tc1 = new TriggerSwitch__c();
        tc1.Name = 'TriggerLeadSourceAssignment';
        tc1.IsActive__c = True;
        insert tc1;
        
        TriggerSwitch__c tc2 = new TriggerSwitch__c();
        tc2.Name = 'Trigger_CustomSharingCriteria';
        tc2.IsActive__c = True;
        insert tc2;
        
        TriggerSwitch__c tc3 = new TriggerSwitch__c();
        tc3.Name = 'Trigger_Lead';
        tc3.IsActive__c = True;
        insert tc3;
        
        TriggerSwitch__c tc4 = new TriggerSwitch__c();
        tc4.Name = 'Trigger_Opportunity';
        tc4.IsActive__c = True;
        insert tc4;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'First',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;        
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u1;
        
        
        
        Lead_Source_Assignment__c lsa=new Lead_Source_Assignment__c();    
        lsa.Name='1st Street';
        lsa.Assign_Lead_to_Record_Owner__c=false;
        lsa.Lead_Source_Assignment__c=u.id;
        lsa.Country__c = 'Australia';
        insert lsa;
                
        List<Custom_Sharing_Criteria__c> lstCSC = new List<Custom_Sharing_Criteria__c>();
        
        Custom_Sharing_Criteria__c csc = new Custom_Sharing_Criteria__c();
        csc.Source__c='Opportunity';
        csc.User_Group_ID__c = u.id;
        csc.Lead_Source__c = '1st Street';
        lstCSC.add(csc);
        
        Custom_Sharing_Criteria__c csc1 = new Custom_Sharing_Criteria__c();
        csc1.Source__c='Opportunity';
        csc1.Lead_Source__c = '1st Street';
        csc1.User_Group_ID__c = u1.id;
        lstCSC.add(csc1);
      
        
        Custom_Sharing_Criteria__c csc2 = new Custom_Sharing_Criteria__c();
        csc2.Source__c='Opportunity';
        csc2.Lead_Source__c = '1st Street';
        csc2.User_Group_ID__c = u1.id;
        lstCSC.add(csc2);
        
          
        Custom_Sharing_Criteria__c csc3 = new Custom_Sharing_Criteria__c();
        csc3.Source__c='Opportunity';
        csc3.User_Group_ID__c = u.id;
        csc3.Lead_Source__c = '1st Street';
        lstCSC.add(csc3);
        
        insert lstCSC;
        
        Opportunity ld=new Opportunity();
        ld.LeadSource='1st Street';
        ld.Name='Test 1';
        ld.StageName='In progress';
        ld.CloseDate = date.today();
        insert ld;
    }
    
    public static testMethod void testMethod3() 
    {
        
        TriggerSwitch__c tc1 = new TriggerSwitch__c();
        tc1.Name = 'TriggerLeadSourceAssignment';
        tc1.IsActive__c = True;
        insert tc1;
        
        TriggerSwitch__c tc2 = new TriggerSwitch__c();
        tc2.Name = 'Trigger_CustomSharingCriteria';
        tc2.IsActive__c = True;
        insert tc2;
        
        TriggerSwitch__c tc3 = new TriggerSwitch__c();
        tc3.Name = 'Trigger_Lead';
        tc3.IsActive__c = True;
        insert tc3;
        
        TriggerSwitch__c tc4 = new TriggerSwitch__c();
        tc4.Name = 'Trigger_Opportunity';
        tc4.IsActive__c = True;
        insert tc4;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'First',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;        
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u1;
        
        
        
        Lead_Source_Assignment__c lsa=new Lead_Source_Assignment__c();    
        lsa.Name='1st Street';
        lsa.Assign_Lead_to_Record_Owner__c=false;
        lsa.Lead_Source_Assignment__c=u.id;
        lsa.Country__c = 'Australia';
        insert lsa;
        
        
        List<Custom_Sharing_Criteria__c> lstCSC = new List<Custom_Sharing_Criteria__c>();
        List<Custom_Sharing_Criteria__c> lstCSC1 = new List<Custom_Sharing_Criteria__c>();

        
        Custom_Sharing_Criteria__c csc = new Custom_Sharing_Criteria__c();
        csc.Source__c='Lead';
        csc.User_Group_ID__c = u.id;
        csc.Lead_Source__c = '1st Street';
        //insert csc;
        lstCSC.add(csc);
        
                
        Custom_Sharing_Criteria__c csc1 = new Custom_Sharing_Criteria__c();
        csc1.Source__c='Lead';
        csc1.Lead_Source__c = '1st Street';
        csc1.User_Group_ID__c = u1.id;
        //insert csc1;
        lstCSC.add(csc1);
      
        
        Custom_Sharing_Criteria__c csc2 = new Custom_Sharing_Criteria__c();
        csc2.Source__c='Lead';
        csc2.Lead_Source__c = '1st Street';
        csc2.User_Group_ID__c = u1.id;
        //insert csc2;
        lstCSC.add(csc2);
        
          
        Custom_Sharing_Criteria__c csc3 = new Custom_Sharing_Criteria__c();
        csc3.Source__c='Lead';
        csc3.User_Group_ID__c = u.id;
        csc3.Lead_Source__c = '1st Street';
        //insert csc3;
        lstCSC.add(csc3);
        
        insert lstCSC;
        
        Custom_Sharing_Criteria__c csc4 = new Custom_Sharing_Criteria__c();
        csc4.Source__c='Lead';
        csc4.User_Group_ID__c = u.id;
        csc4.Lead_Source__c = '360 Capital Partners';
        //insert csc;
        lstCSC1.add(csc4);
        
                
        Custom_Sharing_Criteria__c csc5 = new Custom_Sharing_Criteria__c();
        csc5.Source__c='Lead';
        csc5.Lead_Source__c = '360 Capital Partners';
        csc5.User_Group_ID__c = u1.id;
        //insert csc1;
        lstCSC1.add(csc5);
      
        
        Custom_Sharing_Criteria__c csc6 = new Custom_Sharing_Criteria__c();
        csc6.Source__c='Lead';
        csc6.Lead_Source__c = '360 Capital Partners';
        csc6.User_Group_ID__c = u1.id;
        //insert csc2;
        lstCSC1.add(csc6);
        
          
        Custom_Sharing_Criteria__c csc7 = new Custom_Sharing_Criteria__c();
        csc7.Source__c='Lead';
        csc7.User_Group_ID__c = u.id;
        csc7.Lead_Source__c = '360 Capital Partners';
        //insert csc3;
        lstCSC1.add(csc7);
        
        insert lstCSC1;
        
        
        Lead ld=new lead();
        ld.LeadSource='1st Street';
        ld.LastName='Test 1';
        ld.company='RCS';
        insert ld;
        
        ld.OwnerId = u.id;
        //ld.LeadSource='360 Capital Partners';
        update ld;
    }
    
        public static testMethod void testMethod4() 
    {
        TriggerSwitch__c tc1 = new TriggerSwitch__c();
        tc1.Name = 'TriggerLeadSourceAssignment';
        tc1.IsActive__c = True;
        insert tc1;
        
        TriggerSwitch__c tc2 = new TriggerSwitch__c();
        tc2.Name = 'Trigger_CustomSharingCriteria';
        tc2.IsActive__c = True;
        insert tc2;
        
        TriggerSwitch__c tc3 = new TriggerSwitch__c();
        tc3.Name = 'Trigger_Lead';
        tc3.IsActive__c = True;
        insert tc3;
        
        TriggerSwitch__c tc4 = new TriggerSwitch__c();
        tc4.Name = 'Trigger_Opportunity';
        tc4.IsActive__c = True;
        insert tc4;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'First',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;        
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u1;
        
              
                
        Lead_Source_Assignment__c lsa=new Lead_Source_Assignment__c();    
        lsa.Name='1st Street';
        lsa.Assign_Lead_to_Record_Owner__c=false;
        lsa.Lead_Source_Assignment__c=u.id;
        lsa.Country__c = 'Australia';
        insert lsa;
        
        List<Custom_Sharing_Criteria__c> lstCSC = new List<Custom_Sharing_Criteria__c>();
        List<Custom_Sharing_Criteria__c> lstCSC1 = new List<Custom_Sharing_Criteria__c>();
        
        Custom_Sharing_Criteria__c csc = new Custom_Sharing_Criteria__c();
        csc.Source__c='Opportunity';
        csc.User_Group_ID__c = u.id;
        csc.Lead_Source__c = '1st Street';
        lstCSC.add(csc);
        
        Custom_Sharing_Criteria__c csc1 = new Custom_Sharing_Criteria__c();
        csc1.Source__c='Opportunity';
        csc1.Lead_Source__c = '1st Street';
        csc1.User_Group_ID__c = u1.id;
        lstCSC.add(csc1);
      
        
        Custom_Sharing_Criteria__c csc2 = new Custom_Sharing_Criteria__c();
        csc2.Source__c='Opportunity';
        csc2.Lead_Source__c = '1st Street';
        csc2.User_Group_ID__c = u1.id;
        lstCSC.add(csc2);
        
          
        Custom_Sharing_Criteria__c csc3 = new Custom_Sharing_Criteria__c();
        csc3.Source__c='Opportunity';
        csc3.User_Group_ID__c = u.id;
        csc3.Lead_Source__c = '1st Street';
        lstCSC.add(csc3);
        
        insert lstCSC;
        
        Custom_Sharing_Criteria__c csc4 = new Custom_Sharing_Criteria__c();
        csc4.Source__c='Lead';
        csc4.User_Group_ID__c = u.id;
        csc4.Lead_Source__c = '360 Capital Partners';
        //insert csc;
        lstCSC1.add(csc4);
        
                
        Custom_Sharing_Criteria__c csc5 = new Custom_Sharing_Criteria__c();
        csc5.Source__c='Lead';
        csc5.Lead_Source__c = '360 Capital Partners';
        csc5.User_Group_ID__c = u1.id;
        //insert csc1;
        lstCSC1.add(csc5);
      
        
        Custom_Sharing_Criteria__c csc6 = new Custom_Sharing_Criteria__c();
        csc6.Source__c='Lead';
        csc6.Lead_Source__c = '360 Capital Partners';
        csc6.User_Group_ID__c = u1.id;
        //insert csc2;
        lstCSC1.add(csc6);
        
          
        Custom_Sharing_Criteria__c csc7 = new Custom_Sharing_Criteria__c();
        csc7.Source__c='Lead';
        csc7.User_Group_ID__c = u.id;
        csc7.Lead_Source__c = '360 Capital Partners';
        //insert csc3;
        lstCSC1.add(csc7);
        
        insert lstCSC1;
        
        Opportunity ld=new Opportunity();
        ld.LeadSource='1st Street';
        ld.Name='Test 1';
        ld.StageName='In progress';
        ld.CloseDate = date.today();
        insert ld;
        
        ld.OwnerId = u.id;
        //ld.LeadSource='360 Capital Partners';
        update ld;

    }
    public static testMethod void testMethod5() 
    {
        
        TriggerSwitch__c tc1 = new TriggerSwitch__c();
        tc1.Name = 'TriggerLeadSourceAssignment';
        tc1.IsActive__c = True;
        insert tc1;
        
        TriggerSwitch__c tc2 = new TriggerSwitch__c();
        tc2.Name = 'Trigger_CustomSharingCriteria';
        tc2.IsActive__c = True;
        insert tc2;
        
        TriggerSwitch__c tc3 = new TriggerSwitch__c();
        tc3.Name = 'Trigger_Lead';
        tc3.IsActive__c = True;
        insert tc3;
        
        TriggerSwitch__c tc4 = new TriggerSwitch__c();
        tc4.Name = 'Trigger_Opportunity';
        tc4.IsActive__c = True;
        insert tc4;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'First',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;        
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u1;
        
        
        
        Lead_Source_Assignment__c lsa=new Lead_Source_Assignment__c();    
        lsa.Name='1st Street';
        lsa.Assign_Lead_to_Record_Owner__c=false;
        lsa.Lead_Source_Assignment__c=u.id;
        lsa.Country__c = 'Australia';
        insert lsa;
        
        
        List<Custom_Sharing_Criteria__c> lstCSC = new List<Custom_Sharing_Criteria__c>();
        List<Custom_Sharing_Criteria__c> lstCSC1 = new List<Custom_Sharing_Criteria__c>();

        
        Custom_Sharing_Criteria__c csc = new Custom_Sharing_Criteria__c();
        csc.Source__c='Lead';
        csc.User_Group_ID__c = u.id;
        csc.Lead_Source__c = '1st Street';
        //insert csc;
        lstCSC.add(csc);
        
                
        Custom_Sharing_Criteria__c csc1 = new Custom_Sharing_Criteria__c();
        csc1.Source__c='Lead';
        csc1.Lead_Source__c = '1st Street';
        csc1.User_Group_ID__c = u1.id;
        //insert csc1;
        lstCSC.add(csc1);
      
        
        Custom_Sharing_Criteria__c csc2 = new Custom_Sharing_Criteria__c();
        csc2.Source__c='Lead';
        csc2.Lead_Source__c = '1st Street';
        csc2.User_Group_ID__c = u1.id;
        //insert csc2;
        lstCSC.add(csc2);
        
          
        Custom_Sharing_Criteria__c csc3 = new Custom_Sharing_Criteria__c();
        csc3.Source__c='Lead';
        csc3.User_Group_ID__c = u.id;
        csc3.Lead_Source__c = '1st Street';
        //insert csc3;
        lstCSC.add(csc3);
        
        insert lstCSC;
        
        Custom_Sharing_Criteria__c csc4 = new Custom_Sharing_Criteria__c();
        csc4.Source__c='Lead';
        csc4.User_Group_ID__c = u.id;
        csc4.Lead_Source__c = '360 Capital Partners';
        //insert csc;
        lstCSC1.add(csc4);
        
                
        Custom_Sharing_Criteria__c csc5 = new Custom_Sharing_Criteria__c();
        csc5.Source__c='Lead';
        csc5.Lead_Source__c = '360 Capital Partners';
        csc5.User_Group_ID__c = u1.id;
        //insert csc1;
        lstCSC1.add(csc5);
      
        
        Custom_Sharing_Criteria__c csc6 = new Custom_Sharing_Criteria__c();
        csc6.Source__c='Lead';
        csc6.Lead_Source__c = '360 Capital Partners';
        csc6.User_Group_ID__c = u1.id;
        //insert csc2;
        lstCSC1.add(csc6);
        
          
        Custom_Sharing_Criteria__c csc7 = new Custom_Sharing_Criteria__c();
        csc7.Source__c='Lead';
        csc7.User_Group_ID__c = u.id;
        csc7.Lead_Source__c = '360 Capital Partners';
        //insert csc3;
        lstCSC1.add(csc7);
        
        insert lstCSC1;
        
        
        Lead ld=new lead();
        ld.LeadSource='1st Street';
        ld.LastName='Test 1';
        ld.company='RCS';
        insert ld;
        
        //ld.OwnerId = u.id;
        //ld.LeadSource='360 Capital Partners';
        //update ld;
    }
    
        public static testMethod void testMethod6() 
    {
        TriggerSwitch__c tc1 = new TriggerSwitch__c();
        tc1.Name = 'TriggerLeadSourceAssignment';
        tc1.IsActive__c = True;
        insert tc1;
        
        TriggerSwitch__c tc2 = new TriggerSwitch__c();
        tc2.Name = 'Trigger_CustomSharingCriteria';
        tc2.IsActive__c = True;
        insert tc2;
        
        TriggerSwitch__c tc3 = new TriggerSwitch__c();
        tc3.Name = 'Trigger_Lead';
        tc3.IsActive__c = True;
        insert tc3;
        
        TriggerSwitch__c tc4 = new TriggerSwitch__c();
        tc4.Name = 'Trigger_Opportunity';
        tc4.IsActive__c = True;
        insert tc4;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'First',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;        
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u1;
        
              
                
        Lead_Source_Assignment__c lsa=new Lead_Source_Assignment__c();    
        lsa.Name='1st Street';
        lsa.Assign_Lead_to_Record_Owner__c=false;
        lsa.Lead_Source_Assignment__c=u.id;
        lsa.Country__c = 'Australia';
        insert lsa;
        
        List<Custom_Sharing_Criteria__c> lstCSC = new List<Custom_Sharing_Criteria__c>();
        List<Custom_Sharing_Criteria__c> lstCSC1 = new List<Custom_Sharing_Criteria__c>();
        
        Custom_Sharing_Criteria__c csc = new Custom_Sharing_Criteria__c();
        csc.Source__c='Opportunity';
        csc.User_Group_ID__c = u.id;
        csc.Lead_Source__c = '1st Street';
        lstCSC.add(csc);
        
        Custom_Sharing_Criteria__c csc1 = new Custom_Sharing_Criteria__c();
        csc1.Source__c='Opportunity';
        csc1.Lead_Source__c = '1st Street';
        csc1.User_Group_ID__c = u1.id;
        lstCSC.add(csc1);
      
        
        Custom_Sharing_Criteria__c csc2 = new Custom_Sharing_Criteria__c();
        csc2.Source__c='Opportunity';
        csc2.Lead_Source__c = '1st Street';
        csc2.User_Group_ID__c = u1.id;
        lstCSC.add(csc2);
        
          
        Custom_Sharing_Criteria__c csc3 = new Custom_Sharing_Criteria__c();
        csc3.Source__c='Opportunity';
        csc3.User_Group_ID__c = u.id;
        csc3.Lead_Source__c = '1st Street';
        lstCSC.add(csc3);
        
        insert lstCSC;
        
        Custom_Sharing_Criteria__c csc4 = new Custom_Sharing_Criteria__c();
        csc4.Source__c='Lead';
        csc4.User_Group_ID__c = u.id;
        csc4.Lead_Source__c = '360 Capital Partners';
        //insert csc;
        lstCSC1.add(csc4);
        
                
        Custom_Sharing_Criteria__c csc5 = new Custom_Sharing_Criteria__c();
        csc5.Source__c='Lead';
        csc5.Lead_Source__c = '360 Capital Partners';
        csc5.User_Group_ID__c = u1.id;
        //insert csc1;
        lstCSC1.add(csc5);
      
        
        Custom_Sharing_Criteria__c csc6 = new Custom_Sharing_Criteria__c();
        csc6.Source__c='Lead';
        csc6.Lead_Source__c = '360 Capital Partners';
        csc6.User_Group_ID__c = u1.id;
        //insert csc2;
        lstCSC1.add(csc6);
        
          
        Custom_Sharing_Criteria__c csc7 = new Custom_Sharing_Criteria__c();
        csc7.Source__c='Lead';
        csc7.User_Group_ID__c = u.id;
        csc7.Lead_Source__c = '360 Capital Partners';
        //insert csc3;
        lstCSC1.add(csc7);
        
        insert lstCSC1;
        
        Opportunity ld=new Opportunity();
        ld.LeadSource='1st Street';
        ld.Name='Test 1';
        ld.StageName='In progress';
        ld.CloseDate = date.today();
        insert ld;
        
        //ld.OwnerId = u.id;
        ld.LeadSource='360 Capital Partners';
        update ld;

    }
   
    private static testMethod void testMethod7() 
    {
         
			userRole testUserRole = [Select id,Name,DeveloperName from userRole where DeveloperName='Account_Managers'  limit 1];        
        	userRole testUserRole1 = [Select id,Name,DeveloperName from userRole where DeveloperName='Executive'  limit 1];        

        	User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'First',
            UserRoleId  = testUserRole.id,
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        	//insert u; 
        
         User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            UserRoleId  = testUserRole1.id,
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        ///insert u1;
        // Insert the User records
    Test.startTest();
            System.runAs(new User(Id = UserInfo.getUserId())) {

    insert u;
    insert u1;
            }
    Test.stopTest();
        
         TriggerSwitch__c tc1 = new TriggerSwitch__c();
        tc1.Name = 'TriggerLeadSourceAssignment';
        tc1.IsActive__c = True;
        insert tc1;
        
        TriggerSwitch__c tc2 = new TriggerSwitch__c();
        tc2.Name = 'Trigger_CustomSharingCriteria';
        tc2.IsActive__c = True;
        insert tc2;
        
        TriggerSwitch__c tc3 = new TriggerSwitch__c();
        tc3.Name = 'Trigger_Lead';
        tc3.IsActive__c = True;
        insert tc3;
        
        TriggerSwitch__c tc4 = new TriggerSwitch__c();
        tc4.Name = 'Trigger_Opportunity';
        tc4.IsActive__c = True;
        insert tc4;
        
        Custom_Sharing_Criteria__c csc3 = new Custom_Sharing_Criteria__c();
        csc3.Source__c='Lead';
        csc3.User_Role__c = testUserRole.DeveloperName;
        csc3.Lead_Source__c = '1st Street';
        insert csc3;
        
        Custom_Sharing_Criteria__c csc = new Custom_Sharing_Criteria__c();
        csc.Source__c='Lead';
        csc.User_Role__c = testUserRole1.DeveloperName;
        csc.Lead_Source__c = '1st Street';
        insert csc;
        
        Custom_Sharing_Criteria__c csc4 = new Custom_Sharing_Criteria__c();
        csc4.Source__c='Lead';
        csc4.User_Role__c = testUserRole.DeveloperName;
        csc4.Lead_Source__c = '20/20 Finance Brokers';
        insert csc4;
        
        Custom_Sharing_Criteria__c csc5 = new Custom_Sharing_Criteria__c();
        csc5.Source__c='Lead';
        csc5.User_Role__c = testUserRole1.DeveloperName;
        csc5.Lead_Source__c = '20/20 Finance Brokers';
        insert csc5;
        
        
        Lead ld=new lead();
        ld.LeadSource='1st Street';
        ld.LastName='Test 1';
        ld.company='RCS';
        insert ld;
        
        Ld.LeadSource='20/20 Finance Brokers';
        update ld;
        
        
    }
    private static testMethod void testMethod8() 
    {
         
			userRole testUserRole = [Select id,Name,DeveloperName from userRole where DeveloperName='Account_Managers'  limit 1];        
        	userRole testUserRole1 = [Select id,Name,DeveloperName from userRole where DeveloperName='Executive'  limit 1];        

        	User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'First',
            UserRoleId  = testUserRole.id,
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        	//insert u; 
        
         User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            UserRoleId  = testUserRole1.id,
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        ///insert u1;
        // Insert the User records
    Test.startTest();
            System.runAs(new User(Id = UserInfo.getUserId())) {

    insert u;
    insert u1;
            }
    Test.stopTest();
        
         TriggerSwitch__c tc1 = new TriggerSwitch__c();
        tc1.Name = 'TriggerLeadSourceAssignment';
        tc1.IsActive__c = True;
        insert tc1;
        
        TriggerSwitch__c tc2 = new TriggerSwitch__c();
        tc2.Name = 'Trigger_CustomSharingCriteria';
        tc2.IsActive__c = True;
        insert tc2;
        
        TriggerSwitch__c tc3 = new TriggerSwitch__c();
        tc3.Name = 'Trigger_Lead';
        tc3.IsActive__c = True;
        insert tc3;
        
        TriggerSwitch__c tc4 = new TriggerSwitch__c();
        tc4.Name = 'Trigger_Opportunity';
        tc4.IsActive__c = True;
        insert tc4;
        
        Custom_Sharing_Criteria__c csc3 = new Custom_Sharing_Criteria__c();
        csc3.Source__c='Opportunity';
        csc3.User_Role__c = testUserRole.DeveloperName;
        csc3.Lead_Source__c = '1st Street';
        insert csc3;
        
        Custom_Sharing_Criteria__c csc = new Custom_Sharing_Criteria__c();
        csc.Source__c='Opportunity';
        csc.User_Role__c = testUserRole1.DeveloperName;
        csc.Lead_Source__c = '1st Street';
        insert csc;
        
        Custom_Sharing_Criteria__c csc4 = new Custom_Sharing_Criteria__c();
        csc4.Source__c='Opportunity';
        csc4.User_Role__c = testUserRole.DeveloperName;
        csc4.Lead_Source__c = '20/20 Finance Brokers';
        insert csc4;
        
        Custom_Sharing_Criteria__c csc5 = new Custom_Sharing_Criteria__c();
        csc5.Source__c='Opportunity';
        csc5.User_Role__c = testUserRole1.DeveloperName;
        csc5.Lead_Source__c = '20/20 Finance Brokers';
        insert csc5;
        
        Opportunity ld=new Opportunity();
        ld.LeadSource='1st Street';
        ld.Name='Test 1';
        ld.StageName='In progress';
        ld.CloseDate = date.today();
        insert ld;
       
        
        Ld.LeadSource='20/20 Finance Brokers';
        update ld;
        
        
    }
}