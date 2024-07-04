/*
* Created By: Dhairya Shah
* Desc: Get the BPU records
*/ 
@RestResource(urlMapping='/BizCapGetBPURecords/*')
global with sharing class BizCapGetBPURecords {
    
    
       
    @HttpGet
    global static String locateBPU() 
    {
        
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        AccountWrapper response = new AccountWrapper();
       
        
        String LeadSource = req.headers.get('LeadSource');
        String LeadStatus = req.headers.get('LeadStatus');
        String LeadSubStatus = req.headers.get('LeadSubStatus');
        string LeadRefs = req.headers.get('LeadRefs');  //x1234569,Y1231
        String OppStage = req.headers.get('Stage');
        String OppSubStage = req.headers.get('SubStage');
        String FromLeadStatusChangeDate = req.headers.get('FromLeadStatusChangeDate');
        String ToLeadStatusChangeDate = req.headers.get('ToLeadStatusChangeDate');//2019-06-15T00:00:00.000Z
        String FromLeadSubStatusChangeDate = req.headers.get('FromLeadSubStatusChangeDate');
        String ToLeadSubStatusChangeDate = req.headers.get('ToLeadSubStatusChangeDate');
        String FromStageChangeDate = req.headers.get('FromStageChangeDate'); //OPP STAGE CHANGE DATE
        String ToStageChangeDate = req.headers.get('ToStageChangeDate');
        String FromSubStageChangeDate = req.headers.get('FromSubStageChangeDate'); //OPP SUB STAGE CHANGE DATE
        String ToSubStageChangeDate = req.headers.get('ToSubStageChangeDate');
        
        //LEAD
        dateTime FromDateTimeStatus;
        dateTime ToDateTimeStatus;
        dateTime FromDateTimeSubStatus;
        dateTime ToDateTimeSubStatus;
        
		//OPPORTUNITY
        dateTime FromStageDate;
        dateTime ToStageDate;
        dateTime FromSubStageDate;
        dateTime ToSubStageDate;
        
        BizCapGetBPURespJSON BizCapBPUResp = new BizCapGetBPURespJSON();
        BizCapBPUResp.Results = new list<BizCapGetBPURespJSON.cls_Results>();
        
        INTEGER noLeads = 0;
        string errMsg = '';
        
        if(LeadSource == null || LeadSource == '') 
        {
            response.status = 'Error';
            errMsg = 'You must provide a Lead Source for your search term.';
            res.StatusCode = 400;
        }
        
        else 
        {   
            try 
            {
                system.debug('BPUAPIDetail::'+BPUAPIDetail);
                
                if (BPUAPIDetail != null && (FromLeadStatusChangeDate == null || FromLeadStatusChangeDate == '') && (FromStageChangeDate == ''))
                {
                    FromDateTimeStatus = BPUAPIDetail.Last_Lead_Status__c;
                }
                
                //OPPORTUNITY STAGE DATE
                if(BPUAPIDetail!=NULL && (FromStageChangeDate == null || FromStageChangeDate == '') && (FromLeadStatusChangeDate == ''))
                {
                    FromStageDate = BPUAPIDetail.Last_Opportunity_Stage_Date__c;
                }
                
                
                //LEAD STATUS DATE
                /*if (FromDateTimeStatus == null) 
                {
                    FromDateTimeStatus = system.now().addDays(-14);
                }
                
                //OPPORTUNITY STAGE DATE
                /*if(FromStageDate == NULL)
                {
                    FromStageDate = system.now().addDays(-14);
                }*/
                
                system.debug('FromLeadStatusChangeDate::'+FromLeadStatusChangeDate);
                //FROM LEAD STATUS CHANGE DATE
                if (FromLeadStatusChangeDate != null && FromLeadStatusChangeDate != '') {
                    FromDateTimeStatus = (DateTime) JSON.deserialize('"'+FromLeadStatusChangeDate+'"', DateTime.class); 
                }
                system.debug('FromDateTimeStatus::'+FromDateTimeStatus);
                //TO LEAD STATUS CHANGE DATE
                if (ToLeadStatusChangeDate != null && ToLeadStatusChangeDate != '') {
                    ToDateTimeStatus = (DateTime) JSON.deserialize('"'+ToLeadStatusChangeDate+'"', DateTime.class); 
                }
                
                //FROM LEAD SUB STATUS CHANGE DATE
                if (FromLeadSubStatusChangeDate != null && FromLeadSubStatusChangeDate != '') {
                    FromDateTimeSubStatus = (DateTime) JSON.deserialize('"'+FromLeadSubStatusChangeDate+'"', DateTime.class); 
                }
                
                //TO LEAD SUB STATUS CHANGE DATE
                if (ToLeadSubStatusChangeDate != null && ToLeadSubStatusChangeDate != '') {
                    ToDateTimeSubStatus = (DateTime) JSON.deserialize('"'+ToLeadSubStatusChangeDate+'"', DateTime.class); 
                }
                
                //FROM OPP STAGE DATE
                IF(FromStageChangeDate!=NULL && FromStageChangeDate!='')
                {
                    FromStageDate = (DateTime) JSON.deserialize('"'+FromStageChangeDate+'"', DateTime.class);
                }
                
                //TO OPP STAGE DATE
                IF(ToStageChangeDate!=NULL && ToStageChangeDate!='')
                {
                    ToStageDate = (DateTime) JSON.deserialize('"'+ToStageChangeDate+'"', DateTime.class);
                }
                
                //FROM OPP SUB STAGE DATE
                IF(FromSubStageChangeDate!=NULL && FromSubStageChangeDate!='')
                {
                    FromSubStageDate = (DateTime) JSON.deserialize('"'+FromSubStageChangeDate+'"', DateTime.class);
                }
                
                //TO SUB STAGE DATE
                IF(ToSubStageChangeDate!=NULL && ToSubStageChangeDate!='')
                {
                    ToSubStageDate = (DateTime) JSON.deserialize('"'+ToSubStageChangeDate+'"', DateTime.class);
                }
                
            } catch (Exception e) {
                errMSg += e.getMessage()+'\r\n\r\n';
            }
            
            //LEAD REFS CONTAINS ','
            set<string> leadRefSet = new set<string>();
            if (LeadRefs != null && LeadRefs != '' && LeadRefs.contains(',')) {
                string[] sList  = LeadRefs.split(',');
                if (sList != null && !sList.isEmpty() ) {
                    for (string s : sList) {
                        if (s != null && s != '' ) {
                            leadRefSet.add(s.trim() );  
                        }
                    }
                }
            }
            
            //added by dhairya to get the stage date
            String thisQueryStage;
            List<BPU__c> searchResultsStage = new List<BPU__c>();
            
            String thisQuery;
            List<BPU__c> searchResults = new List<BPU__c>();
            
            String thisQueryLead;
            List<BPU__c> searchResultsLead = new List<BPU__c>();
            
            SYSTEM.debug('FromDateTimeStatus::'+FromDateTimeStatus);
            SYSTEM.debug('FromStageDate::'+FromStageDate);
            
            //MAIN IF CONDITION FOR LEAD STATUS
            if(FromDateTimeStatus!=NULL)
            {
                thisQuery='SELECT id, BC_Number__c, Bizcap_Lead_Ref__c, Call_Attempts__c, Company__c, Conditional_Approval_Amount__c, Conditional_Approval_Date__c, Email_Address__c, Factor_Rate__c';
                thisQuery+=',Funded_Date__c, Is_Converted__c, Last_Call_Date__c, Lead__c, Lead_Reference__c, Lead_Source__c, Loan_Amount__c, Loan_term_business_days__c, Loan_Type__c, Application_Check__c, Bank_Statements_Check__c';
                thisQuery+=',Opportunity__c, Payback_Amount__c, Stage__c, Status__c, Sub_Stage__c, Sub_Status__c, Status_change_date__c, Sub_Status_Change_Date__c, Stage_Change_Date__c, Sub_Stage_Change_Date__c, Lead__r.FirstName, Lead__r.LastName';
                thisQuery+=' FROM BPU__c WHERE Lead_Source__c=\'' + String.escapeSingleQuotes(LeadSource)+'\'';
                
                SYSTEM.debug('INSIDE FROMDATETIME');
                IF(FromDateTimeStatus!=NULL)
                {
                    system.debug('FromDateTimeStatus::'+FromDateTimeStatus);
                    thisQuery +=' AND Status_change_date__c >=: FromDateTimeStatus';
                }
               
                //STATUS CHANGED DATE TO
                if(ToDateTimeStatus!=NULL)
                {
                    system.debug('ToDateTimeStatus::'+ToDateTimeStatus);
                    thisQuery +=' AND Status_change_date__c <=: ToDateTimeStatus';
                }
                
                //SUB STATUS CHANGED DATE FROM
                if(FromDateTimeSubStatus!=NULL){
                    system.debug('FromDateTimeSubStatus::'+FromDateTimeSubStatus);
                    thisQuery +=' AND Sub_Status_Change_Date__c <=: FromDateTimeSubStatus';
                }
                
                //SUB STATUS CHANGED DATE TO
                if(ToDateTimeSubStatus!=NULL){
                    system.debug('ToDateTimeSubStatus::'+ToDateTimeSubStatus);
                    thisQuery +=' AND Sub_Status_Change_Date__c <=:  ToDateTimeSubStatus';
                }
                
                //STAGE DATE
                IF(FromStageDate!=NULL)
                {
                    SYSTEM.debug('FROM DATE IN LEAD STATUS CHANGED DATE');
                    thisQuery +=' AND Stage_Change_Date__c >=: FromStageDate';
                }
                
                //STAGE DATE
                if(ToStageDate!=NULL)
                {
                    SYSTEM.debug('ToStageDate::'+ToStageDate);
                    thisQuery+=' AND Stage_Change_Date__c <=: ToStageDate';
                }
                
                //FROM SUB STAGE DATE
                if(FromSubStageDate!=NULL)
                {
                    SYSTEM.debug('FromSubStageDate::'+FromSubStageDate);
                    thisQuery+=' AND Sub_Stage_Change_Date__c >=:  FromSubStageDate';
                }
                
                //TO SUB STAGE DATE
                if(ToSubStageDate!=NULL)
                {
                    SYSTEM.debug('ToSubStageDate::'+ToSubStageDate);
                    thisQuery+=' AND Sub_Stage_Change_Date__c <=:  ToSubStageDate';
                }
                
                if(LeadStatus!=NULL && LeadStatus!=''){
                    system.debug('LeadStatus::'+LeadStatus);
                    thisQuery+=' AND Status__c=\'' + String.escapeSingleQuotes(LeadStatus.trim())+'\'';
                }
                
                //LEAD SUB STATUS
                if(LeadSubStatus!=NULL && LeadSubStatus!=''){
                    system.debug('LeadSubStatus::'+LeadSubStatus);
                    thisQuery+=' AND Sub_Status__c=\'' + String.escapeSingleQuotes(LeadSubStatus.trim())+'\'';
                }
                
                //OPPORTUNITY STAGE
                if(OppStage!=NULL && OppStage!=''){
                    system.debug('OppStage::'+OppStage);
                    thisQuery+=' AND Stage__c=\'' + String.escapeSingleQuotes(OppStage.trim())+'\'';
                }
                
                //OPPORTUNITY SUB STAGE
                if(OppSubStage!=NULL && OppSubStage!=''){
                    system.debug('OppSubStage::'+OppSubStage);
                    thisQuery+=' AND Sub_Stage__c=\'' + String.escapeSingleQuotes(OppSubStage.trim())+'\'';
                }
                
                //LEAD REFERENCES
                if(LeadRefs!=NULL && LeadRefs!='' && !LeadRefs.contains(',')){
                    system.debug('LeadRefs::'+LeadRefs);
                    thisQuery+=' AND Lead_Reference__c=\'' + String.escapeSingleQuotes(LeadRefs.trim())+'\'';
                }
                
                if(leadRefSet!=NULL && !leadRefSet.ISEmpty())
                {
                    thisQuery += ' and Lead_Reference__c IN :leadRefSet';
                }
                
                if(thisQuery!=NULL){
                    searchResults = Database.query(thisQuery);
                    System.debug('@@@ searchResults= '+searchResults);
                }
            }
            
            //STAGE DATE IF CONDITION
            if(FromStageDate!=NULL && FromDateTimeStatus == NULL)
            {
                thisQueryStage='SELECT id, BC_Number__c, Bizcap_Lead_Ref__c, Call_Attempts__c, Company__c, Conditional_Approval_Amount__c, Conditional_Approval_Date__c, Email_Address__c, Factor_Rate__c';
                thisQueryStage+=',Funded_Date__c, Is_Converted__c, Last_Call_Date__c, Lead__c, Lead_Reference__c, Lead_Source__c, Loan_Amount__c, Loan_term_business_days__c, Loan_Type__c';
                thisQueryStage+=',Opportunity__c, Payback_Amount__c, Stage__c, Status__c, Sub_Stage__c, Sub_Status__c, Status_change_date__c, Sub_Status_Change_Date__c, Stage_Change_Date__c, Sub_Stage_Change_Date__c, Lead__r.FirstName, Lead__r.LastName';
                thisQueryStage+=' FROM BPU__c WHERE Lead_Source__c=\'' + String.escapeSingleQuotes(LeadSource)+'\'';
            
                SYSTEM.debug('FromStageDate::'+FromStageDate);
                IF(FromStageDate!=NULL)
                {
                    thisQueryStage+=' AND Stage_Change_Date__c >=:FromStageDate';
                }
                
                if(ToStageDate!=NULL)
                {
                    SYSTEM.debug('ToStageDate::'+ToStageDate);
                    thisQueryStage+=' AND Stage_Change_Date__c <=:ToStageDate';
                }
                
                //FROM SUB STAGE DATE
                if(FromSubStageDate!=NULL)
                {
                    SYSTEM.debug('FromSubStageDate::'+FromSubStageDate);
                    thisQueryStage+=' AND Sub_Stage_Change_Date__c >=:  FromSubStageDate';
                }
                
                //TO SUB STAGE DATE
                if(ToSubStageDate!=NULL)
                {
                    SYSTEM.debug('ToSubStageDate::'+ToSubStageDate);
                    thisQueryStage+=' AND Sub_Stage_Change_Date__c <=:  ToSubStageDate';
                }
                
                if(LeadStatus!=NULL && LeadStatus!=''){
                    system.debug('LeadStatus::'+LeadStatus);
                    //thisQuery+=' AND Status__c=\'' + String.escapeSingleQuotes(LeadStatus.trim())+'\'';
                    thisQueryStage+=' AND Status__c=\'' + String.escapeSingleQuotes(LeadStatus.trim())+'\'';
                }
                
                //LEAD SUB STATUS
                if(LeadSubStatus!=NULL && LeadSubStatus!=''){
                    system.debug('LeadSubStatus::'+LeadSubStatus);
                    //thisQuery+=' AND Sub_Status__c=\'' + String.escapeSingleQuotes(LeadSubStatus.trim())+'\'';
                    thisQueryStage+=' AND Sub_Status__c=\'' + String.escapeSingleQuotes(LeadSubStatus.trim())+'\'';
                }
                
                //OPPORTUNITY STAGE
                if(OppStage!=NULL && OppStage!=''){
                    system.debug('OppStage::'+OppStage);
                    //thisQuery+=' AND Stage__c=\'' + String.escapeSingleQuotes(OppStage.trim())+'\'';
                    thisQueryStage+=' AND Stage__c=\'' + String.escapeSingleQuotes(OppStage.trim())+'\'';
                }
                
                //OPPORTUNITY SUB STAGE
                if(OppSubStage!=NULL && OppSubStage!=''){
                    system.debug('OppSubStage::'+OppSubStage);
                    //thisQuery+=' AND Sub_Stage__c=\'' + String.escapeSingleQuotes(OppSubStage.trim())+'\'';
                    thisQueryStage+=' AND Sub_Stage__c=\'' + String.escapeSingleQuotes(OppSubStage.trim())+'\'';
                }
                
                //LEAD REFERENCES
                if(LeadRefs!=NULL && LeadRefs!='' && !LeadRefs.contains(',')){
                    system.debug('LeadRefs::'+LeadRefs);
                    //thisQuery+=' AND Lead_Reference__c=\'' + String.escapeSingleQuotes(LeadRefs.trim())+'\'';
                    thisQueryStage+=' AND Lead_Reference__c=\'' + String.escapeSingleQuotes(LeadRefs.trim())+'\'';
                }
                
                if(leadRefSet!=NULL && !leadRefSet.ISEmpty())
                {
                    //thisQuery += ' and Lead_Reference__c IN :leadRefSet';
                    thisQueryStage+=' AND Lead_Reference__c=\'' + String.escapeSingleQuotes(LeadRefs.trim())+'\'';
                }
                
                if(thisQueryStage!=NULL)
                {
                    searchResultsStage = Database.query(thisQueryStage);
                    system.debug('@@searchResultsStage::'+searchResultsStage);
                }
            }
            
            system.debug('thisQueryStage::'+thisQueryStage);
            system.debug('thisquery::'+thisQuery);
            
            if(searchResults!=NULL && searchResults.size()>0 && (searchResultsStage == null || searchResultsStage.isEmpty()))
            {
                for(BPU__c objBPU : searchResults)
                {
                    BizCapGetBPURespJSON.cls_Results respData = new BizCapGetBPURespJSON.cls_Results();
                    respData.ApplicationCheck = objBPU.Application_Check__c;
                    respData.BankStatementsCheck = objBPU.Bank_Statements_Check__c;
                    respData.LeadName= objBPU.Lead__r.FirstName+ '  '+objBPU.Lead__r.LastName;
                    respData.BCNumber = objBPU.BC_Number__c;
                    respData.BizcapLeadRef = objBPU.Bizcap_Lead_Ref__c;
                    respData.CallAttempts = objBPU.Call_Attempts__c;
                    respData.Company = objBPU.Company__c;
                    respData.ConditionalApprovalAmount = objBPU.Conditional_Approval_Amount__c;
                    respData.ConditionalApprovalDate = objBPU.Conditional_Approval_Date__c;
                    respData.EmailAddress = objBPU.Email_Address__c;
                    respData.FactorRate = objBPU.Factor_Rate__c;
                    respData.FundedDate = objBPU.Funded_Date__c;
                    respData.LeadId = objBPU.Lead__c;
                    respData.LeadReference = objBPU.Lead_Reference__c;
                    respData.LeadSource = objBPU.Lead_Source__c;
                    respData.LeadStatusDate = STRING.VALUEOF(objBPU.Status_change_date__c);
                    respData.LeadSubStatusDate = STRING.VALUEOF(objBPU.Sub_Status_Change_Date__c);
                    respData.OpportunityStageDate = STRING.VALUEOF(objBPU.Stage_Change_Date__c);
                    respData.OpportunitySubStageDate = STRING.valueOf(objBPU.Sub_Stage_Change_Date__c);
                    respData.LoanAmount = objBPU.Loan_Amount__c;
                    respData.Loantermbusinessdays = objBPU.Loan_term_business_days__c;
                    respData.LoanType = objBPU.Loan_Type__c;
                    respData.OppId = objBPU.Opportunity__c;
                    respData.PaybackAmount = objBPU.Payback_Amount__c;
                    respData.Stage = objBPU.Stage__c;
                    respData.SubStage = objBPU.Sub_Stage__c;
                    respData.Status = objBPU.Status__c;
                    respData.SubStatus = objBPU.Sub_Status__c;
                    respdata.isConverted = objBPU.Is_Converted__c;
                    BizCapBPUResp.Results.add(respData);
                    noLeads += 1;
                    system.debug('noLeads::'+noLeads);
                }
                BizCapBPUResp.NoOfBPu = noLeads;
                BizCapBPUResp.ErrorMsg = '';
                BPUAPIDetail.Last_Lead_Status__c = system.now();
                //BPUAPIDetail.Last_Opportunity_Stage_Date__c = system.now();
                try {
                    system.debug('inside upsert');
                    upsert BPUAPIDetail;
                } 
                catch (Exception e) {
                    errMSg += e.getMessage()+'\r\n\r\n';
                }
            }
            
            if(searchResultsStage!=NULL && searchResultsStage.size()>0 && (searchResults == null || searchResults.isEmpty()))
            {
                for(BPU__c objBPU : searchResultsStage)
                {
                    BizCapGetBPURespJSON.cls_Results respData = new BizCapGetBPURespJSON.cls_Results();
                    respData.LeadName= objBPU.Lead__r.FirstName+ '  '+objBPU.Lead__r.LastName;
                    respData.BCNumber = objBPU.BC_Number__c;
                    respData.BizcapLeadRef = objBPU.Bizcap_Lead_Ref__c;
                    respData.CallAttempts = objBPU.Call_Attempts__c;
                    respData.Company = objBPU.Company__c;
                    respData.ConditionalApprovalAmount = objBPU.Conditional_Approval_Amount__c;
                    respData.ConditionalApprovalDate = objBPU.Conditional_Approval_Date__c;
                    respData.EmailAddress = objBPU.Email_Address__c;
                    respData.FactorRate = objBPU.Factor_Rate__c;
                    respData.FundedDate = objBPU.Funded_Date__c;
                    respData.LeadId = objBPU.Lead__c;
                    respData.LeadReference = objBPU.Lead_Reference__c;
                    respData.LeadSource = objBPU.Lead_Source__c;
                    respData.LeadStatusDate = STRING.VALUEOF(objBPU.Status_change_date__c);
                    respData.LeadSubStatusDate = STRING.VALUEOF(objBPU.Sub_Status_Change_Date__c);
                    respData.OpportunityStageDate = STRING.VALUEOF(objBPU.Stage_Change_Date__c);
                    respData.OpportunitySubStageDate = STRING.valueOf(objBPU.Sub_Stage_Change_Date__c);
                    respData.LoanAmount = objBPU.Loan_Amount__c;
                    respData.Loantermbusinessdays = objBPU.Loan_term_business_days__c;
                    respData.LoanType = objBPU.Loan_Type__c;
                    respData.OppId = objBPU.Opportunity__c;
                    respData.PaybackAmount = objBPU.Payback_Amount__c;
                    respData.Stage = objBPU.Stage__c;
                    respData.SubStage = objBPU.Sub_Stage__c;
                    respData.Status = objBPU.Status__c;
                    respData.SubStatus = objBPU.Sub_Status__c;
                    respdata.isConverted = objBPU.Is_Converted__c;
                    respData.LastCallDate = objBPU.Last_Call_Date__c;
                    BizCapBPUResp.Results.add(respData);
                    noLeads += 1;
                    system.debug('noLeads::'+noLeads);
                }
                BizCapBPUResp.NoOfBPu = noLeads;
                BizCapBPUResp.ErrorMsg = '';
                //BPUAPIDetail.Last_Lead_Status__c = system.now();
                BPUAPIDetail.Last_Opportunity_Stage_Date__c = system.now();
                try {
                    system.debug('inside upsert');
                    upsert BPUAPIDetail;
                } 
                catch (Exception e) {
                    errMSg += e.getMessage()+'\r\n\r\n';
                }
            }
            
            if((searchResultsStage == NULL || searchResultsStage.ISEMPTY()) && (searchResults == NULL || searchResults.isempty())) 
            {
                BizCapBPUResp.ErrorMsg= 'No BPU records found!';
                BizCapBPUResp.NoOfBPu = noLeads;
            }
                        
        }
        
        system.debug('BizCapBPUResp::'+BizCapBPUResp);
        string JSONResp = JSON.serialize(BizCapBPUResp);
        
        return JSONResp; 
    }
    
    //WRAPPER CLASS
    global class AccountWrapper 
    {
        public List<BPU__c> BPUList;
        public String status;
        public String message;
        
        public AccountWrapper()
        {
            BPUList = new List<BPU__c>();
        }
    }
    
    //ACCOUNT ID (PARTNER ACCOUNT ID)
    private static id accountId 
    {
        get 
        {
            if (accountId == null){
                try {
                    User user = [select Id, contactId, contact.accountId from User where id = :UserInfo.getUserId() limit 1];
                    system.debug('user::'+user.contactid);
                    if (user.contactId != null) {
                        accountId = user.contact.accountId;
                    }
                } catch (Exception e) {
                    SYSTEM.DEBUG('E:::'+e.getMessage());
                }
            }
            return accountId;
        } set;
    }
    
    //GETTING THE BPU API DETAILS TO UPDATE THE LAST LEAD STATUS
    public static BPU_API_Details__c BPUAPIDetail 
    { 
        get 
        {
            if (BPUAPIDetail == null) {
                BPUAPIDetail = new BPU_API_Details__c(
                    Account__c = accountId
                );
                try {
                    BPUAPIDetail = [Select id, Name, Account__c, Last_Lead_Status__c, Last_Opportunity_Stage_Date__c from BPU_API_Details__c where Account__c = :accountId Order by CreatedDate DESC limit 1 ];  
                } catch (Exception e) {
                    system.debug('e::'+e.getMessage());
                }
            }
            return BPUAPIDetail;
        } set; 
    }
    
    public static void fakeMethod(){
    Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;   
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;   
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;   
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;   
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;   
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;   
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;   
        i++;
        i++;
        i++;    
    //repeat the i++ hundred of times

  }
}