/**************************************************************************************
Description : This trigger will restrict the volunteer role updates from outside chapter stafff.
Based on the Volunteer Role Status, It will update Affiliation Status.
***************************************************************************************/

Trigger VolunteerRole_AT on Volunteer_Roles__c (before update,after update,after insert) 
{
    if(Trigger.isUpdate){
        if(trigger.isBefore){
            VolunteerRole_OnBeforeUpdateHandler_AC.OnBeforeUpdate(Trigger.new,Trigger.oldMap);
        }
        //This event used to update volunteer opportunity status as out of compliance or approved based on the volunteer role status      
        if(trigger.isAfter)
        {
            VolunteerRole_OnAfterUpdateHandler_AC.OnAfterUpdate(Trigger.new,Trigger.oldMap);
        }
    }
    //Update Affiliation Status.
    if(Trigger.isInsert && trigger.isAfter)
    {
         VolunteerRole_OnAfterInsertHandler_AC.OnAfterInsert(Trigger.new);   
    }
}