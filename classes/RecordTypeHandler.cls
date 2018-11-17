/**
 * Created by david.hurtado.banda on 17/11/2018.
 */
public class RecordTypeHandler {
	private static RecordTypeHandler instance;
	private Map<String, Map<String, String>> recordTypes = new Map<String, Map<String, String>>();

	public static  RecordTypeHandler getInstance() {
		RecordTypeHandler.instance = RecordTypeHandler.instance == null ? new RecordTypeHandler() : RecordTypeHandler.instance;
		return RecordTypeHandler.instance;
	}

	public static Map<String, String> getSobjectRTs(String sObjectType) {
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
	
	public static String get(String sObjectType, String sObjectField) {
		Map<String, String> sObjectRTs = RecordTypeHandler.getSobjectRTs(sObjectType);
		if (sObjectRTs.containsKey(sObjectField)) {
			return sObjectRTs.get(sObjectField);
		} else {
			throw new CustomException('The field doesn\'t exist at this SObject');
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