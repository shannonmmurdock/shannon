//@isTest
public class TestDataFactory{
    
        public static void createVolunteerContact(Integer count){
         Account chapterAccount = [select Id, Name, RecordTypeId from Account where name LIKE '%Arizona'];

        Constant_AC  constant = new Constant_AC();
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        List<Contact> volunteercontactList  = new List<Contact>();
        for(Integer i =0; i<= count; i++){
            Contact newContact = new Contact();
            newContact.FirstName = 'volunteer' + i;
            newContact.LastName = i + 'test';
            newContact.Birthdate = System.today()-1;
            newContact.Parent_Guardian_Name__c = 'Guardian Test' + i; 
            newContact.RecordTypeId = volunteerRecordTypeId;
            
            newContact.AccountId = chapterAccount.Id;
            volunteercontactList .add(newContact);
        }
        insert volunteercontactList;
    }
    
/* 
  public static void createVolTestRecords(Integer numCons) {

//This  method is used to create a community user and related volunteer contact record
	    
  //Create a Volunteer Contact (prospective) for the Arizona Chapter  
    Account chapterAccount = [select Id, Name, RecordTypeId from Account where name LIKE '%Arizona'];
		
    Constant_AC constant = new Constant_AC();	
		Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        List<Contact> con = new List<Contact>();
    	List<User> volUser = new List<User>();
    	Contact newContact = new Contact();    
    for(Integer i=0;i<numCons;i++) {

        //Contact newContact = new Contact();
        	newContact.FirstName = i + 'Test';
        	newContact.LastName = i + 'Volunteer';
        	newContact.Birthdate = System.today()-1;
        	newContact.Parent_Guardian_Name__c = 'Test Parent' + i; 
        	newContact.RecordTypeId = volunteerRecordTypeId;
        	newContact.Title = 'Mr';
        	newContact.Birth_Month__c = 'January';
        	newContact.Birth_Day__c = '17';
        	newContact.Birth_Year__c = '1986';
        	newContact.Alternate_Phone_Type__c = 'Home';
        	newContact.npe01__PreferredPhone__c = 'Mobile';
        	newContact.OtherPhone = '3332211169';
        	newContact.HomePhone= '9003911427';
        	newContact.MobilePhone= '9003910127';
        	newContact.I_m_on_LinkedIn__c ='Yes';
        	newContact.How_did_you_hear_about_Make_A_Wish__c  = 'Family';
        	newContact.MailingPostalCode = '94106-5188';
        	newContact.MailingStreet = '12' + i + ' Market Street';
        	newContact.MailingCountry = 'United States';
        	newContact.MailingState = 'Arizona';
        	newContact.MailingCity = 'San Francisco';
        	newContact.MailingLatitude = -24.355798;
        	newContact.MailingLongitude = 69.830469;
        	newContact.Emergency_Contact__c  = 'Test Emergency' + i;
        	newContact.Emergency_Contact_Relationship__c= 'Father';
        	newContact.Emergency_Contact_Phone__c  = '9003210426';
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
        	newContact.npe01__Preferred_Email__c = 'test' + i + '@gmail.com';
        	newContact.Email = 'test' + i + '@gmail.com';

            con.add(newContact);
        	//insert newContact;
        	String prospectiveProfileId = label.Prospective_Volunteer_Profile;

  
        	User newProspectiveVolunteerUser = new User(  firstname = newContact.FirstName,lastName = newContact.lastName,email = newContact.Email, Username = newContact.Email,
                                                    EmailEncodingKey = 'ISO-8859-1',Alias = 'jona',TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                                    LanguageLocaleKey = 'en_US',created_from_portal__c = true,ProfileId = prospectiveProfileId,ContactId = newContact.Id,isActive = true,Statecode = 'AZ');
		
        	volUser.add(newProspectiveVolunteer);
			//insert newProspectiveVolunteerUser;
        }
          
*/			
  
}