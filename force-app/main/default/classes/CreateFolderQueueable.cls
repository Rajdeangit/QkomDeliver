public class CreateFolderQueueable implements Queueable, Database.AllowsCallouts {
        public List<qkom365__O365_Metadata__c> accList ; 
    public CreateFolderQueueable(List<qkom365__O365_Metadata__c> accList){
        this.accList = accList ;  
    }
    public void execute(QueueableContext context) {
        for(qkom365__O365_Metadata__c acc :accList){
            if (String.valueOf(acc.qkom365__RelatedToId__c).startsWith('0065h')) {
            for (Integer i = 1; i <= 4; i++) {
              string nameoffolder = i==1 ? 'Other File': i==2 ? 'Shared File': i==3 ? 'Meeting':i==4 ? 'Notes':'check'; 
          qkom365.GraphUtils.createFolder(label.SharepointGroup,acc.qkom365__O365Id__c,nameoffolder);
            }
        //}
    }
            else if(String.valueOf(acc.qkom365__RelatedToId__c).startsWith('0015h'))
            {
              for (Integer i = 1; i <= 2; i++) {
                string nameoffolder = i==1 ? 'Opportunity': i==2 ? 'Client Information':'check';
                  system.debug('nameoffolder'+nameoffolder);
                //qkom365.GraphUtils.createFolder('99f6919e-aa94-4585-a9d3-7af48cd2ca9c',acc.qkom365__O365Id__c,nameoffolder);
                 system.debug('testfor store in obj'+ qkom365.GraphUtils.createFolder(label.SharepointGroup,acc.qkom365__O365Id__c,nameoffolder));
                 
            }
            }
    
}
}
}