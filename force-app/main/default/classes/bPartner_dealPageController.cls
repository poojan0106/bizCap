public with sharing class bPartner_dealPageController {
    
    public user currentuser{get; set;}
    
    //Lists of Records
    public List<Lead> LeadList {get; set;}
    public List<Lead> Applications {get; set;}
    public List<Opportunity> Opportunities {get; set;}
    public List<Opportunity> Settled {get; set;}
    
    //Search Parameters
    public String LeadSearch{get; set;}
    public String AppSearch{get; set;}
    public String OppSearch{get; set;}
    public String SetSearch{get; set;}
    
    public String WhatLead{get;set;}
    public String WhatApp {get; set;}
    public String WhatOpp {get; set;}
    public String WhatSet{get; set;}
    
    public String WhatLead1{get;set;}
    public String WhatApp1 {get; set;}
    public String WhatOpp1 {get; set;}
    public String WhatSet1{get; set;}
    
    public String LeadQuery;
    private integer counter = 0;  //keeps track of the offset
    private integer list_size = Integer.valueOf(System.Label.bPartner_RecordLimit); //sets the page size or number of rows
    public integer total_size = 0; //used to show user the total size of the list
    
    public String ApplicationQuery;
    private integer counter_App=0;  //keeps track of the offset
    private integer list_size_App = Integer.valueOf(System.Label.bPartner_RecordLimit); //sets the page size or number of rows
    public integer total_size_App = 0; //used to show user the total size of the list
    
    public String OpportunityQuery;
    private integer counter_Opp=0;  //keeps track of the offset
    private integer list_size_Opp = Integer.valueOf(System.Label.bPartner_RecordLimit); //sets the page size or number of rows
    public integer total_size_Opp = 0; //used to show user the total size of the list
    
    public String SettleQuery;
    private integer counter_Set = 0;  //keeps track of the offset
    private integer list_size_Set = Integer.valueOf(System.Label.bPartner_RecordLimit); //sets the page size or number of rows
    public integer total_size_Set = 0; //used to show user the total size of the list
    
    public Integer totalLeads {get; set;}
    public Integer totalApps {get; set;}
    public Integer totalOpps {get; set;}
    public Integer totalSets {get; set;}
    
    public Decimal Final_Settled_GrandTotal {get;set;}
    
    public Boolean Lead_searched;
    public Boolean App_searched;
    public Boolean Opp_searched;
    public Boolean Set_searched;
    
    public boolean Lead_filtered;
    public boolean App_filtered;
    public boolean Opp_filtered;
    public boolean Set_filtered;
    
    public String leadStatus {get; set;}
    public String leadSubStatus {get; set;}
    
    public String AppStatus {get; set;}
    public String AppSubStatus {get; set;}
    
    public String OppStage {get; set;}
    public String OppSubStage {get; set;}
    
    public String SetStage {get; set;}
    public String SetSubStage {get; set;}
    
    public String Dev_Name_Lead = Label.bPartner_Lead_PartnerRecordType;
    public String Dev_Name_Opp = Label.bPartner_Opportunity_PartnerRecType;
    
    Public Boolean PickDatesLeadPAnel {get; set;}
    public Date startDate_Lead {get;set;}
    public Date endDate_Lead {get;set;}
    
    Public Boolean PickDatesAppPAnel {get; set;}
    public Date startDate_App {get;set;}
    public Date endDate_App {get;set;}
    
    Public Boolean PickDatesOppPAnel {get; set;}
    public Date startDate_Opp {get;set;}
    public Date endDate_Opp {get;set;}
    
    Public Boolean PickDatesSetPAnel {get; set;}
    public Date startDate_Set {get;set;}
    public Date endDate_Set {get;set;}
    
    public List<SelectOption> getLeadStatusAll(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead.Lead_Status_Partner_Portal__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--Status--', '--Status--'));
        for( Schema.PicklistEntry f : ple){
            if(f.getLabel() != 'New partner lead' && f.getLabel()!='Partner Declined'){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }   
        return options;
    }
    public List<SelectOption> getOpp_StageAll(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Opportunity_Stage_for_Partner_Portal__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--Stage--', '--Stage--'));
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }   
        return options;
    }
    public List<SelectOption> LeadSubStatusAll {get;set;}
    public List<SelectOption> Opp_SubStageAll {get;set;}
    
    public bPartner_dealPageController(){
        currentuser = [SELECT Id,Name,Email FROM User WHERE Id=:userinfo.getuserId()];
        LeadList=new List<Lead>();
        Applications = new List<Lead>();
        Opportunities = new List<Opportunity>();
        Settled = new List<Opportunity>();
        
        LeadSubStatusAll = new List<SelectOption>();
        LeadSubStatusAll.add(new SelectOption('--Sub Status--', '--Sub Status--'));
        Opp_SubStageAll = new List<SelectOption>();
        Opp_SubStageAll.add(new SelectOption('--Sub Stage--', '--Sub Stage--'));
    }
    
    //GET ALL DATE SCENARIO START =========================
    
    public Date getStartDate(){
        Date d = System.Today(); 
        Date dt = d.toStartofWeek();
        return dt;
    }
    
    public Date getEndDate(){
        Date d = System.Today(); 
        Date dt = d.toStartofWeek()+6;
        return dt;
    }
    
    public Date getLastWeekSdate(){
        Date d = System.Today(); 
        Date dt = d.toStartofWeek()-7;
        return dt;
    }
    
    public Date getLastweekEdate(){
        Date d = System.Today(); 
        Date dt = d.toStartofWeek()-1;
        return dt;
    }
    
    public Date getMonthSdate(){
        Date d = System.Today(); 
        Date dt = d.toStartofMonth();
        return dt;
    }
    
    public Date getMonthEdate(){
        Date d = System.Today(); 
        Date dt = d.toStartofMonth().addMonths(1).addDays(-1);
        return dt;
    }
    
    public Date getLastMonthSdate(){
        Date d = System.Today(); 
        Date dt = d.toStartofMonth().addMonths(-1);
        return dt;
    }
    
    public Date getLastMonthEdate(){
        Date d = System.Today(); 
        Date dt = d.toStartofMonth().addDays(-1);
        return dt;
    }
    
    //GET ALL DATE SCENARIO END =========================
    
    //Lead Starts With Paginations    
    
    public void CallLeads(){
        WhatLead = Apexpages.currentPage().getParameters().get('WhatLead');
        system.debug('WhatLead N:::'+WhatLead+':: WhatLead1 ::'+WhatLead1);
        if(WhatLead != null && WhatLead!='' && WhatLead1!= WhatLead){
            counter = 0;
            total_size = 0;
            WhatLead1 = WhatLead;
            LeadSearch = null;
            Lead_searched = false;
            Lead_filtered = false;
            leadStatus = '--Status--';
            leadSubStatus = '--Sub Status--';
            LeadSubStatusAll.clear();
            LeadSubStatusAll.add(new SelectOption('--Sub Status--', '--Sub Status--'));
            PickDatesLeadPAnel = false;
        }
        if(WhatLead1 == 'Today Leads'){
            LeadList.clear();
            LeadQuery ='SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, LastModifiedDate, Form_Update_URL__c, Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone, Latest_Date__c, Bank_Statement_Last_Updated__c, Bank_Statements_Check__c, Conditional_Approval_Amount__c FROM Lead WHERE CreatedDate = today AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatLead1 == 'This Week Leads'){
            LeadList.clear();
            LeadQuery ='SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, LastModifiedDate, Form_Update_URL__c,Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone, Latest_Date__c, Bank_Statement_Last_Updated__c, Bank_Statements_Check__c, Conditional_Approval_Amount__c FROM Lead WHERE CreatedDate = THIS_WEEK AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatLead1 == 'Last Week Leads'){
            LeadList.clear();
            LeadQuery ='SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, LastModifiedDate, Form_Update_URL__c,Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone, Latest_Date__c, Bank_Statement_Last_Updated__c, Bank_Statements_Check__c, Conditional_Approval_Amount__c FROM Lead WHERE CreatedDate = LAST_WEEK AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatLead1 == 'This Month Leads'){
            LeadList.clear();
            LeadQuery ='SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, LastModifiedDate, Form_Update_URL__c,Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone, Latest_Date__c, Bank_Statement_Last_Updated__c, Bank_Statements_Check__c, Conditional_Approval_Amount__c FROM Lead WHERE CreatedDate = THIS_MONTH AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatLead1 == 'Last Month Leads'){
            LeadList.clear();
            LeadQuery ='SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, LastModifiedDate, Form_Update_URL__c,Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone, Latest_Date__c, Bank_Statement_Last_Updated__c, Bank_Statements_Check__c, Conditional_Approval_Amount__c FROM Lead WHERE CreatedDate = LAST_MONTH AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatLead1 == 'This Year Leads'){
            LeadList.clear();
            LeadQuery ='SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, LastModifiedDate, Form_Update_URL__c,Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone, Latest_Date__c, Bank_Statement_Last_Updated__c, Bank_Statements_Check__c, Conditional_Approval_Amount__c FROM Lead WHERE CreatedDate = THIS_YEAR AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        if(startDate_Lead != null && endDate_Lead != null && WhatLead1 == 'Pick Dates Leads'){
            LeadQuery ='SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, LastModifiedDate, Form_Update_URL__c,Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone, Latest_Date__c, Bank_Statement_Last_Updated__c, Bank_Statements_Check__c, Conditional_Approval_Amount__c FROM Lead WHERE CreatedDate >=: startDate_Lead AND CreatedDate <=: endDate_Lead AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        System.debug('LeadSearch N::'+LeadSearch+':: leadStatus ::'+leadStatus+':: leadSubStatus ::'+leadSubStatus);
        
        if(LeadSearch != null && LeadSearch != '' && Lead_searched == true){
            LeadQuery += ' AND (Firstname LIKE \'%' + LeadSearch + '%\' OR Lastname LIKE \'%' + LeadSearch + '%\' OR company LIKE \'%' + LeadSearch + '%\')';
        }
        if(leadStatus != null && leadStatus != '' && leadStatus != '--Status--' && Lead_filtered == true){
            LeadQuery += ' AND Status =: leadStatus';
        }
        if(leadSubStatus != null && leadSubStatus != '' && leadSubStatus != '--Sub Status--' && Lead_filtered == true){
            LeadQuery += ' AND Lead_Sub_Status__c =: leadSubStatus';
        }
        if(total_size != null && total_size ==0){
            if(WhatLead1 != 'Pick Dates Leads'){
                LeadList = Database.query(LeadQuery);
            }
            else{
                if(startDate_Lead != null && endDate_Lead != null && WhatLead1 == 'Pick Dates Leads'){
                    LeadList = Database.query(LeadQuery);}
            }
            total_size = (LeadList !=null &&LeadList.size()>0)?LeadList.size():0;
            totalLeads= total_size;
        }
        
        System.debug('list_size N::'+list_size+'::counter N::'+counter);
        LeadQuery += ' ORDER BY CreatedDate DESC, CreatedDate DESC LIMIT :list_size OFFSET :counter';
        System.debug('LeadQuery N::'+LeadQuery);
        
        if(WhatLead1 != 'Pick Dates Leads'){
            LeadList = Database.query(LeadQuery);}
        else{
            if(startDate_Lead != null && endDate_Lead != null && WhatLead1 == 'Pick Dates Leads'){
                LeadList = Database.query(LeadQuery);}
        }
    }
    
    public void BeginningLead(){        
        counter  = 0;  
        CallLeads();        
    }
    
    public void PreviousLead(){       
        counter = (counter - list_size); 
        CallLeads();    
    }
    
    public void NextLead(){        
        counter  = counter + list_size;  
        CallLeads();        
    }
    
    public void EndLead(){    
        if(math.mod(total_size, list_size) == 0){
            counter  = total_size - list_size; 
        }
        else{
            counter  = total_size - math.mod(total_size, list_size); 
        }
        CallLeads();        
    }
    
    public boolean getDisablePrevious(){        
        if(counter > 0){         
            return false;          
        }        
        else {      
            return true;         
        }  
    }
    
    public Boolean getDisableNext() {
        if (counter + list_size < total_size) return false; else return true;
    }
    
    public void SearchLead(){
        counter = 0;
        total_size=0;
        Lead_searched = true;
        CallLeads();
    }
    
    public void CancelLead(){
        counter = 0;
        total_size = 0;
        Lead_searched = false;
        LeadSearch = null;
        CallLeads();
    }
    
    public void filterLeads(){
        System.debug('leadSubStatus N::'+leadSubStatus);
        System.debug('leadStatus N::'+leadStatus);
        counter = 0;
        total_size = 0;
        if(leadStatus != null && leadStatus != '' && leadStatus != '--Status--' || (leadSubStatus != null && leadSubStatus != '' && leadSubStatus != '--Sub Status--')){
            Lead_filtered = true;
            CallLeads();
        }
    }
    public void filterLeads_cancel(){
        leadStatus = '--Status--';
        leadSubStatus = '--Sub Status--';
        Lead_filtered = false;
        counter = 0;
        total_size = 0;
        CallLeads();
    }
    
    public void picDate_Click_Lead(){
        LeadList.clear();
        WhatLead = null;
        WhatLead1='Pick Dates Leads';
        counter = 0;
        total_size=0;
        PickDatesLeadPAnel = true;
        System.debug('startDate_Lead N::'+startDate_Lead+':: endDate_Lead ::'+endDate_Lead);
        if(startDate_Lead != null && endDate_Lead != null){
            CallLeads();
        }
    }
    
    public void Clear_picDate_Click_Lead(){
        LeadList.clear();
        PickDatesLeadPAnel = true;
        startDate_Lead = null;
        endDate_Lead=null;
    }
    
    //Lead End With Paginations    
    
    //Application Starts With Paginations
    
    public void CallApps(){
        WhatApp = Apexpages.currentPage().getParameters().get('WhatApp');
        system.debug('WhatApp N:::'+WhatApp);
        if(WhatApp != null && WhatApp!='' && WhatApp1!= WhatApp){
            WhatApp1 = WhatApp;
            AppSearch = null;
            App_searched = false;
            AppStatus = '--Status--';
            AppSubStatus = '--Sub Status--';
            App_filtered = false;
            counter_App = 0;
            total_size_App = 0;
            System.debug('total_size_App N::'+total_size_App);
            System.debug('WhatApp1 N'+WhatApp1);
            LeadSubStatusAll.clear();
            LeadSubStatusAll.add(new SelectOption('--Sub Status--', '--Sub Status--'));
            PickDatesAppPAnel = false;
        }
        if(WhatApp1 == 'Today Apps'){
            Applications.clear();
            ApplicationQuery ='SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = today AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatApp1 == 'This Week Apps'){
            Applications.clear();
            ApplicationQuery ='SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = THIS_WEEK AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatApp1 == 'Last Week Apps'){
            Applications.clear();
            ApplicationQuery ='SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = LAST_WEEK AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatApp1 == 'This Month Apps'){
            Applications.clear();
            ApplicationQuery ='SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = THIS_MONTH AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatApp1 == 'Last Month Apps'){
            Applications.clear();
            ApplicationQuery ='SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = LAST_MONTH AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        else if(WhatApp1 == 'This Year Apps'){
            Applications.clear();
            ApplicationQuery ='SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c,Conditional_Approval_Amount__c, Amount_requested__c FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = THIS_YEAR AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        if(startDate_App != null && endDate_App != null && WhatApp1 == 'Pick Dates Apps'){
            ApplicationQuery ='SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c >= :startDate_App AND Bank_Statements_Check_Date__c <=: endDate_App AND Recordtype.Developername !=: Dev_Name_Lead';
        }
        if(AppSearch != null && AppSearch != '' && App_searched == true){
            ApplicationQuery += ' AND (Firstname LIKE \'%' + AppSearch + '%\' OR Lastname LIKE \'%' + AppSearch + '%\' OR company LIKE \'%' + AppSearch + '%\')';      
        }
        if(AppStatus != null && AppStatus != '' && AppStatus != '--Status--' && App_filtered == true){
            ApplicationQuery += ' AND Status =: AppStatus';
        }
        if(AppSubStatus != null && AppSubStatus != '' && AppSubStatus != '--Sub Status--' && App_filtered == true){
            ApplicationQuery += ' AND Lead_Sub_Status__c =: AppSubStatus';
        }
        if(total_size_App != null && total_size_App ==0){
            if(WhatApp1 != 'Pick Dates Apps'){
                Applications = Database.query(ApplicationQuery);}
            else{
                if(startDate_App != null && endDate_App != null && WhatApp1 == 'Pick Dates Apps'){
                    Applications = Database.query(ApplicationQuery);}
            }
            total_size_App = (Applications !=null &&Applications.size()>0)?Applications.size():0;
            totalApps= total_size_App;
        }
        ApplicationQuery += ' ORDER BY Bank_Statements_Check_Date__c DESC LIMIT :list_size_App OFFSET :counter_App';
        
        if(WhatApp1 != 'Pick Dates Apps'){
            Applications = Database.query(ApplicationQuery);}
        else{
            if(startDate_App != null && endDate_App != null && WhatApp1 == 'Pick Dates Apps'){
                Applications = Database.query(ApplicationQuery);}
        }
    }
    
    public void Beginning_App(){        
        counter_App  = 0;  
        CallApps();        
    }
    
    public void Previous_App(){       
        counter_App = (counter_App - list_size_App); 
        CallApps();    
    }
    
    public void Next_App(){        
        counter_App  = counter_App + list_size_App;  
        CallApps();        
    }
    
    public void End_App(){     
        if(math.mod(total_size_App, list_size_App) == 0){
            counter_App = total_size_App - list_size_App;
        }
        else{
            counter_App = total_size_App - math.mod(total_size_App, list_size_App); 
        }
        CallApps();        
    }
    
    public boolean getDisablePrevious_App(){        
        if(counter_App > 0){return false;}else {return true;}  
    }
    
    public Boolean getDisableNext_App() {
        if (counter_App + list_size_App < total_size_App) {return false;} else {return true;}
    }
    
    public void SearchApp(){
        counter_App=0;
        total_size_App=0;
        App_searched = true;
        CallApps();
    }
    
    public void CancelApp(){
        counter_App=0;
        total_size_App=0;
        AppSearch = null;
        App_searched = false;
        CallApps();
    }
    
    public void filterApps(){
        System.debug('AppStatus N::'+AppStatus+':: AppSubStatus ::'+AppSubStatus);
        counter_App=0;
        total_size_App=0;
        if(AppStatus != null && AppStatus != '' && AppStatus != '--Status--' || (AppSubStatus != null && AppSubStatus != '' && AppSubStatus != '--Sub Status--')){
            App_filtered = true;
            CallApps();
        }
    }
    
    public void filterApps_cancel(){
        AppStatus = '--Status--';
        AppSubStatus = '--Sub Status--';
        App_filtered = false;
        counter_App=0;
        total_size_App=0;
        CallApps();
    }
    
    public void picDate_Click_App(){
        Applications.clear();
        PickDatesAppPAnel = true;
        System.debug('startDate_App N::'+startDate_App);
        System.debug('endDate_App N::'+endDate_App);
        if(startDate_App != null && endDate_App != null){
            WhatApp = null;
            WhatApp1='Pick Dates Apps';
            counter_App = 0;
            total_size_App = 0;
            CallApps();
        }
    }
    
    public void Clear_picDate_Click_App(){
        Applications.clear();
        PickDatesAppPAnel = true;
        startDate_App = null;
        endDate_App=null;
        System.debug('startDate_App N::'+startDate_App);
        System.debug('endDate_App N::'+endDate_App);
    }
    
    public void dependent_Lead_Sub_Stattus(){
        System.debug('leadStatus N:::'+leadStatus);
        System.debug('AppStatus N:::'+AppStatus);
        LeadSubStatusAll.clear();
        LeadSubStatusAll.add(new SelectOption('--Sub Status--', '--Sub Status--'));
        if(leadStatus != null && leadStatus != '' && leadStatus != '--Status--' || (AppStatus != null && AppStatus != '' && AppStatus != '--Status--')){
            Map<String,List<String>> dependentPicklistValuesMap = getDependentPicklistValues(Lead.Lead_Sub_Status__c);
            for(String s : dependentPicklistValuesMap.keySet()){
                if(s == leadStatus || s == AppStatus){
                    for(String ss : dependentPicklistValuesMap.get(s)){
                        LeadSubStatusAll.add(new SelectOption(ss, ss));
                    }
                }
            }
        }
    }
    
    //Application Starts With Pagination
    
    //Opportunity Starts With Pagination
    
    public void CallOpportunity(){
        WhatOpp = Apexpages.currentPage().getParameters().get('WhatOpp');
        system.debug('WhatOpp N:::'+WhatOpp);
        system.debug('WhatOpp1 N:::'+WhatOpp1);
        if(WhatOpp != null && WhatOpp!='' && WhatOpp1!= WhatOpp){
            WhatOpp1 = WhatOpp;
            OppSearch = null;
            Opp_searched = false;
            OppStage = '--Stage--';
            OppSubStage = '--Sub Stage--';
            Opp_filtered = false;
            counter_Opp = 0;
            total_size_Opp = 0;
            Opp_SubStageAll = new List<SelectOption>();
            Opp_SubStageAll.add(new SelectOption('--Sub Stage--', '--Sub Stage--'));
            PickDatesOppPAnel = false;
        }
        if(WhatOpp1 == 'Today Opps'){
            Opportunities.clear();
            OpportunityQuery ='SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name, Funded_Date__c, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c FROM Opportunity WHERE CreatedDate = today AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatOpp1 == 'This Week Opps'){
            Opportunities.clear();
            OpportunityQuery ='SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name, Funded_Date__c, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c FROM Opportunity WHERE CreatedDate = THIS_WEEK AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatOpp1 == 'Last Week Opps'){
            Opportunities.clear();
            OpportunityQuery ='SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name, Funded_Date__c, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c FROM Opportunity WHERE CreatedDate = LAST_WEEK AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatOpp1 == 'This Month Opps'){
            Opportunities.clear();
            OpportunityQuery ='SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name, Funded_Date__c, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c FROM Opportunity WHERE CreatedDate = THIS_MONTH AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatOpp1 == 'Last Month Opps'){
            Opportunities.clear();
            OpportunityQuery ='SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name, Funded_Date__c, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c FROM Opportunity WHERE CreatedDate = LAST_MONTH AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatOpp1 == 'This Year Opps'){
            Opportunities.clear();
            OpportunityQuery ='SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name, Funded_Date__c, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c FROM Opportunity WHERE CreatedDate = THIS_YEAR AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        if(startDate_Opp != null && endDate_Opp != null && WhatOpp1 == 'Pick Dates Opp'){
            OpportunityQuery ='SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name, Funded_Date__c, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c FROM Opportunity WHERE CreatedDate >=: startDate_Opp AND CreatedDate <=:endDate_Opp AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        if(OppSearch != null && OppSearch!= '' && Opp_searched == true){
            OpportunityQuery += ' AND (Contact__r.name LIKE \'%' + OppSearch + '%\' OR Account.name LIKE \'%' + OppSearch + '%\')';      
        }
        if(OppStage != null && OppStage != '' && OppStage != '--Stage--' && Opp_filtered == true){
            OpportunityQuery += ' AND StageName =: OppStage';
        }
        if(OppSubStage != null && OppSubStage != '' && OppSubStage != '--Sub Stage--' && Opp_filtered == true){
            OpportunityQuery += ' AND Sub_stage__c =: OppSubStage';
        }
        if(total_size_Opp != null && total_size_Opp ==0){
            if(WhatOpp1 != 'Pick Dates Opp'){
                Opportunities = Database.query(OpportunityQuery);}
            else{
                if(startDate_Opp != null && endDate_Opp != null && WhatOpp1 == 'Pick Dates Opp'){
                    Opportunities = Database.query(OpportunityQuery);}
            }
            total_size_Opp = (Opportunities !=null &&Opportunities.size()>0)?Opportunities.size():0;
            totalOpps = total_size_Opp;
        }
        OpportunityQuery += ' ORDER BY CreatedDate DESC LIMIT :list_size_Opp OFFSET :counter_Opp';
        System.debug('OpportunityQuery N::'+OpportunityQuery);
        if(WhatOpp1 != 'Pick Dates Opp'){
            Opportunities = Database.query(OpportunityQuery);}
        else{
            if(startDate_Opp != null && endDate_Opp != null && WhatOpp1 == 'Pick Dates Opp'){
                Opportunities = Database.query(OpportunityQuery);}
        }
    }
    
    public void Beginning_Opp(){        
        counter_Opp  = 0;  
        CallOpportunity();        
    }
    
    public void Previous_Opp(){       
        counter_Opp = (counter_Opp - list_size_Opp); 
        CallOpportunity();    
    }
    
    public void Next_Opp(){        
        counter_Opp  = counter_Opp + list_size_Opp;  
        CallOpportunity();        
    }
    
    public void End_Opp(){        
        if(math.mod(total_size_Opp, list_size_Opp)==0){
            counter_Opp  = total_size_Opp - list_size_Opp;
        }
        else{
            counter_Opp  = total_size_Opp - math.mod(total_size_Opp, list_size_Opp); 
        }
        CallOpportunity();        
    }
    
    public boolean getDisablePrevious_Opp(){        
        if(counter_Opp > 0){return false;}else {return true;}  
    }
    
    public Boolean getDisableNext_Opp() {
        if (counter_Opp + list_size_Opp < total_size_Opp) {return false;} else {return true;}
    }
    
    public void SearchOpp(){  
        counter_Opp = 0;
        total_size_Opp = 0;
        Opp_searched = true;
        CallOpportunity();        
    }
    
    public void CancelOpp(){
        counter_Opp = 0;
        total_size_Opp = 0;
        OppSearch = null;
        Opp_searched = false;
        CallOpportunity();
    }
    
    public void filterOpps(){
        System.debug('OppSubStage N::'+OppSubStage);
        System.debug('OppStage N::'+OppStage);
        counter_Opp = 0;
        total_size_Opp = 0;
        if(OppStage != null && OppStage != '' && OppStage != '--Stage--' || (OppSubStage != null && OppSubStage != '' && OppSubStage != '--Sub Status--'))
        {
            Opp_filtered = true;
            CallOpportunity();
        }
    }
    public void filterOpps_cancel(){
        OppStage = '--Stage--';
        OppSubStage = '--Sub Stage--';
        Opp_filtered = false;
        counter_Opp = 0;
        total_size_Opp = 0;
        CallOpportunity();
    }
    
    public void picDate_Click_Opp(){
        Opportunities.clear();
        PickDatesOppPAnel = true;
        System.debug('startDate_Opp N::'+startDate_Opp);
        System.debug('endDate_Opp N::'+endDate_Opp);
        if(startDate_Opp != null && endDate_Opp != null)
        {
            WhatOpp = null;
            WhatOpp1='Pick Dates Opp';
            counter_Opp = 0;
            total_size_Opp = 0;
            CallOpportunity();
        }
    }
    
    public void Clear_picDate_Click_Opp(){
        Opportunities.clear();
        PickDatesOppPAnel = true;
        startDate_Opp = null;
        endDate_Opp=null;
        System.debug('startDate_Opp N::'+startDate_Opp);
        System.debug('endDate_Opp N::'+endDate_Opp);
    }
    //Opportunity Ends With Pagination
    
    //Settled Starts With Pagination
    public void CallSettled(){
        WhatSet = Apexpages.currentPage().getParameters().get('WhatSet');
        system.debug('WhatSet N:::'+WhatSet);
        if(WhatSet != null && WhatSet!='' && WhatSet1!= WhatSet){
            WhatSet1 = WhatSet;
            counter_Set = 0;
            total_size_Set = 0;
            SetSearch = null;
            Set_searched = false;
            SetStage = '--Stage--';
            SetSubStage = '--Sub Stage--';
            Set_filtered = false;
            Opp_SubStageAll = new List<SelectOption>();
            Opp_SubStageAll.add(new SelectOption('--Sub Stage--', '--Sub Stage--'));
            PickDatesSetPAnel = false;
        }
        if(WhatSet1 == 'Today Sets'){
            Settled.clear();
            SettleQuery ='SELECT Id, Broker_Name__c, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Contact__r.name, Account.name FROM Opportunity WHERE StageName = \'settled\' AND Funded_Date__c = today AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatSet1 == 'This Week Sets'){
            Settled.clear();
            SettleQuery ='SELECT Id, Broker_Name__c, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Contact__r.name, Account.name FROM Opportunity WHERE StageName = \'settled\' AND Funded_Date__c = THIS_WEEK AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatSet1 == 'Last Week Sets'){
            Settled.clear();
            SettleQuery ='SELECT Id, Broker_Name__c, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Contact__r.name, Account.name FROM Opportunity WHERE StageName = \'settled\' AND Funded_Date__c = LAST_WEEK AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatSet1 == 'This Month Sets'){
            Settled.clear();
            SettleQuery ='SELECT Id, Broker_Name__c, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Contact__r.name, Account.name FROM Opportunity WHERE StageName = \'settled\' AND Funded_Date__c = THIS_MONTH AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatSet1 == 'Last Month Sets'){
            Settled.clear();
            SettleQuery ='SELECT Id, Broker_Name__c, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Contact__r.name, Account.name FROM Opportunity WHERE StageName = \'settled\' AND Funded_Date__c = LAST_MONTH AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        else if(WhatSet1 == 'This Year Sets'){
            Settled.clear();
            SettleQuery ='SELECT Id, Broker_Name__c, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Contact__r.name, Account.name FROM Opportunity WHERE StageName = \'settled\' AND Funded_Date__c = THIS_YEAR AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        if(startDate_Set != null && endDate_Set != null && WhatSet1 == 'Pick Dates Set'){
            SettleQuery ='SELECT Id, Broker_Name__c, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Contact__r.name, Account.name FROM Opportunity WHERE StageName = \'settled\' AND Funded_Date__c >=: startDate_Set AND Funded_Date__c <=: endDate_Set AND RecordType.DeveloperName !=:Dev_Name_Opp';
        }
        if(SetSearch != null && SetSearch!= '' && Set_searched == true){
            SettleQuery += ' AND (Contact__r.name LIKE \'%' + SetSearch + '%\' OR Account.name LIKE \'%' + SetSearch + '%\')';      
        }
        if(SetStage != null && SetStage != '' && SetStage != '--Stage--' && Set_filtered == true){
            SettleQuery += ' AND StageName =: SetStage';
        }
        if(SetSubStage != null && SetSubStage != '' && SetSubStage != '--Sub Stage--' && Set_filtered == true){
            SettleQuery += ' AND Sub_stage__c =: SetSubStage';
        }
        if(total_size_Set != null && total_size_Set ==0){
            System.debug('SettleQuery N::'+SettleQuery);
            if(WhatSet1 != 'Pick Dates Set'){
                Settled = Database.query(SettleQuery);}
            else{
                if(startDate_Set != null && endDate_Set != null && WhatSet1 == 'Pick Dates Set'){
                    Settled = Database.query(SettleQuery);}
            }
            total_size_Set = (Settled !=null &&Settled.size()>0)?Settled.size():0;
            totalSets = total_size_Set;
            
            if(Settled != null && settled.size()>0){
                decimal Settled_GrandTotal = 0;
                for(Opportunity o : Settled){
                    if(o.Loan_Amount__c != null){
                        Settled_GrandTotal = Settled_GrandTotal + o.Loan_Amount__c;
                    }
                }
                if(Settled_GrandTotal != null){
                    Final_Settled_GrandTotal = Settled_GrandTotal;}
            }
        }
        SettleQuery += ' ORDER BY Loan_Type__c ASC, Funded_Date__c DESC LIMIT :list_size_Set OFFSET :counter_Set';
        System.debug('SettleQuery N::'+SettleQuery);
        if(WhatSet1 != 'Pick Dates Set'){
            Settled = Database.query(SettleQuery);}
        else{
            if(startDate_Set != null && endDate_Set != null && WhatSet1 == 'Pick Dates Set'){
                Settled = Database.query(SettleQuery);}
        }
        System.debug('total_size_Set N::'+total_size_Set);
    }
    
    public void Beginning_Set(){        
        counter_Set  = 0;  
        CallSettled();        
    }
    
    public void Previous_Set(){       
        counter_Set = (counter_Set - list_size_Set); 
        CallSettled();    
    }
    
    public void Next_Set(){        
        counter_Set  = counter_Set + list_size_Set;  
        CallSettled();        
    }
    
    public void End_Set(){  
        if(math.mod(total_size_Set, list_size_Set) == 0){
            counter_Set  = total_size_Set - list_size_Set;
        }
        else{
            counter_Set  = total_size_Set - math.mod(total_size_Set, list_size_Set); 
        }
        CallSettled();        
    }
    
    public boolean getDisablePrevious_Set(){        
        if(counter_Set > 0){return false;}else {return true;}  
    }
    
    public Boolean getDisableNext_Set() {
        if (counter_Set + list_size_Set < total_size_Set) {return false;} else {return true;}
    }
    
    public void SearchSet(){
        counter_Set=0;
        total_size_Set=0;
        Set_searched = true;
        CallSettled();
    }
    
    public void ClearSet(){
        counter_Set=0;
        total_size_Set=0;
        SetSearch=null;
        Set_searched = false;
        CallSettled();
    }
    
    public void filterSets(){
        System.debug('SetSubStage N::'+SetSubStage);
        System.debug('SetStage N::'+SetStage);
        counter_Set = 0;
        total_size_Set = 0;
        if(SetStage != null && SetStage != '' && SetStage != '--Stage--' || (SetSubStage != null && SetSubStage != '' && SetSubStage != '--Sub Status--')){
            Set_filtered = true;
            CallSettled();
        }
    }
    public void filterSets_cancel(){
        SetStage = '--Stage--';
        SetSubStage = '--Sub Stage--';
        Set_filtered = false;
        counter_Set = 0;
        total_size_Set = 0;
        CallSettled();
    }
    
    public void picDate_Click_Set(){
        Settled.clear();
        PickDatesSetPAnel = true;
        System.debug('startDate_Set N::'+startDate_Set);
        System.debug('endDate_Set N::'+endDate_Set);
        if(startDate_Set != null && endDate_Set != null){
            WhatSet = null;
            WhatSet1='Pick Dates Set';
            counter_Set = 0;
            total_size_Set = 0;
            CallSettled();
        }
    }
    
    public void Clear_picDate_Click_Set(){
        Settled.clear();
        PickDatesSetPAnel = true;
        startDate_Set = null;
        endDate_Set=null;
        System.debug('startDate_Set N::'+startDate_Set);
        System.debug('endDate_Set N::'+endDate_Set);
    }
    
    //Settled Ends With Pagination
    
    public void dependent_Opp_Sub_Stage(){
        System.debug('OppStage N:::'+OppStage);
        System.debug('SetStage N:::'+SetStage);
        Opp_SubStageAll = new List<SelectOption>();
        Opp_SubStageAll.add(new SelectOption('--Sub Stage--', '--Sub Stage--'));
        if(OppStage != null && OppStage != '' && OppStage != '--Sub Stage--' || (SetStage != null && SetStage != '' && SetStage != '--Sub Stage--')){
            Map<String,List<String>> dependentPicklistValuesMap = getDependentPicklistValues(Opportunity.Sub_stage__c);
            for(String s : dependentPicklistValuesMap.keySet()){
                if(s == OppStage || s == SetStage){
                    for(String ss : dependentPicklistValuesMap.get(s)){
                        Opp_SubStageAll.add(new SelectOption(ss, ss));
                    }
                }
            }
        }
    }
    
    //Common Dependent picklist value method
    public static Map<String, List<String>> getDependentPicklistValues(Schema.sObjectField dependToken) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
        
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
        
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))){
                List<String> base64chars = String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                        (controlEntries == null
                         ?   (Object) (index == 1)
                         :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                        );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    //getLeadSubStatusAllDy.add(entry.getLabel());
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        return dependentPicklistValues;
    }
}