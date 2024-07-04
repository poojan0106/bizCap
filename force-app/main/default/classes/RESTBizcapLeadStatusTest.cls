@isTest
private class RESTBizcapLeadStatusTest {

    static testMethod void RESTBizcapLeadStatusUnitTest() {	
		/*** TEST DATA ***/
		Lead lead = testData.createLead();
		insert lead;

		Account account = testData.createAccount();
		insert account;

		Opportunity opportunity = testData.createOpportunity(account.id);
		insert opportunity;

		/*** RUN TESTS ***/

  		RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();

        req.requestUri ='/services/apexrest/BizcapLeadsStatus/';
        req.httpMethod = 'GET';

		req.addHeader('LeadSource', 'mySampleBroker.com');
		req.addHeader('LeadRefs', 'Test111222a,Test3333444a');

        RestContext.request = req;
		RestContext.response= res;

		string BizcapLeadStatusRespStr = RESTBizcapLeadStatus.locateLeads();

		BizcapLeadStatusRespJSON BizcapLeadStatusResp = BizcapLeadStatusRespJSON.parse(BizcapLeadStatusRespStr);
system.debug(BizcapLeadStatusResp);

	//	system.assertEquals(1, BizcapLeadResp.NoOfSuccesses );
	}
}