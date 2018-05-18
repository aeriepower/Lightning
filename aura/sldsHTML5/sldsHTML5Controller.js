({
    /**
     * Simply function that will make a push notification in the window
     */
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

    /**
     * It is a functionality to transform a string into sound through the speakers
     */
	synthesize : function(component, event, helper) {
        sinthesizer = new SpeechSynthesisUtterance;
        sinthesizer.lang = 'es-ES';
        var msg = event.getParam("arguments").msg;
        sinthesizer.text = msg;
        speechSynthesis.speak(sinthesizer);
	},

    /**
     * It's a functionality to transform speech recognized by the microphone into an string.
     */
    speechRecognize :function (component, event, helper) {
        if ('webkitSpeechRecognition' in window){
            var params = event.getParam('arguments');
            var speechRecognizer = helper.createSpeechRecognizer(component);
            speechRecognizer.start();
            var phrase = '';
            speechRecognizer.onresult = function(event) {
                var finalTranscripts = '';
                var interimTranscripts = '';
                for (var i = event.resultIndex; i < event.results.length; i++) {
                    var transcript = event.results[i][0].transcript;
                    if(event.results[i].isFinal) {
                        finalTranscripts += transcript;
                    } else {
                        interimTranscripts += transcript;
                    }
                }
                phrase = finalTranscripts + ' ' + interimTranscripts;
            }
            speechRecognizer.onend = function(event) {
                if (params.callback) callback(phrase);
                return phrase;
            }
            speechRecognizer.onerror = function(event) {
                console.log(event.error);
            }
        } else {
            alert("Not webkitSpeechRecognition service at Window object");
        }
    }
})