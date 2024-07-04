({
    loadAPIDetail: function(component, event) {
     	var recId = component.get("v.recordId");
        if (!recId) {
            recId = component.get("v.APIDetailRecordId");
        }      
        
        var actionAPIDetail = component.get("c.loadAPIDetail");
        actionAPIDetail.setParams({
            APIDetailRecordId : recId
        });
        actionAPIDetail.setCallback(this, function(response){

            var state = response.getState();
    
            if (state === "SUCCESS") {
               
                var APIDetail = response.getReturnValue();

                component.set("v.APIDetail", APIDetail); 
               	
                component.set("v.recordId",component.get("v.APIDetail.Id") );
                component.set("v.APIDetailRecordId",component.get("v.APIDetail.Id") );   
                
                component.set("v.hasRecord",true);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                
                this.handleErrors( response.getError() );
            }          
        });
        $A.enqueueAction(actionAPIDetail);  
       
    },
    loadLoginLink: function(component, event) {
             
        var actionLoginLink = component.get("c.loadLoginLink");

        actionLoginLink.setCallback(this, function(response){

            var state = response.getState();
        
            if (state === "SUCCESS") {
               
                var LLink = response.getReturnValue();

                component.set("v.loginLink", LLink); 
               	             
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                
                this.handleErrors( response.getError() );
            }          
        });
        $A.enqueueAction(actionLoginLink);  
       
    },               
    handleErrors : function(errors) {
        // Configure error toast
        let toastParams = {
            title: "Error",
            message: "Unknown error", // Default error message
            type: "error"
        };
        // Pass the error message if any
        if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        // Fire error toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }    
})