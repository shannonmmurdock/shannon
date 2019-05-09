/*****************************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 5/23/2016
Description : This TimeSheetTrigger_AT_Test is used to calculate the total hours spent by volunteer to close the wish and 
Non-wish & Event.
*******************************************************************************************************************/
@isTest
public class TimeSheetTrigger_AT_Test {
    
    /*Create Wish volunteer Opportunity time sheet*/
    private testmethod static void createNewWishTimeSheet(){
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        volunteerCon.MailingLatitude = -24.355798;
        volunteerCon.MailingLongitude = 69.830469;
        volunteerCon.MailingStreet = '7540 E Gold Dust Ave';
        volunteerCon.MailingCountry = 'United States';
        volunteerCon.MailingState = 'Arizona';
        volunteerCon.MailingCity = 'Scottsdale';
        update volunteerCon;
        
        User volunteerUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunteerCon.Id);
        
        Case wishCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        wishCase.ChapterName__c = chapterAccount.Id;
        wishCase.ContactId = volunteerCon.Id;
        insert wishCase;
        
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> wishVolOppList = new List<Volunteer_Opportunity__c>();
        Volunteer_Opportunity__c wishVolOpp = OrientationandTrainingUtil.CreateNewWishVolunteerOpportunity(chapterAccount.id,chapterRole.id,wishCase.id);
        wishVolOpp.Volunteer_Name__c = volunteerCon.Id;
        update wishVolOpp;
        
        wishVolOppList.add(wishVolOpp);
        //List<Volunteer_Opportunity__c> OppList = [SELECT Id, Status__c,Volunteer_Name__r.Date_of_last_engagement__c FROM Volunteer_Opportunity__c WHERE Id =: wishVolOpp.Id];
        Test.startTest();
        List<Time_sheet__c> newTimeSheet = OrientationandTrainingUtil.crateWishTimeSheet(wishVolOppList);
        System.debug('Number of newTimeSheet '+newTimeSheet.size()+' and its values are: '+newTimeSheet);
        List<Time_sheet__c> updateTimeSheet = new List<Time_sheet__c>();
        for(Time_sheet__c timeSheet : newTimeSheet){
            timeSheet.Hours_spent__c = 0.100;
            timeSheet.Date__c = date.today()-2;
            updateTimeSheet.add(timeSheet);
        }
        update updateTimeSheet;        
        
        //Time_sheet__c tSheet = [SELECT ID,Hours_Hidden__c FROM Time_Sheet__c];
        //System.assertEquals(10,updateTimeSheet[0].Hours_Hidden__c);
        
