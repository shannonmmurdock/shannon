/*****************************************************************************************************************
Author      : MST Solutions
Date        : 08/20/2018
Description : This BatchWishChildFormDataUpdate is used to migrate the exisiting wishform records into new wishform format. 
*******************************************************************************************************************/

global class BatchWishChildFormDataUpdate implements Database.Batchable<sObject>  {
    // Query all the exisiting wish form records which have migrated as false.
    global Database.QueryLocator start(Database.BatchableContext BC)  {
       
        If(!Test.isRunningTest())
            return Database.getQueryLocator([SELECT Id, CreatedDate, CreatedById, CreatedBy.Name, Migrated__c, RecordTypeId, case__c,LastModifiedById,LastModifiedBy.Name FROM Wish_Child_Form__c WHERE Migrated__c = false AND case__c != Null ]);
        else If(Test.isRunningTest())
            return Database.getQueryLocator([SELECT Id,Case__c,Migrated__c,CreatedDate,CreatedById,CreatedBy.Name,RecordTypeId FROM Wish_Child_Form__c WHERE Migrated__c = False AND RecordType.Name = 'Wish Child']);
        
        return Database.getQueryLocator([SELECT Id,Case__c,Migrated__c,CreatedDate,CreatedById,CreatedBy.Name,RecordTypeId FROM Wish_Child_Form__c WHERE CreatedDate != Today AND Migrated__c = False AND RecordTypeId = Null]);
    }
    
    //Logic for migrate the exisiting records into new wish form format.
    global void execute(Database.BatchableContext BC, List<Wish_Child_Form__c > dbWishChildLiist)  {
      
        Constant_AC  constant = new Constant_AC();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
        Id familyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormFamily).getRecordTypeId();
        Id wichChildRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChild).getRecordTypeId();
        Id wishDterminationCaseRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormDeterMination).getRecordTypeId(); 
        Id driverContactRecordType = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildDriver).getRecordTypeId(); 
        Id emergencyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildEmergency).getRecordTypeId(); 
        Id casewishDeterminatioRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get(constant.wishDeterminationRT ).getRecordTypeId(); 
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,case> caseMap = new Map<Id,case>();
        List<Wish_Child_Form__c> dbWishChildFormList = new List<Wish_Child_Form__c>();
        List<Wish_Child_Form__c> dbWishChildFormUpdateList = new List<Wish_Child_Form__c>();
        List<Wish_Child_Form__c> newWishChildFormList = new List<Wish_Child_Form__c>();
        Map<String,Id> relatedContactMap = new Map<String,Id>();
        set<Id> contactIdSet = new set<Id>();
        set<Id> wishFormCaseIdSet = new set<Id>();
        
       // add the case Id into the collection.
       for(Wish_Child_Form__c dbprocessWishChild : dbWishChildLiist){
           wishFormCaseIdSet.add(dbprocessWishChild.Case__c);
       }
       
       // Query the case records that contains in the set. And also add the wish child Id into the collection.
       for(Case dbCase : [SELECT Id,ContactId,Contact.AccountId FROM Case WHERE Id IN: wishFormCaseIdSet]){
        if(wishFormCaseIdSet.contains(dbCase.Id)){
            caseMap.put(dbCase.Id,dbCase);
            contactIdSet.add(dbCase.ContactId);
        }
       }
       
       // Query all the wish family contact records via relataionship object that npe4__Contact__c contains in contactIdSet.
       for(npe4__Relationship__c currRel : [SELECT id,npe4__RelatedContact__c,npe4__RelatedContact__r.FirstName, npe4__RelatedContact__r.LastName,
                                                 npe4__RelatedContact__r.Email,Hidden_isparentFirst__c,npe4__RelatedContact__r.Phone, npe4__RelatedContact__r.Middle_Name__c,npe4__RelatedContact__r.Mailingcity,npe4__RelatedContact__r.Mailingstreet,
                                                 npe4__RelatedContact__r.MailingState,npe4__RelatedContact__r.MailingPostalCode,npe4__Type__c,npe4__RelatedContact__r.HomePhone,npe4__RelatedContact__r.npe01__WorkPhone__c,npe4__RelatedContact__r.MobilePhone,npe4__RelatedContact__r.BirthDate FROM npe4__Relationship__c WHERE npe4__Contact__c  = : contactIdSet AND 
                                                 npe4__RelatedContact__r.RecordTypeId =: ContactRecordTypeId]){
             
             String name = currRel.npe4__RelatedContact__r.FirstName.trim()+' '+currRel.npe4__RelatedContact__r.Middle_Name__c+' '+currRel.npe4__RelatedContact__r.LastName.trim()+' '+currRel.npe4__RelatedContact__r.Email;
            relatedContactMap.put(name,currRel.npe4__RelatedContact__c);
       }
       
       // Query wish form records which have the case id in caseMap..
       dbWishChildFormList = [SELECT Driver_Details__c,RelatedContact__c,ParentsParticipantsName__c,TelePhone__c,
                           Does_each_requested_participant_Details__c,Name_of_wheelchair_collapsible__c,Age__c,Home_Phone__c,House_Hold_Account_Id__c,
                           Expiration_Date__c,Delivered_LiabilitySignerMapKeyPair__c,Migrated__c,Driver_License_Number__c,Does_your_family_Details__c,
                           Driver_Information__c,Will_a_rental_car_seat_s_Details__c,Delivered_Hidden_Envelop_Id__c,Will_a_rental_stroller_Details__c,RecordTypeId,
                           Hidden_Same_as_Family__c,Hidden_Wish_Fmaily_Contact_Name__c,Has_your_family_flown__c,Residing_With_Wish_Child__c,IsParticipant__c,
                           Electronics_Games_that_I_like_to_play__c,Contact__c,IsWishFamily__c,Hidden_Contact_Name__c,Self_describe_comment_box__c,
                           State__c,Does_Your_Medical_Insurance_Details__c,Does_Your_Medical_Insurance_Include__c,Signers__c,Will_handicap_accessible_Details__c,
                           Does_each_requested_participan__c,Are_all_requested_participants_Details__c,Street__c,Zip_Code__c,oxygen_Details__c,
                           Driver_Name__c,Emergency_First_Name__c,Information_Provided__c,Wish_Determination_Case_Id__c,City__c,Case_Team_Member1__c,
                           Case_Team_Member2__c,When_I_think_about_my_wish_I_imagine__c,When_thinking_some_of_my_wish_ideas_were__c,Wish_Notes__c,
                           To_me_the_most_important_part_of_my_wish__c,MY_WISH_IS_TO__c,Game__c,This_is_my_wish_because__c,LastModifiedDate,
                           Handicap_accommodations_be_required__c,Participant_require_a_wheelchair_Note__c,Requested_Participant_Name_for_Oxygen__c,
                           Requested_Participant_Name_forWheelchair__c,Requested_Participant_Name_for_OtherNeed__c,Requested_Participant_Name_for_Allergies__c,
                           Pariticipant_name_havingWheelchair_Power__c,Participant_dietary_restrictions_Note__c,Medication_require_refrigeration_name__c,
                           Participant_Name_for_Dietary_Restriction__c,Names_for_receiving_nursing_care__c,Participant_dietary_restrictions__c,
                           Parent_Legal_Guardian_Signature__c,Bringing_Own_Wheel_Chair__c,Participant_have_valid_passports_Note__c,Participant_have_allergies_to_food__c,
                           Participant_Contacts__c,Other__c,Music_Singer__c,Movie__c,OwnerId,LastName__c,Medication_require_refrigeration_Note__c,
                           mobilePhone__c,Is_the_wheelchair_collapsible__c,Middle_Name__c,Gender__c,LastModifiedById,Is_your_family_comfortable_in_rendal_car__c,
                           Is_the_wheelchair_power_Note__c,Is_the_wheelchair_power__c,Food__c,Is_a_wheelchair_accessible_vehicle_neede__c,Emergency_Mobilephone__c,
                           If_yes_Enter_Org_Name_Wish_Date_it_wa__c,Is_the_wheelchair_collapsible_Note__c,PrimaryAddreess__c,
                           Has_your_family_flown_before_Note__c,Handicap_accommodations_be_required_No__c,Hobby__c,Have_current_automobile_insurance__c,
                           FirstName__c,Has_your_family_flown_before__c,Does_your_family_have_a_credit_card_Note__c,Emergency_Last_Name__c,Email__c,
                           Does_your_family_have_a_credit_card__c,Emergency_Email__c,Color__c,Cake_Candy__c,When_I_m_outside_I_like_to__c,
                           Will_your_family_bring_wheelchair_Note__c,Wish_Family_Contact__c,Wish_child_receive_nursing_care_Note__c,Wish_child_receive_nursing_care__c,
                           Name,Will_your_family_bring_wheelchair__c,Will_an_interpreter_be_needed__c,Will_a_rental_stroller_be_needed_Note__c,
                           Will_a_rental_stroller_be_needed__c,Will_a_rental_car_seat_s_be_needed_Note__c,Will_a_rental_car_seat_s_be_needed__c,
                           Will_an_interpreter_be_needed_Note__c,When_I_m_with_my_friends_I_like_to__c,When_I_m_with_my_family_I_like_to__c,
                           CreatedDate,When_I_m_inside_I_like_to__c,TVShow__c,Preferred_Name__c,T_Shirt_Size__c,Restaurant__c,Social_Media_Link__c,Sport_Athlete__c,
                           Snack_Food__c,Sit_up_takeoff_landing_on_airplane_Note__c,Sit_up_takeoff_landing_on_airplane__c,Race_Ethnicity__c,Race_Ethnicity_Details__c,
                           Preferred_Driver_State__c,Preferred_Driver_Valid_D_L__c,IsDeleted,Emergency_Middle_Name__c,Preferred_Driver_Expiration_Date__c,
                           Does_participant_have_valid_photo_ID__c,Potential_Valid_D_L__c,Participant_require_oxygen_Note__c,Potential_Driver_Expiration_Date__c,
                           Potential_Driver_Name__c,Potential_Driver_State__c,Pet_Animal__c,Participant_have_valid_passports__c,Participant_require_oxygen_how_often__c,
                           Participant_have_valid_photo_ID_Note__c,Participant_require_medical_supplies__c,Participant_require_a_wheelchair__c,
                           Participant_require_medical_suppliesNote__c,Participant_require_a_wheelchair_Details__c,Availability_Time_Period_3__c,
                           Emergency_Relationship__c,Participant_have_allergies_to_food_Note__c,Diagnosis__c,Medication_require_refrigeration__c,
                           Details_about_Impact__c,Actor_Actress__c,Case__c,CreatedById,ClassinSchool__c,Additional_Requests__c,Book_Story__c,WishType__c,
                           Availability_Time_Period_2__c,Availability_Time_Period_1__c,Already_wish_granted_by_MAW_Other_Org__c,BirthDate__c,
                           Automobile_insurance_provide_coverage__c,Any_impact_your_ability_to_join_wish__c,Will_an_interpreter_be_needed_Details__c,
                           Id,Self__c,LastModifiedBy.Name From Wish_Child_Form__c 
                           WHERE Case__c IN: caseMap.KeySet()];

        
        // Create Json2apex(ParentGuardianJSON2Apex) class to format the json value into apex and stored into list.
        //ParentGuardianJSON2Apex is used to parese the all the parent gurdian values in to apex.
        ParentGuardianJSON2Apex  ParentGuIns = new ParentGuardianJSON2Apex();
        List<ParentGuardianJSON2Apex> parentGuardianList = new List<ParentGuardianJSON2Apex>();
        ParticipantJSON2Apex  ParticipantIns = new ParticipantJSON2Apex();
        List<ParticipantJSON2Apex> prticipantList = new List<ParticipantJSON2Apex>();
        DriverJason2Apex driverInfoIns = new DriverJason2Apex();
        List<DriverJason2Apex > driverList = new List<DriverJason2Apex >();
        
        //Itrate the dbWishChildFormList list and create wish form records with corresponding records type.
        for(Wish_Child_Form__c processWishChild : dbWishChildFormList){
       
                Wish_Child_Form__c wishChildRec = new Wish_Child_Form__c();
                 if(processWishChild.FirstName__c != null)
                wishChildRec.FirstName__c = processWishChild.FirstName__c.trim();
                if(processWishChild.Middle_Name__c != null)
                wishChildRec.Middle_Name__c = processWishChild.Middle_Name__c.trim();
                if(processWishChild.LastName__c != null)
                wishChildRec.LastName__c = processWishChild.LastName__c.trim();
                wishChildRec.Preferred_Name__c = processWishChild.Preferred_Name__c;
                wishChildRec.BirthDate__c = processWishChild.BirthDate__c;
                wishChildRec.Gender__c = processWishChild.Gender__c;
                wishChildRec.Self_describe_comment_box__c = processWishChild.Self_describe_comment_box__c;
                wishChildRec.Diagnosis__c = processWishChild .Diagnosis__c;
                wishChildRec.T_Shirt_Size__c = processWishChild.T_Shirt_Size__c;
                wishChildRec.Street__c = processWishChild .Street__c;
                wishChildRec.City__c = processWishChild .City__c;
                wishChildRec.Zip_Code__c = processWishChild .Zip_Code__c;
                wishChildRec.mobilePhone__c = processWishChild .mobilePhone__c;
                If(processWishChild .Email__c != Null && processWishChild .Email__c != '')
                    wishChildRec.Email__c = processWishChild .Email__c;
                wishChildRec.Color__c = processWishChild .Color__c;
                wishChildRec.Music_Singer__c = processWishChild .Music_Singer__c; 
                wishChildRec.Book_Story__c = processWishChild .Book_Story__c;
                wishChildRec.Hobby__c = processWishChild .Hobby__c;
                wishChildRec.Game__c = processWishChild .Game__c;
                wishChildRec.Movie__c = processWishChild .Movie__c;
                wishChildRec.Food__c = processWishChild .Food__c;
                wishChildRec.TVShow__c = processWishChild .TVShow__c;
                wishChildRec.Restaurant__c = processWishChild .Restaurant__c;
                wishChildRec.Actor_Actress__c = processWishChild .Actor_Actress__c;
                wishChildRec.Cake_Candy__c = processWishChild .Cake_Candy__c;
                wishChildRec.Sport_Athlete__c =  processWishChild .Sport_Athlete__c;
                wishChildRec.Snack_Food__c = processWishChild .Snack_Food__c;
                wishChildRec.Pet_Animal__c = processWishChild .Pet_Animal__c;
                wishChildRec.ClassinSchool__c = processWishChild .ClassinSchool__c;
                wishChildRec.Other__c = processWishChild .Other__c;
                wishChildRec.When_I_m_outside_I_like_to__c = processWishChild .When_I_m_outside_I_like_to__c;
                wishChildRec.When_I_m_inside_I_like_to__c = processWishChild .When_I_m_inside_I_like_to__c;
                wishChildRec.Electronics_Games_that_I_like_to_play__c = processWishChild .Electronics_Games_that_I_like_to_play__c;
                wishChildRec.When_I_m_with_my_family_I_like_to__c = processWishChild .When_I_m_with_my_family_I_like_to__c;
                wishChildRec.When_thinking_some_of_my_wish_ideas_were__c = processWishChild .When_thinking_some_of_my_wish_ideas_were__c;
                wishChildRec.MY_WISH_IS_TO__c = processWishChild .MY_WISH_IS_TO__c;
                wishChildRec.This_is_my_wish_because__c = processWishChild .This_is_my_wish_because__c;
                wishChildRec.When_I_m_with_my_friends_I_like_to__c = processWishChild .When_I_m_with_my_friends_I_like_to__c;
                wishChildRec.To_me_the_most_important_part_of_my_wish__c = processWishChild .To_me_the_most_important_part_of_my_wish__c;
                wishChildRec.When_I_think_about_my_wish_I_imagine__c = processWishChild .When_I_think_about_my_wish_I_imagine__c;
                wishChildRec.Wish_Notes__c = processWishChild .Wish_Notes__c;
                wishChildRec.Wish_Determination_Case_Id__c = processWishChild .Wish_Determination_Case_Id__c;
                wishChildRec.RecordTypeId = wichChildRecordTypeId;
                wishChildRec.Case__c = processWishChild.Case__c;
                if(caseMap.containsKey(processWishChild.Case__c)){
                wishChildRec.Contact__c  = caseMap.get(processWishChild.Case__c).ContactId;
                }
//                wishChildRec.Contact__c  = processWishChild.Contact__c;
                wishChildRec.Already_wish_granted_by_MAW_Other_Org__c = processWishChild.Already_wish_granted_by_MAW_Other_Org__c; 
                wishChildRec.If_yes_Enter_Org_Name_Wish_Date_it_wa__c = processWishChild.If_yes_Enter_Org_Name_Wish_Date_it_wa__c; 
                wishChildRec.Social_Media_Link__c = processWishChild .Social_Media_Link__c;
                wishChildRec.Preferred_Name__c = processWishChild.Preferred_Name__c;
                wishChildRec.Race_Ethnicity__c = processWishChild.Race_Ethnicity__c;
                wishChildRec.Race_Ethnicity_Details__c = processWishChild.Race_Ethnicity_Details__c;
                wishChildRec.Information_Provided__c = processWishChild.Information_Provided__c; 
                newWishChildFormList.add(wishChildRec);
            
             if(processWishChild.Wish_Family_Contact__c != Null){
                String json = string.valueof(processWishChild.Wish_Family_Contact__c);
                json = json.replace('&quot;', '"');
                json = json.replace('&amp;', '&');
                json = json.replace('&#39;', '\'');
                parentGuardianList = ParentGuIns.parse(json);
            }
             if(parentGuardianList.size() > 0){
             for(ParentGuardianJSON2Apex dbWishFamilyParentGurdian : parentGuardianList ){
                    String contactName;
                    if((dbWishFamilyParentGurdian.firstName != '' && dbWishFamilyParentGurdian.firstName != null) && (dbWishFamilyParentGurdian.lastName!= '' && dbWishFamilyParentGurdian.lastName!= null) &&
                     (dbWishFamilyParentGurdian.Email!= '' && dbWishFamilyParentGurdian.Email!= null) &&  (dbWishFamilyParentGurdian.MiddleName != '' && dbWishFamilyParentGurdian.MiddleName != null)){
                     contactName = dbWishFamilyParentGurdian.firstName.trim()+' '+dbWishFamilyParentGurdian.MiddleName+' '+dbWishFamilyParentGurdian.lastName.trim()+' '+dbWishFamilyParentGurdian.Email;
                     }
                     
                     else if((dbWishFamilyParentGurdian.firstName != '' && dbWishFamilyParentGurdian.firstName != null) && (dbWishFamilyParentGurdian.lastName!= '' && dbWishFamilyParentGurdian.lastName!= null) &&
                     (dbWishFamilyParentGurdian.Email == '' && dbWishFamilyParentGurdian.Email == null) &&  (dbWishFamilyParentGurdian.MiddleName != '' && dbWishFamilyParentGurdian.MiddleName != null)){
                     contactName = dbWishFamilyParentGurdian.firstName.trim()+' '+dbWishFamilyParentGurdian.MiddleName+' '+dbWishFamilyParentGurdian.lastName.trim();
                     }
                    
                     else if((dbWishFamilyParentGurdian.firstName != '' && dbWishFamilyParentGurdian.firstName != null) && (dbWishFamilyParentGurdian.lastName!= '' && dbWishFamilyParentGurdian.lastName!= null) &&
                     (dbWishFamilyParentGurdian.Email != '' && dbWishFamilyParentGurdian.Email != null) &&  (dbWishFamilyParentGurdian.MiddleName == '' && dbWishFamilyParentGurdian.MiddleName == null)){
                     contactName = dbWishFamilyParentGurdian.firstName.trim()+' '+dbWishFamilyParentGurdian.lastName.trim()+' '+dbWishFamilyParentGurdian.Email;
                     }
                     
                     else if((dbWishFamilyParentGurdian.firstName != '' && dbWishFamilyParentGurdian.firstName != null) && (dbWishFamilyParentGurdian.lastName!= '' && dbWishFamilyParentGurdian.lastName!= null) &&
                     (dbWishFamilyParentGurdian.Email == '' && dbWishFamilyParentGurdian.Email == null) &&  (dbWishFamilyParentGurdian.MiddleName == '' && dbWishFamilyParentGurdian.MiddleName == null)){
                     contactName = dbWishFamilyParentGurdian.firstName.trim()+' '+dbWishFamilyParentGurdian.lastName.trim();
                     }
                     
                     
                    Wish_Child_Form__c wishFamilyRec = new Wish_Child_Form__c();
                    if(dbWishFamilyParentGurdian.firstName != null && dbWishFamilyParentGurdian.firstName != '')
                    wishFamilyRec.FirstName__c = dbWishFamilyParentGurdian.firstName.trim();
                    if(dbWishFamilyParentGurdian.MiddleName != null && dbWishFamilyParentGurdian.MiddleName!= '')
                    wishFamilyRec.Middle_Name__c = dbWishFamilyParentGurdian.MiddleName.trim();
                    if(dbWishFamilyParentGurdian.lastName != null && dbWishFamilyParentGurdian.lastName != '')
                    wishFamilyRec.LastName__c  = dbWishFamilyParentGurdian.lastName.trim();
                    wishFamilyRec.mobilePhone__c = dbWishFamilyParentGurdian.mobileTelephone ;
                    //system.debug('@@@ Date.valueof(dbWishFamilyParentGurdian.dob) @@@'+Date.valueof(dbWishFamilyParentGurdian.dob));
                    if(dbWishFamilyParentGurdian.dob != null && dbWishFamilyParentGurdian.dob != '')
                    wishFamilyRec.BirthDate__c = Date.valueof(dbWishFamilyParentGurdian.dob);
                    If(dbWishFamilyParentGurdian.Email != Null && dbWishFamilyParentGurdian.Email != '')
                        wishFamilyRec.Email__c =  dbWishFamilyParentGurdian.Email ;
                    wishFamilyRec.city__c  = dbWishFamilyParentGurdian.City; 
                    wishFamilyRec.Street__c = dbWishFamilyParentGurdian.Street ;
                    wishFamilyRec.State__c = dbWishFamilyParentGurdian.State ;
                    wishFamilyRec.Zip_code__c = dbWishFamilyParentGurdian.PostalCode;
                    wishFamilyRec.Emergency_Relationship__c = dbWishFamilyParentGurdian.relationship;
                    wishFamilyRec.Home_Phone__c =  dbWishFamilyParentGurdian.homeTelephone ;
                    wishFamilyRec.TelePhone__c =  dbWishFamilyParentGurdian.workTelephone;
                    wishFamilyRec.T_Shirt_Size__c = dbWishFamilyParentGurdian.tshirtSize;
                    wishFamilyRec.Residing_With_Wish_Child__c= dbWishFamilyParentGurdian.residingWishMedical;
                    if(dbWishFamilyParentGurdian.sameParentGuardianFlag == true || dbWishFamilyParentGurdian.sameParentGuardianFlag == false)
                    wishFamilyRec.Hidden_Same_as_Family__c = dbWishFamilyParentGurdian.sameParentGuardianFlag;
                    wishFamilyRec.Case__c = processWishChild.Case__c;
                    wishFamilyRec.RecordTypeId = familyContactRecordTypeId;
                    if(dbWishFamilyParentGurdian.relId != Null && dbWishFamilyParentGurdian.relId != ''){
                        wishFamilyRec.Contact__c  = dbWishFamilyParentGurdian.relId ;
                    }
                    else if(relatedContactMap.containsKey(contactName) && relatedContactMap.get(contactName) != '' && relatedContactMap.get(contactName) != Null){
                    wishFamilyRec.Contact__c  = relatedContactMap.get(contactName);
                    }
                    wishFamilyRec.IsParticipant__c = false;
                    newWishChildFormList.add(wishFamilyRec);
                    }
            }
            if(processWishChild.Participant_Contacts__c != Null && processWishChild.Participant_Contacts__c != ''){
                String particiapant = string.valueof(processWishChild.Participant_Contacts__c);
                particiapant = particiapant.replace('&quot;', '"');
                particiapant = particiapant.replace('&amp;', '&');
                particiapant = particiapant.replace('&#39;', '\'');
                prticipantList = ParticipantIns.parse(particiapant);
            }
            if(prticipantList.size() > 0){
                for(ParticipantJSON2Apex  dbWishFamilyParticipant: prticipantList){
                   
                    String contactName;
                    if((dbWishFamilyParticipant.firstName != '' && dbWishFamilyParticipant.firstName != null) && (dbWishFamilyParticipant.lastName!= '' && dbWishFamilyParticipant.lastName!= null) &&
                     (dbWishFamilyParticipant.Email!= '' && dbWishFamilyParticipant.Email!= null) &&  (dbWishFamilyParticipant.MiddleName != '' && dbWishFamilyParticipant.MiddleName != null)){
                     contactName = dbWishFamilyParticipant.firstName.trim()+' '+dbWishFamilyParticipant.MiddleName+' '+dbWishFamilyParticipant.lastName.trim()+' '+dbWishFamilyParticipant.Email;
                     }
                     
                     else if((dbWishFamilyParticipant.firstName != '' && dbWishFamilyParticipant.firstName != null) && (dbWishFamilyParticipant.lastName!= '' && dbWishFamilyParticipant.lastName!= null) &&
                     (dbWishFamilyParticipant.Email == '' && dbWishFamilyParticipant.Email == null) &&  (dbWishFamilyParticipant.MiddleName != '' && dbWishFamilyParticipant.MiddleName != null)){
                     contactName = dbWishFamilyParticipant.firstName.trim()+' '+dbWishFamilyParticipant.MiddleName+' '+dbWishFamilyParticipant.lastName.trim();
                     }
                    
                     else if((dbWishFamilyParticipant.firstName != '' && dbWishFamilyParticipant.firstName != null) && (dbWishFamilyParticipant.lastName!= '' && dbWishFamilyParticipant.lastName!= null) &&
                     (dbWishFamilyParticipant.Email != '' && dbWishFamilyParticipant.Email != null) &&  (dbWishFamilyParticipant.MiddleName == '' && dbWishFamilyParticipant.MiddleName == null)){
                     contactName = dbWishFamilyParticipant.firstName.trim()+' '+dbWishFamilyParticipant.lastName.trim()+' '+dbWishFamilyParticipant.Email;
                     }
                     
                     else if((dbWishFamilyParticipant.firstName != '' && dbWishFamilyParticipant.firstName != null) && (dbWishFamilyParticipant.lastName!= '' && dbWishFamilyParticipant.lastName!= null) &&
                     (dbWishFamilyParticipant.Email == '' && dbWishFamilyParticipant.Email == null) &&  (dbWishFamilyParticipant.MiddleName == '' && dbWishFamilyParticipant.MiddleName == null)){
                     contactName = dbWishFamilyParticipant.firstName.trim()+' '+dbWishFamilyParticipant.lastName.trim();
                     }
                   
                   Wish_Child_Form__c wishFamilyParticipantRec = new Wish_Child_Form__c();
                   if(dbWishFamilyParticipant.firstName != null && dbWishFamilyParticipant.firstName != '')
                   wishFamilyParticipantRec.FirstName__c = dbWishFamilyParticipant.firstName.trim();
                   if(dbWishFamilyParticipant.MiddleName != null && dbWishFamilyParticipant.MiddleName != '')
                   wishFamilyParticipantRec.Middle_Name__c = dbWishFamilyParticipant.MiddleName.trim();
                   if(dbWishFamilyParticipant.lastName != null && dbWishFamilyParticipant.lastName != '')
                   wishFamilyParticipantRec.LastName__c  = dbWishFamilyParticipant.lastName.trim();
                   if(dbWishFamilyParticipant.dob != '' && dbWishFamilyParticipant.dob != Null)
                   wishFamilyParticipantRec.BirthDate__c = Date.valueOf(dbWishFamilyParticipant.dob);
                   If(dbWishFamilyParticipant.Email != Null && dbWishFamilyParticipant.Email != '')
                       wishFamilyParticipantRec.Email__c =  dbWishFamilyParticipant.Email;
                   wishFamilyParticipantRec.T_Shirt_Size__c = dbWishFamilyParticipant.tshirtSize;
                   wishFamilyParticipantRec.Residing_With_Wish_Child__c= dbWishFamilyParticipant.residingWishMedical;
                   wishFamilyParticipantRec.Case__c = processWishChild.Case__c;
                   wishFamilyParticipantRec.RecordTypeId = familyContactRecordTypeId;
                   wishFamilyParticipantRec.IsParticipant__c = true;
                   wishFamilyParticipantRec.Hidden_Same_as_Family__c = false;
                   if(relatedContactMap.containsKey(contactName)){
                    wishFamilyParticipantRec.Contact__c  = relatedContactMap.get(contactName);
                   }
                   wishFamilyParticipantRec.Emergency_Relationship__c = dbWishFamilyParticipant.relationship;
                   newWishChildFormList.add(wishFamilyParticipantRec);
                }
           }
           if(processWishChild.Driver_Details__c != Null){
               String json = string.valueof(processWishChild.Driver_Details__c );
                json = json.replace('&quot;', '"');
                json = json.replace('&amp;', '&');
                json = json.replace('&#39;', '\'');
                driverList = driverInfoIns.parse(json);
           }
           if(driverList.size() > 0){
            for(DriverJason2Apex processDriverRec : driverList ){
                Wish_Child_Form__c driverObj= new Wish_Child_Form__c();
                driverObj.Driver_Name__c = processDriverRec .driverName;
                driverObj.State__c = processDriverRec .state;
                //driverObj.Expiration_Date__c = Date.valueOf(processDriverRec .expirationDate);
                driverObj.Driver_License_Number__c  = processDriverRec .licenseNum ;
                driverObj.RecordTypeId = driverContactRecordType;
                driverObj.Case__c = processWishChild.Case__c;
//                driverObj.Contact__c  = driverObj.Contact__c;
                newWishChildFormList.add(driverObj);
           }
           }
           
            Wish_Child_Form__c determinationcase = new Wish_Child_Form__c();
            determinationcase.Wish_Determination_Case_Id__c = processWishChild.Wish_Determination_Case_Id__c; 
            determinationcase.Availability_Time_Period_1__c = processWishChild.Availability_Time_Period_1__c ;
            determinationcase.Availability_Time_Period_2__c = processWishChild.Availability_Time_Period_2__c ;
            determinationcase.Availability_Time_Period_3__c = processWishChild.Availability_Time_Period_3__c;
            determinationcase.Requested_Participant_Name_forWheelchair__c = processWishChild.Requested_Participant_Name_forWheelchair__c ;
            determinationcase.Participant_Name_for_Dietary_Restriction__c = processWishChild.Participant_Name_for_Dietary_Restriction__c ;
            determinationcase.Requested_Participant_Name_for_OtherNeed__c = processWishChild.Requested_Participant_Name_for_OtherNeed__c ;
            determinationcase.Requested_Participant_Name_for_Oxygen__c = processWishChild.Requested_Participant_Name_for_Oxygen__c ;
            determinationcase.Requested_Participant_Name_for_Allergies__c = processWishChild.Requested_Participant_Name_for_Allergies__c ;
            determinationcase.Bringing_Own_Wheel_Chair__c = processWishChild.Bringing_Own_Wheel_Chair__c ;
            determinationcase.Name_of_wheelchair_collapsible__c= processWishChild.Name_of_wheelchair_collapsible__c;
            determinationcase.Pariticipant_name_havingWheelchair_Power__c= processWishChild.Pariticipant_name_havingWheelchair_Power__c;
            determinationcase.Medication_require_refrigeration_name__c= processWishChild.Medication_require_refrigeration_name__c;
            determinationcase.Names_for_receiving_nursing_care__c= processWishChild.Names_for_receiving_nursing_care__c;
            determinationcase.Details_about_Impact__c = processWishChild .Details_about_Impact__c;
            determinationcase.Participant_require_oxygen_how_often__c = processWishChild .Participant_require_oxygen_how_often__c;
            determinationcase.Participant_require_oxygen_Note__c = processWishChild .Participant_require_oxygen_Note__c;
            determinationcase.Participant_dietary_restrictions__c = processWishChild .Participant_dietary_restrictions__c;
            determinationcase.Participant_dietary_restrictions_Note__c = processWishChild .Participant_dietary_restrictions_Note__c;
            determinationcase.Participant_have_allergies_to_food__c = processWishChild .Participant_have_allergies_to_food__c; 
            determinationcase.Participant_have_allergies_to_food_Note__c = processWishChild .Participant_have_allergies_to_food_Note__c;
            determinationcase.Medication_require_refrigeration__c = processWishChild .Medication_require_refrigeration__c; 
            determinationcase.Medication_require_refrigeration_Note__c = processWishChild .Medication_require_refrigeration_Note__c;
            determinationcase.Wish_child_receive_nursing_care__c = processWishChild .Wish_child_receive_nursing_care__c;
            determinationcase.Participant_require_medical_supplies__c = processWishChild .Participant_require_medical_supplies__c; 
            determinationcase.Participant_require_medical_suppliesNote__c = processWishChild .Participant_require_medical_suppliesNote__c;
            determinationcase.Participant_require_a_wheelchair__c = processWishChild .Participant_require_a_wheelchair__c; 
            determinationcase.Participant_require_a_wheelchair_Note__c = processWishChild .Participant_require_a_wheelchair_Note__c;
            determinationcase.Will_your_family_bring_wheelchair__c = processWishChild .Will_your_family_bring_wheelchair__c; 
            determinationcase.Will_your_family_bring_wheelchair_Note__c = processWishChild .Will_your_family_bring_wheelchair_Note__c;
            determinationcase.Is_the_wheelchair_collapsible__c = processWishChild .Is_the_wheelchair_collapsible__c; 
            determinationcase.Is_the_wheelchair_collapsible_Note__c = processWishChild .Is_the_wheelchair_collapsible_Note__c; 
            determinationcase.Is_the_wheelchair_power__c = processWishChild .Is_the_wheelchair_power__c;
            determinationcase.Is_the_wheelchair_power_Note__c = processWishChild .Is_the_wheelchair_power_Note__c;
            determinationcase.Has_your_family_flown_before__c = processWishChild .Has_your_family_flown_before__c;
            determinationcase.Has_your_family_flown__c = processWishChild .Has_your_family_flown__c;
            determinationcase.Will_an_interpreter_be_needed__c = processWishChild .Will_an_interpreter_be_needed__c;
            determinationcase.Will_an_interpreter_be_needed_Details__c = processWishChild .Will_an_interpreter_be_needed_Details__c;
            determinationcase.Will_a_rental_car_seat_s_be_needed__c = processWishChild .Will_a_rental_car_seat_s_be_needed__c;
            determinationcase.Will_a_rental_car_seat_s_Details__c = processWishChild .Will_a_rental_car_seat_s_Details__c;
            determinationcase.Sit_up_takeoff_landing_on_airplane__c = processWishChild .Sit_up_takeoff_landing_on_airplane__c;
            determinationcase.Are_all_requested_participants_Details__c = processWishChild .Are_all_requested_participants_Details__c; 
            determinationcase.Will_a_rental_stroller_be_needed__c = processWishChild .Will_a_rental_stroller_be_needed__c; 
            determinationcase.Will_a_rental_stroller_Details__c = processWishChild .Will_a_rental_stroller_Details__c;
            determinationcase.Handicap_accommodations_be_required__c = processWishChild .Handicap_accommodations_be_required__c;
            determinationcase.Will_handicap_accessible_Details__c = processWishChild .Will_handicap_accessible_Details__c;
            determinationcase.Participant_have_valid_passports__c = processWishChild .Participant_have_valid_passports__c; 
            determinationcase.Does_each_requested_participant_Details__c = processWishChild .Does_each_requested_participant_Details__c; 
            determinationcase.Does_participant_have_valid_photo_ID__c = processWishChild .Does_participant_have_valid_photo_ID__c; 
            determinationcase.Does_each_requested_participan__c = processWishChild .Does_each_requested_participan__c;
            determinationcase.Does_Your_Medical_Insurance_Include__c = processWishChild .Does_Your_Medical_Insurance_Include__c; 
            determinationcase.Does_Your_Medical_Insurance_Details__c = processWishChild .Does_Your_Medical_Insurance_Details__c;
            determinationcase.Does_your_family_have_a_credit_card__c = processWishChild .Does_your_family_have_a_credit_card__c; 
            determinationcase.Does_your_family_Details__c = processWishChild .Does_your_family_Details__c;
            //determinationcase.Driver_Information__c = driverdetails; 
            determinationcase.Information_Provided__c = processWishChild .Information_Provided__c;
            determinationcase.RecordTypeId = wishDterminationCaseRecordTypeId;
            determinationcase.Case__c = processWishChild .Case__c;
            //determinationcase.Contact__c  = processWishChild .Contact__c;
            determinationcase.Have_current_automobile_insurance__c = processWishChild .Have_current_automobile_insurance__c;
            determinationcase.Automobile_insurance_provide_coverage__c = processWishChild .Automobile_insurance_provide_coverage__c; 
            determinationcase.Is_your_family_comfortable_in_rendal_car__c = processWishChild .Is_your_family_comfortable_in_rendal_car__c; 
            determinationcase.Is_a_wheelchair_accessible_vehicle_neede__c = processWishChild .Is_a_wheelchair_accessible_vehicle_neede__c;
            determinationcase.Wish_child_receive_nursing_care_Note__c= processWishChild .Wish_child_receive_nursing_care_Note__c;
            newWishChildFormList.add(determinationcase);
            
            Wish_Child_Form__c wishFamilyEmergencyContact = new Wish_Child_Form__c();
            wishFamilyEmergencyContact.FirstName__c = processWishChild.Emergency_First_Name__c;
            wishFamilyEmergencyContact.Middle_Name__c = processWishChild.Emergency_Middle_Name__c;
            wishFamilyEmergencyContact.LastName__c  = processWishChild.Emergency_Last_Name__c;
            If(processWishChild.Emergency_Email__c != Null && processWishChild.Emergency_Email__c != '')
                wishFamilyEmergencyContact.Email__c = processWishChild.Emergency_Email__c;
            wishFamilyEmergencyContact.mobilePhone__c = processWishChild.Emergency_Mobilephone__c;
            wishFamilyEmergencyContact.Emergency_Relationship__c = processWishChild.Emergency_Relationship__c;
            wishFamilyEmergencyContact.Case_Team_Member1__c = processWishChild.Case_Team_Member1__c; 
            wishFamilyEmergencyContact.Case_Team_Member2__c = processWishChild.Case_Team_Member2__c;
            wishFamilyEmergencyContact.RecordTypeId = emergencyContactRecordTypeId;
            wishFamilyEmergencyContact.Case__c = processWishChild.Case__c;
            if(caseMap.containsKey(processWishChild.Case__c))
            wishFamilyEmergencyContact.House_Hold_Account_Id__c = caseMap.get(processWishChild.Case__c).contact.AccountId;
            system.debug('@@@ Acccount Id @@@'+ wishFamilyEmergencyContact.House_Hold_Account_Id__c);
            newWishChildFormList.add(wishFamilyEmergencyContact);
           
            processWishChild.Migrated__c = true;
            dbWishChildFormUpdateList.add(processWishChild);
            
        }
        // insert new format wish form records.
        if(newWishChildFormList.size() > 0)
        insert newWishChildFormList;
        // update exisiting wish form records as migrated check box as true.
        if(dbWishChildFormUpdateList.size() > 0)
        update dbWishChildFormUpdateList;
       
       
    }   
    // Finish method.
    global void finish(Database.BatchableContext BC) {
        
    }
}