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


    /**
    * Returns a valid XML Document when contains an CDATA Structure inside of the XML Structure
    * @List<sObject> newList Is a list of the new records
    * @Map<Id, sObject> oldMap Is a map of id, old records
    * @List<String> fields Is a list of the fields to compare
    */
    public static Map<Id, sObject> compareRecords (List<sObject> newList, Map<Id, sObject> oldMap, List<String> fields){
        Map<Id, sObject> changedItems = new Map<Id, sObject>();
        for(sObject newsO : newList) {
            sObject oldsO = oldMap.get(newsO.Id);
            for (String field : fields){
                if(changedItems.containsKey(newsO.Id)){
                    break;
                } else if(newsO.get(field) != oldsO.get(field)){
                    changedItems.put(newsO.Id, newsO);
                    break;
                }
            }
        }
        return changedItems;
    }


    /**
    * Returns a true if t he Id is good formed
    * @String id Is an supposed id to be checked
    */
    public static Boolean checkId (String id){
        Map<String, String> cases = new Map<String, String>();
        cases.put('00000','A');
        cases.put('00001','B');
        cases.put('00010','C');
        cases.put('00011','D');
        cases.put('00100','E');
        cases.put('00101','F');
        cases.put('00110','G');
        cases.put('00111','H');
        cases.put('01000','I');
        cases.put('01001','J');
        cases.put('01010','K');
        cases.put('01011','L');
        cases.put('01100','M');
        cases.put('01101','N');
        cases.put('01110','O');
        cases.put('01111','P');
        cases.put('10000','Q');
        cases.put('10001','R');
        cases.put('10010','S');
        cases.put('10011','T');
        cases.put('10100','U');
        cases.put('10101','V');
        cases.put('10110','W');
        cases.put('10101','X');
        cases.put('11000','Y');
        cases.put('11001','Z');
        cases.put('11010','0');
        cases.put('11011','1');
        cases.put('11100','2');
        cases.put('11101','3');
        cases.put('11110','4');
        cases.put('11111','5');
        Boolean valid = false;
        if(id.length() == 18){
            String first = id.substring(0, 4).reverse().replaceAll('[0-9]', '0');
            first.replaceAll('[a-z]', '0');
            first.replaceAll('[A-Z]', '1');
            String second = id.substring(5, 9).reverse().replaceAll('[0-9]', '0');
            second.replaceAll('[a-z]', '0');
            second.replaceAll('[A-Z]', '1');
            String third = id.substring(10, 14).reverse().replaceAll('[0-9]', '0');
            third.replaceAll('[a-z]', '0');
            third.replaceAll('[A-Z]', '1');

        }
        String last = cases.get(first) + cases.get(second) + cases.get(third);
        return id.substring(15, 17) == last;
    }

}