public class ArrayGridcontroller {

    private String accounts;
    
    public ArrayGridcontroller(){
        List<Account> accountsList = [Select Id, Name, Phone, OwnerId From Account limit 1];
        
        accounts = JSON.serialize(accountsList);
        system.debug('Accounts as JSON ' + accounts);    
    }
    
    public String getAccounts(){
        return accounts;
    }   

}