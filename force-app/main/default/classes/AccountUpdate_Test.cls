@isTest
public class AccountUpdate_Test {
    
    static testMethod void insertLead() { 
      
            
            Account ab = new Account();
            ab.Name = 'Test';
            insert ab;
            
            
             Account hj1 = [Select id,Name from Account];
    
    }
    
}