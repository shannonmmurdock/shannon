@istest
public class LeadTriggerHandler_Test{
    public testmethod static void UpdateStatusDNQ(){
     User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        User nationalStaff;
        RecursiveTriggerHandler.isFirstTime = True;
        System.RunAs(currUser)
        {   
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
        }
        Account chapterAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Contact medicalProfessionalCon = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        Contact wishFamily = OrientationandTrainingUtil.CreateWishFamily();
        chapterAccount.Intake_Manager__c = nationalStaff.Id;
        Update chapterAccount;
        Lead newLead = OrientationandTrainingUtil.createTestLeadRec(chapterAccount.Id);
        newLead.ChapterName__c = chapterAccount.Id;
       // newLead.OwnerId =nationalStaff.Id;
        newLead.status = 'Inquiry';
        Insert newlead;
        system.assertequals(chapterAccount.Id,[SELECT ChapterName__r.Name FROM lead WHERE Id =: newlead.Id].ChapterName__c);
        system.assertequals('Referred',[SELECT status FROM lead WHERE Id =: newLead.Id].Status);
         RecursiveTriggerHandler.isFirstTime = True;
        newlead.Qualifying_Diagnosis__c  = 'Test'; 
        newLead.Will_Child_s_Condition_Deteriorate__c = 'No';
        newLead.I_m_Part_of_The_Treating_HealthCare_Team__c = 'No';
        newLead.Is_in_a_Comatose_Vegetative_State__c = 'No';
		
		newLead.I_am_Recognized_To_Practice_As_a__c = 'Nurse';
		newLead.Any_medical_reason_for_moving_quickly__c = 'No';
        newLead.Part_A_Received__c = System.today();
        newLead.Sub_Status__c = 'Age';
        newlead.Status= 'DNQ';
        //updateLeadStatus.Id = newlead.Id;
        Update newlead;
        system.assertequals('DNQ',[SELECT status FROM lead WHERE Id =: newlead.Id].Status);
         
        
    }
    
}