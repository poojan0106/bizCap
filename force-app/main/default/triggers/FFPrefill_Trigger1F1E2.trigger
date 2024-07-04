/**
 * Auto Generated and Deployed by Fast Prefill - Formstack
 **/
trigger FFPrefill_Trigger1F1E2 on Lead
    (after insert)
{
 if  (trigger.isAfter  &&  trigger.isInsert) { 
List<Lead>  newlyInsertedItems =  [SELECT  Id ,  NZ_Application_Link__c FROM  Lead WHERE  Id  IN :trigger.new] ; 
List<string> ids = new List<string>();
 for ( Lead e  : newlyInsertedItems) { 
ids.add(e.id); 
} 
 VisualAntidote.FastFormsUtilities.DoUpdateRecords( 'Lead' ,  'NZ_Application_Link__c' ,  'a0o2s000000kBpRAAU' ,  ids,null );  
 update newlyInsertedItems;}
}