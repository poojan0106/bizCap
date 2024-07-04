/*
 * Created by: Dhairya Shah
 * Date: 12th june 2020
 * Desc: Creating task
 */ 

public class CreateTaskForOpportunity {

    public static boolean isCreateTask = true;
    
    public static void createTask(id convertedOppId, Boolean converted)
    {
        system.debug('convertedOppId::'+convertedOppId);
        system.debug('converted::'+converted);
        if(converted == false)
        {
            system.debug('converted>>>'+converted);
            Task objTask = new Task();
            objTask.WhatId = convertedOppId;
            objTask.OwnerId = label.Task_Owner;
            objTask.Subject = 'Create Contract';
            objTask.Status = 'Not started';
            objTask.Priority = 'Normal';
            objTask.ActivityDate = system.today();
            objTask.Due_Date_Time__c = system.now();
            insert objTask;
            
            Opportunity objOpps = new Opportunity();
            objOpps.Id = convertedOppId;
            objOpps.Task_contract_send_sent_for_mo__c = true;
            update objOpps;
        }
    }
}