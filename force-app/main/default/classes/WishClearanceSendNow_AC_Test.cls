/*****************************************************************************
Author : MST Solutions
CreateDate : 03/25/2016
Description : WishClearanceSendNow_AC_Test is used to increase the code coverage for WishClearanceSendNow_AC.
******************************************************************************/

@isTest
public class WishClearanceSendNow_AC_Test {
    // This method will create parent case as test data and pass the case id to the page
    public static testMethod void createParentCase(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRecord(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
        PageReference pageRef = Page.WishClearanceSendNow_VF;
        pageRef.getParameters().put('id',String.valueOf(caseId.Id));
        Test.setCurrentPage(pageRef);
        
        WishClearanceSendNow_AC wishClear = new WishClearanceSendNow_AC(sc);
        wishClear.getMedicalProContact();
        wishClear.medicalProfContactName = contactMedicalProfessChild.FirstName+' '+contactMedicalProfessChild.LastName;
        wishClear.SendtoDocuSign();
        wishClear.DisplayMessage();
        wishClear.cancel();
        wishClear.displayEmail();
        System.assert(wishClear.currentParentCase.Id == caseId.Id ,'Wish Clearance does not match with parent Id.');
    }
   // This method will create the parent case with rush and pass the case id to the page    
    public static testMethod void createParentCaseWithRush(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild();
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRecord(contactWishChild.Id,contactMedicalProfessChild.Id); 
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        case updatecase = new case();
        updatecase.Rush__c = true;
        updatecase.Id = caseId.Id;
        updatecase.Rush_Explanation__c = 'test';
        updatecase.IsRushWishClearence_ChildSummary__c = true;
        updatecase.Rush_Timeframe__c = '0-31';
        update updatecase;
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPAges.StandardController sc = new ApexPages.StandardController(updatecase);
        PageReference pageRef = Page.WishClearanceSendNow_VF;
        pageRef.getParameters().put('id',String.valueOf(updatecase.Id));
        Test.setCurrentPage(pageRef);
        WishClearanceSendNow_AC wishClear = new WishClearanceSendNow_AC(sc);
        wishClear.getMedicalProContact();
        wishClear.medicalProfContactName = contactMedicalProfessChild.FirstName+' '+contactMedicalProfessChild.LastName;
        wishClear.SendtoDocuSign();
        wishClear.DisplayMessage();
        wishClear.cancel();
        wishClear.displayEmail();
        wishClear.ReturnToWish();
        wishClear.ReturnToWishClearanceForm();
        System.assert(updatecase.Rush__c , 'The wish not a Rush');
        
    }
    // This method will create the paremtcase with Airtravel
    public static testMethod void createParentCaseWithAirTravel(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRecord(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        case updatecase = new case();
        updatecase.wish_involves_air_travel__c = 'Yes';
        updatecase.Id = caseId.Id;
        updatecase.Description = 'test';
        updatecase.Rush__c =true;
        updatecase.Rush_Explanation__c ='test';
        updatecase.Rush_Timeframe__c ='ASAP';
        update updatecase;
        
        case newCase = new case();
        newCase.IsRushWishClearence_ChildSummary__c = true;
        newCase.Id = caseId.id;
        update newCase;
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPAges.StandardController sc = new ApexPages.StandardController(updatecase);
        PageReference pageRef = Page.WishClearanceSendNow_VF;
        pageRef.getParameters().put('id',String.valueOf(updatecase.Id));
        Test.setCurrentPage(pageRef);
        WishClearanceSendNow_AC wishClear = new WishClearanceSendNow_AC(sc);
        wishClear.getMedicalProContact();
         wishClear.medicalProfContactName = contactMedicalProfessChild.FirstName+' '+contactMedicalProfessChild.LastName;
        wishClear.SendtoDocuSign();
        wishClear.DisplayMessage();
        wishClear.cancel();
        wishClear.displayEmail();
        wishClear.ReturnToWish();
        wishClear.ReturnToWishClearanceForm();
        System.assert(updatecase.wish_involves_air_travel__c == 'Yes' , 'The particular Wish does not involve the Air travel');
    }
    // This method will create the parent case as test data
    public static testMethod void createParentCaseWithTravel(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRecord(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCaseWithTravel(contactWishChild.Id);
        createRelationShipRec.Send_Wish_Forms__c = True;
        Update createRelationShipRec;
        
        case updatecase = new case();
        updatecase.wish_involves_air_travel__c = 'Yes' ;
        updatecase.Id = caseId.Id;
        updatecase.Description = 'test';
        updatecase.Emergency_Number__c = Null;
        updatecase.Appropriate_Comments__c = Null;
        updatecase.Please_Explain__c = Null;
        updatecase.Date_of_last_visit_treatment__c = Null;
        updatecase.IsRushWishClearence_ChildSummary__c = true;
        updatecase.Comments__c = Null;
        updatecase.Comment_1__c = Null;
        updatecase.Comment_2__c = Null;
        updatecase.Rush__c =true;
        updatecase.Rush_Explanation__c ='test';
        updatecase.Rush_Timeframe__c ='ASAP';
        updatecase.Wish_Clearance_Sent_Date__c = system.today();
        updatecase.Wish_Clearance_Sent_Date__c = system.today();
        update updatecase;
        
        
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
        PageReference pageRef = Page.WishClearanceSendNow_VF;
        pageRef.getParameters().put('id',String.valueOf(caseId.Id));
        Test.setCurrentPage(pageRef);
        WishClearanceSendNow_AC wishClear = new WishClearanceSendNow_AC(sc);
        wishClear.getMedicalProContact();
        wishClear.medicalProfContactName = contactMedicalProfessChild.FirstName+' '+contactMedicalProfessChild.LastName;
        wishClear.email = contactMedicalProfessChild.Email;
        wishClear.displayEmail();
        wishClear.SendtoDocuSign();
        Test.StartTest();
        boolean isRush = false;
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        WishClearanceSendNow_AC.CallouttoDocusign(caseId.id,contactWishChild.Name,contactWishChild.Email,Null);
        Test.StopTest();
        System.assertEquals(wishClear.medicalProfContactName,contactMedicalProfessChild.FirstName+' '+contactMedicalProfessChild.LastName,'Compare MedicalProf Name in Contact and in WishChildSummary');
    }
     // This method will create parent case as test data and pass the case id to the page
    public static testMethod void wishClearance_test(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRecord(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCase(contactWishChild.Id);
        Case parentCase = new Case(Id=caseId.Id, Description = 'Test', wish_involves_air_travel__c='Yes', Wish_Clarence_Attachment__c='Yes');
        update parentCase;
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
        PageReference pageRef = Page.WishClearanceSendNow_VF;
        pageRef.getParameters().put('id',String.valueOf(caseId.Id));
        Test.setCurrentPage(pageRef);
        
        WishClearanceSendNow_AC wishClear = new WishClearanceSendNow_AC(sc);
        wishClear.getMedicalProContact();
        wishClear.medicalProfContactName = contactMedicalProfessChild.FirstName+' '+contactMedicalProfessChild.LastName;
        wishClear.type = 'WishClearanceNoTravel';
        wishClear.SendtoDocuSign();
        wishClear.DisplayMessage();
        wishClear.cancel();
        wishClear.displayEmail();
        wishClear.ReturnToWishClearanceNoTravelForm();
        wishClear.displayAttachment();
        System.assert(wishClear.currentParentCase.Id == caseId.Id ,'Wish Clearance does not match with parent Id.');
    }
    public static testMethod void createParentCaseWithTravel2(){
        Contact contactWishChild =   OrientationandTrainingUtil.CreateWishChild(); 
        Contact contactMedicalProfessChild = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        npe4__Relationship__c createRelationShipRec = OrientationandTrainingUtil.CreateMedicalProfessionalRelationshipRecord(contactWishChild.Id,contactMedicalProfessChild.Id);
        Case caseId = OrientationandTrainingUtil.CreateParentCaseWithTravel(contactWishChild.Id);
        createRelationShipRec.Send_Wish_Forms__c = True;
        Update createRelationShipRec;
        
        case updatecase = new case();
        updatecase.wish_involves_air_travel__c = 'Yes' ;
        updatecase.Id = caseId.Id;
        updatecase.Description = 'test';
        updatecase.Emergency_Number__c = Null;
        updatecase.Appropriate_Comments__c = Null;
        updatecase.Please_Explain__c = Null;
        updatecase.Date_of_last_visit_treatment__c = Null;
        updatecase.IsRushWishClearence_ChildSummary__c = true;
        updatecase.Comments__c = Null;
        updatecase.Comment_1__c = Null;
        updatecase.Comment_2__c = Null;
        updatecase.Rush__c =false;
        updatecase.Rush_Explanation__c ='test';
        updatecase.Rush_Timeframe__c ='ASAP';
        updatecase.Wish_Clearance_Sent_Date__c = system.today();
        updatecase.Wish_Clearance_Sent_Date__c = system.today();
        update updatecase;
        
        
        OrientationandTrainingUtil.insertDocusignSetting();
        ApexPAges.StandardController sc = new ApexPages.StandardController(caseId);
        PageReference pageRef = Page.WishClearanceSendNow_VF;
        pageRef.getParameters().put('id',String.valueOf(caseId.Id));
        Test.setCurrentPage(pageRef);
        WishClearanceSendNow_AC wishClear = new WishClearanceSendNow_AC(sc);
        wishClear.type = 'WishClearanceNoTravel';
        wishClear.getMedicalProContact();
        wishClear.medicalProfContactName = contactMedicalProfessChild.FirstName+' '+contactMedicalProfessChild.LastName;
        wishClear.email = contactMedicalProfessChild.Email;
        wishClear.displayEmail();
        wishClear.SendtoDocuSign();
        Test.StartTest();
        boolean isRush = false;
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        WishClearanceSendNow_AC.CallouttoDocusign(caseId.id,contactWishChild.Name,contactWishChild.Email,Null);
        Test.StopTest();
        System.assertEquals(wishClear.medicalProfContactName,contactMedicalProfessChild.FirstName+' '+contactMedicalProfessChild.LastName,'Compare MedicalProf Name in Contact and in WishChildSummary');
    }
}