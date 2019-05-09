//@isTest
public class TestDataFactory2{
    
    public static void createVolTestRecords(Integer numCons) {
        
        /*This  method is used to create a community user and related volunteer contact record*/
        
        //Create a Volunteer Contact (prospective) for the Arizona Chapter  
        Account chapterAccount = [select Id, Name, RecordTypeId from Account where name LIKE '%Arizona'];
        
        Constant_AC constant = new Constant_AC();	
        Id volunteerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.volunteerRT).getRecordTypeId();
        List<Contact> con = new List<Contact>();
        //Contact newContact = new Contact();    
        for(Integer i=0;i<numCons;i++) {
            con.add(new Contact(FirstName = i + 'Testy',LastName = i + 'Volunteer',Birthdate = System.today()-1,Parent_Guardian_Name__c = 'Testy Parent' + i,RecordTypeId = volunteerRecordTypeId,Title = 'Mr',Birth_Month__c = 'January',Birth_Day__c = (i + '1'),Birth_Year__c = '1988',Alternate_Phone_Type__c = 'Home',npe01__PreferredPhone__c = 'Mobile',OtherPhone = '3332211369',
                               HomePhone= '9003911437',MobilePhone= '9003910127',I_m_on_LinkedIn__c ='Yes',How_did_you_hear_about_Make_A_Wish__c  = 'Family',MailingPostalCode = '94106-5188',MailingStreet = '10' + i + ' Market A Street',MailingCountry = 'United States',MailingState = 'Arizona',MailingCity = 'Phoenix',MailingLatitude = -24.355798,MailingLongitude = 69.830469,
                               Emergency_Contact__c  = 'Testy Emergency' + i,Emergency_Contact_Relationship__c= 'Father',Emergency_Contact_Phone__c  = '9013211426',Read__c  = 'English',language__c = 'English',speak__c = 'English',understand__c = 'English',Professional_Skills__c = 'Photography',Language_Notes__c = 'Test',is_Application__c ='Partial Submit',
                               AccountId = chapterAccount.Id,Volunteer_Role__c = 'Wish Granter',npe01__Preferred_Email__c = 'testy' + i + '@gmail.com',Email = 'testy' + i + '@gmail.com'));
            //Contact newContact = new Contact();
            /*newContact.FirstName = i + 'Test';
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
            
            con.add(newContact);*/
        }
        insert con;
        
        //system.debug('new contact: ' + newContact.Id);
        //Create related USER account with Prospective Volunteer Profile 
        
        String prospectiveProfileId = label.Prospective_Volunteer_Profile;
        
        List<User> volUser = new List<User>();    
        for (Integer i=0;i<numCons;i++){
            volUser.add(new User(firstname = con[0].FirstName,lastName = con[0].lastName,email = con[0].Email, Username = con[0].Email,
                                 EmailEncodingKey = 'ISO-8859-1',Alias = con[0].FirstName.substring(0,2) + con[0].LastName.substring(0,2),TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey = 'en_US',
                                 LanguageLocaleKey = 'en_US',created_from_portal__c = true,ProfileId = prospectiveProfileId,ContactId = con[0].Id,isActive = true,Statecode = 'AZ'));
            
            }
        //User chapterUser = [SELECT Id,UserName,ProfileId,Profile.Name,Email FROM User WHERE Profile.Name  =: 'System Administrator' LIMIT 1];        
        //System.runAs(chapterUser){
        //    try{
       //         insert volUser;}
       //     catch(exception ex){
      //      }
      //  }
        //insert volUser;
        }
        
    }