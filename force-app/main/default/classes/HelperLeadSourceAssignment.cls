public class HelperLeadSourceAssignment 
{
    public static void CustomSharingCreation(List<Lead_Source_Assignment__c> lstLSA)
    {
        if(!lstLSA.isEmpty() && lstLSA.size() > 0)
        {
            list<Custom_Sharing_Criteria__c> lstlead=new list<Custom_Sharing_Criteria__c>();
            list<Custom_Sharing_Criteria__c> lstopp=new list<Custom_Sharing_Criteria__c>();
            
            try
            {
                for(Lead_Source_Assignment__c lsa:lstLSA)
                {
                    Custom_Sharing_Criteria__c lead=new Custom_Sharing_Criteria__c();
                    
                    lead.Lead_Source__c=lsa.Name;
                    lead.User_Group_ID__c=lsa.Lead_Source_Assignment__c;
                    lead.Source__c='Lead';
                    //leadOpp.OwnerId=lsa.OwnerId;
                    lstlead.add(lead);
                    system.debug('lstlead'+lstlead);
                }
                if(!lstlead.isEmpty() && lstlead.size() > 0)
                {
                    insert lstlead;
                }
                for(Lead_Source_Assignment__c lsa:lstLSA)
                {
                    Custom_Sharing_Criteria__c Opp=new Custom_Sharing_Criteria__c();
                    
                    Opp.Lead_Source__c=lsa.Name;
                    Opp.User_Group_ID__c=lsa.Lead_Source_Assignment__c;
                    Opp.Source__c='Opportunity';
                    //leadOpp.OwnerId=lsa.OwnerId;
                    lstopp.add(Opp);
                    system.debug('lstopp'+lstopp);
                }
                if(!lstopp.isEmpty() && lstopp.size() > 0)
                {
                    insert lstopp;
                }
                
            }
            catch(Exception e)
            {
                system.debug('Exception:'+e.getMessage());
                system.debug('Exception:'+e.getLineNumber());
            }
        }
    }
    
}