/**
* Class to simplify the way to make an callout.
*
* Example: Callout callout = new Callout('http://icanhazip.com', 'POST').send();
*/

public class Callout {
    private Http http;
    private HttpRequest req;
    public String type;
    public String body;
    public Dom.Document document;
    public String status;
    public Integer statusCode;
    public Map<String, String> headers = new Map<String, String>();
    public HttpResponse httpRes;
    public MyException myException;

    /**
    * Constructor
    * @String endpoint Is the URL where is pointed to the callout
    * @String method Is the verb used for to perform the callout
    */
    public Callout(String endpoint, String method){
        this.http = new Http();
        this.req = new HttpRequest();
        this.req.setEndpoint(endpoint);
        this.req.setMethod(method);
    }

    /**
    * Sends the request to the endpoint and setup the class variables depending on the response.
    * In case the response isn't successfull, if set up an exception but doesn't throw it.
    */
    public Callout send(){
		try{
			this.httpRes = this.http.send(this.req);
            while (this.httpRes.getStatusCode() == 302) {
                this.req.setEndpoint(this.httpRes.getHeader('Location'));
                this.httpRes = new Http().send(this.req);
            }
			this.body = this.httpRes.getBody();
			this.status = this.httpRes.getStatus();
			for(String key : this.httpRes.getHeaderKeys()){
				this.headers.put(key, this.httpRes.getHeader(key));
			}
			this.type = this.httpRes.getHeader('Content-Type');
			this.statusCode = this.httpRes.getStatusCode();
			if(this.statusCode != 200){
				this.myException = new MyException(this.status);
			}
		} catch(Exception e){
			this.myException = new MyException(e.getMessage());
		}
        return this;
    }

    /**
    * Set the endpoint to the callout
    * @String method Is the verb used for to perform the callout
    */
    public Callout setEndpoint(String endpoint){
        this.req.setEndpoint(endpoint);
        return this;
    }

    /**
    * Set the method to the callout
    * @String method Is the verb used for to perform the callout
    */
    public Callout setMethod(String method){
        this.req.setMethod(method);
        return this;
    }

    /**
    * Set the body to the callout
    * @String body Is the body of the
    */
    public Callout setBody(String body){
        this.req.setBody(body);
        return this;
    }

    /**
    * Set a document in the body of the callout
    * @DOM.Document doc A document to be placed on the body
    */
    public Callout setBodyDocument(DOM.Document doc){
        this.req.setBodyDocument(doc);
        return this;
    }

    /**
    * Set the timeout to the callout
    * @Integer timeout The cipher of the timeout expressed in millisecs
    */
    public Callout setTimeout(Integer timeout){
        this.req.setTimeout(timeout);
        return this;
    }

    /**
    * Set an header to the callout
    * @String key The key of the header
    * @String value The value of the header
    */
    public Callout setHeader(String key, String value){
        this.req.setHeader(key, value);
        return this;
    }

    /**
    * Set a list of headers to the callout
    * @Map<String, String> headers The key-value map of the headers to be setted
    */
    public Callout setHeaders(Map<String, String> headers){
        if(headers != null){
            for(String key : headers.keySet()) {
                this.req.setHeader(key, headers.get(key));
            }
        }
        return this;
    }

    /**
    * Returns the Body document
    */
    public DOM.Document getResponseDocument(){
        this.document = this.httpRes.getBodyDocument();
        return this.document;
    }

    /**
    * Custom exception class
    */
    public class MyException extends Exception {}

    /**
    * Throws the callout's exception
    */
    public void throwException(){
        if(this.myException != null){
            throw this.myException;
        }
    }

}