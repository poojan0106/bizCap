public with sharing class OAuthRespJSON {

	public String access_token;	//00D0l000000Daeq!AREAQIHpQi5Ab_LSumgVu9zKR5ZNaFaOyKikFLnZ.z4Bftg9.3e25f_DOz07ZYOVKSHIP3HfQ8GPHAhJ19L_dkiCbQyBv0Q.
	public String signature;	//vbxCbSrsZhinLIqwaRbpkgAR2xtTPSjh/SgFLruReUY=
	public String scope;	//visualforce id api
	public String instance_url;	//https://bizcap--aakonsult.my.salesforce.com
	public String id;	//https://test.salesforce.com/id/00D0l000000DaeqEAC/0050l0000035I7AAAU
	public String token_type;	//Bearer
	public string refresh_token; // 5Aep861hjC52juQoBc5QHhq3JGjPjc8TxB.xp6eljWCcMkyxM1_rXFogmvZAnhRAgc1NGWEnle6wUme.FswKapu
	public String issued_at;	//1559606254013
	public static OAuthRespJSON parse(String json){
		return (OAuthRespJSON) System.JSON.deserialize(json, OAuthRespJSON.class);
	}

}