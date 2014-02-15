// This class includes the test methods for the
// AutoCreateFollowUpTasks trigger.
public class FollowUpTaskTester {
	private static integer NUMBER_TO_CREATE = 4;
	private static String UNIQUE_SUBJECT = 'Testing follow-up tasks';
	static testMethod void testCreateFollowUpTasks() {
		List<Task> tasksToCreate = new List<Task>();
		for (Integer i = 0; i < NUMBER_TO_CREATE; i++) {
			Task newTask = new Task(subject = UNIQUE_SUBJECT, ActivityDate = System.today(), Create_Follow_Up_Task__c = true );
			System.assert(newTask.Create_Follow_Up_Task__c);
			tasksToCreate.add(newTask);
		}
		insert tasksToCreate;
		System.assertEquals(NUMBER_TO_CREATE, [select count() from Task 
		where subject = :UNIQUE_SUBJECT	and ActivityDate = :System.today()]);
		// Make sure there are follow-up tasks created
		System.assertEquals(NUMBER_TO_CREATE, [select count() from Task 
		where subject = :FollowUpTaskHelper.getFollowUpSubject(UNIQUE_SUBJECT) and ActivityDate = :System.today()+1]);
	}

	static testMethod void assertNormalTasksArentFollowedUp() {
		List<Task> tasksToCreate = new List<Task>();
		for (integer i = 0; i < NUMBER_TO_CREATE; i++) {
			Task newTask = new Task(subject = UNIQUE_SUBJECT, ActivityDate = System.today(), Create_Follow_Up_Task__c = false);
			tasksToCreate.add(newTask);
		}
		insert tasksToCreate;
		System.assertEquals(NUMBER_TO_CREATE, [select count() from Task	
		where subject=:UNIQUE_SUBJECT and ActivityDate =:System.today()]);
		// There should be no follow-up tasks created
		System.assertEquals(0, [select count() from Task 
		where subject=:FollowUpTaskHelper.getFollowUpSubject(UNIQUE_SUBJECT) and ActivityDate =:(System.today() +1)]);
	}
}