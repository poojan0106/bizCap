@isTest
private class AAkonsultUtilTest {
    static testMethod void testUtils() {
        Account account = TestData.createAccount();
        insert account;

        Contact contact = TestData.createContact(account.Id);
        insert contact;

        List<SelectOption> so1 = AAkonsultUtil.pickListSelectOption('Account', 'Type');
        Boolean isDisabled = AAkonsultUtil.allTriggersDisabled('Default Settings');
        String qry = AAkonsultUtil.doQuerySObject(new List<Id>{account.Id}, AAkonsultUtil.schemaMap.get('Account').getDescribe().fields.getMap(), 'Account', 'Id');
        String qry2 = AAkonsultUtil.doQuerySObject(new List<Id>{account.Id}, AAkonsultUtil.schemaMap.get('Account').getDescribe().fields.getMap(), 'Account', 'Id',null,true,true);
        AAkonsultUtil.errorLog('Program Area', 'Subject', 'Oops');
        so1 = AAkonsultUtil.fieldNameSelectOption('Account');
        Id id = AAkonsultUtil.getRecordTypeIdFor('Metric', 'Completion');
        String rtName = AAkonsultUtil.getRecordTypeNameFor('Metric', id);
        so1 = AAkonsultUtil.getRecordTypeSelectOptionFor('Metric');
        String qry3 = AAkonsultUtil.buildCommonQuery(AAkonsultUtil.schemaMap.get('Account').getDescribe().fields.getMap(), AAkonsultUtil.schemaMap.get('Contact').getDescribe().fields.getMap());
        AAkonsultUtil.doCopyObjectFields(AAkonsultUtil.schemaMap.get('Account').getDescribe().fields.getMap(), AAkonsultUtil.schemaMap.get('Contact').getDescribe().fields.getMap(), account, contact);
        AAkonsultUtil.doCopyObjectFields(AAkonsultUtil.schemaMap.get('Account').getDescribe().fields.getMap(), AAkonsultUtil.schemaMap.get('Contact').getDescribe().fields.getMap(), account, contact,false);
        AAkonsultUtil.sendErrorEmail('This happened');
        Map<String, List<String>> dependantList = AAkonsultUtil.getDependentOptions('Account','ShippingCountryCode','ShippingStateCode');
        Blob b = Blob.valueOf('This is a blob');
        List<Integer> ints = AAkonsultUtil.BlobToBytes(b);
        ints = AAkonsultUtil.cnvBits('YWJjMTIzIT8kKiYoKSctPUB+abc123!?$*&()\'-=@~');
        String gID = AAkonsultUtil.NewGuid();
        String charAt = AAkonsultUtil.getCharAtIndex('String str', 1);
        AAkonsultUtil.TPicklistEntry e = new AAkonsultUtil.TPicklistEntry();
        e.active = 'text';
		e.defaultValue = 'text';
		e.label = 'text';
		e.value = 'text';
		e.validFor = 'text';
    }
}