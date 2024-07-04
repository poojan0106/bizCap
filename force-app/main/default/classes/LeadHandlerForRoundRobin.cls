public class LeadHandlerForRoundRobin {
    
    public static Boolean isFirstTime = true;
    public static Boolean isFirstTimeBeforeUpdate = true;    
    public static Boolean isFirstTimeafterUpdate = true;
    public static Set<Lead> lstRRLeadToUpdate = new Set<Lead>();
    
    public static Set<Lead> updateObjectData(List<Lead> lstLead)
    {
        String NextRRUser;
        Map<id,Lead_Round_Robin_Assignment__c> lstLRRAToUpdate = new Map<id,Lead_Round_Robin_Assignment__c>();
        
        QueueSobject lstQueue = [select id,Queue.name,Queue.id from QueueSobject where Queue.name = :Label.Round_Robin LIMIT 1];
        Lead_Round_Robin_Assignment__c lstLRRA = [select id,Last_RR_Lead_Receiver__c,Next_RR_User_ID__c,Round_Robin_User_ID__c,
                                                  Next_RR_User__c, Round_Robin_User__c,Next_RR_User__r.id, Round_Robin_User__r.id
                                                  from Lead_Round_Robin_Assignment__c 
                                                  where Last_RR_Lead_Receiver__c = True
                                                  
                                                  LIMIT 1];
        system.debug('lstQueue : ' + lstQueue.Queue.id);
        system.debug('lstLRRA : ' + lstLRRA);
        map<id,id> leadToOwner =new map<id,id>();
        
        List<Lead_Round_Robin_Assignment__c> lstLRRA1 = [select id,Last_RR_Lead_Receiver__c,Next_RR_User_ID__c,Round_Robin_User_ID__c ,
                                                         Next_RR_User__c, Round_Robin_User__c,Next_RR_User__r.id, Round_Robin_User__r.id
                                                         from Lead_Round_Robin_Assignment__c  order by Last_RR_Lead_Receiver__c desc ];
        
        Map<id,id> mapNextTOcurrent =new Map<id,id>();
        for(Lead_Round_Robin_Assignment__c lr:lstLRRA1)
        {
            mapNextTOcurrent.put(lr.Round_Robin_User__r.id,lr.Next_RR_User__r.id );
        }
        Map<integer,id> nextRR = new Map<integer,id>();
        integer num = 1;
        string nextid;
        for(Lead_Round_Robin_Assignment__c lr:lstLRRA1)
        {           
            
            if(lr.Last_RR_Lead_Receiver__c == True)
            {                  
                nextRR.put(1, lr.Next_RR_User__r.id);
                nextid = lr.Next_RR_User__r.id;
                system.debug('nextid : '+ nextid);
            }
            else             
            {   
                
                nextRR.put(num, mapNextTOcurrent.get(nextid));
                nextid = mapNextTOcurrent.get(nextid);
            }
            num++;
        }
        system.debug('mapNextTOcurrent : '+ nextRR);
        
        string lastNext;
        for(Lead l : lstLead)
        {
            leadToOwner.put(l.id,NextRRUser);
        }
        if(lstQueue!=NULL && !String.isBlank(lstQueue.Queue.id) && lstLRRA!=NULL && !String.isBlank(lstLRRA.Next_RR_User_ID__c))
        {
            system.debug('in updateObjectData');
            NextRRUser = lstLRRA.Next_RR_User__r.id;
            system.debug('NextRRUser : '+ NextRRUser);
            for(integer i = 0; i<lstLead.size();i++)
            {
                system.debug('l.ownerId : '+ lstLead[i].ownerId);
                if(lstLead[i].ownerId == lstQueue.Queue.id)
                {
                    LeadHandlerForRoundRobin.isFirstTime = false;
                    lstLead[i].Duplicate__c = 'NO';
                    if(i+1<=nextRR.size())
                    {
                        system.debug('nextRR.get(i+1);' + nextRR.get(i+1));
                        lstLead[i].ownerid = nextRR.get(i+1);
                    }
                    else
                    {
                        system.debug('nextRR.get(math.mod(i+1,nextRR.size())) :'+ nextRR.get(math.mod(i+1,nextRR.size())));
                        lstLead[i].ownerid = nextRR.get(math.mod(i+1,nextRR.size()));
                    }
                    lastNext = lstLead[i].ownerid ;
                    lstLead[i].Round_Robin_Owner_Assigned__c = TRUE;
                    lstRRLeadToUpdate.add(lstLead[i]);
                }
            }
        }
        for(Lead_Round_Robin_Assignment__c lr:lstLRRA1)
        {
            lr.Last_RR_Lead_Receiver__c = false;
            lstLRRAToUpdate.put(lr.id,lr);
        }
        system.debug('lastNext : ' + lastNext);
        if(NextRRUser!='' )
        {
            Lead_Round_Robin_Assignment__c lstNextLRRA = [select id,Last_RR_Lead_Receiver__c,Next_RR_User_ID__c,Round_Robin_User_ID__c ,Round_Robin_User__c 
                                                          ,Next_RR_User__r.id, Round_Robin_User__r.id from Lead_Round_Robin_Assignment__c 
                                                          where Round_Robin_User__c  = :lastNext
                                                          LIMIT 1];
            User nextUser = [Select id,Email,Name from User where id = :NextRRUser];
            if(lstNextLRRA != NULL)
            {
                lstNextLRRA.Last_RR_Lead_Receiver__c = True;
                lstLRRAToUpdate.put(lstNextLRRA.id, lstNextLRRA);
            }
            
            if(lstLRRAToUpdate.size()>0 && !lstLRRAToUpdate.isEmpty())
            {
                system.debug('lstLRRAToUpdate : '+ lstLRRAToUpdate);
                update lstLRRAToUpdate.values();
            }
            if(lstRRLeadToUpdate.size()>0 && !lstRRLeadToUpdate.isEmpty())
            {
                system.debug('lstRRLeadToUpdate : '+ lstRRLeadToUpdate);
               
                return lstRRLeadToUpdate;
            }
            else
            {
                return null;
            }
        }
        else 
            return null;
    }
    
    public static void sendEmailNotification(Set<Lead> lstLead)
    {
        system.debug('myLeadForEmail : ' + lstLead);
        List<Id> lstusersIds = new List<Id>();
        For(Lead l:lstLead)
        {
            lstusersIds.add(l.OwnerId);
        }
        List<user> lstUsers = [select id,name,email from user where id in :lstusersIds];
        Map<id,String> mapUseraName = new Map<id,String>();
        Map<id,String> mapUseraEmail = new Map<id,String>();
        for(User u: lstUsers)
        {
            mapUseraName.put(u.id,u.name);
            mapUseraEmail.put(u.id,u.email);
        }
        List<Task> lstTask = new List<Task>();
        List<Messaging.SingleEmailMessage> email =new List<Messaging.SingleEmailMessage>();
        for(Lead l: lstLead)
        { 
            if(l.OwnerId != null && mapUseraEmail.get(l.OwnerId) != null)
            {
                string LeadSource = String.isBlank(l.LeadSource) ? ' ' : l.LeadSource;
                Task task = new Task();
                task.OwnerId = l.OwnerId;
                task.Due_Date_Time__c = Date.today();
                task.WhoId = l.id;
                task.Subject = 'New Lead Created - Lead Source : ' + LeadSource;
                task.status = 'Not Started';
                lstTask.add(task);
                
                string Company = String.isBlank(l.Company) ? ' ' : l.Company;
                string LeadName =  String.isBlank(l.FirstName) ? ' ' : l.FirstName ;
                string LeadEmail= String.isBlank(l.Email) ? ' ' : l.Email;
                string LeadMobile = String.isBlank(l.Phone) ? ' ' : l.Phone;
                string CountryAPI = String.isBlank(l.Country_API__c) ? ' ' :l.Country_API__c;
                string State =  String.isBlank(l.StateCode) ? ' ' : l.StateCode;
                Decimal Monthlyrevenue = l.Monthl__c == NULL ? 0 : l.Monthl__c;            
                Decimal AverageMonthlyTurnover =  l.Average_Monthly_Turnover__c== NULL ? 0 : l.Average_Monthly_Turnover__c;
                
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                String newBody = 'Hello ' + mapUseraName.get(l.OwnerId) + '<br><br>';
                newBody += 'The following lead has been assigned to you.'+ '<br>'; 
                newBody += 'Company : ' + Company + '<br>';
                newBody += 'Lead Name : ' + LeadName + ' ' + l.LastName+ '<br>';
                newBody += 'Lead Email : ' +LeadEmail + '<br>';
                newBody += 'Lead Mobile: '+ LeadMobile + '<br>';
                newBody += 'Lead Source : ' + LeadSource + '<br>';
                newBody += 'Country :' + CountryAPI + '<br>' ; 
                newBody += 'State : '+ state + '<br>';
                newBody += 'Monthly revenue : '+ Monthlyrevenue + '<br>';
                newBody += 'Average Monthly Turnover : '+  AverageMonthlyTurnover+ '<br>';
                newBody += 'Click on the below link to access to view the lead record in Salesforce.com: https://bizcapau.my.salesforce.com/'+l.Id+ '<br><br>';
                newBody += 'Thank you';
                msg.setSubject('New Lead Assigned');
                msg.setHtmlBody(newBody);  
                //msg.setOrgWideEmailAddressId(owaRepair != null ? owaRepair.Id : owaId);
                msg.setToAddresses( new String[] {mapUseraEmail.get(l.OwnerId)} );
                if(Label.RoundRobinBCCemail != 'NA')
                {
                    msg.setBccAddresses(new String[] {Label.RoundRobinBCCemail});
                }
                //msg.setSaveAsActivity(TRUE);
                // msg.setTargetObjectId(l.Id);
                //msg.SetwhatId(l.id);
                email.add(msg);
            }
        }
        if(email != Null && !Test.isRunningTest()){
            System.debug('The test is ');
            Messaging.sendEmail(email);
        }
        
        if(!lstTask.isEmpty() && lstTask.size()> 0 )
        {
            insert lstTask;
        }
    }
}