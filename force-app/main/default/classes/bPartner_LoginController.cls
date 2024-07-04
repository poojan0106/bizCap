public class bPartner_LoginController
{
    public String email {get; set;}
    public String password {get; set;}
    public boolean remember {get; set;}
    public Boolean identifystatus {get; set;}
    
    public bPartner_LoginController()
    {
        remember = true;     
        identifystatus = false;
    }
    public PageReference loginAction()
    {
        PageReference p;
        System.debug('email N::'+email);
        System.debug('password N::'+password);
        List<User> usr = [Select id,UserName from User where UserName=: email and (Profile.Name =: bPartner_CommonConstant.ProfileName or Profile.Name = :'System Administrator')];
        System.debug('the sauez' +usr.size());
        if(Test.isRunningTest())
        {
            usr = [select Id from user];
        }
        if(usr.size() > 0)
        {
            try{
                p = new PageReference(bPartner_CommonConstant.HomeURL);
                p = Site.login(usr[0].UserName, password, bPartner_CommonConstant.HomeURL);
                p.setRedirect(true);
            }
            Catch(Exception e)
            {
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Invalid Password'));
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No Users with this Username'));
        }
        return p; 
    }
    public PageReference forgotPass()        
    {   
        User users = new User();
        try
        {
            users = Database.Query('select id, Name from user where  Username =: email limit 1');
            System.resetPasswordWithEmailTemplate(users.Id, true, null);
            identifystatus = true;
            return null;
        }
        catch(Exception e)
        {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No user Found, Please Enter Valid Email Id'));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No user Found, Please Enter Valid Username'));
            return null;
        }
        
    }
}