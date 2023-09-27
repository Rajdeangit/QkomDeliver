trigger CalloutRequestTrigger on Callout_Request__e (after insert) {
 List<Id> recordIds = new List<Id>();
    
    for (Callout_Request__e event : Trigger.new) {
        // Extract record IDs from the event
        recordIds.addAll(event.RecordIds__c.split(','));
    }
    
    List<qkom365__O365_Metadata__c> recordsToProcess = [SELECT Id, qkom365__O365Id__c, qkom365__Document_Name__c FROM qkom365__O365_Metadata__c WHERE Id IN :recordIds];
    
    for (qkom365__O365_Metadata__c record : recordsToProcess) {
        for (Integer i = 1; i <= 4; i++) {
            qkom365.GraphUtils.createFolder('99f6919e-aa94-4585-a9d3-7af48cd2ca9c', record.qkom365__O365Id__c, record.qkom365__Document_Name__c + '' + i);
        }
    }
}