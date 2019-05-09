// Created by : MST
// This class used to verify the functionality of Case_ReadytoInterview_Popup_AC class
// Helpful to do unit testing and codcoverage
@isTest
public class Case_ReadytoInterview_Popup_AC_Test {
    
    public testmethod static void createParentCaseReadytoInterview(){
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        Case newCase = new Case();
        newCase.id = parentCase.id;
        newCase.Status = 'Ready to Interview';
        newCase.Hidden_bypass_Validation__c = 'Ready to Interview';
        insert newCase;
        // system.assertEquals(parentWishRecordTypeId, newCase.RecordTypeId, 'Record type id does not match');
        test.startTest();
        Case_ReadytoInterview_Popup_AC.UpdateCaseStatus(newCase.id,newCase.Status);
        test.stopTest();
    }
    
    public testmethod static void createParentCaseWishDeterminedStatus(){
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        
        Bypass_Triggers__c byPassTgr = new Bypass_Triggers__c();
        byPassTgr.SetupOwnerId = UserInfo.getUserId();
        insert byPassTgr;
        List<PermissionSet> permSionSet = [SELECT Id, Name FROM Permissionset WHERE name = 'Program Supervisor'];
        if(permSionSet.size() > 0) {
            PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = permSionSet[0].Id, AssigneeId = UserInfo.getUserId());
            Insert psa;
        }
        
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        Case newCase = new Case();
        newCase.id = parentCase.id;
        newCase.Status = 'Wish Determined';
        newCase.Sub_Status__c = 'Within Policy';
        newCase.Hidden_bypass_Validation__c = 'Wish Determined/Within Policy';
        insert newCase;
        // system.assertEquals(parentWishRecordTypeId, newCase.RecordTypeId, 'Record type id does not match');
        test.startTest();
        Case_ReadytoInterview_Popup_AC.UpdateCaseStatus(newCase.id, 'Ready to Interview');
        test.stopTest();
    }
    
    
    public testmethod static void createParentCase(){
        Constant_AC  constant = new Constant_Ac();    
        Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        Case parentCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        insert parentCase;
        system.assertEquals(parentWishRecordTypeId, parentCase.RecordTypeId, 'Record type id does not match');
        test.startTest();
        Case_ReadytoInterview_Popup_AC.UpdateCaseStatus(parentCase.id,parentCase.Status);
        test.stopTest();
    }
    
}