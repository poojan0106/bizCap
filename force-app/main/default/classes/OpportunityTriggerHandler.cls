/*
Created by: Yogesh
Desc: to create or update BPU records from Opportunity OpportunityTriggerHandler
Updated on" 26/02/2020
Updated By : Nrupa Vora
Date : 12/10/2020
*/ 
public class OpportunityTriggerHandler {
    public static Boolean isFirstTimeInsert = true;
    public static Boolean isFirstTimeUpdate = true;
    
    //UPDATING STAGE CHANGE DATE
    public static void updateopps(List<Opportunity> oppList)
    {
        List<Opportunity> listopp = new List<Opportunity>();
        for(Opportunity objOpps : oppList)
        {
            if(objOpps.Stage_Change_Date__c == null)
            {
                Opportunity updateOpp = new Opportunity();
                updateOpp.id = objOpps.id;
                updateOpp.Stage_Change_Date__c = system.now();
                updateOpp.Sub_Stage_Change_Date__c = system.now();
                listopp.add(updateOpp);
            }
        }
        
        if(listopp!=NULL && listopp.SIZE()>0)
        {
            UPDATE listopp;
        }
    }
    
    public static void deleteBPU(List<opportunity> deletedOpp)
    {
        System.debug('---deletedOpp-' +deletedOpp);
        if(deletedOpp != null && deletedOpp.size() > 0)
        {
            List<BPU__c>  OppDelBPU = [Select id, Opportunity__c from BPU__c where Opportunity__c IN: deletedOpp];
            if(OppDelBPU != null && OppDelBPU.size() > 0)
            {
                delete OppDelBPU;
            }
        }
    }
    
