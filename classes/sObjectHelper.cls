/**
 * The porpuse of this class is to help with sObject metadata common methods.
 * This methods are accessed by Static way and are listed at the end of this class.
 */
public class sObjectHelper {
	private sObject obj;
	private List<sObject> objList;
	private Schema.SObjectType type;
	private Schema.DescribeSObjectResult describe;
	private Map<String, Schema.SObjectField> fields;
	private Map<String, Schema.RecordTypeInfo> rtDevNameMap;
	private Map<String, Schema.RecordTypeInfo> rtNameMap;

	private sObjectHelper(String name){
		if(!String.isEmpty(name)){
			Schema.SObjectType objType = Schema.getGlobalDescribe().get(name);
			if(objType != null) {
				this.obj = objType.newSObject();
				this.type = objType;
				this.describe = this.type.getDescribe();
			} else {
				throw new SObjectException('No se encuentra la clase "' + name + '" en la metadata global.');
			}
		} else {
			throw new SObjectException('Esta clase no acepta un nombre vacio como parametro de construccion.');
		}
	}

	private sObjectHelper(sObject obj){
		if(obj != null){
			this.obj = obj;
			this.type = this.obj.getSObjectType();
			this.describe = this.type.getDescribe();
		} else {
			throw new SObjectException('Esta clase no acepta un null como parametro de construccion.');
		}
	}

	private sObjectHelper(List<sObject> objList){
		if(objList != null && objList.size() > 0){
			this.obj = objList[0];
			this.type = this.obj.getSObjectType();
			this.describe = this.type.getDescribe();
			for(Integer i = 0; i < objList.size(); i++){
				sObject obj = this.objList.get(i);
				if(obj.getSObjectType() != this.type){
					objList.remove(i);
				}
			}
		} else {
			throw new SObjectException('Esta clase no acepta una lista nula o vacia como parametro de construccion.');
		}
	}

	private List<String> getObjFields(){
		List<String> fields = new List<String>();
		this.fields = this.describe.fields.getMap();
		for (Schema.sObjectField field: this.fields.values()) {
			fields.add(String.valueOf(field));
		}
		return fields;
	}

	private Map<String, Object> getInstFields(){
		return this.obj.getPopulatedFieldsAsMap();
	}
	
	private static Map<String, List<sObject>> filterTheRecords(List<sObject> newObjList, Map<Id, sObject> oldObjMap, List<String> fields, Boolean allOrNone){
		Map<String, List<sObject>> response = new Map<String, List<sObject>>();
		response.put('changed', new List<sObject>());
		response.put('notChanged', new List<sObject>());
		for(sObject newObj : newObjList){
			sObject oldObj = oldObjMap.get(newObj.Id);
			Boolean hasChanged = false;
			Boolean hasChangedAllOrNone = true;
			for (String field : fields){
				if(newObj.get(field) != oldObj.get(field)){
					hasChanged = true;
				} else {
					hasChangedAllOrNone = false;
				}
			}
			hasChanged = allOrNone ? hasChangedAllOrNone : hasChanged;
			if(hasChanged){
				response.get('changed').add(newObj);
			} else {
				response.get('notChanged').add(newObj);
			}
		}
		return  response;
	}
	
	public Id getTheRecordType(String field){
		Id recordTypeId;
		this.rtDevNameMap = this.describe.getRecordTypeInfosByDeveloperName();
		this.rtNameMap = this.describe.getRecordTypeInfosByName();
		if(this.rtDevNameMap.containsKey(field)){
			recordTypeId = this.rtDevNameMap.get(field).getRecordTypeId();
		} else if(this.rtNameMap.containsKey(field)){
			recordTypeId = this.rtNameMap.get(field).getRecordTypeId();
		}
		return recordTypeId;
	}
	
