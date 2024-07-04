public with sharing class OAuthRestController {

    public static id APIDetailId {get;set;}

    public static string accountId {get {
        if (accountId == null && accountId != '') {
            try {
                User user = [select Id, contactId, contact.accountId from User where id = :UserInfo.getUserId() limit 1];
                if (user.contactId != null) {
                    accountId = user.contact.accountId;
                }
            } catch (Exception e) {}
        }
        return accountId;
    } set;}

	@AuraEnabled
	public static API_Detail__c loadAPIDetail(string APIDetailRecordId) {

        API_Detail__c APIDetail = new API_Detail__c();
		if (APIDetailRecordId != null && APIDetailRecordId != '') {
            APIDetailId = APIDetailRecordId;
        }
        if (APIDetailId != null) {
            try {
                APIDetail = [Select id,Name,Account__c,Access_Token__c,Refresh_Token__c,Instance_URL__c,Lead_Create_POST_URL__c,Lead_Status_GET_URL__c,Integration_Guide__c from API_Detail__c where id = :APIDetailId and Account__c = :accountId Order by CreatedDate DESC limit 1 ];
            } catch (Exception e) {}
        } else {
            try {
                APIDetail = [Select id,Name,Account__c,Access_Token__c,Refresh_Token__c,Instance_URL__c,Lead_Create_POST_URL__c,Lead_Status_GET_URL__c,Integration_Guide__c from API_Detail__c where Account__c = :accountId Order by CreatedDate DESC limit 1 ];  
            } catch (Exception e) {}
        }

        try {
          upsert APIDetail;
        } catch (Exception e) {
            throw new AuraHandledException('Error occurred whilst creating API Detail record: '+ e.getMessage()); 
        }

        return APIDetail;
    }  

    // Production
    private static string loginUrl = Label.loginUrlProductionOAuth;//'https://bizcapau.my.salesforce.com/';
// STILL TO DO + add remote sites    
    private static string redirectUri =Label.loginUrlProdToken + 'apex/OAuthReturn';// loginUrl + 'apex/OAuthReturn';
    private static string clientId = '3MVG9YDQS5WtC11pR7VR8IRcHSZMNOzIgyif9ELp0FgkD3Cj2.tKyM1AdeN5m_t2Y54wvASUXJVrY.wutiwTc';
    private static string clientSecret = '26434780978A477A9052C2EBCCE0230EA6559F9BF693A451F0D150FD82AD5A94';

    private static void locateCredentials() {

        boolean partnerPortal = UserInfo.getUserType() != 'Standard';

        string environment = (userinfo.getOrganizationId() == '00D6F000002U6sIUAS') ? 'Production' : 'Sandbox';

        if (partnerPortal || Test.isRunningTest()) {
            if (environment == 'Production') {

                loginUrl = Label.loginUrlProductionOAuth;//'https://bizcap.force.com/bizcapportal/';
                redirectUri = Label.loginUrlProdToken + 'apex/OAuthReturn';

                clientId = '3MVG9YDQS5WtC11pR7VR8IRcHSRKa9EYcQ09PxqrAsJvL.83j9AuNiPpxsZN2CplRAAIzkuRNDMe0ZBFfAegp';
                clientSecret = '5B0360DA5EFA3F15BD4C2558A406C95DA7CF75229230B8BBCC5333DC6FE042A0';
            }
            if (environment == 'Sandbox') {              
                loginUrl = 'https://aakonsult-bizcap.cs58.force.com/bizcap/';
                redirectUri = loginUrl + 'apex/OAuthReturn';

                clientId = '3MVG99S6MzYiT5k_0S9YS5rJRXRxyU_m7aOcYiGHP66MCpSYHRtK5Ayu2oZsWaVypchVIpWURBxEjr82FskFX';
                clientSecret = 'BA1173DCCB5C5895B6D93CC8F34AB46AC89B1537C07C29834BE6C6178448150F';
            }            
        } else {
            if (environment == 'Sandbox') {
                loginUrl = 'https://cs58.salesforce.com/';
                redirectUri = loginUrl + 'apex/OAuthReturn';

                clientId = '3MVG99S6MzYiT5k_0S9YS5rJRXT8zQe3bIGXMgHlRRXHn1plyZuHvsAVBRiCMBDNcL5izDIyNBH3tKvmQa2M2';
                clientSecret = 'E9154C76359800FB021BD3497724BC225554070D9A443AD26DF2B7B36008B827';
            }
        }
      
    }

	@AuraEnabled
	public static string loadLoginLink() {
        locateCredentials();
		String loginLink = Label.loginUrlProdToken;
        string retURL = loginLink + 'services/oauth2/authorize?response_type=code&client_id='+clientId+'&redirect_uri='+redirectUri;
        // E.g: https://cs58.salesforce.com/services/oauth2/authorize?response_type=code&#x26;client_id=3MVG99S6MzYiT5k_0S9YS5rJRXT8zQe3bIGXMgHlRRXHn1plyZuHvsAVBRiCMBDNcL5izDIyNBH3tKvmQa2M2&#x26;redirect_uri=https://cs58.salesforce.com/services/oauth2/callback
        return retURL;
    }

	/* to use:
	 * under setup > develop > remote.  Create new app.  Put the URL as ...../apex/RestCall
	 * delete any oAuth cookies
	 * run https://test.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9dPGzpc3kWyfD3Ws_ENYrfX6fPxcjqQKF4n88cKxlls1U4rlvcOvxgIGC5M8qORVQKwEvq0l0D3F0VZns&redirect_uri=https://ixc--dev.cs15.my.salesforce.com/apex/RestCall
	 * copy: access_token for immediate
	 * copy: refresh_token for future refresh
	 */


    /***** SAMPLE CALL
    https://cs58.salesforce.com/services/oauth2/authorize?response_type=token&client_id=3MVG99S6MzYiT5k_0S9YS5rJRXT8zQe3bIGXMgHlRRXHn1plyZuHvsAVBRiCMBDNcL5izDIyNBH3tKvmQa2M2&redirect_uri=https://cs58.salesforce.com/services/oauth2/callback

    /**** SAMPLE RESPONSE ****
    https://cs58.salesforce.com/services/oauth2/callback#access_token=00D0l000000Daeq%21AREAQAHDVC3S6A0Gp.0qwCUuXun4kpcdRgECCO6JQBjBtWZP_yrIJJ9r_sLBWrkp3yajnUPXdsvQBZjL2hMVlK8SIVjW46qw&instance_url=https%3A%2F%2Fbizcap--aakonsult.my.salesforce.com&id=https%3A%2F%2Ftest.salesforce.com%2Fid%2F00D0l000000DaeqEAC%2F0050l0000035I7AAAU&issued_at=1559028458072&signature=fxix1ZdQ7KpMlMu%2FQZUxAYhZ9Th6TVaf0lKwxENSl6g%3D&scope=id+api+visualforce&token_type=Bearer
    */
   
    public PageReference login() {
        // Get a URL for the page without any query params
  
        String url;
        try {
            url = ApexPages.currentPage().getUrl().split('\\?')[0];
        } catch (Exception e) {

        }  
        System.debug('url is '+url);

        locateCredentials();
     
        // If we get here we have no token
        PageReference pageRef;
     
        if (! ApexPages.currentPage().getParameters().containsKey('code')) {
            // if contains "error" or "error_description"  (e.g. if login access denied)
            if (ApexPages.currentPage().getParameters().containsKey('error') ) {
                AAkonsultUtil.errorLog('OAuthRestController.login','oAuth Error ',ApexPages.currentPage().getParameters().get('error_description') );
            } else {
                pageRef = new PageReference('/lightning/page/home');
                pageRef.setRedirect(true);                
            }
            // Initial step of OAuth - redirect to OAuth service
            /*
            System.debug('OAuth Step 1');
     
            String authuri = loginUrl+'/services/oauth2/authorize?'+
                'response_type=code&client_id='+clientId+'&redirect_uri='+redirectUri;
                         
            pageRef = new PageReference(authuri);
            */
        } else {
            // Second step of OAuth - get token from OAuth service
            String code = ApexPages.currentPage().getParameters().get('code');

            System.debug('OAuth Step 2 - code:'+code);
             
            String body = 'grant_type=authorization_code&client_id='+clientId+
                '&redirect_uri='+redirectUri+'&client_secret='+clientSecret+
                '&code='+code;
//System.debug('body is:'+body);
             
            HttpRequest req = new HttpRequest();
            req.setEndpoint(loginUrl+'services/oauth2/token');
            req.setMethod('POST');
            req.setBody(body);
     
            Http h = new Http();
            String resp;
            String respBody='';
            if (system.test.isRunningTest()) {
            	resp = '200';
            	respBody= testData.OAuthRespJSON();
            } else {
            	HttpResponse res = h.send(req);
             	resp = string.valueOf(res.getStatusCode() );
             	respBody = res.getBody();
            }
//System.debug('FINAL RESP IS:'+EncodingUtil.urlDecode(resp, 'UTF-8'));

            OAuthRespJSON AuthResp;
            try {
                AuthResp = OAuthRespJSON.parse(respBody);
            } catch (Exception e) {
                AAkonsultUtil.errorLog('OAuthRestController.login','parse of JSON',e.getMessage()+'\r\n\r\n'+respBody );
            }

            API_Detail__c APIDetail = new API_Detail__c(
                Refresh_Token__c = AuthResp.refresh_token,
                Access_Token__c = AuthResp.access_token,
                Instance_URL__c = AuthResp.instance_url,
                Account__c = accountId  
            );

            try {
                upsert APIDetail;
            } catch (Exception e) {
                AAkonsultUtil.errorLog('OAuthRestController.login','upsert API_Detail__c',e.getMessage() );
            }

            pageRef = new PageReference('/lightning/page/home');
            pageRef.setRedirect(true);
        }
     
        return pageRef;
    }
}