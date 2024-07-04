/*
* CreatedBy: Dhairya Shah
* Desc: Response class for BizCapGetBPURecords
*/ 
public with sharing class BizCapGetBPURespJSON {
    
    public Integer NoOfBPu;	//1
    public String ErrorMsg;	//
    public cls_Results[] Results;
    
    public class cls_Results {
        
        public String LeadName;
        public String BCNumber;
        public String BizcapLeadRef;
        public String CallAttempts;
        public String Company;
        public String ConditionalApprovalAmount;
        public String ConditionalApprovalDate;
        public String EmailAddress;
        public String FactorRate;
        public String FundedDate;
        public String LastCallDate;
        public String LeadReference;
        public String LeadSource;
        public String LoanAmount;
        public String Loantermbusinessdays;
        public String LoanType;
        public String PaybackAmount;
        public String Stage;
        public String Status;
        public String SubStage;
        public String SubStatus;
        public String LeadId;
        public String OppId;
        public String LeadStatusDate;
        public String LeadSubStatusDate;
        public String OpportunityStageDate;
        public String OpportunitySubStageDate;
        public Boolean isConverted;
        public Boolean ApplicationCheck;
        public Boolean BankStatementsCheck;
    }   
    
    public static BizCapGetBPURespJSON parse(String json){
		return (BizCapGetBPURespJSON) System.JSON.deserialize(json, BizCapGetBPURespJSON.class);
	}
}