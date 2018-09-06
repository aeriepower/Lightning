public class Utils {

	/**
	* Method to retrieve a json with all the data of a picklist from an sObject
	* @sObject objObject Is the sObject from to get the picklist
	* @String fld Is the name of the field where is hosted the pickList
	*/
	@AuraEnabled
	public static String getPicklistMetadata(sObject objObject, string fld) {
		List <PicklistItem> items = new List<PicklistItem>();
		Schema.sObjectType objType = objObject.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
		list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();

		// Add these values to the selectoption list.
		for (Schema.PicklistEntry a: values) {
			PicklistItem item = new PicklistItem();
			item.value = a.getValue();
			item.label = a.getLabel();
			items.add(item);
		}
		return JSON.serialize(items);
	}

	/**
	* Method to retrieve a list of any sObject fields
	* @String typeName Is the sObjectType's Name
	*/
	public static List<String> getAllFields(String typeName){
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
		sObject obj = targetType.newSObject();
		Schema.DescribeSObjectResult a_desc = obj.getSObjectType().getDescribe();
		Map<String, Schema.SObjectField> a_fields = a_desc.fields.getMap();
		List<String> fields = new List<String>();

		for (Schema.sObjectField field:a_fields.values()) {
			fields.add(field + '');
		}
		return fields;
	}

	public class PicklistItem {
		public String label;
		public String value;
	}
}