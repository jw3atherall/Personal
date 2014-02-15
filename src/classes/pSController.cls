public class pSController {
        private List<jweatherall__Project_Lead__c> projects;
          
        public List<jweatherall__Project_Lead__c> getProjects() { 
                return projects; 
        }

        public pSController() { 
                String q = System.currentPageReference().getParameters().get('q');
                String w = System.currentPageReference().getParameters().get('w');

                String srchString1 = '%' + q + '%'; // add wild cards
                String srchString2 = '%' + w + '%'; // add wild cards

                if (w!= null && q!=null) {
                        projects = [SELECT Id, Name, jweatherall__site_Address_1__c FROM jweatherall__Project_Lead__c where Name like :srchString1 and jweatherall__site_Address_1__c like:srchString2];
                }
        }
}