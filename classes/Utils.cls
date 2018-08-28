public class Utils {
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

	public class PicklistItem {
		public String label;
		public String value;
	}
}