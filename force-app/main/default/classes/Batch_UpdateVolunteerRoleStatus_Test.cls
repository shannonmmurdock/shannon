/*************************************************************************************************************************************************
Created by: Pavithra
Author : MST Solutions
CreateDate : 10/05/2016
Description :Batch_UpdateVolunteerStatus_Test is used to increase the code coverage for Batch_UpdateVolunteerStatus_AC class.
*************************************************************************************************************************************************/

@isTest
public class Batch_UpdateVolunteerRoleStatus_Test{
     static testmethod void  updateVolunteerStatus(){
         Account chapterAc = OrientationandTrainingUtil.createchapterAccount();
        // Contact volunteerContact1 = OrientationandTrainingUtil.createVolunteerContact(chapterAc.Id);
         Contact volunteerContact2 = OrientationandTrainingUtil.createVolunteerContact(chapterAc.Id);
        /* npe5__Affiliation__c affiliation1 = OrientationandTrainingUtil.CreateAffiliation(volunteerContact1.Id);
         affiliation1.npe5__Status__c = 'Active';
         Update affiliation1;*/
         npe5__Affiliation__c affiliation2 = OrientationandTrainingUtil.CreateAffiliation(volunteerContact2.Id);
         affiliation2.npe5__Status__c = 'Active';
         Update affiliation2;
            User currUser1;
               User currUser2;
         System.RunAs(new User(Id = UserInfo.getUserId()))
        {
           // currUser1 = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact1.id);
            currUser2 = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunteerContact2.id);
        }
         
         
      //   Background_check__c bc = OrientationandTrainingUtil.createBackgroundCheckRec(volunteerContact.Id);
       //  Conflict_Of_Interest__c conOfIntrest = OrientationandTrainingUtil.createCOI(volunteerContact.Id);
         
         Role__c wishGranterRole = OrientationandTrainingUtil.createRole();
         Role__c nonWishRole = OrientationandTrainingUtil.createNonWishRole();
       /*  Role__C boardMemberRole =  OrientationandTrainingUtil.createRole();
         boardMemberRole.Name = 'Board Member';
         Update boardMemberRole;*/
        
         Chapter_Role__c wishGranterChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,wishGranterRole.Id);
         Chapter_Role__c nonWishChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,nonWishRole.Id);
        // Chapter_Role__c boardMemberChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,boardMemberRole.Id);
         Orientation_Training__c  OrientationId = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
         Chapter_Role_O_T__c chapRoleandId = OrientationandTrainingUtil.createChapterOandT(wishGranterChapterRole.Id,OrientationId.Id);
         Class_Offering__c newclass = OrientationandTrainingUtil.createClassOffering(chapRoleandId.Id);
         
         Chapter_Role_O_T__c chapRoleandId2 = OrientationandTrainingUtil.createChapterOandT(nonWishChapterRole.Id,OrientationId.Id);
         Class_Offering__c newclass2 = OrientationandTrainingUtil.createClassOffering(chapRoleandId2.Id);
         
         Volunteer_Roles__c wishGranterVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact2.Id,wishGranterChapterRole.Id);
         Volunteer_Roles__c nonWishVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact2.Id,nonWishChapterRole.Id);
        // Volunteer_Roles__c boardMemberVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact1.Id,boardMemberChapterRole.Id);
         Volunteer_Orientation_Training__c createVolTraining = OrientationandTrainingUtil.createVolTraining(OrientationId.id,newclass2.Id,volunteerContact2.Id,'Completed');
         
         wishGranterVolRole.Status__C = 'Out of Compliance';
         nonWishVolRole.Status__C = 'Out of Compliance';
      //   boardMemberVolRole.Status__C = 'Out of Compliance';
         Test.startTest();
        // Update boardMemberVolRole;
         Update nonWishVolRole;
         Update wishGranterVolRole;
         Database.executeBatch(new Batch_UpdateVolunteerRoleStatus_AC());
        Test.stopTest();
      //  system.assertEquals(boardMemberRole.Name,'Board Member','Role is not board member');
