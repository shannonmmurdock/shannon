/***************************************************************************************************
Author      : MST Solutions
Date        : 
Description : COI_OnBeforeInsertTriggerHandler is used to call the Helper class when the
              new COI record is created.
              
              Modification Log
              ------------------
              WVC-1888    Pavithra G  06/13/2018
              WVC-2199    Pavithra G  08/10/2018
              
*****************************************************************************************************/
public class COI_OnAfterInsertTriggerHandler{
    /********************************************************************************************
    This method is used to create a task when the lead record is created. And share the lead
    record based on the chapter.
*********************************************************************************************/
    public static void OnAfterInsert(List<Conflict_Of_Interest__c > newCOIList){
         Set<Id> recordIds = new Set<Id>();
         Set<Id> volunteerIds = new Set<Id>();
         Set<Id> updateVolunteerIdSet = new Set<Id>();
         Set<Id> ownerIds = new Set<Id>();
         List<Conflict_Of_Interest__c> updateVolRoleCOIList = new List<Conflict_Of_Interest__c>();
         List<Contact> updateVolunteerContact = new List<Contact>();
         Contact updateCon;
         for(Conflict_Of_Interest__c  currCOI : newCOIList)
         {
            if(currCOI.current__c == True)
            {
                recordIds.add(currCOI.Id);
                volunteerIds.add(currCOI.Volunteer_Contact__c);
            }
            
             ownerIds.add(currCOI.ownerId);
             
             if(currCOI.Expiration_Date__c != Null && currCOI.Volunteer_Contact__c  != Null){
                 //updateVolunteerContact.add(curr);
                  updateCon = new Contact();
                  updateCon.Id = currCOI.Volunteer_Contact__c;
                  updateCon.COI_Expiration_Date__c = currCOI.Expiration_Date__c;
                  updateVolunteerContact.add(updateCon);
             }
             /***** WVC-2199 *******/
             if(currCOI.Expiration_Date__c != Null && currCOI.Volunteer_Contact__c  != Null && currCOI.current__c == True){
                 updateVolunteerIdSet.add(currCOI.Volunteer_Contact__c);
                 updateVolRoleCOIList.add(currCOI);   
             }
            /***** WVC-2199 ****/
         }
         
         
        if(volunteerIds.size() > 0 && recordIds.size() > 0)
        {
          COI_OnAfterInsertTriggerHelper.UpdateExistingRecords(newCOIList,recordIds,volunteerIds);
        }
        
        if(updateVolunteerContact.Size() > 0)
            Update updateVolunteerContact;
        
        if(ownerIds.size() > 0)
            COI_OnAfterInsertTriggerHelper.COIRecordSharing(ownerIds,newCOIList);
            
        if(updateVolunteerIdSet.Size() > 0){
            COI_OnAfterInsertTriggerHelper.updateVolunteerRole(updateVolunteerIdSet,updateVolRoleCOIList);
        }
    }
}