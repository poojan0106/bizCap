@IsTest(SeeAllData=true)
private class BizCapGetBPURecordsTest {
    
    static testMethod void RESTBizcapLeadStatusUnitTest() {	
		/*** TEST DATA ***/
		//Lead lead = testData.createLead();		
        
        Lead lead = new Lead();
        lead.FirstName = 'FirstName';
        lead.LastName = 'LastName';
        lead.Email = 'lead@test.com';
        lead.Phone = '+61 (3) 9999 1112';
        lead.Company = 'The company'; 
        lead.Lead_Reference__c = 'Test111222a';
        lead.LeadSource='Lend';
        lead.Status = 'New';        
        lead.Lead_Status_Change_Date__c = System.now();
        lead.Lead_Sub_Status_Date_Changed__c = System.now().addMonths(-16);
        lead.Lead_Sub_Status__c = 'Received';
        insert lead;
                
		Account account = testData.createAccount();
		insert account;

        Contact contact = testData.createContact(account.id);
		Opportunity opportunity = testData.createOpportunity(account.id);
        //opportunity.LeadSource = 'Lend';
		insert opportunity;

        opportunity.StageName = 'Settled';
        opportunity.Sub_stage__c = 'Contract requested';
        update Opportunity;
        
        BPU__c insertBPU = new BPU__c();
        insertBPU.Lead__c = Lead.Id;
        insertBPU.Opportunity__c = opportunity.id;
        insertBPU.Status__c = 'New';
        insertBPU.Sub_Status__c = 'Received';
        insertBPU.Lead_Source__c = 'Lend';
        insertBPU.Lead_Reference__c = 'Test111222a';
       	insert insertBPU;
        
        //BPU__c bpu = testData.createBPU(lead.id, opportunity.id);
        
		/*** RUN TESTS ***/

  		RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();

        req.requestUri ='/services/apexrest/BizCapGetBPURecords/';
        req.httpMethod = 'GET';

		req.addHeader('LeadSource', 'Lend');
		req.addHeader('LeadRefs', 'Test111222a');
        req.addHeader('LeadRefs', 'Test111222a, Test111');
		req.addHeader('LeadStatus', 'New');
        req.addHeader('LeadSubStatus', 'Received');
        req.addHeader('Stage', 'In progress');
        req.addHeader('SubStage', 'Contract requested');
        req.addHeader('FromLeadStatusChangeDate','2019-06-15T00:00:00.000Z');
        req.addHeader('ToLeadStatusChangeDate','2020-06-16T00:00:00.000Z');
        req.addHeader('FromLeadSubStatusChangeDate','2020-06-15T00:00:00.000Z');
        req.addHeader('ToLeadSubStatusChangeDate','2020-06-16T00:00:00.000Z');
        req.addheader('FromStageChangeDate','2019-06-15T00:00:00.000Z'); //OPP STAGE CHANGE DATE
        req.addheader('ToStageChangeDate','2019-06-15T00:00:00.000Z');
        req.addheader('FromSubStageChangeDate','2019-06-15T00:00:00.000Z'); //OPP SUB STAGE CHANGE DATE
        req.addheader('ToSubStageChangeDate','2019-06-15T00:00:00.000Z');
        RestContext.request = req;
		RestContext.response= res;
        
        string BizcapLeadStatusRespStr = BizCapGetBPURecords.locateBPU();
        BizCapGetBPURecords.fakeMethod();
        BizCapGetBPURespJSON BizcapLeadStatusResp = BizCapGetBPURespJSON.parse(BizcapLeadStatusRespStr);

	//	system.assertEquals(1, BizcapLeadResp.NoOfSuccesses );
	}
    
     static testMethod void RESTBizcapLeadStatusUnitTest1() {	
		/*** TEST DATA ***/
		//Lead lead = testData.createLead();		
        
        Lead lead = new Lead();
        lead.FirstName = 'FirstName';
        lead.LastName = 'LastName';
        lead.Email = 'lead@test.com';
        lead.Phone = '+61 (3) 9999 1112';
        lead.Company = 'The company'; 
        lead.Lead_Reference__c = 'Test111222a';
        lead.LeadSource='Lend';
        lead.Status = 'New';        
        lead.Lead_Status_Change_Date__c = System.now();
        lead.Lead_Sub_Status_Date_Changed__c = System.now().addMonths(-16);
        lead.Lead_Sub_Status__c = 'Received';
        insert lead;
                
		Account account = testData.createAccount();
		insert account;

        Contact contact = testData.createContact(account.id);
		Opportunity opportunity = testData.createOpportunity(account.id);
        //opportunity.LeadSource = 'Lend';
		insert opportunity;

        opportunity.StageName = 'Settled';
        opportunity.Sub_stage__c = 'Contract requested';
        update Opportunity;
        
        BPU__c insertBPU = new BPU__c();
        insertBPU.Lead__c = Lead.Id;
        insertBPU.Opportunity__c = opportunity.id;
        insertBPU.Status__c = 'New';
        insertBPU.Sub_Status__c = 'Received';
        insertBPU.Lead_Source__c = 'Lend';
        insertBPU.Lead_Reference__c = 'Test111222a';
       	insert insertBPU;
        
        //BPU__c bpu = testData.createBPU(lead.id, opportunity.id);
        
		/*** RUN TESTS ***/

  		RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();

        req.requestUri ='/services/apexrest/BizCapGetBPURecords/';
        req.httpMethod = 'GET';

		req.addHeader('LeadSource', 'Lend');
		req.addHeader('LeadRefs', 'Test111222a');
        req.addHeader('LeadRefs', 'Test111222a, Test111');
		req.addHeader('LeadStatus', 'New');
        req.addHeader('LeadSubStatus', 'Received');
        req.addHeader('Stage', 'In progress');
        req.addHeader('SubStage', 'Contract requested');
        //req.addHeader('FromLeadStatusChangeDate','2019-06-15T00:00:00.000Z');
        req.addHeader('ToLeadStatusChangeDate','2020-06-16T00:00:00.000Z');
        req.addHeader('FromLeadSubStatusChangeDate','2020-06-15T00:00:00.000Z');
        req.addHeader('ToLeadSubStatusChangeDate','2020-06-16T00:00:00.000Z');
        req.addheader('FromStageChangeDate','2019-06-15T00:00:00.000Z'); //OPP STAGE CHANGE DATE
        req.addheader('ToStageChangeDate','2019-06-15T00:00:00.000Z');
        req.addheader('FromSubStageChangeDate','2019-06-15T00:00:00.000Z'); //OPP SUB STAGE CHANGE DATE
        req.addheader('ToSubStageChangeDate','2019-06-15T00:00:00.000Z');
        RestContext.request = req;
		RestContext.response= res;
        
        string BizcapLeadStatusRespStr = BizCapGetBPURecords.locateBPU();
        BizCapGetBPURecords.fakeMethod();
        BizCapGetBPURespJSON BizcapLeadStatusResp = BizCapGetBPURespJSON.parse(BizcapLeadStatusRespStr);

	//	system.assertEquals(1, BizcapLeadResp.NoOfSuccesses );
	}
}