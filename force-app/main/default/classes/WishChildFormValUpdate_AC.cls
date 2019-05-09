/*****************************************************************************
Author : MST Solutions
CreateDate : 03/25/2016
Description :This WishChildFormValUpdate_AC is used to update the parent case and create or update contacts when
the wish family form is approved
Modification Log: 
23/03/2018 - Sankar - WVC-1835
******************************************************************************/
Public Class WishChildFormValUpdate_AC
{
    
  //This method is used to create task when the family form get approved.
  public static void updateWishType(Map<string,Case> newCaseDetails)
    {
         
        Task taskInstance;
        List<task>  taskList=new List<task>();
        Map<String,Wish_Child_Form__c> wishFormDetailsMap = new Map<String,Wish_Child_Form__c>();
        for(Wish_Child_Form__c currWishChildform : [SELECT id,WishType__c,Case_Team_Member1__c, Case_Team_Member2__c,
                                                    Driver_Name__c,case__c,Case__r.ChapterName__c,Case__r.Contact.Language__c,Migrated__c FROM Wish_Child_Form__c WHERE 
                                                    Case__c IN : newCaseDetails.keySet() AND Migrated__c = false LIMIT 50000])
        {
            wishFormDetailsMap.put(currWishChildform.case__c, currWishChildForm);
        }
        for(Case currRec : newCaseDetails.Values())
        {
            if(wishFormDetailsMap.containsKey(currRec.id))
            {
                currRec.Driver_Names__c= wishFormDetailsMap.get(currRec.id).Driver_Name__c;
                if(wishFormDetailsMap.get(currRec.id).Case_Team_Member1__c != Null &&
                   wishFormDetailsMap.get(currRec.id).Case_Team_Member2__c != Null)
                {
                    currRec.Active_Wish_Granter__c = wishFormDetailsMap.get(currRec.id).Case_Team_Member1__c + ','+wishFormDetailsMap.get(currRec.id).Case_Team_Member2__c;
                }
                else if(wishFormDetailsMap.get(currRec.id).Case_Team_Member1__c != Null)
                    currRec.Active_Wish_Granter__c = wishFormDetailsMap.get(currRec.id).Case_Team_Member1__c;
                else if(wishFormDetailsMap.get(currRec.id).Case_Team_Member2__c != Null)
                    currRec.Active_Wish_Granter__c = wishFormDetailsMap.get(currRec.id).Case_Team_Member1__c;
            }
            taskInstance=new Task();
            taskInstance.OwnerId = currRec.OwnerId;
            taskInstance.Subject = 'Wish Concept Approval';
            taskInstance.Priority = 'Normal';
            taskInstance.Status = 'Not Started';
            taskInstance.Type = 'Action';
            taskInstance.ActivityDate=system.Today()+5;
            taskInstance.Whatid=currRec.id;
            taskList.add(taskInstance); 
        }
        
    }
    
    //This method is used to update the wish child and wish family contact.
    public static List<Case> updateWishdetails(Map<Id,Case> caseToUpdateMap)
    {   
        String LogValue;
        String recId;
        Set<Id> caseIdSet = new Set<Id>();
        Constant_AC  constant = new Constant_AC();
        caseIdSet.addAll(caseToUpdateMap.KeySet());
        Id wishDterminationCaseRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormDeterMination).getRecordTypeId();
        List<string> LstLog = new List<string>();
        
        try {
            Map<String,Wish_Child_Form__c> wishChildFormMap = new Map<String,Wish_Child_Form__c>();
            boolean migrated = false;
            String wishChildQuery = 'SELECT ';
            for(Schema.FieldSetMember f : getWishChildFields()) {
            wishChildQuery+= f.getFieldPath() + ', ';
            }
            wishChildQuery = WishchildQuery.removeEnd(', ');
            wishChildQuery+= ' from Wish_Child_Form__c' + ' WHERE Case__c = :'+'caseIdSet'+' AND Migrated__c =: migrated ';
            system.debug('@@@@ wishChildQuery @@@@'+wishChildQuery);
            List<Wish_Child_Form__c> determinationFormList = Database.Query(wishChildQuery);
            
            for(Wish_Child_Form__c currWishChildform :  determinationFormList )
            {    
                if(currWishChildform.RecordTypeId == wishDterminationCaseRecordTypeId){
                    caseIdSet.add(currWishChildform.Case__c);
                    wishChildFormMap.put(currWishChildform.case__c,currWishChildform);
                }
            }
            system.debug('@@@@ wishChildFormMap@@@'+wishChildFormMap);
            List<Case> updateCaseList = new List<Case>();
            for(Case currRec : caseToUpdateMap.Values())
            {    
                if(wishChildFormMap.containsKey(currRec.id))
                {
                    Case currCase = new Case();
                    system.debug('@@@@ wishDterminationCaseRecordTypeId @@@'+wishDterminationCaseRecordTypeId);
                    system.debug('@@@@wishChildFormMap.get(currRec.id).RecordTypeId @@@'+wishChildFormMap.get(currRec.id).RecordTypeId);
                    if(wishChildFormMap.get(currRec.id).Wish_Determination_Case_Id__c != Null && wishChildFormMap.get(currRec.id).RecordTypeId == wishDterminationCaseRecordTypeId)
                    {
                        recId = wishChildFormMap.get(currRec.id).Wish_Determination_Case_Id__c ;
                        currCase.id = wishChildFormMap.get(currRec.id).Wish_Determination_Case_Id__c ;
                        currCase.When_thinking_some_of_my_wish_ideas_were__c = wishChildFormMap.get(currRec.id).When_thinking_some_of_my_wish_ideas_were__c;
                        currCase.MY_WISH_IS_TO__c = wishChildFormMap.get(currRec.id).MY_WISH_IS_TO__c;
                        currCase.This_is_my_wish_because__c = wishChildFormMap.get(currRec.id).This_is_my_wish_because__c;
                        currCase.To_me_the_most_important_part_of_my_wish__c = wishChildFormMap.get(currRec.id).To_me_the_most_important_part_of_my_wish__c;
                        currCase.When_I_think_about_my_wish_I_imagine__c = wishChildFormMap.get(currRec.id).When_I_think_about_my_wish_I_imagine__c;
                        currCase.Wish_Notes__c = wishChildFormMap.get(currRec.id).Wish_Notes__c;
                        currCase.Availability_1__c = wishChildFormMap.get(currRec.id).Availability_Time_Period_1__c ;
                        currCase.Availability2__c = wishChildFormMap.get(currRec.id).Availability_Time_Period_2__c ;
                        currCase.Availability3__c = wishChildFormMap.get(currRec.id).Availability_Time_Period_3__c ;
                        currCase.Any_impact_your_ability_to_join_wish__c = wishChildFormMap.get(currRec.id).Any_impact_your_ability_to_join_wish__c;
                        currCase.Details_about_Impact__c = wishChildFormMap.get(currRec.id).Details_about_Impact__c;
                        currCase.Have_current_automobile_insurance__c = wishChildFormMap.get(currRec.id).Have_current_automobile_insurance__c;
                        currCase.Automobile_insurance_provide_coverage__c = wishChildFormMap.get(currRec.id).Automobile_insurance_provide_coverage__c;
                        currCase.Is_your_family_comfortable_in_rendal_car__c = wishChildFormMap.get(currRec.id).Is_your_family_comfortable_in_rendal_car__c;
                        currCase.Is_a_wheelchair_accessible_vehicle_neede__c = wishChildFormMap.get(currRec.id).Is_a_wheelchair_accessible_vehicle_neede__c;
                        currCase.Participant_dietary_restrictions__c = wishChildFormMap.get(currRec.id).Participant_dietary_restrictions__c;
                        currCase.Participant_dietary_restrictions_Note__c = wishChildFormMap.get(currRec.id).Participant_dietary_restrictions_Note__c;
                        currCase.Participant_require_a_wheelchair__c = wishChildFormMap.get(currRec.id).Participant_require_a_wheelchair__c;
                        currCase.Participant_require_a_wheelchair_Note__c = wishChildFormMap.get(currRec.id).Participant_require_a_wheelchair_Note__c;
                        currCase.Will_your_family_bring_wheelchair__c = wishChildFormMap.get(currRec.id).Will_your_family_bring_wheelchair__c;
                        currCase.Will_your_family_bring_wheelchair_Note__c = wishChildFormMap.get(currRec.id).Will_your_family_bring_wheelchair_Note__c;
                        currCase.Is_the_wheelchair_collapsible__c = wishChildFormMap.get(currRec.id).Is_the_wheelchair_collapsible__c;
                        currCase.Is_the_wheelchair_collapsible_Note__c = wishChildFormMap.get(currRec.id).Is_the_wheelchair_collapsible_Note__c;
                        currCase.Is_the_wheelchair_power__c = wishChildFormMap.get(currRec.id).Is_the_wheelchair_power__c;
                        currCase.Is_the_wheelchair_power_Note__c = wishChildFormMap.get(currRec.id).Is_the_wheelchair_power_Note__c;
                        currCase.Participant_require_oxygen_Note__c = wishChildFormMap.get(currRec.id).Participant_require_oxygen_Note__c;
                        currCase.Medication_require_refrigeration__c = wishChildFormMap.get(currRec.id).Medication_require_refrigeration__c;
                        currCase.Medication_require_refrigeration_Note__c = wishChildFormMap.get(currRec.id).Medication_require_refrigeration_Note__c;
                        currCase.Wish_child_receive_nursing_care__c = wishChildFormMap.get(currRec.id).Wish_child_receive_nursing_care__c;
                        currCase.Wish_child_receive_nursing_care_Note__c = wishChildFormMap.get(currRec.id).Wish_child_receive_nursing_care_Note__c;
                        currCase.Participant_have_allergies_to_food__c = wishChildFormMap.get(currRec.id).Participant_have_allergies_to_food__c;
                        currCase.Participant_have_allergies_to_food_Note__c = wishChildFormMap.get(currRec.id).Participant_have_allergies_to_food_Note__c;
                        currCase.Participant_require_medical_supplies__c = wishChildFormMap.get(currRec.id).Participant_require_medical_supplies__c;
                        currCase.Participant_require_medical_suppliesNote__c = wishChildFormMap.get(currRec.id).Participant_require_medical_suppliesNote__c;
                        currCase.Additional_Requests__c = wishChildFormMap.get(currRec.id).Additional_Requests__c;
                        currCase.Has_your_family_flown_before__c = wishChildFormMap.get(currRec.id).Has_your_family_flown_before__c;
                        currCase.Has_your_family_flown_before_Note__c = wishChildFormMap.get(currRec.id).Has_your_family_flown__c;
                        currCase.Will_an_interpreter_be_needed__c = wishChildFormMap.get(currRec.id).Will_an_interpreter_be_needed__c;
                        currCase.Will_an_interpreter_be_needed_Note__c = wishChildFormMap.get(currRec.id).Will_an_interpreter_be_needed_Details__c;
                        currCase.Will_a_rental_car_seat_s_be_needed__c = wishChildFormMap.get(currRec.id).Will_a_rental_car_seat_s_be_needed__c;
                        currCase.Will_a_rental_car_seat_s_be_needed_Note__c = wishChildFormMap.get(currRec.id).Will_a_rental_car_seat_s_Details__c;
                        currCase.Sit_up_takeoff_landing_on_airplane__c = wishChildFormMap.get(currRec.id).Sit_up_takeoff_landing_on_airplane__c;
                        currCase.Sit_up_takeoff_landing_on_airplane_Note__c = wishChildFormMap.get(currRec.id).Are_all_requested_participants_Details__c;
                        currCase.Will_a_rental_stroller_be_needed__c = wishChildFormMap.get(currRec.id).Will_a_rental_stroller_be_needed__c;
                        currCase.Will_a_rental_stroller_be_needed_Note__c = wishChildFormMap.get(currRec.id).Will_a_rental_stroller_Details__c;
                        currCase.Handicap_accommodations_be_required__c = wishChildFormMap.get(currRec.id).Handicap_accommodations_be_required__c;
                        currCase.Handicap_accommodations_be_required_Note__c = wishChildFormMap.get(currRec.id).Will_handicap_accessible_Details__c;
                        currCase.Participant_have_valid_passports__c = wishChildFormMap.get(currRec.id).Participant_have_valid_passports__c;
                        currCase.Participant_have_valid_passports_Note__c = wishChildFormMap.get(currRec.id).Does_each_requested_participant_Details__c;
                        currCase.Does_participant_have_valid_photo_ID__c = wishChildFormMap.get(currRec.id).Does_participant_have_valid_photo_ID__c;
                        currCase.Participant_have_valid_photo_ID_Note__c = wishChildFormMap.get(currRec.id).Does_each_requested_participan__c;
                        currCase.Does_your_family_have_a_credit_card__c = wishChildFormMap.get(currRec.id).Does_your_family_have_a_credit_card__c;
                        currCase.Does_your_family_have_a_credit_card_Note__c = wishChildFormMap.get(currRec.id).Does_your_family_Details__c;
                        currCase.Bringing_Own_Wheel_Chair__c = wishChildFormMap.get(currRec.id).Bringing_Own_Wheel_Chair__c;
                        currCase.Requested_Participant_Name_forWheelchair__c = wishChildFormMap.get(currRec.id).Requested_Participant_Name_forWheelchair__c;
                        currCase.Name_of_wheelchair_collapsible__c = wishChildFormMap.get(currRec.id).Name_of_wheelchair_collapsible__c;
                        currCase.Pariticipant_name_havingWheelchair_Power__c = wishChildFormMap.get(currRec.id).Pariticipant_name_havingWheelchair_Power__c;
                        currCase.Requested_Participant_Name_for_Oxygen__c =  wishChildFormMap.get(currRec.id).Requested_Participant_Name_for_Oxygen__c;
                        currCase.Participant_Name_for_Dietary_Restriction__c = wishChildFormMap.get(currRec.id).Participant_Name_for_Dietary_Restriction__c;
                        currCase.Requested_Participant_Name_for_Allergies__c = wishChildFormMap.get(currRec.id).Requested_Participant_Name_for_Allergies__c;
                        currCase.Medication_require_refrigeration_name__c = wishChildFormMap.get(currRec.id).Medication_require_refrigeration_name__c;
                        currCase.Names_for_receiving_nursing_care__c = wishChildFormMap.get(currRec.id).Names_for_receiving_nursing_care__c;
                        currCase.Requested_Participant_Name_for_OtherNeed__c = wishChildFormMap.get(currRec.id).Requested_Participant_Name_for_OtherNeed__c;
                        currCase.Participant_require_oxygen_how_often__c   = wishChildFormMap.get(currRec.id).Participant_require_oxygen_how_often__c;
                        currCase.Medical_insurance_out_of_state__c = wishChildFormMap.get(currRec.id).Does_Your_Medical_Insurance_Include__c;
                        currCase.Medical_insurance_note__c = wishChildFormMap.get(currRec.id).Does_Your_Medical_Insurance_Details__c;
                        currCase.Driver_Information__c = wishChildFormMap.get(currRec.id).Driver_Information__c;
                        LstLog.add('currCase: '+currCase);
                        updateCaseList.add(currCase);
                    }
                }
            }
            
         return updateCaseList;
        }
        Catch(Exception ex) {
            Logvalue = string.join(LstLog,', ');
           /* for(Wish_Child_Form__c currRec : determinationFormList){
                                                 
                                                  ErrorMessage_AC.createdebugRec('WishChildFormValUpdate_AC',String.valueof(currRec),String.valueOf(ex.getMessage()),'UpdateWishChildandWishFamily',currRec.Case__c,ex.getStackTraceString(),'Error');
                                              }*/
           }
        
        return null; 
    }
    
   /* Public static List<Case> updateDriverInfo(Map<Id,Case> caseToUpdateMap){
         
        
        Constant_AC  constant = new Constant_AC();
        Map<Id,Wish_Child_Form__c> wishChildFormMap = new Map<Id,Wish_Child_Form__c>();
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> driverSetId = new Set<Id>();
        caseIdSet.addAll(caseToUpdateMap.KeySet());
        Id driverContactRecordType = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildDriver).getRecordTypeId(); 
        List<Case> drivercaseList = new List<Case>();
        String driverInfo = '';
        String wishChildQuery = 'SELECT ';
        for(Schema.FieldSetMember f : getWishChildFields()) {
            wishChildQuery+= f.getFieldPath() + ', ';
        }
            
            wishChildQuery = WishchildQuery.removeEnd(', ');
            wishChildQuery+= ' from Wish_Child_Form__c' + ' WHERE Case__c = :'+'caseIdSet';
            List<Wish_Child_Form__c> driverList = Database.Query(wishChildQuery);
            
            for(Wish_Child_Form__c currWishChildform :  driverList)
            {    
               if(currWishChildform.RecordTypeId == driverContactRecordType){
                  system.debug('@@@@ Driver record @@@@');
                  driverSetId.add(currWishChildform.Id);
                   wishChildFormMap.put(currWishChildform.case__c,currWishChildform);
               }
            }
           
            for(Case currRec : caseToUpdateMap.Values())
            {
                if(wishChildFormMap.containsKey(currRec.id))
                {
                    Case currCase = new Case();
                    if(wishChildFormMap.get(currRec.id).RecordTypeId == driverContactRecordType )
                    {
                    case wishDeterminationcase = new case();
                    wishDeterminationcase.Id = wishChildFormMap.get(currRec.id).Wish_Determination_Case_Id__c ; 
                     for(Integer i=1; i<=driverSetId.size(); i++){
                      if(driverInfo == ''){
                            
                          driverInfo = wishChildFormMap.get(currRec.id).Driver_Name__c+' '+'|'+' '+wishChildFormMap.get(currRec.id).Driver_License_Number__c+' '+'|'+' '+wishChildFormMap.get(currRec.id).State__c +' '+'|'+' '+ wishChildFormMap.get(currRec.id).Expiration_Date__c;      
                       wishDeterminationcase.Driver_Information__c = driverInfo;
                        system.debug('@@@ driverInfo @@@'+driverInfo );
                       }
                       
                        else{
                           string  infomations =driverInfo +'<br/>'+wishChildFormMap.get(currRec.id).Driver_Name__c+' '+'|'+' '+wishChildFormMap.get(currRec.id).Driver_License_Number__c+' '+'|'+' '+wishChildFormMap.get(currRec.id).State__c +' '+'|'+' '+ wishChildFormMap.get(currRec.id).Expiration_Date__c;
                            wishDeterminationcase.Driver_Information__c = infomations;
                         system.debug('@@@ infomations  @@@'+infomations );
                        }
                        
                 drivercaseList.add(wishDeterminationcase);
                }
                }
               }
        return drivercaseList;
    }*/
    
    //This method is used to update or create parent case and wish child and wish family contact.
    public static void UpdateWishChildandWishFamily(Map<Id,Case> newWishMap)
    {  
        
        system.debug('@@@ Enter @@@@'+newWishMap);
        String LogValue;
        String recId;
        List<string> LstLog = new List<string>();
        try {
        Constant_AC  constant = new Constant_Ac();
        String wishFamilyDT = Schema.Sobjecttype.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Id familyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormFamily).getRecordTypeId();
        Id wichChildRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChild).getRecordTypeId();
        Id driverContactRecordType = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildDriver).getRecordTypeId(); 
        Id emergencyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildEmergency).getRecordTypeId(); 
        Set<Id> caseIds = new Set<Id>();
        Set<Id> wishChildIdSet = new Set<Id>();
        caseIds.addAll(newWishMap.keySet());
        Map<Id,npe4__Relationship__c> siblingMap = new Map<Id,npe4__Relationship__c >();
        caseIds.addAll(newWishMap.keySet());
        Id ChapterAccId;
        Id wishChildContactId;
        Set<String> contactIds = new Set<String>();
        Set<String> parentGurdianSet = new Set<String>();
        Set<String> participantSet = new Set<String>();
        Map<Id,Id> contactFileMap = new Map<Id,Id>();
        List<Case> updateWishDeterminationCaseList = WishChildFormValUpdate_AC.updateWishdetails(newWishMap);
       // List<Case> updateWishDeterminationdriverList = WishChildFormValUpdate_AC.updateDriverInfo(newWishMap);
        String relationShipString;
        Id wishChildId;
        List<npe4__Relationship__c> relationshipList = new  List<npe4__Relationship__c>();
        boolean isSelf;
        String wishChildQuery = 'SELECT ';
        for(Schema.FieldSetMember f : getWishChildFields()) {
            wishChildQuery+= f.getFieldPath() + ', ';
        }
        
        wishChildQuery+= ' Case__r.ContactId,Case__r.ChapterName__c,Case__r.Contact.AccountId,Case__r.Contact.Language__c from Wish_Child_Form__c' + ' WHERE Case__c = :'+'caseIds';
        List<Wish_Child_Form__c> wishChildList = Database.Query(wishChildQuery);
        
        List<Contact> updateWishChildContact = new List<Contact>();
        List<Account> updateWishFamilyAccount = new List<Account>();
        Map<String,Contact> createNewWishFamily = new Map<String,Contact>();
        Map<String,Contact> sameFamilyMap = new Map<String,Contact>();
        Set<String> firstNamesSet = new Set<String>();
        Set<String> lastNamesSet = new Set<String>();
        Set<String> relationshipsSet = new Set<String>();
        Set<Id> wishChildIds = new Set<Id>();
        Set<String> wishchildIdString = new Set<String>();
        List<cg__CaseFile__c> caseFileList = new List<cg__CaseFile__c>();
        Map<String,WishChildFormUtil.DriverWrapper> driverWrapperClsMap = new Map<String,WishChildFormUtil.DriverWrapper>();
        for(Case dbParentWish : newWishMap.values()){
            wishChildIdSet.add(dbParentWish.ContactId);
            contactFileMap.put(dbParentWish.ContactId,dbParentWish.Id);
        }
        
        if(wishChildIdSet.size() > 0){
            for(npe4__Relationship__c  dbRelationShip : [SELECT Id,npe4__Contact__c ,npe4__RelatedContact__c,npe4__RelatedContact__R.FirstName,npe4__RelatedContact__r.LastName,npe4__Type__c,npe4__RelatedContact__R.Email From npe4__Relationship__c  WHERE npe4__Contact__c IN: wishChildIdSet AND npe4__Type__c != 'Medical Professional' LIMIT 50000]){
                siblingMap.put(dbRelationShip.npe4__RelatedContact__c,dbRelationShip);
            }
        }
        for(Wish_Child_Form__c currWishChildform : wishChildList)
        {
            Contact currContact = new Contact();
            Account updateAccount = new Account();
            
            if(currWishChildForm.Contact__c != Null && currWishChildform.RecordTypeId == wichChildRecordTypeId)
            {    
                wishchildIdString.add(currWishChildForm.Contact__c+'-'+currWishChildForm.Contact__c);
                
                wishChildIds.add(currWishChildForm.Contact__c);
                wishChildId = currWishChildForm.Contact__c;
                recId = currWishChildForm.Contact__c;
                currContact.Id = currWishChildForm.Contact__c;
                wishChildContactId = currWishChildForm.Contact__c;
                currContact.FirstName = currWishChildForm.FirstName__c;
                currContact.LastName = currWishChildForm.LastName__c;
                currContact.Middle_Name__c = currWishChildForm.Middle_Name__c;
                currContact.Social_Media_Link__c = currWishChildForm.Social_Media_Link__c;
                currContact.Already_wish_granted_by_MAW_Other_Org__c = currWishChildForm.Already_wish_granted_by_MAW_Other_Org__c;
                currContact.If_yes_Enter_Org_Name_Wish_Date_it_was__c= currWishChildForm.If_yes_Enter_Org_Name_Wish_Date_it_wa__c;
                currContact.Preferred_Name__c = currWishChildForm.Preferred_Name__c;
                currContact.Gender__c= currWishChildForm.Gender__c;
                currContact.Self_describe_comment_box__c= currWishChildForm.Self_describe_comment_box__c;
                currContact.BirthDate = currWishChildForm.BirthDate__c;
                currContact.T_Shirt_Size__c= currWishChildForm.T_Shirt_Size__c;
                currContact.Diagnosis__c = currWishChildForm.Diagnosis__c;
                currContact.Primary_Address__c = currWishChildForm.PrimaryAddreess__c;
                currContact.mobilePhone = currWishChildForm.mobilePhone__c;
                currContact.Email = currWishChildForm.Email__c;
                currContact.Color__c = currWishChildForm.Color__c;
                currContact.Music_Singer__c  = currWishChildForm.Music_Singer__c;
                currContact.Book_Story__c = currWishChildForm.Book_Story__c;
                currContact.Hobby__c = currWishChildForm.Hobby__c;
                currContact.Game__c= currWishChildForm.Game__c;
                currContact.Food__c= currWishChildForm.Food__c;
                currContact.Hidden_Wish_Form_Id__c = currWishChildForm.Id;
                currContact.Movie__c= currWishChildForm.Movie__c;
                currContact.Food__c = currWishChildForm.Food__c;
                currContact.TV_Show__c = currWishChildForm.TVShow__c;
                currContact.Restaurant__c= currWishChildForm.Restaurant__c;
                currContact.Actor_Actress__c = currWishChildForm.Actor_Actress__c;
                currContact.Cake_Candy__c = currWishChildForm.Cake_Candy__c;
                currContact.Sport_Athlete__c = currWishChildForm.Sport_Athlete__c;
                currContact.Snack_Food__c = currWishChildForm.Snack_Food__c;
                currContact.Pet_Animal__c = currWishChildForm.Pet_Animal__c;
                currContact.Class_in_School__c = currWishChildForm.ClassinSchool__c;
                currContact.Other__c= currWishChildForm.Other__c;
                currContact.When_I_m_outside_I_like_to__c = currWishChildForm.When_I_m_outside_I_like_to__c;
                currContact.When_I_m_inside_I_like_to__c = currWishChildForm.When_I_m_inside_I_like_to__c;
                currContact.Electronics_Games_that_I_like_to_play__c = currWishChildForm.Electronics_Games_that_I_like_to_play__c;
                currContact.When_I_m_with_my_family_I_like_to__c = currWishChildForm.When_I_m_with_my_family_I_like_to__c;
                currContact.When_I_m_with_my_friends_I_like_to__c = currWishChildForm.When_I_m_with_my_friends_I_like_to__c;
                currContact.Region_Chapter__c = currWishChildForm.Case__r.ChapterName__c;
                ChapterAccId = currWishChildForm.Case__r.ChapterName__c;
                //currContact.Parent_Legal_Guardian__c = currWishChildForm.RelatedContact__c;
                currContact.RelatedContacts__c = currWishChildForm.RelatedContact__c;
                currContact.MyWishIsTo__c = currWishChildForm.MY_WISH_IS_TO__c;
                currContact.When_I_think_about_my_wish_I_imagine__c = currWishChildForm.When_I_think_about_my_wish_I_imagine__c;
                currContact.This_is_my_wish_because__c = currWishChildForm.This_is_my_wish_because__c;
                currContact.To_me_the_most_important_part_of_my_wish__c = currWishChildForm.To_me_the_most_important_part_of_my_wish__c;
                currContact.Wish_Notes__c = currWishChildForm.Wish_Notes__c;
                currContact.When_thinking_some_of_my_wish_ideas_were__c = currWishChildForm.When_thinking_some_of_my_wish_ideas_were__c; 
                currContact.Race_Ethnicity__c = currWishChildForm.Race_Ethnicity__c;
                currContact.Race_Ethnicity_Details__c = currWishChildForm.Race_Ethnicity_Details__c;
                currContact.Preferred_Name__c = currWishChildForm.Preferred_Name__c;
                if(currWishChildForm.Street__c != Null)
                    currContact.MailingStreet = currWishChildForm.Street__c;
                if(currWishChildForm.City__c != Null)
                    currContact.MailingCity = currWishChildForm.City__c;
                if(currWishChildForm.State__c != Null)
                    currContact.MailingState = currWishChildForm.State__c;
                if(currWishChildForm.Zip_code__c != Null)
                    currContact.MailingPostalcode = currWishChildForm.Zip_code__c;
                LstLog.add('currContact: '+currContact);
                updateWishChildContact.add(currContact);
            }
            
            if(currWishChildForm.Case__r.Contact.AccountId != Null && currWishChildForm.RecordTypeId == emergencyContactRecordTypeId)
            {
                updateAccount.id = currWishChildForm.Case__r.Contact.AccountId;
                if(currWishChildForm.FirstName__c  != Null && currWishChildForm.LastName__c!= Null)
                    updateAccount.Emergency_Contact__c = currWishChildForm.FirstName__c +' '+currWishChildForm.LastName__c;
                if(currWishChildForm.FirstName__c  != Null && currWishChildForm.LastName__c != Null && currWishChildForm.Middle_Name__c != Null)
                    updateAccount.Emergency_Contact__c = currWishChildForm.Emergency_First_Name__c+' '+currWishChildForm.Middle_Name__c+' '+currWishChildForm.Emergency_Last_Name__c;
                updateAccount.Emergency_Contact_Phone__c = currWishChildForm.mobilePhone__c;
                updateAccount.Relationship_type__c = currWishChildForm.Emergency_Relationship__c;
                updateAccount.Emergency_Contact_Middle_Name__c = currWishChildForm.Middle_Name__c;
                updateAccount.Emergency_Contact_Email__c = currWishChildForm.Email__c;
                updateAccount.Hidden_Wish_Form_Id__c  = currWishChildForm.Id;
                LstLog.add('updateAccount: '+updateAccount);
                updateWishFamilyAccount.add(updateAccount);
            }
            
            if(currWishChildForm.RecordTypeId == familyContactRecordTypeId)
            {
               If(currWishChildForm.LastName__c != Null){
                    String findDupe = currWishChildForm.FirstName__c +'-'+currWishChildForm.LastName__c;
                    Contact newContact = new Contact();
                    newContact.RecordTypeId = wishFamilyDT;
                    if(siblingMap.containsKey(currWishChildForm.Contact__c))
                    {
                        newContact.id = currWishChildForm.Contact__c;
                    }
                    newContact.Hidden_Wish_Form_Id__c = currWishChildForm.Id;
                    
                    newContact.FirstName = currWishChildForm.FirstName__c;
                    newContact.Middle_Name__c = currWishChildForm.Middle_Name__c;
                    newContact.LastName =  currWishChildForm.LastName__c;
                    newContact.Relationship__c = currWishChildForm.Emergency_Relationship__c;
                    newContact.HomePhone = currWishChildForm.Home_Phone__c;
                    newContact.npe01__WorkPhone__c = currWishChildForm.TelePhone__c;
                    newContact.MobilePhone = currWishChildForm.mobilePhone__c;
                    newContact.Email =  currWishChildForm.Email__c;
                    newContact.BirthDate = currWishChildForm.BirthDate__c;
                    
                    if(currWishChildForm.Hidden_Same_as_Family__c == true){
                    newContact.IsParentGuardian__c = 'ParentGuardian/Participant';
                    }
                    else if(currWishChildForm.IsParticipant__c == true && currWishChildForm.Hidden_Same_as_Family__c == false){
                    newContact.IsParentGuardian__c = 'Participant';
                    }
                    else if(currWishChildForm.IsParticipant__c == false && currWishChildForm.Hidden_Same_as_Family__c == false){
                    newContact.IsParentGuardian__c = 'ParentGuardian';
                    }
                    
                    newContact.Region_Chapter__c = ChapterAccId;
                    newContact.MailingStreet = currWishChildForm.Street__c;
                    newContact.MailingCity = currWishChildForm.City__c;
                    newContact.MailingState = currWishChildForm.State__c;
                    newContact.MailingPostalCode = currWishChildForm.Zip_code__c ;
                    newContact.AccountId = currWishChildForm.Case__r.Contact.AccountId;
                    newContact.Language__c  = currWishChildForm.case__r.contact.Language__c;
                    newContact.Residing_with_Wish_child__c = currWishChildForm.Residing_With_Wish_Child__c;
                    newContact.T_Shirt_Size__c = currWishChildForm.T_Shirt_Size__c;
                    createNewWishFamily.put(newContact.FirstName+'-'+newContact.LastName,newContact);
                    }
                
            }
          }
        
        Map<String, Contact> existingContactMap = new Map<String, Contact>();
        Map<String,String> existingRelationMap = new Map<String,String>();
        Set<Id> wichildIdSet = new Set<Id>();
        Map<Id, Contact> existingContacts = new Map<Id, Contact>();
        
        
        Map<String,Contact> toUpdateContact = new Map<String,Contact>();  
        for(Contact currCon : createNewWishFamily.values())
        {
            toUpdateContact.put(currCon.firstName+'-'+currCon.lastname+'-'+currCon.Relationship__c,currCon); 
        }
        if(updateWishDeterminationCaseList.size() > 0)
        {
            LstLog.add('updateWishDeterminationCaseList: '+updateWishDeterminationCaseList);
            update updateWishDeterminationCaseList;
        }
        //if(updateWishDeterminationdriverList.size() > 0){
        //update updateWishDeterminationdriverList;
        //}   
        if(toUpdateContact.size() > 0)
        { 
            LstLog.add('toUpdateContact: '+toUpdateContact);
            if(!Test.isRunningTest())
            Upsert toUpdateContact.values();
        
        }
        if(updateWishFamilyAccount.size() > 0)
        {
            LstLog.add('updateWishFamilyAccount: '+updateWishFamilyAccount);
            update updateWishFamilyAccount;
        }
        if(updateWishChildContact.size() > 0)
        {
            LstLog.add('updateWishChildContact: '+updateWishChildContact);
            update updateWishChildContact;
        }
            
        for(npe4__Relationship__c currRel : [SELECT Id,npe4__Contact__c,npe4__RelatedContact__c  FROM npe4__Relationship__c 
                                             WHERE npe4__Contact__c  IN :wishChildIds LIMIT 50000] )
        {
            String name = currRel.npe4__Contact__c+'-'+currRel.npe4__RelatedContact__c;
            if(!wishchildIdString.contains(name )){
                isSelf = true;
            }
            existingRelationMap.put(currRel.npe4__Contact__c+'-'+currRel.npe4__RelatedContact__c,currRel.id);
        }
        
        for(Contact newContact : toUpdateContact.values())
        {
            npe4__Relationship__c newRelation = new npe4__Relationship__c();
            newRelation.npe4__Type__c  = newContact.Relationship__c;
            newRelation.Medical_Needs__c = newContact.Medical_Needs__c;
            newRelation.Residing_with_Wish_child__c = newContact.Residing_with_Wish_child__c;
            String name = newContact.FirstName+'-'+newContact.lastName+'-'+newContact.Email;
            
            if(newContact.IsParentGuardian__c == 'ParentGuardian/Participant'){
               
                newRelation.Parent_Legal_Guardian__c = true;
                newRelation.Wish_Participant__c = true;
                 if(newContact.Birthdate != Null){
                        Date dt = Date.Valueof(newContact.Birthdate);
                        Integer days = dt.daysBetween(Date.Today());
                        Integer age = Integer.valueOf(days/365);
                        if(age < 18){
                            newRelation.Under_18__c = true;
                        }
                        else{
                            newRelation.Under_18__c = false;
                        }
                    }
            }
            else{
                if(newContact.IsParentGuardian__c == 'ParentGuardian'){
                    newRelation.Parent_Legal_Guardian__c = true;
                    newRelation.Wish_Participant__c = false;
                    if(newContact.Birthdate != Null){
                        Date dt = Date.Valueof(newContact.Birthdate);
                        Integer days = dt.daysBetween(Date.Today());
                        Integer age = Integer.valueOf(days/365);
                        if(age < 18){
                            newRelation.Under_18__c = true;
                        }
                        else{
                            newRelation.Under_18__c = false;
                        }
                        
                    }
                }
                if(newContact.IsParentGuardian__c == 'Participant'){
                    newRelation.Parent_Legal_Guardian__c = false;
                    newRelation.Wish_Participant__c = true;
                    if(newContact.Birthdate != Null){
                        Date dt = Date.Valueof(newContact.Birthdate);
                        Integer days = dt.daysBetween(Date.Today());
                        Integer age = Integer.valueOf(days/365);
                        if(age < 18){
                            newRelation.Under_18__c = true;
                        }
                        else{
                            newRelation.Under_18__c = false;
                        }
                    }
                }
            }  
            if(existingRelationMap.containsKey(wishChildContactId+'-'+newContact.id))
            {
                newRelation.id = existingRelationMap.get(wishChildContactId+'-'+newContact.id);
            }
            else
            {
                newRelation.npe4__Contact__c  = wishChildContactId;
                newRelation.npe4__RelatedContact__c  = newContact.id;
            }
            system.debug('@@@ relationshipList @@@'+relationshipList);
            relationshipList.add(newRelation);
            
        }
        
            if(relationshipList.size() > 0)
            {   
                
                if(!Test.isRunningTest())
                upsert relationshipList;
            }
        }
        Catch(Exception ex) {
            Logvalue = string.join(LstLog,', ');
            Set<Id> caseIdSet = new Set<Id>();
            for(Wish_Child_Form__c currRec : [SELECT id,Case__c,Case__r.ChapterName__c,Case__r.Contact.Language__c,When_thinking_some_of_my_wish_ideas_were__c,MY_WISH_IS_TO__c,This_is_my_wish_because__c,
                                              To_me_the_most_important_part_of_my_wish__c, When_I_think_about_my_wish_I_imagine__c, Wish_Notes__c,
                                              Availability_Time_Period_1__c,Availability_Time_Period_2__c,Availability_Time_Period_3__c, 
                                              Any_impact_your_ability_to_join_wish__c,Details_about_Impact__c,Street__c,
                                              Have_current_automobile_insurance__c,Automobile_insurance_provide_coverage__c,Is_your_family_comfortable_in_rendal_car__c,
                                              Is_a_wheelchair_accessible_vehicle_neede__c,Participant_dietary_restrictions__c,Participant_dietary_restrictions_Note__c,
                                              Participant_require_a_wheelchair__c,Participant_require_a_wheelchair_Note__c,Will_your_family_bring_wheelchair__c,
                                              Will_your_family_bring_wheelchair_Note__c,Is_the_wheelchair_collapsible__c,Is_the_wheelchair_collapsible_Note__c,
                                              Is_the_wheelchair_power__c,Is_the_wheelchair_power_Note__c,Participant_require_oxygen_how_often__c,Participant_require_oxygen_Note__c,
                                              Medication_require_refrigeration__c,Medication_require_refrigeration_Note__c,Wish_child_receive_nursing_care__c,
                                              Wish_child_receive_nursing_care_Note__c,Participant_have_allergies_to_food__c,Participant_have_allergies_to_food_Note__c,
                                              Participant_require_medical_supplies__c,Participant_require_medical_suppliesNote__c,Additional_Requests__c,
                                              Has_your_family_flown_before__c,Has_your_family_flown_before_Note__c,Will_an_interpreter_be_needed__c,Will_an_interpreter_be_needed_Note__c,
                                              Will_a_rental_car_seat_s_be_needed__c,Will_a_rental_car_seat_s_be_needed_Note__c,
                                              Sit_up_takeoff_landing_on_airplane__c,Sit_up_takeoff_landing_on_airplane_Note__c,Will_a_rental_stroller_be_needed__c,
                                              Will_a_rental_stroller_be_needed_Note__c,Handicap_accommodations_be_required__c,Handicap_accommodations_be_required_No__c,
                                              Participant_have_valid_passports__c,Participant_have_valid_passports_Note__c,Does_participant_have_valid_photo_ID__c,
                                              Participant_have_valid_photo_ID_Note__c,Wish_Determination_Case_Id__c,Does_your_family_have_a_credit_card__c,Does_your_family_have_a_credit_card_Note__c,Bringing_Own_Wheel_Chair__c,RelatedContact__c,Requested_Participant_Name_forWheelchair__c,
                                              Participant_Name_for_Dietary_Restriction__c,Requested_Participant_Name_for_Allergies__c,Medication_require_refrigeration_name__c,Pariticipant_name_havingWheelchair_Power__c,
                                              Names_for_receiving_nursing_care__c,Requested_Participant_Name_for_Oxygen__c,Requested_Participant_Name_for_OtherNeed__c,Name_of_wheelchair_collapsible__c,Has_your_family_flown__c,Will_an_interpreter_be_needed_Details__c,
                                              Will_a_rental_car_seat_s_Details__c,Are_all_requested_participants_Details__c,Will_a_rental_stroller_Details__c,Will_handicap_accessible_Details__c,Does_each_requested_participant_Details__c,Does_each_requested_participan__c,Does_your_family_Details__c,Race_Ethnicity__c,Driver_Information__c,
                                              Does_Your_Medical_Insurance_Include__c,Does_Your_Medical_Insurance_Details__c FROM 
                                              Wish_Child_Form__c WHERE Case__c IN : newWishMap.keySet() LIMIT 50000]){
                                                  caseIdSet.add(currRec.Case__c);
                                                  ErrorMessage_AC.createdebugRec('WishChildFormValUpdate_AC',String.valueof(currRec),String.valueOf(ex),'UpdateWishChildandWishFamily',currRec.Case__c,ex.getStackTraceString(),'Error');
                                              }
            for(Case currRec : [SELECT Id FROM Case WHERE Id IN: caseIdSet Limit 50000]){
                //currRec.addError(Label.Debug_log_error_message);
            }
        }
    }
    
      // Medical Referral Field set contains the mandatory fields of Medical Professional.
    public static List<Schema.FieldSetMember> getWishChildFields() 
    {
        return SObjectType.Wish_child_form__c.FieldSets.Wish_Child_Form.getFields();
    }
    
 }