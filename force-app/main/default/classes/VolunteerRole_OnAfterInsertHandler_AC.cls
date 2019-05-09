/***************************************************************************************************
Author      : MST Solutions
Date        : 
Description : VolunteerRole_OnAfterInsertHandler_AC is used to call the Helper class when the
              new volunteer Role record is created.
              
              Modification Log
              ------------------
              WVC-1889    Pavithra G 07/31/2018
              
*****************************************************************************************************/
Public class VolunteerRole_OnAfterInsertHandler_AC{
    Public static void OnAfterInsert(List<Volunteer_Roles__c> newVolunteerRoleList){
        Map<id,list<Volunteer_Roles__c>> volunteerRoleStatusMap = new Map<id,list<Volunteer_Roles__c>>();
        Set<Id> volunteerRoleIdsSet = new Set<Id>();
        Set<Id> volunteerIdsSet = new Set<Id>();
        List<Volunteer_Roles__c> pendingTrainingExceptionList = new List<Volunteer_Roles__C>();
        for(Volunteer_Roles__c newVolRole : newVolunteerRoleList)
        {
            if(volunteerRoleStatusMap.containsKey(newVolRole.Volunteer_Name__c))
            {
                volunteerRoleStatusMap.get(newVolRole.Volunteer_Name__c).add(newVolRole);
            }
            else
            {
                volunteerRoleStatusMap.put(newVolRole.Volunteer_Name__c, new list<Volunteer_Roles__c>{newVolRole});
            }
            if(newVolRole.Status__c == 'Pending Training'){
                volunteerRoleIdsSet.add(newVolRole.Id);
                volunteerIdsSet.add(newVolRole.Volunteer_Name__c);
                pendingTrainingExceptionList.add(newVolRole);
            }
            
        }
        
        if(volunteerRoleStatusMap.size() > 0)
        {
            VolunteerRole_OnAfterInsertHelper_AC.updateVolunteerRoleStatus(volunteerRoleStatusMap,'Insert',newVolunteerRoleList);
        }
        if(volunteerRoleIdsSet.size() > 0 && volunteerIdsSet.size() > 0) 
        {
            VolunteerRole_OnAfterInsertHelper_AC.getVolunteerBasedOnVolunteerRoleStatus(volunteerRoleIdsSet,volunteerIdsSet,pendingTrainingExceptionList);
        }
    }
}