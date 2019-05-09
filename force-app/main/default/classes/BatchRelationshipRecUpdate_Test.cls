@isTest
public class BatchRelationshipRecUpdate_Test {
    
    static testMethod void createInterviewDate()
    {
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
         Test.startTest();
        Contact parentGurdianContact =  OrientationandTrainingUtil.CreateWishFamily();
        Contact participantContact =  OrientationandTrainingUtil.CreateWishFamilyparticipant();
        Contact parentGurdianSecondContact =  OrientationandTrainingUtil.CreateWishFamily();
       
       
        //npe4__Relationship__c gurdianRelationShipRec = OrientationandTrainingUtil.ParentLegualGuardianRelation(wishChild.Id,parentGurdianContact.Id);
        //npe4__Relationship__c participantRelationShipRec = OrientationandTrainingUtil.ParticipantRelationShip(wishChild.Id,participantContact.Id);
        npe4__Relationship__c participantSecondRelationShipRec = OrientationandTrainingUtil.ParticipantRelationShip(wishChild.Id,parentGurdianSecondContact.Id);
        Test.stopTest();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        List<Wish_Child_Form__c> wishChildFormIns = OrientationandTrainingUtil.createWishChildForm(wish.id,wishChild,parentGurdianContact,participantContact);
        Insert  wishChildFormIns;
        
        Database.executeBatch(new BatchRelationshipRecUpdate());
    }
}