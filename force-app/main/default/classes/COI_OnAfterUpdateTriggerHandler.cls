/***************************************************************************************************
Author      : MST Solutions
Date        : 
Description : COI_OnBeforeInsertTriggerHandler is used to call the Helper class when the
              new COI record is created.
              
              Modification Log
              ------------------
              WVC-1888    Pavithra G  06/13/2018
              
*****************************************************************************************************/
public class COI_OnAfterUpdateTriggerHandler{
    /********************************************************************************************
    This method is used to create a task when the lead record is created. And share the lead
    record based on the chapter.
*********************************************************************************************/
    public static void OnAfterUpdate(List<Conflict_Of_Interest__c > newCOIList,Map<Id,Conflict_Of_Interest__c> oldCOIMap){
       List<Contact> updateVolunteerContact = new List<Contact>();
       Set<Id> recordIds = new Set<Id>();
       Set<Id> volunteerIds = new Set<Id>();
       Set<Id> ownerIds = new Set<Id>();
       Set<Id> volunteerContactIdSet = new Set<Id>();
       List<Conflict_Of_Interest__c> coiList = new List<Conflict_Of_Interest__c>();
        for(Conflict_Of_Interest__c  currCOI : newCOIList)
        {
           if(currCOI.Expiration_Date__c  != oldCOIMap.get(currCOI.id).Expiration_Date__c && currCOI.Expiration_Date__c != Null)
           {
                if(currCOI.Volunteer_Contact__c != Null)
                {
                   Contact updateVolunteer = new Contact();
                   updateVolunteer.Id = currCOI.Volunteer_Contact__c;
                   updateVolunteer.COI_Expiration_Date__c = currCOI.Expiration_Date__c;
                   updateVolunteerContact.add(updateVolunteer);
                }
           }
           coiList.add(currCOI);
           if(currCOI.HiddenConflictExpire__c == true && oldCOIMap.get(currCOI.Id).HiddenConflictExpire__c  == false){
               volunteerContactIdSet.add(currCOI.Volunteer_Contact__c);
           }
           
           if(currCOI.current__c == True && oldCOIMap.get(currCOI.id).current__c == False)
            {
                recordIds.add(currCOI.Id);
                volunteerIds.add(currCOI.Volunteer_Contact__c);                
            }
            
            if(currCOI.ownerId != oldCOIMap.get(currCOI.id).OwnerId)
                ownerIds.add(currCOI.ownerId);
        }
                
        if(updateVolunteerContact.size() > 0)
          update updateVolunteerContact;
          
        if(ownerIds.size() > 0)
            COI_OnAfterInsertTriggerHelper.COIRecordSharing(ownerIds,newCOIList);  
          
        if(volunteerIds.size() > 0 && recordIds.size() > 0)
        {
          COI_OnAfterInsertTriggerHelper.UpdateExistingRecords(newCOIList,recordIds,volunteerIds);
        }
        
        if(volunteerContactIdSet.size() > 0)
         BackGroundCheck_OnAfterUpdateHelper.UpdateVOppAndVRoleStatus(volunteerContactIdSet,'COI',coiList);
     }
    }