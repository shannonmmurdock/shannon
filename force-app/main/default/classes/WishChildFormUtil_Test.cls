@isTest
public class WishChildFormUtil_Test{
    
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
        wcfUtil.getStates();
        wcfUtil.getYear();
        wcfUtil.getParentGuardianRelationships();
        wcfUtil.getRelationships();
        wcfUtil.getParticipantRelationships();
        wcfUtil.selectedNames('testName;testone');
        wcfUtil.getMonths();
        WishChildFormUtil.DriverWrapper driver = new WishChildFormUtil.DriverWrapper();
        WishChildFormUtil.WrapperClass wrap = new WishChildFormUtil.WrapperClass();
        
        
    }
  }