    //IS AFTER INSERT METHOD FROM OPPORTUNITY TRIGGER    
    public static void UpdateSFID(List<Opportunity> opplst)
    {
        System.debug('@@@ UpdateSFID Call');
        Decimal tempAccNo = 0 ;
        String LeadSFID;
        Boolean isNotConverted;
        
        List<id> accId = new List<id>(); 
        //FOR START
        for(opportunity opps : opplst)
        {
            accId.add(opps.AccountId);
            if(opps.Is_Converted__c == FALSE)
            {
                isNotConverted = TRUE;
            }
            ELSE
            {
                isNotConverted = FALSE;
            }
        }
        //FOR END
        opportunity FirstOpp = [select Bizcap_Lead_Ref__c from opportunity where AccountId IN :  accId order by CreatedDate limit 1 ];
        
        List<account> getAccList = [select Id,Opp_For_Number__c,Is_Converted__c from account where Id IN : accId]; // GET ACCOUNT LIST
        
        List<opportunity> getOppList = [SELECT Name, Lead_SFID__c, Id, StageName,Sub_stage__c, Loan_Type__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c,
                                        Factor_Rate__c, Funded_Date__c, BC_Number__c, Bizcap_Lead_Ref__c,  Decline_Reason__c, Lead_Email__c,Lead_Reference__c , Conditional_Approval_Amount__c, Call_Attempts__c, Last_Call_Date__c, 
                                        Conditional_Approval_Date__c, LeadSource, Company__c, (select id from APIs__r)
                                        FROM Opportunity where Id IN : opplst]; //GET OPPORTUNITY LIST
        
        
        
        List<opportunity> updateOpp = new List<opportunity>(); //CREARE OPPORTUNITY LIST
        List<account> updateAcc = new List<account>(); // CREATE ACCOUNT LIST FOR PUSH RECORD AND UPDATE 
        List<BPU__c> lstbpu = new List<BPU__c>();
        System.debug('$$$ getAccList : '+getAccList);
        //FOR START
        
        for(account acc : getAccList)
        {
            System.debug('@@@ getAccList');
            System.debug('@@2 acc.Is_Converted__c ='+acc.Is_Converted__c);
            SYSTEM.debug('isNotConverted::'+isNotConverted);
            //IF START
            if(acc.Is_Converted__c == true && isNotConverted == TRUE)
            {
                System.debug('$$$$ Now i am working');
                acc.Opp_For_Number__c = acc.Opp_For_Number__c+1;
                System.debug('-<< acc.Opp_For_Number__c >>- :'+acc.Opp_For_Number__c);
                tempAccNo = acc.Opp_For_Number__c;
                updateAcc.add(acc); 
                
                for(opportunity opp : getOppList) {
                    System.debug('@@@ before Create BPU ');
                    //create BPU record
                    BPU__c objBPU = new BPU__c();
                    objBPU.Is_Converted__c = TRUE;
                    objBPU.Name = Opp.Name;
                    objBPU.Opportunity__c = opp.id;
                    objBPU.Stage__c = opp.StageName;
                    objBPU.Sub_Stage__c = opp.Sub_stage__c;
                    objBPU.Factor_Rate__c = string.valueOf(opp.Factor_Rate__c);
                    objBPU.Loan_Type__c = opp.Loan_Type__c;
                    objBPU.Loan_Amount__c = string.valueOf(opp.Loan_Amount__c);
                    objBPU.Loan_term_business_days__c = string.valueOf(opp.Loan_term_business_days__c);
                    objBPU.Payback_Amount__c = string.valueOf(opp.Payback_Amount__c);
                    objBPU.Factor_Rate__c = string.valueOf(opp.Factor_Rate__c);
                    objBPU.Funded_Date__c = string.valueOf(opp.Funded_Date__c);
                    objBPU.BC_Number__c = opp.BC_Number__c;
                    //objBPU.Bizcap_Lead_Ref__c = FirstOpp.Bizcap_Lead_Ref__c+'-'+tempAccNo;
                    objBPU.Bizcap_Lead_Ref__c = opp.Bizcap_Lead_Ref__c+'-'+tempAccNo;

                    System.debug('$$$ opp.Bizcap_Lead_Ref__c :: '+FirstOpp.Bizcap_Lead_Ref__c);
                    //api.Decline_Reason__c = opp.Decline_Reason__c;
                    //objBPU.Email_Address__c = opp.Lead_Email__c;
                    objBPU.Lead_Reference__c = opp.Lead_Reference__c;
                    objBPU.Conditional_Approval_Amount__c = string.valueOf(opp.Conditional_Approval_Amount__c);
                    objBPU.Call_Attempts__c = string.valueOf(opp.Call_Attempts__c);
                    objBPU.Last_Call_Date__c = string.valueOf(opp.Last_Call_Date__c);
                    objBPU.Conditional_Approval_Date__c = string.valueOf(opp.Conditional_Approval_Date__c);
                    //objBPU.Lead_Source__c = opp.LeadSource;
                    if (opp.LeadSource != null) 
                    {
                        Schema.DescribeFieldResult field = opportunity.LeadSource.getDescribe();
                        System.debug(' $$$ field:' + field);
                        for (Schema.PicklistEntry f : field.getPicklistValues())
                        {
                            if(opp.LeadSource == f.getValue())
                            {
                                //System.debug(' $$$ Picklist Value Label is :' + f.getLabel());
                                objBPU.Lead_Source__c = f.getLabel();
                            }
                        }
                    }
                    //objBPU.Company__c = opp.Company__c;
                    System.debug('@@@@ opp.APIs__r.size() = '+opp.APIs__r.size());
                    if(opp.APIs__r.size() == 0) {
                        lstbpu.add(objBPU);    
                    }
                    
                }
                
            }
            //END IF
        } 
        
        if(lstbpu.size() > 0)
        {
            System.debug('@@@ Insert BPU');
            insert lstbpu;   
        }
        
        //FOR END
        //CHECK RECORD IS EXIST OR NOT
        if(updateAcc!=NULL && updateAcc.size()>0)
        {
            //UPDATE ACCOUNT LIST
            update updateAcc;
        }
        //UPDATE tempAccNo FIELD ON ACCOUNT
        if(tempAccNo>0)
        {
            
            System.debug('-<< FirstOpp >>- :'+FirstOpp);
            //START FOR
            for(opportunity opp : getOppList)
            {
                //opp.Bizcap_Lead_Ref__c = FirstOpp.Bizcap_Lead_Ref__c;
                System.debug('-<< Lead_SFID__c >>- :'+opp.Bizcap_Lead_Ref__c);
                opp.Lead_SFID__c = opp.Bizcap_Lead_Ref__c+'-'+tempAccNo;
                updateOpp.add(opp);
            }
            //END FOR
            if(updateOpp!=NULL && updateOpp.size()>0)
            {
                update updateOpp;
            }
        }
    }
    
