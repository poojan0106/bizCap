public with sharing class BizcapLeadJSON {

    public cls_Lead[] Leads;
    public class cls_Lead {
        public cls_LeadInfo LeadInfo;
        public cls_Applicant Applicant;
        public cls_BrokerInfo BrokerName;
        public cls_Business Business;
        public cls_LoanDetails LoanDetails;
        public cls_AdditionalOwnerDetails AdditionalOwners;
        public cls_Documents Documents;
    }
    public class cls_LeadInfo {
        public String leadRef;  //x1234569
        public String LeadSource;   //mySampleBroker.com
    }
    public class cls_Applicant {
        public cls_ApplicantName ApplicantName;
        public cls_ApplicantName OwnerName;
        public String JobTitle; // Managing Director
        public String ContactPreference;    //Telephone
        public String ContactDateTime;  //21/04/2019 10:30 AM
        public String MobilePhone;  //0419 123 456
        public String Phone;    //03 9999 1111
        public String WorkPhone;    //03 1111 2222
        public String Email;    //john.smith@mailinator.com
        public String BirthDate;    //31/12/1995
        public String DriversLicense;   //111-222-4444
        public cls_HomeAddress HomeAddress;
        public Double PersonalCreditScore;  //89.5
        public String PersonalCredit;   //Perfect - I have never had a default
        public Double BusinessOwnershipPCT; //100
        public String HadDefaults;  //No
        public String HadBankruptcy;    //No
        public String OutstandingTaxLiens;  //Yes
        public String PoliticallyExposedPerson; //Yes
        
        public String BrokerName;
        public String BrokerContactName;
        public String BrokerContactNumber;
        public String BrokerContactEmail; //ADDED BY NRUPA ON 09/02/2022 TO PUSH EMAIL VIA API - "abc@gmail.com"
        public String CallOnBehalfOfAlias;
        public String CallClientOrBroker;
        public String Channel;
        
        public String politicallyExposed;
        public boolean PrivacyPolicycheckBox;
        public String FormstackUpdateURLODIN;
        public String ProvisoLinkODIN;
        Public String Note;
        
        public String CountryAPI; //AUS/NZ
        
        public string NZBN; //NZBN
        public String CompanyNumber; //Company Number
        public String PassportNumber; //PassportNumber
        public String DriversVersionNumber; //Driver'sVersionNumber
    }
    
    public class cls_ApplicantName {
        public String Salutation;   //Mr
        public String FirstName;    //John
        public String LastName; //Smith
    }
    
    public class cls_HomeAddress {
        public String Street;   //100 collins st
        public String City; //Melbourne
        public String State;    //VIC
        public String PostcalCode;  //3000
        public String Country;  //Australia
        public string LengthAtAddress; // 5 Years
    }
    
    public class cls_Business {
        public String LegalName;    //Smart Consulting Pty Ltd
        public String TradingName;  //Quik and Simple
        public String HomeBasedBusiness;    //No
        public String ABN;  //51 824 753 556
        public String Phone;    //03 1111 2222
        public cls_DeliveryAddress DeliveryAddress;
        public cls_MailingAddress MailingAddress;
        public String Industry; //GYM & Fitness Centre
        public String TypeOfEntity; //Australian Private Company
        public String TypeOfCustomers;  //Business and Consumers
        public String EntityTypeSize;   //Company with 2 - 5 Employees
        public string LandLordMorgage;  // Renting      
        public String BusinessOwner;    //Rentig the same place for last 2 years
        public String CompanyFinancials;    //Bookkeeping and BAS all upto date
        public cls_FinancialInfo FinancialInfo;
        public String BusinessCreditHistory;    //text notes
        public String BusinessEstablised;   //01/12/2008
        public String LengthOfOwnership;    //5 Years
    }
    
    public class cls_DeliveryAddress {
        public String Street;   //120 Collins St
        public String City; //Melbourne
        public String State;    //VIC
        public String PostcalCode;  //3000
        public String Country;  //Australia
    }
    
    public class cls_MailingAddress {
        public String Street;   //PO Box 188
        public String City; //Melbourne
        public String State;    //VIC
        public String PostcalCode;  //3000
        public String Country;  //Australia
    }
    
    public class cls_FinancialInfo {
        public string AnnualRevenue;    //12000000.00
        public string AverageMonthlyTurnover;   //100000.00
        public string AverageMonthlyDeposits;   //90000.00
        public string AverageDailyBankBalance;  //-10000.00
        public string NoofExistingBusinessLoans;    //0
        public string AmountPerMonthProcessedOnCreditCardorEFTPOS;  //3500.00
        public String BusinessProfitNotes;  //We have been loosing money for the last 6 months      
        public string Profit;   //200000.00
        public string ATOTaxPosition;   //30000.00
        public string NONBankLoanBalance;   //10000.00
        public String HowPaid;  //Paid COD
    }
    
    public class cls_LoanDetails {
        public string AmountRequested;  //120000
        public String LoanPurpose;  //New Equipment
        public String LoanProduct;  //Equipment Finance
        public String LoanTermMonths;   //60
        public String LoanType; //Unsecured
        public String HowSoon;  //30 Days
        public String SecuritThatCanBeProvided; //Personal Vehicle
        public String ApplicationSignDate;  //31/12/2019
        public String BankStatementsLastUpdated;    //30/11/2019
        public String OriginalEnquiryDate;  //30/11/2019
        public String Outstandingloanbalance; //10000
    }

    public class cls_AdditionalOwnerDetails {
        public cls_Applicant[] AdditionalOwnerDetails;
    }

    public class cls_Documents {
        public cls_BankstatementsDocumentIDs[] BankstatementsDocumentIDs;
    }
    
    public class cls_BankstatementsDocumentIDs {
        public String BankstatementsDocumentID; //xxxxxx
        public String DocumentName;
        public string DocumentURL;
        public string DocumentNote;
    }
    
    public class cls_BrokerInfo {
        public String BrokerName;
        public String BrokerContactName;
        public String BrokerContactNumber;
        public String BrokerContactEmail; //ADDED BY NRUPA ON 09/02/2022 TO PUSH EMAIL VIA API - "abc@gmail.com"
        public String CallOnBehalfOfAlias;
        public String CallClientOrBroker;
        public String Channel;
    }
    
    public static BizcapLeadJSON parse(String json){
        return (BizcapLeadJSON) System.JSON.deserialize(json, BizcapLeadJSON.class);
    }

}