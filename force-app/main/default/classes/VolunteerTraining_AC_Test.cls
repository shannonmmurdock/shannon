//Unit Test for Volunteer Training.

@isTest
Public class VolunteerTraining_AC_Test {
    // Complete the Volunteer Training.
    static testmethod void CreatingCompletedTraining() 
    {
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         Role__c currRole = OrientationandTrainingUtil.createRole();
         Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
         Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
         Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
         Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
         Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
         Volunteer_Orientation_Training__c  createVolOrientation = VolunteerTraining_AC_Test.createVolOrientation(currOandT.id,currOffering.id,con.id,'Completed');
               
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
              
          }
         System.RunAs(currUser)
         {
                System.assertEquals(currOffering.id,createVolOrientation.class_offering__c);
                TestClassUtil.createDynamicContent();
                PageReference pageRef = Page.VolunteerTraining_VF; 
                Test.setCurrentPage(pageRef);
                VolunteerTraining_AC controller = new VolunteerTraining_AC();
                controller.TimingInfo();
                controller.getTrainingRecordList();
                controller.trainingId = currOffering.id;
         }
        
    }
    // Display Class OFfering on Portal.
    static testmethod void VolunteerTrainingDisplay() 
    {
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         Role__c currRole = OrientationandTrainingUtil.createRole();
         Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
         Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
         Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
         Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
         Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
         Volunteer_Orientation_Training__c  createVolOrientation = VolunteerTraining_AC_Test.createVolOrientation(currOandT.id,currOffering.id,con.id,'Registered');
               
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
            {
               
                System.assertEquals(currOffering.id,createVolOrientation.class_offering__c);
                
                TestClassUtil.createDynamicContent();
                PageReference pageRef = Page.VolunteerTraining_VF; 
                Test.setCurrentPage(pageRef);
                
                VolunteerTraining_AC controller = new VolunteerTraining_AC();
                controller.TimingInfo();
                controller.getTrainingRecordList();
                controller.trainingId = currOffering.id;
                controller.Register();         
            }
    }
     // Register for new Training.
    static testmethod void CreateNewTraining() 
    {
    LMS_Credentials__c currLMSCredential = testClassUtil.createLMSCredentials();
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         Role__c currRole = OrientationandTrainingUtil.createRole();
         Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
         Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
         Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
         Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
         Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
                              
         User currUser;
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
            {
               
                              
                TestClassUtil.createDynamicContent();
                PageReference pageRef = Page.VolunteerTraining_VF; 
                Test.setCurrentPage(pageRef);
                
                VolunteerTraining_AC controller = new VolunteerTraining_AC();
                controller.TimingInfo();
                controller.getTrainingRecordList();
                controller.trainingId = currOffering.id;
                controller.Register();         
            }
    }
    // Creating Training with Cancelled status.
    static testmethod void CreatingCancelledTraining() 
    {
    LMS_Credentials__c currLMSCredential = testClassUtil.createLMSCredentials();
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
        Role__c currRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
        Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
        Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
        Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
        Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
        Volunteer_Orientation_Training__c  createVolOrientation = VolunteerTraining_AC_Test.createVolOrientation(currOandT.id,currOffering.id,con.id,'Volunteer Cancelled');              
                              
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
            {
               
                TestClassUtil.createDynamicContent();
                PageReference pageRef = Page.VolunteerTraining_VF; 
                Test.setCurrentPage(pageRef);
                
                VolunteerTraining_AC controller = new VolunteerTraining_AC();
                controller.TimingInfo();
                controller.getTrainingRecordList();
                controller.trainingId = currOffering.id;
               // controller.Register();         
            }
    }
      // Cancel Registered Training.
    static testmethod void CancelTraining() 
    {
    LMS_Credentials__c currLMSCredential = testClassUtil.createLMSCredentials();
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
         Role__c currRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
        Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
        Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
        Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
        Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
        Volunteer_Orientation_Training__c  createVolOrientation = VolunteerTraining_AC_Test.createVolOrientation(currOandT.id,currOffering.id,con.id,'Registered');              
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
            {
               
                              
                TestClassUtil.createDynamicContent();
                PageReference pageRef = Page.VolunteerTraining_VF; 
                Test.setCurrentPage(pageRef);
                
                VolunteerTraining_AC controller = new VolunteerTraining_AC();
                controller.TimingInfo();
                controller.getTrainingRecordList();
                controller.trainingId = currOffering.id;
                controller.Cancel();         
            }
    }
   
   // Duplicate Training time prevention.
   static testmethod void BookingTrainingwithSameTime() 
    {
         Account acc = OrientationandTrainingUtil.createVolunteerAccount();
         Contact con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         OrientationandTrainingUtil.createAffiliation(con.id);
         User currUser;
          Role__c currRole = OrientationandTrainingUtil.createRole();
        Chapter_Role__c  currChapRole = OrientationandTrainingUtil.createChapter(acc.id,currRole.id);
        Volunteer_Roles__c currVolRole = OrientationandTrainingUtil.createVolRole(con.id,currChapRole.id);
       
        Orientation_Training__c  currOandT = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
        Chapter_Role_O_T__c currChapOandT = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT.id);
        Class_Offering__c currOffering = OrientationandTrainingUtil.createClassOffering(currChapOandT.id);
        Volunteer_Orientation_Training__c  createVolOrientation = VolunteerTraining_AC_Test.createVolOrientation(currOandT.id,currOffering.id,con.id,'Registered');              
                  
        Orientation_Training__c  currOandT1 = OrientationandTrainingUtil.CreateVolunteerTrainingRecord();
        Chapter_Role_O_T__c currChapOandT1 = OrientationandTrainingUtil.createChapterOandT(currChapRole.id,currOandT1.id);
        Class_Offering__c currOffering1 = OrientationandTrainingUtil.createClassOffering(currChapOandT1.id);
                
         System.RunAs(new User(Id = UserInfo.getUserId()))
          {
              currUser = OrientationandTrainingUtil.createProspectiveVolunteerUser(con.id);
          }
         System.RunAs(currUser)
            {
              
                              
                TestClassUtil.createDynamicContent();
                PageReference pageRef = Page.VolunteerTraining_VF; 
                Test.setCurrentPage(pageRef);                
                System.currentPageReference().getParameters().put('bgRequired', 'true');
                System.currentPageReference().getParameters().put('trainingRequired', 'false');
                VolunteerTraining_AC controller = new VolunteerTraining_AC();
                controller.TimingInfo();
                controller.getTrainingRecordList();
                controller.trainingId = currOffering1.id;
                controller.Register(); 
                controller.Next();
                controller.Beginning();
                controller.getPageNumber();
                controller.getTotalPages();
                controller.End();
                controller.getDisableNext();
                controller.Beginning();
                controller.Previous();
                controller.getDisablePrevious();
                VolunteerTraining_AC.updateUser('3497181','test.prod@mail.com','test.prod@mail.com','0051F0000015C98');
           
            }
    }
   // Creating Volunteer Training for volunteer based on the input parameter.
    static Volunteer_Orientation_Training__c createVolOrientation(Id OrienationId, Id ClassOfferingId,Id volunteer,string status)
    {
        Volunteer_Orientation_Training__c createNewVol = new Volunteer_Orientation_Training__c();
        createNewVol.class_offering__c = ClassOfferingId;
        createNewVol.Hidden_O_T_Id__c = OrienationId;
        createNewVol.Registered_Date__c = Date.Today();
        createNewVol.Volunteer__c = volunteer;
        createNewVol.Volunteer_Attendance__c = status;
        createNewVol.Type__c = 'Training';
        insert createNewVol;
        return createNewVol;
    }
    
