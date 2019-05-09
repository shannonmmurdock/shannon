//@isTest
////IN DEVELOPMENT
public class TestDataFactory4 {
    List<Orientation_Training__C> volOrientationList = new List<Orientation_Training__C>();
        List<Orientation_Training__C> wishGrantTrainingList = new List<Orientation_Training__C>();
        List<Orientation_Training__C> specialEventTrainingList = new List<Orientation_Training__C>();
        List<Chapter_Role_O_T__c> wishGranChapOT = new List<Chapter_Role_O_T__c>();
        List<Chapter_Role_O_T__c> volOrientationChapOT = new List<Chapter_Role_O_T__c>();
        List<Chapter_Role_O_T__c> specialEventChapOT = new List<Chapter_Role_O_T__c>();
        List<Class_Offering__c> wishGranterClass = new List<Class_Offering__c>();
        List<Class_Offering__c> volunOrientationClass = new List<Class_Offering__c>();
        List<Class_Offering__c> specialEventClass = new List<Class_Offering__c>();
    
    public static void createVolCourseReq(){
        //Sandbox script for record creation required to create approved vol contacts in sandbox.
        // Created 3-38-19 by Shannon Paderes
        
        List<Orientation_Training__C> volOrientationList = new List<Orientation_Training__C>();
        List<Orientation_Training__C> wishGrantTrainingList = new List<Orientation_Training__C>();
        List<Orientation_Training__C> specialEventTrainingList = new List<Orientation_Training__C>();
        List<Chapter_Role_O_T__c> wishGranChapOT = new List<Chapter_Role_O_T__c>();
        List<Chapter_Role_O_T__c> volOrientationChapOT = new List<Chapter_Role_O_T__c>();
        List<Chapter_Role_O_T__c> specialEventChapOT = new List<Chapter_Role_O_T__c>();
        List<Class_Offering__c> wishGranterClass = new List<Class_Offering__c>();
        List<Class_Offering__c> volunOrientationClass = new List<Class_Offering__c>();
        List<Class_Offering__c> specialEventClass = new List<Class_Offering__c>();

        
        //Get id for Arizona Chapter Account
        Account azChapter =  [select Id, Name, RecordTypeId from Account where name LIKE '%Arizona'];
        system.debug('Chapter Name and Id is: ' + azChapter.Name + ' | ' + azChapter.id);
        
        //Get iD's for existing ROLE__C records
        //Get id for existing Wish Granter Role__c 
        Role__c wishGranter = [Select Id, Name from Role__c where Name Like 'Wish Granter' LIMIT 1] ;
        system.debug('Role Name and Id is: ' + wishGranter.Name + ' | ' + wishGranter.id);
        
        //CHAPTER_ROLE__C
        //Get id for existing Wish Granter Chapter_Role__c
        Chapter_Role__c wishGranterCR = [Select Id, Role_Name__c, Role__c, Chapter_Name__c from Chapter_Role__c where Role_Name__r.Name = 'Wish Granter' AND chapter_name__r.Name Like '%Arizona'] ;
        system.debug('Wish Granter - Chapter Role Name and Id is: ' + wishGranterCR.Role__c + ' | ' + wishGranterCR.id);
        //Get id for existing ALL ROLES Chapter_Role__c
        Chapter_Role__c allRolesCR = [Select Id, Role_Name__c, Role__c, Chapter_Name__c from Chapter_Role__c where Role_Name__r.Name = 'All Roles' AND chapter_name__r.Name Like '%Arizona'] ;
        system.debug('All Roles - Chapter Role Name and Id is: ' + allRolesCR.Role__c + ' | ' + allRolesCR.id);
        
        //ORIENTATION_TRAINING__C
            //Get RecordTypeId for Record type ORIENTATION from Sobject Orientation_Training__c 
            Id orienRtype = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get('Orientation').getRecordTypeId();
            
            //Get RecordTypeId for Record type TRAINING from Sobject Orientation_Training__c 
            Id TrainRtype = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
            
            system.debug('Orientation Training - ORIENTATION Record Type Id is: ' + orienRtype);
            system.debug('Orientation Training - TRAINING Record Type Id is: ' + TrainRtype);
        
        //Orientation and Training__c Records
        //Volunteer Orientation
            Orientation_Training__C volOrientation = new Orientation_Training__c();
            volOrientation.Name = 'Volunteer Orientation';
            volOrientation.RecordTypeId = orienRtype;
            system.debug('Vol Orientation Name and RT is: ' + volOrientation.Name + ' | ' + volOrientation.RecordTypeId);
        	
        	volOrientationList.add(volOrientation);
            insert volOrientation;
        	
            system.debug('Vol Orientation- O&T record ID is: ' + volOrientation.Id );
        
        
        //Wish Granter Training 
            Orientation_Training__C wgTraining = new Orientation_Training__c();
            wgTraining.Name = 'Wish Granter Training';
            wgTraining.RecordTypeId = TrainRtype;
            system.debug('Wish Granter Training Name and RT is: ' + wgTraining.Name + ' | ' + wgTraining.RecordTypeId);
            
            wishGrantTrainingList.add(wgTraining);
        	insert wgTraining;
            system.debug('Wish Granter - O&T record ID is: ' + wgTraining.Id );
        
        //Special Events Training 
            Orientation_Training__C eventsTraining = new Orientation_Training__c();
            eventsTraining.Name = 'Special Events Training';
            eventsTraining.RecordTypeId = TrainRtype;
            system.debug('Special Events Training Name and RT is: ' + eventsTraining.Name + ' | ' + eventsTraining.RecordTypeId);
        	
        	specialEventTrainingList.add(eventsTraining);
            insert eventsTraining;
            system.debug('Special Events - O&T record ID is: ' + eventsTraining.Id );
        
        //Chapter_Role_O_T__c Records
        //Wish Granter
            Chapter_Role_O_T__c wishGranterChapOT = new Chapter_Role_O_T__c();
            wishGranterChapOT.Orientation_Training__c = wgTraining.Id;
            wishGranterChapOT.Chapter_Role__c = wishGranterCR.id;
            wishGranterChapOT.required__c = TRUE;
        
        	wishGranChapOT.add(wishGranterChapOT);
            insert wishGranterChapOT;
            system.debug('Wish Granter - ChapRole O&T record ID is: ' + wishGranterChapOT.Id );
        
        //Volunteer Orientation
            Chapter_Role_O_T__c volOrientChapOT = new Chapter_Role_O_T__c();
            volOrientChapOT.Orientation_Training__c = volOrientation.Id;
            volOrientChapOT.Chapter_Role__c = allRolesCR.id;
            volOrientChapOT.required__c = TRUE;
        	
        	volOrientationChapOT.add(volOrientChapOT);
            insert volOrientChapOT;
            system.debug('Vol Orientation - ChapRole O&T record ID is: ' + volOrientChapOT.Id );
            
        //Special Events Training
            Chapter_Role_O_T__c eventTrainChapOT = new Chapter_Role_O_T__c();
            eventTrainChapOT.Orientation_Training__c = eventsTraining.Id;
            eventTrainChapOT.Chapter_Role__c = allRolesCR.id;
            eventTrainChapOT.required__c = FALSE;
            
        	specialEventChapOT.add(eventTrainChapOT);
        	insert eventTrainChapOT;
            system.debug('Special Events Training - ChapRole O&T record ID is: ' + eventTrainChapOT.Id );
        
        //Class_Offering__c RT
        //Get RecordTypeId for Record type INPERSON from Sobject Class_Offering__c
            Id classOffPersonRT = Schema.Sobjecttype.Class_Offering__c.getRecordTypeInfosByName().get('In-Person').getRecordTypeId();
            system.debug('Class_Offering__c - In-Person Record Type Id is: ' + classOffPersonRT);
            //Get RecordTypeId for Record type Virtual - Self Paced from Sobject Class_Offering__c 
            Id classOffVirSelfRT = Schema.Sobjecttype.Class_Offering__c.getRecordTypeInfosByName().get('Virtual - Self Paced').getRecordTypeId();
            system.debug('Class_Offering__c - Virtual - Self Paced Record Type Id is: ' + classOffVirSelfRT);
            //Get RecordTypeId for Record type Virtual - Instructor Lead from Sobject Class_Offering__c 
            Id classOffVirInstrRT = Schema.Sobjecttype.Class_Offering__c.getRecordTypeInfosByName().get('Virtual - Instructor Lead').getRecordTypeId();
            system.debug('Class_Offering__c - Virtual - Self Paced Record Type Id is: ' + classOffVirInstrRT);
        
        //Class_Offering__c Record Creation
        //Wish Granter - Class_Offering__c
            Class_Offering__c wgClass1 = new Class_Offering__c();
            wgClass1.RecordTypeId = classOffPersonRT;
            wgClass1.Chapter_Role_O_T__c = wishGranterChapOT.Id;
            wgClass1.Location__c = 'Arizona Chapter';
            wgClass1.max_capacity__c = 500;
            //wgClass1.Date__c = Date.newInstance(2019,04,04);
        	wgClass1.Date__c = system.today() + 20;
            wgClass1.Start_Time__c = '7:00 AM';
            wgClass1.End_Time__c = '9:00 AM';
        
        	wishGranterClass.add(wgClass1);
            insert wgClass1;
            System.Debug('The Wish Granter class will be held at ' + wgClass1.Start_Time__c + ' on ' + wgClass1.Date__c  + ' at ' + wgClass1.Location__c + ' | ' + wgClass1.Id);
        
        
        //Volunteer Orientation - Class_Offering__c
            Class_Offering__c volorClass1 = new Class_Offering__c();
            volorClass1.RecordTypeId = classOffPersonRT;
            volorClass1.Chapter_Role_O_T__c = volOrientChapOT.Id;
            volorClass1.Location__c = 'Arizona Chapter';
            volorClass1.max_capacity__c = 500;
            //volorClass1.Date__c = Date.newInstance(2019,04,05);
            volorClass1.Date__c = system.today() + 20;
            volorClass1.Start_Time__c = '8:00 AM';
            volorClass1.End_Time__c = '10:00 AM';
        
        	volunOrientationClass.add(volorClass1);
            insert volorClass1;
            System.Debug('The Volunteer Orientation class will be held at ' + volorClass1.Start_Time__c + ' on ' + volorClass1.Date__c  + ' at ' + volorClass1.Location__c + ' | ' + volorClass1.Id);
        
        //Special Events Training - Class_Offering__c
            Class_Offering__c eventsClass1 = new Class_Offering__c();
            eventsClass1.RecordTypeId = classOffVirSelfRT;
            eventsClass1.Chapter_Role_O_T__c = eventTrainChapOT.Id;
            eventsClass1.Location__c = 'Arizona Chapter';
            eventsClass1.max_capacity__c = 50;
            //eventsClass1.Date__c = Date.newInstance(2019,04,06);
            eventsClass1.Date__c = system.today() + 20;
            eventsClass1.Start_Time__c = '10:00 AM';
            eventsClass1.End_Time__c = '11:00 AM';
            
        	specialEventClass.add(eventsClass1);
        	insert eventsClass1;
            System.Debug('The Volunteer Orientation class will be held at ' + eventsClass1.Start_Time__c + ' on ' + eventsClass1.Date__c  + ' at ' + eventsClass1.Location__c + ' | ' + eventsClass1.Id);
        
    }
}