        Test.stopTest();
    }
    
    /*Create Non Wish Volunteer Opportunity time sheet*/
    public testmethod static void InsertNonWishTimeSheet(){
        Test.startTest();
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        /*volunteerCon.MailingLatitude = -24.355798;
        volunteerCon.MailingLongitude = 69.830469;
        volunteerCon.MailingStreet = '7540 E Gold Dust Ave';
        volunteerCon.MailingCountry = 'United States';
        volunteerCon.MailingState = 'Arizona';
        volunteerCon.MailingCity = 'Scottsdale';
        update volunteerCon;*/
        
        
        
        Non_Wish_Events__c nonWishEventId = OrientationandTrainingUtil.CreateEvent(chapterAccount.Id);
        //nonWishEventId.
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> nonWishVolunteerOpportunityList =OrientationandTrainingUtil.NewnonWishVolunteerOpportunityList(volunteerCon.Id,chapterAccount.id,chapterRole.id,nonWishEventId.id,1);
        
        OrientationandTrainingUtil.crateNonWishTimeSheet(nonWishVolunteerOpportunityList,1);
        OrientationandTrainingUtil.crateNonWishTimeSheet(nonWishVolunteerOpportunityList,1);
        
        List<Time_sheet__c> updateTimeSheetList = new List<Time_sheet__c>();
        List<Time_sheet__c> timeSheetList = [SELECT Id,Volunteer_Opportunity__c,Volunteer_Opportunity__r.Non_Wish_Event__c,Hours_spent__c  FROM Time_sheet__c WHERE Volunteer_Opportunity__r.Non_Wish_Event__c =: nonWishEventId.Id];
        for(Time_sheet__c processTimeSheetRec : timeSheetList){
            Time_sheet__c  updateSheet = new Time_sheet__c ();
            updateSheet.Id = processTimeSheetRec.id;
            updateSheet.Hours_spent__c = 10.30;
            updateTimeSheetList.add(updateSheet);
        }
        
        update updateTimeSheetList;
        
        delete updateTimeSheetList;
        Test.stopTest();
    }
    public testmethod static void updateNonWishTimeSheet(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Non_Wish_Events__c nonWishEventId = OrientationandTrainingUtil.CreateEvent(chapterAccount.Id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> nonWishVolunteerOpportunityList =OrientationandTrainingUtil.NewnonWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,nonWishEventId.id,1);
       
    }
    
    public testmethod static void deleteWishTimeSheet(){
        Test.startTest();
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        volunteerCon.MailingLatitude = -24.355798;
        volunteerCon.MailingLongitude = 69.830469;
        volunteerCon.MailingStreet = '7540 E Gold Dust Ave';
        volunteerCon.MailingCountry = 'United States';
        volunteerCon.MailingState = 'Arizona';
        volunteerCon.MailingCity = 'Scottsdale';
        update volunteerCon;
        Case wishCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        wishCase.ChapterName__c = chapterAccount.Id;
        wishCase.contactId = volunteerCon.Id;
        //wishCase.Total_Hour_Spent_Hidden__c = 12.80;
        insert wishCase;
        
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> wishVolOppList = OrientationandTrainingUtil.NewWishVolunteerOpportunityList(volunteerCon.Id,chapterAccount.id,chapterRole.id,wishCase.id,1);
                
        List<Time_sheet__c> newTimeSheet = OrientationandTrainingUtil.crateWishTimeSheet(wishVolOppList);
        //update newTimeSheet;
        List<Time_Sheet__c> deleteTimeSheet = [SELECT ID FROM Time_sheet__c];
        System.debug('Is Timesheet created?: '+deleteTimeSheet.size());
        delete deleteTimeSheet;
        Test.stopTest();
    }
    
    
    private testmethod static void verifyCalculationWish(){
        Test.startTest();
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact volunteerCon = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        volunteerCon.MailingLatitude = -24.355798;
        volunteerCon.MailingLongitude = 69.830469;
        volunteerCon.MailingStreet = '7540 E Gold Dust Ave';
        volunteerCon.MailingCountry = 'United States';
        volunteerCon.MailingState = 'Arizona';
        volunteerCon.MailingCity = 'Scottsdale';
        volunteerCon.Email = 'test@test.com';
        update volunteerCon;
        //User volunteerUser = OrientationandTrainingUtil.CreateActiveVolunteerUser(volunteerCon.Id);
        
        Case wishCase = OrientationandTrainingUtil.CreateParentCaseWithStatus();
        wishCase.ChapterName__c = chapterAccount.Id;
        //wishCase.Total_Hour_Spent_Hidden__c = 12.60;
        wishCase.contactId = volunteerCon.Id;
        insert wishCase;
        
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        Volunteer_Opportunity__c wishVolOpp = OrientationandTrainingUtil.CreateNewWishVolunteerOpportunity(chapterAccount.id,chapterRole.id,wishCase.id);
        wishVolOpp.Volunteer_Name__c = volunteerCon.Id;
        update wishVolOpp;
        
        List<Volunteer_Opportunity__c> OppList = [SELECT Id, Wish__c,Wish__r.Total_Hour_Spent_Hidden__c FROM Volunteer_Opportunity__c WHERE Id =: wishVolOpp.Id];
        
        System.debug('What are list availed here: '+OppList);
        List<Time_sheet__c> newTimeSheet = OrientationandTrainingUtil.crateWishTimeSheet(OppList);
        
        List<Time_sheet__c> updateTimeSheet = new List<Time_sheet__c>();
        for(Time_sheet__c timeSheet : newTimeSheet){
            timeSheet.Hours_spent__c = 1.60;
            timeSheet.Date__c = date.today()-2;
            updateTimeSheet.add(timeSheet);
        }
        update updateTimeSheet;        
        
        
        Time_sheet__c tSheet = [SELECT ID,Hours_Hidden__c FROM Time_Sheet__c];
        //System.assertEquals(10,tSheet.Hours_Hidden__c);
        
        Test.stopTest();
    }
    
    public testmethod static void shareVolunteerOpportunity(){
        
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();   
        Contact wishChild = OrientationandTrainingUtil.CreateWishChild(); 
        Contact VolunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.id);
        Case parentCase = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        User currUser = OrientationandTrainingUtil.createActiveVolunteerUser(VolunteerContact.id);
        Set<Id> caseIdsSet = new Set<Id>();
        Set<Id> volOppIdsSet = new Set<Id>();
        list<Case> subcase = new list<Case>();
        subcase.add(parentCase);
        caseIdsSet.add(parentCase.id);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        List<Volunteer_Opportunity__c> wishVolunteerOpportunityList =OrientationandTrainingUtil.NewWishVolunteerOpportunityList(chapterAccount.id,chapterRole.id,parentCase.id,1);
        List<Volunteer_Opportunity__c> volunteerOpportunityList = new List<Volunteer_Opportunity__c>();
        for(Volunteer_Opportunity__c processVolOpportunities : wishVolunteerOpportunityList){
            processVolOpportunities.Volunteer_Name__c = VolunteerContact.Id;
            volunteerOpportunityList.add(processVolOpportunities);
            volOppIdsSet.add(VolunteerContact.Id);
        }
        update volunteerOpportunityList;
       /* System.RunAs(currUser){
             List<Time_sheet__c> newTimeSheet = OrientationandTrainingUtil.crateWishTimeSheet(volunteerOpportunityList);
       }*/
    }
    
}