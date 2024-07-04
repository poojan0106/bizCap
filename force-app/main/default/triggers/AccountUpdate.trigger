/*
 * Created by: Dhairya SHah
 * Desc: To updae checkbox is converted on account whenever it is inserted or updated only for converted accounts from Lead.
 */ 
trigger AccountUpdate on Account (after insert, after update) {

 List<Account> listAcc = new List<Account>();
    /*
    if(Trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
    {
        for(Account objAcc : Trigger.new)
        {
            if(objAcc.is_Converted__C == false)
            {
                listAcc.add(objAcc);
            }
            if(listAcc!=NULL && listAcc.size()>0)
            {
                List<Lead> listOfLead = [SELECT Id, ConvertedAccountId FROM Lead WHERE ConvertedAccountId IN: listAcc LIMIT 1];
                
                IF(listOfLead!=NULL && listOfLead.size()>0)
                {
                    //LeadTriggerHandler.accountConvert(listOfLead);
                }
            }
        }
    }*/    
}