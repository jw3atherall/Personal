/*
* This class is the controller behind the New Customer Opportunity
* wizard. The new wizard is comprised of three pages, each of
* which utilizes the same instance of this controller.
*/

public class newOpportunityController {
        // These four class variables maintain the state of the wizard.
        // When users enter data into the wizard, their input is stored
        // in these variables.

        Account account;
        Contact contact;
        Opportunity opportunity;
        OpportunityContactRole role;

        // The next four methods return one of each of the four class
        // variables. If this is the first time the method is called,
        // it creates an empty record for the variable.

        public Account getAccount() {
                if(account == null) account = new Account();
                return account;
        }

        public Contact getContact() {
                if(contact == null) contact = new Contact();
                return contact;
        }

        public Opportunity getOpportunity() {
                if(opportunity == null) opportunity = new Opportunity();
                return opportunity;
        }

        public OpportunityContactRole getRole() {
                if(role == null) role = new OpportunityContactRole();
                return role;
        }

        // The next three methods are used to control navigation through
        // the wizard. Each returns a reference to one of the three pages
        // in the wizard.

        public PageReference step1() {
                return Page.OpptyStep1;
        }

        public PageReference step2() {
                return Page.OpptyStep2;
        }

        public PageReference step3() {
                return Page.OpptyStep3;
        }

        // This method performs the final save for all four objects, and
        // then navigates the user to the detail page for the new
        // opportunity.

        public PageReference save() {
        // Create the account. Before inserting, copy the contact's
        // phone number into the account phone number field.

                account.phone = contact.phone;  
                insert account;
        
        // Create the contact. Before inserting, use the id field
        // that's created once the account is inserted to create
        // the relationship between the contact and the account.

                contact.accountId = account.id;
                insert contact;

        // Create the opportunity. Before inserting, create
        // another relationship with the account.

                opportunity.accountId = account.id;             
                insert opportunity;

        // Create the junction contact role between the opportunity
        // and the contact.

                role.opportunityId = opportunity.id;    
                role.contactId = contact.id;
                insert role;

        // Finally, send the user to the detail page for        
        // the new opportunity.
        // Note that using '/' in the new PageReference object keeps
        // the user in the current instance of salesforce, rather than
        // redirecting him or her elsewhere.

                PageReference opptyPage = new PageReference('/' + opportunity.id);      
                opptyPage.setRedirect(true);

                return opptyPage;
        }
}