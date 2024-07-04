trigger Trigger_Opportunity on Opportunity (after insert,after update,before update) 
{
	TriggerSwitch__c checkForStatus = [select IsActive__c from TriggerSwitch__c
                                       where Name= 'Trigger_Opportunity'];
        
    if(checkForStatus.IsActive__c)
    {
    set<string> lstownerids;
    set<id> stid=new set<id>();
    set<string> lstupdateCode1;
    set<string> lstowner;
    //list<OpportunityShare> lstshare=new list<OpportunityShare>();
    
    
    map<id,id> mapopp = new map<id,id>(); 
    list<OpportunityShare> lstshr=new list<OpportunityShare>();
    map<string,set<string>> mapcsc=new map<string,set<string>>();
    set<string> lstid =new set<string>();
    list<OpportunityShare> lstshare=new list<OpportunityShare>();
    //public static list<OpportunityShare> lstshares=new list<OpportunityShare>();
    list<string> lstsourceCode =new list<string>();
    set<string> lstupdateCode;
    list<string> lstids;
    list<string> lstupdateOwner;
    list<string> lstownerid;    
    map<string,list<string>> mapOpportunityShare=new map<string,list<string>>();  
    list<string> lstSourceCode1 =new list<string>();
    Set<string> lstUserId = new Set<string>();
    map<string,set<string>> mapcsc1=new map<string,set<string>>();
            set<string> lstUserRoles=new set<string>();
        set<string> lstRoles=new set<string>();
        set<string> lstupdateCodeForRole;
        map<string,set<string>> mapcscWithRole=new map<string,set<string>>();
        map<string,string> mapWithRoleId=new map<string,string>();
        set<string> lstRoleIds=new set<string>();
        map<string,set<string>> mapWithLdSourceRole=new map<string,set<string>>();
        set<string> tempHoldRole;

    
    
    if(RecursiveTriggerHandler.isFirstTime)
    {
        if(trigger.isafter && trigger.isinsert)
        {
            RecursiveTriggerHandler.isFirstTime = false;
            
            try
            {
                for(opportunity opp:trigger.new)
                {
                    lstsourceCode.add(opp.LeadSource);
                }
                list<Custom_Sharing_Criteria__c> lstCSC=[select id,name,User_Role__c,Lead_Source__c,User_Group_ID__c from Custom_Sharing_Criteria__c where Lead_Source__c=:lstsourceCode ];
                
                if(!lstCSC.isEmpty())
                    {
                for(Custom_Sharing_Criteria__c csc:lstCSC)
                {
                    if(csc.User_Group_ID__c !=null && csc.User_Group_ID__c !='')
                        {
                    lstid.add(csc.User_Group_ID__c);
                    system.debug('lstid'+lstid);
                    if(!mapcsc.isEmpty() && mapcsc.containsKey(csc.Lead_Source__c))
                    {
                        lstupdateCode=new set<string>();
                        lstupdateCode=mapcsc.get(csc.Lead_Source__c);
                        lstid=lstupdateCode;
                        mapcsc.put(csc.Lead_Source__c,lstid);
                    }
                    else
                    {
                        mapcsc.put(csc.Lead_Source__c,lstid);   
                    } 
                }
                    else if(csc.User_Role__c !=null && csc.User_Role__c !='') //To get map of leadsource and roles else if
                        {
                          lstUserRoles.add(csc.User_Role__c);
                            lstRoles.add(csc.User_Role__c);
                        system.debug('83 lstRoles'+lstRoles);
                        if(!mapcscWithRole.isEmpty() && mapcscWithRole.containsKey(csc.Lead_Source__c))
                        {
                            lstupdateCodeForRole=new set<string>();
                            lstupdateCodeForRole=mapcscWithRole.get(csc.Lead_Source__c);
                            lstRoles=lstupdateCodeForRole;
                            mapcscWithRole.put(csc.Lead_Source__c,lstRoles);
                        }
                        else
                        {
                            mapcscWithRole.put(csc.Lead_Source__c,lstRoles);   
                        }
                    }
                }
                
                //Get Role Ids
                    if(!lstUserRoles.isEmpty()){
                        
                        List<Group> lstGroupName = [Select Id,Name,RelatedId,Type,DeveloperName  From Group where RelatedId IN (select Id from userRole where DeveloperName in :lstUserRoles) and Type='Role'];
                   
                        //To Create map of Role Name With Role Id                       
                    if(!lstGroupName.isEmpty())
                    {
                        for(Group gp:lstGroupName)
                        {
                            mapWithRoleId.put(gp.DeveloperName,gp.id);
                        }
                    }
                    system.debug('111 '+mapWithRoleId);

                        //To Create map of LeadSource With Role Id
                        if(!mapWithRoleId.isEmpty())//New Map
                    {
                        for(string ldSource:mapcscWithRole.KeySet())
                        {
                            Set<String> setRoles = mapcscWithRole.get(ldSource);
                            for(string role:setRoles)
                            {//mapWithLdSourceRole
                           		if(mapWithRoleId.containsKey(role))
                                {
                                    String users = mapWithRoleId.get(role);
                                    {
                                        lstRoleIds.add(users);
                                        if(!mapWithLdSourceRole.isEmpty() && mapWithLdSourceRole.containsKey(ldSource))
                                        {
                                            tempHoldRole=new set<string>();
                                            tempHoldRole=mapWithLdSourceRole.get(ldSource);
                                            lstRoleIds=tempHoldRole;
                                            mapWithLdSourceRole.put(ldSource,lstRoleIds);
                                        }
                                        else
                                        {
                                            mapWithLdSourceRole.put(ldSource,lstRoleIds);   
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                        
                    }
                    }
                    system.debug('147 '+mapWithLdSourceRole);
                
                
                system.debug('lstid'+lstid);
                system.debug('mapcsc'+mapcsc);  
                for(opportunity opp:Trigger.new)
                {
                    if(opp.LeadSource!=null && mapcsc.containskey(opp.LeadSource))
                    {
                        
                        lstownerids=new set<string>();
                        lstownerids=mapcsc.get(opp.LeadSource);
                        for(string acessid:lstownerids)
                        {
                            //if(opp.ownerId!=acessid) 
                            //{
                                system.debug('acessid'+acessid);
                                OpportunityShare oppshare= new OpportunityShare();
                                oppshare.OpportunityId=opp.id;
                                oppshare.OpportunityAccessLevel='Edit';
                                oppshare.RowCause='Manual';
                                oppshare.UserOrGroupId=acessid;
                                lstshare.add(oppshare);  
                                system.debug('oppshare'+oppshare);
                           // }
                        }
                    }
                     //Insert Lead Share for the Roles
                        if(opp.LeadSource!=null && mapWithLdSourceRole.containskey(opp.LeadSource))
                        {
                            lstownerids=new set<string>();
                            lstownerids=mapWithLdSourceRole.get(opp.LeadSource);
                            for(string acessid:lstownerids)
                            {
                                if(opp.ownerId!=acessid)
                                {
                               		
                                    system.debug('acessid'+acessid);
                                    OpportunityShare oppshare= new OpportunityShare();
                                    oppshare.OpportunityId=opp.id;
                                    oppshare.OpportunityAccessLevel='Edit';
                                    oppshare.RowCause='Manual';
                                    oppshare.UserOrGroupId=acessid;
                                    lstshare.add(oppshare);  
                                    system.debug('oppshare'+oppshare);
                                }
                            }                 
                            
                        }
                }
                
                if(!lstshare.isEmpty()){
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
    Set<Id> OppIds = new Set<Id>();
    for(Opportunity record: Trigger.new)
    {
        OppIds.add(record.Id);
    }
    List<OpportunityShare> lstOppShare = [SELECT Id, OpportunityAccessLevel, OpportunityId, RowCause, UserOrGroupId 
                     FROM   OpportunityShare
                     WHERE  OpportunityId IN :OppIds AND 
                     RowCause = 'Manual'];
    
    for(Opportunity record: Trigger.new)
    {
        OppIds.add(record.Id);
        if(record.OwnerId != Trigger.oldMap.get(record.Id).OwnerId)
        {
                                RecursiveTriggerHandler.isFirstTime = false;

            if(Test.isRunningTest() && Limits.getFutureCalls() >= Limits.getLimitFutureCalls())
            {
                    system.debug(LoggingLevel.Error, 'Future method limit reached. Skipping...');
                } 
            else 
            {
                if(OppIds.size()>0 && Limits.getFutureCalls() < Limits.getLimitFutureCalls())
                {
                    Persistence.persistSharings(
                JSON.serialize(
                    [SELECT Id, OpportunityAccessLevel, OpportunityId, RowCause, UserOrGroupId 
                     FROM   OpportunityShare
                     WHERE  OpportunityId IN :OppIds AND 
                     RowCause = 'Manual']));
        }
        }
        }
        
        if(record.LeadSource != Trigger.oldMap.get(record.Id).LeadSource)
        {
            if(Test.isRunningTest() && Limits.getFutureCalls() >= Limits.getLimitFutureCalls()) {
                    system.debug(LoggingLevel.Error, 'Future method limit reached. Skipping...');
                } else {
                    if(OppIds.size()>0 && Limits.getFutureCalls() < Limits.getLimitFutureCalls())
                        {
            Persistence.persistSharingsOppDelete(
                JSON.serialize(
                    [SELECT Id, OpportunityAccessLevel, OpportunityId, RowCause, UserOrGroupId 
                     FROM   OpportunityShare
                     WHERE  OpportunityId IN :OppIds AND 
                     RowCause = 'Manual']));
                }   
                }
        }   
    }
    
}

if(trigger.isupdate && trigger.IsAfter)
{
    Set<string> oppShareIds = new Set<string>();
    for(Opportunity record: Trigger.new)
    {
        oppShareIds.add(record.LeadSource);
        
        if(record.LeadSource != Trigger.oldMap.get(record.Id).LeadSource)
        {
            
         RecursiveTriggerHandler.isFirstTime = false;

            system.debug('record.LeadSource'+record.LeadSource);
            
            list<Custom_Sharing_Criteria__c> lstCSC=[select id,name,Lead_Source__c,User_Role__c,User_Group_ID__c from Custom_Sharing_Criteria__c where Lead_Source__c=:oppShareIds ];
            
            if(!lstCSC.isEmpty())
                {
            for(Custom_Sharing_Criteria__c csc:lstCSC)
            { 
                if(csc.User_Group_ID__c !=null && csc.User_Group_ID__c !='')
                        {
                system.debug('@@@Line 148  '+lstCSC);
                //lstid=new list<string>();
                system.debug('csc.User_Group_ID__c'+csc.User_Group_ID__c);
                lstUserId.add(csc.User_Group_ID__c);
                
                system.debug('lstUserId'+lstUserId);
                if(!mapcsc1.isEmpty() && mapcsc1.containsKey(csc.Lead_Source__c))
                {
                    lstupdateCode1=new set<string>();
                    lstupdateCode1=mapcsc1.get(csc.Lead_Source__c);
                    lstUserId=lstupdateCode1;
                    mapcsc1.put(csc.Lead_Source__c,lstUserId);
                }
                else
                {
                    mapcsc1.put(csc.Lead_Source__c,lstUserId);   
                } 
            }
                //To get map of leadsource and roles
                        else if(csc.User_Role__c !=null && csc.User_Role__c !='')
                        {
                             lstUserRoles.add(csc.User_Role__c);
                            lstRoles.add(csc.User_Role__c);
                        system.debug('lstRoles'+lstRoles);
                        if(!mapcscWithRole.isEmpty() && mapcscWithRole.containsKey(csc.Lead_Source__c))
                        {
                            lstupdateCodeForRole=new set<string>();
                            lstupdateCodeForRole=mapcscWithRole.get(csc.Lead_Source__c);
                            lstRoles=lstupdateCodeForRole;
                            mapcscWithRole.put(csc.Lead_Source__c,lstRoles);
                        }
                        else
                        {
                            mapcscWithRole.put(csc.Lead_Source__c,lstRoles);   
                        }
                        }
            }
                      //Get Role Ids
                    if(!lstUserRoles.isEmpty()){
                        
                        List<Group> lstGroupName = [Select Id,Name,RelatedId,Type,DeveloperName  From Group where RelatedId IN (select Id from userRole where DeveloperName in :lstUserRoles) and Type='Role'];
                   
                        //To Create map of Role Name With Role Id                       
                    if(!lstGroupName.isEmpty())
                    {
                        for(Group gp:lstGroupName)
                        {
                            mapWithRoleId.put(gp.DeveloperName,gp.id);
                        }
                    }
                        //To Create map of LeadSource With Role Id
                        if(!mapWithRoleId.isEmpty())//New Map
                    {
                        for(string ldSource:mapcscWithRole.KeySet())
                        {
                            Set<String> setRoles = mapcscWithRole.get(ldSource);
                            for(string role:setRoles)
                            {//mapWithLdSourceRole
                           		if(mapWithRoleId.containsKey(role))
                                {
                                    String users = mapWithRoleId.get(role);
                                    {
                                        lstRoleIds.add(users);
                                        if(!mapWithLdSourceRole.isEmpty() && mapWithLdSourceRole.containsKey(ldSource))
                                        {
                                            tempHoldRole=new set<string>();
                                            tempHoldRole=mapWithLdSourceRole.get(ldSource);
                                            lstRoleIds=tempHoldRole;
                                            mapWithLdSourceRole.put(ldSource,lstRoleIds);
                                        }
                                        else
                                        {
                                            mapWithLdSourceRole.put(ldSource,lstRoleIds);   
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                        
                    }
        }
            for(opportunity opport:Trigger.new)
            {
                if(opport.LeadSource!=null && mapcsc1.containskey(opport.LeadSource))
                {
                    
                    system.debug('Line 169@@@@@ ');
                    lstowner=new set<string>();
                    lstowner=mapcsc1.get(opport.LeadSource);
                    for(string acessid:lstowner)
                    {
                        //if(opport.ownerId!=acessid)
                        //{
                            system.debug('acessid'+acessid);
                            OpportunityShare oppShare= new OpportunityShare();
                            oppShare.OpportunityId=opport.id;
                            oppShare.OpportunityAccessLevel='Edit';
                            oppShare.RowCause='Manual';
                            oppShare.UserOrGroupId=acessid;
                            lstshare.add(oppShare);  
                            system.debug('ldshare'+lstshare);
                        //}
                    }                 
                    
                }
            }
            if(!lstshare.isEmpty()){
                insert lstshare;}
        }
    } 
} 
}
}