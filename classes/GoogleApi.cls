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
        return GoogleApi.performRequest(endPoint, 'retrieveGeoDecodification');
    }


    public static String performRequest(String endPoint, String methodName) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod(GoogleApi.methods.get(methodName));
        HttpResponse res = h.send(req);
        return res.getBody();
    }
}