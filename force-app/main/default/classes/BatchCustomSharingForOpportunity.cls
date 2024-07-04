global class BatchCustomSharingForOpportunity implements Database.Batchable<Opportunity>
{
    Map<string,set<string>> mapCustomSh=new Map<string,set<string>>();
    set<string> Set_CSC= new set<string>();
    public BatchCustomSharingForOpportunity(Map<string,set<string>> mapcsc)
    {
        mapCustomSh.putAll(mapcsc); 
    }
    global List<Opportunity> start(Database.BatchableContext BC)
    {   
        list<Opportunity> lstopp=[select id,name,LeadSource from Opportunity where LeadSource=:mapCustomSh.keyset() ];
        return lstopp;
    }
    global void execute(Database.BatchableContext BC, list<Opportunity> scope)
    {
        list<OpportunityShare> lstshare=new list<OpportunityShare>();
        set<string> lstownerid;
        list<string> lstowner;
        list<string> lstupdateOwner;
        //set<string> setowner;
        map<id,list<string>> mapOpportunityShare=new map<id,list<string>>();
        set<id> parentid=new set<id>();
        list<string> lstid;
        for(Opportunity opp:scope)
        {
            parentid.add(opp.id);
        }
        if(!parentid.isempty())
        {
            list<OpportunityShare> lstShr=[select OpportunityId,OpportunityAccessLevel,RowCause,UserOrGroupId from OpportunityShare where OpportunityId=:parentid and RowCause='Manual'];
            if(!lstShr.isempty())
            {
                for (OpportunityShare ls:lstShr)
                {
                    lstid=new list<string>();        
                    lstid.add(ls.UserOrGroupId);
                    if(!mapOpportunityShare.isEmpty() && mapOpportunityShare.containsKey(ls.OpportunityId))
                    {
                        lstupdateOwner=new list<string>();
                        lstupdateOwner=mapOpportunityShare.get(ls.OpportunityId);
                        lstid=lstupdateOwner;
                        mapOpportunityShare.put(ls.OpportunityId,lstid);
                    }
                    else
                    {
                        mapOpportunityShare.put(ls.OpportunityId,lstid);            
                    }            
                }}}
        for(Opportunity ld:scope)
        {
            lstownerid=new set<string>();
            lstownerid=mapCustomSh.get(ld.LeadSource);
            if(!mapOpportunityShare.containsKey(ld.id))
            {
                //lstownerid=new list<string>();
                //lstownerid=mapCustomSh.get(ld.LeadSource);
                
                if(!lstownerid.isempty())
                {
                    for(string ownerid:lstownerid)
                    {
                        OpportunityShare opshare = new OpportunityShare();
                        opshare.OpportunityId=ld.id;
                        opshare.OpportunityAccessLevel='Edit';
                        opshare.RowCause='Manual';
                        opshare.UserOrGroupId=ownerid;
                        lstshare.add(opshare);
                    }
                }
            }
            else 
            {
                //lstownerid=new list<string>();
                //lstownerid=mapCustomSh.get(ld.LeadSource);
                // setowner= new set<string>();
                lstowner=new list<string> ();
                lstowner=mapOpportunityShare.get(ld.id);
                for(string owner:lstownerid)
                {
                    if(!lstowner.Contains(owner))
                    {
                        OpportunityShare opshare = new OpportunityShare();
                        opshare.OpportunityId=ld.id;
                        opshare.OpportunityAccessLevel='Edit';
                        opshare.RowCause='Manual';
                        opshare.UserOrGroupId=owner;
                        lstshare.add(opshare);
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