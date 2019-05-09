/***************************************************************************************************
Author      : MST Solutions
Date        : 09/11/2018
Description : CloudNewsTrigger_Test is used to increase the code coverage for ErrorMessage__e and its controller.
*****************************************************************************************************/
@isTest
public class CloudNewsTrigger_Test {
    
    public testmethod static void updateLeadAsQualified(){
        Id chapterAccount = OrientationandTrainingUtil.CreateAlabamaAccount();
        Condition_Description__c descrip = OrientationandTrainingUtil.createConditionDesCription(); 
        insert descrip;
        Account chapAcc = OrientationandTrainingUtil.MakeAWishAmericaAcc();
        Contact medicalProfessionalCon = OrientationandTrainingUtil.CreateTreatingMedicalProfContact();
        Contact FamilyContact = OrientationandTrainingUtil.CreateWishFamily();
        ICD_Codes__c icdCode = OrientationandTrainingUtil.createICDCode(descrip.Id);
        insert icdCode;
        //Test.startTest();
        Lead newLead = OrientationandTrainingUtil.createSameMedicalLead(chapterAccount);
        newLead.Sibling_Detail__c = 'aa | - | 12';
        newLead.Relationship_to_child__c = 'Medical Professional';
        newLead.PD_ICD_Code__c = icdCode.Id;
        newLead.Diagnosis_Given_By_Referrer__c  = 'Test';  
        newLead.Will_Child_s_Condition_Deteriorate__c = 'No';
        newLead.I_m_Part_of_The_Treating_HealthCare_Team__c = 'No';
        newLead.Is_in_a_Comatose_Vegetative_State__c = 'No';
        
        insert newLead;
        //Test.stopTest();
        RecursiveTriggerHandler.isFirstTime = true; 
        System.assertEquals( RecursiveTriggerHandler.isFirstTime,true);
        newLead.SD1_ICD_Code__c = icdCode.Id;
        newLead.SD2_ICD_Code__c = icdCode.Id;
        newLead.SD3_ICD_Code__c = icdCode.Id;
        newLead.SD4_ICD_Code__c = icdCode.Id;
        newLead.Status = 'Referred';
        newLead.ChapterName__c = chapAcc.Id;
        newLead.Sub_Status__c = 'Pending Diagnosis Verification';
        newLead.Wish_Family_ContactId__c = FamilyContact.Id;
        newLead.Medical_Professional_ContactId__c =  medicalProfessionalCon.Id;
        newLead.Hidden_Additional_Parent_Id__c =  FamilyContact.Id;
        newLead.Best_Contact_for_Physician_First_Name__c = 'bestPhysician';
        newLead.Best_Contact_for_Physician_Last_Name__c = 'Test';
        newLead.Best_contact_for_Physician_Email__c = 'best@mail.com';
        newLead.Hidden_Best_Contact_Person_Id__c = medicalProfessionalCon.Id;
        update newLead;
        Test.startTest();
        newLead.Any_medical_reason_for_moving_quickly__c = 'Yes';
        newLead.Please_Explain__c = 'Yes';
        //newLead.Childs_Qualifying_Diagnosis__c = 'Testrr';
        newLead.I_am_Recognized_To_Practice_As_a__c = 'Nurse';
        newLead.Status = 'Qualified';
        update newLead;
        Test.stopTest();
        System.assertEquals(newLead.Status,'Qualified');
        System.assertEquals(medicalProfessionalCon.Id,newLead.Medical_Professional_ContactId__c);
    }
}