({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Id', fieldName: 'Id', type: 'text'},
            {label: 'Account name', fieldName: 'Name', type: 'text'}
        ]);

        let action = component.get("c.getPartners");

        action.setCallback(this, function(response){
            let records = response.getReturnValue();
            console.log("records: "+records);
            component.set("v.accList",records);
        });
        $A.enqueueAction(action);
    }
})
