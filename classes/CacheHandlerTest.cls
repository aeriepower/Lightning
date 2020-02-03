/**
 * Created by David Hurtado Banda
 */
@IsTest
public class CacheHandlerTest {

	@IsTest
	static void test1() {
		CacheHandler.set('test', 'test');
		Test.startTest();
		System.assertEquals(CacheHandler.get('test'), 'test');
		Test.stopTest();

	}
	@IsTest
	static void test2() {
		CacheHandler ch1 = new CacheHandler();
		ch1.put('test','test');

		Test.startTest();
		System.assertEquals(ch1.retrieve('test'), 'test');
		Test.stopTest();
	}
	@IsTest
	static void test3() {
		CacheHandler ch1 = new CacheHandler('local');
		ch1.put('test','test');

		Test.startTest();
		System.assertEquals(ch1.retrieve('test'), 'test');
		Test.stopTest();

	}

	@IsTest
	static void test4() {
		CacheHandler ch1 = new CacheHandler('local','default');
		ch1.put('test','test');

		Test.startTest();
		System.assertEquals(ch1.retrieve('test'), 'test');
		Test.stopTest();
	}

}