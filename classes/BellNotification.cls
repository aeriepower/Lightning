/**
 * Created by david.hurtado.banda on 04/02/2020.
 */

//TODO: Create a Static method to facilitate the way to use.

/**
* Public class to send notifications for users and receive them at the bell notification section.
* It's needed to set up almost one notification at Setup => Notification builder => Custom notifications.
* If the notification must be sent after an dml insert/update operation, it's needed to use method setFuture(true) at the instance.
* Example to use: new BellNotification().setTargetId('8013E000000s3E7QAI').send();
*/
public class BellNotification{

	/**
	* The title of the notification.
	*/
	private String title;

	/**
	* The body of the notification.
	*/
	private String body;

	/**
	* The ID of the custom Notification.
	* It's recommended to host this Id in a Custom Setting.
	* If is not setted, the class will try to retrieve it calling the services/data/tooling.
	*/
	private String customNotifTypeId;

	/**
	* The list of users that will receive the notification.
	*/
	private List<String> recipientIds;

	/**
	* The related record that the notification will be related about.
	*/
	private String targetId;

	/**
	* OPTIONAL.
	* The id of the User who sends the notification.
	*/
	private String senderId;

	/**
	* Boolean that will decide if the send method is executed asynchronously.
	*/
	private Boolean isFuture;

	/**
	* Boolean to set if the notification was correctly delivered.
	*/
	private Boolean isSuccess;

	/**
	* In case we cannot deliver the notification will host the error message in this variable.
	*/
	private List<String> errorMsgList;

	/**
	* The endpoint.
	*/
	public static final String ENDPOINT = Url.getOrgDomainUrl().toExternalForm() + '/services/data/v46.0/actions/standard/customNotificationAction';

	/**
	* The "call to action". It can be executed in the process or asynchronously.
	*/
	public BellNotification send(){
		if(allParamsAreSet()){
			if(this.isFuture){
				callWSFutured(this.title, this.body, this.customNotifTypeId, this.recipientIds, this.targetId);
			} else {
				return this.callWS();
			}
		}
		return this;
	}

	/**
	* Creates a new instance in a separated process and call the WS.
	*/
	@Future(callout=true)
	private static void callWSFutured(String title, String body, String customNotifTypeId, List<String> recipientIds,  String targetId){
		new BellNotification()
			.setRecipientIds(recipientIds)
			.setTitle(title)
			.setBody(body)
			.setCustomNotifTypeId(customNotifTypeId)
			.setTargetId(targetId)
			.send();
	}

	/**
	* Creates a new instance in a separated process and call the WS.
	*/
	private BellNotification callWS(){
		CustomNotificationActionInput input = new CustomNotificationActionInput( this.title, this.body, this.customNotifTypeId,this.recipientIds, this.targetId, this.senderId);
		CustomNotificationAction action = new CustomNotificationAction(new List<CustomNotificationActionInput>{input});

		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint(ENDPOINT);
		request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
		request.setHeader('Content-Type', 'application/json');
		request.setBody(JSON.serialize(action));
		HttpResponse response =  new Http().send(request);
		List<NotificationServiceResponse> NotificationResponseList = (List<NotificationServiceResponse>) JSON.deserialize(response.getBody(), List<NotificationServiceResponse>.class);
		if(NotificationResponseList != null && NotificationResponseList.size() == 1){
			NotificationServiceResponse NotificationResponse = NotificationResponseList[0];
			if(NotificationResponse.isSuccess){
				this.setIsSuccess(true);
			} else {
				for(NotificationServiceError error : NotificationResponse.errors){
					this.setErrorMsg(error.statusCode + ' - ' + error.message);
					System.debug(error.statusCode + ' - ' + error.message);
				}
			}
		}
		return this;
	}



	/**
	* Checking method to ensure all params are setted up before calling out.
	* It can auto-fill some empty params if are null but not all.
	* Returns a boolean which proves that the call can be invoked or not.
	*/
	private boolean allParamsAreSet(){
		Boolean allSetted = true;
		if(this.customNotifTypeId == null){
			Id customNotifTypeId = this.getNotificationId();
			if(customNotifTypeId != null){
				this.setCustomNotifTypeId(customNotifTypeId);
			} else {
				this.setIsSuccess(false);
				this.setErrorMsg('There was not possible to get an Custom Notification Id');
				allSetted = false;
			}
		}

		if(this.recipientIds == null){
			this.setRecipientIds(new List<String>{UserInfo.getUserId()});
		}

		if(this.title == null){
			this.setTitle('Title');
		}

		if(this.body == null){
			this.setBody('Body');
		}

		if(this.targetId == null){
			this.setIsSuccess(false);
			this.setErrorMsg('You must specify an Target Id (sObject)');
			allSetted = false;
		}

		if(this.isFuture == null){
			this.setFuture(false);
		}
		return allSetted;
	}

