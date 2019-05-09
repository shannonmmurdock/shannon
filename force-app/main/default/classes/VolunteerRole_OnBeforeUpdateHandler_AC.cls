/***************************************************************************************************
Author      : MST Solutions
Date        : 
Description : VolunteerRole_OnBeforeInsertHandler_AC is used to call the Helper class when the
              new volunteer Role record is created.
              
              Modification Log
              ------------------
              WVC-1889    Pavithra G 07/31/2018
              
*****************************************************************************************************/
Public class VolunteerRole_OnBeforeUpdateHandler_AC{
    Public static void OnBeforeUpdate(List<Volunteer_Roles__c> newVolunteerRoleList,Map<Id,Volunteer_Roles__c> oldVolunteerRoleMap){
        Set<String> chapterNamesSet = new Set<String>();
            for(Volunteer_Roles__c currRec : newVolunteerRoleList)
            {
                chapterNamesSet.add(currRec.Chapter_Name__c); 
                If(currRec.sub_Status__c != Null && (currRec.Status__c == 'Trained' || currRec.Status__c == 'Not Approved' || currRec.Status__c == 'Out of Compliance')){
                    currRec.sub_Status__c ='';
                }
            }
            
            Map<String, String> chapterRoleMap = new Map<String,String>();
            
            if(chapterNamesSet.size() > 0)
                chapterRoleMap = ChapterStaffRecordSharing_AC.FindChapterRole(chapterNamesSet);
            
            List<User> currUser = [SELECT id,UserRole.Name,Profile.Name FROM User WHERE id = :userInfo.getUserId() limit 1];  
            
            for(Volunteer_Roles__c currRec : newVolunteerRoleList)
            {
                if(chapterRoleMap.get(currRec.Chapter_Name__c) != currUser[0].UserRole.Name && currUser[0].UserRole.Name != 'National Staff' && currUser[0].profile.Name != 'System Administrator' && Bypass_Triggers__c.getValues(userInfo.getUserId()) == Null)
                {
                    currRec.addError('Insufficient previlege to update this record. Please contact system administrator.');
                    
                }
            } 
    }
}