    //Update BPU's stage and substage when Opp is update
    public static void updateBPU(List<Opportunity> opplst)
    {
        if(opplst!=NULL && opplst.size()>0)
        {
            List<opportunity> getOppList = new List<opportunity>();
            List<BPU__c> lstUpdateBpu = new List<BPU__c>();
            //START FOR
            for(opportunity opp: opplst)
            {
                getOppList.add(opp);
            }
            //END FOR
            List<BPU__c>  lstBPU = [SELECT Sub_Stage__c, Stage__c, Opportunity__c 
                                    FROM BPU__c 
                                    WHERE Opportunity__c In :opplst]; //GET BPU RECORD DEPEND ON OPPORTUNITY ID
            //IF CONDITION STARTS
            if(lstBPU!=NULL && lstBPU.size()>0)
            {
                for(BPU__c api : lstBPU)
                {
                    //START FOR
                    for(integer i=0;i<getOppList.size();i++) 
                    {
                        if(api.Opportunity__c == getOppList[i].id)
                        {
                            system.debug('Opportunity__c :: '+api.Opportunity__c +':getOppList ::'+getOppList[i].id);
                            api.Name = getOppList[i].name;
                            api.Stage__c = getOppList[i].StageName;
                            api.Sub_Stage__c = getOppList[i].Sub_stage__c;
                            api.Factor_Rate__c = string.valueOf(getOppList[i].Factor_Rate__c);
                            api.Loan_Type__c = getOppList[i].Loan_Type__c;
                            api.Loan_Amount__c = string.valueOf(getOppList[i].Loan_Amount__c);
                            api.Loan_term_business_days__c = string.valueOf(getOppList[i].Loan_term_business_days__c);
                            api.Payback_Amount__c = string.valueOf(getOppList[i].Payback_Amount__c);
                            api.Factor_Rate__c = string.valueOf(getOppList[i].Factor_Rate__c);
                            api.Funded_Date__c = string.valueOf(getOppList[i].Funded_Date__c);
                            api.BC_Number__c = getOppList[i].BC_Number__c;
                            api.Lead_Reference__c = getOppList[i].Lead_Reference__c;
                            api.Conditional_Approval_Amount__c = string.valueOf(getOppList[i].Conditional_Approval_Amount__c);
                            api.Call_Attempts__c = string.valueOf(getOppList[i].Call_Attempts__c);
                            api.Last_Call_Date__c = string.valueOf(getOppList[i].Last_Call_Date__c);
                            api.Conditional_Approval_Date__c = string.valueOf(getOppList[i].Conditional_Approval_Date__c);
                            if (getOppList[i].LeadSource != null) 
                            {
                                Schema.DescribeFieldResult field = opportunity.LeadSource.getDescribe();
                                System.debug(' $$$ field:' + field);
                                for (Schema.PicklistEntry f : field.getPicklistValues())
                                {
                                    // myPicklist.add(f.getLabel());
                                    if(getOppList[i].LeadSource == f.getValue())
                                    {
                                        //System.debug(' $$$ Picklist Value Label is :' + f.getLabel());
                                        api.Lead_Source__c = f.getLabel();
                                    }
                                }
                            }
                            lstUpdateBpu.add(api);
                            system.debug('lstUpdateBpuin IF::'+lstUpdateBpu);
                        }
                    }
                    //END FOR
                }
            }
            //IF CONDITION ENDS
            //END FOR
            if(lstUpdateBpu.size()>0 && lstUpdateBpu != null)
            {
                Update lstUpdateBpu;           
            }
        }
    }
}