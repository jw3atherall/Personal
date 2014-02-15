public class FollowUpTaskHelper {
// Static variables are local to the context of a Web request
// (or testMethod during a runTests call)
// Therefore, this variable will be initialized as false
// at the beginning of each Web request which accesses it.
	private static boolean alreadyCreatedTasks = false;
	public static boolean hasAlreadyCreatedFollowUpTasks() {
	return alreadyCreatedTasks;
	}
// By setting the variable to true, it maintains this
// new value throughout the duration of the request
// (or testMethod)
	public static void setAlreadyCreatedFollowUpTasks() {
	alreadyCreatedTasks = true;
	}
	public static String getFollowUpSubject(String subject) {
	return 'Follow Up: ' + subject;
	}
}