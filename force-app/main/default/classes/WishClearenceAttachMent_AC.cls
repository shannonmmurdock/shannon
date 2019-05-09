/*****************************************************************************************************************
Author      : MST Solutions
Date        : 01/19/2017
Description : This form is used as IFrame inside the  Diagnosis Verification form to upload medical summary attachment
*******************************************************************************************************************/
public class WishClearenceAttachMent_AC  {
    
    public Id attachmentId {get; set;}
    public Attachment newAttachment {get; set;}
    public Id recId;
    public boolean isSaved{get;set;}
    public boolean isDeleted{get;set;}
    public WishClearenceAttachMent_AC() {
        newAttachment = new Attachment();
        recId = ApexPages.currentPage().getParameters().get('id');
        if(ApexPages.currentPage().getParameters().get('saved') != null && ApexPages.currentPage().getParameters().get('saved') == 'true'){
            isSaved = true;
        }
        if(ApexPages.currentPage().getParameters().get('deleted') != null && ApexPages.currentPage().getParameters().get('deleted') == 'true'){
            isDeleted = true;
        }
    }  
    
    //Used to display medical summary attachment to diagnosis verification form
     public List<cg__CaseFile__c> getAttachments() {
         Constant_AC cons = new Constant_AC();
         Id wishClearenceRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.wishClearenceAttachment ).getRecordTypeId();
         Set<string> filePathSets = new Set<string>();
        
        for(Minor_Participant__c dbMinorRec : [SELECT Id,File_Path__c,Form_Name__c,Case__c,RecordTypeId FROM Minor_Participant__c WHERE Case__c =: recId AND 
                                                 RecordTypeId =: wishClearenceRecordTypeId]){
            filePathSets.add(dbMinorRec.Form_Name__c);
        }
        List<cg__CaseFile__c> attachmentList = [select Id, cg__Case__c, File_Path__c,cg__Content_Type__c,cg__Description__c, 
                                                cg__File_Name__c from cg__CaseFile__c where cg__Case__c =: recId AND 
                                                cg__Content_Type__c != 'Folder' AND cg__File_Name__c IN: filePathSets];
        
        return attachmentList;
    }
    
    //Used to save new attachment theat attached from diagnosis verification form
    public PageReference save() {
        Constant_AC cons = new Constant_AC();
        Id wishClearenceRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.wishClearenceAttachment ).getRecordTypeId();
        if (newAttachment.Body!=null) {
            newAttachment.parentId = recId;
            insert newAttachment;
            
            system.debug('@@@ newAttachment @@@'+newAttachment);
            
            Minor_Participant__c newMinorParticipant = new Minor_Participant__c();
            newMinorParticipant.Case__c = recId;
            newMinorParticipant.Form_Name__c = newAttachment.Name;
            newMinorParticipant.RecordTypeId = wishClearenceRecordTypeId;
            newMinorParticipant.AttachmentId__c = newAttachment.Name;
            system.debug('@@@ newMinorParticipant @@@'+newMinorParticipant);
            
            insert newMinorParticipant;
            
            newAttachment = new Attachment();
        }
        PageReference redirect = new PageReference('/apex/WishClearenceAttachMent_VF?id='+recId+'&saved=true');
        redirect.setRedirect(true);
        return redirect;
    }
    
    //Used to refresh the block
    public void Refresh() {
    }
    
    //Used to delete the attachment from diagnosis verification form
    public PageReference RemoveAttachment() {
        List<cg__CaseFile__c> attachmentToBeDeleted = [SELECT Id FROM cg__CaseFile__c WHERE Id =: attachmentId];
        if(attachmentToBeDeleted.size() > 0) {
            try{
                delete attachmentToBeDeleted;    
            }Catch(Exception ex){
                System.debug('Exception ex'+ex.getMessage());
            }            
            
        }
        PageReference redirect = new PageReference('/apex/WishClearenceAttachMent_VF?id='+recId);
        redirect.setRedirect(true);
        return redirect;
    }
}