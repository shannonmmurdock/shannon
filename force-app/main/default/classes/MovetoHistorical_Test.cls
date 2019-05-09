/****************************************************************************************
Author : MST Solutions
CreateDate : 10/06/2017
Description : This MovetoHistorical_Test is used to increase the code coverage for MovetoHistorical controller.
*****************************************************************************************/

@isTest
public class MovetoHistorical_Test 
{
    //This callCheckHistoricalRole method is used to increase the code coverage for "UpdateVolunteerOpportunity" methods.
    private static testmethod void callCheckHistoricalRole()
    {
        Constant_AC constant = new Constant_AC();
        Id wishVolunteerOpportunity = Schema.Sobjecttype.Volunteer_Opportunity__c.getRecordTypeInfosByName().get(constant.wishVolunteerOpportunity).getRecordTypeId();        
        Role__c currRole = OrientationandTrainingUtil.createRole();
        Contact wishChild=OrientationandTrainingUtil.CreateWishChild();
         Account chapterAccount = OrientationandTrainingUtil.createchapterAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        //Contact wishChild1=OrientationandTrainingUtil.CreateWishChild();        
        
        Account acc = OrientationandTrainingUtil.createchapterAccount();
        Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.Id);
        Contact volCnt = OrientationandTrainingUtil.createVolunteerContact(acc.Id);        
        Case newParentWish = OrientationandTrainingUtil.CreateParentCase(volCnt.Id);
        Volunteer_Opportunity__c volOpp = OrientationandTrainingUtil.CreateNewWishVolunteerOpportunity(acc.Id, currChapRole.Id, newParentWish.Id);
        MovetoHistorical.CheckHistoricalRole(volOpp.Id);
        Volunteer_Opportunity__c opp=new Volunteer_Opportunity__c();
        opp.Id=volOpp.Id;
        opp.Wish__c=newParentWish.Id;
        opp.Chapter_Role_Opportunity__c=currChapRole.Id;
        opp.RecordTypeId = wishVolunteerOpportunity;
        opp.Volunteer_Name__c = volunteerContact.id;
        update opp;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        MovetoHistorical.UpdateVolunteerOpportunity(opp.Id);
        System.runAs (thisUser) {
            Test.startTest();
            Id CaseTeamId;
            CaseTeamRole ctr=[SELECT id from CaseTeamRole where Name='Wish Granter'];
            CaseTeamId=ctr.Id;
            if(ctr.Id==NULL)
            {
                CaseTeamRole ctr1=OrientationandTrainingUtil.CreateCaseTeamRole();
                CaseTeamId=ctr1.Id;
            }
            CaseTeamMember caseMemeber=OrientationandTrainingUtil.createWishTeamMemberwithTeamRole(newParentWish.Id,wishChild.Id,CaseTeamId);
            Test.stopTest();
        }
       // MovetoHistorical.UpdateVolunteerOpportunity(volOpp.Id);
        System.AssertEquals(opp.Id,volOpp.Id);
    }
}