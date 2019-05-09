/*************************************************************************************************************************************************
Created by: Pavithra
Author : MST Solutions
CreateDate : 10/05/2016
Description :batch_BUpdateAffiliation_Test is used to increase the code coverage for Batch_UpdateVolunteerStatus_AC class.
*************************************************************************************************************************************************/

@isTest
public class batch_BUpdateAffiliation_Test{
     static testmethod void  updateVolunteerAffStatus(){
         Account chapterAc = OrientationandTrainingUtil.createchapterAccount();
         Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAc.Id);
         npe5__Affiliation__c affiliation = OrientationandTrainingUtil.CreateAffiliation(volunteerContact.Id);
         affiliation.npe5__Status__c = 'Out of Compliance';
         Update affiliation;
         
         Role__c wishGranterRole = OrientationandTrainingUtil.createRole();
         Chapter_Role__c wishGranterChapterRole = OrientationandTrainingUtil.createChapter(chapterAc.Id,wishGranterRole.Id); 
         Volunteer_Roles__c wishGranterVolRole = OrientationandTrainingUtil.createVolRole(volunteerContact.Id,wishGranterChapterRole.Id);
         Database.executeBatch(new batch_BUpdateAffiliation_AC());
     }
}