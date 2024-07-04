@isTest
public class OpportunityTriggerDemo_Test {
    static testMethod void insertLead() { 
      
            
        Opportunity ab = new Opportunity();
        ab.Name = 'Test';
        ab.CloseDate = System.today();
        ab.StageName = 'Settled';
        insert ab;
            
            
             Opportunity hj1 = [Select id,Name from Opportunity];
    
    }

}