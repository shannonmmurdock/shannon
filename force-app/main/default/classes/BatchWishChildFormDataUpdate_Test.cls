@isTest
public class BatchWishChildFormDataUpdate_Test{


      static testMethod void calltheConstructorMethod(){ 
        
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        
        
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Contact parentGurdianContact =  OrientationandTrainingUtil.CreateWishFamily();
       Contact participantContact =  OrientationandTrainingUtil.CreateWishFamily();
       
        Test.startTest();
        
        
        
        Wish_Child_Form__c newChildForm = new Wish_Child_Form__c();
        newChildForm.Actor_Actress__c = 'James';
        newChildForm.Additional_Requests__c = 'test';
        
        newChildForm.Already_wish_granted_by_MAW_Other_Org__c = 'Yes';
        newChildForm.Any_impact_your_ability_to_join_wish__c = 'Yes';
        newChildForm.Automobile_insurance_provide_coverage__c = 'Yes';
        newChildForm.Availability_Time_Period_1__c =' Apr/2019';
        newChildForm.Hidden_Wish_Fmaily_Contact_Email__c = 'Vennila  Paramasivam - mcavennila@gmail.com, chandrasekar - chandru@mstsolutions.com';
        newChildForm.Hidden_Contact_Name__c = 'Vennila Paramasivam';
        newChildForm.Hidden_Wish_Fmaily_Contact_Name__c = 'Vennila Paramasivam#chandrasekar ';
        newChildForm.Case__c = wish.Id;
        newChildForm.Wish_Family_Contact__c = '[{"workTelephone":"","tshirtSize":null,"residingWishMedical":null,"relId":"'+parentGurdianContact.Id+'","relationship":"Father","mobileTelephone":"(878) 787-8787","MiddleName":"","medicalNeeds":null,"lastName":"Test12","homeTelephone":"","firstName":"Test12","Email":"kanagaraj@mstsolutions.com","dob":"2016-11-29"},{"workTelephone":"","tshirtSize":null,"residingWishMedical":null,"relId":"'+participantContact.Id+'","relationship":"Mother","mobileTelephone":"(878) 787-8787","MiddleName":"","medicalNeeds":null,"lastName":"TestPL1","homeTelephone":"","firstName":"TestPF1","Email":"kanagu431@gmail.com","dob":"2016-11-28"}]';
        newChildForm.Participant_Contacts__c = '[{"workTelephone":null,"tshirtSize":"","residingWishMedical":"Yes","relId":null,"relationship":"Father","mobileTelephone":null,"MiddleName":"","medicalNeeds":"Yes","lastName":"Test12","homeTelephone":null,"firstName":"Test12","Email":"kanagaraj@mstsolutions.com","dob":null},{"workTelephone":null,"tshirtSize":"","residingWishMedical":"Yes","relId":null,"relationship":"Mother","mobileTelephone":null,"MiddleName":"","medicalNeeds":"Yes","lastName":"TestPL1","homeTelephone":null,"firstName":"TestPF1","Email":"kanagu431@gmail.com","dob":null}]';
        newChildForm.Driver_Name__c = 'Vennila karur |';
        newChildForm.Driver_Details__c = '[{"type":"Potential","state":"Alaska","licenseNum":"Tamil Nadu","expirationDate":"2017-01-04","driverName":"Test12 Test12"}]';
        newChildForm.Availability_Time_Period_2__c = 'Feb/2016';
        newChildForm.Availability_Time_Period_3__c = 'Feb/2018';
        newChildForm.Participant_Name_for_Dietary_Restriction__c = 'test';
        newChildForm.Requested_Participant_Name_forWheelchair__c = 'test';
        newChildForm.Requested_Participant_Name_for_OtherNeed__c= 'test';
        newChildForm.Requested_Participant_Name_for_Oxygen__c = 'test';
        newChildForm.Requested_Participant_Name_for_Allergies__c = 'test';
        newChildForm.Bringing_Own_Wheel_Chair__c = 'test';
        newChildForm.Name_of_wheelchair_collapsible__c = 'test;test';
        newChildForm.Pariticipant_name_havingWheelchair_Power__c = 'test;test';
        newChildForm.Medication_require_refrigeration_name__c = 'test;test';
        newChildForm.Names_for_receiving_nursing_care__c = 'test;test';
        newChildForm.Participant_Details__c  = 'Participant Participant2-joserathi@mstsolutions.com-26';
        newChildForm.Participant_Name__c = 'Participant Participant2-26';
        newChildForm.Hidden_Wish_Fmaily_Contact_Name__c= 'Parent1 Parent2#parent3 parent4';
        newChildForm.Hidden_Wish_Fmaily_Contact_Email__c = 'Parent1 Parent2-kanagu431@gmail.com,parent3 parent4-kanagaraj@mstsolutions.com';
        newChildForm.Participant_Name__c = 'Kanagaraj'+' '+'Arjunan'+'::'+30;
        newChildForm.Parent_Gurdian_above_18_Email__c = 'Kanagaraj'+' '+'Arjunan'+'::'+'test@gmail.com';
        newChildForm.Participant_Details__c = 'Kanagaraj'+' '+'Arjunan'+'::'+'test@gmail.com'+'::'+30;
        newChildForm.Emergency_Relationship__c = 'Employee';
        newChildForm.Emergency_First_Name__c = 'TestEmployee';
        newChildForm.Emergency_Last_Name__c = 'TestLastEmployee';
        newChildForm.Emergency_Mobilephone__c = '9600467559';
        newChildForm.Race_Ethnicity__c = 'American Indian or Alaska Native';
        newChildForm.Case_Team_Member1__c = 'Test Chandru';
        newChildForm.Case_Team_Member2__c = 'Test Kesav';
        newChildForm.Driver_Information__c = '{"type":"","state":"Alabama","licenseNum":"Test","expirationDate":"2019-10-02","driverName":"Father - Chandr Sek"}]';
        Insert  newChildForm;
        Database.executeBatch(new BatchWishChildFormDataUpdate());
 }
}