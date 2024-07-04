trigger Trigger_CustomSharingCriteria on Custom_Sharing_Criteria__c (after insert) 
{
    TriggerSwitch__c checkForStatus = [select IsActive__c from TriggerSwitch__c
                                       where Name= 'Trigger_CustomSharingCriteria'];
        
    if(checkForStatus.IsActive__c)
    {
        set<string> lstUserRoles=new set<string>();
        set<string> lstRoles=new set<string>();
        set<string> tempHoldRole;

        map<string,set<string>> mapcscWithRole=new map<string,set<string>>();
        map<string,set<string>> mapCombineRoleUser=new map<string,set<string>>();
        map<string,string> mapWithRoleId=new map<string,string>();
        set<string> lstRoleIds=new set<string>();
        map<string,set<string>> mapWithLdSourceRole=new map<string,set<string>>();

        set<string> lstupdateCodeForRole;
        
        
        Map<string,Set<string>> mapcsc=new Map<string,set<string>>();
        set<string> lstupdateCode;
        set<string> lstid;
        boolean triggerindex;
        for(Custom_Sharing_Criteria__c csc:trigger.new)
        {
             system.debug('Lokesh@@ '+csc.User_Role__c);
            if(csc.Source__c=='Lead')
            {
                triggerindex=True;
                if(csc.User_Group_ID__c !=null && csc.User_Group_ID__c !='')
                {
                    lstid=new set<string>();        
                    lstid.add(csc.User_Group_ID__c);
                    if(!mapcsc.isEmpty() && mapcsc.containsKey(csc.Lead_Source__c))
                    {            
                        lstupdateCode=new set<string>();
                        lstupdateCode=mapcsc.get(csc.Lead_Source__c);
                        lstid.addall(lstupdateCode);
                        system.debug(lstid);
                        mapcsc.put(csc.Lead_Source__c,lstid);
                        system.debug(mapcsc);
                    }
                    else
                    {
                        mapcsc.put(csc.Lead_Source__c,lstid);
                        system.debug('++++++++++  ' +mapcsc);
                    }}
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
                    system.debug('64  '+ mapcscWithRole);
                }
            }
        else
        {
            triggerindex=false;
            if(csc.User_Group_ID__c !=null && csc.User_Group_ID__c !='')
                {
            lstid=new set<string>();        
            lstid.add(csc.User_Group_ID__c);
            if(!mapcsc.isEmpty() && mapcsc.containsKey(csc.Lead_Source__c))
            {            
                lstupdateCode=new set<string>();
                lstupdateCode=mapcsc.get(csc.Lead_Source__c);
                lstid.addAll(lstupdateCode);
                system.debug(lstid);
                mapcsc.put(csc.Lead_Source__c,lstid);
                system.debug(mapcsc);
            }
            else
            {
                mapcsc.put(csc.Lead_Source__c,lstid);
                system.debug('************ '+mapcsc);
            } 
        }
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
                    system.debug('64  '+ mapcscWithRole);
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
                        system.debug('100 '+mapWithRoleId);
                    }
                        //To Create map of LeadSource With Role Id
                        if(!mapWithRoleId.isEmpty())//New Map
                    {
                        for(string ldSource:mapcscWithRole.KeySet())
                        {
                            Set<String> setRoles = mapcscWithRole.get(ldSource);
                            system.debug('108 '+setRoles);
                            for(string role:setRoles)
                            {//mapWithLdSourceRole
                                system.debug('111 '+role);
                           		if(mapWithRoleId.containsKey(role))
                                {
                                    String users = mapWithRoleId.get(role);
                                    system.debug('115 '+users);
                                    {
                                        lstRoleIds.add(users);
                                        if(!mapWithLdSourceRole.isEmpty() && mapWithLdSourceRole.containsKey(ldSource))
                                        {
                                            tempHoldRole=new set<string>();
                                            tempHoldRole=mapWithLdSourceRole.get(ldSource);
                                            lstRoleIds=tempHoldRole;
                                            mapWithLdSourceRole.put(ldSource,lstRoleIds);
                                            system.debug('124 '+mapWithLdSourceRole);
                                        }
                                        else
                                        {
                                            mapWithLdSourceRole.put(ldSource,lstRoleIds);  
                                            system.debug('128 '+mapWithLdSourceRole);
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                        
                    }
        system.debug('140 '+mapWithLdSourceRole);
        mapCombineRoleUser.putAll(mapcsc);
        for (String key : mapWithLdSourceRole.keySet()) {
            if (mapCombineRoleUser.containsKey(key)) {
                mapCombineRoleUser.get(key).addAll(mapWithLdSourceRole.get(key));
                system.debug('145 '+mapCombineRoleUser);
            } else {
                mapCombineRoleUser.put(key, mapWithLdSourceRole.get(key));
                system.debug('148 '+mapCombineRoleUser);
            }
        }
        
    if(!mapCombineRoleUser.isEmpty() && triggerindex==True)
    {
        system.debug('154 '+mapCombineRoleUser);
        database.executeBatch(New BatchCustomSharingCriteria(mapCombineRoleUser));
    }
    if(!mapCombineRoleUser.isEmpty() && triggerindex==False)
    {
        database.executeBatch(New BatchCustomSharingForOpportunity(mapCombineRoleUser));
    }
    }
}