static testmethod void CheckViewLMS(){
        Account acc;
        Contact con;
        LMS_Credentials__c currLMSCredential;
        User currUser;
       
         acc = OrientationandTrainingUtil.createVolunteerAccount();
         con = OrientationandTrainingUtil.createVolunteerContact(acc.id);
         currLMSCredential = testClassUtil.createLMSCredentials();
         OrientationandTrainingUtil.createAffiliation(con.id);     
         
         System.RunAs(new User(Id = UserInfo.getUserId()))
         {
            testClassUtil.createUser();   
            testClassUtil.createUser(); 
         }
        List<User> currUserLst = [SELECT ID FROM USER WHERE ID != : Userinfo.getUserId() AND isActive=True];
        System.RunAs(currUserLst[0]){            
              
            LMSCourseSyncMockImpl currLMSCourseSyncMockImpl = new LMSCourseSyncMockImpl();
            HttpResponse response = new HttpResponse();
            response.setStatus('OK');
            response.setStatusCode(200);
            LMSUserResponse currLMSUserResponse =  new LMSUserResponse();
            currLMSUserResponse.id = 1234;
            currLMSUserResponse.login = 'test@test.com';
            currLMSUserResponse.code = 'test@test.com';
            currLMSUserResponse.first_name = 'test';
            currLMSUserResponse.last_name = 'test';
            currLMSUserResponse.last_name = 'test@test.com';
            currLMSUserResponse.is_active = true;
            currLMSUserResponse.last_login_at = '2016-08-04T19:20:05.407-04:00';        
            String payload = JSON.serialize(currLMSUserResponse);  
            response.setBody(payload);
            currLMSCourseSyncMockImpl.addResponse(response);
            Test.setMock(HttpCalloutMock.class, currLMSCourseSyncMockImpl);
        }  
        Test.startTest();
         System.RunAs(currUserLst[1]){
                PageReference pageRef = Page.VolunteerTraining_VF; 
                Test.setCurrentPage(pageRef);
                VolunteerTraining_AC controller = new VolunteerTraining_AC();                
                controller.lMSCourseId = 'Test';                
                controller.viewLMS(); 
                controller.getLMSSSODetails('1234');
                VolunteerTraining_AC.updateUser('3497181','test.prod@mail.com','test.prod@mail.com',currUserLst[1].Id);
                                      
            }
        Test.stopTest();
    }
}