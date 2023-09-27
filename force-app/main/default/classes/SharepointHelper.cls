public class SharepointHelper {
 
    public static String normalize(String title){
	title = title.replace('"','').replace(';','').replace(':','').replace('*','').replace('<','').replace('>','').replace('?','').replace('/','-').replace('\\','-').replace('|','-');

	if(title.endsWith('.')){
	    title = title.left(title.length()-1);
	}

	return title;
    }

    // Returns ready-to-use batch request for qkom365.GraphUtils.send(req, endpoint);
    public static HttpRequest getTemplateRequest(String driveId, String itemId, String name){
        HttpRequest r = new HttpRequest();
        r.setMethod('POST');
        r.setBody('{ "parentReference": { "driveId": "'+ driveId +'", "id": "'+ itemId +'" }, "name": "'+ name +'" }');

        return r;
    }
    public static HttpRequest getTemplateRequest1(){
        HttpRequest r = new HttpRequest();
        r.setMethod('POST');
      String requestBody = '{' +
        '"subject": "Let\'s go for walk with ak",' +
        '"body": {' +
            '"contentType": "HTML",' +
            '"content": "Does mid month work for you?"' +
        '},' +
        '"start": {' +
            '"dateTime": "2023-09-13T12:00:00",' +
            '"timeZone": "America/Los_Angeles"' +
        '},' +
        '"end": {' +
            '"dateTime": "2023-09-13T14:00:00",' +
            '"timeZone": "America/Los_Angeles"' +
        '},' +
        '"location": {' +
            '"displayName": "Harry\'s Bar"' +
        '},' +
        '"attendees": [' +
            '{' +
                '"emailAddress": {' +
                    '"address": "rajldcadcs@gmail.com",' +
                    '"name": "Adele Vance"' +
                '},' +
                '"type": "required"' +
            '}' +
        '],' +
        '"isOnlineMeeting": true,'+
  '"onlineMeetingProvider": "teamsForBusiness"'+
    '}';
        r.setBody(requestBody);

        return r;
    }
    

    // Returns the job id from an HttpResponse object after copying an item
    public static String getCopiedItemJob(HttpResponse res){
      
        
        system.debug('responseddd'+res);
	if(res.getStatusCode() != 202){
        system.debug('getres'+res);
	    throw new EException('Copy failed. Exiting');
	}

	for(String k : res.getHeaderKeys()){
	    System.debug(k + ' : ' + res.getHeader(k));
	    if(k == 'Location'){
		return res.getHeader(k);
	    }
	}
	return null;
    }

    // Returns a ready to use Http request for checking operation status
    public static HttpRequest getJobStatusRequest(String job){
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(job);

        return req;
    }

    // Retrieves job url from location header in response
    public static String getIdFromJobStatusResponse(HttpResponse res){
        if(res.getStatusCode() != 200){
            throw new EException('Error checking operation status. Exiting');
        }

        for(String h : res.getHeaderKeys()){
            System.debug(h + ' : ' + res.getHeader(h));
        }

        Map<String, Object> operation = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        if(String.valueOf(operation.get('status')) == 'completed'){
            return String.valueOf(operation.get('resourceId'));
        }
        else{
            return null;
        }
    }

    // Creates qkom365__O365_Metadata__c link document
    public static void createLink(String salesforceId, String name, String DOCUMENT_LIBRARY, String sharepointId, String webUrl, String linkType, String parentName, String comment, String sharingUrl){
        qkom365__O365_Metadata__c l = new qkom365__O365_Metadata__c(
            qkom365__Comment__c = comment,
            qkom365__Document_Name__c = name,
            qkom365__O365_WebUrl__c = webUrl,
            qkom365__O365Id__c = sharepointId,
            qkom365__O365DriveId__c = DOCUMENT_LIBRARY,
            qkom365__O365SiteId__c = DOCUMENT_LIBRARY,
            qkom365__O365ParentId__c = DOCUMENT_LIBRARY,
            qkom365__O365ParentName__c = parentName,
            qkom365__O365Type__c = linkType,
            qkom365__RelatedToId__c = salesforceId);
        
        
    system.debug('testingdean'+l);
        try{
            insert(l);
           
            
        }
        catch(DmlException e){
            throw new EException('An exception has occurred: ' + e.getMessage());
        }
    }

    public static void sleep(Integer delay){
        Long start = DateTime.now().getTime();
        Long stop = DateTime.now().getTime();

        while ((stop - start) < delay) {
            stop = DateTime.now().getTime();
        }
    }

    // Exception interface
    public class EException extends Exception {}
}