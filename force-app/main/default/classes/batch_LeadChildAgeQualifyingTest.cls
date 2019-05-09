@isTest
public class batch_LeadChildAgeQualifyingTest{

    static testmethod void testBatchLeadChildAgesetup(){
        //string CRON_EXP = '0 0 1 * * ?';
        Account chapterAccount = OrientationandTrainingUtil.CreateAmericaAccount();
        Condition_Description__c descrip = OrientationandTrainingUtil.createConditionDesCription(); 
        insert descrip;
        ICD_Codes__c icdCode = OrientationandTrainingUtil.createICDCode(descrip.Id);
        insert icdCode;
        date childDOB = Date.parse(String.valueOf(System.today().month())+'/'+String.valueOf(System.today().day())+'/'+String.valueOf(System.today().year()-2));  
        date childDOB2 = Date.parse(String.valueOf(System.today().month()+6)+'/'+String.valueOf(System.today().day())+'/'+String.valueOf(System.today().year()-3));  
        List<Lead> leadList = new List<Lead>();
        
        for(Integer i=0;i<20;i++){
            leadList.add(new Lead(firstName='FirstName'+i, lastName='LastName'+i,child_age__c='Under 2.5',DOB__c=childDOB2,gender__c='Male',company='MAWA',
                                  is_Family_Aware_of_Referral__c = 'Yes', Phone = '9600467559', Email = 'testmawa'+i+'@gmail.com',State = 'Arizona',
                                  Treating_Medical_Professional_First_Name__c = 'Steve',Treating_Medical_Professional_Last_Name__c = 'Waugh',
                                  Treating_Medical_Professional_Email__c = 'testmawa2'+i+'@gmail.com',Hospital_Treatment_Facility_Treating__c = 'Steve Smith AC',
                                  Treating_Medical_Professional_Phone__c='999046755'+i,Parent_First_Name__c='Parent'+i,Parent_Last_Name__c='LastName'+i,
                                  Referrer_FirstName__c='Referrer'+i,Referrer_Last_Name__c='TestRef'+i,Referrer_Phone__c='888046755'+i,Referrer_Email__c='referrer'+i+'@gmail.com',
                                  Referrer_City__c='Phoenix',Referrer_Zip__c='85016',status = 'Inquiry',PD_ICD_Code__c = icdCode.Id,ICD_Given_By_Referrer__c=icdCode.id,
                                  Diagnosis_Given_By_Referrer__c = 'Test',ChapterName__c=chapterAccount.id,Street='12'+i+'Market St',postalcode='85016',city='Phoenix',Age_Requirement_Met__c=false));
        }
        insert leadList;
        system.debug('@@child age ' + leadlist[0].child_CurrentAge__c);
        system.debug('@@size ' + leadList.size());
        Test.startTest();
        Database.executeBatch(new batch_leadChildAgeQualifying());  
        Test.stopTest();
        system.debug('@@agereq ' + leadList[1].Age_Requirement_Met__c);
        
    }
    
}