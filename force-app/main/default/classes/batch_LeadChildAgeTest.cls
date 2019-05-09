@isTest
public class batch_LeadChildAgeTest{
    
    @testSetup
    static void setup() {
        Account chapterAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Condition_Description__c descrip = OrientationandTrainingUtil.createConditionDesCription(); 
        insert descrip;
        ICD_Codes__c icdCode = OrientationandTrainingUtil.createICDCode(descrip.Id);
        insert icdCode;
        date childDOB = Date.parse(String.valueOf(System.today().month())+'/'+String.valueOf(System.today().day())+'/'+String.valueOf(System.today().year()-2));  
        date childDOB2 = Date.parse(String.valueOf(System.today().month()+6)+'/'+String.valueOf(System.today().day())+'/'+String.valueOf(System.today().year()-3));  
        //date childDOB3 = Date.parse(String.valueOf(System.today().month()+6)+'/'+String.valueOf(System.today().day()-2)+'/'+String.valueOf(System.today().year()-3));
        
        List<Lead> leadList = new List<Lead>();
        List<Lead> leadListNeg = new List<Lead>();
        //List<Lead> leadListReqMetThisMonth = new List<Lead>();
        
        //insert wish child leads where child age is 2.5 years old today and the field for Age Requirement should update
        for(Integer i=0;i<10;i++)
        {
            leadList.add(new Lead(firstName='FirstName'+i, lastName='LastName'+i,child_age__c='Under 2.5',DOB__c=childDOB2,gender__c='Male',company='MAWA',
                                  is_Family_Aware_of_Referral__c = 'Yes', Phone = '9600467559', Email = 'testmawa'+i+'@gmail.com',State = 'Arizona',
                                  Treating_Medical_Professional_First_Name__c = 'Steve'+i,Treating_Medical_Professional_Last_Name__c = 'Waugh',
                                  Treating_Medical_Professional_Email__c = 'testmawa2'+i+'@gmail.com',Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC',
                                  Treating_Medical_Professional_Phone__c='9990467555',Parent_First_Name__c='Parent'+i,Parent_Last_Name__c='LastName'+i,
                                  Referrer_FirstName__c='Referrer'+i,Referrer_Last_Name__c='TestRef'+i,Referrer_Phone__c='8880467556',Referrer_Email__c='referrer'+i+'@gmail.com',
                                  Referrer_City__c='Phoenix',Referrer_Zip__c='85016',status = 'Inquiry',PD_ICD_Code__c = icdCode.Id,ICD_Given_By_Referrer__c=icdCode.id,
                                  Diagnosis_Given_By_Referrer__c = 'Test',ChapterName__c=chapterAccount.id,Street='12'+i+'Market St',postalcode='85016',city='Phoenix',Age_Requirement_Met__c=false));
        }
        //insert wish child leads where child age is 1.5 years old and the field for Age Requirement should not update
        for(Integer i=0;i<10;i++)
        {
            leadListNeg.add(new Lead(firstName='NFirstName'+i, lastName='NLastName'+i,child_age__c='Under 2.5',DOB__c=childDOB,gender__c='Male',company='MAWA',
                                  is_Family_Aware_of_Referral__c = 'Yes', Phone = '9611467559', Email = 'Ntestmawa'+i+'@gmail.com',State = 'Arizona',
                                  Treating_Medical_Professional_First_Name__c = 'Steve'+i,Treating_Medical_Professional_Last_Name__c = 'Waugh',
                                  Treating_Medical_Professional_Email__c = 'Ntestmawa2'+i+'@gmail.com',Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC',
                                  Treating_Medical_Professional_Phone__c='9990498555',Parent_First_Name__c='Parent'+i,Parent_Last_Name__c='LastName'+i,
                                  Referrer_FirstName__c='NReferrer'+i,Referrer_Last_Name__c='NTestRef'+i,Referrer_Phone__c='8818467556',Referrer_Email__c='Nreferrer'+i+'@gmail.com',
                                  Referrer_City__c='Phoenix',Referrer_Zip__c='85016',status = 'Inquiry',PD_ICD_Code__c = icdCode.Id,ICD_Given_By_Referrer__c=icdCode.id,
                                  Diagnosis_Given_By_Referrer__c = 'Test',ChapterName__c=chapterAccount.id,Street='12'+i+'N Market St',postalcode='85016',city='Phoenix',Age_Requirement_Met__c=false));
        }
        
        /*insert wish child leads where child age is 2.5 years old this month before today and the field for Age Requirement should update
        for(Integer i=0;i<5;i++)
        {
            if(System.today().day() > 2) {
            leadListReqMetThisMonth.add(new Lead(firstName='John'+i, lastName='JLastName'+i,child_age__c='Under 2.5',DOB__c=childDOB3,gender__c='Male',company='MAWA',
                                  is_Family_Aware_of_Referral__c = 'Yes', Phone = '9600457559', Email = 'jtestmawa'+i+'@gmail.com',State = 'Arizona',
                                  Treating_Medical_Professional_First_Name__c = 'Steven'+i,Treating_Medical_Professional_Last_Name__c = 'Waugh',
                                  Treating_Medical_Professional_Email__c = 'jtestmawa2'+i+'@gmail.com',Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC',
                                  Treating_Medical_Professional_Phone__c='8880467555',Parent_First_Name__c='JohnParent'+i,Parent_Last_Name__c='JLastName'+i,
                                  Referrer_FirstName__c='Referrer'+i,Referrer_Last_Name__c='TestRef'+i,Referrer_Phone__c='8880467556',Referrer_Email__c='jreferrer'+i+'@gmail.com',
                                  Referrer_City__c='Phoenix',Referrer_Zip__c='85016',status = 'Inquiry',PD_ICD_Code__c = icdCode.Id,ICD_Given_By_Referrer__c=icdCode.id,
                                  Diagnosis_Given_By_Referrer__c = 'Test',ChapterName__c=chapterAccount.id,Street='123'+i+'Market St',postalcode='85016',city='Phoenix',Age_Requirement_Met__c=false));
            }
        }*/
        
        insert leadList;
        insert leadListNeg;
        //insert leadListReqMetThisMonth;
    }

