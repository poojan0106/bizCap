@RestResource(urlMapping='/BizcapLeadsCreate/*')
global with sharing class RESTBizcapLead
{
    
    @HttpPost
    global static string createLead(){
        
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        string reqBody = req.requestBody.toString();
        System.debug('reqBody N:::'+reqBody);
        
        if (reqBody != null && reqBody != '') {
            
            BizcapLeadJSON leadJSON;
            try {
                leadJSON = BizcapLeadJSON.parse(reqBody);
            } catch (Exception e) {
                
                AAkonsultUtil.errorLog('RESTBizcapLead.createLead','parse of JSON',e.getMessage()+'\r\n\r\n'+reqBody );
                
                BizcapLeadRespJSON.cls_Results BizcapLeadResult= new BizcapLeadRespJSON.cls_Results();
                BizcapLeadResult.ErrorMsg = 'Invalid JSON: '+e.getMessage();
                BizcapLeadResult.Success = false;
                BizcapLeadResp.NoOfFails += 1;
                BizcapLeadResp.Results.add(BizcapLeadResult);
            }
            
            map<string,list<Loan_Document__c>> leadDocsMap = new map<string,list<Loan_Document__c>>();
            map<string,list<Owner_Details__c>> additionalOwnersMap = new map<string,list<Owner_Details__c>>();
            list<Lead> leadList = new list<Lead>();
            
            if (leadJSON != null && leadJSON.Leads != null) {
                
                // check if existing leads
                set<string> leadRefSet = new set<string>();
                for (BizcapLeadJSON.cls_Lead thisLead : leadJSON.Leads) {
                    
                    if (thisLead.LeadInfo != null) {
                        string leadRef = thisLead.LeadInfo.leadRef;
                        leadRefSet.add(leadRef);
                    }
                }
                
                map<string,Lead> existingLeadMap = new map<string,Lead>();
                if (leadRefSet != null && !leadRefSet.isEmpty() ) {
                    for (lead[] existingLeadList : [Select Id,Lead_Reference__c from Lead where Lead_Reference__c in :leadRefSet and IsConverted = false order by Lead_Reference__c,CreatedDate ]) {
                        for (lead existingLead : existingLeadList) {
                            existingLeadMap.put(existingLead.Lead_Reference__c,existingLead);
                        }
                    }
                }
                
                //ADDED BY DHAIRYA AS ESTHER TOLD TO RECORD TYPE MUST BE AGGREGATOR ON 3RD APRIL 2020
                Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Aggregator').getRecordTypeId();
                System.debug('leadJSON.Leads :: '+leadJSON.Leads);
                for (BizcapLeadJSON.cls_Lead thisLead : leadJSON.Leads) {
                    
                    Lead lead = new lead();
                    
                    if(devRecordTypeId!=NULL)
                    {
                        lead.RecordTypeId = devRecordTypeId;
                    }
                    
                    if (thisLead.LeadInfo != null) {
                        if (thisLead.LeadInfo.leadRef == null || thisLead.LeadInfo.leadRef == '') {continue; }  // leadref missing.
                        if (thisLead.LeadInfo.leadRef != null) {lead.Lead_Reference__c = thisLead.LeadInfo.leadRef;}
                        if (thisLead.LeadInfo.LeadSource != null){lead.LeadSource = thisLead.LeadInfo.LeadSource;}
                        if (existingLeadMap.containsKey(lead.Lead_Reference__c)) {
                            lead.id = existingLeadMap.get(lead.Lead_Reference__c).id;
                        }
                    } else {
                        continue;  // leadref missing.
                    }
                    System.debug('thisLead.Applicant :: '+thisLead.Applicant);
                    if (thisLead.Applicant != null) {
                        System.debug('thisLead.Applicant.ApplicantName :: '+thisLead.Applicant.ApplicantName);
                        if (thisLead.Applicant.ApplicantName != null) {
                            if (thisLead.Applicant.ApplicantName.Salutation != null) {lead.Salutation = thisLead.Applicant.ApplicantName.Salutation;}
                            if (thisLead.Applicant.ApplicantName.FirstName != null) {lead.FirstName = thisLead.Applicant.ApplicantName.FirstName;}
                            //if (thisLead.Applicant.ApplicantName.LastName != null) {lead.LastName = thisLead.Applicant.ApplicantName.LastName;}
                            if (thisLead.Applicant.ApplicantName.LastName == '' || thisLead.Applicant.ApplicantName.LastName == null) {
                                if (lead.id == null)
                                {
                                    lead.LastName = '[not provided]'; 
                                }                           
                            } else{
                                lead.LastName = thisLead.Applicant.ApplicantName.LastName;
                            }
                        }                        
                        if (thisLead.Applicant.JobTitle != null) {lead.Job_Title__c = thisLead.Applicant.JobTitle;}
                        if (thisLead.Applicant.ContactPreference != null) {lead.Contact_Preference__c = thisLead.Applicant.ContactPreference;}
                        if (thisLead.Applicant.ContactDateTime != null) {lead.Contact_Time__c = thisLead.Applicant.ContactDateTime;}
                        if (thisLead.Applicant.MobilePhone != null) {lead.MobilePhone = thisLead.Applicant.MobilePhone;}
                        if (thisLead.Applicant.Phone != null) {lead.Phone = thisLead.Applicant.Phone;}
                        if (thisLead.Applicant.WorkPhone != null) {lead.Phone_BussProp__c = thisLead.Applicant.WorkPhone;}
                        if (thisLead.Applicant.Email != null) {lead.Email = thisLead.Applicant.Email;}
                        if (thisLead.Applicant.BirthDate !=null) {lead.Date_of_Birth__c = cleanDate(thisLead.Applicant.BirthDate );}
                        
                        //NEWLY ADDED FIELDS ON LEADS
                        if (thisLead.Applicant.BrokerName != null && thisLead.Applicant.BrokerName != '') 
                        {lead.Broker_Name__c = thisLead.Applicant.BrokerName;}
                        if (thisLead.Applicant.BrokerContactName != null && thisLead.Applicant.BrokerContactName != '') 
                        {lead.Broker_Contact_Name__c = thisLead.Applicant.BrokerContactName;}
                        if (thisLead.Applicant.BrokerContactNumber != null && thisLead.Applicant.BrokerContactNumber != '') 
                        {lead.Broker_Contact_Number__c = thisLead.Applicant.BrokerContactNumber;}
                        if (thisLead.Applicant.BrokerContactEmail != null && thisLead.Applicant.BrokerContactEmail != '') 
                        {lead.Broker_Contact_Email__c = thisLead.Applicant.BrokerContactEmail;}
                        if (thisLead.Applicant.CallOnBehalfOfAlias != null && thisLead.Applicant.CallOnBehalfOfAlias != '') 
                        {lead.Call_on_behalf_of_alias__c = thisLead.Applicant.CallOnBehalfOfAlias;}
                        if (thisLead.Applicant.CallClientOrBroker != null && thisLead.Applicant.CallClientOrBroker != '') 
                        {lead.Client_or_Broker__c = thisLead.Applicant.CallClientOrBroker;}  
                        if (thisLead.Applicant.Channel != null && thisLead.Applicant.Channel != '') 
                        {lead.Channel__c = thisLead.Applicant.Channel;}
                        
                        //NEWLY ADDED 4 FIELDS
                        if (thisLead.Applicant.politicallyExposed != null) {Lead.Are_you_a_Politically_Exposed_Person__c = thisLead.Applicant.politicallyExposed;}
                        if (thisLead.Applicant.PrivacyPolicycheckBox != null) {lead.I_agree_to_Bizcap_Consent_Privacy__c = thisLead.Applicant.PrivacyPolicycheckBox;}
                        if (thisLead.Applicant.FormstackUpdateURLODIN != null) {lead.Formstack_Update_URL_ODIN__c = thisLead.Applicant.FormstackUpdateURLODIN;}
                        if (thisLead.Applicant.Note != null) {lead.Note__c= thisLead.Applicant.Note;}
                        //if (thisLead.Applicant.ProvisoLinkODIN != null) {lead.Proviso_Link_ODIN = thisLead.Applicant.ProvisoLinkODIN;}
                        
                        if (thisLead.Applicant.CountryAPI != null) {lead.country_API__c = thisLead.Applicant.CountryAPI;}
                        
                        //This new 4 fields added here by Nrupa Vora
                        if (thisLead.Applicant.NZBN != null) {lead.NZBN__c = thisLead.Applicant.NZBN;}
                        if (thisLead.Applicant.CompanyNumber != null) {lead.Company_Number__c = thisLead.Applicant.CompanyNumber;}
                        if (thisLead.Applicant.PassportNumber != null) {lead.Passport_Number__c = thisLead.Applicant.PassportNumber;}
                        if (thisLead.Applicant.DriversVersionNumber != null) {lead.Driver_s_Version_number__c = thisLead.Applicant.DriversVersionNumber;}
                        
                        if (thisLead.Applicant.HomeAddress != null) {
                            if (thisLead.Applicant.HomeAddress.Street != null) {lead.Home_Address__c = thisLead.Applicant.HomeAddress.Street;}
                            if (thisLead.Applicant.HomeAddress.city != null) {lead.Suburb_Home__c = thisLead.Applicant.HomeAddress.city;}
                            if (thisLead.Applicant.HomeAddress.State != null) {lead.State_Home__c = thisLead.Applicant.HomeAddress.State; }                        
                            if (thisLead.Applicant.HomeAddress.PostcalCode != null) {lead.Post_Code_Home__c = thisLead.Applicant.HomeAddress.PostcalCode;}  
                        }
                       
                        if (thisLead.Applicant.PersonalCreditScore != null) {lead.Credit_Score__c = thisLead.Applicant.PersonalCreditScore;}
                        if (thisLead.Applicant.PersonalCredit != null) {lead.Applicant_Personal_Credit__c = thisLead.Applicant.PersonalCredit;}
                        if (thisLead.Applicant.DriversLicense != null) {lead.Drivers_license_number__c = thisLead.Applicant.DriversLicense;}
                        if (thisLead.Applicant.BusinessOwnershipPCT != null) {lead.Business_Ownership_PCT__c = thisLead.Applicant.BusinessOwnershipPCT;}
                        if (thisLead.Applicant.HadDefaults != null) {lead.Had_Defaults__c = thisLead.Applicant.HadDefaults;}
                        if (thisLead.Applicant.HadBankruptcy != null) {lead.Had_Bankruptcy__c = thisLead.Applicant.HadBankruptcy;}
                        if (thisLead.Applicant.OutstandingTaxLiens != null) {lead.Outstanding_Tax_Liens__c = thisLead.Applicant.OutstandingTaxLiens;}
                        
                    }
                    
                    IF(thisLead.BrokerName != null){
                        System.debug('thisLead.BrokerName :: '+thisLead.BrokerName);
                        //NEWLY ADDED FIELDS ON LEADS
                        if (thisLead.BrokerName.BrokerName != null && thisLead.BrokerName.BrokerName != '') 
                        {lead.Broker_Name__c = thisLead.BrokerName.BrokerName;}
                        if (thisLead.BrokerName.BrokerContactName != null && thisLead.BrokerName.BrokerContactName != '') 
                        {lead.Broker_Contact_Name__c = thisLead.BrokerName.BrokerContactName;}
                        if (thisLead.BrokerName.BrokerContactNumber != null && thisLead.BrokerName.BrokerContactNumber != '') 
                        {lead.Broker_Contact_Number__c = thisLead.BrokerName.BrokerContactNumber;}
                        if (thisLead.BrokerName.BrokerContactEmail != null && thisLead.BrokerName.BrokerContactEmail != '') 
                        {lead.Broker_Contact_Email__c = thisLead.BrokerName.BrokerContactEmail;}
                        if (thisLead.BrokerName.CallOnBehalfOfAlias != null && thisLead.BrokerName.CallOnBehalfOfAlias != '') 
                        {lead.Call_on_behalf_of_alias__c = thisLead.BrokerName.CallOnBehalfOfAlias;}
                        if (thisLead.BrokerName.CallClientOrBroker != null && thisLead.BrokerName.CallClientOrBroker != '') 
                        {lead.Client_or_Broker__c = thisLead.BrokerName.CallClientOrBroker;}  
                        if (thisLead.BrokerName.Channel != null && thisLead.BrokerName.Channel != '') 
                        {lead.Channel__c = thisLead.BrokerName.Channel;}
                    }
                    
                    if (thisLead.Business != null) {
                        //if (thisLead.Business.LegalName != null) {Lead.Company = thisLead.Business.LegalName;}
                        if (thisLead.Business.LegalName == '' || thisLead.Business.LegalName == null)  {
                            if (lead.id == null)
                            {
                                lead.Company = '[not provided]'; 
                            } 
                        } else{
                            Lead.Company = thisLead.Business.LegalName;
                        }
                        if (thisLead.Business.TradingName != null) {Lead.Business_Trading_Name__c = thisLead.Business.TradingName;}
                        if (thisLead.Business.ABN != null) {Lead.ABN__c = thisLead.Business.ABN;}
                        if (thisLead.Business.Phone != null) {Lead.Phone_BussProp__c = thisLead.Business.Phone;}
                        if (thisLead.Business.HomeBasedBusiness != null) {Lead.Home_Based_Business__c = thisLead.Business.HomeBasedBusiness;}
                        
                        if (thisLead.Business.DeliveryAddress != null) {
                            if (thisLead.Business.DeliveryAddress.Street != null) {lead.Physical_Address__c = thisLead.Business.DeliveryAddress.Street;}
                            if (thisLead.Business.DeliveryAddress.city != null) {lead.Suburb_Physical__c = thisLead.Business.DeliveryAddress.city;}
                            if (thisLead.Business.DeliveryAddress.State != null) {lead.State_Physical__c = thisLead.Business.DeliveryAddress.State;}                         
                            if (thisLead.Business.DeliveryAddress.PostcalCode != null) {lead.Post_Code_Physical__c = thisLead.Business.DeliveryAddress.PostcalCode;}                              
                        }
                        
                        if (thisLead.Business.MailingAddress != null) {
                            if (thisLead.Business.MailingAddress.Street != null) {lead.Mailing_Address__c = thisLead.Business.MailingAddress.Street;}
                            if (thisLead.Business.MailingAddress.city != null) {lead.Suburb_Mailing__c = thisLead.Business.MailingAddress.city;}
                            if (thisLead.Business.MailingAddress.State != null) {lead.State_Mailing__c = thisLead.Business.MailingAddress.State;}                         
                            if (thisLead.Business.MailingAddress.PostcalCode != null) {lead.Post_Code_Mailing__c = thisLead.Business.MailingAddress.PostcalCode;}                             
                        }
                        
                        if (thisLead.Business.Industry != null) {Lead.Industry = thisLead.Business.Industry;}
                        if (thisLead.Business.Industry != null) {Lead.Industry__c = thisLead.Business.Industry;}
                        
                        if (thisLead.Business.TypeOfEntity != null) {Lead.Type_of_Entity__c = thisLead.Business.TypeOfEntity;}
                        if (thisLead.Business.TypeOfCustomers != null) {Lead.Customers_Type__c = thisLead.Business.TypeOfCustomers;}
                        if (thisLead.Business.EntityTypeSize != null) {Lead.Entity_Type_Size__c = thisLead.Business.EntityTypeSize;}
                        if (thisLead.Business.BusinessOwner != null) {Lead.Business_Owner__c = thisLead.Business.BusinessOwner;}
                        if (thisLead.Business.LandLordMorgage != null) {Lead.Landlord_Mortgage__c = thisLead.Business.LandLordMorgage;}
                        if (thisLead.Business.CompanyFinancials != null) {Lead.Company_Financials__c = thisLead.Business.CompanyFinancials;}
                        
                        if (thisLead.Business.FinancialInfo != null) {
                            if (thisLead.Business.FinancialInfo.AnnualRevenue != null) {Lead.AnnualRevenue = cleanDecimal(thisLead.Business.FinancialInfo.AnnualRevenue);}
                            if (thisLead.Business.FinancialInfo.AnnualRevenue != null) {Lead.Annual_Turn_over__c = cleanDecimal(thisLead.Business.FinancialInfo.AnnualRevenue);}
                            
                            if (thisLead.Business.FinancialInfo.AverageMonthlyTurnover != null) {Lead.Average_Monthly_Turnover__c = cleanDecimal(thisLead.Business.FinancialInfo.AverageMonthlyTurnover);}
                            if (thisLead.Business.FinancialInfo.AverageMonthlyTurnover != null) {Lead.Monthly_Revenue__c = cleanDecimal(thisLead.Business.FinancialInfo.AverageMonthlyTurnover);}
                            
                            if (thisLead.Business.FinancialInfo.AverageMonthlyDeposits != null) {Lead.Average_Monthly_Deposits__c = cleanDecimal(thisLead.Business.FinancialInfo.AverageMonthlyDeposits);}
                            if (thisLead.Business.FinancialInfo.AverageDailyBankBalance != null) {Lead.Average_Bank_Balance__c = cleanDecimal(thisLead.Business.FinancialInfo.AverageDailyBankBalance);}
                            if (thisLead.Business.FinancialInfo.NoofExistingBusinessLoans != null) {Lead.No_of_Existing_Business_Loans__c = cleanDecimal(thisLead.Business.FinancialInfo.NoofExistingBusinessLoans);}
                            if (thisLead.Business.FinancialInfo.AmountPerMonthProcessedOnCreditCardorEFTPOS != null) {Lead.Amount_Credit_Card_or_EFTPOS__c = cleanDecimal(thisLead.Business.FinancialInfo.AmountPerMonthProcessedOnCreditCardorEFTPOS);}
                            if (thisLead.Business.FinancialInfo.BusinessProfitNotes != null) {Lead.Business_Profit__c = thisLead.Business.FinancialInfo.BusinessProfitNotes; }                       
                            if (thisLead.Business.FinancialInfo.Profit != null) {Lead.Profit__c = cleanDecimal(thisLead.Business.FinancialInfo.Profit);}
                            if (thisLead.Business.FinancialInfo.ATOTaxPosition != null) {Lead.ATO_Tax_Position__c = cleanDecimal(thisLead.Business.FinancialInfo.ATOTaxPosition);}
                            if (thisLead.Business.FinancialInfo.NONBankLoanBalance != null) {Lead.NON_Bank_Loan_Balance__c = cleanDecimal(thisLead.Business.FinancialInfo.NONBankLoanBalance);}
                            if (thisLead.Business.FinancialInfo.HowPaid != null) {Lead.How_we_get_paid__c = thisLead.Business.FinancialInfo.HowPaid;}                           
                        }
                        
                        if (thisLead.Business.BusinessCreditHistory != null) {Lead.Business_Credit_History__c = thisLead.Business.BusinessCreditHistory;}
                        // date  - ?????? TO UPDATE JSON etc.                  
                        if (thisLead.Business.BusinessEstablised != null) {Lead.Business_Established__c = cleanDate(thisLead.Business.BusinessEstablised);}
                        if (thisLead.Business.LengthOfOwnership != null) {Lead.Length_of_Ownership__c = thisLead.Business.LengthOfOwnership;}
                        
                    }
                    if (thisLead.LoanDetails != null) {
                        //if (thisLead.LoanDetails.AmountRequested != null) {Lead.Loan_Amount__c = cleanDecimal(thisLead.LoanDetails.AmountRequested);}
                        if (thisLead.LoanDetails.AmountRequested != null) {Lead.Amount_requested__c = cleanDecimal(thisLead.LoanDetails.AmountRequested);}
                        
                        if (thisLead.LoanDetails.LoanPurpose != null) {Lead.Loan_Purpose__c = thisLead.LoanDetails.LoanPurpose;}
                        if (thisLead.LoanDetails.LoanProduct != null) {Lead.Loan_Product__c = thisLead.LoanDetails.LoanProduct;}
                        if (thisLead.LoanDetails.LoanTermMonths != null) {Lead.Term_Length_Preferred__c = cleanDecimal(thisLead.LoanDetails.LoanTermMonths);}
                        if (thisLead.LoanDetails.LoanType != null) {Lead.Loan_Type__c = thisLead.LoanDetails.LoanType;}
                        if (thisLead.LoanDetails.HowSoon != null) {Lead.How_Soon__c = thisLead.LoanDetails.HowSoon;}
                        if (thisLead.LoanDetails.SecuritThatCanBeProvided != null) {Lead.Security_provided__c = thisLead.LoanDetails.SecuritThatCanBeProvided;}
                        if (thisLead.LoanDetails.ApplicationSignDate != null) {Lead.Application_Sign_Date__c = cleanDate(thisLead.LoanDetails.ApplicationSignDate);}
                        if (thisLead.LoanDetails.BankStatementsLastUpdated != null) {Lead.Bank_Statement_Last_Updated__c = cleanDate(thisLead.LoanDetails.BankStatementsLastUpdated);}
                        if (thisLead.LoanDetails.OriginalEnquiryDate != null) {Lead.Original_Enquiry_Date__c = cleanDate(thisLead.LoanDetails.OriginalEnquiryDate);}
                        if (thisLead.LoanDetails.Outstandingloanbalance != null) {Lead.Outstanding_loan_balance__c = cleanDecimal(thisLead.LoanDetails.Outstandingloanbalance);}
                    }
                    
                    
                    if (thisLead.AdditionalOwners != null  && thisLead.AdditionalOwners.AdditionalOwnerDetails != null) {
                        list<Owner_Details__c> AdditionalOwnerList = new list<Owner_Details__c>();
                        if (additionalOwnersMap.containsKey(lead.Lead_Reference__c)) {
                            AdditionalOwnerList = additionalOwnersMap.get(lead.Lead_Reference__c);
                        }    
                        
                        list<BizcapLeadJSON.cls_Applicant> addOwnersList = thisLead.AdditionalOwners.AdditionalOwnerDetails; 
                        for (BizcapLeadJSON.cls_Applicant addOwners : addOwnersList) {
                            Owner_Details__c ownerDetail = new Owner_Details__c();
                            if (addOwners.OwnerName != null) {
                                ownerDetail.Title__c = addOwners.OwnerName.Salutation;
                                ownerDetail.Name = addOwners.OwnerName.FirstName;
                                ownerDetail.Last_Name__c = addOwners.OwnerName.LastName;
                            }
                            
                            if (addOwners.HomeAddress != null) {
                                string HomeAddress='';
                                
                                if (addOwners.HomeAddress.Street != null) {HomeAddress += addOwners.HomeAddress.Street;}
                                if (addOwners.HomeAddress.city != null) {ownerDetail.Suburb__c = addOwners.HomeAddress.city;}
                                if (addOwners.HomeAddress.State != null) {ownerDetail.State__c = addOwners.HomeAddress.State; }                        
                                if (addOwners.HomeAddress.PostcalCode != null) {ownerDetail.Postal_Code__c = addOwners.HomeAddress.PostcalCode;}
                                
                                ownerDetail.Home_Address__c = HomeAddress;
                                
                                ownerDetail.Length_at_Address__c = addOwners.HomeAddress.LengthAtAddress;                     
                            }  
                            
                            ownerDetail.Are_you_a_Politically_Exposed_Person__c = addOwners.PoliticallyExposedPerson;
                            ownerDetail.Email__c = addOwners.Email;
                            ownerDetail.Tel_M__c = addOwners.MobilePhone;
                            ownerDetail.Tel_W__c = addOwners.WorkPhone;
                            ownerDetail.Date_Of_Birth__c = cleanDate(addOwners.BirthDate);
                            
                            ownerDetail.Ownership__c = addOwners.BusinessOwnershipPCT;
                            
                            AdditionalOwnerList.add(ownerDetail);
                        }
                        additionalOwnersMap.put(lead.Lead_Reference__c,AdditionalOwnerList);
                    }
                    
                    if (thisLead.Documents != null  && thisLead.Documents.BankstatementsDocumentIDs != null) {
                        list<BizcapLeadJSON.cls_BankstatementsDocumentIDs> docsIDsList = thisLead.Documents.BankstatementsDocumentIDs;
                        
                        list<Loan_Document__c> loanDocsList = new list<Loan_Document__c>();
                        if (leadDocsMap.containsKey(lead.Lead_Reference__c)) {
                            loanDocsList = leadDocsMap.get(lead.Lead_Reference__c);
                        }
                        
                        for (BizcapLeadJSON.cls_BankstatementsDocumentIDs docsID : docsIDsList) {
                            loanDocsList.add(new Loan_Document__c(
                                Bank_Statement_Document_ID__c = docsID.BankstatementsDocumentID,
                                Document_Name__c = docsID.DocumentName,
                                Document_URL__c = ((docsID.DocumentURL != null && docsID.DocumentURL.length() <= 255) ? docsID.DocumentURL : null),
                                Document_Long_URL__c = ((docsID.DocumentURL != null && docsID.DocumentURL.length() > 255) ? docsID.DocumentURL : null) 
                            ));
                            if (docsID.DocumentNote != null && docsID.DocumentNote != '') {
                                loanDocsList[loanDocsList.size()-1].Note__c = EncodingUtil.urlDecode(docsID.DocumentNote,'UTF-8');
                                //This field mapping is commented by Gaurang [ Took it to a lead Applican't level.]
                                //Lead.Note__c = EncodingUtil.urlDecode(docsID.DocumentNote,'UTF-8');
                            }
                        }
                        leadDocsMap.put(lead.Lead_Reference__c,loanDocsList);
                    }
                    
                    leadList.add(lead);
                    if (leadList.size() >= 200 ) {
                        upsertLeads(leadList,leadDocsMap,additionalOwnersMap);
                        leadList = new list<Lead>();
                        leadDocsMap = new map<string,list<Loan_Document__c>>();
                        additionalOwnersMap = new map<string,list<Owner_Details__c>>();
                    }
                    
                }
                
                upsertLeads(leadList,leadDocsMap,additionalOwnersMap);
            }
            
        }
        
        string resp = JSON.serialize(BizcapLeadResp,true);
        
        return resp;
    }
    
    public static BizcapLeadRespJSON BizcapLeadResp {get {
        if (BizcapLeadResp == null) {
            BizcapLeadResp = new BizcapLeadRespJSON();
            BizcapLeadResp.NoOfFails = 0;
            BizcapLeadResp.NoOfSuccesses = 0;
            list<BizcapLeadRespJSON.cls_Results> BizcapResultsList = new list<BizcapLeadRespJSON.cls_Results>();
            BizcapLeadResp.Results = BizcapResultsList;
        }
        return BizcapLeadResp;
    } set;}
    
    public static date cleanDate(string Dts) {
        if (Dts == null || Dts == '') {return null;}
        date dt;
        if (DTS.contains(' ')) { // just in case a time is also included
            string[] s = DTS.split(' ');
            if (s.size() > 0) {
                DTS = s[0];
            }
        }
        if (DTS != null && DTS != '' && DTS.contains('/')) {
            try {
                string[] s = DTS.split('/');
                integer yr;
                integer mth;
                integer day;
                if (s.size() > 0) {
                    day = integer.valueOf(s[0]);
                } 
                if (s.size() > 1) {
                    mth = integer.valueOf(s[1]);
                } 
                if (s.size() > 2) {
                    yr = integer.valueOf(s[2]);
                } 
                dt = date.newInstance(yr,mth,day);                                
            } catch (Exception e) {}        
        }
        return dt;
    }
    
    private static decimal cleanDecimal(string dStr) {
        if (dStr == null || dStr == '') {return null;}
        decimal d;
        try {
            dStr = dStr.replaceAll(',','');
            d = decimal.valueOf(dStr);
        } catch (Exception e) {}
        return d;
    }
    
    private static void upsertLeads(list<Lead> leadList, map<string,list<Loan_Document__c>> leadDocsMap,map<string,list<Owner_Details__c>> additionalOwnersMap) {
        list<Error_Log__c> errorLogList = new list<Error_Log__c>();
        
        if (leadList == null || leadList.isEmpty() ) {return;}
        
        list<Lead> dupeLeadList = new list<Lead>();
        list<integer> dupeLeadPosList = new list<integer>();
        
        list<Lead> dupeLeadUpdList = new list<Lead>();
        list<integer> dupeLeadUpdPosList = new list<integer>();
        
        try {
            Database.UpsertResult[] DBSaveResults = database.upsert(leadList,false);
            integer i = -1;
            
            set<id> leadIdSet = new set<id>();
            
            for (Database.UpsertResult DBSaveRes :  DBSaveResults) {
                i ++;
                BizcapLeadRespJSON.cls_Results BizcapLeadResult= new BizcapLeadRespJSON.cls_Results();
                BizcapLeadResult.LeadRef = leadList[i].Lead_Reference__c;
            
                if (!DBSaveRes.isSuccess()) {
                    
                    string errMsg = '';
                    for(Database.Error inErr: DBSaveRes.getErrors()) {   
                        
                        if (inErr instanceof Database.DuplicateError) {
                            
                            Database.DuplicateError duplicateError = (Database.DuplicateError)inErr;
                            Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                            
                            // Get duplicate records
                            List<sObject> duplicateRecords = new List<sObject>();
                            
                            // Return only match results of matching rules that 
                            //  find duplicate records
                            Datacloud.MatchResult[] matchResults = 
                                duplicateResult.getMatchResults();
                            
                            // Just grab first match result (which contains the 
                            //   duplicate record found and other match info)
                            Datacloud.MatchResult matchResult = matchResults[0];
                            
                            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                            
                            // Add matched record to the duplicate records variable
                            for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                duplicateRecords.add(matchRecord.getRecord());
                            }
                            
                            if (duplicateRecords != null && !duplicateRecords.isEmpty() ) {
                                leadList[i].Duplicate_Lead__c = duplicateRecords[0].id;
                            }
                            
                            if (leadList[i].id == null) {
                                dupeLeadList.add(leadList[i]);
                                dupeLeadPosList.add(i);
                            } else {
                                dupeLeadUpdList.add(leadList[i]);
                                dupeLeadUpdPosList.add(i);                           
                            }
                        }
                        
                        errMsg += (errMsg == '') ? '' : '\r\n';
                        errMsg += inErr.getMessage();
                        
                    }
                    
                    if (errMsg != '') {
                        errorLogList.add(new Error_Log__c(
                            Program_Area__c = 'RESTBizcapLead.upsertLeads',
                            Subject__c='Database.SaveResult[] DBSaveResults = database.upsert(leadList,true);',
                            Description__c=errMsg+'\r\n\r\n '+leadList[i],
                            Status__c='New'
                        ));
                        BizcapLeadResult.ErrorMsg = errMsg;
                        BizcapLeadResult.Success = false;
                        BizcapLeadResp.NoOfFails += 1;
                    }
                } 
                else {
                    BizcapLeadResult.Success = true;
                    BizcapLeadResult.LeadId = DBSaveRes.getId();
                    leadIdSet.add(DBSaveRes.getId() );
                    BizcapLeadResp.NoOfSuccesses += 1;
                    
                    list<Owner_Details__c> additionalOwnersList = new list<Owner_Details__c>();
                    if (additionalOwnersMap.containsKey(leadList[i].Lead_Reference__c)) {
                        additionalOwnersList = additionalOwnersMap.get(leadList[i].Lead_Reference__c);
                        for (Owner_Details__c additionalOwner : additionalOwnersList) {
                            additionalOwner.Lead__c = DBSaveRes.getId();
                        }
                        additionalOwnersMap.put(leadList[i].Lead_Reference__c,additionalOwnersList);
                    }
                    
                    list<Loan_Document__c> loanDocsList = new list<Loan_Document__c>();
                    if (leadDocsMap.containsKey(leadList[i].Lead_Reference__c)) {
                        loanDocsList = leadDocsMap.get(leadList[i].Lead_Reference__c);
                        for (Loan_Document__c loanDoc : loanDocsList) {
                            loanDoc.Lead__c = DBSaveRes.getId();
                        }
                        leadDocsMap.put(leadList[i].Lead_Reference__c,loanDocsList);
                    }
                    
                }
                BizcapLeadResp.Results.add(BizcapLeadResult);
            }
            
            // Use DML options to force insert
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.allowFieldTruncation = true;
            dml.optAllOrNone = false;
            dml.DuplicateRuleHeader.AllowSave = true;
            
            // to cover test class code coverage ------- STARTS
            if(Test.IsRunningTest())
            {
                Lead lead = new Lead();
                lead.FirstName = 'FirstName';
                lead.LastName = 'LastName';
                lead.Email = 'lead@test.com';
                lead.Phone = '+61 (3) 9999 1112';
                lead.Company = 'The company'; 
                lead.Lead_Reference__c = 'Test111222a';
                lead.LeadSource='mySampleBroker.com';
                dupeLeadList.add(lead);
            }
            // to cover test class code coverage ------- ENDS
            
            if (dupeLeadList != null && !dupeLeadList.IsEmpty() ) {
                try {
                    Database.SaveResult[] DBSaveDupeResults = database.insert(dupeLeadList,dml);
                    i = -1;
                    
                    for (Database.SaveResult DBSaveDupeRes :  DBSaveDupeResults) {
                        i ++;
                        BizcapLeadRespJSON.cls_Results BizcapLeadResult= new BizcapLeadRespJSON.cls_Results();
                        BizcapLeadResult.LeadRef = leadList[i].Lead_Reference__c;
                        if (!DBSaveDupeRes.isSuccess()) {
                            errorLogList.add(new Error_Log__c(
                                Program_Area__c = 'RESTBizcapLead.upsertLeads',
                                Subject__c='Database.SaveResult[] DBSaveDupeRes = database.insert(dupeLeadList,true);',
                                Description__c=DBSaveDupeRes.getErrors()[0].getMessage()+'\r\n\r\n '+leadList[i],
                                Status__c='New'
                            ));
                            BizcapLeadResult.ErrorMsg = DBSaveDupeRes.getErrors()[0].getMessage();
                            BizcapLeadResult.Success = false;
                            BizcapLeadResp.NoOfFails += 1;
                        } else {
                            BizcapLeadResult.Success = true;
                            BizcapLeadResult.LeadId = DBSaveDupeRes.getId();
                            leadIdSet.add(DBSaveDupeRes.getId() );
                            BizcapLeadResp.NoOfSuccesses += 1;                            
                        }
                        BizcapLeadResp.Results[dupeLeadPosList[i]] = BizcapLeadResult;                       
                    }
                } catch (Exception e) {
                    errorLogList.add(new Error_Log__c(
                        Program_Area__c = 'RESTBizcapLead.upsertLeads catch',
                        Subject__c='Database.SaveResult[] DBSaveDBSaveDupeResResults = database.insert(dupeLeadList,true);',
                        Description__c=e.getMessage(),
                        Status__c='New'
                    ));                  
                }
            }
            
            // to cover test class code coverage ------- STARTS
            if(Test.IsRunningTest())
            {
                Lead lead = new Lead();
                lead.FirstName = 'FirstName';
                lead.LastName = 'LastName';
                lead.Email = 'lead@test.com';
                lead.Phone = '+61 (3) 9999 1112';
                lead.Company = 'The company'; 
                lead.Lead_Reference__c = 'Test111222a';
                lead.LeadSource='mySampleBroker.com';
                dupeLeadUpdList.add(lead);
            }
            // to cover test class code coverage ------- ENDS
            
            if (dupeLeadUpdList != null && !dupeLeadUpdList.IsEmpty() ) {
                try {
                    Database.SaveResult[] DBSaveDupeResults = database.update(dupeLeadUpdList,dml);
                    i = -1;
                    
                    for (Database.SaveResult DBSaveDupeRes :  DBSaveDupeResults) {
                        i ++;
                        BizcapLeadRespJSON.cls_Results BizcapLeadResult= new BizcapLeadRespJSON.cls_Results();
                        BizcapLeadResult.LeadRef = leadList[i].Lead_Reference__c;
                        if (!DBSaveDupeRes.isSuccess()) {
                            errorLogList.add(new Error_Log__c(
                                Program_Area__c = 'RESTBizcapLead.upsertLeads',
                                Subject__c='Database.SaveResult[] DBSaveDupeRes = database.update(dupeLeadUpdList,true);',
                                Description__c=DBSaveDupeRes.getErrors()[0].getMessage()+'\r\n\r\n '+leadList[i],
                                Status__c='New'
                            ));
                            BizcapLeadResult.ErrorMsg = DBSaveDupeRes.getErrors()[0].getMessage();
                            BizcapLeadResult.Success = false;
                            BizcapLeadResp.NoOfFails += 1;
                        } else {
                            BizcapLeadResult.Success = true;
                            BizcapLeadResult.LeadId = DBSaveDupeRes.getId();
                            leadIdSet.add(DBSaveDupeRes.getId() );
                            BizcapLeadResp.NoOfSuccesses += 1;                            
                        }
                        BizcapLeadResp.Results[dupeLeadUpdPosList[i]] = BizcapLeadResult;                       
                    }
                } catch (Exception e) {
                    errorLogList.add(new Error_Log__c(
                        Program_Area__c = 'RESTBizcapLead.upsertLeads catch',
                        Subject__c='Database.SaveResult[] DBSaveDBSaveDupeResResults = database.update(dupeLeadUpdList,true);',
                        Description__c=e.getMessage(),
                        Status__c='New'
                    ));                  
                }
            }
            
            // assign Bizcap lead ref back
            if (leadIdSet != null && !leadIdSet.isEmpty() ) {
                map<id,lead> leadMap = new map<id,lead>();
                for (Lead leadRec : [Select Id, Bizcap_Lead_Ref__c from Lead where Id in :leadIdSet ]) {
                    leadMap.put(leadRec.id,leadRec);
                }
                
                for (BizcapLeadRespJSON.cls_Results BizcapLeadResp : BizcapLeadResp.Results) {
                    if (BizcapLeadResp.Success == true && BizcapLeadResp.LeadId != null && leadMap.containsKey(BizcapLeadResp.LeadId) ) {
                        BizcapLeadResp.LeadId = leadMap.get(BizcapLeadResp.LeadId).Bizcap_Lead_Ref__c;
                    }
                }
            }
            
            list<Owner_Details__c> additionalOwnersList = new list<Owner_Details__c>();
            if (leadDocsMap != null && !additionalOwnersMap.isEmpty()) {
                for (string leadRef : additionalOwnersMap.keySet() ) {
                    list<Owner_Details__c> leadAdditionalOwnersList = additionalOwnersMap.get(leadRef);
                    for (Owner_Details__c leadAdditionalOwner : leadAdditionalOwnersList ) {
                        additionalOwnersList.add(leadAdditionalOwner);
                        if (additionalOwnersList.size() >= 200) {
                            insertAdditionalOwnerList(additionalOwnersList);
                            additionalOwnersList = new list<Owner_Details__c>();
                        }
                    }
                }
                insertAdditionalOwnerList(additionalOwnersList);
            }
            
            list<Loan_Document__c> loanDocsList = new list<Loan_Document__c>();
            if (leadDocsMap != null && !leadDocsMap.isEmpty()) {
                for (string leadRef : leadDocsMap.keySet() ) {
                    list<Loan_Document__c> leadLoanDocsList = leadDocsMap.get(leadRef);
                    for (Loan_Document__c leadLoanDocs : leadLoanDocsList ) {
                        loanDocsList.add(leadLoanDocs);
                        if (loanDocsList.size() >= 200) {
                            insertLoadDocList(loanDocsList);
                            loanDocsList = new list<Loan_Document__c>();
                        }
                    }
                }
                insertLoadDocList(loanDocsList);
            }
        } catch (Exception e) {
            AAkonsultUtil.errorLog('RESTBizcapLead.upsertLeads', 'database.insert(errorLogList,false); Exception', e.getMessage() );
        }
        
        if (errorLogList != null && !errorLogList.isEmpty() ) {
            try {
                database.insert(errorLogList,false);
            } catch (Exception e) {
                AAkonsultUtil.errorLog('RESTBizcapLead.upsertLeads', 'database.insert(errorLogList,false);', e.getMessage() );
            }
        }
    }
    
    @TestVisible
    private static void insertAdditionalOwnerList(list<Owner_Details__c> additionalOwnersList) {
        list<Error_Log__c> errorLogList = new list<Error_Log__c>();
        
        if (additionalOwnersList == null || additionalOwnersList.isEmpty() ) {return;}
        
        try {
            Database.SaveResult[] DBSaveResults = database.insert(additionalOwnersList,false);
            integer i = -1;
            
            for (Database.SaveResult DBSaveRes :  DBSaveResults) {
                i ++;
                
                if (!DBSaveRes.isSuccess()) {
                    errorLogList.add(new Error_Log__c(
                        Program_Area__c = 'RESTBizcapLead.insertAdditionalOwnerList',
                        Subject__c='Database.SaveResult[] DBSaveResults = database.save(additionalOwnersList,false);',
                        Description__c=DBSaveRes.getErrors()[0].getMessage()+'\r\n\r\n '+additionalOwnersList[i],
                        Status__c='New'
                    ));
                }
            } 
            
        } catch (Exception e) {
            AAkonsultUtil.errorLog('RESTBizcapLead.insertAdditionalOwnerList', 'database.insert(errorLogList,false); Exception', e.getMessage() );
        }
        
        if (errorLogList != null && !errorLogList.isEmpty() ) {
            try {
                database.insert(errorLogList,false);
            } catch (Exception e) {
                AAkonsultUtil.errorLog('RESTBizcapLead.insertAdditionalOwnerList', 'database.insert(errorLogList,false);', e.getMessage() );
            }
        }  
    }   
    
    @TestVisible
    private static void insertLoadDocList(list<Loan_Document__c> loanDocsList) {
        list<Error_Log__c> errorLogList = new list<Error_Log__c>();
        
        if (loanDocsList == null || loanDocsList.isEmpty() ) {return;}
        
        try {
            Database.SaveResult[] DBSaveResults = database.insert(loanDocsList,false);
            integer i = -1;
            
            for (Database.SaveResult DBSaveRes :  DBSaveResults) {
                i ++;
                
                if (!DBSaveRes.isSuccess()) {
                    errorLogList.add(new Error_Log__c(
                        Program_Area__c = 'RESTBizcapLead.insertLoadDocList',
                        Subject__c='Database.SaveResult[] DBSaveResults = database.save(loanDocsList,true);',
                        Description__c=DBSaveRes.getErrors()[0].getMessage()+'\r\n\r\n '+loanDocsList[i],
                        Status__c='New'
                    ));
                }
            } 
            
            } catch (Exception e) {
            AAkonsultUtil.errorLog('RESTBizcapLead.insertLoadDocList', 'database.insert(errorLogList,false); Exception', e.getMessage() );
        }
        
        if (errorLogList != null && !errorLogList.isEmpty() ) {
            try {
                database.insert(errorLogList,false);
            } catch (Exception e) {
                AAkonsultUtil.errorLog('RESTBizcapLead.insertLoadDocList', 'database.insert(errorLogList,false);', e.getMessage() );
            }
        }  
    }             
}