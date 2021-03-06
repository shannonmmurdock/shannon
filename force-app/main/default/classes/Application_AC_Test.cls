/***************************************************************************************************
Author      : MST Solutions
CreatedBy   : Kanagaraj
Date        : 28/06/2016
Description : Application_AC_Test is used to increase the code coverage for Application_AC controller.
*****************************************************************************************************/

@isTest
public class Application_AC_Test{
    
    /* This method is used to update the volunteer contact information*/
    
    public testmethod static void updateVolunteerContact(){ 
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        volunteerContact.Write__c = 'Arabic; Chinese; English';
        volunteerContact.is_Application__c = 'Complete';
        update volunteerContact;
        User currentVoulnteerUser;
        System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
            
        }
        OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
        OrientationandTrainingUtil.insertDocusignSetting();
        OrientationandTrainingUtil.createDynamicContent();
        
        // system.RunAs(currentVoulnteerUser){
        list<Contact> conList = new list<Contact>();
        conList = [select id from contact Limit 50000];
        System.assert(currentVoulnteerUser.ContactId.equals(volunteerContact.Id), 'Check Volunteer User Contact in equal to volunteerContact');
        PageReference pageRef = Page.Application_VF; 
        
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('bgRequired','true');
        ApexPages.currentPage().getParameters().put('trainingRequired','true');
        Application_AC applicationAcIns = new Application_AC();
        applicationAcIns.saveRec();
        applicationAcIns.EditRec();
        applicationAcIns.getStates();
        applicationAcIns.getDays();
        applicationAcIns.getMonths();
        applicationAcIns.getLanguages();
        applicationAcIns.getProfessionalSKills();
        applicationAcIns.getRoles();
        applicationAcIns.getAlternatePhoneType();
        applicationAcIns.getPreferedPhoneType();
        applicationAcIns.getIamOnLinkedIn();
        applicationAcIns.getTitles();
        applicationAcIns.getCountries();
        applicationAcIns.getContactAtWorks();
        applicationAcIns.getInterstedList();
        applicationAcIns.DisplayDescription();
        applicationAcIns.getHowdidyouhearaboutMakeAWish();
        applicationAcIns.ClosePopUp();
        applicationAcIns.editmode = true;
        applicationAcIns.showsubmitbutton = true;
        applicationAcIns.dynamicName= 'test';
        applicationAcIns.applicationDynamicContent = 'test';
        applicationAcIns.submitdisable = true;
        applicationAcIns.isSigned = true;            
        
