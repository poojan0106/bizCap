@isTest
private class TestDataCoverage {
    static testMethod void CoverTestCode() {
        Account account = TestData.createAccount();
        insert account;

        Contact contact = TestData.createContact(account.Id);
        insert contact;

        Lead lead = TestData.createLead();
        insert lead;

        Case cse = TestData.createCase(contact.Id, account.Id);
        insert cse;

        Opportunity opportunity = TestData.createOpportunity(account.Id);
        insert opportunity;

        Product2 product = TestData.createProduct();
        insert product;

        PricebookEntry pbe = TestData.createPricebookEntry(product.Id);
        insert pbe;

        OpportunityLineItem oli = TestData.createOpportunityLineItem(opportunity.Id, pbe.Id);
        insert oli;

        Campaign campaign = TestData.createCampaign();
        insert campaign;

        List<CampaignMemberStatus> cms = TestData.createCampaignMemberStatus(campaign.Id);
        insert cms;

        CampaignMember cm = TestData.createCampaignMember(contact.Id, campaign.Id);
        insert cm;
        
        Attachment att = TestData.createAttachment(contact.Id);
        insert att;
        
        String OAuthRespJSON_data = TestData.OAuthRespJSON();
	
        String JSONdata = TestData.RESTBizcapLead();
    }
}