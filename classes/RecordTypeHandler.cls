public class RecordTypeHandler {

	/**
	* @String obj => Object API Name
	* @String fld => Field Name / DeveloperName
	*/
	public static Id get(String obj, String fld) {
		Id recordTypeId;
		Schema.SObjectType objSchema = Schema.getGlobalDescribe().get(obj);
		if(objSchema != null) {
			Schema.RecordTypeInfo rtInfo = objSchema.getDescribe().getRecordTypeInfosByDeveloperName().get(fld);
			if(rtInfo == null) {
				rtInfo = objSchema.getDescribe().getRecordTypeInfosByName().get(fld);
			}
			if(rtInfo != null) {
				recordTypeId = rtInfo.getRecordTypeId();
			}
		}
		return recordTypeId;
	}

	/**
	* @String obj => Object API Name
	* @String fld => Field Name / DeveloperName
	* @Id rtId => Id to compare
	*/
	public static boolean compare(String obj, String fld, Id rtId){
		return get(obj, fld) == rtId;
	}
}