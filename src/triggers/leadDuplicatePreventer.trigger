trigger leadDuplicatePreventer on Lead (before insert, before update) {
	Map<String, Lead> leadMap = new Map<String, Lead>();
	for (Lead lead : System.Trigger.new) {
	// Make sure we don't treat an email address that
	// isn't changing during an update as a duplicate.
	if ((lead.Phone != null) &&
		(System.Trigger.isInsert || (lead.Phone != System.Trigger.oldMap.get(lead.Id).Phone))) {
	// Make sure another new lead isn't also a duplicate
	if (leadMap.containsKey(lead.Phone)) {
		lead.Phone.addError('Another new lead has the same Phone number.');
	} 
	else {
		leadMap.put(lead.Phone, lead);
	}
	}
	}
	// Using a single database query, find all the leads in
	// the database that have the same email address as any
	// of the leads being inserted or updated.
		for (Lead lead : [SELECT Phone FROM Lead WHERE Phone IN :leadMap.KeySet()]) {
			Lead newLead = leadMap.get(lead.Phone);
			newLead.Phone.addError('A lead with this Phone number already exists.');
		}
	}