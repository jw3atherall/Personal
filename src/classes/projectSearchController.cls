public class projectSearchController {
        public String Name;
        public String Site_Address_1;
        public List<jweatherall__Project_Lead__c> projects;

        public projectSearchController() {
                projects = [SELECT Id, Name, jweatherall__site_Address_1__c FROM jweatherall__Project_Lead__c];
        }

        public String getName() {
                return this.Name;
        }

        public void setName(String Name) {
                this.Name = Name;
        }

        public String getSite_Address_1() {
                return this.Site_Address_1;
        }

        public void setSite_Address_1(String Site_Address_1) {
                this.Site_Address_1 = Site_Address_1;
        }

        public List<jweatherall__Project_Lead__c> getProjects() { 
                return projects; 
        }
        
        public PageReference ProjectSearch() {
                //String name = System.currentPageReference().getParameters().get('name');
                //String address = System.currentPageReference().getParameters().get('address');
                Name = this.name;
                Site_Address_1 = this.site_address_1;
                Name = '%' + name  + '%';
                Site_Address_1 = '%' + Site_Address_1  + '%';
                projects = [SELECT Id, Name, jweatherall__site_Address_1__c FROM jweatherall__Project_Lead__c where Name like:Name and jweatherall__site_Address_1__c like:Site_Address_1];
                return null;
        }
}