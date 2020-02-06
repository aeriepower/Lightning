/**
 * Created by david.hurtado.banda on 05/02/2020.
 */

@IsTest
public class BellNotificationTest {

	@IsTest
	static void asynchronousNotification() {

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('WSServiceToolResponse');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		Test.setMock(HttpCalloutMock.class, new BellNotificationTest.WSServiceToolResponse());
		BellNotification bell = new BellNotification()
			.setFuture(true)
			.setTargetId('8013E000000s3E7QAI')
			.send();

		Test.stopTest();
	}

	public class WSServiceToolResponse implements HttpCalloutMock{

		/**
		* @param The HttpRequest.
		* @return Fake HttpResponse.
		*/
		public HTTPResponse respond(HTTPRequest request) {
			// Create a fake response
			HttpResponse response = new HttpResponse();
			response.setHeader('Content-Type', 'application/json');
			String body = '{"size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"CustomNotificationType","records":[{"attributes":{"type":"CustomNotificationType","url":"/services/data/v45.0/tooling/sobjects/CustomNotificationType/0ML3E0000008PL0WAM"},"Id":"0ML3E0000008PL0WAM","CustomNotifTypeName":"Test"}]}';
			response.setBody(body);
			response.setStatusCode(200);
			return response;

		}
	}
}