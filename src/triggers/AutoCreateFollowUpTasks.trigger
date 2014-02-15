trigger AutoCreateFollowUpTasks on Task (before insert) {
// Before cloning and inserting the follow-up tasks,
// make sure the current trigger context isn't operating
// on a set of cloned follow-up tasks.
	if (!FollowUpTaskHelper.hasAlreadyCreatedFollowUpTasks()) {
		List<Task> followUpTasks = new List<Task>();
		for (Task t : Trigger.new) {
			if (t.Create_Follow_Up_Task__c) {
				// False indicates that the ID should NOT
				// be preserved
				Task followUpTask = t.clone(false);
				System.assertEquals(null, followUpTask.id);
				followUpTask.subject = 'Follow Up: ' + followUpTask.subject;
				if (followUpTask.ActivityDate != null) {
					followUpTask.ActivityDate =	followUpTask.ActivityDate + 1; //The day after
				}
				followUpTask.Status = 'In Progress';
				followUpTasks.add(followUpTask);
			}
		}
		FollowUpTaskHelper.setAlreadyCreatedFollowUpTasks();
		insert followUpTasks;
	}
}