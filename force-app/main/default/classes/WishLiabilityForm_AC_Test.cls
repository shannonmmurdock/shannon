/*****************************************************************************
Author : MST Solutions
CreateDate : 14/11/2016
Description : WishLiabilityForm_AC_Test is used to increase the code coverage for WishLiabilityForm_AC.
******************************************************************************/
@isTest
public class WishLiabilityForm_AC_Test {
    
    static testMethod void Method1(){ 
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
        OrientationandTrainingUtil.insertDocusignSetting();
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        Test.StopTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        pageRef.getParameters().put('option', 'Three');
        Test.setCurrentPage(pageRef);
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator());
        WishLiabilityForm_AC wishChildIns = new WishLiabilityForm_AC(sc);
        wishChildIns.SingerName = wishChildFormIns[1].FirstName__c+ ' '+wishChildFormIns[1].LastName__c;
        wishChildIns.SignNowmultiEmail();
        wishChildIns.multiEmail();
        wishChildIns.sendpdftoEmail(); 
        map<string,string> emailMap = new map<string,string>();
        emailMap.put(wishChildFormIns[1].FirstName__c+ ' '+wishChildFormIns[1].LastName__c,wishChildFormIns[1].Email__c);
        WishLiabilityForm_AC.callOuttoDocusign(emailMap,wish.Id,'Three',wishChild.Name,'');
        wishChildIns.displayMessage();
        wishChildIns.returnToLiabilityForm();
        wishChildIns.cancel();
        wishChildIns.returnToWish();
        wishChildIns.redirect();
       }

    static testMethod void Method2(){ 
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
         OrientationandTrainingUtil.insertDocusignSetting();
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        Test.StopTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        pageRef.getParameters().put('option', 'One');
        Test.setCurrentPage(pageRef);
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator());
        WishLiabilityForm_AC wishChildIns = new WishLiabilityForm_AC(sc);
        wishChildIns.SingerName = wishChildFormIns[1].FirstName__c+ ' '+wishChildFormIns[1].LastName__c;
        wishChildIns.SignNowmultiEmail();
        wishChildIns.multiEmail();
        wishChildIns.sendpdftoEmail(); 
        map<string,string> emailMap = new map<string,string>();
        emailMap.put(wishChildFormIns[1].FirstName__c+ ' '+wishChildFormIns[1].LastName__c,wishChildFormIns[1].Email__c);
        WishLiabilityForm_AC.callOuttoDocusign(emailMap,wish.Id,'one',wishChild.Name,'');
        wishChildIns.displayMessage();
        wishChildIns.returnToLiabilityForm();
        wishChildIns.cancel();
        wishChildIns.returnToWish();
        wishChildIns.redirect();
       }
       
    static testMethod void Method3(){ 
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
        OrientationandTrainingUtil.insertDocusignSetting();
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        Test.StopTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishLiabilityForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        pageRef.getParameters().put('option', 'One');
        Test.setCurrentPage(pageRef);
        WishLiabilityForm_AC wishChildIns = new WishLiabilityForm_AC(sc);
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator());
        wishChildIns.SingerName = wishChildFormIns[1].FirstName__c+ ' '+wishChildFormIns[1].LastName__c;
        wishChildIns.multiEmail();
        wishChildIns.submitAndSign();
       }
}