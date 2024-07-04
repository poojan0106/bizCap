@isTest
private class OAuthRestControllerTest {

    static testMethod void OAuthRestControllerUnitTest() {	
		/*** TEST DATA ***/


		/*** RUN TESTS ***/
		id accountId = OAuthRestController.accountId;
		API_Detail__c APIDetail = OAuthRestController.loadAPIDetail(null);
		system.assertNotEquals(Null,APIDetail.id);

		OAuthRestController.APIDetailId = APIDetail.id;

		string loadLoginLink = OAuthRestController.loadLoginLink();

		OAuthRestController controller=new OAuthRestController();
		controller.login(); // should fail, no code passed in

		Test.SetCurrentPageReference(New PageReference('/apex/OAuthReturn?code=test'));
		controller.login();

	}
    static testMethod void OAuthRestControllerUnitTest2() {	
		/*** TEST DATA ***/
        API_Detail__c APIDetail2 = new API_Detail__c(
            Refresh_Token__c ='test',
            Access_Token__c = 'test',
            Instance_URL__c = 'test',
            Account__c =  OAuthRestController.accountId  
        );
insert APIDetail2;

		/*** RUN TESTS ***/
		id accountId = OAuthRestController.accountId;
		API_Detail__c APIDetail = OAuthRestController.loadAPIDetail(APIDetail2.id);
		system.assertNotEquals(Null,APIDetail.id);

		OAuthRestController.APIDetailId = APIDetail.id;

		string loadLoginLink = OAuthRestController.loadLoginLink();

		OAuthRestController controller=new OAuthRestController();
		controller.login(); // should fail, no code passed in

		Test.SetCurrentPageReference(New PageReference('/apex/OAuthReturn?code=test'));
		controller.login();

	}
}