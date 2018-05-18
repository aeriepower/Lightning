({
    /**
     * Create a new instance of WebkitSpeechRecognition and set it up
     */
    createSpeechRecognizer : function(component) {
        var speechRecognizer = new webkitSpeechRecognition();
        speechRecognizer.continuous = false;
        speechRecognizer.interimResults = true;
        speechRecognizer.lang = 'es-ES';
        return speechRecognizer;
    },
})