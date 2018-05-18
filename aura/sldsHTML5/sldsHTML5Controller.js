({
	notify : function(component, event, helper) {
        var params = event.getParam('arguments');
        if(params && window.Notification && Notification.permission !== "denied") {
            Notification.requestPermission(function(status) {
                // status is "granted", if accepted by user
                var n = new Notification(params.title, {
                    body: params.msg,
                    icon: params.icon // optional
                });
            });
        }
	}
})