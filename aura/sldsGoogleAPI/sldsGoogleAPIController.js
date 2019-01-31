({
    geoDecodificationInverse : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var callback, action;
            callback = params.callback;
            action=component.get("c.retrieveGeoDecodification");
            if(action){
                var params = { latlng: params.latLng };
                var callback = function(a) {
                    if (a.getState() === "SUCCESS") {
                        var res = a.getReturnValue();
                        if (callback) callback(response.getReturnValue());
                    }
                };
               this.performAction(component, action, params, callback);
            }

        }
    }
})