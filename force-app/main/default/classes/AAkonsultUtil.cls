/**
* @author AAkonsult Consulting
* @date 
*
* @group 
*
* @description Handy and common methods 
*
* @maintenance
*/
public virtual with sharing class AAkonsultUtil {
    public static Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe(); 

    /** Stores a map of SObject names to the RTInfo describe map. */
    private static Map<String, Map<String, Schema.RecordTypeInfo>> objectToSchemaMap = new Map<String, Map<String, Schema.RecordTypeInfo>>();
    private static Map<String, Map<Id, Schema.RecordTypeInfo>> objectToSchemaNameMap = new Map<String, Map<Id, Schema.RecordTypeInfo>>();

    public static integer checkBatchProcessorRunning(string apexClasses) {
        return checkBatchProcessorRunning(apexClasses,true);
    }

    public static integer checkBatchProcessorRunning(string apexClasses, boolean includeScheduled) {
        if (apexClasses == null || apexClasses =='') {return 0;}
        list <string> apexClassList = apexClasses.split(',');
        list<string> jobTypeList = new list<string>{'BatchApex'};
        if (includeScheduled) {
            jobTypeList.add('ScheduledApex');
        }
        
        Integer runningBatchJobs = [
          select count()
          from AsyncApexJob
          where JobType in :jobTypeList
          and status in ('Holding','Queued','Processing','Preparing')
          and ApexClass.Name in :apexClassList
          and ApexClass.NameSpacePrefix = 'AAkPay'
        ];
        return runningBatchJobs;
    }
    
    /*******************************************************************************************************
    * @description Returns a list of select option
    * @param String pObjectName: the API name of the object eg. 'Account'
    * @param String pFieldName: the API name of the picklist field eg. 'Type' 
    * @return 
    * @maintenance
    */
    public static List<SelectOption> pickListSelectOption(String pObjectName,String pFieldName) {
        return pickListSelectOption(pObjectName,pFieldName,'');
    }

    /* Overload of the pickListSelectOption to set the first value eg. '--None--' */
    public static List<SelectOption> pickListSelectOption(String pObjectName,String pFieldName, String pFirstValue) {
        List<SelectOption> options = new List<SelectOption>();

        if (pFirstValue != null && pFirstValue != '') {
            options.add(new SelectOption(pFirstValue,pFirstValue));
        }
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(pObjectName).getDescribe().fields.getMap();       
        List<Schema.PicklistEntry> fieldMapValues = fieldMap.get(pFieldName).getDescribe().getPicklistValues();
        for( Schema.PicklistEntry ple :  fieldMapValues) {
            options.add(new SelectOption(ple.getLabel(),ple.getLabel())); 
        }                                                       
        
        return options; 
    }

    /*******************************************************************************************************
    * @description Checks the custom metadata types to see if the disbale all triggers is ticked
    * @param label: The name of the custom metadata type eg. 'Default'
    * @param 
    * @return True if all triggers have been disabled
    * @maintenance
    */
    public static map<string,AAkonsult_Settings__mdt> AAkSettingMap {get {
        if (AAkSettingMap == null) {
            AAkSettingMap = new map<string,AAkonsult_Settings__mdt>();
            for (AAkonsult_Settings__mdt[] p2usSettingList : [Select id,Label, Disable_Triggers__c from AAkonsult_Settings__mdt limit 1000] ) {
                for (AAkonsult_Settings__mdt p2usSetting : p2usSettingList) {
                    AAkSettingMap.put(p2usSetting.label,p2usSetting);
                }
            }
        }
        return AAkSettingMap;
    } set;}

    public static Boolean allTriggersDisabled(String label) {
    	Boolean result = false;
        if (AAkSettingMap != null && AAkSettingMap.containsKey(label)) {
            result = AAkSettingMap.get(label).Disable_Triggers__c;
        }

    	return result;
    }

    /*******************************************************************************************************
    * @description 	returns a query String that can be used for a dymanic SOQL query. Query String includes all fields as returned by getObjectFieldMap
    *				Eg. thisQuery = AAkonsultUtil.doQuerySObject(contractIdList,contractProductServicesFieldMap,'Contract_Product_Service__c','agreement__r.Id');
    * @param 
    * @param 
    * @return String
    * @maintenance
    */
    public static String doQuerySObject(List<Id> objectIdList,Map <String, Schema.SObjectField> fromObjectFieldMap,String objectName,String whereId) {      
        Set<String> ignoreFields = new Set<String>();
        Set<String> extraFields = new Set<String>();
            
        return doQuerySObject(objectIdList,fromObjectFieldMap,objectName,whereId,ignoreFields,false,false,extraFields);         
    }
            
    /* overloading of doQuerySObject with extra parameter to ignore formula fields. */

	public static String doQuerySObject(List<Id> objectIdList,Map <String, Schema.SObjectField> fromObjectFieldMap,String objectName,String whereId,Set<String> ignoreFields,boolean ignoreFormula,boolean noWhereClause) {  
		Set<String> extraFields = new Set<String>();
		return doQuerySObject(objectIdList,fromObjectFieldMap,objectName,whereId,ignoreFields,ignoreFormula,noWhereClause,extraFields); 
	}

    public static String doQuerySObject(List<Id> objectIdList,Map <String, Schema.SObjectField> fromObjectFieldMap,String objectName,String whereId,Set<String> ignoreFields,boolean ignoreFormula,boolean noWhereClause,Set<String> extraFields) {     

        String thisQuery = '';
        // Get list of all fields on the object
        for(Schema.SObjectField sfield : fromObjectFieldMap.Values()){  
            schema.describefieldresult dfield;
            try {
                dfield= sfield.getDescribe(); 
            } catch (Exception e) {
                continue;
            }
                        
            // mainly used for person accounts - contacts to ignore AccountId for updates
            if (ignoreFields != null && ignoreFields.contains(dfield.getname())) {
                continue;
            }
            
            // sometimes too many query fields.  This will reduce number being queried.
            if (ignoreFormula && dfield.isCalculated()) {
                continue;
            }

            if (thisQuery != '') {
                thisQuery+=',';
            }              
            thisQuery+= dfield.getname();  
        }  
  
  		if (extraFields != null ) {
  			for (String extraField : extraFields) {
	            if (thisQuery != '') {
	                thisQuery+=',';
	            }
	            thisQuery+=	extraField;			
  			}
  		}
        
        // Build up where clause for to select all id's passed to this function
        String thisWhere='';
        for (Id objectId : objectIdList) {
            if (thisWhere == '') {
                thisWhere +='( '+whereId+' = \''+objectId+'\'';
            } else {
                thisWhere +='OR '+whereId+' = \''+objectId+'\'';
            }
        }
        thisWhere += ' )';

        thisQuery='Select ' +thisQuery+' from '+objectName;

        if (!noWhereClause) {
            thisQuery += ' where '+thisWhere;
        }
        return thisQuery;
    }

    /*******************************************************************************************************
    * @description Writes to the error log object
    * @param programArea: class name and method error was thrown from
    * @param subject: what the method was trying to do when it failed
    * @param errDescription: The details of the error. This is usually the Exception.getMessage()
    * @return 
    * @maintenance
    */
    public static void errorLog(String programArea,String subject,String errDescription) {
        Error_Log__c errorLog = new Error_Log__c(program_Area__c=programArea,Subject__c=subject,Description__c=errDescription,Status__c='New');
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.allowFieldTruncation = true;
        errorLog.setOptions(dmo);
        List<Error_Log__c> errorLogList = new List<Error_Log__c>();
        system.debug('Error Log:'+errorLog);
        errorLogList.add(errorLog);
        
        if (limits.getDMLStatements() < limits.getLimitDMLStatements()  ) {
            try {
                Database.insert(ErrorLogList,false);
            } Catch (Exception e) { 
                system.debug('unexpected error'+e);
            }   
        } else {
            system.debug('DML on error log exceeded');
        }
    }

    /*******************************************************************************************************
    * @description Returns a list of select options with value = field api name and label = field label
    * @param pObjectName: The API name of the object eg. 'Error_Log__c'
    * @param 
    * @return A list of selectoptions 
    * @maintenance
    */
    public static List<SelectOption> fieldNameSelectOption(String pObjectName) {
        List<SelectOption> options = new List<SelectOption>();

        if (!schemaMap.containsKey(pObjectName)){ return options;}
        
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(pObjectName).getDescribe().fields.getMap();       

        for (String fieldMapItem : fieldMap.keySet()) {         
            options.add(new SelectOption(fieldMapItem,fieldMap.get(fieldMapItem).getDescribe().getLabel() ));
        }                                                       
        
        return options; 
    }

    /*******************************************************************************************************
    * @description Returns a record type Id for an Object and Record Type 
    * @param SObjectName: The API name of the Object eg. 'Error_Log__c'
    * @param recordTypeName: The DeveloperName of the record type
    * @return 
    * @maintenance
    */
    public static Id getRecordTypeIdFor(String SObjectName, String recordTypeName) {
        String target = SObjectName.toLowerCase();
        Map<String, Schema.RecordTypeInfo> rtMap = objectToSchemaMap.get(target);
        if (rtMap == null) { // need to populate it
            Schema.SObjectType objToken = schemaMap.get(target);
            if (objToken == null) {
                return null;
            }
            rtMap = objToken.getDescribe().getRecordTypeInfosByName();

            objectToSchemaMap.put(target, rtMap);
        }
        Schema.RecordTypeInfo rtInfo = rtMap.get(recordTypeName);

        return (rtInfo == null) ? null : rtInfo.getRecordTypeId();
    }

    /*******************************************************************************************************
    * @description Returns a record type name for an Object and Record Type Id 
    * @param SObjectName: The API name of the Object eg. 'Error_Log__c'
    * @param recordTypeName: The Id of the record type
    * @return 
    * @maintenance
    */
    public static String getRecordTypeNameFor(String SObjectName, Id recordTypeId) {
        String target = SObjectName.toLowerCase();
        Map<String, Schema.RecordTypeInfo> rtMap = objectToSchemaMap.get(target);
        Map<Id, Schema.RecordTypeInfo> rtNameMap = new Map<Id, Schema.RecordTypeInfo>();
        if (rtMap == null || rtNameMap.isEmpty() ) { // need to populate it
            Schema.SObjectType objToken = schemaMap.get(target);
            if (objToken == null) {
                return null;
            }
            rtNameMap = objToken.getDescribe().getRecordTypeInfosById();
            objectToSchemaMap.put(target, rtMap);
        }
        Schema.RecordTypeInfo rtNameInfo = rtNameMap.get(recordTypeId);
        return (rtNameInfo == null) ? null : rtNameInfo.getName();
    }

    /*******************************************************************************************************
    * @description Return a list of select options with value and label = record type name
    * @param SObjectName: The API name of the object eg. 'Error_Log__c'
    * @param 
    * @return 
    * @maintenance
    */
    public static list<SelectOption> getRecordTypeSelectOptionFor(String SObjectName) {
        String target = SObjectName.toLowerCase();
        Map<String, Schema.RecordTypeInfo> rtMap = objectToSchemaMap.get(target);
        list<SelectOption> RecordTypeSelectOptionList = new list<SelectOption>();
        if (rtMap == null) { // need to populate it
            Schema.SObjectType objToken = schemaMap.get(target);
            if (objToken == null) {
                return RecordTypeSelectOptionList;
            }
            rtMap = objToken.getDescribe().getRecordTypeInfosByName();
            objectToSchemaMap.put(target, rtMap);
        }
        
        for (Schema.RecordTypeInfo rtInfo : rtMap.values() ) {
            if (rtInfo.isAvailable() && rtInfo.getName() != 'Master') {
                RecordTypeSelectOptionList.add(new SelectOption(rtInfo.getName(),rtInfo.getName() ));
            }
        }
        return RecordTypeSelectOptionList;
    }

    /*******************************************************************************************************
    * @description Returns a comma seperated list of fields that are in both the objects passed in. This can be used to copy fields between objects
    * @param fromObjectFieldMap: a map of the from (source) object name and it's fields
    * @param toObjectFieldMap: a map of the to (target) object name and it's fields
    * @return comma seperated string of field API names that exists on both objects
    * @maintenance
    */
    public static String buildCommonQuery(Map <String, Schema.SObjectField> fromObjectFieldMap,Map <String, Schema.SObjectField> toObjectFieldMap) {
        
        String queryString = '';
        
        // Check all fields Account to see if field with same name on Person Account. If field is not empty, copy value across
        for(String sfieldNa : toObjectFieldMap.keySet() ){  

            // had to do this as getDescribe was having an uncaught exception.
            if (sfieldNa == 'LastViewedDate' || sfieldNa == 'LastReferencedDate' ) {
                continue;
            }
 
			if (!fromObjectFieldMap.containsKey(sfieldNa)) {
				continue;
			}        
    
            if ( sfieldNa != 'Id' && sfieldNa != 'RecordTypeId' && sfieldNa != 'OwnerId' && sfieldNa != 'Name' && sfieldNa != 'LastViewedDate' && sfieldNa != 'IsDeleted' && sfieldNa != 'SystemModstamp' && sfieldNa != 'LastModifiedById' && sfieldNa != 'LastModifiedDate' && sfieldNa != 'CreatedById'  && sfieldNa != 'CreatedDate') {
            	queryString += ','+sfieldNa;
            }
          
        }
        
        return queryString;
    }

    private static boolean isPersonEnabled = false; // only required if using person accounts.
    
    /*******************************************************************************************************
    * @description 	Copies from one sobject to another sobject. If the name, type of field are the same on the 
    				source object and destination object the these values get copied across. 
    				This routine is when copying from one sobject type to another.  If its the same object, then a sobject.clone() could be used.
    * @param fromObjectFieldMap: a map of the from (source) object name and it's fields
    * @param toObjectFieldMap: a map of the to (target) object name and it's fields
    * @param fromObjectRec: the record that is the source
    * @param toObjectRec: the record that is the target
    * @param IsCreate: ?
    * @param createOnlyFieldSet: ?
    * @return 
    * @maintenance
    */
    public static void doCopyObjectFields(Map <String, Schema.SObjectField> fromObjectFieldMap,Map <String, Schema.SObjectField> toObjectFieldMap ,SOBject fromObjectRec,SOBject toObjectRec,boolean IsCreate,set<String> createOnlyFieldSet) {
        
        // Check all fields Account to see if field with same name on Person Account. If field is not empty, copy value across
        for(String sfieldNa : toObjectFieldMap.keySet() ){  

            // had to do this as getDescribe was having an uncaught exception.
            if (sfieldNa == 'LastViewedDate' || sfieldNa == 'LastReferencedDate' ) {
                continue;
            }
            Schema.SObjectField sfield = toObjectFieldMap.get(sfieldNa);
            
            schema.describefieldresult dfield;
            try {
                dfield = sfield.getDescribe();
            } catch (Exception e) {
                continue;
            }           
            String dFieldName = dfield.getname();
    
            if ( ((dField.isUpdateable() && !IsCreate) || (dField.isCreateable() && IsCreate)) && dFieldName != 'Id' && dFieldName != 'RecordTypeId' && dFieldName != 'OwnerId' && dFieldName != 'Name' && dFieldName != 'LastViewedDate') {
                    
                if (isPersonEnabled && dFieldName == 'AccountId' && toObjectFieldMap.containsKey('IsPersonAccount') && toObjectRec.get('IsPersonAccount') == true ) {
                    continue;
                }
                if (dFieldName.endsWith('__pc')) {  // Allow for person account fields
                    dFieldName = dFieldName.substring(0, dFieldName.length()-4);
                    dFieldName += '__c';
                }
                if(!fromObjectFieldMap.containsKey(dFieldName) && !dFieldName.endsWith('__c')) {
                    // If Standard field on PersonAccount, check if matches custom field
                    // So Phone = Phone__c
                    if (fromObjectFieldMap.containsKey(dFieldName+'__c')) {
                        dFieldName += '__c';
                    } else {
                        // Match standard person (contact) fields with custom fields.  Ie., in the Account, all standard contact fields begin with person.... (eg. PersonMobilePhone)
                        // So PersonMobilePhone = MobilePhone__c
                        if (dFieldName.startsWith('Person')) {
                            dFieldName = dFieldName.substring(6, dFieldName.length())+'__c';
                        }
                    }
                } 
                try {
	                if(fromObjectFieldMap.containsKey(dFieldName)) {
	            
	                    if (fromObjectRec.get(dFieldName) != null) {
	                        schema.describefieldresult ffield = fromObjectFieldMap.get(dFieldName).getDescribe(); 
	                        // Only copy across boolean if true
	                        if (dfield.getType() == ffield.getType() || 
	                            (ffield.getType()== Schema.DisplayType.Picklist && (dfield.getType() == Schema.DisplayType.TextArea || dfield.getType() == Schema.DisplayType.String) ) ||
	                            (dfield.getType()== Schema.DisplayType.Picklist && (ffield.getType() == Schema.DisplayType.TextArea || ffield.getType() == Schema.DisplayType.String) )
	                            ) {
	                            // some fields are to only get populated on create.
	
	                            if ((!createOnlyFieldSet.contains(dfield.getname()) )
	                                  || (createOnlyFieldSet.contains(dfield.getname()) && 
	                                      (toObjectRec.get(dfield.getname()) == null || 
	                                         (dfield.getType() == Schema.DisplayType.String && toObjectRec.get(dfield.getname()) == '')
	                                         )
	                                        )
	                                      ) { 
	                        
	                                        toObjectRec.put(dfield.getname(), fromObjectRec.get(dFieldName));
	                            }
	                        }
	                    }
	                }
                } catch (Exception e) {
                	continue;
                }           
                                                
            }              
        }                       
            
    }

    // Overloading of doCopyObjectFields
    public static void doCopyObjectFields(Map <String, Schema.SObjectField> fromObjectFieldMap,Map <String, Schema.SObjectField> toObjectFieldMap ,SOBject fromObjectRec,SOBject toObjectRec) {
        set<String> createOnlyFieldSet = new Set<String>(); 
        doCopyObjectFields(fromObjectFieldMap,toObjectFieldMap ,fromObjectRec,toObjectRec,false,createOnlyFieldSet);        
    }
 
    public static void doCopyObjectFields(Map <String, Schema.SObjectField> fromObjectFieldMap,Map <String, Schema.SObjectField> toObjectFieldMap ,SOBject fromObjectRec,SOBject toObjectRec,boolean IsCreate) {
        set<String> createOnlyFieldSet = new Set<String>(); 
        doCopyObjectFields(fromObjectFieldMap,toObjectFieldMap ,fromObjectRec,toObjectRec,IsCreate,createOnlyFieldSet); 
    }

    /*******************************************************************************************************
    * @description Sends and error email to AAkonsult Consulting
    * @param errMessage: the error message to send in the body of the email
    * @param 
    * @return 
    * @maintenance
    */
    public static void sendErrorEmail(String errMessage) {
         Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {'consulting@aakonsult.com'};
         mail.setToAddresses(toAddresses);
         mail.setSenderDisplayName('Apex error message');
         mail.setSubject('Error from Org: ' + UserInfo.getOrganizationName()+' '+UserInfo.getOrganizationId());
         string eMessage = (errMessage == null) ? 'unknown error' : errMessage;
         mail.setPlainTextBody(eMessage);
         if (limits.getEmailInvocations() < limits.getLimitEmailInvocations()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         }
    }

    /*******************************************************************************************************
    * @description 	Returns dependant picklist values in a map. Key is the controlling picklist label and the values are the dependant picklist labels
    *   			Source: http://titancronus.com/blog/2014/07/03/acquiring-dependent-picklists-in-apex-contd/
    * @param pObjName: The API name of the object
    * @param pControllingFieldName: the API name of the controlling field
    * @param pDependantFieldName: the API name of the dependant field
    * @return Map of the each controlling field label and a list of its dependant field's label 
    * @maintenance
    */	
    public static Map<String,List<String>> getDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName) {
        Map<String,List<String>> mapResults = new Map<String,List<String>>();

        //verify/get object schema
        Schema.SObjectType pType = Schema.getGlobalDescribe().get(pObjName);
        if ( pType == null ) return mapResults;
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();

        //verify field names
        if (!objFieldMap.containsKey(pControllingFieldName) || !objFieldMap.containsKey(pDependentFieldName)) return mapResults;     

        //get the control & dependent values   
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();

        //clear heap
        objFieldMap = null;

        //initialize results mapping
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){           
            mapResults.put( ctrl_ple[pControllingIndex].getLabel(), new List<String>());
        }
        //cater for null and empty
        mapResults.put('', new List<String>());
        mapResults.put(null, new List<String>());

        //serialize dep entries        
        List<TPicklistEntry> objDS_Entries = new List<TPicklistEntry>();
        objDS_Entries = (List<TPicklistEntry>)JSON.deserialize(JSON.serialize(dep_ple), List<TPicklistEntry>.class);

        List<Integer> validIndexes;
        for (TPicklistEntry objDepPLE : objDS_Entries){

            validIndexes = cnvBits(objDepPLE.validFor);
            //System.Debug('cnvBits: [' + objDepPLE.label + '] = ' + validIndexes);

            for (Integer validIndex : validIndexes){                
                mapResults.get( ctrl_ple[validIndex-1].getLabel() ).add( objDepPLE.label );
            }
        }

        //clear heap
        objDS_Entries = null;

        return mapResults;
    }//GetDependentOptions

    public static List<Integer> B64ToBytes (String sIn) {
        Map<Integer,Integer> base64 = new Map<Integer,Integer>{65=>0,66=>1,67=>2,68=>3,69=>4,70=>5,71=>6,72=>7,73=>8,74=>9,75=>10,76=>11,77=>12,78=>13,79=>14,80=>15,81=>16,82=>17,83=>18,84=>19,85=>20,86=>21,87=>22,88=>23,89=>24,90=>25
                                                           ,97=>26,98=>27,99=>28,100=>29,101=>30,102=>31,103=>32,104=>33,105=>34,106=>35,107=>36,108=>37,109=>38,110=>39,111=>40,112=>41,113=>42,114=>43,115=>44,116=>45,117=>46,118=>47,119=>48,120=>49,121=>50,122=>51
                                                           ,48=>52,49=>53,50=>54,51=>55,52=>56,53=>57,54=>58,55=>59,56=>60,57=>61,43=>62,47=>63};

        List<Integer> lstOut = new List<Integer>();
        if ( sIn == null || sIn == '' ) return lstOut;
    
        sIn += '='.repeat( 4 - Math.mod( sIn.length(), 4) );

        for ( Integer idx=0; idx < sIn.length(); idx += 4 ) {
            if ( base64.get(sIn.charAt(idx+1)) != null ) lstOut.add( (base64.get(sIn.charAt(idx)) << 2) | (base64.get(sIn.charAt(idx+1)) >>> 4) );
            if ( base64.get(sIn.charAt(idx+2)) != null ) lstOut.add( ((base64.get(sIn.charAt(idx+1)) & 15)<<4) | (base64.get(sIn.charAt(idx+2)) >>> 2) );
            if ( base64.get(sIn.charAt(idx+3)) != null ) lstOut.add( ((base64.get(sIn.charAt(idx+2)) & 3)<<6) | base64.get(sIn.charAt(idx+3)) );
        }

        //System.Debug('B64ToBytes: [' + sIn + '] = ' + lstOut);
        return lstOut;
    }//B64ToBytes

    public static List<Integer> BlobToBytes (Blob input) {
        return B64ToBytes( EncodingUtil.base64Encode(input) );
    }//BlobToBytes

    // Converts a base64 string into a list of integers indicating at which position the bits are on
    public static List<Integer> cnvBits (String b64Str) {
        List<Integer> lstOut = new List<Integer>();
        if ( b64Str == null || b64Str == '' ) return lstOut;

        List<Integer> lstBytes = B64ToBytes(b64Str);

        Integer i, b, v;
        for ( i = 0; i < lstBytes.size(); i++ ) {
            v = lstBytes[i];
            //System.debug ( 'i['+i+'] v['+v+']' );
            for ( b = 1; b <= 8; b++ ) {
                //System.debug ( 'i['+i+'] b['+b+'] v['+v+'] = ['+(v & 128)+']' );
                if ( ( v & 128 ) == 128 ) lstOut.add( (i*8) + b );
                v <<= 1;
            }
        }

        //System.Debug('cnvBits: [' + b64Str + '] = ' + lstOut);
        return lstOut;
    }//cnvBits

    public class TPicklistEntry{
        public string active {get;set;}
        public string defaultValue {get;set;}
        public string label {get;set;}
        public string value {get;set;}
        public string validFor {get;set;}
        public TPicklistEntry(){}
    }//TPicklistEntry
 
    
    
    // thanks to: https://success.salesforce.com/ideaView?id=08730000000KgTYAA0
    
   	private static String kHexChars = '0123456789abcdef';

    public static String NewGuid() {

        String returnValue = '';
        Integer nextByte = 0;

        for (Integer i=0; i<16; i++) {

            if (i==4 || i==6 || i==8 || i==10) 
                returnValue += '-';

            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if (i==6) {
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }

            if (i==8) {
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }

            returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
            returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }

        return returnValue;
    }

    public static String getCharAtIndex(String str, Integer index) {

        if (str == null) return null;

        if (str.length() <= 0) return str;    

        if (index == str.length()) return null;    

        return str.substring(index, index+1);
    }          
    
}