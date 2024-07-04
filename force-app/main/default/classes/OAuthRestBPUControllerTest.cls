@isTest
private class OAuthRestBPUControllerTest {

    static testMethod void OAuthRestControllerUnitTest() {	
		/*** TEST DATA ***/


		/*** RUN TESTS ***/
		id accountId = OAuthRestBPUController.accountId;
		BPU_API_Details__c APIDetail = OAuthRestBPUController.loadAPIDetail(null);
		system.assertNotEquals(Null,APIDetail.id);

		OAuthRestBPUController.APIDetailId = APIDetail.id;

		string loadLoginLink = OAuthRestBPUController.loadLoginLink();

		OAuthRestBPUController controller=new OAuthRestBPUController();
		controller.login(); // should fail, no code passed in

		Test.SetCurrentPageReference(New PageReference('/apex/OAuthBPUReturn?code=test'));
		controller.login();

	}
}