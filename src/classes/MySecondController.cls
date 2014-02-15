Public class MySecondController {
    public PageReference convert() {
      return null;
    }


    public PageReference save() {
      return null;
    }


        public Account getAccount() {
                return [select id, name, (select id, firstname, lastname from Contacts limit 5) from Account where id = :System.currentPageReference().getParameters().get('id')];
        }
        
        public string getName() {
                return 'My Second Custom Controller';
        }
}