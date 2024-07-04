/*
* Created by: Yogesh
* Desc: to create BPU records from lead records LeadTriggerByRes
* Updated on" 26/02/2020
* LastModifyBy :- Ranjeet Kadam on 24 August 2020
*/ 
public class LeadTriggerHandler { 
    
    public static boolean isFirstTimeUpdate = true;
    public static Boolean isFirstTimeBeforeUpdate = TRUE;
    
    //CALLING INSERT BPU METHOD
    public static void insertBPU(List<Lead> lstlead)
    {
        List<BPU__c> lstBPU = new List<BPU__c>();
        
        List<BPU__c> listOfBPU = [SELECT id, Lead__c FROM BPU__c WHERE Lead__c IN :lstLead];
        //MAIN IF STARTS
        if(lstLead != NULL && lstLead.size() > 0 && (listOfBPU == NULL || listOfBPU.size() == 0 ||  listOfBPU.isEmpty()))
        {
            system.debug('lstLead:INSERT::'+lstLead);
            //FOR STARTS
            for(Lead objLead : lstlead)
            { 
                system.debug('objLead.FirstName+'+ objLead.FirstName);
                // create BPU record
                BPU__c objBPU = new BPU__c();
                String lfname = objLead.FirstName != null ? objLead.FirstName : '';
                String llname = objLead.LastName != null ? objLead.LastName : '';
                objBPU.Name = lfname+' '+llname;
                objBPU.Lead__c = objLead.Id;
                objBPU.Status__c = objLead.Status;
                objBPU.Sub_Status__c = objLead.Lead_Sub_Status__c;
                objBPU.Factor_Rate__c = string.valueOf(objLead.Factor_Rate__c);
                
                if(objLead.Loan_Type__c == 'Add On') {
                    System.debug('@@ In Add On IF');
                    objBPU.Loan_Type__c = 'Renewal';
                } else {
                    system.debug('IN ESLE INSERT');
                    objBPU.Loan_Type__c = objLead.Loan_Type__c;
                }         
                
                objBPU.Loan_Amount__c = string.valueOf(objLead.Loan_Amount__c);
                objBPU.Loan_term_business_days__c = string.valueOf(objLead.Loan_term_business_days__c);
                objBPU.Payback_Amount__c = string.valueOf(objLead.Payback_Amount__c);
                objBPU.Factor_Rate__c = string.valueOf(objLead.Factor_Rate__c);
                objBPU.Funded_Date__c = string.valueOf(objLead.Funded_Date__c);
                objBPU.BC_Number__c = objLead.BC_Number__c;
                objBPU.Bizcap_Lead_Ref__c = objLead.Bizcap_Lead_Ref__c;
                objBPU.Email_Address__c = objLead.Email;
                
                objBPU.Lead_Reference__c = objLead.Lead_Reference__c;
                objBPU.Conditional_Approval_Amount__c = string.valueOf(objLead.Conditional_Approval_Amount__c);
                objBPU.Call_Attempts__c = string.valueOf(objLead.Call_Attempts__c);
                objBPU.Last_Call_Date__c = string.valueOf(objLead.Last_Call_Date__c);
                objBPU.Conditional_Approval_Date__c = string.valueOf(objLead.Conditional_Approval_Date__c);
                objBPU.Country_API__c = objLead.Country_API__c;
                
                if (objLead.LeadSource != null) 
                {
                    objBPU.Lead_Source__c = objLead.LeadSource;
                    /*Schema.DescribeFieldResult field = Lead.LeadSource.getDescribe();
for (Schema.PicklistEntry f : field.getPicklistValues())
{
if(objLead.LeadSource == f.getValue())
{
system.debug('inside this::>>'+f.getLabel());
objBPU.Lead_Source__c = f.getLabel();
}
}*/
                }
                objBPU.Company__c = objLead.Company;
                
                if (objLead.Formstack_Update_URL_ODIN__c != null && objLead.Formstack_Update_URL_ODIN__c != '') 
                {
                    objBPU.Formstack_Update_URL_ODIN__c = objLead.Formstack_Update_URL_ODIN__c;
                }
                
                lstBPU.add(objBPU);
            } //FOR ENDS
            system.debug('lstBPU::::'+lstBPU);
            System.debug('objBPU.Lead_Source__c:::'+lstBPU[0].Lead_Source__c);
            if(lstBPU!=NULL && lstBPU.size() > 0 )
            {
                System.debug(' $$$ list Bpu ::'+ lstBPU);
                insert lstBPU;
            }
            
        }//MAIN IF ENDS
    }
    
