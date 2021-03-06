//@isTest
//test class to use post sandbox refresh for (prospective) volunteer contact and portal user creation. 
//user with E.Anon : TestDataFactory.createVolTestRecords and specify number of contacts to set as numCons parameter.

public class TestDataFactory3 {

     public static void createVolTestRecords(Integer numCons){
    
        Account chapterAccount = [select Id, Name, RecordTypeId from Account where name LIKE '%Arizona'];
        
        Constant_AC constant = new Constant_AC();	
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        
        List<Contact> VolContact = new List<Contact>();  //list for contacts
        for(Integer i=0; i<numCons;i++) {
        Contact newContact = new Contact();    
        
            newContact.FirstName = 'BTest';
            newContact.LastName = 'BVolunteer' + i;
            newContact.Birthdate = System.today()-1;
            newContact.Parent_Guardian_Name__c = 'BTest Parent' + i; 
            newContact.RecordTypeId = volunteerRecordTypeId;
            newContact.Title = 'Mr';
            newContact.Birth_Month__c = 'January';
            newContact.Birth_Day__c = '23';
            newContact.Birth_Year__c = '1985';
            newContact.Alternate_Phone_Type__c = 'Home';
            newContact.npe01__PreferredPhone__c = 'Mobile';
            newContact.OtherPhone = '3232211569';
            newContact.HomePhone= '9025914427';
            newContact.MobilePhone= '9013510127';
            newContact.I_m_on_LinkedIn__c ='Yes';
            newContact.How_did_you_hear_about_Make_A_Wish__c  = 'Family';
            newContact.MailingPostalCode = '94106-5188';
            newContact.MailingStreet = '15 B Market Street';
            newContact.MailingCountry = 'United States';
            newContact.MailingState = 'Arizona';
            newContact.MailingCity = 'San Francisco';
            newContact.MailingLatitude = -24.355798;
            newContact.MailingLongitude = 69.830469;
            newContact.Emergency_Contact__c  = 'Test EmergencyB';
            newContact.Emergency_Contact_Relationship__c= 'Father';
            newContact.Emergency_Contact_Phone__c  = '9003215476';
            newContact.Read__c  = 'English';
            newContact.language__c = 'English';
            newContact.speak__c = 'English';
            newContact.understand__c = 'English';
            newContact.Professional_Skills__c = 'Photography';
            newContact.Language_Notes__c = 'Test';
            //newContact.Volunteer_Role__c = 'Special Events';
            newContact.is_Application__c ='Partial Submit';
            newContact.AccountId = chapterAccount.Id;
            newContact.Volunteer_Role__c = 'Wish Granter';
            newContact.npe01__Preferred_Email__c = i + 'testB@gmail.com';
            newContact.Email = i + 'testB@gmail.com';
            
			volContact.add(newContact);
         
        insert newContact;
        
        //system.debug('new contact: ' + newContact.Id);
        //Create related USER account with Prospective Volunteer Profile 
        
        String prospectiveProfileId = label.Prospective_Volunteer_Profile;
        
        User volUser = new User();
            volUser.firstname = newContact.FirstName;
            volUser.lastName = newContact.lastName;
			volUser.email = newContact.Email;
			volUser.Username = newContact.Email;
            volUser.EmailEncodingKey = 'ISO-8859-1';
			volUser.Alias = newContact.FirstName.substring(0,2) + newContact.LastName.substring(0,2);
			volUser.TimeZoneSidKey = 'America/Los_Angeles';
			volUser.LocaleSidKey = 'en_US';
			volUser.LanguageLocaleKey = 'en_US';
			volUser.created_from_portal__c = true;
			volUser.ProfileId = prospectiveProfileId;
			volUser.ContactId = newContact.Id;
			volUser.isActive = true;
			volUser.Statecode = 'AZ';
            
			insert volUser;

		string accountid = chapterAccount.id;
		string password = null;

		string userid = site.createportaluser(volUser, accountid, password);
		system.debug(userid);

        }

     }


}