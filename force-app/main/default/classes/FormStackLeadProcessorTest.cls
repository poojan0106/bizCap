@isTest
private class FormStackLeadProcessorTest {

    static testMethod void FormStackLeadProcessorUnitTest() {
        
        string CRON_SCH = '0 0 0 3 9 ? 2022';
        
        Lead lead = testDAta.createLead();
        insert lead;

        Test.startTest();
        
        String jobId = System.schedule('testBatchScheduledApex',CRON_SCH, new FormStackLeadProcessor());
        // Get the information from the CronTrigger API object  
        
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same 

        // *** Next from help doc: http://www.salesforce.com/us/developer/docs/apexcode/index_Left.htm#StartTopic=Content%2Fapex_scheduler.htm|SkinName=webhelp
        System.assertEquals(CRON_SCH, ct.CronExpression);
        // Verify the job has not run  
            
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run  
            
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));

        // Get test coverage of this
        FormStackLeadProcessor BatchProcessor = new FormStackLeadProcessor();
        string thisQuery = BatchProcessor.queryDetail();
        thisQuery += ' limit 5';
        BatchProcessor.query = thisQuery;
    
        ID batchprocessid = Database.executeBatch(BatchProcessor,100 );
                
        //FormStackLeadProcessor.statusUpdate(paymentTxnList);
          
        Test.stopTest();          
        
    }
}