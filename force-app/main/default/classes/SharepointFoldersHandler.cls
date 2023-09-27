public class SharepointFoldersHandler {
 public static boolean FIRST_RUN = true;

    @future(callout=true)
    public static void createAccountFolders(list<Id> accountId,string Objectname) {
        
         
      if (Objectname=='Account')
       {
        List<Account> accounts = [ SELECT Id, Name FROM Account WHERE Id IN :accountId ];
    for (account ac:accounts)
    {
     String title = SharepointHelper.normalize(ac.Name);
	
	String destination_drive = SharepointConfig.DESTINATION_DRIVE; //Destination_Drive__c same  documentlib
	String destination_item = SharepointConfig.DESTINATION_ROOT;//Destination_Root__c //root
	String template_drive = SharepointConfig.TEMPLATE_DRIVE;//Template_Drive__c same documentlib
	String template_accounts = SharepointConfig.TEMPLATE_ACCOUNTS;// Template_Accounts__c folder id 

	// Get HttpRequest > Copy template to destination
	HttpRequest req = SharepointHelper.getTemplateRequest(destination_drive, destination_item, title);
	String job_url = SharepointHelper.getCopiedItemJob(qkom365.GraphUtils.send(req, '/v1.0/drives/' + template_drive + '/items/' + template_accounts + '/copy'));

	// Get copy job information
	Http http = new Http();
	HttpRequest req_job = SharepointHelper.getJobStatusRequest(job_url);

	// Retrieve root folder metadata
	String root_id = '';
	Integer k = 0;
	while(true){
	    root_id = SharepointHelper.getIdFromJobStatusResponse(http.send(req_job));

	    if(root_id == null){
		SharepointHelper.sleep(SharepointConfig.SLEEP_DELAY);

		if(++k > 15){
		    throw new EException('Error getting new document library id. Exiting.');
		}
		continue;
	    }
	    break;
	}

	// Get additional folder information
	HttpRequest req_top = new HttpRequest();
	req_top.setMethod('GET');

	HttpResponse res_top = qkom365.GraphUtils.send(req_top, '/v1.0/drives/' + destination_drive + '/items/' + root_id);

	Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(res_top.getBody());
    system.debug('getbody'+body);
	String root_url = String.valueOf(body.get('webUrl'));

	
	SharepointHelper.createLink(String.valueOf(ac.id), title, destination_drive, root_id, root_url, 'Folder', 'Accounts', 'Account Files', null);
        
    // System.enqueueJob(new CreateFolderQueueable(title, root_id)); 
    }
       }

        
      else   if(Objectname=='Opportunity')
    {
        set<id>sid=new set<id>();
    List<Opportunity> opportunities = [ SELECT Id,accountid, Name FROM Opportunity WHERE Id IN :accountId ];
    for (Opportunity ac:opportunities)
    {
    sid.add(ac.accountid);
    }
       // string title=null;
      //Destination_Drive__c same  documentlib
    // list<opportunity>opps=[select id,accountid from opportunity where id=:accountId];
    map<id,qkom365__O365_Metadata__c>qkommap= new map<id,qkom365__O365_Metadata__c>();
    list<qkom365__O365_Metadata__c>qkommdt=[select id,qkom365__O365Id__c,qkom365__RelatedToId__c,qkom365__O365ParentId__c from  qkom365__O365_Metadata__c where qkom365__RelatedToId__c in:sid];
    for(qkom365__O365_Metadata__c qk:qkommdt)
    {
     qkommap.put(qk.qkom365__RelatedToId__c,qk)   ;
    }
    for (Opportunity ac:opportunities)
    {  
     string title=ac.name;
     qkom365__O365_Metadata__c qkommdt1=  qkommap.get(ac.accountid); 
    String opportunityId=' ' ;
    HttpRequest req_topp = new HttpRequest();
	req_topp.setMethod('GET');       
        HttpResponse res_topp = qkom365.GraphUtils.send(req_topp, '/v1.0/drives/'+ qkommdt1.qkom365__O365ParentId__c +'/items/'+qkommdt1.qkom365__O365Id__c +'/children');
    system.debug('res_top11'+res_topp);
    Map<String, Object> bodyy = (Map<String, Object>) JSON.deserializeUntyped(res_topp.getBody());
    system.debug('getbody'+bodyy);
   

if (bodyy.containsKey('value') && bodyy.get('value') instanceof List<Object>) {
    List<Object> valueList = (List<Object>) bodyy.get('value');
    
    for (Object item : valueList) {
        if (item instanceof Map<String, Object>) {
            Map<String, Object> child = (Map<String, Object>) item;
            String name = (String) child.get('name');
            
            if (name != null && name.equalsIgnoreCase('opportunity')) {
                opportunityId = (String) child.get('id');
                System.debug('Opportunity ID: ' + opportunityId);
                break;
            }
        }
    }
} else {
    System.debug('Unexpected response format');
}
        
    // String destination_drive = SharepointConfig.DESTINATION_DRIVE; //Destination_Drive__c same  documentlib
	String destination_drive = SharepointConfig.DESTINATION_DRIVE;
    String destination_item =opportunityId;//Destination_Root__c //root
	String template_drive = SharepointConfig.TEMPLATE_DRIVE;//Template_Drive__c same documentlib
	String template_accounts = SharepointConfig.TEMPLATE_ACCOUNTS;// Template_Accounts__c folder id 
     
    HttpRequest req = SharepointHelper.getTemplateRequest(destination_drive, destination_item, title);
	String job_url = SharepointHelper.getCopiedItemJob(qkom365.GraphUtils.send(req, '/v1.0/drives/' + template_drive + '/items/' + template_accounts + '/copy'));

	// Get copy job information
	Http http = new Http();
	HttpRequest req_job = SharepointHelper.getJobStatusRequest(job_url);

	// Retrieve root folder metadata
	String root_id = '';
	Integer k = 0;
	while(true){
	    root_id = SharepointHelper.getIdFromJobStatusResponse(http.send(req_job));

	    if(root_id == null){
		SharepointHelper.sleep(SharepointConfig.SLEEP_DELAY);

		if(++k > 15){
		    throw new EException('Error getting new document library id. Exiting.');
		}
		continue;
	    }
	    break;
	}

	// Get additional folder information
	HttpRequest req_top = new HttpRequest();
	req_top.setMethod('GET');

	HttpResponse res_top = qkom365.GraphUtils.send(req_top, '/v1.0/drives/' + destination_drive + '/items/' + root_id);

	Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(res_top.getBody());
    system.debug('getbody'+body);
	String root_url = String.valueOf(body.get('webUrl'));

	// Create link document: top-level
	SharepointHelper.createLink(String.valueOf(ac.id), title, destination_drive, root_id, root_url, 'Folder', 'Opportunity', 'Opportunity Files', null);
    }  
         
     
    
    } 
    }
    
    public class EException extends Exception {}
}