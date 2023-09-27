trigger SharepointFoldersAccounts on Account (After insert,after Update) {
    // Create a set to store unique Account Ids
    if(SharepointFoldersHandler.FIRST_RUN){
    Set<Id> accountIds = new Set<Id>();

    // Collect the Account Ids from the trigger context
    for (Account a : Trigger.new) {
        accountIds.add(a.Id);
    }

    // Query for existing linked documents
    List<qkom365__O365_Metadata__c> existingLinks = [
        SELECT Id, qkom365__RelatedToId__c, qkom365__Document_Name__c
        FROM qkom365__O365_Metadata__c
        WHERE qkom365__Deleted__c != true
        AND qkom365__RelatedToId__c IN :accountIds
        AND qkom365__Document_Name__c IN :accountIds
    ];

    // Create a map to store the Account Ids that have existing links
    Map<Id, Boolean> accountHasLink = new Map<Id, Boolean>();
    for (qkom365__O365_Metadata__c link : existingLinks) {
        accountHasLink.put(link.qkom365__RelatedToId__c, true);
    }

    // Create a list of Account Ids that need processing
    List<Id> accountsToProcess = new List<Id>();
    for (Account a : Trigger.new) {
        if (!accountHasLink.containsKey(a.Id)) {
            accountsToProcess.add(a.Id);
        }
    }

    // Call the future method to create Account folders for eligible Accounts
    if (!accountsToProcess.isEmpty()) {
        SharepointFoldersHandler.createAccountFolders(accountsToProcess,'Account');
        
    }
        SharepointFoldersHandler.FIRST_RUN = false;
    }
}