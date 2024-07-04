trigger Trigger_Lead on Lead (after insert,before update,after update) 
{
    TriggerSwitch__c checkForStatus = [select IsActive__c from TriggerSwitch__c
                                       where Name= 'Trigger_Lead'];
    system.debug('--------TriggerSwitch__c----------'+checkForStatus);
    string rrID = Label.RoundRobin;
    system.debug('rrIDrrIDrrID'+rrID);
    
    if(checkForStatus.IsActive__c)
    {
        set<string> lstownerids;
        set<string> lstowner;
        
        set<id> stid=new set<id>();
        map<id,id> maplead = new map<id,id>();
        list<leadshare> lstShr=new list<leadshare>();
        //private static boolean run = true;
        map<string,set<string>> mapcsc=new map<string,set<string>>();
        map<string,set<string>> mapcsc1=new map<string,set<string>>();
        
        // list<LeadShare> lstshare=new list<LeadShare>();
        //public static list<LeadShare> lstshares=new list<LeadShare>();
        list<string> lstsourceCode =new list<string>();
        list<string> lstSourceCode1 =new list<string>();
        
        Set<string> leadId= new set<string>();
        
        
        set<string> lstupdateCode;
        set<string> lstupdateCode1;
        
        list<string> lstids;
        list<string> lstupdateOwner;
        list<string> lstownerid;
        map<string,list<string>> mapLeadShare = new map<string,list<string>>();
        
        if(RecursiveTriggerHandler.isFirstTime)
        {
            list<LeadShare> lstshare=new list<LeadShare>();
            
            if(trigger.isafter && trigger.isinsert)
            {        
                system.debug('after insert called');
                RecursiveTriggerHandler.isFirstTime = false;
                
                try
                {
                    for(lead ld:trigger.new)
                    {
                        lstsourceCode.add(ld.LeadSource);
                    }
                    list<Custom_Sharing_Criteria__c> lstCSC=[select id,name,Lead_Source__c,User_Group_ID__c from Custom_Sharing_Criteria__c where Lead_Source__c=:lstsourceCode ];
                    
                    for(Custom_Sharing_Criteria__c csc:lstcsc)
                    {
                        system.debug('lstCSC@@ '+csc);
                        
                    }
                    
                    for(Custom_Sharing_Criteria__c csc:lstCSC)
                    {
                        if(csc.User_Group_ID__c != null && csc.User_Group_ID__c != ''){
                            if(!mapcsc.isEmpty() && mapcsc.containsKey(csc.Lead_Source__c))
                            {
                                mapcsc.get(csc.Lead_Source__c).add(csc.User_Group_ID__c);
                            }
                            else
                            {
                                mapcsc.put(csc.Lead_Source__c,New Set<String>{csc.User_Group_ID__c});   
                            }  
                        }
                    }
                    system.debug('mapcsc'+mapcsc);  
                    
                    for(lead ld:Trigger.new)
                    {
                        if(ld.LeadSource!=null && mapcsc.containskey(ld.LeadSource))
                        {
                            lstownerids=new set<string>();
                            lstownerids=mapcsc.get(ld.LeadSource);
                            for(string acessid:lstownerids)
                            {
                                if(ld.ownerId!=acessid)
                                {
                                    
                                    system.debug('acessid'+acessid);
                                    LeadShare ldshare= new LeadShare();
                                    ldshare.LeadId=ld.id;
                                    ldshare.LeadAccessLevel='Edit';
                                    ldshare.RowCause='Manual';
                                    ldshare.UserOrGroupId=acessid;
                                    lstshare.add(ldshare);  
                                    system.debug('ldshare'+ldshare);
                                }
                            }                 
                            
                        }
                    }
                    if(!lstshare.isEmpty()){
                        system.debug('lstshare'+lstshare);
                        insert lstshare;}
                }
                catch(Exception e){
                    system.debug('Exception:'+e.getMessage());
                    system.debug('Exception:'+e.getLineNumber());
                }
            }
        }
        
        
        if(trigger.isupdate && trigger.Isbefore)
        {
            Set<Id> leadIds = new Set<Id>();
            for(lead record: Trigger.new)
            {
                leadIds.add(record.Id);
            }
            
            list<leadShare> lstLdShare = [SELECT Id, leadAccessLevel, leadId, RowCause, UserOrGroupId 
                                          FROM   leadShare 
                                          WHERE  leadId IN :leadIds AND 
                                          RowCause = 'Manual'];
            
            for(lead record: Trigger.new)
            {
                //leadIds.add(record.Id);
                system.debug('For Source@Lead Update'+record.LeadSource);
                system.debug('For Source@Lead new n=map'+record.OwnerId);
                system.debug('For Source@Lead oldmap'+Trigger.oldMap.get(record.Id).OwnerId);
                
                
                if(record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId && record.OwnerId!=rrID )
                {
                    RecursiveTriggerHandler.isFirstTime = false;
                    system.debug('in first if for before update owner');
                    if(Test.isRunningTest() && Limits.getFutureCalls() >= Limits.getLimitFutureCalls()) 
                    {
                        system.debug(LoggingLevel.Error, 'Future method limit reached. Skipping...');
                    } else {
                        if(lstLdShare.size()>0 && Limits.getFutureCalls() < Limits.getLimitFutureCalls() )
                        {
                            system.debug('in else');
                            
                            Persistence.persistSharing(
                                JSON.serialize(
                                    [SELECT Id, leadAccessLevel, leadId, RowCause, UserOrGroupId 
                                     FROM   leadShare 
                                     WHERE  leadId IN :leadIds AND 
                                     RowCause = 'Manual'])); 
                            
                        }
                    }
                }
                if(record.LeadSource != Trigger.oldMap.get(record.Id).LeadSource)
                {
                    system.debug('in second if for before update LeadSource');
                    if(Test.isRunningTest() && Limits.getFutureCalls() >= Limits.getLimitFutureCalls()) {
                        system.debug(LoggingLevel.Error, 'Future method limit reached. Skipping...');
                    } else {
                        if(lstLdShare.size()>0 && Limits.getFutureCalls() < Limits.getLimitFutureCalls())
                        {
                            Persistence.persistSharingDelLead(
                                JSON.serialize(
                                    [SELECT Id, leadAccessLevel, leadId, RowCause, UserOrGroupId 
                                     FROM   leadShare 
                                     WHERE  leadId IN :leadIds AND 
                                     RowCause = 'Manual'])); 
                            
                        }
                    }
                }
            }
        }
        
        if(trigger.isupdate && trigger.Isafter)
        {
            
            Set<string> leadShareIds = new Set<string>(); 
            Set<string> leadSourceNames = new Set<string>(); 
            
            List<lead> lstUpdatedLead = new List<Lead>();
            
            for(lead record: Trigger.new)
            {
                if(record.LeadSource != Trigger.oldMap.get(record.Id).LeadSource)
                {
                    RecursiveTriggerHandler.isFirstTime = false;
                    leadShareIds.add(record.LeadSource);
                }
                if(Trigger.newMap.get(record.Id).OwnerId != Trigger.oldMap.get(record.Id).OwnerId)//record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId)
                {
                    RecursiveTriggerHandler.isFirstTime = false;
                    lstUpdatedLead.add(record);
                }
            }
            if(leadShareIds!=null)
            { 
                list<LeadShare> lstshare=new list<LeadShare>();
                
                system.debug('in first if for after update LeadShareid');
                
                list<Custom_Sharing_Criteria__c> lstCSC=[select id,name,Lead_Source__c,User_Group_ID__c from Custom_Sharing_Criteria__c where Lead_Source__c=:leadShareIds ]; 
                for(Custom_Sharing_Criteria__c csc:lstCSC)
                { 
                    if(csc.User_Group_ID__c != null && csc.User_Group_ID__c != ''){
                        if(!mapcsc1.isEmpty() && mapcsc1.containsKey(csc.Lead_Source__c))
                        {
                            
                            mapcsc1.get(csc.Lead_Source__c).add(csc.User_Group_ID__c);
                        }
                        else
                        {
                            mapcsc1.put(csc.Lead_Source__c,New Set<String>{csc.User_Group_ID__c});   
                        }
                    }
                }
                for(lead ld:Trigger.new)
                {
                    if(ld.LeadSource!=null && mapcsc1.containskey(ld.LeadSource))
                    {
                        
                        system.debug('Line 169@@@@@ ');
                        lstowner=new set<string>();
                        lstowner=mapcsc1.get(ld.LeadSource);
                        for(string acessid:lstowner)
                        {
                            if(ld.ownerId!=acessid)
                            {
                                system.debug('acessid'+acessid);
                                LeadShare ldshare= new LeadShare();
                                ldshare.LeadId=ld.id;
                                ldshare.LeadAccessLevel='Edit';
                                ldshare.RowCause='Manual';
                                ldshare.UserOrGroupId=acessid;
                                lstshare.add(ldshare);  
                                system.debug('ldshare'+ldshare);
                            }
                        }                 
                        
                    }
                }
                if(!lstshare.isEmpty()){
                    system.debug('lstshare for leadShareIds '+lstshare);
                    
                    insert lstshare;}
            }
            if(lstUpdatedLead!=null)
            {
                list<LeadShare> lstshare=new list<LeadShare>();
                
                system.debug('in second if for after update lstUpdatedLead');
                for(Lead ld:lstUpdatedLead)
                {
                    leadSourceNames.add(ld.LeadSource);   
                }
                list<Custom_Sharing_Criteria__c> lstCSC=[select id,name,Lead_Source__c,User_Group_ID__c from Custom_Sharing_Criteria__c where Lead_Source__c=:leadSourceNames ];
                
                for(Custom_Sharing_Criteria__c csc:lstCSC)
                {
                    if(csc.User_Group_ID__c != null && csc.User_Group_ID__c != ''){
                        if(!mapcsc1.isEmpty() && mapcsc1.containsKey(csc.Lead_Source__c))
                        {
                            mapcsc1.get(csc.Lead_Source__c).add(csc.User_Group_ID__c);
                        }
                        else
                        {
                            mapcsc1.put(csc.Lead_Source__c,New Set<String>{csc.User_Group_ID__c});   
                        }  
                    }
                }
                for(lead ld:Trigger.new)
                {
                    if(ld.LeadSource!=null && mapcsc1.containskey(ld.LeadSource))
                    {
                        
                        system.debug('Line 169@@@@@ ');
                        lstowner=new set<string>();
                        lstowner=mapcsc1.get(ld.LeadSource);
                        for(string acessid:lstowner)
                        {
                            if(ld.ownerId!=acessid)
                            {
                                system.debug('acessid'+acessid);
                                LeadShare ldshare= new LeadShare();
                                ldshare.LeadId=ld.id;
                                ldshare.LeadAccessLevel='Edit';
                                ldshare.RowCause='Manual';
                                ldshare.UserOrGroupId=acessid;
                                lstshare.add(ldshare);  
                                system.debug('ldshare'+ldshare);
                            }
                        }                 
                        
                    }
                }
                if(!lstshare.isEmpty()){
                    system.debug('lstshare for lstUpdatedLead'+lstshare);
                    insert lstshare;}
            }
        } 
    }
}