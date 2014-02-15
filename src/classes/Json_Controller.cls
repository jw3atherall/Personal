public class Json_Controller {

    public String json { get; set; }
    
    public Json_Controller() {
        opportunity[] opps = new opportunity[]{};
        integer start = 0;
        integer pageSize = 10;
        
        if (ApexPages.currentPage().getParameters().get('start') != null && ApexPages.currentPage().getParameters().get('limit') != null) {
            start = integer.valueof(ApexPages.currentPage().getParameters().get('start'));
            pageSize = integer.valueof(ApexPages.currentPage().getParameters().get('limit'));
        }
        
        string jsonRecordsString = '';
        
        integer i = 1;
        integer j = 0;
        
        for (Opportunity o : [Select id, name, stagename, closedate from opportunity order by name limit 1000]) {
            if (j >= start) {
                if (i <= pageSize) {
                    jsonRecordsString += '{';
                    jsonRecordsString += '"id":' + '"'+o.id+'",';
                    jsonRecordsString += '"name":' + '"'+o.name+'",';
                    jsonRecordsString += '"stagename":' + '"'+o.stagename+'",';
                    jsonRecordsString += '"closedate":' + '"'+o.closedate+'"';
                    jsonRecordsString += '},';
                    i++;
                }
            }
            opps.add(o);
            j++;
        }
               
        string jsonString = '({"total":"'+opps.size()+'", "results":[' + jsonRecordsString + ']})';
        jsonString = jsonString.replaceAll(',]',']');
        this.json = jsonString;
    }
}