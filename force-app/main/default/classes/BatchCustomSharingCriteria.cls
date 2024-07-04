global class BatchCustomSharingCriteria implements Database.Batchable<Lead>
{
    Map<string,Set<string>> mapCustomSh=new Map<string,Set<string>>();
    public BatchCustomSharingCriteria(Map<string,Set<string>> mapcsc)
    {
        mapCustomSh.putAll(mapcsc); 
        system.debug('7 '+mapCustomSh);
    }
    
    global List<Lead> start(Database.BatchableContext BC)
    {   
        list<lead> lstld=[select id,name,LeadSource from lead where LeadSource=:mapCustomSh.keyset()];
        system.debug('12 '+lstld);
        return lstld;
    }
    global void execute(Database.BatchableContext BC, list<lead> scope)
    {
        list<LeadShare> lstshare=new list<LeadShare>();
        Set<string> lstownerid;
        list<string> lstowner;
        list<string> lstupdateOwner;
        //set<string> setowner;
        map<id,list<string>> mapLeadShare=new map<id,list<string>>();
        set<id> parentid=new set<id>();
        list<string> lstid;
        for(lead ld:scope)
        {
            parentid.add(ld.id);
        }
        if(!parentid.isempty())
        {
            list<leadshare> lstShr=[select id,LeadId,LeadAccessLevel,RowCause,UserOrGroupId from leadshare where LeadId=:parentid and RowCause='Manual'];
            if(!lstShr.isempty())
            {
                for (leadshare ls:lstShr)
                {
                    lstid=new list<string>();        
                    lstid.add(ls.UserOrGroupId);
                    if(!mapLeadShare.isEmpty() && mapLeadShare.containsKey(ls.LeadId))
                    {
                        lstupdateOwner=new list<string>();
                        lstupdateOwner=mapLeadShare.get(ls.LeadId);
                        lstid=lstupdateOwner;
                        mapLeadShare.put(ls.LeadId,lstid);
                    }
                    else
                    {
                        mapLeadShare.put(ls.LeadId,lstid);            
                    }            
                }}}
        system.debug('51 '+mapLeadShare);
        for(lead ld:scope)
        {
            lstownerid=new Set<string>();
            lstownerid=mapCustomSh.get(ld.LeadSource);
            system.debug('56 '+lstownerid);
            if(!mapLeadShare.containsKey(ld.id))
            {
                //lstownerid=new list<string>();
                //lstownerid=mapCustomSh.get(ld.LeadSource);
                
                if(!lstownerid.isempty())
                {
                    for(string ownerid:lstownerid)
                    {
                         system.debug('66 '+ownerid);
                        leadshare ldshare = new leadshare();
                        ldshare.LeadId=ld.id;
                        ldshare.LeadAccessLevel='Edit';
                        ldshare.RowCause='Manual';
                        ldshare.UserOrGroupId=ownerid;
                        lstshare.add(ldshare);
                    }
                }
            }
            else 
            {
                //lstownerid=new list<string>();
                //lstownerid=mapCustomSh.get(ld.LeadSource);
                // setowner= new set<string>();
                lstowner=new list<string> ();
                lstowner=mapLeadShare.get(ld.id);
                for(string owner:lstownerid)
                {
                     system.debug('86 '+owner);
                    if(!lstowner.Contains(owner))
                    {
                         system.debug('88 '+owner);
                        leadshare ldshare = new leadshare();
                        ldshare.LeadId=ld.id;
                        ldshare.LeadAccessLevel='Edit';
                        ldshare.RowCause='Manual';
                        ldshare.UserOrGroupId=owner;
                        lstshare.add(ldshare);
                    }
                }                
            }
        }        
        if(!lstshare.isEmpty())
        {
            Database.SaveResult[] results= Database.Insert(lstshare,false);                
            
            if(!results.isempty()) 
            { 
                for(database.saveresult res:results) 
                { 
                    if(res.issuccess()) 
                    {
                        system.debug('Record has been inserted successfully and Record id....'+res.getid());
                    }
                    else
                    { 
                        for(database.error err: res.geterrors())
                        { 
                            system.debug('Error Message is...'+err.getMessage());
                            system.debug('Error Status Code is...'+err.getstatuscode()); 
                            system.debug('Effected Fields are...'+err.getfields()); 
                        } 
                    } 
                }
            }
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
                          a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
                          a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
    }   
}