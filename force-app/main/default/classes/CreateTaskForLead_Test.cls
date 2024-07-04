@isTest
private class CreateTaskForLead_Test
{
    public static testMethod void TestMethod1()
    {
        Lead ld = new Lead();
        ld.RecordTypeId = '0126F000001KFFYQA4';
        ld.LeadSource = 'Access Capital';
        ld.Status = 'New';
        ld.LastName = 'Test';
        ld.Company = 'TestCompany';
        ld.Document_ID__c = 'TestID123';
        insert ld;
        
        Test.startTest();
        Lead lstld = [Select id,Company from Lead where Company = 'TestCompany']; 
        Test.stopTest();
        
        System.assertEquals('TestCompany', lstld.Company);
    }
}