	//Call the batch_leadChildAge class    
    static testmethod void testBatchLeadChildAge() {
        
        Test.startTest();
        
        //verify none of the leads entering the batch have the Age requirement field marked as true
        Lead[] leadsBeforeUpdateList = [SELECT Id, Age_Requirement_Met__c FROM Lead Where Age_Requirement_Met__c = true];
        System.AssertEquals(0,leadsBeforeUpdateList.size());
        
        //initialize the batch job
        batch_leadChildAge reminder = new batch_leadChildAge();
        id batchId = database.executeBatch(reminder);
        test.stopTest();
        
        //Assert that number of the leads that should have been updated have been updated
        Lead[] leadsUpdatedList = [SELECT Id, Age_Requirement_Met__c FROM Lead Where Age_Requirement_Met__c = true];
        System.AssertEquals(true,leadsUpdatedList[0].Age_Requirement_Met__c);
        //System.AssertEquals(15,leadsUpdatedList.size());
        System.AssertEquals(10,leadsUpdatedList.size());
        
    }
    
    //Test batch_leadChildAgeSchedule 
    static testmethod void  testschedule(){
        
        Test.startTest();
        
        String CRON_EXP = '0 0 13 * * ?';
        batch_leadChildAgeSchedule_AC reminder = new batch_leadChildAgeSchedule_AC();
        String jobID = System.schedule('Lead Child Age Req', CRON_EXP, reminder);
        CronTrigger ct = [Select id, cronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        
        system.assertEquals(CRON_EXP, ct.CronExpression);
        system.assertEquals(0,ct.TimesTriggered);
        system.debug(string.valueOf(ct.NextFireTime));
        
        Test.stopTest();
    }
    
    
    /*static testmethod void testScheduler(){
        String CRON_EXP = '0 0 13 * * ?';
        
        //verify the asyncApexJob is empty
        List<AsyncApexJob> jobsBefore = [Select id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob];
        System.assertEquals(0,jobsBefore.size(), 'not expecting any asyncjobs');
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('testBatchleadChildAgeSchedule', CRON_EXP, new batch_leadChildAgeSchedule_AC());
        Test.StopTest();
        
        // Check schedulable is in the job list
        List<AsyncApexJob> jobsScheduled = [Select id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];
        System.AssertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
        System.AssertEquals('batch_LeadChildAgeSchedule_AC', jobsScheduled[0].ApexClass.Name, 'expecting specific scheduled job');
        System.debug('@@jobScheduled ' + jobsScheduled[0].ApexClass.Name);
        
        // check apex batch is in the job list
        List<AsyncApexJob> jobsApexBatch = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'BatchApex'];
        System.AssertEquals(1, jobsApexBatch.size(), 'expecting one apex batch job');
        System.AssertEquals('batch_leadChildAge', jobsApexBatch[0].ApexClass.Name, 'expecting specific batch job');
        System.debug(jobsApexBatch[0].ApexClass.Name);
        
    
    }*/
    
    
}