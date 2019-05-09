@isTest
public class WishChildForm_AC_Test{
    
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
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        Test.StopTest();
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        List<Wish_Child_Form__c> updateFormList = new List<Wish_Child_Form__c>();
        for(Wish_Child_Form__c forms : wishChildFormIns){
            forms.City__c = null;
            updateFormList.add(forms);
        }
        Insert updateFormList;
        List<Wish_Child_Form__c> wishChildFormIns2 = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishChildForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        pageRef.getParameters().put('saved','true');
        Test.setCurrentPage(pageRef);
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        WishChildFormUtil wcfUtil = new WishChildFormUtil();
        wishChildIns.wcfUtil.isInformation = true;
        wishChildIns.SaveContact();
        wishChildIns.SaveandWishChildExit();
        wishChildIns.generatePDF();
        wishChildIns.getCurrentOwnWheelChairList();
        wishChildIns.getCurrentWCCollapsibleList();
        wishChildIns.getCurrentWCPowerList();
        wishChildIns.getCurrentOxygenNamesList();
        wishChildIns.getCurrrentDietaryNameList();
        wishChildIns.getCurrentOxygenNamesList();
        wishChildIns.getCurrrentDietaryNameList();
        wishChildIns.getCurrentNursingCareList();
        wishChildIns.getCurrentMedicationList();
        wishChildIns.getCurrentAllergyNamesList();
        wishChildIns.getCurrentOtherNeedsList();
        list<String> stringList = new list<String>();
        string valName = 'Test, Chandru Test value';
        stringList.add(valName);
        wishChildIns.setTempName(stringList);
        wishChildIns.setCurrentOwnWheelChairList(stringList);
        wishChildIns.setCurrentWCCollapsibleList(stringList);
        wishChildIns.setCurrentWCPowerList(stringList);
        wishChildIns.setCurrentOxygenNamesList(stringList);
        wishChildIns.setCurrrentDietaryNameList(stringList);
        wishChildIns.setCurrentNursingCareList(stringList);
        wishChildIns.setCurrentMedicationList(stringList);
        wishChildIns.setCurrentAllergyNamesList(stringList);
        wishChildIns.setCurrentOtherNeedsList(stringList);
        
    }
    
    static testMethod void saveWishFormMethod(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        Contact parentGurdianContact =  OrientationandTrainingUtil.CreateWishFamily();
        Contact participantContact =  OrientationandTrainingUtil.CreateWishFamilyparticipant();
        OrientationandTrainingUtil.createContactFileRecord(wishChild.id);
        Test.startTest();
        npe4__Relationship__c gurdianRelationShipRec = OrientationandTrainingUtil.ParentLegualGuardianRelation(wishChild.Id,parentGurdianContact.Id);
        npe4__Relationship__c participantRelationShipRec = OrientationandTrainingUtil.ParticipantRelationShip(wishChild.Id,participantContact.Id);
        Contact volunterCon = OrientationandTrainingUtil.createVolunteerContact(chapterAcc.id);
        Contact volunterConTwo = OrientationandTrainingUtil.createVolunteerContactwithOtherPhone(chapterAcc.id);
        RecursiveTriggerHandler.blockBeforeUpdate = true;
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishFamilyForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        WishChildFormUtil wcfUtil = new WishChildFormUtil();
        wishChildIns.wcfUtil.isInformation = true;
        wishChildIns.SaveContact();
        wishChildIns.WCFNext();
        wishChildIns.WCFtoWIF();
        wishChildIns.WCFtoWFF();
        wishChildIns.SaveandWishChildExit();
        wishChildIns.WishFamilytoWishInfo();
        PageReference pageRef1 = Page.WishInformationForm_VF;
        pageRef1.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef1);
        wishChildIns.WishInfotoWishChild();
        wishChildIns.cancelfunction();
        wishChildIns.cancel();
        wishChildIns.SavewithExit();
        wishChildIns.ExitwithApprovalError();
        wishChildIns.addFamily();
        wishChildIns.addDriver();
        wishChildIns.addParticipants();
        wishChildIns.BackToWCF();
        wishChildIns.SaveandwishFamilyExit();
        wishChildIns.generatePDF();
        wishChildIns.wishChildMap('Test','WishChild');
        wishChildIns.WishInfotoWishFamily();
        //wishChildIns.confirmSignNow();
        //wishChildIns.SubmitAndSign();
        Test.StopTest();
       
        wishChildIns.multiEmail();
        wishChildIns.sendpdftoEmail();
        wishChildIns.WishInfoWithSave();
        wishChildIns.forceDownloadPDF();
        wishChildIns.DisplayApprovalProcess();
        wishChildIns.getRaceEthnicity();
        wishChildIns.getDoesParticipantReqWheelchair();
        wishChildIns.getWillYourFamilyBringWheelChair();
        wishChildIns.getWheelChairColapsable();
        wishChildIns.getwheelChairPower();
        wishChildIns.getparticipantRequireOxygan();
        wishChildIns.getparticipantHaveSpecialallergies();
        wishChildIns.getmedicationRequireRefeigeration();
        wishChildIns.getcurrentlyReceiveNursingCare();
        wishChildIns.getanyOtherMedicalSupplies();
        wishChildIns.withOutNavigate();
        wishChildIns.RetrunToWish();
        wishChildIns.getTempName();
        wishChildIns.getethnicityList();
        wishChildIns.UploadFile();
        wishChildIns.getAttachments();
        wishChildIns.saveAttachment();
        wishChildIns.refresh();
        wishChildIns.removeAttachment();
        wishChildIns.init();
        wishChildIns.getparticipantHaveSpecialRestrictaion();
        WishChildForm_AC.searchCaseFile(wishChild.id);
        wishChildIns.NavigatetoWishFamily();
        wishChildIns.WFFNext();
        
    }
    
    static testMethod void saveWishInformationFormMethod(){ 
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
        
        
        CaseTeamRole roleRec = [SELECT Id FROM CaseTeamRole WHERE Name = 'Wish Granter' LIMIT 1];       
        CaseTeamMember caseTeamMeber = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterCon.id,roleRec.id);
        CaseTeamMember caseTeamMebertwo = OrientationandTrainingUtil.createCaseTeamMember(wish.id,volunterConTwo.id,roleRec.id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishInformationForm_VF;
        PageReference wishpageRef = Page.WishFamilyForm_VF;
        Test.setCurrentPage(wishpageRef);
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        wishpageRef.getParameters().put('index', '0');

        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        WishChildFormUtil wcfUtil = new WishChildFormUtil();
        wishChildIns.wcfUtil.isInformation = true;
        wishChildIns.SaveContact();
        wishChildIns.submitforApproval();
        wishChildIns.SaveandWishChildExit();
        wishChildIns.SaveandRedirectChildForm();
        wishChildIns.SaveAndRedirectFamilyForm();
        wishChildIns.SaveAndRedirectInformationForm();
        wishChildIns.SaveFromInformationToChildForm();
        wishChildIns.BackToWFF();
        wishChildIns.WishInfoSave();
        wishChildIns.generatePDF();
        wishChildIns.NavigatetoWishChildForm();
        wishChildIns.withOutSavefromWCFtoWIF();
        wishChildIns.withOutSavetoChild();
        wishChildIns.withOutSaveWCCF();
        List<Wish_Child_Form__c> wishformList = new List<Wish_Child_Form__c>();
        wishformList.add(wishChildFormIns[1]);
        wishChildIns.displayWishFamilyList = wishChildFormIns;
        wishChildIns.removeFamily();
        //wishChildIns.removeParticipants();
        //wishChildIns.displayErrorMessage(Exception ex);
        
        Test.StopTest();
    }
    
    
     static testMethod void saveDocInfo(){ 
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
        OrientationandTrainingUtil.insertDocusignSetting();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        Test.StopTest();
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference wishpageRef = Page.WishFamilyForm_VF;
        wishpageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(wishpageRef);
        wishpageRef.getParameters().put('id', String.valueOf(wish.Id));
        wishpageRef.getParameters().put('Participant', '0');
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator());
        WishChildFormUtil wcfUtil = new WishChildFormUtil();
        wishChildIns.confirmSignNow();
        wishChildIns.SubmitAndSign();
        wishChildIns.displayWishFamilyParticipantList = wishChildFormIns;
        wishChildIns.removeParticipants();
        }
        
        static testMethod void saveDocInfocallOut(){ 
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
        OrientationandTrainingUtil.insertDocusignSetting();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        case wishDetermination = OrientationandTrainingUtil.childWishWithConChapter(wish.Id);
        insert wishDetermination;
        Test.StopTest();
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        PageReference pageRef = Page.WishInformationForm_VF;
        pageRef.getParameters().put('id', String.valueOf(wish.Id));
        Test.setCurrentPage(pageRef);
        
        WishChildForm_AC wishChildIns = new WishChildForm_AC(sc);
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator());
        WishChildFormUtil wcfUtil = new WishChildFormUtil();
        wishChildIns.confirmSignNow();
        wishChildIns.SubmitAndSign();
        Map<string,string> sendEmailMap = new Map<string,string>();
        sendEmailMap.put('kanagaraj Arjunan','kanagaraj@mstsolutions.com');
        WishChildForm_AC.callouttoDocusing(sendEmailMap,wish.id,wishChild.Id,'kanagaraj'+' '+'Arjunan','Combo Family Form & Liability/Publicity Release Form','');
        }
}