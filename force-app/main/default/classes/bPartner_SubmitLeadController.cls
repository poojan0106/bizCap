public class bPartner_SubmitLeadController {
    
    public String firstname{get;set;}
    public String lastname{get;set;}
    public String company_name{get;set;}
    public String abn{get;set;}
    public String phy_state{get;set;}
    public String mobile_number{get;set;}
    public String email{get;set;}
    public Decimal amount_needded{get;set;}
    public Decimal avg_monthly_turnover{get;set;}
    public String notes{get;set;}
    public String Industry{get;set;}
    public String document_Id{get;set;}
    public List<Lead> InsertLead;

    //public blob image {get; set;}
    //public Transient String filename{get;set;}
    //public Transient  String bodyVal{get;set;}
    public String myuserid {get;set;}
    public String conLeadSource {get; set;}
    public String BrokerName;
    public boolean CallBroker {get; set;}
    public String finalValue {get;set;}
    
    public bPartner_SubmitLeadController()
    {
        myuserid = UserInfo.getUserId();
        User usr = [Select Name, id, Contact.name, ContactId, Contact.LeadSource, Contact.Portal_User_Type__c
                    From User 
                    where  Id = :myuserid ];
        conLeadSource = usr.Contact.LeadSource;
        BrokerName = usr.Contact.Name;
        finalValue ='';
        
    }
    public transient String base64;
    public string count;
    public  string MYLeadId{get;set;}
    public String name{get;set;}
    public String getBase64()
    {
        return base64;
    }
    public void setbase64(String base64)
    {
        this.base64 = base64;
    }
    
    public String getcount()
    {
        return count;
    }
    public void setcount(String count)
    {
        this.count = count;
    }
    
    public String fileName {get; set;}    
    public void saveFile()
    {
        System.debug('Data N:::'+firstname+':::'+lastname+':::'+company_name+':::'+mobile_number+':::'+email+':::'+amount_needded+':::'+avg_monthly_turnover+':::'+notes+':::'+document_Id);
        List<Lead> InsertLead = new List<Lead>();
        Lead lead = new lead();
        string leadid;
        system.debug('fileName N::: ' + fileName);        
        system.debug('count N::: ' + count);
        //if(count == 'yes')
        {
            if(firstname != null && firstname != '')
            {
                lead.FirstName = firstname;
            }
            if(lastname != null && lastname != '')
            {
                lead.LastName = lastname;
            }
            if(company_name != null && company_name != '')
            {
                lead.Company = company_name;
            }
            if(mobile_number != null && mobile_number != '')
            {
                lead.MobilePhone = mobile_number;
            }
            if(email != null && email != '')
            {
                lead.email = email;
            }
            if(amount_needded != null)
            {
                lead.Amount_requested__c = amount_needded;
            }
            if(avg_monthly_turnover != null)
            {
                lead.Monthly_Rent__c = avg_monthly_turnover;
            }
            if(notes != null && notes != '')
            {
                lead.Status_Notes__c = notes;
            }
            if(document_Id != null && document_Id != '')
            {
                lead.Document_ID__c = document_Id;
            }
            if(abn != null && abn != '')
            {
                lead.ABN__c = abn;
            }
            if(phy_state != null && phy_state != '')
            {
                lead.State_Physical__c = phy_state;
            }
            if(Industry != null && Industry != '' && Industry != 'Select Industry')
            {
                lead.Industry_Pick__c = Industry;
            }
            
            if(conLeadSource != null && conLeadSource != '')
            {
                lead.LeadSource = conLeadSource;
            }
            if(BrokerName != Null && BrokerName != '')
            {
                lead.Broker_Name__c = BrokerName;
            }
            if(CallBroker != null && CallBroker == true)
            {
                lead.Client_or_Broker__c = 'Call Broker';
            }
            InsertLead.add(lead);
            
            if(InsertLead != null && InsertLead.size()>0)
            {
                insert InsertLead;
                MYLeadId = InsertLead[0].id;
            }
        }
       /* if(fileName != null && fileName != '')
        {
            Attachment a = new Attachment();
            a.parentId = MYLeadId;
            a.Body =  EncodingUtil.base64Decode(base64);
            a.name = fileName;
            insert a;
        }*/
    }
    
    public List<SelectOption> Industry_Pick
    {
        get
        {
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Lead.Industry_Pick__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            return options;
        }
    }
}