    //CALLING UPDATE BPU METHOD
    public static void updateBPURecords(List<Lead> leadList, Map<Id, Lead> leaMap)
    {
        system.debug('is update:::');
        System.debug('@@@ lstLead = '+leadList);
        List<BPU__c> updatelstBPU = new List<BPU__c>();
        
        List<BPU__c>  lstBPU = [Select id, Lead__c, Name, Status__c, Sub_Status__c from BPU__c where Lead__c IN: leadList];
        SYSTEM.debug('lstBPU::'+lstBPU);
        if(lstBPU != NULL && lstBPU.SIZE() > 0)
        {
            for(BPU__c objBPU : lstBPU)
            {
                Lead lea = leaMap.get(objBPU.Lead__c);
                BPU__c updateBPU = new BPU__c();
                updateBPU.Id = objBPU.id;
                updateBPU.Lead__c = objBPU.Lead__c;
                String lfname = lea.FirstName != null ? lea.FirstName : '';
                String llname = lea.LastName != null ? lea.LastName : '';
                updateBPU.Name = lfname+' '+llname;
                
                if(updateBPU.Status__c != lea.Status)
                {
                    updateBPU.Status__c = lea.Status;
                }
                
                if(updateBPU.Sub_Status__c != lea.Lead_Sub_Status__c)
                {
                    updateBPU.Sub_Status__c = lea.Lead_Sub_Status__c;
                }
                
                system.debug('updateBPU.Sub_Status__c>>'+updateBPU.Sub_Status__c);
                system.debug('updateBPU.Status__c>>'+updateBPU.Status__c);
                
                updateBPU.Factor_Rate__c = String.valueOf(lea.Factor_Rate__c);
                if(lea.Loan_Type__c == 'Add On')
                {
                    System.debug('@@ In Add On IF');
                    updateBPU.Loan_Type__c = 'Renewal';
                } else 
                {
                    updateBPU.Loan_Type__c = lea.Loan_Type__c;
                }  
                updateBPU.Loan_Amount__c = string.valueOf(lea.Loan_Amount__c);
                updateBPU.Loan_term_business_days__c = string.valueOf(lea.Loan_term_business_days__c);
                updateBPU.Payback_Amount__c = string.valueOf(lea.Payback_Amount__c);
                updateBPU.Factor_Rate__c = string.valueOf(lea.Factor_Rate__c);
                updateBPU.Funded_Date__c = string.valueOf(lea.Funded_Date__c);
                updateBPU.BC_Number__c = lea.BC_Number__c;
                updateBPU.Bizcap_lead_Ref__c = lea.Bizcap_lead_Ref__c;
                System.debug('@@@ Tets lead Email = '+lea.Email);
                updateBPU.Email_Address__c = lea.Email;
                updateBPU.Lead_Reference__c = lea.lead_Reference__c;
                updateBPU.Conditional_Approval_Amount__c = string.valueOf(lea.Conditional_Approval_Amount__c);
                updateBPU.Call_Attempts__c = string.valueOf(lea.Call_Attempts__c);
                updateBPU.Last_Call_Date__c = string.valueOf(lea.Last_Call_Date__c);
                updateBPU.Conditional_Approval_Date__c = string.valueOf(lea.Conditional_Approval_Date__c);
                updateBPU.Country_API__c = lea.Country_API__c;
                //if (lea.leadSource != null) 
                //{
                //System.debug(' $$$ leadList[i].leadSource :' + lea.leadSource);
                updateBPU.lead_Source__c = lea.leadSource;
                /*Schema.DescribeFieldResult field = Lead.LeadSource.getDescribe();
                System.debug('field ::>> '+field.getPicklistValues());
                for (Schema.PicklistEntry f : field.getPicklistValues())
                {
                if(lea.leadSource == f.getValue())
                {
                System.debug('f.getLabel() >> '+f.getLabel());
                updateBPU.lead_Source__c = f.getLabel();
                }
                }*/
                //}
                updateBPU.Company__c = lea.Company;
                
                //if (lea.Formstack_Update_URL_ODIN__c != null && lea.Formstack_Update_URL_ODIN__c != '') 
                //{
                updateBPU.Formstack_Update_URL_ODIN__c = lea.Formstack_Update_URL_ODIN__c;
                //}
                updatelstBPU.add(updateBPU);
                System.debug('updateBPU.lead_Source__c >>> '+updateBPU.lead_Source__c);
                system.debug('updatelstBPU>>'+updatelstBPU);
            }
        }
        
        if(updatelstBPU!=NULL && updatelstBPU.size()>0)
        {
            System.debug(' $$$ updatelstBPU :' + updatelstBPU);
            update updatelstBPU;
        }
    }
    
