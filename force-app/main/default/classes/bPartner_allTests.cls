@isTest
public class bPartner_allTests
{
    static testMethod void bPartner_SubmitLeadController_testMethod()
    {
        PageReference pageRef = Page.bPartner_submitLead; // Add your VF page Name here
        ApexPages.currentPage().getParameters().put('filename','filename.uytre');
        ApexPages.currentPage().getParameters().put('bodyVal','bodyVal');
        
        bPartner_SubmitLeadController sublead = new bPartner_SubmitLeadController();
        sublead.firstname = 'fname';
        sublead.lastname = 'hello';
        sublead.company_name = 'test';
        sublead.conLeadSource = 'Esther';
        sublead.document_Id = '123';
        sublead.notes = '123';
        sublead.avg_monthly_turnover = 123;
        sublead.amount_needded = 123;
        sublead.email = 'abc@gmail.com';
        sublead.mobile_number = '1234567890';
        //sublead.Industry = 'industry';
        sublead.abn = '123';
        sublead.phy_state = 'State_Physical__c';
        sublead.count = 'yes';
        sublead.fileName = 'fileName';
        sublead.BrokerName = 'BrokerName';
        sublead.CallBroker = true;
        List<SelectOption> selOpts=sublead.Industry_Pick;
        sublead.getBase64();
        sublead.setbase64('hello');
        sublead.getcount();
        sublead.setcount('yes');
        sublead.saveFile();
    }
    
    static testMethod void bPartner_HomePageController_testMethod()
    {
        PageReference pageRef = Page.bPartner_submitLead; // Add your VF page Name here
        ApexPages.currentPage().getParameters().put('filename','filename.uytre');
        ApexPages.currentPage().getParameters().put('bodyVal','bodyVal');
        
        bPartner_HomePageController home = new bPartner_HomePageController();
        home.pickStartDate = '2020-01-01';
        home.pickEndDate = '2020-12-01';
        home.getStartDate();
        home.getEndDate();
        home.getLastWeekSdate();
        home.getLastweekEdate();
        home.getMonthSdate();
        home.getMonthEdate();
        home.getLastMonthSdate();
        home.getLastMonthEdate();
        home.seeAllOpp();
        home.loginOut();
        home.checkBothDates();
        home.redirect();
        home.SAOFirstPage();
        home.SAOnext();
        home.getSAOprev();
        home.getSAOnxt();
    }
    
    static testMethod void bPartner_dealPageController_testMethod()
    {
        bPartner_dealPageController dhome = new bPartner_dealPageController();
        PageReference pageRef = Page.bPartner_deal;
        dhome.getStartDate();
        dhome.getEndDate();
        dhome.getLastWeekSdate();
        dhome.getMonthSdate();
        dhome.getMonthEdate();
        dhome.getLastMonthSdate();
        dhome.getLastMonthEdate();
        dhome.getLastweekEdate();
        dhome.getLeadStatusAll();
        dhome.getOpp_StageAll();
        
        //Lead Part
        dhome.WhatLead1 = 'This Week Leads';
        Apexpages.currentPage().getParameters().put('WhatLead', 'Today Leads');
        dhome.CallLeads();
        dhome.BeginningLead();
        dhome.NextLead();
        dhome.getDisablePrevious();
        dhome.getDisableNext();
        dhome.leadStatus = 'New';
        dhome.leadSubStatus = 'Received';
        dhome.Lead_filtered = true;
        dhome.filterLeads();
        dhome.filterLeads_cancel();
        dhome.LeadSearch = 'test';
        dhome.Lead_searched = true;
        dhome.SearchLead();
        dhome.CancelLead();
        Apexpages.currentPage().getParameters().put('WhatLead', 'Pick Dates Leads');
        dhome.startDate_Lead = System.today().addMonths(-1);
        dhome.endDate_Lead = System.today();
        dhome.picDate_Click_Lead();
        dhome.Clear_picDate_Click_Lead();
        
        //Application Part
        dhome.WhatApp1 = 'This Week Apps';
        Apexpages.currentPage().getParameters().put('WhatApp', 'Today Apps');
        dhome.CallApps();
        dhome.Beginning_App();
        dhome.Next_App();
        dhome.getDisablePrevious_App();
        dhome.getDisableNext_App();
        dhome.AppStatus = 'New';
        dhome.AppSubStatus = 'Received';
        dhome.App_filtered = true;
        dhome.filterApps();
        dhome.filterApps_cancel();
        dhome.AppSearch = 'test';
        dhome.App_searched = true;
        dhome.SearchApp();
        dhome.CancelApp();
        Apexpages.currentPage().getParameters().put('WhatApp', 'Pick Dates Apps');
        dhome.startDate_App = System.today().addMonths(-1);
        dhome.endDate_App = System.today();
        dhome.picDate_Click_App();
        dhome.Clear_picDate_Click_App();
        
        dhome.AppStatus = 'New';
        dhome.AppSubStatus = 'Received';
        dhome.dependent_Lead_Sub_Stattus();
        
        //Opportunity Part
        dhome.WhatOpp1 = 'This Week Opps';
        Apexpages.currentPage().getParameters().put('WhatOpp', 'Today Opps');
        dhome.CallOpportunity();
        dhome.Beginning_Opp();
        dhome.Next_Opp();
        dhome.getDisablePrevious_Opp();
        dhome.getDisableNext_Opp();
        dhome.OppStage = 'Settled';
        dhome.OppSubStage = 'Received';
        dhome.Opp_filtered = true;
        dhome.filterOpps();
        dhome.filterOpps_cancel();
        dhome.OppSearch = 'test';
        dhome.Opp_searched = true;
        dhome.SearchOpp();
        dhome.CancelOpp();
        Apexpages.currentPage().getParameters().put('WhatOpp', 'Pick Dates Opp');
        dhome.startDate_Opp = System.today().addMonths(-1);
        dhome.endDate_Opp = System.today();
        dhome.picDate_Click_Opp();
        dhome.Clear_picDate_Click_Opp();
        
        //Settled Part
        dhome.WhatSet1 = 'This Week Sets';
        Apexpages.currentPage().getParameters().put('WhatSet', 'Today Sets');
        dhome.CallSettled();
        dhome.Beginning_Set();
        dhome.Next_Set();
        dhome.getDisablePrevious_Set();
        dhome.getDisableNext_Set();
        dhome.SetStage = 'Settled';
        dhome.SetSubStage = 'Received';
        dhome.Set_filtered = true;
        dhome.filterSets();
        dhome.filterSets_cancel();
        dhome.SetSearch = 'test';
        dhome.Set_searched = true;
        dhome.SearchSet();
        dhome.ClearSet();
        Apexpages.currentPage().getParameters().put('WhatSet', 'Pick Dates Set');
        dhome.startDate_Set = System.today().addMonths(-1);
        dhome.endDate_Set = System.today();
        dhome.picDate_Click_Set();
        dhome.Clear_picDate_Click_Set();
        
        dhome.SetStage = 'Settled';
        dhome.SetSubStage = 'Received';
        dhome.Set_filtered = true;
        dhome.dependent_Opp_Sub_Stage();
    }
    
