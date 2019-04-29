public class RecordTypeHandler {

	/**
	 * Contains the relations between fields and objects
	 */
	public static Map<String, String> fieldObjectRelation;


	/**
	 * Get the Id of the record type
	 * @obj => Object API Name
	 * @fld => Field Name / DeveloperName
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
	 * Get the Id of the record type
	 * @obj => Object API Name
	 * @fld => Field Name / DeveloperName
	 */
	public static Id get(String fld) {
		buildFieldObjectRelation();
		return get(fieldObjectRelation.get(field), field);
	}


	/**
	 * This method filter a list of sObjects by RecordType returning all except the ones who does match.
	 * @obj => Object API Name
	 * @fld => Field Name / DeveloperName
	 * @rtId => Id to compare
	 */
	public static boolean compare(String obj, String fld, Id rtId){
		return get(obj, fld) == rtId;
	}


	/**
	 * This method filter a list of sObjects by RecordType returning only the ones who does match.
	 * @obj => Object API Name
	 * @fld => Field Name / DeveloperName
	 * @originalList => A list to be filtered
	 */
	public static List<sObject> innerList(String obj, String fld, List<sObject> originalList){
		return filterList(obj, fld, originalList, 'inner');
	}


	/**
	 * This method filter a list of sObjects by RecordType returning all except the ones who does match.
	 * @obj => Object API Name
	 * @fld => Field Name / DeveloperName
	 * @originalList => A list to be filtered
	 */
	public static List<sObject> outerList(String obj, String fld, List<sObject> originalList){
		return filterList(obj, fld, originalList, 'outer');
	}


	/**
	 * This method filter a list of sObjects by RecordType returning all except the ones who does match.
	 * @ obj => Object API Name
	 * @ fld => Field Name / DeveloperName
	 * @originalList => A list to be filtered
	 * @method => Choose wich records returns
	 */
	public static List<sObject> filterList(String obj, String fld, List<sObject> originalList, String method){
		List<sObject> filteredList = new List<sObject>();
		for(sObject original : originalList){
			if(compare(obj, fld, (Id)original.get('RecordTypeId')) && method == 'inner' ||
							!compare(obj, fld, (Id)original.get('RecordTypeId')) && method == 'outer'){
				filteredList.add(original);
			}
		}
		return filteredList;
	}


	/**
	 * Get a map of RecordType names / ids of the object's name passed.
	 * @ obj => Object API Name
	 */
	public static Map<String, Id> getSobjectRTs(String obj){
		buildFieldObjectRelation();
		Map<String, Id> objRTs = new Map<String, Id>();

		for(String field : fieldObjectRelation.keySet()){
			String obj2 = fieldObjectRelation.get(field);
			if(obj == obj2){
				objRTs.put(field, get(obj, field));
			}
		}
		return objRTs;
	}


	/**
	 * It build a map to stablish the relation between RecordType Names /developernames and sObjects
	 */
	private static void buildFieldObjectRelation(){
		if(fieldObjectRelation == null){
			fieldObjectRelation = new Map<String, String>();
			/*
				Example:
				fieldObjectRelation.put("KindOfAccount", "Account");
			*/
		}
	}
}