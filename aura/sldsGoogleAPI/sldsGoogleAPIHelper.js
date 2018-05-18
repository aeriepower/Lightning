({
    performAction : function(component,actionName,params,callback) {
        var action=component.get(actionName);
        if(action){
            action.setParams(params);
            action.setCallback(this,callback);
            $A.enqueueAction(action);
        }
    },
})