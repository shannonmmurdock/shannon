/*****************************************************************************************************************
Author      : MST Solutions
Date        : 10/26/2016
Description : This class contains test method for CaseFile object
*******************************************************************************************************************/
@isTest
public class CaseFile_AT_Test {
    
    @testSetup static void methodName() {
        Constant_AC cons = new Constant_AC();
        Id wishClearenceRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.wishClearenceAttachment ).getRecordTypeId();
        Contact wishChildCon = OrientationandTrainingUtil.CreateWishChild();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChildCon.Id);
        Minor_Participant__c newParticipant = new Minor_Participant__c(Associated_Childeren__c = 'Test', AttachmentId__c = 'Test', RecordTypeId = wishClearenceRecordTypeId, Case__c = parentCase.Id);
        insert newParticipant;
    }
    
    static testmethod void createCaseFile() {
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon();
        Case parentCase = [SELECT Id FROM Case LIMIT 1];
        cg__CaseFile__c newFileRecord = OrientationandTrainingUtil.createCaseFileRecord(parentCase.Id);
        newFileRecord.File_Path__c = 'Path';
        newFileRecord.cg__Key__c = 'Test File';
        newFileRecord.cg__File_Name__c = 'Sample';
        Minor_Participant__c updateCaseFile = new Minor_Participant__c();
        updateCaseFile.Id = [SELECT Id FROM Minor_Participant__c LIMIT 1].Id;
        updateCaseFile.Case__c = parentCase.Id;
        updateCaseFile.AttachmentId__c = newFileRecord.cg__File_Name__c;
        update updateCaseFile;
        update newFileRecord;
        
        
        //system.AssertEquals(newCase.contactId,wishChild.Id,'Contact Id does not match');
        //system.Assert(newCase.Id == newFileRecord.cg__Case__c,'Case Id does not match');
    }
    
    Static testMethod void deleteCaseFile(){
        test.startTest();
        Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildCon();
        Case parentCase = [SELECT Id FROM Case LIMIT 1];
        Minor_Participant__c newMinorPart = new Minor_Participant__c();
        newMinorPart.Case__c = parentCase.id;
        newMinorPart.File_Path__c = 'Path';
        insert newMinorPart;
        cg__CaseFile__c newFileRecord = OrientationandTrainingUtil.createCaseFileRecord(parentCase.Id);
        newFileRecord.File_Path__c = 'Path';
        Update newFileRecord;
        cg__CaseFile__c newCaseFile = new cg__CaseFile__c(cg__Case__c = parentCase.Id, cg__Content_Type__c = 'Folder',cg__File_Name__c = 'Documents');
        insert newCaseFile;
        cg__CaseFile__c newCaseFile1 = new cg__CaseFile__c(cg__Case__c = parentCase.Id, cg__Content_Type__c = 'Folder',cg__File_Name__c = 'Documents', cg__Parent_Folder_Id__c = newCaseFile.Id);
        insert newCaseFile1;
        cg__CaseFile__c folderCon = new cg__CaseFile__c(cg__Case__c = parentCase.Id, cg__Content_Type__c = 'Folder1',cg__File_Name__c = 'Documents', cg__Parent_Folder_Id__c = newCaseFile.Id);
        insert folderCon;
        Delete newFileRecord;
        test.stopTest();
        
    }
}