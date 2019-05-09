/*****************************************************************************************
Created by: Kanagaraj
Author : MST Solutions
CreateDate : 12/09/2018
Description : This class is used to increase the code coverage for SignNow_AC
*******************************************************************************************/
@isTest
public class SignNow_AC_Test{
     static testMethod void calltheConstructorMethod(){ 
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        Contact parentGurdianContact =  OrientationandTrainingUtil.CreateWishFamily();
        Contact participantContact =  OrientationandTrainingUtil.CreateWishFamilyparticipant();
        Test.startTest();
        npe4__Relationship__c gurdianRelationShipRec = OrientationandTrainingUtil.ParentLegualGuardianRelation(wishChild.Id,parentGurdianContact.Id);
        npe4__Relationship__c participantRelationShipRec = OrientationandTrainingUtil.ParticipantRelationShip(wishChild.Id,participantContact.Id);
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAcc.id);
        Contact volunterConTwo = OrientationandTrainingUtil.createVolunteerContactwithOtherPhone(chapterAcc.id);
        RecursiveTriggerHandler.blockBeforeUpdate = true;
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Test.StopTest();
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        Wish_Child_Form__c updateWishchild = new Wish_Child_Form__c();
        updateWishchild.Id = wishChildFormIns[0].Id;
        updateWishchild.BirthDate__c =  wishChildFormIns[0].BirthDate__c - 7032;
        update updateWishchild;
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishChildForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        SignNow_AC signIns = new SignNow_AC(sc);
    }
}