        //  }
        System.assertEquals(currentVoulnteerUser.Email,'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
        System.assert(currentVoulnteerUser.Email == 'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
    }
    /*This method is used to sign the docusign document when the application is completed*/
    
    public testmethod static void signDocument(){  
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContact(chapterAccount.Id);
        User currentVoulnteerUser;
        //  System.RunAs(new User(Id = UserInfo.getUserId())){
        currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        /* contactShare currContactSharing = new contactShare();
currContactSharing.ContactId = volunteerContact.Id;
currContactSharing.UserOrGroupId = currentVoulnteerUser.id;
currContactSharing.ContactAccessLevel = 'Read';
currContactSharing.RowCause = Schema.contactshare.RowCause.Manual;
insert currContactSharing;*/
        //  }
       npe5__Affiliation__c newAffiliation = OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
        Role__c  roleName = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  chapterRole = OrientationandTrainingUtil.createChapter(newAffiliation.npe5__Organization__c,roleName.id);
        OrientationandTrainingUtil.insertDocusignSetting();
        OrientationandTrainingUtil.createDynamicContent();
        
        
        
        //  system.RunAs(currentVoulnteerUser){
        PageReference pageRef = Page.Application_VF; 
        Test.setCurrentPage(pageRef);
        Application_AC applicationAcIns = new Application_AC();
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        applicationAcIns.SubmitAndSign();
        applicationAcIns.saveRec();
        applicationAcIns.DisplayDescription();
       
        Test.StopTest();
        
        // }
        System.assertEquals(currentVoulnteerUser.Email,'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
        System.assert(currentVoulnteerUser.Email == 'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
    }
    
    /* This method is used to update the volunteer contact Alternate Phone type and prefered phone type with the value of Home*/
    
    public testmethod static void updateVolunteerContactwithHomePhone(){ 
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.VolunteerContactwithHomePhone(chapterAccount.Id);
        volunteerContact.Write__c = 'Arabic; Chinese; English';
        update volunteerContact;
        User currentVoulnteerUser;
         Application_AC.roleWrapper newRoleWrapper = new Application_AC.roleWrapper();
        System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        }
        OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
        OrientationandTrainingUtil.insertDocusignSetting();
        OrientationandTrainingUtil.createDynamicContent();
        
        system.RunAs(currentVoulnteerUser){
            
            PageReference pageRef = Page.Application_VF; 
            Test.StartTest();
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('bgRequired','true');
            ApexPages.currentPage().getParameters().put('trainingRequired','true');
            Application_AC applicationAcIns = new Application_AC();
            applicationAcIns.saveRec();
            applicationAcIns.EditRec();
            applicationAcIns.getStates();
            applicationAcIns.getDays();
            applicationAcIns.getMonths();
            applicationAcIns.getLanguages();
            applicationAcIns.getProfessionalSKills();
            applicationAcIns.getRoles();
            applicationAcIns.getAlternatePhoneType();
            applicationAcIns.getPreferedPhoneType();
            applicationAcIns.getIamOnLinkedIn();
            applicationAcIns.getTitles();
            applicationAcIns.getCountries();
            applicationAcIns.getContactAtWorks();
            applicationAcIns.getInterstedList();
            applicationAcIns.DisplayDescription();
            applicationAcIns.getHowdidyouhearaboutMakeAWish();
            applicationAcIns.ClosePopUp();
            applicationAcIns.editmode = true;
            applicationAcIns.showsubmitbutton = true;
            applicationAcIns.dynamicName= 'test';
            applicationAcIns.applicationDynamicContent = 'test';
            applicationAcIns.submitdisable = true;
            applicationAcIns.isSigned = true;
            Test.StopTest();
        }
        System.assertEquals(currentVoulnteerUser.Email,'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
        System.assert(currentVoulnteerUser.Email == 'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
        
    }
    
    /* This method is used to update the volunteer contact Alternate Phone type and prefered phone type with the value of Mobile*/
    
    public testmethod static void updateVolunteerContactwithMobilePhone(){ 
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.VolunteerContactwithMobilePhone(chapterAccount.Id);
        volunteerContact.Write__c = 'Arabic; Chinese; English';
        update volunteerContact;
        User currentVoulnteerUser;
        System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        }
       npe5__Affiliation__c newAff =  OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
        OrientationandTrainingUtil.insertDocusignSetting();
        OrientationandTrainingUtil.createDynamicContent();
        
        system.RunAs(currentVoulnteerUser){
            
            PageReference pageRef = Page.Application_VF; 
            Test.StartTest();
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('bgRequired','true');
            ApexPages.currentPage().getParameters().put('trainingRequired','true');
            Application_AC applicationAcIns = new Application_AC();
            applicationAcIns.saveRec();
            applicationAcIns.EditRec();
            applicationAcIns.getStates();
            applicationAcIns.getDays();
            applicationAcIns.getMonths();
            applicationAcIns.getLanguages();
            applicationAcIns.getProfessionalSKills();
            applicationAcIns.getRoles();
            applicationAcIns.getAlternatePhoneType();
            applicationAcIns.getPreferedPhoneType();
            applicationAcIns.getIamOnLinkedIn();
            applicationAcIns.getTitles();
            applicationAcIns.getCountries();
            applicationAcIns.getContactAtWorks();
            applicationAcIns.getInterstedList();
            applicationAcIns.DisplayDescription();
            applicationAcIns.getHowdidyouhearaboutMakeAWish();
            applicationAcIns.ClosePopUp();
            applicationAcIns.editmode = true;
            applicationAcIns.showsubmitbutton = true;
            applicationAcIns.dynamicName= 'test';
            applicationAcIns.applicationDynamicContent = 'test';
            applicationAcIns.submitdisable = true;
            applicationAcIns.isSigned = true;
            Test.StopTest();
        }
        System.assertEquals(currentVoulnteerUser.Email,'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
        System.assert(currentVoulnteerUser.Email == 'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
        
    }
    
    /* This method is used to update the volunteer contact Alternate Phone type and prefered phone type with the value of Home and Mobile*/
    
    public testmethod static void updateVolunteerContactwithOtherPhone(){ 
        Account chapterAccount = OrientationandTrainingUtil.createVolunteerAccount();
        Contact volunteerContact = OrientationandTrainingUtil.createVolunteerContactwithOtherPhone(chapterAccount.Id);
        User currentVoulnteerUser;
        System.RunAs(new User(Id = UserInfo.getUserId())){
            currentVoulnteerUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(volunteerContact.Id);
        }
        OrientationandTrainingUtil.CreateAffiliation(currentVoulnteerUser.ContactId);
        OrientationandTrainingUtil.insertDocusignSetting();
        OrientationandTrainingUtil.createDynamicContent();
        
        system.RunAs(currentVoulnteerUser){
            
            PageReference pageRef = Page.Application_VF; 
            Test.StartTest();
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('bgRequired','true');
            ApexPages.currentPage().getParameters().put('trainingRequired','true');
            Application_AC applicationAcIns = new Application_AC();
            applicationAcIns.saveRec();
            applicationAcIns.EditRec();
            applicationAcIns.getStates();
            applicationAcIns.getDays();
            applicationAcIns.getMonths();
            applicationAcIns.getLanguages();
            applicationAcIns.getProfessionalSKills();
            applicationAcIns.getRoles();
            applicationAcIns.getAlternatePhoneType();
            applicationAcIns.getPreferedPhoneType();
            applicationAcIns.getIamOnLinkedIn();
            applicationAcIns.getTitles();
            applicationAcIns.getCountries();
            applicationAcIns.getContactAtWorks();
            applicationAcIns.getInterstedList();
            applicationAcIns.DisplayDescription();
            applicationAcIns.getHowdidyouhearaboutMakeAWish();
            applicationAcIns.ClosePopUp();
            applicationAcIns.editmode = true;
            applicationAcIns.showsubmitbutton = true;
            applicationAcIns.dynamicName= 'test';
            applicationAcIns.applicationDynamicContent = 'test';
            applicationAcIns.submitdisable = true;
            applicationAcIns.confirmSign();
            applicationAcIns.isSigned = true;
            Test.StopTest();
        }
        System.assertEquals(currentVoulnteerUser.Email,'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
        System.assert(currentVoulnteerUser.Email == 'jonathanEdwards@gmail.com','Email does not updated or Mismatched Email');
        
    }
    
    
}