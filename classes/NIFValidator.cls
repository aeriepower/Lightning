/**
 * Created by david.hurtado.banda on 03/07/2019.
 */
public class NIFValidator {
	private static final String TINENDPOINT = 'https://ec.europa.eu/taxation_customs/tin/services/checkTinService';
	private static final String VATENDPOINT = 'http://ec.europa.eu/taxation_customs/vies/services/checkVatService';
	private static NIFValidator instance;
	private String countryCode;
	private String id;
	private Boolean valid = false;
	
	/**
	 * Constructor
	 */
	private NIFValidator(String id){
		this.setCountryAndNIF(id);
	}
	
	/**
	 * Static method that can throw the process to validate the European NIF
	 */
	public static Boolean validateTin(String id){
		if(NIFValidator.instance == null){
			NIFValidator.instance = new NIFValidator(id);
		}
		NIFValidator.instance.callTinWebservice();
		return NIFValidator.instance.getValid();
	}
	
	/**
	 * Static method that can throw the process to validate the European NIF
	 */
	public static Boolean validateVat(String id){
		if(NIFValidator.instance == null){
			NIFValidator.instance = new NIFValidator(id);
		}
		NIFValidator.instance.callVatWebservice();
		return NIFValidator.instance.getValid();
	}
	
	/**
	 * Check the first and second letter from the String passed.
	 * If doesn't match on the list, it sets "ES" by default
	 */
	public void setCountryAndNIF(String id) {
		List<String> validCountries = new List<String>{
				'AT', 'BE', 'BG', 'CY', 'CZ', 'DE', 'DK',
				'ES', 'HR', 'EE', 'FI', 'FR', 'GB', 'GR',
				'HU', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT',
				'NL', 'PL', 'PT', 'RO', 'SE', 'SK', 'SI'};
		String ct  = id.substring(0,2);
		String nif = id.substring(2,id.length());
		if(validCountries.contains(ct)){
			this.setCountryCode(ct);
			this.setId(nif);
		} else {
			this.setCountryCode('ES');
			this.setId(id);
		}
	}
	
	/**
	 * Do the call to the webservice and check if Structure and sintax are correct.
 	 * WSDL: https://ec.europa.eu/taxation_customs/tin/checkTinService.wsdl
	 */
	private void callTinWebservice(){
		String xml =
				'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ec.europa.eu:taxud:tin:services:checkTin:types">' +
				'<soapenv:Header/>' +
				'<soapenv:Body>' +
				'<urn:checkTin>' +
				'<urn:countryCode>'
				+ this.getCountryCode() +
				'</urn:countryCode>' +
				'<urn:tinNumber>'
				+ this.getId() +
				'</urn:tinNumber>' +
				'</urn:checkTin>' +
				'</soapenv:Body>' +
				'</soapenv:Envelope>';
		
		Callout callout = new Callout(TINENDPOINT, 'GET');
		callout.setHeader('Content-Type', 'text/xml');
		callout.setBodyDocument(xml);
		callout.send();
		
		if(!isNull(callout.httpRes) && isNull(callout.myException)){
			DOM.Document docRes = callout.httpRes.getBodyDocument();
			Dom.XMLNode xmlNode = docRes.getRootElement();
			xmlNode = xmlNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
			xmlNode = xmlNode.getChildElement('checkTinResponse', 'urn:ec.europa.eu:taxud:tin:services:checkTin:types');
			Boolean validStructure = false;
			Boolean validSyntax = false;
			Dom.XMLNode validStructureNode = xmlNode.getChildElement('validStructure','urn:ec.europa.eu:taxud:tin:services:checkTin:types');
			if(validStructureNode != null){
				validStructure = Boolean.valueOf(validStructureNode.getText());
			}
			Dom.XMLNode validSyntaxNode = xmlNode.getChildElement('validSyntax','urn:ec.europa.eu:taxud:tin:services:checkTin:types');
			if(validSyntaxNode != null){
				validSyntax = Boolean.valueOf(validSyntaxNode.getText());
			}
			this.valid = validSyntax && validStructure;
		}
	}
	
	/**
	 * Do the call to the webservice and check if Structure and sintax are correct.
 	 * WSDL: http://ec.europa.eu/taxation_customs/vies/checkVatService.wsdl
	 */
	private void callVatWebservice(){
		String xml =
				'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ec.europa.eu:taxud:vies:services:checkVat:types">' +
				'<soapenv:Header/>' +
				'<soapenv:Body>' +
				'<urn:checkVat>' +
				'<urn:countryCode>'
				+ this.getCountryCode() +
				'</urn:countryCode>' +
				'<urn:vatNumber>'
				+ this.getId() +
				'</urn:vatNumber>' +
				'</urn:checkVat>' +
				'</soapenv:Body>' +
				'</soapenv:Envelope>';
		
		Dom.Document doc = new Dom.Document();
		doc.load( xml );
		
		
		Callout callout = new Callout(VATENDPOINT, 'GET');
		callout.setHeader('Content-Type', 'text/xml');
		callout.setBodyDocument(doc);
		callout.send();
		
		if(!isNull(callout.httpRes) && isNull(callout.myException)){
			DOM.Document docRes = callout.httpRes.getBodyDocument();
			Dom.XMLNode xmlNode = docRes.getRootElement();
			xmlNode = xmlNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
			xmlNode = xmlNode.getChildElement('checkVatResponse', 'urn:ec.europa.eu:taxud:vies:services:checkVat:types');
			Boolean valid = false;
			Dom.XMLNode validStructureNode = xmlNode.getChildElement('valid','urn:ec.europa.eu:taxud:vies:services:checkVat:types');
			if(validStructureNode != null){
				valid = Boolean.valueOf(validStructureNode.getText());
			}
			this.valid = valid;
		}
	}
	
	private boolean isNull(Object obj){
		return obj == null;
	}
	
	/**
	 * GETTERS AND SETTERS
	 */
	public String getCountryCode() {
		return countryCode;
	}
	
	public String getId() {
		return id;
	}
	
	public Boolean getValid() {
		return valid;
	}
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
}