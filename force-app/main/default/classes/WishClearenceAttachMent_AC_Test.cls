@isTest
public class WishClearenceAttachMent_AC_Test {
    
    
    @testSetup static void testData() {
        Constant_AC cons = new Constant_AC();
        Id wishClearenceRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.wishClearenceAttachment ).getRecordTypeId();
        Contact wishChildCon = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChildCon.Id);
        Minor_Participant__c newParticipant = new Minor_Participant__c(Associated_Childeren__c = 'Test', AttachmentId__c = 'Test', RecordTypeId = wishClearenceRecordTypeId, Case__c = parentCase.Id, Form_Name__c = 'MyForm');
        insert newParticipant;
        cg__CaseFile__c caseFile = OrientationandTrainingUtil.createCaseFileRecord(parentCase.Id);
        caseFile.cg__File_Name__c = newParticipant.Form_Name__c;
        caseFile.cg__Case__c = parentCase.Id;
        update caseFile;
    }
    
    static testMethod void attachment()  {
        Test.StartTest(); 
        Case parentCase = [SELECT Id FROM Case LIMIT 1];
        cg__CaseFile__c attachmentId = [SELECT Id FROM cg__CaseFile__c LIMIT 1];
        PageReference pageRef = Page.WishClearenceAttachMent_VF; // Add your VF page Name here
        pageRef.getParameters().put('id', parentCase.Id);
        pageRef.getParameters().put('saved', 'true');
        pageRef.getParameters().put('deleted', 'true');
        Test.setCurrentPage(pageRef);
        
        WishClearenceAttachMent_AC wishClearance = new WishClearenceAttachMent_AC();
        
        Attachment newAttachmentFile = new Attachment();
        newAttachmentFile.Body = Blob.valueOf('Sample');
        newAttachmentFile.Name = 'My Document';
        newAttachmentFile.parentId = parentCase.Id;
        //insert newAttachmentFile;
        
        wishClearance.newAttachment = newAttachmentFile;
        wishClearance.getAttachments();
        wishClearance.save();	
        wishClearance.Refresh();
        wishClearance.attachmentId = attachmentId.Id;
        wishClearance.RemoveAttachment();
        Test.StopTest();
    }
}