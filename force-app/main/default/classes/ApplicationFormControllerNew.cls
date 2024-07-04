public with sharing class ApplicationFormControllerNew{
    
    public Lead objLead{get; set;}
    public Lead objLeadToUpdate{get; set;}
    public String strErrorMessage{get;set;}
    //public String strDateOfBirth{get;set;}
    //public String strDateOfBirthOwner{get;set;}
    //public String dateBusinessEstablished{get;set;}
    public List<Owner_Details__c> listOwnerDetails{get;set;}
    public String strRemoveOwnerIndex{get;set;}
    //public string leadId{get;set;}
    public List<Lead> listLeads{get;set;}
    
    /********************************************************************************************
    Purpose: Constructor for Application Page
    Initialize variables
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    *********************************************************************************************/
    public ApplicationFormControllerNew(ApexPages.standardcontroller objController){
        //leadId = ApexPages.currentPage().getParameters().get('Id');
        //system.debug('#@##@#' +objLead);
       
        objLead = (Lead)objController.getRecord();
        
        if(objLead != null && String.isNotBlank(objLead.Id)){
            List<Lead> listLeads = new List<Lead>([select Id, LastName, FirstName, RecordTypeId, Title, Company, Street, City, State, 
                                          PostalCode, Country, Phone, MobilePhone, Email, Website, Description, LeadSource, Status, Industry, 
                                          Rating, AnnualRevenue, NumberOfEmployees, OwnerId, Business_Trading_Name__c, ACN__c, ABN__c, 
                                          No_of_Locations__c, Physical_Address__c, Suburb_Physical__c, State_Physical__c, Post_Code_Physical__c, 
                                          Mailing_Address__c, Suburb_Mailing__c, State_Mailing__c, Post_Code_Mailing__c, Telephone_Number__c, 
                                          Business_Established_New__c , Length_of_Ownership__c, Loan_Purpose__c, Type_of_Entity__c, 
                                          Products_or_Services_Sold__c, Fax, Application_Confirmed__c,
                                          Landlord_Mortgage__c, Contact_Account__c, Monthly_Rent__c, 
                                          Time_Remaining_on_Lease_Mortgage__c, Phone_BussProp__c, Amount_requested__c, Monthly_Revenue__c, (select Id, OwnerId, Name, Title__c, Ownership__c, 
                                          Home_Address__c, Suburb__c, State__c, Postal_Code__c, Length_at_Address__c, Date_Of_Birth__c, Tel_W__c, 
                                          Tel_M__c, Last_Name__c, Email__c, Lead__c, Are_you_a_Politically_Exposed_Person__c from Owner_Details__r) FROM Lead WHERE Id =:objLead.Id LIMIT 1]);
       
           
            if(listLeads != null && listLeads.size() > 0){
                objLeadToUpdate = listLeads[0];
                
                if(listLeads[0].Owner_Details__r != null && listLeads[0].Owner_Details__r.size() > 0){
                    listOwnerDetails = new List<Owner_Details__c>();
                    for(Owner_Details__c objOwner :listLeads[0].Owner_Details__r){
                        listOwnerDetails.add(objOwner);
                    }
                } else{
                    listOwnerDetails = new List<Owner_Details__c>();
                    listOwnerDetails.add(new Owner_Details__c());
                }
                objLeadToUpdate.id = null;
            }
        } else{
           
            objLeadToUpdate = new Lead();
            listOwnerDetails = new List<Owner_Details__c>();
            listOwnerDetails.add(new Owner_Details__c());
        
        }

        //strErrorMessage = '';
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        system.debug('sdsdssddsd' +msgs );
    }
    
    public void saveApplication(){
    
     List<Apexpages.Message> msgs3= ApexPages.getMessages();
        system.debug('sdsdssdddsdsd' +msgs3);
        
     
       strErrorMessage = '';
        /*
        strErrorMessage = '';
        
        validateApplication();
        system.debug('WEEWEWEe' +strErrorMessage);
        if (String.isNotBlank(strErrorMessage)) {
            return;
        }
        */
        List<Lead> listDuplicateLeads = new List<Lead>();
        Id aplicationRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Application').getRecordTypeId();
        system.debug('eRWERWRER' +ApexPages.getMessages());
        try {
        //system.debug('eRWERWewwewrweRER' +ApexPages.getMessages());
            //system.debug('WEEQWEQWEQWEQWEQWEeweqwee' +objLead);
            if(objLeadToUpdate != null && String.isBlank(objLead.Id)){
                //system.debug('WEEQWEQWEQWEQWEQWE' +objLead);
                if(objLeadToUpdate.Email != null && objLeadToUpdate.Email != ''){
                    listDuplicateLeads = [select Id, LastName, FirstName, RecordTypeId, Title, Company, Street, City, State, 
                                          PostalCode, Country, Phone, MobilePhone, Email, Website, Description, LeadSource, Status, Industry, 
                                          Rating, AnnualRevenue, NumberOfEmployees, OwnerId, Business_Trading_Name__c, ACN__c, ABN__c, 
                                          No_of_Locations__c, Physical_Address__c, Suburb_Physical__c, State_Physical__c, Post_Code_Physical__c, 
                                          Mailing_Address__c, Suburb_Mailing__c, State_Mailing__c, Post_Code_Mailing__c, Telephone_Number__c, 
                                          Business_Established_New__c , Length_of_Ownership__c, Loan_Purpose__c, Type_of_Entity__c, 
                                          Products_or_Services_Sold__c, Fax, Application_Confirmed__c,
                                          Landlord_Mortgage__c, Contact_Account__c, Monthly_Rent__c, 
                                          Time_Remaining_on_Lease_Mortgage__c, Phone_BussProp__c, Amount_requested__c, Monthly_Revenue__c, (select Id, OwnerId, Name, Title__c, Ownership__c, 
                                          Home_Address__c, Suburb__c, State__c, Postal_Code__c, Length_at_Address__c, Date_Of_Birth__c, Tel_W__c, 
                                          Tel_M__c, Last_Name__c, Email__c, Lead__c, Are_you_a_Politically_Exposed_Person__c from Owner_Details__r) FROM Lead WHERE Email =: objLeadToUpdate.Email];
                system.debug('eRWERWwrwrrrwerwRER' +ApexPages.getMessages());
                }
                if(listDuplicateLeads != null && listDuplicateLeads.size() > 0){
                    objLeadToUpdate = listDuplicateLeads[0];
                    //objLead.Id = objLeadToUpdate.Id;
                    if (listDuplicateLeads[0].Owner_Details__r != null && listDuplicateLeads[0].Owner_Details__r.size() > 0){
                        listOwnerDetails = listDuplicateLeads[0].Owner_Details__r;
                    } else{
                    
                    }
                    
                    /*
                    if(strDateOfBirth != '' && strDateOfBirth != null){
                        date dateOfBirth = date.parse(strDateOfBirth);
                        objLead.Date_Of_Birth__c = dateOfBirth;
                    }
                    if(strDateOfBirthOwner != '' && strDateOfBirthOwner != null){
                        date dateOfBirthOwner = date.parse(strDateOfBirthOwner);
                        objLead.Date_Of_Birth_Owner__c = dateOfBirthOwner;
                    }
                    */
                    objLead.Country = 'Australia';
                    //Update objLead;
                    
                } else{
                    //listOwnerDetails = new List<Owner_Details__c>();
                    system.debug('eRWEdfsdffsfsfRWRER' +ApexPages.getMessages());
                    objLeadToUpdate.LeadSource = 'Application';
                    objLeadToUpdate.Country = 'Australia';
                    objLeadToUpdate.LastName = objLeadToUpdate.Company;
                    objLeadToUpdate.RecordTypeId = aplicationRecordTypeId;
                    /*
                    if(strDateOfBirth != '' && strDateOfBirth != null){
                        date dateOfBirth = date.parse(strDateOfBirth);
                        objLead.Date_Of_Birth__c = dateOfBirth;
                    }
                    if(strDateOfBirthOwner != '' && strDateOfBirthOwner != null){
                        date dateOfBirthOwner = date.parse(strDateOfBirthOwner);
                        objLead.Date_Of_Birth_Owner__c = dateOfBirthOwner;
                    }
                    */
                    //date dateOfusinessEstablished = date.parse(dateBusinessEstablished);
                    
                    
                    //objLead.Business_Established__c = dateOfusinessEstablished;
                    //insert objLead;
                    //objLead = new Lead();
                    //strErrorMessage = 'success';
                   
                } 
                
                if(objLeadToUpdate != null){
               
                    upsert objLeadToUpdate;
              
                    if (objLeadToUpdate != null && String.IsBlank(objLeadToUpdate.Id) == false) {
                        for(Owner_Details__c objOwner :listOwnerDetails){
                            objOwner.Lead__c = objLeadToUpdate.Id;
                        }
                    }
                    if(listOwnerDetails != null && listOwnerDetails.size() > 0){
                        upsert listOwnerDetails;
                    }
                }
                
                 objLeadToUpdate = new Lead();
                    //strErrorMessage = 'success';
            } 
            List<Owner_Details__c> listOwnertoUpsert = new List<Owner_Details__c>();
            if(objLead != null && String.isNotBlank(objLead.Id)){
                objLeadToUpdate.Id = objLead.Id;
                update objLeadToUpdate;
                objLeadToUpdate.Id = null;
                if(listOwnerDetails != null && listOwnerDetails.size() > 0){
                    system.debug('@$$@@#$@$#' +listOwnerDetails);
                    for(Owner_Details__c objOwner :listOwnerDetails){
                        objOwner.Lead__c = objLead.Id;
                        listOwnertoUpsert.add(objOwner);
                    }
                    upsert listOwnertoUpsert;
                }
            }
            
           
        }catch (Exception objEx) {
            strErrorMessage = objEx.getMessage();
            system.debug('EWEWWEWEWE'+strErrorMessage );
        }
        
        
    }
    
    /********************************************************************************************
       Purpose: Applicationcustom validation method before save
       Parameters: 
       Returns: 
       Throws [Exceptions]: 
    *********************************************************************************************/
     /*
    public void validateApplication(){
       
        if(objLead.Application_Confirmed__c == false){
            strErrorMessage  = 'Please confirm you have read and understood Bizcap Privacy Policy';
            return;
        }
        
       
        if (String.isBlank(objLead.Company) || String.isBlank(objLead.Business_Trading_Name__c) || String.isBlank(objLead.ABN__c)
            || String.isBlank(objLead.Physical_Address__c) || String.isBlank(objLead.Suburb_Physical__c) || String.isBlank(objLead.State_Physical__c)
            || String.isBlank(objLead.Post_Code_Physical__c) || (objLead.Telephone_Number__c == null) || String.isBlank(objLead.Email)
            || String.isBlank(objLead.Length_of_Ownership__c) || (objLead.Amount_requested__c == null) || (objLead.Monthly_Revenue__c == null)
            || String.isBlank(objLead.Type_of_Entity__c) || String.isBlank(objLead.Loan_Purpose__c) || String.isBlank(objLead.Products_or_Services_Sold__c)) {
        
            strErrorMessage = 'please fill in all mandatory fields marked with an asterisk (✶)';
            return;
        }
        system.debug('#$#@$$#$#@$$32' +listOwnerDetails.size());
        system.debug('#$#@$$#$#@$$32' +listOwnerDetails);
        if(listOwnerDetails != null && listOwnerDetails.size() > 0){
            for(Owner_Details__c objOwner :listOwnerDetails){
                if (String.isBlank(objOwner.Name) || String.isBlank(objOwner.Last_Name__c) || String.isBlank(objOwner.Title__c)
                || objOwner.Ownership__c == null || String.isBlank(objOwner.Home_Address__c) || String.isBlank(objOwner.Suburb__c) || String.isBlank(objOwner.State__c)
                || String.isBlank(objOwner.Postal_Code__c) || String.isBlank(objOwner.Length_at_Address__c) || objOwner.Date_Of_Birth__c == null || String.isBlank(objOwner.Email__c)
                || objOwner.Tel_M__c == null || String.isBlank(objOwner.Are_you_a_Politically_Exposed_Person__c)){
                    strErrorMessage = 'please fill in all mandatory fields marked with an asterisk (✶)';
                    return;
                }
            }
           
        }
        
        
    }
    */
    public void addOwner(){
        Owner_Details__c objOwnerDetail = new Owner_Details__c();
        listOwnerDetails.add(objOwnerDetail);
    }
    
    public void deleteOwner(){
        system.debug('@#####2' +listOwnerDetails);
        system.debug('@#####2' +strRemoveOwnerIndex);
        if(listOwnerDetails.size() > -1){
            if (!String.isBlank(strRemoveOwnerIndex)) {
                listOwnerDetails.remove(Integer.valueOf(strRemoveOwnerIndex));
            }     
        }
    }  
    
    
    public Boolean hasError { get { return ApexPages.hasMessages(); } }
    
    
}