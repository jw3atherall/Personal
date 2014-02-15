public class leadDupePreventerTests{
static testMethod void testLeadDupPreventer() {
// First make sure there are no leads already in the system
// that have the email addresses used for testing
	Set<String> testEmailAddress = new Set<String>();
	testEmailAddress.add('test1@duptest.com');
	testEmailAddress.add('test2@duptest.com');
	testEmailAddress.add('test3@duptest.com');
	testEmailAddress.add('test4@duptest.com');
	testEmailAddress.add('test5@duptest.com');
	System.assert([SELECT count() FROM Lead WHERE Email IN :testEmailAddress] == 0);
// Seed the database with some leads, and make sure they can
// be bulk inserted successfully.
	Lead lead1 = new Lead(LastName='Test1', Company='Test1 Inc.', Email='test1@duptest.com');
	Lead lead2 = new Lead(LastName='Test2', Company='Test2 Inc.', Email='test4@duptest.com');
	Lead lead3 = new Lead(LastName='Test3', Company='Test3 Inc.', Email='test5@duptest.com');
	Lead[] leads = new Lead[] {lead1, lead2, lead3};
	insert leads;
// Now make sure that some of these leads can be changed and
// then bulk updated successfully. Note that lead1 is not
// being changed, but is still being passed to the update
// call. This should be OK.
	lead2.Email = 'test2@duptest.com';
	lead3.Email = 'test3@duptest.com';
	update leads;
// Make sure that single row lead duplication prevention works
// on insert.
Lead dup1 = new Lead(LastName='Test1Dup', Company='Test1Dup Inc.', Email='test1@duptest.com');
try {
	insert dup1;
	System.assert(false);
} catch (System.DmlException e) {
	System.assert(e.getNumDml() == 1);
	System.assert(e.getDmlIndex(0) == 0);
	System.assert(e.getDmlFields(0).size() == 1);
	System.assert(e.getDmlFields(0)[0] == 'Email');
	System.assert(e.getDmlMessage(0).indexOf('A lead with this email address already exists.') > -1);
  }
// Make sure that single row lead duplication prevention works
// on update.
	dup1 = new Lead(Id = lead1.Id, LastName='Test1Dup',	Company='Test1Dup Inc.', Email='test2@duptest.com');
try {
	update dup1;
	System.assert(false);
} catch (System.DmlException e) {
	System.assert(e.getNumDml() == 1);
	System.assert(e.getDmlIndex(0) == 0);
	System.assert(e.getDmlFields(0).size() == 1);
	System.assert(e.getDmlFields(0)[0] == 'Email');
	System.assert(e.getDmlMessage(0).indexOf('A lead with this email address already exists.') > -1);
  }
// Make sure that bulk lead duplication prevention works on
// insert. Note that the first item being inserted is fine,
// but the second and third items are duplicates. Note also
// that since at least one record insert fails, the entire
// transaction will be rolled back.
	dup1 = new Lead(LastName='Test1Dup', Company='Test1Dup Inc.', Email='test4@duptest.com');
	Lead dup2 = new Lead(LastName='Test2Dup', Company='Test2Dup Inc.', Email='test2@duptest.com');
	Lead dup3 = new Lead(LastName='Test3Dup', Company='Test3Dup Inc.', Email='test3@duptest.com');
	Lead[] dups = new Lead[] {dup1, dup2, dup3};
try {
	insert dups;
	System.assert(false);
} catch (System.DmlException e) {
	System.assert(e.getNumDml() == 2);
	System.assert(e.getDmlIndex(0) == 1);
	System.assert(e.getDmlFields(0).size() == 1);
	System.assert(e.getDmlFields(0)[0] == 'Email');
	System.assert(e.getDmlMessage(0).indexOf('A lead with this email address already exists.') > -1);
	System.assert(e.getDmlIndex(1) == 2);
	System.assert(e.getDmlFields(1).size() == 1);
	System.assert(e.getDmlFields(1)[0] == 'Email');
	System.assert(e.getDmlMessage(1).indexOf('A lead with this email address already exists.') > -1);
  }
// Make sure that bulk lead duplication prevention works on
// update. Note that the first item being updated is fine,
// because the email address is new, and the second item is
// also fine, but in this case it's because the email
// address doesn't change. The third case is flagged as an
// error because it is a duplicate of the email address of the
// first lead's value in the database, even though that value
// is changing in this same update call. It would be an
// interesting exercise to rewrite the trigger to allow this
// case. Note also that since at least one record update
// fails, the entire transaction will be rolled back.
	dup1 = new Lead(Id=lead1.Id, Email='test4@duptest.com');
	dup2 = new Lead(Id=lead2.Id, Email='test2@duptest.com');
	dup3 = new Lead(Id=lead3.Id, Email='test1@duptest.com');
	dups = new Lead[] {dup1, dup2, dup3};
try {
	update dups;
	System.assert(false);
} catch (System.DmlException e) {
	System.debug(e.getNumDml());
	System.debug(e.getDmlMessage(0));
	System.assert(e.getNumDml() == 1);
	System.assert(e.getDmlIndex(0) == 2);
	System.assert(e.getDmlFields(0).size() == 1);
	System.assert(e.getDmlFields(0)[0] == 'Email');
	System.assert(e.getDmlMessage(0).indexOf('A lead with this email address already exists.') > -1);
  }
// Make sure that duplicates in the submission are caught when
// inserting leads. Note that this test also catches an
// attempt to insert a lead where there is an existing
// duplicate.
	dup1 = new Lead(LastName='Test1Dup', Company='Test1Dup Inc.', Email='test4@duptest.com');
	dup2 = new Lead(LastName='Test2Dup', Company='Test2Dup Inc.', Email='test4@duptest.com');
	dup3 = new Lead(LastName='Test3Dup', Company='Test3Dup Inc.', Email='test3@duptest.com');
	dups = new Lead[] {dup1, dup2, dup3};
try {
	insert dups;
	System.assert(false);
} catch (System.DmlException e) {
	System.assert(e.getNumDml() == 2);
	System.assert(e.getDmlIndex(0) == 1);
	System.assert(e.getDmlFields(0).size() == 1);
	System.assert(e.getDmlFields(0)[0] == 'Email');
	System.assert(e.getDmlMessage(0).indexOf('Another new lead has the same email address.') > -1);
	System.assert(e.getDmlIndex(1) == 2);
	System.assert(e.getDmlFields(1).size() == 1);
	System.assert(e.getDmlFields(1)[0] == 'Email');
	System.assert(e.getDmlMessage(1).indexOf('A lead with this email address already exists.') > -1);
  }
// Make sure that duplicates in the submission are caught when
// updating leads. Note that this test also catches an attempt
// to update a lead where there is an existing duplicate.
	dup1 = new Lead(Id=lead1.Id, Email='test4@duptest.com');
	dup2 = new Lead(Id=lead2.Id, Email='test4@duptest.com');
	dup3 = new Lead(Id=lead3.Id, Email='test2@duptest.com');
	dups = new Lead[] {dup1, dup2, dup3};
try {
	update dups;
	System.assert(false);
} catch (System.DmlException e) {
	System.assert(e.getNumDml() == 2);
	System.assert(e.getDmlIndex(0) == 1);
	System.assert(e.getDmlFields(0).size() == 1);
	System.assert(e.getDmlFields(0)[0] == 'Email');
	System.assert(e.getDmlMessage(0).indexOf('Another new lead has the same email address.') > -1);
	System.assert(e.getDmlIndex(1) == 2);
	System.assert(e.getDmlFields(1).size() == 1);
	System.assert(e.getDmlFields(1)[0] == 'Email');
	System.assert(e.getDmlMessage(1).indexOf('A lead with this email address already exists.') > -1);
  }
}
}