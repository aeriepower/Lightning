public class GoogleApi{

    public static Map<String, String> methods = new Map<String, String>{
        'retrieveGeoDecodification' => 'GET'
    };

    // Your public key here
    public static String key = '';

    public GoogleApi() {
    }

    @AuraEnabled
    public static String retrieveGeoDecodification(String latlng) {
        String endPoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=' + latlng + '&key=' + GoogleApi.key;
        Callout callout = new Callout(endPoint, GoogleApi.methods.get(methodName));
        return callout.body;
    }
}