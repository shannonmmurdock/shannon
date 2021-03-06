/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : BackGroundCheck_AT_Test is used to increase the code coverage for Application_AC controller.
*****************************************************************************************************/
@isTest
public class BackGroundCheck_AT_Test {
    
    
    /*This method is used to update the background check record to approved*/
    
    public testmethod static void UpdateBackGroundChecktoApproved(){  
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.Id);
        Role__c  role = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(volunteerAccount.Id,role.Id);
        Volunteer_Roles__c volunteerRole = OrientationandTrainingUtil.createVolRole(volunteerContact.Id,chapterRole.Id);
        Volunteer_Roles__c volunteerRoleRec = OrientationandTrainingUtil.createVolRole(volunteerContact.Id,chapterRole.Id);
        Orientation_Training__c  orientationId = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
        Chapter_Role_O_T__c chapterRoleT = OrientationandTrainingUtil.createChapterOandT (chapterRole.Id,orientationId.id);
        npe5__Affiliation__c  orgAfflitation = OrientationandTrainingUtil.CreateAffiliationwithAccount(volunteerContact.Id,volunteerAccount.Id);
        OrientationandTrainingUtil.createCOI(volunteerContact.Id);
        Background_check__c  backgroundcheck = OrientationandTrainingUtil.createBackgroundCheck(volunteerContact.id);        
        
        backgroundcheck.Status__c = 'Approved';
        backgroundcheck.current__c = true;
        backgroundcheck.Date_Completed__c = system.today();
        update backgroundcheck; 
        
    }
    
    /*This method is used to update the background check record to Rejected*/
    
    public testmethod static void UpdateBackGroundChecktoRejected(){  
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.Id);
        Background_check__c  backgroundcheck = OrientationandTrainingUtil.createBackgroundCheckFasleRec(volunteerContact.id);
        
        backgroundcheck.Status__c = 'Rejected';
        backgroundcheck.Hidden_Background_Rejected__c = true;
        backgroundcheck.HiddenBackgroundExpire__c = true;
        update backgroundcheck; 
        
        backgroundcheck.Hidden_Background_Rejected__c = false;
        update backgroundcheck;
        
        backgroundcheck.Status__c = 'Received from First Advantage';
        update backgroundcheck;
    }
    /*This method is used to create background check record*/
    
    public testmethod static void CreateBackGroundCheckRecord(){  
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.Id);
        OrientationandTrainingUtil.createBackgroundCheckRec(volunteerContact.Id);
        Background_check__c  backgroundcheck = OrientationandTrainingUtil.createBackgroundCheckActiveRec(volunteerContact.id);
        
        
    }
    
    /*This method is used to create background check record to Active*/
    
    public testmethod static void updateBackgroundChecktoActive(){  
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.Id);
        Background_check__c  backgroundcheck = OrientationandTrainingUtil.createBackgroundCheckActiveRec(volunteerContact.id);
        Background_check__c  backgroundcheckfalse = OrientationandTrainingUtil.createBackgroundCheckFasleRec(volunteerContact.Id);
        backgroundcheckfalse.current__c= true;
        backgroundcheckfalse.Date_Completed__c = system.today() + 9;
        Database.SaveResult result = Database.update(backgroundcheckfalse,false);
        //System.assertEquals('Active Background Check Already Exist',result.getErrors()[0].getMessage());
        
    }
    
    /*This method is used to create background check exisiting background record is Active or not*/
    
    public testmethod static void CheckExisitingRecordtoActive(){  
        Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.Id);
        Background_check__c  backgroundcheck = OrientationandTrainingUtil.createBackgroundCheckActiveRec(volunteerContact.id);
        Background_check__c  backgroundcheckActive = OrientationandTrainingUtil.createBackgroundCheckActiveRec(volunteerContact.id);
        Background_check__c  backgroundcheckfalse = OrientationandTrainingUtil.createBackgroundCheckFasleRec(volunteerContact.Id);
        backgroundcheckfalse.current__c= true;
        backgroundcheckfalse.Date_Completed__c = system.today() + 9;
        Database.SaveResult result = Database.update(backgroundcheckfalse,false);
        //System.assertEquals('Active Background Check Already Exist',result.getErrors()[0].getMessage());
        
    }
    
    
    private testmethod static void createBackgroundCheckNationalStaff(){  
        
        
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1]; 
        User nationalStaff;
        System.RunAs(currUser)
        {     
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id); 
        }
        System.runAs(nationalStaff) {          
            Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.Id);
            volunteerContact.Region_Chapter__c = volunteerAccount.Id;
            Update volunteerContact;
            
            Background_check__c backCheck = new Background_check__c();
            backCheck.Date__c = system.today() + 3;
            backCheck.Volunteer__c = volunteerContact.Id;
            backCheck.Status__c = 'Manual';
            backCheck.current__c = true;
            backCheck.Date_Completed__c = system.today() + 9;
            backCheck.OwnerId=nationalStaff.Id;
            insert backCheck;
            
        }
        
        
        //System.assertEquals('Active Background Check Already Exist',result.getErrors()[0].getMessage());
        
    }
    
    
    private testmethod static void createBackgroundCheckNonNationalStaff(){  
        
        
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        Id staffProfileId = [SELECT Id FROM Profile WHERE Name = 'Program Staff'].Id;
        User nonNationalStaff;
        System.RunAs(currUser)
        {     
            nonNationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id); 
            nonNationalStaff.UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'Alabama - chapter'].Id;
            nonNationalStaff.ProfileId = staffProfileId;
            update nonNationalStaff;
        }
        System.runAs(nonNationalStaff) {          
            Account volunteerAccount = OrientationandTrainingUtil.createVolunteerAccount();
            Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(volunteerAccount.Id);
            Background_check__c backCheck = new Background_check__c();
            backCheck.Date__c = system.today() + 3;
            backCheck.Volunteer__c = volunteerContact.Id;
            backCheck.Status__c = 'test';
            backCheck.current__c = true;
            backCheck.Date_Completed__c = system.today() + 9;
            backCheck.OwnerId=nonNationalStaff.Id;
            insert backCheck;
            
        }
        
        
        //System.assertEquals('Active Background Check Already Exist',result.getErrors()[0].getMessage());
        
    }
    
    private testmethod static void checkVolOpp(){
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
        insert wishCase;
        
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(chapterAccount.Id,roleName.id);
        Volunteer_Opportunity__c wishVolOpp = OrientationandTrainingUtil.CreateNewWishVolunteerOpportunity(chapterAccount.id,chapterRole.id,wishCase.id);
        wishVolOpp.Status__c = 'Approved';
        wishVolOpp.Volunteer_Name__c = volunteerCon.Id;
        update wishVolOpp;
       
        Test.startTest();
        Volunteer_Roles__c volRole = OrientationandTrainingUtil.createVolRole(volunteerCon.id, chapterRole.Id);     
        Background_check__c  backgroundcheck = OrientationandTrainingUtil.createBackgroundCheckFasleRec(volunteerCon.id);
        backgroundcheck.Hidden_Background_Rejected__c = false;
        update backgroundcheck; 
        
        backgroundcheck.Hidden_Background_Rejected__c = true;
        update backgroundcheck;
        
        Test.stopTest();
    }
}