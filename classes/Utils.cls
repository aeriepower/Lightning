public class Utils {

    /**
    * Method to retrieve a json with all the data of a picklist from an sObject
    * @String sObjectName Is the sObjectType's name
    * @String fieldName Is the picklist's name
    */
    public static List <PicklistItem> getPicklistMetadata(String sObjectName, string fieldName) {
        List <PicklistItem> items = new List<PicklistItem>();
        Map < String, Schema.SObjectField > fieldMap = Utils.getSobjectFieldsMap(sObjectName);
        List < Schema.PicklistEntry > values = fieldMap.get(fieldName).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a: values) {
            PicklistItem item = new PicklistItem();
            item.value = a.getValue();
            item.label = a.getLabel();
            items.add(item);
        }
        return items;
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
    * @String sObjectName Is the sObjectType's Name
    */
    public static String getsObjectFields(String sObjectName) {
        List<String> allFields = Utils.getAllFields(sObjectName);
        return String.join( allFields, ',');
    }

    /**
    * Method to retrieve a list of any sObject fields
    * @String sObjectName Is the sObjectType's Name
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
    * @String sObjectName Is the sObjectType's Name
    */
    public static Map<String, Schema.SObjectField> getSobjectFieldsMap(String sObjectName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
        sObject obj = targetType.newSObject();
        Schema.DescribeSObjectResult a_desc = obj.getSObjectType().getDescribe();
        return a_desc.fields.getMap();
    }

    /**
    * Method to validate EU NIFs
    * @String nif Is the identification
    */
    public static EuNifValidator.ValidationResult validateNif(String nif){
        return EuNifValidator.validateNif(nif);
    }

   /**
   * Returns a boolean depending if the Organization is an Sandbox
   */
    public static Boolean IsProductionOrg() {
        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        return (org.IsSandbox == true) ? false : true;
    }

    /**
    * Returns a valid XML Document when contains an CDATA Structure inside of the XML Structure
    * @String xml Is the XML structure formed with the CDATA included
    */
    public static DOM.Document generateXMLWithCDATA(String xml) {
        xml = xml.replaceAll( '<!\\[CDATA\\[', 'XML_CDATA_START' ).replaceAll( ']]>', 'XML_CDATA_END' );
        Map<String, String> replacementMap = new Map<String, String>();
        Pattern myPattern = Pattern.compile( '(XML_CDATA_START)(.*?)(XML_CDATA_END)' );
        Matcher myMatcher = myPattern.matcher( xml );

        while ( myMatcher.find() ) {
            replacementMap.put( myMatcher.group(), myMatcher.group(2).escapeXML() );
        }

        for ( String key : replacementMap.keySet() ) {
            xml = xml.replace( key, replacementMap.get( key ) );
        }

        Dom.Document doc = new Dom.Document();
        doc.load( xml );
        return doc;
    }
}