    //CALLING DELETE BPU METHOD
    public static void deleteBPU(List<Lead> leaList)
    {
        System.debug('---leaList-' +leaList);
        if(leaList != null && leaList.size() > 0)
        {
            List<BPU__c>  lstdelBPU = [Select id, Lead__c from BPU__c where Lead__c IN: leaList];
            if(lstdelBPU != null && lstdelBPU.size() > 0)
            {
                delete lstdelBPU;
            }
        }
    }
    
    public static void populateOppOnContacts (List<Lead> listofLead, List<id> convertedAcc, List<Id> convertedCon, List<Id> convertedOpp, String LeadEmail, String LeadCompany, String LeadReference)
    {
        system.debug('listofLead::'+listofLead);
        system.debug('convertedAcc::'+convertedAcc);
        system.debug('convertedCon::'+convertedCon);
        system.debug('convertedOpp::'+convertedOpp);
        system.debug('LeadEmail::'+LeadEmail);
        system.debug('LeadCompany::'+LeadCompany);
        
        //GET RECORD TYPE FROM LEAD Obj
        String RecTypePartnerForLead =  Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        System.debug('String RecTypePartnerForLead  N::'+RecTypePartnerForLead);
        
        if(ListOfLead!=NULL  && listOflead.size()>0 && convertedAcc!=NULL && convertedCon!=NULL && convertedOpp!=NULL)
        {
            System.debug('listofLead size :::: '+listofLead.size());
            System.debug('listofLead[0].recordtype :::: '+listofLead[0].RecordTypeId);
            
            //ACCOUNT CHECKBOX CODE STARTS 
            List<Account> listToUpdateAcc = new List<Account>();
            List<Account> listAcc = [SELECT id, is_Converted__c FROM Account WHERE ID IN: convertedAcc];
            
            String RecTypePartnerForAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
            System.debug('RecTypePartnerForAcc N::'+RecTypePartnerForAcc);
            String RecTypeCustomerForAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            System.debug('RecTypeCustomerForAcc N::'+RecTypeCustomerForAcc);
            
            if(listAcc!=NULL && listAcc.size()>0){
                for(Account objAccount : listAcc){
                    Account objAccs = new Account();
                    objAccs.id = objAccount.id;
                    if(listofLead[0].RecordtypeID == RecTypePartnerForLead && RecTypePartnerForAcc != null)
                    {
                        objAccs.RecordTypeId = RecTypePartnerForAcc;
                    }
                    else
                    {
                        objAccs.RecordTypeId = RecTypeCustomerForAcc;
                    }
                    objAccs.Is_Converted__c = TRUE;
                    
                    listToUpdateAcc.ADD(objAccs);
                }
            }
            
            system.debug('listToUpdateAcc::'+listToUpdateAcc);
            IF(listToUpdateAcc!=NULL && listToUpdateAcc.SIZE()>0){
                UPDATE listToUpdateAcc;
            }
            //ACCOUNT CHECKBOX CODE ENDS
            
            List<Opportunity> listToUpdateOpp = new List<Opportunity>();
            
            List<Opportunity> listOpps = [SELECT id, Contact__c, Lead_Email__c, Company__c FROM Opportunity WHERE ID IN: convertedOpp];
            
            if(listOpps!=NULL && listOpps.size()>0 && convertedCon!=NULL)
            {
                
                //GET OPPORTUNITY RECORD TYPE FROM SALESFORCE 
                String RecTypePartnerForOpp =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Partner Opportunity').getRecordTypeId();
                System.debug('RecTypePartnerForOpp ID N:::'+RecTypePartnerForOpp);
                
                String RecTypeDefaultForOpp =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                System.debug('RecTypeDefaultForOpp size:::'+RecTypeDefaultForOpp);
                
                //UPDATE OPPORTUNITY WITH RECORDTYPE ACCORDING TO LEAD
                for(Opportunity objOpp : listOpps){
                    for(id convertedContact : convertedCon){
                        Opportunity objOpps = new Opportunity();
                        objOpps.id = objopp.id;
                        if(listofLead[0].RecordtypeID == RecTypePartnerForLead && RecTypePartnerForOpp != null)
                        {
                            objOpps.RecordTypeId = RecTypePartnerForOpp;
                            objOpps.StageName = 'Onboarding';
                            objOpps.Sub_stage__c = 'No Leads Submitted yet';
                        }
                        else
                        {
                            objOpps.RecordTypeId = RecTypeDefaultForOpp;
                            objOpps.StageName = 'In progress';
                            objOpps.Sub_stage__c = 'Contract requested';
                        }
                        System.debug('objOpps.RecordType :::'+objOpps.RecordType);
                        objOpps.Contact__c = convertedContact;
                        objOpps.Lead_Email__c = LeadEmail;
                        objOpps.Company__c = LeadCompany;
                        objOpps.Is_Converted__c = TRUE;
                        objOpps.Bizcap_Lead_Ref__c = LeadReference;
                        objOpps.Lead_SFID__c = LeadReference;
                        listToUpdateOpp.add(objOpps);
                    }
                }
            }
            system.debug('listToUpdateOpp::'+listToUpdateOpp);
            if(listToUpdateOpp!=NULL && listToUpdateOpp.size()>0)
            {
                System.debug('listToUpdateOpp Record Type :::'+listToUpdateOpp[0].Recordtype.Name);
                update listToUpdateOpp;
            }
            
            LIST<BPU__c> listOfBPU = [SELECT id, Opportunity__c FROM BPU__c WHERE Lead__c IN: ListOfLead];
            List<BPU__c> ListToUpdateBPU = new List<BPU__c>();
            
            for(Opportunity objOpp : listToUpdateOpp)
            {
                for(BPU__c objBPU : listOfBPU)
                {
                    BPU__c objupdateBPU = new BPU__c();
                    objUpdateBPU.id = objBPU.id;
                    objUpdateBPU.Opportunity__c = objOpp.id;
                    objUpdateBPU.Is_Converted__c = true;
                    system.debug('objOpp.StageName::'+objOpp.StageName);
                    objUpdateBPU.Stage__c = objOpp.StageName;
                    objupdateBPU.Sub_Stage__c = objOPP.Sub_stage__c;
                    //objUpdateBPU.Sub_Status_Change_Date__c = system.now();
                    ListToUpdateBPU.add(objUpdateBPU);
                }
            }
            
            if(ListToUpdateBPU!=NULL && ListToUpdateBPU.SIZE()>0)
            {
                UPDATE ListToUpdateBPU;
            }
        }
    }
}