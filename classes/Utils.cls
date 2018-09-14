public class Utils {

	/**
	* Method to retrieve a json with all the data of a picklist from an sObject
	* @sObject objObject Is the sObject from to get the picklist
	* @String fld Is the name of the field where is hosted the pickList
	*/
	@AuraEnabled
	public static String getPicklistMetadata(String typeName, string fld) {
		List <PicklistItem> items = new List<PicklistItem>();
		Map < String, Schema.SObjectField > fieldMap = Utils.getSobjectFieldsMap(typeName);
		List < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();

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
	public static List<String> getAllFields(String typeName) {
		Map<String, Schema.SObjectField> a_fields = Utils.getSobjectFieldsMap(typeName);
		List<String> fields = new List<String>();

		for (Schema.sObjectField field:a_fields.values()) {
			fields.add(field + '');
		}
		return fields;
	}

	public static Map<String, Schema.SObjectField> getSobjectFieldsMap(String typeName) {
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
		sObject obj = targetType.newSObject();
		Schema.DescribeSObjectResult a_desc = obj.getSObjectType().getDescribe();
		return a_desc.fields.getMap();
	}

	public class PicklistItem {
		public String label;
		public String value;
	}
}