@isTest
public class ConflictOfInterestTrigger_AT_Test{
    // Mapping fields.
    public static testMethod void createConflictOfInterest(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        Conflict_Of_Interest__c  coiRec = OrientationandTrainingUtil.createCOI(volunteerContact.Id);
    }
    
    public static testMethod void updateConflictOfInterest(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        volunteerContact.Region_Chapter__C=chapterAccount.Id;
        Update volunteerContact;
        Conflict_Of_Interest__c  coiRec = OrientationandTrainingUtil.createCOI(volunteerContact.Id);
        coiRec.Expiration_Date__c = Date.Today().addYears(1);
        update coiRec;
    }
    
    public static testMethod void nationalStaffConflictOfInterest(){
        Chapter_Vs_Role__c arizonaChap = OrientationandTrainingUtil.createArizonaChapter();
        Chapter_Vs_Role__c alabamaChap = OrientationandTrainingUtil.createAlabamaChapter();
        Insert alabamaChap;
        Insert arizonaChap;
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact; // = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        
        
        
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        User nationalStaff;
        System.RunAs(currUser)
        {   
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
        }
        
        System.runAs(nationalStaff) {
            
            volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
            volunteerContact.Region_Chapter__C=chapterAccount.Id;
            Update volunteerContact;
            Role__c newR = new Role__c(Name = 'Wish Granter');
            Insert newR;
            Chapter_Role__c newCR = new Chapter_Role__c(Role_Name__c = newR.Id, Chapter_Name__c = chapterAccount.Id);
            insert newCR;
            Volunteer_Roles__c newVR = new Volunteer_Roles__c(Volunteer_Name__c = volunteerContact.Id, Status__c = 'Out of Compliance', Chapter_Role__c = newCR.Id);
            insert newVR;
            Background_check__c newBg = new Background_check__c(Volunteer__c = volunteerContact.Id,Current__c = TRUE, Date__c = Date.today().addDays(-10), Date_Completed__c = Date.today().addDays(-50), Status__c = 'Completed');
            insert newBg;
            newBg.Date__c = Date.today().addDays(-11);
            update newBg;
            Conflict_Of_Interest__c newCOI1 = new Conflict_Of_Interest__c();
            newCOI1.Volunteer_Contact__c = volunteerContact.Id;
            newCOI1.Expiration_Date__c = system.today() + 3;
            newCOI1.Current__C = True;
            insert newCOI1;
        }
        System.runAs(nationalStaff) {
            Conflict_Of_Interest__c newCOI = new Conflict_Of_Interest__c();
            newCOI.Volunteer_Contact__c = volunteerContact.Id;
            newCOI.Expiration_Date__c = system.today() + 3;
            newCOI.Current__C = True;
            newCOI.Account_Name__c = chapterAccount.Id;
            newCOI.OwnerId = nationalStaff.Id;
            insert newCOI;
        }
    }
    public static testMethod void UpdateOwnerConflictOfInterest(){
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        volunteerContact.Region_Chapter__C=chapterAccount.Id;
        Update volunteerContact;
        Conflict_Of_Interest__c newCOI = new Conflict_Of_Interest__c();
        newCOI.Volunteer_Contact__c = volunteerContact.Id;
        newCOI.Expiration_Date__c = system.today() + 3;
        newCOI.Signed_Date__c = system.today()-2;
        newCOI.Current__C = False;
        insert newCOI;
        
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1];
        User nationalStaff;
        System.RunAs(currUser)
        {   
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id);
        }
        
        System.runAs(nationalStaff) {
            newCOI.OwnerId=nationalStaff.Id;
            newCOI.Signed_Date__c = system.today();
            newCOI.HiddenConflictExpire__c = True;
            
            newCOI.Current__C = True;
            Update newCOI;
        }
    }
}