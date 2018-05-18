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
	},

	synthesize : function(component, event, helper) {
        sinthesizer = new SpeechSynthesisUtterance;
        sinthesizer.lang = 'es-ES';
        var msg = event.getParam("arguments").msg;
        sinthesizer.text = msg;
        speechSynthesis.speak(sinthesizer);
	}
})