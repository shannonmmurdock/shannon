global class Batch_UpdateVolunteerRoleStatus_AC implements Database.batchable<Sobject>{
    global static Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,Volunteer_Name__c,Status__C,Chapter_Role__c,Hidden_Previous_Sub_Status__C,Hidden_Previous_Status__c,Sub_status__c FROM Volunteer_roles__c WHERE Status__C = \'Out of Compliance\' AND volunteer_Name__C != Null AND Hidden_Previous_Status__c = Null AND Hidden_Previous_Sub_Status__C = Null');
    }
    global static void execute( Database.BatchableContext bc,List<Volunteer_Roles__C> volunteerRoleList){
        set<Id> volunteerIdSet = new Set<Id>();
        Map<Id,List<Volunteer_Roles__C>> volunteerIdRoleMap = new Map<Id,List<volunteer_Roles__c>>();
        Set<Id> prosepectiveIdSet = new Set<Id>();
        Set<Id> activeIdSet = new Set<Id>();
        Set<Id> activeContactIdsSet = new Set<Id>();
        List<npe5__Affiliation__c> affiliationList = new List<npe5__Affiliation__c>();
        Set<Id> chapterRoleIds = new Set<Id>();
        Map<Id,Set<Id>> contactChapterRolesMap = new Map<Id, Set<Id>>();
        Map<Id,Set<Id>> chapterRoleOandTMap = new Map<Id,Set<Id>>();
        Set<Id> orientationIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Set<String> activeChapterRoleIds = new Set<String>();
        Map<String,Id> volunteerRoleMap = new Map<String,Id>();
        Constant_Ac constant = new Constant_Ac();
        Id trainingRecordTypeId = Schema.Sobjecttype.Orientation_Training__c.getRecordTypeInfosByName().get(constant.trainingRT).getRecordTypeId();
        Map<Id, List<Volunteer_Orientation_Training__c>> volunteerTrainingMap = new Map<Id, List<Volunteer_Orientation_Training__c>>();
        List<Volunteer_Roles__c> updateVolRoleList  = new List<Volunteer_Roles__c>();
        
        
        for(volunteer_Roles__c currRec : volunteerRoleList){
            volunteerIdSet.add(currRec.Volunteer_Name__c);
            if(volunteerIdRoleMap.containsKey(currRec.Volunteer_Name__c)){
                volunteerIdRoleMap.get(currRec.Volunteer_Name__c).add(currRec);
            }
            else{
                volunteerIdRoleMap.put(currRec.Volunteer_Name__c, new List<Volunteer_Roles__C>{currRec});
            }
            chapterRoleIds.add(currRec.chapter_Role__c);
            if(contactChapterRolesMap.containsKey(currRec.Volunteer_Name__c))
                contactChapterRolesMap.get(currRec.Volunteer_Name__c).add(currRec.chapter_role__c);
            else
                contactChapterRolesMap.put(currRec.Volunteer_Name__c,new Set<Id>{currRec.chapter_role__c});
            
            volunteerRoleMap.put(currRec.Volunteer_Name__c+'-'+currRec.chapter_role__c,currRec.id);
        } 
        for(User currUser : [SELECT Id,ContactId,Profile.Name,Profile.Id FROM User WHERE contactId IN: volunteerIdSet]){
            if(currUser.Profile.Id == label.Prospective_Volunteer_Profile){
                prosepectiveIdSet.add(currUSer.ContactId);
            }
            else{
                activeIdSet.add(currUSer.ContactId);
            }
        }
        
        
        
        for(Class_Offering__c currRec : [SELECT Id, Chapter_Role_O_T__r.Chapter_Role__c,Date__c,End_Time__c,Location__c,Chapter_Role_O_T__r.Orientation_Training__c FROM Class_Offering__c WHERE Chapter_Role_O_T__r.Chapter_Role__c IN :chapterRoleIds AND  Chapter_Role_O_T__r.Required__c = True AND Chapter_Role_O_T__r.Orientation_Training__r.RecordTypeId =: trainingRecordTypeId])
        {
            orientationIds.add(currRec.Chapter_Role_O_T__r.Orientation_Training__c);
            if(chapterRoleOandTMap.containsKey(currRec.Chapter_Role_O_T__r.Chapter_Role__c))
            {
                chapterRoleOandTMap.get(currRec.Chapter_Role_O_T__r.Chapter_Role__c).add(currRec.Chapter_Role_O_T__r.Orientation_Training__c);
            }
            else
            {
                chapterRoleOandTMap.put(currRec.Chapter_Role_O_T__r.Chapter_Role__c,new Set<Id>{currRec.Chapter_Role_O_T__r.Orientation_Training__c});
            }
        }
        
       /* for(Volunteer_Orientation_Training__c currTraining : [SELECT id, Volunteer__c,Hidden_O_T_Id__c FROM Volunteer_Orientation_Training__c WHERE Volunteer__c IN :volunteerIdSet AND Hidden_O_T_Id__c IN :orientationIds AND Type__c = 'Training' AND Volunteer_Attendance__c = 'Completed'])
        {
            if(volunteerTrainingMap.containsKey(currTraining.Hidden_O_T_Id__c))
                volunteerTrainingMap.get(currTraining.Hidden_O_T_Id__c).add(currTraining);
            else
                volunteerTrainingMap.put(currTraining.Hidden_O_T_Id__c, new List<Volunteer_Orientation_Training__c>{currTraining});
        }*/
        for(Volunteer_Orientation_Training__c currTraining : [SELECT id, Volunteer__c,Hidden_O_T_Id__c,Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__c FROM Volunteer_Orientation_Training__c WHERE Volunteer__c IN :volunteerIdSet AND Hidden_O_T_Id__c IN :orientationIds AND Type__c = 'Training' AND Volunteer_Attendance__c = 'Completed'])
        {
            if(volunteerTrainingMap.containsKey(currTraining.Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__c))
                volunteerTrainingMap.get(currTraining.Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__c).add(currTraining);
            else
                volunteerTrainingMap.put(currTraining.Class_Offering__r.Chapter_Role_O_T__r.Orientation_Training__c, new List<Volunteer_Orientation_Training__c>{currTraining});
        }
        
        
        for(Id currConId : volunteerIdSet)
        {
            /*if(prosepectiveIdSet.contains(currConId)){
                for(Volunteer_Roles__c currVolRole : volunteerIdRoleMap.get(currConId)){
                    Volunteer_Roles__c updateRec = new Volunteer_Roles__c();
                    updateRec.Hidden_Previous_Status__c = 'Pending';
                    updateRec.Hidden_Previous_Sub_Status__c = 'Missing Requirement';
                    updateRec.id = currVolRole.Id;              
                    updateVolRoleList.add(updateRec);
                }
                
            }*/
            if(activeIdSet.contains(currConId) || prosepectiveIdSet.contains(currConId)){
                for(Id currChapRolId : contactChapterRolesMap.get(currConId))
                { 
                    Integer trainingSize = 0;
                    if(chapterRoleOandTMap.containsKey(currChapRolId))
                    {
                        for(Id currOrientationId : chapterRoleOandTMap.get(currChapRolId)) 
                        {
                            if(volunteerTrainingMap.containsKey(currOrientationId))
                            {
                                for(Volunteer_Orientation_Training__c Training : volunteerTrainingMap.get(currOrientationId))
                                {
                                    trainingSize = trainingSize + 1;
                                    
                                }
                            }
                            
                        }
                    }
                    
                    if( chapterRoleOandTMap.containsKey(currChapRolId))
                    {   Volunteer_Roles__c updateRec = new Volunteer_Roles__c();
                     if(trainingSize == (chapterRoleOandTMap.get(currChapRolId).size()))
                     {
                         updateRec.Hidden_Previous_Status__c = 'Trained';
                         updateRec.Hidden_Previous_Sub_Status__c = '';
                     }
                     else{
                         updateRec.Hidden_Previous_Status__c = 'Pending';
                         updateRec.Hidden_Previous_Sub_Status__c = 'Missing Requirement';
                     }
                     updateRec.id = volunteerRoleMap.get(currConId+'-'+currChapRolId);               
                     updateVolRoleList.add(updateRec);
                    }
                    else if( !chapterRoleOandTMap.containsKey(currChapRolId))
                    {
                     Volunteer_Roles__c updateRec = new Volunteer_Roles__c();
                     updateRec.Hidden_Previous_Status__c = 'Trained';                     
                     updateRec.id = volunteerRoleMap.get(currConId+'-'+currChapRolId);               
                     updateVolRoleList.add(updateRec);
                    }
                    
                }
            }
        }            
        
        If(updateVolRoleList.Size() > 0){
            Update updateVolRoleList;
        }
    }
    global static void finish(Database.BatchableContext bc){
    } 
}