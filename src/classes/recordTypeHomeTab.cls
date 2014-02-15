public class recordTypeHomeTab {
static string rid = 'Supplier'; // change to match the record type for the tab
boolean which = true; // which list are we showing, simple toggle

public Account[] getAccounts() {
if (!which) {
return [select id,name,lastmodifieddate,billingcity,billingstate,phone,type,recordType.name from
Account where recordType.name = :rid order by createddate desc];
}
return [select id,name,lastmodifieddate,billingcity,billingstate,phone,type,recordType.name from
Account where recordType.name = :rid order by lastmodifieddate ];
}

public PageReference changeRt() { // toggle a static var to flip between recent modified or created items
which = ( ! which) ;
return null;
}

public PageReference newRt() { // construct a new record with this record type already set
RecordType r = [select id from RecordType where Name = :rid];
PageReference p = new PageReference('/001/e?RecordType=' + r.id +
'&retURL='+ getBasePageName() );
p.setRedirect(true);
return p;
}


public string getBasePageName() {
PageReference cur = System.CurrentPageReference();
String url = cur.getUrl();
String [] basearray = url.split('\\?');
return basearray[0];
}
public String getUrl() {
return getBasePageName();
}

public static testMethod void testMyControler() {
RecordTypeHomeTab t = new RecordTypeHomeTab();
Account[] a = t.getAccounts();
t.changeRt();
t.getAccounts();
//System.Assert( t.getReportsArea() != '' );
//System.Assert( t.getToolsArea() != '' );
System.Assert( t.newRt() != null);
Boolean beforet = t.which;
t.changeRt();
System.Assert( beforet != t.which);
System.assert( t.getUrl() != '' );
}
}