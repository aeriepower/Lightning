public class Utils {

    public Map<String, Map<String, String>> recordTypeMap = new Map<String, List<RecordType>>();

    /**
    * Method to retrieve a json with all the data of a picklist from an sObject
    */
    @AuraEnabled
    public static String getPicklistMetadata(String sObjectName, string fieldName) {
        List <PicklistItem> items = new List<PicklistItem>();
        Map < String, Schema.SObjectField > fieldMap = Utils.getSobjectFieldsMap(sObjectName);
        List < Schema.PicklistEntry > values = fieldMap.get(fieldName).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a: values) {
            PicklistItem item = new PicklistItem();
            item.value = a.getValue();
            item.label = a.getLabel();
            items.add(item);
        }
        return JSON.serialize(items);
    }

    /**
    * Complementary class used when request data about an sObject's picklist
    */
    public class PicklistItem {
        public String label;
        public String value;
    }

    /**
    * Method to retrieve a list of any sObject fields
    * @String typeName Is the sObjectType's Name
    */
    public static List<String> getAllFields(String sObjectName) {
        Map<String, Schema.SObjectField> a_fields = Utils.getSobjectFieldsMap(sObjectName);
        List<String> fields = new List<String>();

        for (Schema.sObjectField field:a_fields.values()) {
            fields.add(field + '');
        }
        return fields;
    }

    /**
    * Common method used to retrieve a map of fields from an object
    */
    public static Map<String, Schema.SObjectField> getSobjectFieldsMap(String sObjectName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
        sObject obj = targetType.newSObject();
        Schema.DescribeSObjectResult a_desc = obj.getSObjectType().getDescribe();
        return a_desc.fields.getMap();
    }

    /**
    * Method to retrieve the a Map<Name, Id> about the Record types of an sObject
    */
    public static String getSobjectRecordType(String sObjectName) {
        if (!Utils.recordTypeMap.containsKey(sObjectName)) {
            Map<String, String> recordTypesMap = new Map<String, String>();
            for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType = :sObjectName]) {
                recordTypesMap.put(rt.Name, rt.Id);
            }
            Utils.recordTypeMap.put(sObjectName, recordTypesMap);
        }

        return Utils.recordTypeMap.get(sObjectName);
    }
}