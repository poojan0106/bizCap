@RestResource(urlMapping='/BizcapLeadsStatus/*')
global with sharing class RESTBizcapLeadStatus
{

    @HttpGet
    global static string locateLeads(){

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;

		String LeadSource = req.headers.get('LeadSource');	//mySampleBroker.com
		String FromDateTimeStr = req.headers.get('FromDateTime');	//2019-06-15T00:00:00.000Z
		String ToDateTimeStr = req.headers.get('ToDateTime');	//2019-06-15T23:59:59.000Z
		string LeadRefs = req.headers.get('LeadRefs');  //x1234569,Y1231

		dateTime FromDateTime;
		dateTime ToDateTime;

		string errMsg = '';
		try {
			if (FromDateTimeStr != null && FromDateTimeStr != '') {
				FromDateTime = (DateTime) JSON.deserialize('"'+FromDateTimeStr+'"', DateTime.class); 
			}
			if (ToDateTimeStr != null && ToDateTimeStr != '') {
				ToDateTime = (DateTime) JSON.deserialize('"'+ToDateTimeStr+'"', DateTime.class); 
			}
		} catch (Exception e) {
			errMSg += e.getMessage()+'\r\n\r\n';
		}

		set<string> leadRefSet = new set<string>();
		if (LeadRefs != null && LeadRefs != '') {
			string[] sList  = LeadRefs.split(',');
			if (sList != null && !sList.isEmpty() ) {
				for (string s : sList) {
					if (s != null && s != '' ) {
						leadRefSet.add(s.trim() );	
					}
				}
			}
		}

		BizcapLeadStatusRespJSON BizcapLeadStatusResp = new BizcapLeadStatusRespJSON();
		BizcapLeadStatusResp.Results = new list<BizcapLeadStatusRespJSON.cls_Results>();

		integer noLeads = 0;

		if (LeadSource == null || LeadSource == '') {
			errMSg = 'Missing Lead Source';
		}  
		if (errMsg == '') {
			if (APIDetail != null && FromDateTime == null) {
				FromDateTime = APIDetail.Last_Lead_Status__c;
			}
			if (FromDateTime == null) {
				FromDateTime = system.now().addDays(-14);
			}

			map<string,lead> leadStatusMap = new map<string,lead>();

			// find leads
			string thisQuery = 'Select Id,Lead_Reference__c,Bizcap_Lead_Ref__c, Status, Decline_Reason__c,Funded_Date__c,Loan_Type__c,Loan_Amount__c,Loan_term_business_days__c,Payback_Amount__c,Factor_Rate__c,Last_Call_Date__c,Call_Attempts__c from Lead where IsConverted = false and leadSource = :LeadSource and lastModifiedDate >= :FromDateTime  ';
			if (ToDateTime != null) {
				thisQuery += ' and lastModifiedDate <= :ToDateTime ';
			}
			if (leadRefSet != null && !leadRefSet.isEmpty() ) {
				thisQuery += ' and Lead_Reference__c in :leadRefSet ';
			}
			thisQuery += ' order by CreatedDate';

			for (Lead lead : database.query(thisQuery) ) {
				leadStatusMap.put(lead.Lead_Reference__c,Lead);
			}

			// Find opportunities
			map<string,Opportunity> oppStatusMap = new map<string,Opportunity>();
			thisQuery = 'Select Id,Lead_Reference__c,Bizcap_Lead_Ref__c, StageName,Decline_Reason__c,CloseDate,Loan_Type__c,Amount,Loan_term_business_days__c,Payback_Amount__c,Factor_Rate__c from Opportunity where leadSource = :LeadSource and lastModifiedDate >= :FromDateTime  ';

			if (ToDateTime != null) {
				thisQuery += ' and lastModifiedDate <= :ToDateTime ';
			}
			if (leadRefSet != null && !leadRefSet.isEmpty() ) {
				thisQuery += ' and Lead_Reference__c in :leadRefSet ';
			}			
			thisQuery += ' order by CreatedDate';

			for (Opportunity opp : database.query(thisQuery) ) {
				oppStatusMap.put(opp.Lead_Reference__c,opp);
			}

			for (string leadRef : leadStatusMap.keySet() ) {
				if (!oppStatusMap.containsKey(leadRef) ) {
					BizcapLeadStatusRespJSON.cls_Results BCRes = new BizcapLeadStatusRespJSON.cls_Results();
					Lead lead = leadStatusMap.get(leadRef);
					BCRes.LeadId = lead.Bizcap_Lead_Ref__c;
					BCRes.LeadRef = lead.Lead_Reference__c;
					BCRes.reason = lead.Decline_Reason__c;
					BCRes.Status = lead.Status;	
					BCRes.FundedDate = lead.Funded_Date__c; 
					BCRes.LoanType = lead.Loan_Type__c; // New Loan
					BCRes.LoanAmount = lead.Loan_Amount__c;
					BCRes.PaybackAmount = lead.Payback_Amount__c;
					BCRes.LoanTermBusinessDays = (lead.Loan_term_business_days__c == null) ? 0 : integer.valueOf(lead.Loan_term_business_days__c);
					BCRes.FactorRate = lead.Factor_Rate__c;	
                    BCRes.CallAttempts = lead.Call_Attempts__c;
                    BCRes.LastCallDate = lead.Last_Call_Date__c;
					BizcapLeadStatusResp.Results.add(BCRes);
                    					
					noLeads += 1;				
				}
			}

			for (string leadRef : oppStatusMap.keySet() ) {
					BizcapLeadStatusRespJSON.cls_Results BCRes = new BizcapLeadStatusRespJSON.cls_Results();
					Opportunity opp = oppStatusMap.get(leadRef);
					BCRes.LeadId = opp.Bizcap_Lead_Ref__c;
					BCRes.LeadRef = opp.Lead_Reference__c;
					BCRes.reason = opp.Decline_Reason__c;
					BCRes.Status = opp.StageName;
					BCRes.FundedDate = opp.CloseDate; 
					BCRes.LoanType = opp.Loan_Type__c; // New Loan
					BCRes.LoanAmount = opp.Amount;
					BCRes.PaybackAmount = opp.Payback_Amount__c;
					BCRes.LoanTermBusinessDays = (opp.Loan_term_business_days__c == null) ? 0 : integer.valueOf(opp.Loan_term_business_days__c);
					BCRes.FactorRate = opp.Factor_Rate__c;					
					BizcapLeadStatusResp.Results.add(BCRes);
					
					noLeads += 1;				
			}


			APIDetail.Last_Lead_Status__c = system.now();

			try {
				upsert APIDetail;
			} catch (Exception e) {
				errMSg += e.getMessage()+'\r\n\r\n';
			}
		}

		BizcapLeadStatusResp.ErrorMsg=errMSg;
		BizcapLeadStatusResp.NoOfLeads = noLeads;

		string JSONResp = JSON.serialize(BizcapLeadStatusResp);

		return JSONResp; 
	}

    private static id accountId {get {
        if (accountId == null) {
            try {
                User user = [select Id, contactId, contact.accountId from User where id = :UserInfo.getUserId() limit 1];
                if (user.contactId != null) {
                    accountId = user.contact.accountId;
                }
            } catch (Exception e) {}
        }
        return accountId;
    } set;}


	public static API_Detail__c APIDetail { get {

		if (APIDetail == null) {
         	APIDetail = new API_Detail__c(
				Account__c = accountId
			);
            try {
                APIDetail = [Select id,Name,Account__c,Last_Lead_Status__c from API_Detail__c where Account__c = :accountId Order by CreatedDate DESC limit 1 ];  
            } catch (Exception e) {}
        }

        return APIDetail;
    } set; }
}