    static testMethod void bPartner_dealPageController_testMethod1()
    {
        bPartner_dealPageController dhome = new bPartner_dealPageController();
        Apexpages.currentPage().getParameters().put('WhatLead', 'This Week Leads');
        dhome.CallLeads();
        Apexpages.currentPage().getParameters().put('WhatApp', 'This Week Apps');
        dhome.CallApps();
        Apexpages.currentPage().getParameters().put('WhatOpp', 'This Week Opps');
        dhome.CallOpportunity();
        Apexpages.currentPage().getParameters().put('WhatSet', 'This Week Sets');
        dhome.CallSettled();
    }
    
    static testMethod void bPartner_dealPageController_testMethod2()
    {
        bPartner_dealPageController dhome = new bPartner_dealPageController();
        Apexpages.currentPage().getParameters().put('WhatLead', 'Last Week Leads');
        dhome.CallLeads();
        Apexpages.currentPage().getParameters().put('WhatApp', 'Last Week Apps');
        dhome.CallApps();
        Apexpages.currentPage().getParameters().put('WhatOpp', 'Last Week Opps');
        dhome.CallOpportunity();
        Apexpages.currentPage().getParameters().put('WhatSet', 'Last Week Sets');
        dhome.CallSettled();
    }
    
    static testMethod void bPartner_dealPageController_testMethod3()
    {
        bPartner_dealPageController dhome = new bPartner_dealPageController();
        Apexpages.currentPage().getParameters().put('WhatLead', 'This Month Leads');
        dhome.CallLeads();
        Apexpages.currentPage().getParameters().put('WhatApp', 'This Month Apps');
        dhome.CallApps();
        Apexpages.currentPage().getParameters().put('WhatOpp', 'This Month Opps');
        dhome.CallOpportunity();
        Apexpages.currentPage().getParameters().put('WhatSet', 'This Month Sets');
        dhome.CallSettled();
    }
    
    static testMethod void bPartner_dealPageController_testMethod4()
    {
        bPartner_dealPageController dhome = new bPartner_dealPageController();
        Apexpages.currentPage().getParameters().put('WhatLead', 'Last Month Leads');
        dhome.CallLeads();
        Apexpages.currentPage().getParameters().put('WhatApp', 'Last Month Apps');
        dhome.CallApps();
        Apexpages.currentPage().getParameters().put('WhatOpp', 'Last Month Opps');
        dhome.CallOpportunity();
        Apexpages.currentPage().getParameters().put('WhatSet', 'Last Month Sets');
        dhome.CallSettled();
    }
    
    static testMethod void bPartner_dealPageController_testMethod5()
    {
        bPartner_dealPageController dhome = new bPartner_dealPageController();
        Apexpages.currentPage().getParameters().put('WhatLead', 'This Year Leads');
        dhome.CallLeads();
        Apexpages.currentPage().getParameters().put('WhatApp', 'This Year Apps');
        dhome.CallApps();
        Apexpages.currentPage().getParameters().put('WhatOpp', 'This Year Opps');
        dhome.CallOpportunity();
        Apexpages.currentPage().getParameters().put('WhatSet', 'This Year Sets');
        dhome.CallSettled();
    }
    
    static testMethod void bPartner_CommonConstant_testMethod()
    {
        bPartner_CommonConstant cc = new bPartner_CommonConstant();
    }
    
    static testMethod void bPartner_LoginController_testMethod()
    {        
        contact cont = new contact();
        cont.lastname = 'lastname';
        insert cont;
        
        bPartner_LoginController lc = new bPartner_LoginController();
        lc.email = 'abc@gmail.com';
        lc.password='abc@gmail.com';
        lc.loginAction();
        lc.forgotPass();
    }
}