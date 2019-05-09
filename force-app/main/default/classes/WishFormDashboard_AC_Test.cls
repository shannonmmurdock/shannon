/*****************************************************************************************
Created by: Kanagaraj
Author : MST Solutions
CreateDate : 07/09/2018
Description : This class is used to increase the code coverage for WishFormDashboard_AC 
*******************************************************************************************/

@isTest
public class WishFormDashboard_AC_Test{
/* This CalltheConstructor Method is used to cover the codecoverage for constructor.*/
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
        Minor_Participant__c minorParticipantIns = OrientationandTrainingUtil.createMinorParticipanRec(wish.Id);
        insert minorParticipantIns;
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        dsfs__DocuSign_Status__c createdsfsRec = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c createdsfsRecipentRec = OrientationandTrainingUtil.CreatedsfsRec(createdsfsRec.Id);
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildFormRec(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        WishFormDashboard_AC wishDashBoard = new WishFormDashboard_AC(wish.Id);
        //string name = WishFormDashboard_AC.getWishFamilyList(wish.Id);
        WishFormDashboard_AC.sendEnvelopId(createdsfsRec.dsfs__DocuSign_Envelope_ID__c, 'testEmail@demo.com');
        WishFormDashboard_AC.deleteStatusRec(createdsfsRec.dsfs__DocuSign_Envelope_ID__c,minorParticipantIns.Id);
        string gurdianName = wishChildFormIns[1].FirstName__c+' '+wishChildFormIns[1].LastName__c; 
        string email = wishChildFormIns[1].Email__c;
        string comboconfigValue = '{"Name":"'+gurdianName+'","email":"'+email+'","selectedForm":"Combo Family Form & Liability/Publicity Release Form","guardian":"'+gurdianName+'","miniorParticipantName":"self","currentPageId" :"'+wish.Id+'","WishChildContactId":"'+wishChild.id+'","selectedFormat":"E-Signature","documentTitle":"mr"}';
        WishFormDashboard_AC.sendWishFamilyEnvelope(comboconfigValue);
        WishFormDashboard_AC.editWishChildInformation(minorParticipantIns.Id,wish.Id);
        PageReference pageRef = Page.wishFormDashboard_VF;
        Test.setCurrentPage(pageRef);
        
    }
    
