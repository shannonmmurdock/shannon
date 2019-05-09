@isTest
public class CreateWishFormRecords_AC_Test {
    
    static testMethod void createInterviewDate()
    {
        Account chapterAccount = OrientationandTrainingUtil.AlabamaAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild();
        Account chapterAmericaAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Contact childFamily = OrientationandTrainingUtil.CreateWishFamily();
        npe4__Relationship__c  npcr = OrientationandTrainingUtil.CreateRelationshipRec(wishChild.Id,childFamily.Id);
        Wish_Child_Form__c wishForm = [SELECT Id FROM Wish_Child_Form__c WHERE Case__c =: parentCase.Id LIMIT 1];
        DELETE wishForm;
        Database.executeBatch(new CreateWishFormRecords_AC());
    }
}