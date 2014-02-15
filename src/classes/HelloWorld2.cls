global class HelloWorld2 {
	// The WebService keyword makes this a public
	// WebService method. WebService methods must
	// always be static, and must also be contained
	// in a global class.
	WebService static String sayHelloWorld(String arg) {
		return 'Hello ' + arg;
	}
	// The following is a simple unit test for the
	// sayHelloWorld method. Unit test methods take
	// no arguments, commit no data to the database,
	// and are flagged with the testMethod keyword
	// in the definition.
	static testMethod void testHelloWorld() {
		System.assertEquals('Hello to you!', sayHelloWorld('there!'));
	}
}