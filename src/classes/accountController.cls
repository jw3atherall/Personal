public class accountController {
// Return a list of the ten most recently modified contacts
        public List<Account> getAccounts() {
                return [SELECT Id, Name FROM Account LIMIT 10];
        }

        public Account getAccount() {

                Id id = System.currentPageReference().getParameters().get('id');
                return id == null ? new Account() : [SELECT Id, Name FROM Account WHERE Id = :id];
        }
}