	/**
	* Setter for customNotifTypeId.
	* Returns the instance for a dynamic coding.
	*/
	private Id getNotificationId() {
		Id notificationId;
		String endpoint = Url.getOrgDomainUrl().toExternalForm()
				+ '/services/data/v45.0/tooling/query/?q=SELECT+id,CustomNotifTypeName+from+CustomNotificationType';
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
		request.setEndpoint(endpoint);
		request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
		request.setHeader('Content-Type', 'application/json');
		HttpResponse response =  new Http().send(request);
		if(response.getStatusCode() == 200){
			ServiceData serviceData = (ServiceData) JSON.deserialize(response.getBody(), ServiceData.class);
			if(serviceData.totalSize > 0){
				notificationId = serviceData.records[0].Id;
			}
		}
		return notificationId;
	}

	/**
	* Setter for customNotifTypeId.
	* Returns the instance for a dynamic coding.
	*/
	public BellNotification setCustomNotifTypeId(String customNotifTypeId) {
		this.customNotifTypeId = customNotifTypeId;
		return this;
	}

	/**
	* Setter for recipientIds.
	* Returns the instance for a dynamic coding.
	*/
	public BellNotification setRecipientIds(List<String> recipientIds) {
		this.recipientIds = recipientIds;
		return this;
	}

	/**
	* Setter for title.
	* Returns the instance for a dynamic coding.
	*/
	public BellNotification setTitle(String title) {
		this.title = title;
		return this;
	}

	/**
	* Setter for body.
	* Returns the instance for a dynamic coding.
	*/
	public BellNotification setBody(String body) {
		this.body = body;
		return this;
	}

	/**
	* Setter for targetId.
	* Returns the instance for a dynamic coding.
	*/
	public BellNotification setTargetId(String targetId) {
		this.targetId = targetId;
		return this;
	}

	/**
	* Setter for targetId.
	* Returns the instance for a dynamic coding.
	*/
	public BellNotification setSenderId(String senderId) {
		this.senderId = senderId;
		return this;
	}

	/**
	* Setter for future.
	* Returns the instance for a dynamic coding.
	*/
	public BellNotification setFuture(Boolean isFuture) {
		this.isFuture = isFuture;
		return this;
	}

	/**
	* Setter for isSuccess.
	*/
	public void setIsSuccess(Boolean isSuccess) {
		this.isSuccess = isSuccess;
	}

	/**
	* Setter for errorMsg.
	*/
	public void setErrorMsg(String errorMsg) {
		if(this.getErrorMsg() == null){
			errorMsgList = new List<String>{errorMsg};
		} else {
			errorMsgList.add(errorMsg);
		}
	}

	/**
	* Getter for isSuccess.
	*/
	public Boolean getIsSuccess() {
		return isSuccess;
	}

	/**
	* Getter for errorMsg.
	*/
	public List<String> getErrorMsg() {
		return errorMsgList;
	}

	/**
	* Containing subclass to build a JSON for to send.
	*/
	public class CustomNotificationAction{
		public List<CustomNotificationActionInput> inputs {get; set;}
		public CustomNotificationAction(List<CustomNotificationActionInput> inputs){
			this.inputs = inputs;
		}
	}

	/**
	* Containing subclass to build a JSON for to send.
	*/
	public class CustomNotificationActionInput{
		public String title { get; set; }
		public String body { get; set; }
		public String customNotifTypeId { get; set; }
		public List<String> recipientIds { get; set; }
		public String targetId { get; set; }
		public String senderId { get; set; }

		public CustomNotificationActionInput(String title, String body, String customNotifTypeId, List<String> recipientIds, String targetId, String senderId){
			this.title = title;
			this.body = body;
			this.customNotifTypeId = customNotifTypeId;
			this.recipientIds = recipientIds;
			this.targetId = targetId;
			this.senderId = senderId;
		}
	}

	public class ServiceData{
		public Integer size { get; set; }
		public Integer totalSize { get; set; }
		public Boolean done { get; set; }
		public String queryLocator { get; set; }
		public String entityTypeName { get; set; }
		public List<ServiceDataRecords> records { get; set; }
	}

	public class ServiceDataRecords{
		public String Id { get; set; }
		public String CustomNotifTypeName { get; set; }
	}

	public class NotificationServiceResponse{
		public List<NotificationServiceError> errors { get; set; }
		public Boolean isSuccess { get; set; }
	}

	public class NotificationServiceError{
		public String statusCode { get; set; }
		public String message { get; set; }
	}

}