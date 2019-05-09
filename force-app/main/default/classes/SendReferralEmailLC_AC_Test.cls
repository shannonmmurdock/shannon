@isTest
public class SendReferralEmailLC_AC_Test {
    @isTest
    static void SendReferralEmail_test(){
        Account chapterAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Contact wishChildContact = OrientationandTrainingUtil.CreateWishChildCon();
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);        
        insert newLead;
        
        SendReferralEmailLC_AC.getOfficeViaLead(newLead.Id);
        SendReferralEmailLC_AC.triggerEmail(newLead.Id, 'Test@test.com');
        ChapterChangeConfirmationPopup_AC.updateLeadChapter('revert', newLead.Id);
        ChapterChangeConfirmationPopup_AC.updateLeadChapter('accept', newLead.Id);
    }
}