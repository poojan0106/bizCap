/**
 * Auto Generated and Deployed by Fast Prefill - Formstack
 **/
trigger FFPrefill_Trigger56C72 on Lead
    (after insert)
{
 if  (trigger.isAfter  &&  trigger.isInsert) { 
List<Lead>  newlyInsertedItems =  [SELECT  Id ,  Formstack_Update_URL_ODIN__c FROM  Lead WHERE  Id  IN :trigger.new] ; 
List<string> ids = new List<string>();
 for ( Lead e  : newlyInsertedItems) { 
ids.add(e.id); 
} 
 VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'Lead' ,  'Formstack_Update_URL_ODIN__c' ,  'a0o2s0000000CqjAAE' ,  ids,null );  
 update newlyInsertedItems;}
}