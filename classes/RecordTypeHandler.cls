/**
* Use cases:
* - Method get(sObectType, sObjectField)
    We can have a record type giving the name of the sObject and the name/developerName
    If we provide the Name it will try to get it from the Schema so will not make any DML
    If we provide the DeveloperName it will retrieve all the RTs, will host them into a Singleton and return the RT
* - Method getSobjectRTs(sObjectType)
    It will retrieve all the RTs and, will host them into a Singleton and return a map of the sObject RTs
*/

public class RecordTypeHandler {
    public class CustomException extends Exception {}
    private static RecordTypeHandler instance;
    private Map<String, Map<String, Id>> recordTypes = new Map<String, Map<String, String>>();

    /**
    * Returns the only instance of the class along the whole process
    */
    public static  RecordTypeHandler getInstance() {
        RecordTypeHandler.instance = RecordTypeHandler.instance == null ? new RecordTypeHandler() : RecordTypeHandler.instance;
        return RecordTypeHandler.instance;
    }

    /**
    * Privatized Creator method to prevent the creation of an instance outside of the class
    */
    private RecordTypeHandler(){

    }

    /**
    * Returns a map about all the record types from an specific object
    * @String sobjectType Is the API name of the sObject
    */
    public static Map<String, Id> getSobjectRTs(String sObjectType) {
        RecordTypeHandler rth = RecordTypeHandler.getInstance();

        if (rth.recordTypes.containsKey(sObjectType)) {
            return rth.recordTypes.get(sObjectType);
        } else {
            rth.retrieveRTs();
            if (rth.recordTypes.containsKey(sObjectType)) {
                return rth.recordTypes.get(sObjectType);
            } else {
                throw new CustomException('There are not RecordTypes for requested SObject');
            }
        }
    }

    /**
    * Returns the Id of and specific record type name in a specific object
    * @String sobjectType Is the API name of the sObject
    * @String rtName Is the Name of the specific record type
    */
    public static Id get(String sObjectType, String rtName) {
        Schema.SObjectType objSchema = Schema.getGlobalDescribe().get(sObjectType);
        Id recordTypeId = null;
        if(objSchema != null) {
            Schema.RecordTypeInfo rtInfo = objSchema.getDescribe().getRecordTypeInfosByName().get(rtName);
            if(rtInfo != null) {
                recordTypeId = rtInfo.getRecordTypeId();
            }
        }
        if(recordTypeId == null) {
            Map<String, Id> sObjectRTs = RecordTypeHandler.getSobjectRTs(sObjectType);
            if (sObjectRTs.containsKey(rtName)) {
                return sObjectRTs.get(rtName);
            } else {
                throw new CustomException('The Record type provided doesn\'t exist for this SObject');
            }
        } else {
            return recordTypeId;
        }
    }

    /**
    * Search all the Record types in Database
    */
    private void retrieveRTs(){
        List<RecordType> RTList = [SELECT Id, SobjectType, DeveloperName FROM RecordType];
        for(RecordType rt : RTList) {
            if(!this.recordTypes.containsKey(rt.SobjectType)){
                this.recordTypes.put(rt.SobjectType, new Map<String, String>());
            }
            this.recordTypes.get(rt.SobjectType).put(rt.DeveloperName, rt.Id);
        }
        RecordTypeHandler.instance = this;
    }
}