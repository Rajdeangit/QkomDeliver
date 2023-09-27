public class EventUtilities {
 public static HttpRequest getTemplateRequest1(string sub,DateTime start,DateTime enddate,string location,string email){
        HttpRequest r = new HttpRequest();
        r.setMethod('POST');
     system.debug('get the date '+start.format()+' '+enddate.format());
      String requestBody = '{' +
        '"subject":"' + sub + '",' +
        '"body": {' +
            '"contentType": "HTML",' +
            '"content": "Does mid-month work for you?"' +
        '},' +
   /*  '"start": {'+
     '"dateTime": "2023-09-12T12:00:00",'+
      '"timeZone": "Pacific Standard Time"'+
 '},'+
  '"end": {'+
      '"dateTime": "2023-09-12T14:00:00",'+
      '"timeZone": "Pacific Standard Time"'+
  '},' + */
          
         '"start": {'+
     '"dateTime": "'+start.format()+'",'+
      '"timeZone": "Pacific Standard Time"'+
 '},'+
  '"end": {'+
      '"dateTime": "'+enddate.format()+'",'+
      '"timeZone": "Pacific Standard Time"'+
  '},' +
        '"location": {' +
            '"displayName":"' + location + '"' +
        '},' +
        '"attendees": [' +
            '{' +
                '"emailAddress": {' +
                    '"address":"' + email + '",' +
                    '"name": "Adele Vance"' +
                '},' +
                '"type": "required"' +
            '}' +
        '],' +
        '"isOnlineMeeting": true,' +
        '"onlineMeetingProvider": "teamsForBusiness"' +
    '}';
    r.setBody(requestBody);

    return r;
}   public static String getCopiedItemJob(HttpResponse res){
       String responseBody = res.getBody();  
      Map<String, Object> eventResponseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        system.debug('eventResponseMap'+eventResponseMap);
    String meetingURL = null;

    if (eventResponseMap.containsKey('onlineMeeting')) {
        Map<String, Object> onlineMeeting = (Map<String, Object>) eventResponseMap.get('onlineMeeting');
         String onlineMeetingJson = JSON.serialize(onlineMeeting);

        system.debug('onlinemeet'+onlineMeeting);
        
       return onlineMeetingJson;
    } 
        
        system.debug('responseddd'+res);
	if(res.getStatusCode() != 201){
        system.debug('getres'+res);
	    throw new EException('Copy failed. Exiting');
	}

	for(String k : res.getHeaderKeys()){
	    System.debug(k + ' : ' + res.getHeader(k));
	    if(k == 'Location'){
            system.debug('i am gettting location');
		//return res.getHeader(k);
		return meetingURL;
	    } 
    
	}
	return null;
    }  
   public class EException extends Exception {}
}