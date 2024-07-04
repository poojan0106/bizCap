/**
 * Auto Generated and Deployed by Fast Prefill - Formstack
 **/
trigger FFPrefill_Trigger7F671 on Contact
    (after insert)
{
 if  (trigger.isAfter  &&  trigger.isInsert) { 
List<Contact>  newlyInsertedItems =  [SELECT  Id ,  Form_Update_URL_CONTACT__c FROM  Contact WHERE  Id  IN :trigger.new] ; 
List<string> ids = new List<string>();
 for ( Contact e  : newlyInsertedItems) { 
ids.add(e.id); 
} 
 VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'Contact' ,  'Form_Update_URL_CONTACT__c' ,  'a0o2s000000kE4rAAE' ,  ids,null );  
 update newlyInsertedItems;}
}