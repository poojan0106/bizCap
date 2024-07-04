({
	doInit : function(component, event, helper) {
     	var recId = component.get("v.recordId");
        if (!recId) {
            recId = component.get("v.APIDetailRecordId");
        }
        
        helper.loadAPIDetail(component, event);	
        helper.loadLoginLink(component, event);	
	}
})