	/*public Map<String, List<sObject>> separateTheListByRT(){
		Map<String, List<sObject>> separatedLists = new Map<String, List<sObject>>();
		Map<Id, String> idDevNameMap = new Map<Id, String>();
		for(String rtDevName : this.rtDevNameMap.keySet()){
			idDevNameMap.put(this.rtDevNameMap.get(rtDevName).getRecordTypeId(), rtDevName);
		}
		for(sObject obj : this.objList){
			if(obj.RecordTypeId != null){
				if(idDevNameMap.containsKey(obj.RecordTypeId)){
					String rtDevName = idDevNameMap.get(obj.RecordTypeId);
					if(separatedLists.containsKey(rtDevName)){
						separatedLists.get(rtDevName).add(obj);
					} else {
						separatedLists.put(rtDevName, new List<sObject>{obj});
					}
				}
			}
		}
		return separatedLists;
	}*/

	private List<PicklistItem> getPicklistMetadata(String field){
		this.fields = this.describe.fields.getMap();
		Schema.SObjectField sObjectField = this.fields.get(field);
		List<PicklistItem> items = new List<PicklistItem>();
		if(sObjectField != null){
			List < Schema.PicklistEntry > values = sObjectField.getDescribe().getPickListValues();
			for (Schema.PicklistEntry a: values) {
				PicklistItem item = new PicklistItem();
				item.value = a.getValue();
				item.label = a.getLabel();
				items.add(item);
			}
		}
		return items;
	}

	/**
	 * Complementary class used when request data about an sObject's picklist
	 */
	private class PicklistItem {
		private String label;
		private String value;
	}
	
	/**
	 * Static methods to access this class functionalities without creating an external instance.
	 */
	
	/**
	 * Method to get an sObject fields (based on sObject Name)
	 */
	public static List<String> getObjectFields(String objName){
		sObjectHelper helper = new sObjectHelper(objName);
		return helper.getObjFields();
	}
	
	/**
	 * Method to get an sObject fields (based on sObject)
	 */
	public static List<String> getObjectFields(sObject obj){
		sObjectHelper helper = new sObjectHelper(obj);
		return helper.getObjFields();
	}
	
	/**
	 * Method to get all the fields than and sObject instance contains (based on sObject Name)
	 */
	public static Map<String, Object> getInstanceFields(String objName){
		sObjectHelper helper = new sObjectHelper(objName);
		return helper.getInstFields();
	}
	
	/**
	 * Method to get all the fields than and sObject instance contains (based on sObject)
	 */
	public static Map<String, Object> getInstanceFields(sObject obj){
		sObjectHelper helper = new sObjectHelper(obj);
		return helper.getInstFields();
	}
	
	/**
	 * Method to get a list of picklist label/values from an sObject (based on sObject Name)
	 */
	public static List<PicklistItem> getPicklist(String objName, String picklist){
		sObjectHelper helper = new sObjectHelper(objName);
		return helper.getPicklistMetadata(picklist);
	}
	
	/**
	 * Method to get a list of picklist label/values from an sObject (based on sObject)
	 */
	public static List<PicklistItem> getPicklist(sObject obj, String picklist){
		sObjectHelper helper = new sObjectHelper(obj);
			return helper.getPicklistMetadata(picklist);
	}
	
	/**
	 * Method to get the Id of an RecordType (based on sObject Name)
	 */
	public static Id getRecordType(String objName, String field){
		sObjectHelper helper = new sObjectHelper(objName);
		return helper.getTheRecordType(field);
	}
	
	/**
	 * Method to get the Id of an RecordType (based on sObject)
	 */
	public static Id getRecordType(sObject obj, String field){
		sObjectHelper helper = new sObjectHelper(obj);
		return helper.getTheRecordType(field);
	}
	
	/**
	 * Method to get a map with two list depending if a list of sObject has been changed or not in a list of fields.
	 * It checks if almost one of the fields has been changed.
	 */
	public static Map<String, List<sObject>> recordsHasBeenChanged(List<sObject> newObjList, Map<Id, sObject> oldObjMap, List<String> fields){
		return filterTheRecords(newObjList, oldObjMap, fields, false);
	}
	
	/**
	 * Method to get a map with two list depending if a list of sObject has been changed or not in a list of fields.
	 * allOrNone decide if is needed to change all the fields to put the record in the changed list.
	 */
	public static Map<String, List<sObject>> recordsHasBeenChanged(List<sObject> newObjList, Map<Id, sObject> oldObjMap, List<String> fields, Boolean allOrNone){
		return filterTheRecords(newObjList, oldObjMap, fields, allOrNone);
	}

}