trigger CreateTaskForLead on Lead (after insert) 
{
    List<Task> lstTask = new List<Task>();
    RecordType OnlineRecordType = [select id,name from RecordType where name =: Label.Online_Record_Type Limit 1];
    
    for(Lead ld : Trigger.New)
    {
        System.debug('In the lead ::' +ld);
        System.debug('ld.RecordTypeId :: ' +ld.RecordTypeId);
        System.debug('ld.Document_ID__c  :: ' +ld.Document_ID__c);
        System.debug('ld.LeadSource :: ' +ld.LeadSource);
        if(ld.RecordTypeId == OnlineRecordType.id && (ld.Document_ID__c != null && ld.Document_ID__c != '') && ld.LeadSource != null)
        {
            System.debug('Task Part::');
            Task objTask = new Task();
            objTask.Subject = 'Bank Statements Received from ' +ld.LeadSource +': Document ID: ' + ld.Document_ID__c;
            objTask.Due_Date_Time__c = date.today();
            objTask.Status = 'Not Started';
            objTask.Priority = 'Normal';
            objTask.WhoId = ld.id;
            objTask.IsReminderSet = false;
            objTask.OwnerId = Label.TASK_Owner_ID;
            lstTask.add(objTask);
        }
    }
    
    System.debug('lstTask Size ::' +lstTask.size());
    If(!lstTask.isEmpty() && lstTask.size() > 0)
    {
        insert lstTask;
    }
    
}