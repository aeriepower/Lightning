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
	*/
	public Callout(String endpoint, String method){
		this.http = new Http();
		this.req = new HttpRequest();
		this.req.setEndpoint(endpoint);
		this.req.setMethod(method);
	}

	/**
	* Sends the request to the endpoint and setup the class variables depending on the response
	*/
	public Callout send(){
		this.httpRes = this.http.send(this.req);
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
		return this;
	}

	/**
	* Set the  to the callout
	*/
	public Callout setEndpoint(String endpoint){
		this.req.setEndpoint(endpoint);
		return this;
	}

	/**
	* Set the  to the callout
	*/
	public Callout setMethod(String method){
		this.req.setMethod(method);
		return this;
	}

	/**
	* Set the body to the callout
	*/
	public Callout setBody(String body){
		this.req.setBody(body);
		return this;
	}

	/**
	* Set the body document to the callout
	*/
	public Callout setBodyDocument(DOM.Document doc){
		this.req.setBodyDocument(doc);
		return this;
	}

	/**
	* Set the timeout to the callout
	*/
	public Callout setTimeout(Integer timeout){
		this.req.setTimeout(timeout);
		return this;
	}

	/**
	* Set an header to the callout
	*/
	public Callout setHeader(String key, String value){
		this.req.setHeader(key, value);
		return this;
	}

	/**
	* Set a list of headers to the callout
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