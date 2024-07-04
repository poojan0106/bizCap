public with sharing class bPartner_HomePageController 
{
    public user currentuser{get; set;}
    public String SearchText {get; set;}
    public boolean display {get; set;}
    public String whatIdValue{get; set;}
    public String whatDivValue{get; set;}
    public String whattabValue{get; set;}
    public String whatTableValue{get; set;}
    
    public String NewOrRepeat{get;set;}
    public Boolean ShowpageBlockFlag{get;set;}
    public Boolean Showpagination{get;set;}
    
    public decimal Application_Report{get; set;}
    public decimal AppToOpp_Report{get; set;}
    public decimal OppToSet{get; set;}
    
    public String pickStartDate {get; set;}
    public String pickEndDate {get; set;}
    public Integer allLead {get; set;}
    //public Integer applicationLead {get; set;}
    
    //Lists to display today record size on VF Page
    transient public List<Lead> LeadList {get; set;}
    transient public List<Lead> application {get; set;}
    transient public List<Opportunity> opp_created {get; set;}
    transient public List<Opportunity> setteled_New {get; set;}
    transient public List<Opportunity> settled_subsequent {get; set;}
    
    
    
    //Lists To display this week record size on vf page
    transient public List<Lead> LeadList1 {get; set;}
    transient public List<Lead> application1 {get; set;}
    transient public List<Opportunity> opp_created1 {get; set;}
    transient public List<Opportunity> setteled_New1 {get; set;}
    transient public List<Opportunity> settled_subsequent1 {get; set;}
    
    //Lists to display last week record size on VF Page
    transient public List<Lead> LeadList2 {get; set;}
    transient public List<Lead> application2 {get; set;}
    transient public List<Opportunity> opp_created2 {get; set;}
    transient public List<Opportunity> setteled_New2 {get; set;}
    transient public List<Opportunity> settled_subsequent2 {get; set;}
    
    //Lists to display this month record size on VF Page
    transient public List<Lead> LeadList3 {get; set;}
    transient public List<Lead> application3 {get; set;}
    transient public List<Opportunity> opp_created3 {get; set;}
    transient public List<Opportunity> setteled_New3 {get; set;}
    transient public List<Opportunity> settled_subsequent3 {get; set;}
    
    //Lists to display last month record size on VF Page
    transient public List<Lead> LeadList4 {get; set;}
    transient public List<Lead> application4 {get; set;}
    transient public List<Opportunity> opp_created4 {get; set;}
    transient public List<Opportunity> setteled_New4 {get; set;}
    transient public List<Opportunity> settled_subsequent4 {get; set;}
    
    //Lists to display this year record size on VF Page
    transient  public List<Lead> LeadList5 {get; set;}
    transient public List<Lead> application5 {get; set;}
    transient public List<Opportunity> opp_created5 {get; set;}
    transient public List<Opportunity> setteled_New5 {get; set;}
    transient public List<Opportunity> settled_subsequent5 {get; set;}
    
    //Lists to display records b/t custom dates on VF PAge
    transient public List<Lead> LeadList6 {get; set;}
    transient public List<Lead> application6 {get; set;}
    transient public List<Opportunity> opp_created6 {get; set;}
    transient public List<Opportunity> setteled_New6 {get; set;}
    transient public List<Opportunity> settled_subsequent6 {get; set;}
    
    public Integer SAOppCount {get; set;}
    private integer LimitSize= Integer.valueOf(System.Label.bPartner_RecordLimit); 
    public String Dev_Name_Lead = Label.bPartner_Lead_PartnerRecordType;
    public String Dev_Name_Opp = Label.bPartner_Opportunity_PartnerRecType;
    
    public string enteredText1{get;set;}
    public string enteredText2{get;set;}
    public string enteredText3{get;set;}
    public string enteredText4{get;set;}
    
    public List<Opportunity> RecentOpp {get; set;}
    
    public String fileDownloadUrl {get; set;}
    
    public Date testDate {get; set;}
    
    public String logOutURL{get; set;}
    
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
    
    public Date getMonthSdate()
    {
        Date d = System.Today(); 
        Date dt = d.toStartofMonth();
        return dt;
    }
    
    public Date getMonthEdate()
    {
        Date d = System.Today(); 
        Date dt = d.toStartofMonth().addMonths(1).addDays(-1);
        return dt;
    }
    
    public Date getLastMonthSdate()
    {
        Date d = System.Today(); 
        Date dt = d.toStartofMonth().addMonths(-1);
        return dt;
    }
    
    public Date getLastMonthEdate()
    {
        Date d = System.Today(); 
        Date dt = d.toStartofMonth().addDays(-1);
        return dt;
    }
    
    public bPartner_HomePageController()
    {
        logOutURL = '';
        String UrlPathPrefix = System.label.bPartner_Community_Prefix;
        Site site = [SELECT Id FROM Site WHERE UrlPathPrefix =: UrlPathPrefix LIMIT 1];
        String communityUrl = [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;
        System.debug('Community url: ' + communityUrl);
        logOutURL = communityUrl+'/secur/logout.jsp?retUrl='+bPartner_CommonConstant.logoutUrl;
        
        enteredText1 = ApexPages.currentPage().getParameters().get('a');
        enteredText2 = ApexPages.currentPage().getParameters().get('b');
        enteredText3 = ApexPages.currentPage().getParameters().get('c');
        enteredText4 = ApexPages.currentPage().getParameters().get('d');
        system.debug('enteredText1 N:::' + enteredText1);
        System.debug('NewOrRepeat N:::'+NewOrRepeat);
        display = false;
        allLead = 0;
        ShowpageBlockFlag = true;
        Showpagination = false;
        currentuser = [SELECT Id,Name,Email FROM User WHERE Id=:userinfo.getuserId()];
        
        //fileDownloadUrl = URL.getSalesforceBaseUrl().toExternalForm()  + '/sfc/servlet.shepherd/document/download/' + System.label.bPartner_PdfDoc + '?operationContext=S1';
        
        // ======================== Lead Starts from Here
                
        //Leads to Application Report
        Decimal TotalLeadNum = [select count() from Lead where CreatedDate = LAST_N_DAYS:60];
        System.debug('TotalLeadNum N:::'+TotalLeadNum);
        Decimal AppLeadCount = [select count() from Lead where Bank_Statements_Check__c  = TRUE AND CreatedDate = LAST_N_DAYS:60];
        System.debug('AppLeadCount N:::'+AppLeadCount);
        if(TotalLeadNum != 0)
        {
            Application_Report = ((AppLeadCount/TotalLeadNum) * 100).setScale(2, RoundingMode.HALF_EVEN);
            System.debug('Application_Report N:::'+Application_Report);
        }
        else
        {
            Application_Report = 0;
        }
        
        //Application to Opportunity Report
        Decimal TotalLead = [select count() from Opportunity where Is_Converted__c = True AND Bank_Statements_Check_Date__c = LAST_N_DAYS:60];
        System.debug('TotalLead N:::'+TotalLead);
        Decimal AppOpp = [select count() from Lead where Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = LAST_N_DAYS:60];
        System.debug('AppOpp N:::'+AppOpp);
        if(AppOpp != 0)
        {
            AppToOpp_Report = ((TotalLead/AppOpp)*100).setScale(2, RoundingMode.HALF_EVEN);
            System.debug('AppToOpp_Report N:::'+AppToOpp_Report);
        }
        else
        {
            AppToOpp_Report = 0;
        }
        
        //Opportunity to Settled Report
        Decimal TotalOpp = [select count() from Opportunity where CreatedDate = LAST_N_DAYS:60];
        System.debug('TotalOpp N:::'+TotalOpp);
        Decimal SetOpp = [select count() from Opportunity where StageName = 'settled' AND CreatedDate = LAST_N_DAYS:60];
        System.debug('SetOpp N:::'+SetOpp);
        if(TotalOpp != 0)
        {
            OppToSet = ((SetOpp/TotalOpp) * 100).setScale(2, RoundingMode.HALF_EVEN);
            System.debug('OppToSet N:::'+OppToSet);
        }
        else
        {
            OppToSet = 0;
        }
        
        //Today
        LeadList = [SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, Form_Update_URL__c,
                    Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone
                    FROM Lead WHERE CreatedDate = today AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY CreatedDate DESC];
        
        //THIS WEEK
        LeadList1 = [SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, Form_Update_URL__c,
                     Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone
                     FROM Lead WHERE CreatedDate = THIS_WEEK AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY CreatedDate DESC];
        System.debug('LeadList1 N:::'+LeadList1);
        
        //Last WEEK
        LeadList2 = [SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, Form_Update_URL__c,
                     Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone
                     FROM Lead WHERE CreatedDate = LAST_WEEK AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY CreatedDate DESC];
        
        //This Month
        LeadList3 = [SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, Form_Update_URL__c,
                     Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone
                     FROM Lead WHERE CreatedDate = THIS_MONTH AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY CreatedDate DESC];
        
        //Last Month
        LeadList4 = [SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, Form_Update_URL__c,
                     Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone
                     FROM Lead WHERE CreatedDate = LAST_MONTH AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY CreatedDate DESC];
        
        //This Year
        LeadList5 = [SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, Form_Update_URL__c,
                     Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone
                     FROM Lead WHERE CreatedDate = THIS_YEAR AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY CreatedDate DESC];
        
        // ======================== Lead Ends Here
        
        
        // ======================== Application Starts Here
        //Today
        application = [SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c
                       FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = today AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY Bank_Statements_Check_Date__c DESC];
        
        //THIS WEEK
        application1 = [SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c 
                        FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = THIS_WEEK AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY Bank_Statements_Check_Date__c DESC];
        
        //Last WEEK
        application2 = [SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c 
                        FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = LAST_WEEK AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY Bank_Statements_Check_Date__c DESC];
        
        //This Month
        application3 = [SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c 
                        FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = THIS_MONTH AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY Bank_Statements_Check_Date__c DESC];
        
        //Last Month
        application4 = [SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c 
                        FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = LAST_MONTH AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY Bank_Statements_Check_Date__c DESC];
        
        //This Year
        application5 = [SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c,Conditional_Approval_Amount__c, Amount_requested__c 
                        FROM Lead WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c = THIS_YEAR AND Recordtype.DeveloperName != :Dev_Name_Lead ORDER BY Bank_Statements_Check_Date__c DESC]; 
        
        // ======================== Application Ends Here
        
        
        // ======================== Opportunity Created Starts Here
        //Today
        opp_created = [SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name 
                       FROM Opportunity WHERE CreatedDate = today AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY CreatedDate DESC];
        
        //THIS WEEK
        opp_created1 = [SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name
                        FROM Opportunity WHERE CreatedDate = THIS_WEEK AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY CreatedDate DESC];
        
        //Last WEEK
        opp_created2 = [SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name
                        FROM Opportunity WHERE CreatedDate = LAST_WEEK AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY CreatedDate DESC];
        
        //This Month
        opp_created3 = [SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name
                        FROM Opportunity WHERE CreatedDate = THIS_MONTH AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY CreatedDate DESC];
        
        //Last Month
        opp_created4 = [SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name
                        FROM Opportunity WHERE CreatedDate = LAST_MONTH AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY CreatedDate DESC];
        
        //This Year
        opp_created5 = [SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name
                        FROM Opportunity WHERE CreatedDate = THIS_YEAR AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY CreatedDate DESC];
        
        // ======================== Opportunity Created Ends Here
        
        
        // ======================== settled New Starts Here
        //Today
        setteled_New = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = TRUE AND Funded_Date__c = today AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //THIS WEEK
        setteled_New1 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = TRUE AND Funded_Date__c = THIS_WEEK AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //Last WEEK
        setteled_New2 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = TRUE AND Funded_Date__c = LAST_WEEK AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //This Month
        setteled_New3 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = TRUE AND Funded_Date__c = THIS_MONTH AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //Last Month
        setteled_New4 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = TRUE AND Funded_Date__c = LAST_MONTH AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //This Year
        setteled_New5 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = TRUE AND Funded_Date__c = THIS_YEAR AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        // ======================== settled New Ends Here
        
        
        // ======================== settled Subsequent Starts Here
        //Today
        settled_subsequent = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = FALSE AND Funded_Date__c = today AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //THIS WEEK
        settled_subsequent1 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = FALSE AND Funded_Date__c = THIS_WEEK AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //Last WEEK
        settled_subsequent2 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = FALSE AND Funded_Date__c = LAST_WEEK AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //This Month
        settled_subsequent3 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = FALSE AND Funded_Date__c = THIS_MONTH AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //Last Month
        settled_subsequent4 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = FALSE AND Funded_Date__c = LAST_MONTH AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        //This Year
        settled_subsequent5 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = FALSE AND Funded_Date__c = THIS_YEAR AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        // ======================== settled Subsequent Ends Here
        
        //Initially Display only 5 Opportunity in table 
        /*RecentOpp = [SELECT Id, Name, createdDate, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Application_Sign_Date__c
                     FROM Opportunity where Recordtype.DeveloperName != :Dev_Name_Opp Order By LastActivityDate DESC LIMIT 5];*/
        
        //Initially Display only 5 Opportunity in table ORDER BY LastModifiedDate DESC
        RecentOpp = [SELECT Id, Name, createdDate, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Application_Sign_Date__c
                     FROM Opportunity where Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY LastModifiedDate DESC LIMIT 5];
    }
    
    //Pagination of See All Opprotunities
    private integer SAOtotalRecs = 0;    
    private integer SAOffsetSize = 0; 
    
    public void seeAllOpp()
    { 
        String strQuery ='SELECT Id, Name, createdDate, Funded_Date__c, Company__c, StageName, Sub_stage__c, Loan_Amount__c, Loan_term_business_days__c, Payback_Amount__c, Loan_Type__c, Application_Sign_Date__c, LastActivityDate FROM Opportunity where Recordtype.DeveloperName != :Dev_Name_Opp';
        if(SAOtotalRecs != null && SAOtotalRecs == 0)
        {
            System.debug('strQuery N:::'+strQuery);            
            List<Opportunity> accTemp = Database.query(strQuery);            
            SAOtotalRecs = (accTemp !=null &&accTemp.size()>0)?accTemp.size():0; 
            SAOppCount = SAOtotalRecs;
        }
        strQuery += ' ORDER BY LastActivityDate DESC, LastActivityDate DESC LIMIT :LimitSize OFFSET :SAOffsetSize';   
        RecentOpp = Database.query(strQuery);
        ShowpageBlockFlag = false;
        Showpagination = true;
    }
    
    public void SAOFirstPage(){        
        SAOffsetSize = 0;        
        seeAllOpp();        
    }
    
    public void SAOprevious(){       
        SAOffsetSize = (SAOffsetSize-LimitSize);        
        seeAllOpp();    
    }
    
    public void SAOnext(){        
        SAOffsetSize = SAOffsetSize + LimitSize;        
        seeAllOpp();        
    }
    
    public void SAOLastPage(){        
        SAOffsetSize = SAOtotalRecs - math.mod(SAOtotalRecs,LimitSize);        
        seeAllOpp();        
    }
    
    public boolean getSAOprev(){        
        if(SAOffsetSize == 0){         
            return true;          
        }        
        else {      
            return false;         
        }  
    }
    
    public boolean getSAOnxt(){        
        if((SAOffsetSize + LimitSize) > SAOtotalRecs){            
            return true;           
        }        
        else { 
            return false;            
        }        
    }    
    //Pagination End of See All Opprotunities
    
    public PageReference loginOut()        
    {
        System.debug('loginOut called');
        String UrlPathPrefix = System.label.bPartner_Community_Prefix;
        Site site = [SELECT Id FROM Site WHERE UrlPathPrefix =: UrlPathPrefix LIMIT 1];
        String communityUrl = [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;
        System.debug('Community url: ' + communityUrl);
        PageReference p;
        p = new PageReference(communityUrl+'/secur/logout.jsp?retUrl='+bPartner_CommonConstant.logoutUrl);
        //p = site.
        p.setRedirect(true);
        return p;
        
        //PageReference logoutPage = new PageReference(Site.getBaseSecureUrl()+'/secur/logout.jsp?retUrl='+bPartner_CommonConstant.logoutUrl); 
        //logoutPage.setRedirect(true);
        //return logoutPage;     
    }
    
    public Document att {
        get {
            if (att == null) {
                att = [SELECT Body, ContentType, Name FROM Document WHERE ID = :System.label.bPartner_PdfDoc];
            }
            return att;
        }
        private set;
    }
    
    public String pdf {
        get {
            return EncodingUtil.Base64Encode(att.body);
        }
    }
    
    public void checkBothDates()
    {
        display = true;
        Date sd;
        Date ed;
        if(pickStartDate != null && pickStartDate != '')
        {
            String str = pickStartDate;
            str = str.replaceAll('/','-');
            sd = date.valueOf(str);
        }
        
        if(pickEndDate != null && pickEndDate != '')
        {
            String str1 = pickEndDate;
            str1 = str1.replaceAll('/','-');
            ed = date.valueOf(str1);
        }
        
        LeadList6 = [SELECT Id, Broker_Name__c, CreatedDate, firstname, lastname, company, Status, Lead_Sub_Status__c, Lead_Status_Change_Date__c, Form_Update_URL__c,
                     Lead_Sub_Status_Date_Changed__c, Amount_requested__c, Email, MobilePhone, Phone, Conditional_Approval_Amount__c FROM Lead 
                     WHERE CreatedDate >= :sd AND CreatedDate <= :ed AND Recordtype.DeveloperName != :Dev_Name_Lead
                     ORDER BY CreatedDate DESC];
        allLead = LeadList6.size();
        
        application6 = [SELECT Id, Broker_Name__c, Latest_Date__c, CreatedDate, Bank_Statement_Last_Updated__c, firstname, lastname, company, Status, Lead_Sub_Status__c, Conditional_Approval_Amount__c, Amount_requested__c FROM Lead
                        WHERE Bank_Statements_Check__c = TRUE AND Bank_Statements_Check_Date__c >= :sd AND Bank_Statements_Check_Date__c <= :ed AND Recordtype.DeveloperName != :Dev_Name_Lead
                        ORDER BY Bank_Statements_Check_Date__c DESC];
        
        opp_created6 = [SELECT Id, Broker_Name__c, CreatedDate, name, Company__c, StageName, Conditional_Approval_Amount__c, Amount_requested__c, Contact__r.name, Account.name FROM Opportunity
                        WHERE CreatedDate >= :sd AND CreatedDate <= :ed AND Recordtype.DeveloperName != :Dev_Name_Opp
                        ORDER BY CreatedDate DESC];
        
        setteled_New6 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = TRUE AND Funded_Date__c >= :sd AND Funded_Date__c <= :ed AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
        
        settled_subsequent6 = [SELECT Id FROM Opportunity WHERE StageName = 'settled' AND Is_Converted__c = FALSE AND Funded_Date__c >= :sd AND Funded_Date__c <= :ed AND Recordtype.DeveloperName != :Dev_Name_Opp ORDER BY Funded_Date__c DESC];
    }
    
    public PageReference redirect() 
    {
        system.debug('clicked2 N:::');
        System.debug('NewOrRepeat    N:::'+NewOrRepeat);
        PageReference pageRef = page.bPartner_deal;
        //PageReference pageRef = new PageReference('/apex/bPartner_deal');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('WhenID', enteredText1);
        return pageRef;
    }
}