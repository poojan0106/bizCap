@isTest
public class ApplicationFormControllerTest {
    static testMethod void testApplication(){
        
        //Id aplicationRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Application').getRecordTypeId();
        ApplicationFormController objAppCon = new ApplicationFormController();

        Lead objLead = new Lead();
        objLead.Application_Confirmed__c = false;
        objLead.FirstName = 'TestF';
        objLead.LastName = 'Test LastName';
        objLead.Company = 'Test Company';
        objLead.Business_Trading_Name__c = 'TestBusiness';
        objLead.ABN__c = 'TestABN';
        objLead.Physical_Address__c = 'Test Physical';
        objLead.Suburb_Physical__c  = 'TestSuburd';
        objLead.State_Physical__c = 'Test State';
        objLead.Post_Code_Physical__c = '2323';
        objLead.Telephone_Number__c = '424324324';
        objLead.Email = 'Test@ymail.com';
        objLead.Length_of_Ownership__c = 'TestLength';
        objLead.Amount_requested__c = 1000;
        objLead.Monthly_Revenue__c = 324;
        objLead.Type_of_Entity__c = 'trust';
        objLead.Loan_Purpose__c = 'TestLoan';
        objLead.Products_or_Services_Sold__c = 'TestProd';
        //objLead.RecordTypeId = aplicationRecordTypeId;
        ApexPages.StandardController sc4 = new ApexPages.StandardController(objLead);
        ApplicationFormControllerNew objAppConNew3 = new ApplicationFormControllerNew(sc4);
         PageReference pageRef2 = Page.ApplicationForm_Wizard;
         pageRef2.getParameters().put('Id', objLead.Id);
         Test.setCurrentPage(pageRef2);  
        objAppConNew3.saveApplication();
        insert objLead;
         
        
        
        objAppCon.objLead = objLead;
        objLead.Email = 'Test@ymail.com';
        update objLead;
        
        objAppCon.validateApplication();
        objAppCon.saveApplication();
        objAppCon.deleteOwner();
        
      
        
        Lead objLead2 = new Lead();
        objLead2.Application_Confirmed__c = true;
        objLead2.FirstName = 'TestF';
        objLead2.LastName = 'Test LastName';
        objLead2.Company = 'Test Company';
        //objLead.RecordTypeId = aplicationRecordTypeId;
        insert objLead2; 

        ApplicationFormController objAppCon2 = new ApplicationFormController();
        objAppCon2.objLead = objLead2;
                ApexPages.StandardController sc1 = new ApexPages.StandardController(objLead2);
        ApplicationFormControllerNew objAppConNew1 = new ApplicationFormControllerNew(sc1);
       
        objAppCon2.saveApplication();
        objAppCon.addOwner();
        
       
        
        Lead objLead3 = new Lead();
        objLead3.FirstName = 'TestF';
        objLead3.Application_Confirmed__c = true;
        objLead3.LastName = 'Test LastName';
        objLead3.Company = 'Test Company';
        objLead3.Business_Trading_Name__c = 'TestBusiness';
        objLead3.ABN__c = 'TestABN';
        objLead3.Physical_Address__c = 'Test Physical';
        objLead3.Suburb_Physical__c  = 'TestSuburd';
        objLead3.State_Physical__c = 'Test State';
        objLead3.Post_Code_Physical__c = '2323';
        objLead3.Telephone_Number__c = '424324324';
        objLead3.Email = 'Test@ymail.com';
        objLead3.Length_of_Ownership__c = 'TestLength';
        objLead3.Amount_requested__c = 1000;
        objLead3.Monthly_Revenue__c = 324;
        objLead3.Type_of_Entity__c = 'trust';
        objLead3.Loan_Purpose__c = 'TestLoan';
        objLead3.Products_or_Services_Sold__c = 'TestProd';
        insert objLead3;
        Owner_Details__c objOwnerDetail = new Owner_Details__c();
        objOwnerDetail.Last_Name__c = 'Test OwnerName';
        objOwnerDetail.Name = 'Test Name';
        objOwnerDetail.Title__c = 'Test title';
        objOwnerDetail.Ownership__c = 10;
        objOwnerDetail.Lead__c = objLead3.Id;
        objOwnerDetail.Home_Address__c = 'Test home';
        objOwnerDetail.Suburb__c = 'TestS';
        objOwnerDetail.State__c = 'TestState';
        objOwnerDetail.Postal_Code__c = '24324234';
        objOwnerDetail.Length_at_Address__c = 'dfsdf';
        objOwnerDetail.Date_Of_Birth__c = date.parse('10/10/2010');
        objOwnerDetail.Email__c = 'Test@ymail.com';
        objOwnerDetail.Tel_M__c = '3233234323';
        objOwnerDetail.Tel_W__c = '3223323323';
        objOwnerDetail.Are_you_a_Politically_Exposed_Person__c = 'Yes';
        
        insert objOwnerDetail;
        
          ApexPages.StandardController sc = new ApexPages.StandardController(objLead3);
        ApplicationFormControllerNew objAppConNew = new ApplicationFormControllerNew(sc);
         PageReference pageRef = Page.ApplicationForm_Wizard;
         pageRef.getParameters().put('Id', String.valueOf(objLead3.Id));
         Test.setCurrentPage(pageRef);  
         objAppConNew.saveApplication();
        objAppConNew.addOwner();
        objAppConNew.deleteOwner();
        List<Owner_Details__c> listOwnerDetails = new List<Owner_Details__c>();
        listOwnerDetails.add(objOwnerDetail);
        ApplicationFormController objAppCon3 = new ApplicationFormController();
        objAppCon3.objLead = objLead3;
        objAppCon3.listOwnerDetails = listOwnerDetails;
        
        objAppCon3.validateApplication();
        objAppCon3.saveApplication();
        
        objAppCon.validateApplication();
        objAppCon.saveApplication();
        objAppCon.deleteOwner();
        
        objAppConNew.objLead = objLead3;
        objAppConNew.listOwnerDetails = listOwnerDetails;
        objAppConNew.saveApplication();
        objAppConNew.deleteOwner();
        objAppConNew.deleteOwner();
        
    }
}