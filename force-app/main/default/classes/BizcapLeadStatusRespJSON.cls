public with sharing class BizcapLeadStatusRespJSON {

	public Integer NoOfLeads;	//1
	public String ErrorMsg;	//
	public cls_Results[] Results;
	public class cls_Results {
		public String LeadRef;	//x1234569
		public String LeadId;	//BC190000001
		public String Status;	//Rejected after contract
		public String Reason;	//overleveraged
		public date FundedDate; 
		public string LoanType; // New Loan
		public Decimal LoanAmount;
		public Decimal PaybackAmount;
		public Integer LoanTermBusinessDays;
		public Decimal FactorRate;
        public Decimal CallAttempts;
        public datetime LastCallDate;
	}
	public static BizcapLeadStatusRespJSON parse(String json){
		return (BizcapLeadStatusRespJSON) System.JSON.deserialize(json, BizcapLeadStatusRespJSON.class);
	}

/*
	static testMethod void testParse() {
		String json=		'{  '+
		'   "NoOfLeads":1,'+
		'   "ErrorMsgs":"",'+
		'   "Results":[  '+
		'      {  '+
		'         "LeadRef":"x1234569",'+
		'         "LeadId":"BC190000001",'+
		'         "Status":"Rejected after contract",'+
		'         "Reason":"overleveraged"'+
		'      }'+
		'   ]'+
		'}';
		BizcapLeadStatusRespJSON obj = parse(json);
		System.assert(obj != null);
	}
*/	
}