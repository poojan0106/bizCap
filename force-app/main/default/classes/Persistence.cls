public with sharing class Persistence {
    
    @future
    public static void persistSharing(String ShareString) {
        LeadShare[] reasons = (LeadShare[])JSON.deserialize(shareString, LeadShare[].class);
        system.debug('++++++===='+reasons.Size());
        for(LeadShare reason: reasons)
            reason.Id = null;
        system.debug('++++++===='+reasons);
        try
        {
            Database.insert(reasons, false);
        }
        catch(dmlexception e)
        {
            system.debug('ERROR  '+E.getMessage());
        }
    }
    
    @future
    public static void persistSharingDelLead(String ShareString) {
        LeadShare[] reasons = (LeadShare[])JSON.deserialize(shareString, LeadShare[].class);
        system.debug('++++++===='+reasons.Size());
        system.debug('++++++===='+reasons);
        try
        {
            Database.Delete(reasons, false);
        }
        catch(dmlexception e)
        {
            system.debug('ERROR  '+E.getMessage());
        }
    }
    
    @future
    public static void persistSharings(String ShareStr) {
        OpportunityShare[] rea = (OpportunityShare[])JSON.deserialize(shareStr, OpportunityShare[].class);
        system.debug('++++++===='+rea.size());
        for(OpportunityShare reas: rea)
            reas.Id = null;
        system.debug('++++++===='+rea);
        try
        {
            Database.insert(rea, false);
        }
        catch(dmlexception e)
        {
            system.debug('ERROR  '+E.getMessage());
        }
    }
    
    @future
    public static void persistSharingsOppDelete(String ShareStr) {
        OpportunityShare[] rea = (OpportunityShare[])JSON.deserialize(shareStr, OpportunityShare[].class);
        
        try
        {
            Database.Delete(rea, false);
        }
        catch(dmlexception e)
        {
            system.debug('ERROR  '+E.getMessage());
        }
    }
    
}