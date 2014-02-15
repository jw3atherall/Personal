public class AsanaAPIController {

    public asanaUser aUser {get;private set;}
    public List<asanaWorkspace> wSpaces {get; private set;}
    
    public AsanaAPIController()
    {
         request();
    }
    
    public void request()
    {
        String accessToken = null;
        String api_key = '2x03T1B.XRTQshJnjQXB4xAWotGSFPU3';
        Blob auth = Blob.valueOf(api_key + ':');
        
        String uri = 'https://app.asana.com/api/1.0/users/me';
        
        HttpRequest request = new HttpRequest();           
        request = new HttpRequest();
        request.setTimeout(60000);
        request.setHeader('Content-Type','application/json');
        //request.setHeader('api_key', api_key);
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(auth));
        System.debug('Basic = ' + EncodingUtil.base64Encode(auth));
        request.setEndpoint(uri);
        request.setMethod('GET');
        
        System.debug('request = ' + request);
        
        Http http = new Http();
        HttpResponse response = null;
        response = http.send(request);
        
        String jsonString = response.getBody();
        JSONParser parser = JSON.createParser(jsonString);
        
        asanaUser au = new asanaUser();
        asanaWorkspace aw = new asanaWorkspace();
        
        List<asanaWorkspace> workspaces = new List<asanaWorkspace>();
        
        while (parser.nextToken() != null) {
            //if current token is a field name
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                String fieldName = parser.getText();
                System.debug('fieldName: ' + fieldName);
                //move to token after the field name
                parser.nextToken(); 
                if(fieldName == 'data'){
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                        while(parser.nextToken() != JSONToken.END_OBJECT){
                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                                String dataFieldName = parser.getText();
                                parser.nextToken();
                                if(dataFieldName == 'id'){
                                    au.id = parser.getText();
                                }
                                else if(dataFieldName == 'name'){
                                    au.name = parser.getText();
                                }
                                else if(dataFieldName == 'email'){
                                    au.email = parser.getText();
                                }
                                else if(dataFieldName == 'image_60x60'){
                                    au.photo = parser.getText();
                                }
                            }
                        }
                    }
                } 
                else if(fieldName == 'workspaces')
                {
                    if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                        while(parser.nextToken() != null){
                            System.debug('parser.getCurrentToken() ' + parser.getCurrentToken() + ' parser.getText() ' + parser.getText());
                            if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                                asanaWorkspace aWorkspace = (asanaWorkspace)parser.readValueAs(asanaWorkspace.class);
                                workspaces.add(aWorkspace);
                            }
                            else if(parser.getCurrentToken() == JSONToken.END_ARRAY){    
                                break;
                            }
                        }
                    }
                }
            }
        }
        aUser = au;
        wSpaces = workspaces;        
    }
    
    public class asanaUser 
    {
        public String id {get;private set;}
        public String name {get;private set;}        
        public String email {get;private set;}
        public String photo {get;private set;}
    }
    
    public class asanaWorkspace
    {
        public String id {get;private set;}
        public String name {get;private set;}        
    }    
}