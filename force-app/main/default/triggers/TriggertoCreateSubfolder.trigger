trigger TriggertoCreateSubfolder on qkom365__O365_Metadata__c (After insert) {
 /* List<Id> recordIds = new List<Id>();
    
    for (qkom365__O365_Metadata__c record : Trigger.new) {
        recordIds.add(record.Id);
    }
    
    // Convert the list of IDs to a comma-separated string
    String recordIdsAsString = String.join(recordIds, ',');

    // Publish a Platform Event with the record IDs
    Callout_Request__e calloutEvent = new Callout_Request__e(
        RecordIds__c = recordIdsAsString
    );
    EventBus.publish(calloutEvent); */

        // Perform any synchronous logic here
        
        // Enqueue the Queueable Apex job
        System.enqueueJob(new CreateFolderQueueable(trigger.new));
    
  
}