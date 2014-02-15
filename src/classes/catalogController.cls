public class catalogController {
    List<Widget__c> widgets;

    public List<Widget__c> getWidgets() {
            if(widgets == null) widgets = [select name, description__c, price__c from widget__c];
            return widgets;
    }
    
    testmethod static void testGetWidgets() {
       CatalogController cc = new CatalogController();
       List<Widget__c> l = cc.getWidgets();
       System.assert( l != null );
    }

}