    static testMethod void sendEnvelop(){
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
        Minor_Participant__c minorParticipantIns = OrientationandTrainingUtil.createMinorParticipanRec(wish.Id);
        insert minorParticipantIns;
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        dsfs__DocuSign_Status__c createdsfsRec = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c createdsfsRecipentRec = OrientationandTrainingUtil.CreatedsfsRec(createdsfsRec.Id);
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildFormRec(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        WishFormDashboard_AC wishDashBoard = new WishFormDashboard_AC(wish.Id);
        //string name = WishFormDashboard_AC.getWishFamilyList(wish.Id);
        string gurdianName = wishChildFormIns[1].FirstName__c+' '+wishChildFormIns[1].LastName__c; 
        string email = wishChildFormIns[1].Email__c;
        string comboconfigValue = '{"Name":"'+gurdianName+'","email":"'+email+'","selectedForm":"Wish Form & Liability Form","guardian":"'+gurdianName+'","miniorParticipantName":"self","currentPageId" :"'+wish.Id+'","WishChildContactId":"'+wishChild.id+'","selectedFormat":"E-Signature","documentTitle":"mr"}';
        WishFormDashboard_AC.sendWishFamilyEnvelope(comboconfigValue);
        WishFormDashboard_AC.signNowEnvelopStatus(createdsfsRec.dsfs__DocuSign_Envelope_ID__c);
        PageReference pageRef = Page.wishFormDashboard_VF;
        Test.setCurrentPage(pageRef);
    }
    
     static testMethod void sendLiabilityEnvelop(){
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
        Minor_Participant__c minorParticipantIns = OrientationandTrainingUtil.createMinorParticipanRec(wish.Id);
        insert minorParticipantIns;
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        dsfs__DocuSign_Status__c createdsfsRec = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c createdsfsRecipentRec = OrientationandTrainingUtil.CreatedsfsRec(createdsfsRec.Id);
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildFormRec(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        WishFormDashboard_AC wishDashBoard = new WishFormDashboard_AC(wish.Id);
        //string name = WishFormDashboard_AC.getWishFamilyList(wish.Id);
        WishFormDashboard_AC.sendEnvelopId(createdsfsRec.dsfs__DocuSign_Envelope_ID__c, 'testEmail@demo.com');
        WishFormDashboard_AC.deleteStatusRec(createdsfsRec.dsfs__DocuSign_Envelope_ID__c,minorParticipantIns.Id);
        string gurdianName = wishChildFormIns[1].FirstName__c+' '+wishChildFormIns[1].LastName__c; 
        string email = wishChildFormIns[1].Email__c;
        string comboconfigValue = '{"Name":"'+gurdianName+'","email":"'+email+'","selectedForm":"Liability Form","guardian":"'+gurdianName+'","miniorParticipantName":"self","currentPageId" :"'+wish.Id+'","WishChildContactId":"'+wishChild.id+'","selectedFormat":"E-Signature","documentTitle":"mr"}';
        WishFormDashboard_AC.sendWishFamilyEnvelope(comboconfigValue);
        PageReference pageRef = Page.wishFormDashboard_VF;
        Test.setCurrentPage(pageRef);
    }
    
     static testMethod void sendAbsentEnvelop(){
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
        Minor_Participant__c minorParticipantIns = OrientationandTrainingUtil.createMinorParticipanRec(wish.Id);
        insert minorParticipantIns;
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        dsfs__DocuSign_Status__c createdsfsRec = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c createdsfsRecipentRec = OrientationandTrainingUtil.CreatedsfsRec(createdsfsRec.Id);
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildFormRec(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        WishFormDashboard_AC wishDashBoard = new WishFormDashboard_AC(wish.Id);
        //string name = WishFormDashboard_AC.getWishFamilyList(wish.Id);
        WishFormDashboard_AC.sendEnvelopId(createdsfsRec.dsfs__DocuSign_Envelope_ID__c, 'testEmail@demo.com');
        WishFormDashboard_AC.deleteStatusRec(createdsfsRec.dsfs__DocuSign_Envelope_ID__c,minorParticipantIns.Id);
        string gurdianName = wishChildFormIns[1].FirstName__c+' '+wishChildFormIns[1].LastName__c; 
        string email = wishChildFormIns[1].Email__c;
        string comboconfigValue = '{"Name":"'+gurdianName+'","email":"'+email+'","selectedForm":"Absent Parent Form","guardian":"'+gurdianName+'","miniorParticipantName":"self","currentPageId" :"'+wish.Id+'","WishChildContactId":"'+wishChild.id+'","selectedFormat":"E-Signature","documentTitle":"mr"}';
        WishFormDashboard_AC.sendWishFamilyEnvelope(comboconfigValue);
        PageReference pageRef = Page.wishFormDashboard_VF;
        Test.setCurrentPage(pageRef);
    }
    
     static testMethod void sendSingleEnvelop(){
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
        Minor_Participant__c minorParticipantIns = OrientationandTrainingUtil.createMinorParticipanRec(wish.Id);
        insert minorParticipantIns;
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        dsfs__DocuSign_Status__c createdsfsRec = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c createdsfsRecipentRec = OrientationandTrainingUtil.CreatedsfsRec(createdsfsRec.Id);
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildFormRec(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        WishFormDashboard_AC wishDashBoard = new WishFormDashboard_AC(wish.Id);
        //string name = WishFormDashboard_AC.getWishFamilyList(wish.Id);
        WishFormDashboard_AC.sendEnvelopId(createdsfsRec.dsfs__DocuSign_Envelope_ID__c, 'testEmail@demo.com');
        WishFormDashboard_AC.deleteStatusRec(createdsfsRec.dsfs__DocuSign_Envelope_ID__c,minorParticipantIns.Id);
        string gurdianName = wishChildFormIns[1].FirstName__c+' '+wishChildFormIns[1].LastName__c; 
        string email = wishChildFormIns[1].Email__c;
        string comboconfigValue = '{"Name":"'+gurdianName+'","email":"'+email+'","selectedForm":"Single Parent Form","guardian":"'+gurdianName+'","miniorParticipantName":"self","currentPageId" :"'+wish.Id+'","WishChildContactId":"'+wishChild.id+'","selectedFormat":"E-Signature","documentTitle":"mr"}';
        WishFormDashboard_AC.sendWishFamilyEnvelope(comboconfigValue);
        PageReference pageRef = Page.wishFormDashboard_VF;
        Test.setCurrentPage(pageRef);
    }
    
     static testMethod void sendMinorParticipantEnvelop(){
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
        Minor_Participant__c minorParticipantIns = OrientationandTrainingUtil.createMinorParticipanRec(wish.Id);
        insert minorParticipantIns;
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildFormRec(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        WishFormDashboard_AC wishDashBoard = new WishFormDashboard_AC(wish.Id);
        //string name = WishFormDashboard_AC.getWishFamilyList(wish.Id);
        string gurdianName = wishChildFormIns[1].FirstName__c+' '+wishChildFormIns[1].LastName__c; 
        string email = wishChildFormIns[1].Email__c;
        WishFormDashboard_AC.displayFormStatusPopup(gurdianName,wish.Id);
        string comboconfigValue = '{"Name":"'+gurdianName+'","email":"'+email+'","selectedForm":"Single Parent Form","guardian":"Not listed","miniorParticipantName":"self","currentPageId" :"'+wish.Id+'","WishChildContactId":"'+wishChild.id+'","selectedFormat":"Paper","documentTitle":"mr","editParticipantId":"'+minorParticipantIns.Id+'"}';
        WishFormDashboard_AC.sendWishFamilyEnvelope(comboconfigValue);
        WishFormDashboard_AC.updateParticipantInformation(comboconfigValue);
        PageReference pageRef = Page.wishFormDashboard_VF;
        Test.setCurrentPage(pageRef);
    }
    static testMethod void senNotListedEnvelop(){
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
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        dsfs__DocuSign_Status__c createdsfsRec = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c createdsfsRecipentRec = OrientationandTrainingUtil.CreatedsfsRec(createdsfsRec.Id);
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildFormRec(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        WishFormDashboard_AC wishDashBoard = new WishFormDashboard_AC(wish.Id);
        //string name = WishFormDashboard_AC.getWishFamilyList(wish.Id);
        string gurdianName = wishChildFormIns[1].FirstName__c+' '+wishChildFormIns[1].LastName__c; 
        string email = wishChildFormIns[1].Email__c;
        string comboconfigValue = '{"Name":"'+gurdianName+'","email":"'+email+'","selectedForm":"Single Parent Form","guardian":"'+gurdianName+'","miniorParticipantName":"self","currentPageId" :"'+wish.Id+'","WishChildContactId":"'+wishChild.id+'","selectedFormat":"Paper","documentTitle":"mr"}';
        WishFormDashboard_AC.sendWishFamilyEnvelope(comboconfigValue);
        PageReference pageRef = Page.wishFormDashboard_VF;
        Test.setCurrentPage(pageRef);
    }
     static testMethod void sendEmailEnvelop(){
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
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        dsfs__DocuSign_Status__c createdsfsRec = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c createdsfsRecipentRec = OrientationandTrainingUtil.CreatedsfsRec(createdsfsRec.Id);
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildFormRec(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        WishFormDashboard_AC wishDashBoard = new WishFormDashboard_AC(wish.Id);
        //string name = WishFormDashboard_AC.getWishFamilyList(wish.Id);
        
        string gurdianName = wishChildFormIns[1].FirstName__c+' '+wishChildFormIns[1].LastName__c; 
        string email = wishChildFormIns[1].Email__c;
        WishFormDashboard_AC.displayFormStatusPopup(createdsfsRecipentRec.Name,wish.Id);
        string comboconfigValue = '{"Name":"'+gurdianName+'","email":"'+email+'","selectedForm":"Single Parent Form","guardian":"'+gurdianName+'","miniorParticipantName":"self","currentPageId" :"'+wish.Id+'","WishChildContactId":"'+wishChild.id+'","selectedFormat":"E-Signature","documentTitle":"mr"}';
        WishFormDashboard_AC.sendWishFamilyEnvelope(comboconfigValue);
        List<dsfs__DocuSign_Recipient_Status__c > dsfsRecList = WishFormDashboard_AC.editDocuSignInformation(createdsfsRec.dsfs__DocuSign_Envelope_ID__c,wish.Id);
        String updateName = WishFormDashboard_AC.updateDocuSignInformation(createdsfsRec.dsfs__DocuSign_Envelope_ID__c,wish.Id,'test','test@gmail.com','test');
        PageReference pageRef = Page.wishFormDashboard_VF;
        Test.setCurrentPage(pageRef);
    }
}