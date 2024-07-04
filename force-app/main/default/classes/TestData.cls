public with sharing class TestData {
    public static Account createAccount() {
        Account account = new Account(
            Name='Test Account',
            BillingStreet='100 somewhere st',
            BillingCity='Melbourne',
            BillingState='Victoria',
            BillingPostalCode='3000',
            BillingCountry='Australia',
            Fax='+61 (3) 9999 1111',
            Phone='+61 (3) 9999 1112'  
        );
        return account;
    }
    
    public static Contact createContact(Id AccountId) {
        Contact contact = new Contact(
            AccountId=AccountId,
            firstName='FirstNa',
            lastName='lastNa',
            email='test@test.com.au',
            MobilePhone='+61 411 111 111'
        );
        return contact;
    }
    
    public static Lead createLead() {
        Lead lead = new Lead();
        lead.FirstName = 'FirstName';
        lead.LastName = 'LastName';
        lead.Email = 'lead@test.com';
        lead.Phone = '+61 (3) 9999 1112';
        lead.Company = 'The company'; 
        lead.Lead_Reference__c = 'Test111222a';
        lead.LeadSource='mySampleBroker.com';
        return lead;
    }
    
    public static Case createCase(Id contactId, Id accountId) {
        Case cse = new Case();
        cse.Priority = 'Low';
        cse.ContactId = contactId;
        cse.AccountId = accountId;
        cse.Description = 'What went wrong';
        return cse;
    }
    
    public static Opportunity createOpportunity(Id accId) {
        Opportunity o = new Opportunity(
            Name = 'Test Opp'
            , CloseDate = Date.today()
            , StageName = 'Closed/Won'
            , AccountId = accId
            , Lead_Reference__c = 'Test3333444a'
            , LeadSource='mySampleBroker.com'
        );
        return o;
    }
    
    public static OpportunityLineItem createOpportunityLineItem(Id oppId, Id pbeId) {
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = oppId
            , PricebookEntryId = pbeId
            , Quantity = 1
            , UnitPrice = 5
        );
        return oli;
    }
    
    public static Product2 createProduct() {
        Product2 product = new Product2();
        product.Name = 'TestName';
        product.Family = 'TestFam';
        product.IsActive = true;
        
        return product;
    }
    
    public static PricebookEntry createPricebookEntry(Id prodId) {
        PricebookEntry pbe = new PricebookEntry();
        Id stdPBId = Test.getStandardPricebookId();
        pbe.pricebook2Id = stdPBId;
        pbe.Product2Id = prodId;
        pbe.unitprice = 50;
        pbe.isactive = true;
        
        return pbe;
    }
    
    public static Campaign createCampaign() {
        Campaign campaign = new Campaign(
            Name='Test Campaign',
            IsActive=true,
            startDate=System.today()-30,
            endDate=system.today()+45
        );
        return campaign;
    }
    
    public static CampaignMember createCampaignMember(Id contactId, Id campaignId) {
        CampaignMember campaignMember = new CampaignMember(CampaignId=campaignId,contactId=contactId,Status='Sent');
        return campaignMember;
    }
    
    public static list<CampaignMemberStatus> createCampaignMemberStatus(Id campaignId) {
        list<CampaignMemberStatus> campaignMemberStatusList = new list<CampaignMemberStatus>();
        campaignMemberStatusList.add(new CampaignMemberStatus(campaignId = campaignId,Label='Sent',sortOrder=1));
        campaignMemberStatusList.add(new CampaignMemberStatus(campaignId = campaignId,Label='Responded',sortOrder=2));
        return campaignMemberStatusList;
    }
    
    public static Attachment createAttachment(Id ParentId) {
        String attachmentData = 'StartDate,EndDate,PayrollGroupName,EmpGroupName,' +
            'EmpName,ApprovedBy,Payrate,RegHours,Ot1Hours,Ot2Hours,' +
            'Other1Hours,Other2Hours,Other3Hours,Other4Hours,Other5Hours,' +
            'RegCategoryName,Ot1CategoryName,Ot2CategoryName,' +
            'Other1CategoryName,Other2CategoryName,Other3CategoryName,' +
            'Other4CategoryName,Other5CategoryName,RegCategoryCode,' +
            'Ot1CategoryCode,Ot2CategoryCode,Other1CategoryCode,' +
            'Other2CategoryCode,Other3CategoryCode,Other4CategoryCode,' +
            'Other5CategoryCode\n';        
        Blob body1 = Blob.valueOf(attachmentData);
        
        Attachment attachment = new Attachment(
            body=body1,
            Name='signatureTest.gif',
            ContentType='image/gif',
            ParentId = parentId
        );
        return attachment;    
    }
    
    public static string OAuthRespJSON() {
        String json=		'{'+
            '    "access_token": "00D0l000000Daeq!AREAQIHpQi5Ab_LSumgVu9zKR5ZNaFaOyKikFLnZ.z4Bftg9.3e25f_DOz07ZYOVKSHIP3HfQ8GPHAhJ19L_dkiCbQyBv0Q.",'+
            '    "signature": "vbxCbSrsZhinLIqwaRbpkgAR2xtTPSjh/SgFLruReUY=",'+
            '    "scope": "visualforce id api",'+
            '    "instance_url": "https://bizcap--aakonsult.my.salesforce.com",'+
            '    "id": "https://test.salesforce.com/id/00D0l000000DaeqEAC/0050l0000035I7AAAU",'+
            '    "token_type": "Bearer",'+
            '    "issued_at": "1559606254013"'+
            '}';
        
        return json;
        
    }
    
    public static string RESTBizcapLead() {
        
        String json='{ \r\n';
        json += '   "Leads":[ \r\n';
        json += '      { \r\n';
        json += '		\r\n';
        json += '		"BrokerName": {\r\n';
        json += '			"BrokerContactName": "Become Test",\r\n';
        json += '			"BrokerContactNumber": "+61490939325",\r\n';
        json += '			"BrokerContactEmail": "abc@gmail.com",\r\n';
        json += '			"CallOnBehalfOfAlias": "Become test",\r\n';
        json += '			"CallClientOrBroker": "Client",\r\n';
        json += '			"Channel": "Phone"\r\n';
        json += '			},\r\n';
        json += '           "LeadInfo":{ \r\n';
        json += '              "leadRef":"x1234569",\r\n';
        json += '               "LeadSource":"mySampleBroker.com"\r\n';
        json += '            },\r\n';
        json += '           "Applicant":{ \r\n';
        json += '              "ApplicantName":{ \r\n';
        json += '                 "Salutation":"Mr",\r\n';
        json += '                  "FirstName":"John",\r\n';
        json += '                  "LastName":"Smith"\r\n';
        json += '               },\r\n';
        
        json += '				"BrokerContactName": "Become Test",\r\n';
        json += '				"BrokerContactNumber": "+61490939325",\r\n';
        json += '				"BrokerContactEmail": "abc@gmail.com",\r\n';
        json += '				"CallOnBehalfOfAlias": "Become test",\r\n';
        json += '				"CallClientOrBroker": "Client",\r\n';
        json += '				"Channel": "Phone",\r\n';
        
        json += '               "JobTitle":"Managing Director",\r\n';
        json += '               "ContactPreference":"Telephone",\r\n';
        json += '               "ContactDateTime":"21/04/2019 10:30 AM",\r\n';
        json += '               "MobilePhone":"0419 123 456",\r\n';
        json += '               "Phone":"03 9999 1111",\r\n';
        json += '               "WorkPhone":"03 1111 2222",\r\n';
        json += '               "Email":"john.smith@mailinator.com",\r\n';
        json += '               "BirthDate":"31/12/1995",\r\n';
        json += '               "DriversLicense":"111-222-4444",\r\n';
        json += '               "HomeAddress":{ \r\n';
        json += '                  "Street":"100 collins st",\r\n';
        json += '                  "City":"Melbourne",\r\n';
        json += '                  "State":"VIC",\r\n';
        json += '                 "PostcalCode":"3000",\r\n';
        json += '                  "Country":"Australia"\r\n';
        json += '               },\r\n';
        json += '               "PersonalCreditScore":89.5,\r\n';
        json += '               "PersonalCredit":"Perfect - I have never had a default",\r\n';
        json += '               "BusinessOwnershipPCT":100.00,\r\n';
        json += '               "HadDefaults":"No",\r\n';
        json += '               "HadBankruptcy":"No",\r\n';
        json += '               "OutstandingTaxLiens":"Yes"\r\n';
        json += '            },\r\n';
        json += '            "Business":{ \r\n';
        json += '               "LegalName":"Smart Consulting Pty Ltd",\r\n';
        json += '               "TradingName":"Quik and Simple",\r\n';
        json += '               "HomeBasedBusiness":"No",\r\n';
        json += '               "ABN":"51 824 753 556",\r\n';
        json += '               "Phone":"03 1111 2222",\r\n';
        json += '               "DeliveryAddress":{ \r\n';
        json += '                 "Street":"120 Collins St",\r\n';
        json += '                  "City":"Melbourne",\r\n';
        json += '                  "State":"VIC",\r\n';
        json += '                  "PostcalCode":"3000",\r\n';
        json += '                  "Country":"Australia"\r\n';
        json += '               },\r\n';
        json += '               "MailingAddress":{ \r\n';
        json += '                  "Street":"PO Box 188",\r\n';
        json += '                 "City":"Melbourne",\r\n';
        json += '                 "State":"VIC",\r\n';
        json += '                 "PostcalCode":"3000",\r\n';
        json += '                 "Country":"Australia"\r\n';
        json += '              },\r\n';
        json += '              "Industry":"GYM & Fitness Centre",\r\n';
        json += '              "TypeOfEntity":"Australian Private Company",\r\n';
        json += '              "TypeOfCustomers":"Business and Consumers",\r\n';
        json += '              "EntityTypeSize":"Company with 2 - 5 Employees",\r\n';
        json += '              "BusinessOwner":"Rentig the same place for last 2 years",\r\n';
        json += '              "CompanyFinancials":"Bookkeeping and BAS all upto date",\r\n';
        json += '               "FinancialInfo":{ \r\n';
        json += '                  "AnnualRevenue":12000000.00,\r\n';
        json += '                  "AverageMonthlyTurnover":100000.00,\r\n';
        json += '                 "AverageMonthlyDeposits":90000.00,\r\n';
        json += '                 "AverageDailyBankBalance":-10000.00,\r\n';
        json += '                 "NoofExistingBusinessLoans":0,\r\n';
        json += '                 "AmountPerMonthProcessedOnCreditCardorEFTPOS":3500.00,\r\n';
        json += '                 "BusinessProfitNotes":"We have been loosing money for the last 6 months",\r\n';
        json += '                  "Profit":200000.00,\r\n';
        json += '                  "ATOTaxPosition":30000.00,\r\n';
        json += '                 "NONBankLoanBalance":10000.00,\r\n';
        json += '                 "HowPaid":"Paid COD"\r\n';
        json += '              },\r\n';
        json += '              "BusinessCreditHistory":"text notes",\r\n';
        json += '              "BusinessEstablised":"01/12/2008",\r\n';
        json += '               "LengthOfOwnership":"5 Years"\r\n';
        json += '            },\r\n';
        json += '            "LoanDetails":{ \r\n';
        json += '              "AmountRequested":120000.00,\r\n';
        json += '               "LoanPurpose":"New Equipment",\r\n';
        json += '              "LoanProduct":"Equipment Finance",\r\n';
        json += '              "LoanTermMonths":"60",\r\n';
        json += '               "LoanType":"Unsecured",\r\n';
        json += '               "HowSoon":"30 Days",\r\n';
        json += '              "SecuritThatCanBeProvided":"Personal Vehicle",\r\n';
        json += '              "ApplicationSignDate":"31/12/2019",\r\n';
        json += '              "BankStatementsLastUpdated":"30/11/2019"\r\n';
        json += '           },\r\n';
        
        json += '                       "AdditionalOwners": {\r\n';
        json += '                          "AdditionalOwnerDetails":[{\r\n';
        json += '                             "OwnerName":{ \r\n';
        json += '                                "Salutation":"Mrs",\r\n';
        json += '                                "FirstName":"Marry",\r\n';
        json += '                                "LastName":"Smith"\r\n';
        json += '                             },\r\n';
        json += '                             "MobilePhone":"0419 123 456",\r\n';
        json += '                             "Phone":"03 9999 1111",\r\n';
        json += '                             "WorkPhone":"03 1111 2222",\r\n';
        json += '                             "Email":"john.smith@mailinator.com",\r\n';
        json += '                            "BirthDate":"30/11/1996",\r\n';
        json += '                             "HomeAddress":{ \r\n';
        json += '                               "Street":"100 collins st",\r\n';
        json += '                                "City":"Melbourne",\r\n';
        json += '                                "State":"VIC",\r\n';
        json += '                                "PostcalCode":"3000",\r\n';
        json += '                                "Country":"Australia",\r\n';
        json += '                               "LengthAtAddress":"5 years"\r\n';
        json += '                             },\r\n';
        json += '                             "BusinessOwnershipPCT":50.00,\r\n';
        json += '                             "PoliticallyExposedPerson":"Yes"\r\n';
        json += '                          }\r\n';
        json += '                           ]\r\n';
        json += '                       },\r\n';
        
        json += '           "Documents":{ \r\n';
        json += '              "BankstatementsDocumentIDs":[ \r\n';
        json += '                 { \r\n';
        json += '                    "BankstatementsDocumentID":"DOC1234596"\r\n';
        json += '                 }\r\n';
        json += '              ]\r\n';
        json += '            }\r\n';
        /*json += '"BrokerName": {';
        json += '"BrokerContactName": "Become Test",';
        json += '"BrokerContactNumber": "+61490939325",';
        json += '"BrokerContactEmail": "abc@gmail.com",';
        json += '"CallOnBehalfOfAlias": "Become test",';
        json += '"CallClientOrBroker": "Client",';
        json += '"Channel": "Phone"';
        json += '}';*/
        json += '        }\r\n';
        json += '\r\n';
        json += '   ]\r\n';
        json += '}';
        
        return json;
    }    
}