//        system.assert(affiliation.npe5__Status__c == 'Active','status updated incorrectly' );
    }
      static testmethod void  updateVolunteerSingleActiveStatus(){
       Account chapterAc = OrientationandTrainingUtil.createchapterAccount();
         Contact volunteerContact1 = OrientationandTrainingUtil.createVolunteerContact(chapterAc.Id);
         Contact volunteerContact2 = OrientationandTrainingUtil.createVolunteerContact(chapterAc.Id);
         npe5__Affiliation__c affiliation1 = OrientationandTrainingUtil.CreateAffiliation(volunteerContact1.Id);
         affiliation1.npe5__Status__c = 'Active';
         Update affiliation1;
         npe5__Affiliation__c affiliation2 = OrientationandTrainingUtil.CreateAffiliation(volunteerContact2.Id);
         affiliation2.npe5__Status__c = 'Active';
         Update affiliation2;
            User currUser1;
               User currUser2;
         System.RunAs(new User(Id = UserInfo.getUserId()))
        {
           currUser1 = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact1.id);
            //currUser2 = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunteerContact2.id);
        }
         
         
      //   Background_check__c bc = OrientationandTrainingUtil.createBackgroundCheckRec(volunteerContact.Id);
       //  Conflict_Of_Interest__c conOfIntrest = OrientationandTrainingUtil.createCOI(volunteerContact.Id);
         
         Role__c wishGranterRole = OrientationandTrainingUtil.createRole();
         Role__c nonWishRole = OrientationandTrainingUtil.createNonWishRole();
         Role__C boardMemberRole =  OrientationandTrainingUtil.createRole();
         boardMemberRole.Name = 'Board Member';
         Update boardMemberRole;
        
         Chapter_Role__c wishGranterChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,wishGranterRole.Id);
         Chapter_Role__c nonWishChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,nonWishRole.Id);
         Chapter_Role__c boardMemberChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,boardMemberRole.Id);
        
         Volunteer_Roles__c wishGranterVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact1.Id,wishGranterChapterRole.Id);
         Volunteer_Roles__c nonWishVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact2.Id,nonWishChapterRole.Id);
         Volunteer_Roles__c boardMemberVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact1.Id,boardMemberChapterRole.Id);
         
         
         wishGranterVolRole.Status__C = 'Out of Compliance';
         nonWishVolRole.Status__C = 'Out of Compliance';
         boardMemberVolRole.Status__C = 'Out of Compliance';
         Test.startTest();
         Update boardMemberVolRole;
         Update nonWishVolRole;
         Update wishGranterVolRole;
         Database.executeBatch(new Batch_UpdateVolunteerRoleStatus_AC());
        Test.stopTest();
        system.assertEquals(boardMemberRole.Name,'Board Member','Role is not board member');
//        system.assert(affiliation.npe5__Status__c == 'Active','status updated incorrectly' );
     }
    static testmethod void  updateVolunteerRolePedingStatus(){
       Account chapterAc = OrientationandTrainingUtil.createchapterAccount();
         Contact volunteerContact1 = OrientationandTrainingUtil.createVolunteerContact(chapterAc.Id);
         Contact volunteerContact2 = OrientationandTrainingUtil.createVolunteerContact(chapterAc.Id);
         npe5__Affiliation__c affiliation1 = OrientationandTrainingUtil.CreateAffiliation(volunteerContact1.Id);
         affiliation1.npe5__Status__c = 'Active';
         Update affiliation1;
         npe5__Affiliation__c affiliation2 = OrientationandTrainingUtil.CreateAffiliation(volunteerContact2.Id);
         affiliation2.npe5__Status__c = 'Active';
         Update affiliation2;
            User currUser1;
               User currUser2;
         System.RunAs(new User(Id = UserInfo.getUserId()))
        {
          // currUser1 = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact1.id);
            currUser2 = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunteerContact2.id);
        }
         
         
      //   Background_check__c bc = OrientationandTrainingUtil.createBackgroundCheckRec(volunteerContact.Id);
       //  Conflict_Of_Interest__c conOfIntrest = OrientationandTrainingUtil.createCOI(volunteerContact.Id);
         
         Role__c wishGranterRole = OrientationandTrainingUtil.createRole();
         Role__c nonWishRole = OrientationandTrainingUtil.createNonWishRole();
         Role__C boardMemberRole =  OrientationandTrainingUtil.createRole();
         boardMemberRole.Name = 'Board Member';
         Update boardMemberRole;
        
         Chapter_Role__c wishGranterChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,wishGranterRole.Id);
         Chapter_Role__c nonWishChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,nonWishRole.Id);
         Chapter_Role__c boardMemberChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,boardMemberRole.Id);
        
         Volunteer_Roles__c wishGranterVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact1.Id,wishGranterChapterRole.Id);
         Volunteer_Roles__c nonWishVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact2.Id,nonWishChapterRole.Id);
         Volunteer_Roles__c boardMemberVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact1.Id,boardMemberChapterRole.Id);
         
         
         wishGranterVolRole.Status__C = 'Out of Compliance';
         nonWishVolRole.Status__C = 'Out of Compliance';
         boardMemberVolRole.Status__C = 'Out of Compliance';
         Test.startTest();
         Update boardMemberVolRole;
         Update nonWishVolRole;
         Update wishGranterVolRole;
         Database.executeBatch(new Batch_UpdateVolunteerRoleStatus_AC());
        Test.stopTest();
        system.assertEquals(boardMemberRole.Name,'Board Member','Role is not board member');
//        system.assert(affiliation.npe5__Status__c == 'Active','status updated incorrectly' );
     }
    
    
}