public with sharing class OAuthRestBPUController {
    
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
        system.debug('accountid::'+accountid);
        return accountId;
    } set;}
    
    @AuraEnabled
    public static BPU_API_Details__c loadAPIDetail(string APIDetailRecordId) {
        
        BPU_API_Details__c APIDetail = new BPU_API_Details__c();
        if (APIDetailRecordId != null && APIDetailRecordId != '') 
        {
            APIDetailId = APIDetailRecordId;
        }
        
        if (APIDetailId != null)
        {
            system.debug('APIDetaild::'+APIDetailid);
            try 
            {
                APIDetail = [Select id,Name,Account__c,BPU_Access_Token__c,BPU_GET_URL__c,BPU_Refresh_Token__c,Instance_URL__c from BPU_API_Details__c where id = :APIDetailId and Account__c = :accountId Order by CreatedDate DESC limit 1 ];
            } 
            catch (Exception e) 
            {
                system.debug('e in if::'+e.getMessage());
            }
        } 
        else 
        {
            try 
            {
                system.debug('Accountid::'+accountid);
                APIDetail = [Select id,Name,Account__c,BPU_Access_Token__c,BPU_GET_URL__c,Instance_URL__c,BPU_Refresh_Token__c from BPU_API_Details__c where Account__c = :accountId Order by CreatedDate DESC limit 1 ];  
                system.debug('APIDetail::'+APIDetail);
            } 
            catch (Exception e) 
            {
                system.debug('e:::'+e.getMessage());
            }
        }
        
        try 
        {
            system.debug('upsert 1st::'+APIDetail);
            upsert APIDetail;
            system.debug('upsert 1st done::');
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException('Error occurred whilst creating API Detail record: '+ e.getMessage()); 
        }
        return APIDetail;
    }  
    
    // Production
    private static string loginUrl = Label.loginUrlProductionOAuth;//'https://bizcap.force.com/bizcapportal/';
    // STILL TO DO + add remote sites    
    private static string redirectUri = Label.loginUrlProdToken  + 'apex/OAuthBPUReturn';//loginUrl + 'apex/OAuthBPUReturn';
    private static string clientId = '3MVG9YDQS5WtC11pR7VR8IRcHSWqAhIzLk6dmbIhBWox_ZxXSvc3AZxhdkXI.ye2mAd36mj.6yLBlzKMWkQ1J';
    private static string clientSecret = '6CD8EE7900D6086A9718228604A16A20CD2FBE08C06DCFA56E69499584AAC7A7';
    
    @AuraEnabled
    public static string loadLoginLink() 
    {
        system.debug('clientId::'+clientId);
        system.debug('redirectUri::'+redirectUri);
        String loginLink = Label.loginUrlProdToken;
        string retURL = loginLink + 'services/oauth2/authorize?response_type=code&client_id='+clientId+'&redirect_uri='+redirectUri;
        // E.g: https://cs58.salesforce.com/services/oauth2/authorize?response_type=code&#x26;client_id=3MVG99S6MzYiT5k_0S9YS5rJRXT8zQe3bIGXMgHlRRXHn1plyZuHvsAVBRiCMBDNcL5izDIyNBH3tKvmQa2M2&#x26;redirect_uri=https://cs58.salesforce.com/services/oauth2/callback
        system.debug('retURL:'+retURL);
        return retURL;
    }
    
    public PageReference login() 
    {
        String url;
        try 
        {
            url = ApexPages.currentPage().getUrl().split('\\?')[0];
        } 
        catch (Exception e) 
        {
            system.debug('ex 94::'+e.getMessage());     
        }  
        System.debug('url is '+url);
        
        // If we get here we have no token
        PageReference pageRef;
        
        if (! ApexPages.currentPage().getParameters().containsKey('code')) 
        {
            // if contains "error" or "error_description"  (e.g. if login access denied)
            if (ApexPages.currentPage().getParameters().containsKey('error') ) {
                AAkonsultUtil.errorLog('OAuthRestBPUController.login','oAuth Error ',ApexPages.currentPage().getParameters().get('error_description') );
            } else {
                pageRef = new PageReference('/lightning/page/home');
                pageRef.setRedirect(true);                
            }
            
        } 
        else 
        {
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
            if (system.test.isRunningTest()) 
            {
                resp = '200';
                respBody= testData.OAuthRespJSON();
            } 
            else 
            {
                HttpResponse res = h.send(req);
                resp = string.valueOf(res.getStatusCode() );
                respBody = res.getBody();
                system.debug('respBody::'+respBody);
            }
            //System.debug('FINAL RESP IS:'+EncodingUtil.urlDecode(resp, 'UTF-8'));
            
            OAuthRespJSON AuthResp;
            try {
                AuthResp = OAuthRespJSON.parse(respBody);
            } catch (Exception e) {
                AAkonsultUtil.errorLog('OAuthRestBPUController.login','parse of JSON',e.getMessage()+'\r\n\r\n'+respBody );
            }
            
            BPU_API_Details__c APIDetail = new BPU_API_Details__c(
                BPU_Refresh_Token__c = AuthResp.refresh_token,
                BPU_Access_Token__c = AuthResp.access_token,
                BPU_GET_URL__c = AuthResp.instance_url+'/services/apexrest/BizCapGetBPURecords',
                Account__c = accountId  
            );
            
            try 
            {
                system.debug('APIDetail::'+APIDetail.id);
                upsert APIDetail;
            } 
            catch (Exception e) 
            {
                AAkonsultUtil.errorLog('OAuthRestBPUController.login','upsert BPU_API_Details__c',e.getMessage() );
            }
            
            pageRef = new PageReference('/lightning/page/home');
            system.debug('pageRef::'+pageRef);
            pageRef.setRedirect(true);
        }
        
        return pageRef;
    }
}