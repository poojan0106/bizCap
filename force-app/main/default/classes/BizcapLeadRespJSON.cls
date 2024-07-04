public with sharing class BizcapLeadRespJSON {

	public Integer NoOfSuccesses;	//1
	public Integer NoOfFails;	//0
	public cls_Results[] Results;
	public class cls_Results {
		public String LeadRef;	//x1234569
		public String LeadId;	//BC190000001
		public boolean Success;
		public String ErrorMsg;	//
	}
	public static BizcapLeadRespJSON parse(String json){
		return (BizcapLeadRespJSON) System.JSON.deserialize(json, BizcapLeadRespJSON.class);
	}

/*
	static testMethod void testParse() {
		String json=		'{'+
		'  "NoOfSuccesses" : 1,'+
		'  "NoOfFails" : 0,'+
		'  "Results" : [{'+
		'    "LeadRef" : "x1234569",'+
		'    "LeadId" : "BC190000001",'+
		'    "Success" : true,'+
		'    "ErrorMsg" : ""'+
		'  }]'+
		'}';
		BizcapLeadRespJSON obj = parse(json);
		System.assert(obj != null);
	}
*/
}