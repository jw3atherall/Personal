public class projectSearchController2 {
  private List<jweatherall__Project_Lead__c> projects;
  public List<jweatherall__Project_Lead__c> getProjects() 
  { 
        return projects; 
  }

  public projectSearchController2() { 
    String q = System.currentPageReference().getParameters().get('q');
        String w = System.currentPageReference().getParameters().get('w');

        String srchString1 = '%' + q + '%'; // add wild cards
        String srchString2 = '%' + w + '%'; // add wild cards

    if (q!= null) {
            projects = [SELECT Id, Name, jweatherall__site_Address_1__c FROM jweatherall__Project_Lead__c where Name like:srchString1 ];
    }

    if (w!= null) {
      String srchString = '%' + w + '%'; // add wild cards
      projects = [SELECT Id, Name, jweatherall__site_Address_1__c FROM jweatherall__Project_Lead__c where Name like:srchString2 ];
    }


     if (w!= null && q!=null) {
         projects = [SELECT Id, Name, jweatherall__site_Address_1__c FROM jweatherall__Project_Lead__c where Name like:srchString1 and jweatherall__site_Address_1__c like:srchString2];
        }

  }

}