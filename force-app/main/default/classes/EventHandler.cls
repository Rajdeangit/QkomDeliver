public class EventHandler {
    
    public static void callutil(list<Event> evmap)
        
    {
        
        set<id>sid=new set<id>();
        for(event ev:evmap)
      {
          if(ev.isteams__c)
        {
      sid.add(ev.WhoId);
        }
      }
      
      map<id,contact>conmap=new map<id,contact>([select id,email from contact where id in:sid]);  
      for(event ev:evmap)
      {
          if(ev.isteams__c)
        {
          contact con=conmap.get(ev.WhoId);
       calenderevent(ev.subject,ev.StartDateTime,ev.EndDateTime,ev.Location,con.Email,ev.id);
        } }
    
    }
    
    @future(callout=true)
    
    public static void calenderevent(string sub,DateTime start,DateTime enddate,string location,string email,string eventId)
    {  
   HttpRequest req = EventUtilities.getTemplateRequest1(sub,start,enddate,location,email); 
       String job_url = EventUtilities.getCopiedItemJob(qkom365.GraphUtils.send(req, '/v1.0/me/calendars/'+label.calenderid+'/events'));
       List<Event> eventsToUpdate = new List<Event>();
    
    system.debug('why i am not getting url'+job_url);
            event evv=new Event(Id = eventId, Description = job_url);
     
        update evv;
    }
    }