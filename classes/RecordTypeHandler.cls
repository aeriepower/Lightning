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
	private static RecordTypeHandler instance;
	private Map<String, Map<String, Id>> recordTypes = new Map<String, Map<String, String>>();

	public static  RecordTypeHandler getInstance() {
		RecordTypeHandler.instance = RecordTypeHandler.instance == null ? new RecordTypeHandler() : RecordTypeHandler.instance;
		return RecordTypeHandler.instance;
	}

	private RecordTypeHandler(){

	}

	public static Map<String, Id> getSobjectRTs(String sObjectType) {
		RecordTypeHandler rth = RecordTypeHandler.getInstance();

		if (rth.recordTypes.containsKey(sObjectType)) {
			return rth.recordTypes.get(sObjectType);
		} else {
			rth.retrieveRTs();
			if (rth.recordTypes.containsKey(sObjectType)) {
				return rth.recordTypes.get(sObjectType);
			} else {
				throw Exception('There are not RecordTypes for requested SObject');
			}
		}
	}

	public static Id get(String sObjectType, String sObjectField) {
		Id recordTypeId = Schema.getGlobalDescribe().get(sObjectType).getDescribe().getRecordTypeInfosByName().get(sObjectField).getRecordTypeId();
		if(recordTypeId == null) {
			Map<String, Id> sObjectRTs = RecordTypeHandler.getSobjectRTs(sObjectType);
			if (sObjectRTs.containsKey(sObjectField)) {
				return sObjectRTs.get(sObjectField);
			} else {
				throw Exception('The field doesn\'t exist at this SObject');
			}
		} else {
			return recordTypeId;
		}
	}

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