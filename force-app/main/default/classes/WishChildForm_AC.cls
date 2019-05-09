/************************************************************************************************************************************
Created by: Vennila Paramasivam & Kanagaraj
Author : MST Solutions
CreateDate : 06/01/2016
Description : This WishChildForm_AC class is used to update wish child contact and wish family contact details.
And aslo we can able to add additional parent legaual guardian and participant in wish family form and 
we can add dervier details,medical information and travel information in wish information form.
And we can able to electronic sign this form with details volunteer has filled using sing now and
send for signature options.And user can able to download this form. Once all the information hase been 
entered the volunteer is submit this record for approval. Once the chapter staff approved this record
the corresponding details are updated in wish child and wish family and wish record. It also create relationship
record.
**************************************************************************************************************************************/

public Class WishChildForm_AC{
    Constant_AC  constant = new Constant_AC();
    Public Id familyContactRecordTypeId{get;set;}
    Public Id wichChildRecordTypeId{get;set;}
    Public Id emergencyContactRecordTypeId{get;set;}
    Public Id wishDterminationCaseRecordTypeId{get;set;}
    Public Id driverContactRecordType{get;set;}
    Public Id ContactFamilyRecordTypeId;
    Public Id casewishDeterminatioRecordTypeId;
    public WishChildFormUtil wcfUtil{get;set;}
    public Case currCase{get;set;}
    public Wish_Child_Form__c currWishChild{get;set;}
    public Wish_Child_Form__c emergencyChild{get;set;}
    public Wish_Child_Form__c determinationcaseInfo{get;set;}
    public Id currentPageId;
    public Boolean isChildPart = false;
    public Boolean isParticipants {get;set;}
    public List<string> tempName = new List<string>();
    public List<String> ethnicityList = new List<String>();
    public List<String>currentOwnWheelChairList =new List<String>();
    Public List<String>currentWCCollapsibleList = new List<String>();
    Public List<String>currentWCPowerList = new List<String>();
    Public List<String>currentOxygenNamesList = new List<String>();
    Public List<String>currrentDietaryNameList = new List<String>();
    Public List<String>currentNursingCareList = new List<String>();
    Public List<String>currentMedicationList = new List<String>();
    Public List<String>currentAllergyNamesList = new List<String>();
    Public List<String>currentOtherNeedsList = new List<String>();
    public String tshirt{get;set;}
    public boolean isWishchildFormRequired{get;set;}
    public boolean isWishfamilyFormRequired{get;set;}
    public Integer j = 0;
    public Integer k = 0;
    Public String driverInfo = '';
    public Set<String> relationShipSet = new Set<String>();
    public Map<String,String> processedNameMap;
    public Map<String,String> nameMap;
    public Set<String> signerSet;
    public boolean displaypopwindow{get;set;}
    public string attachmentId {get; set;}
    public Attachment newAttachment {get; set;}
    public Id recId;    
    public boolean isSaved{get;set;}
    public boolean isDeleted{get;set;}
    public List<cg__CaseFile__c> attachmentList{get;set;}
    public boolean sucess{get;set;}
    public boolean showException;
    public string pageName;
    public string participantName;
    public string participantEmail;
    public string formName;
    public string gurdianName;
    public string associatedParticipant;
    public List<Wish_Child_Form__c> disPlayWishChildList{get;set;}
    public List<Wish_Child_Form__c> displayWishFamilyList{get;set;}
    public List<Wish_Child_Form__c> displayWishFamilyParticipantList{get;set;}
    public List<Wish_Child_Form__c> determinationCaseList{get;set;}
    public List<Wish_Child_Form__c> driverInformationList{get;set;}
    Public List<Wish_Child_Form__c> wishFormList{get;set;}
    public List<SelectOption> signNowList{get;set;}
    public string SignNowName{get;set;}
    Public Map<String,String> sendEmailMap{get;set;}
    Public Id determinationcaseId;
    public String signerName{get;set;}
    /********************************************************************************************
This is the constructor method will call when the wishchild form is open and it display
all the wish child details and wish family details in wish child form and wish family form. 
**********************************************************************************************/
    
    public WishChildForm_AC(Apexpages.StandardController controller){
        currentPageId =  ApexPages.currentPage().getParameters().get('id');
        isChildPart = false ;
        isParticipants  = false;         
        if(wcfUtil == null)   
            wcfUtil = new WishChildFormUtil();
        processedNameMap = new Map<String,String>();
        nameMap = new Map<String,String>();
        signerSet = new Set<String>();
        displaypopwindow = false;        
        newAttachment = new Attachment();
        currentPageId =  ApexPages.currentPage().getParameters().get('id');
        wishFormList  = new List<Wish_Child_Form__c>();
        disPlayWishChildList = new List<Wish_Child_Form__c>();
        displayWishFamilyList = new List<Wish_Child_Form__c>();
        displayWishFamilyParticipantList = new List<Wish_Child_Form__c>();
        determinationCaseList = new List<Wish_Child_Form__c>();
        driverInformationList = new List<Wish_Child_Form__c>(); 
        currWishChild = new Wish_Child_Form__c();
        emergencyChild = new Wish_Child_Form__c();
        determinationcaseInfo = new Wish_Child_Form__c();
        sendEmailMap = new Map<String,String>();
        integer i = 0;
        familyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormFamily).getRecordTypeId();
        wichChildRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChild).getRecordTypeId();
        wishDterminationCaseRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormDeterMination).getRecordTypeId(); 
        driverContactRecordType = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildDriver).getRecordTypeId(); 
        emergencyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildEmergency).getRecordTypeId(); 
        casewishDeterminatioRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get(constant.wishDeterminationRT ).getRecordTypeId(); 
        if(ApexPages.currentPage().getParameters().get('saved') != null && ApexPages.currentPage().getParameters().get('saved') == 'true'){
            isSaved = true;
        } 
        
        this.currCase = (Case)controller.getRecord();
        recId = this.currCase.Id;
        attachmentList =new List<cg__CaseFile__c>();
        this.currCase = [SELECT id,Hidden_Email_List__c,ContactId,Contact.FirstName,Contact.LastName, Contact.Middle_Name__c,Contact.Current_Age__c,
                         Contact.Diagnosis__c , Contact.Email, Contact.MobilePhone, Contact.Gender__C, Contact.Self_describe_comment_box__c,
                         Contact.BirthDate, Contact.T_Shirt_Size__c, Contact.MailingStreet,
                         Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode,ChapterName__r.Name,Contact.Name,contact.AccountId
                         FROM Case WHERE Id = :this.currCase.id limit 1];
        
        
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        
        String queueName = '';
        if(!String.IsBlank(currCase.ChapterName__r.Name) && currCase.ChapterName__r.Name.contains('Make-A-Wish ')) {
            queueName = currCase.ChapterName__r.Name.remove('Make-A-Wish ');
        }
        
        List<Group> groupInfoList = [Select Id from Group where type='Queue' and Name =: queueName];
        Set<Id> groupMemberIdSet= new Set<Id>();
        if(groupInfoList.size() > 0) {
            for(GroupMember groupMem : [Select Id, UserOrGroupId From GroupMember where GroupId =: groupInfoList[0].Id]) {
                groupMemberIdSet.add(groupMem.UserOrGroupId);
            }
        }
        
        
        
        if(currentPageId != null){
            List<ProcessInstanceWorkitem> approvalIns = [SELECT Id,ActorId,OriginalActorId,ProcessInstanceId,ProcessInstance.TargetObjectId,ProcessInstance.Status,ProcessInstance.ProcessDefinition.Name FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: currentPageId AND ProcessInstance.Status =: 'Pending' AND ProcessInstance.ProcessDefinition.Name =: 'Wish Paperwork Packet'
                                                         AND (((ActorId !=: UserInfo.getUserId() AND ActorId NOT IN : groupMemberIdSet) AND (OriginalActorId !=: UserInfo.getUserId() AND OriginalActorId NOT IN : groupMemberIdSet)))];
            
            
            List<CaseTeamMember> caseTeamMemberList = [SELECT id,Member.Name FROM CaseTeamMember WHERE ParentId =: this.currCase.id AND TeamRole.Name = 'Wish Granter' limit 2];
            
            List<case> determinationcaseList = [SELECT Id,ParentId, RecordTypeId FROM Case WHERE RecordTypeId =:casewishDeterminatioRecordTypeId  AND  ParentId =: currentPageId];
            determinationcaseId = determinationcaseList[0].Id;
            
            If(approvalIns.size() > 0 && Wish_Form_Approval__c.getValues(PROFILE[0].Id) == Null && !groupMemberIdSet.contains(UserInfo.getUserId())){ 
                wcfUtil.approvalError = true;
            }
            
            
            if(this.currCase.Id != null){
                String caseId = this.currCase.id;
                boolean migrated = false;
                String wishChildQuery = 'SELECT ';
                for(Schema.FieldSetMember f : wcfUtil.getWishChildFields()) {
                    wishChildQuery+= f.getFieldPath() + ', ';
                }
                wishChildQuery = WishchildQuery.removeEnd(', ');
                wishChildQuery+= ' from Wish_Child_Form__c' + ' WHERE Case__c = :'+'caseId'+' AND Migrated__c =: migrated ';
                wishFormList = Database.Query(wishChildQuery);
            } 
            if(wishFormList.size() == 0){
                init();
            } 
            else {
                system.debug('@@@@ Enter into ELSE @@@@');
                
                for(Wish_Child_Form__c dbWishFormRec : wishFormList){
                    if(dbWishFormRec.RecordTypeId == emergencyContactRecordTypeId ){
                        
                        emergencyChild = dbWishFormRec;
                    }
                    if(dbWishFormRec.RecordTypeId == familyContactRecordTypeId && dbWishFormRec.IsParticipant__c == true){
                        displayWishFamilyParticipantList.add(dbWishFormRec);
                        
                    }
                    if(dbWishFormRec.RecordTypeId == familyContactRecordTypeId && dbWishFormRec.IsParticipant__c == false){
                        displayWishFamilyList.add(dbWishFormRec);
                        
                    }
                    if(dbWishFormRec.RecordTypeId == wichChildRecordTypeId){
                        if(dbWishFormRec.BirthDate__c != Null){
                            Date dt = Date.Valueof(dbWishFormRec.BirthDate__c);
                            Integer days = dt.daysBetween(Date.Today());
                            Integer age = Integer.valueOf(days/365);
                            String name = dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
                            if(age > = 18){
                                processedNameMap.put(name,dbWishFormRec.Email__c);
                            }
                        }
                        if(caseTeamMemberList.size() > 0){
                            dbWishFormRec.Case_Team_Member1__c = caseTeamMemberList[0].Member.Name;
                            if(caseTeamMemberList.size() > 1)
                                dbWishFormRec.Case_Team_Member2__c = caseTeamMemberList[1].Member.Name;
                        }
                        if(dbWishFormRec.FirstName__c == Null || dbWishFormRec.LastName__c == Null || dbWishFormRec.BirthDate__c == Null ||  
                           dbWishFormRec.Street__c ==  Null || dbWishFormRec.City__c == Null || dbWishFormRec.State__c == Null ||
                           dbWishFormRec.Zip_Code__c ==  Null || (dbWishFormRec.Gender__c == 'Self-describe' && dbWishFormRec.Self_describe_comment_box__c == Null)){
                               isWishchildFormRequired = true;
                           }
                        else{    
                            currWishChild = dbWishFormRec;
                        }  
                        disPlayWishChildList.add(dbWishFormRec);
                        
                    }
                    if(dbWishFormRec.RecordTypeId == driverContactRecordType){
                        driverInformationList.add(dbWishFormRec);
                    }
                    if(dbWishFormRec.RecordTypeId == wishDterminationCaseRecordTypeId){
                        determinationcaseInfo = dbWishFormRec;
                        
                        if(determinationcaseInfo .Availability_Time_Period_1__c != null){
                            List<String> currString =  (determinationcaseInfo .Availability_Time_Period_1__c).split('/');
                            if(currString.size() > 0)
                                wcfUtil.availableMonth1 = currString[0];
                            if(CurrString.size() > 1)
                                wcfUtil.availableYear1 = currString[1];
                        }
                        if( determinationcaseInfo .Availability_Time_Period_2__c != null){
                            List<String> currString =  (determinationcaseInfo .Availability_Time_Period_2__c).split('/');
                            if(currString.size() > 0)
                                wcfUtil.availableMonth2 = currString[0];
                            if(CurrString.size() > 1)
                                wcfUtil.availableYear2 = currString[1];
                        }
                        if( determinationcaseInfo .Availability_Time_Period_3__c != null){
                            List<String> currString =  (determinationcaseInfo .Availability_Time_Period_3__c).split('/');
                            if(currString.size() > 0)
                                wcfUtil.availableMonth3 = currString[0];
                            if(CurrString.size() > 1)
                                wcfUtil.availableYear3 = currString[1];
                        }  
                    } 
                }
            }
            if(disPlayWishChildList.size() > 0){
                if(disPlayWishChildList[0].Hidden_Same_as_Family__c  == true){
                    wishChildMap(disPlayWishChildList[0].FirstName__c,disPlayWishChildList[0].LastName__c);
                }
            }
            if(displayWishFamilyList.size() > 0){
                ParentLegalMapping(displayWishFamilyList); 
            }
            if(displayWishFamilyParticipantList.size() > 0){
                ParticipantsMapping(displayWishFamilyParticipantList); 
            }
            displaySignNowList();
            
            for(Wish_Child_Form__c parentGurdian : displayWishFamilyList){
                
                if(i == 0){ 
                    if(parentGurdian.FirstName__c == null || parentGurdian.LastName__c == null ||  parentGurdian.Emergency_Relationship__c  == null || parentGurdian.city__c == null || parentGurdian.Street__c == null || parentGurdian.State__c == null|| 
                       parentGurdian.Zip_code__c == null || parentGurdian.BirthDate__c == null|| parentGurdian.Residing_With_Wish_Child__c == null || (parentGurdian.Home_Phone__c == null && parentGurdian.TelePhone__c == null && parentGurdian.mobilePhone__c == null) && parentGurdian.RecordTypeId == familyContactRecordTypeId)
                    {  
                        
                        isWishfamilyFormRequired = true;
                    }
                }
                else{
                    if(parentGurdian.FirstName__c == null || parentGurdian.LastName__c == null ||  parentGurdian.Emergency_Relationship__c  == null ||  
                       parentGurdian.BirthDate__c == null || parentGurdian.Residing_With_Wish_Child__c == null || (parentGurdian.Home_Phone__c == null && parentGurdian.TelePhone__c == null && parentGurdian.mobilePhone__c == null) && parentGurdian.RecordTypeId == familyContactRecordTypeId)
                    {   
                        isWishfamilyFormRequired = true;
                    }
                }
                i++;
            }
            
            for(Wish_Child_Form__c participant : displayWishFamilyParticipantList){
                if(participant.FirstName__c  == null || participant.LastName__c  == null ||  participant.Emergency_Relationship__c  == null ||  
                   participant.BirthDate__c == null || participant.Residing_With_Wish_Child__c == null && participant.RecordTypeId == familyContactRecordTypeId){
                       isWishfamilyFormRequired = true;
                   } 
            }
            
        }
    }
    
    
    /********************************************************************************************
This is the init() method is used to query all the related contact details and this details are
displayed in wishfamily form.
**********************************************************************************************/
    public void init(){
    }
    
    /********************************************************************************************
This is the SaveContact() method is used to all the details entered in wish child, wish family and 
Wish information form.
**********************************************************************************************/
    public void SaveContact(){
        List<Wish_Child_Form__c> saveWishFormList = new List<Wish_Child_Form__c>();
        Set<String> nameset = new Set<String>();
        Set<String> familyNameSet = new Set<String>();
        Set<String> driverNameSet = new Set<String>();
        String driverdetails = '';
        String driverinfostr;
        for(Wish_Child_Form__c dbWishChildList : disPlayWishChildList){
            Wish_Child_Form__c wishChildRec = new Wish_Child_Form__c();
            if(dbWishChildList.RecordTypeId == wichChildRecordTypeId && dbWishChildList.Migrated__c == false){
                if(dbWishChildList.Id != Null){
                    wishChildRec.Id = dbWishChildList.Id;
                }
                wishChildRec.FirstName__c = dbWishChildList.FirstName__c;
                wishChildRec.Middle_Name__c = dbWishChildList.Middle_Name__c;
                wishChildRec.LastName__c = dbWishChildList.LastName__c;
                wishChildRec.Preferred_Name__c = dbWishChildList.Preferred_Name__c;
                wishChildRec.BirthDate__c = dbWishChildList.BirthDate__c;
                wishChildRec.Gender__c = dbWishChildList.Gender__c;
                wishChildRec.Self_describe_comment_box__c = dbWishChildList.Self_describe_comment_box__c;
                wishChildRec.Diagnosis__c = dbWishChildList.Diagnosis__c;
                wishChildRec.T_Shirt_Size__c = dbWishChildList.T_Shirt_Size__c;
                wishChildRec.Street__c = dbWishChildList.Street__c;
                wishChildRec.City__c = dbWishChildList.City__c;
                wishChildRec.Zip_Code__c = dbWishChildList.Zip_Code__c;
                wishChildRec.mobilePhone__c = dbWishChildList.mobilePhone__c;
                wishChildRec.Email__c = dbWishChildList.Email__c;
                wishChildRec.Color__c = dbWishChildList.Color__c;
                wishChildRec.Music_Singer__c = dbWishChildList.Music_Singer__c; 
                wishChildRec.Book_Story__c = dbWishChildList.Book_Story__c;
                wishChildRec.Hobby__c = dbWishChildList.Hobby__c;
                wishChildRec.Game__c = dbWishChildList.Game__c;
                wishChildRec.Movie__c = dbWishChildList.Movie__c;
                wishChildRec.Food__c = dbWishChildList.Food__c;
                wishChildRec.TVShow__c = dbWishChildList.TVShow__c;
                wishChildRec.Restaurant__c = dbWishChildList.Restaurant__c;
                wishChildRec.Actor_Actress__c = dbWishChildList.Actor_Actress__c;
                wishChildRec.Cake_Candy__c = dbWishChildList.Cake_Candy__c;
                wishChildRec.Sport_Athlete__c =  dbWishChildList.Sport_Athlete__c;
                wishChildRec.Snack_Food__c = dbWishChildList.Snack_Food__c;
                wishChildRec.Pet_Animal__c = dbWishChildList.Pet_Animal__c;
                wishChildRec.ClassinSchool__c = dbWishChildList.ClassinSchool__c;
                wishChildRec.Other__c = dbWishChildList.Other__c;
                wishChildRec.When_I_m_outside_I_like_to__c = dbWishChildList.When_I_m_outside_I_like_to__c;
                wishChildRec.When_I_m_inside_I_like_to__c = dbWishChildList.When_I_m_inside_I_like_to__c;
                wishChildRec.Electronics_Games_that_I_like_to_play__c = dbWishChildList.Electronics_Games_that_I_like_to_play__c;
                wishChildRec.When_I_m_with_my_family_I_like_to__c = dbWishChildList.When_I_m_with_my_family_I_like_to__c;
                wishChildRec.When_thinking_some_of_my_wish_ideas_were__c = dbWishChildList.When_thinking_some_of_my_wish_ideas_were__c;
                wishChildRec.MY_WISH_IS_TO__c = dbWishChildList.MY_WISH_IS_TO__c;
                wishChildRec.This_is_my_wish_because__c = dbWishChildList.This_is_my_wish_because__c;
                wishChildRec.When_I_m_with_my_friends_I_like_to__c = dbWishChildList.When_I_m_with_my_friends_I_like_to__c;
                wishChildRec.To_me_the_most_important_part_of_my_wish__c = dbWishChildList.To_me_the_most_important_part_of_my_wish__c;
                wishChildRec.When_I_think_about_my_wish_I_imagine__c = dbWishChildList.When_I_think_about_my_wish_I_imagine__c;
                wishChildRec.Wish_Notes__c = dbWishChildList.Wish_Notes__c;
                wishChildRec.Wish_Determination_Case_Id__c = dbWishChildList.Wish_Determination_Case_Id__c;
                wishChildRec.RecordTypeId = wichChildRecordTypeId;
                wishChildRec.Case__c = currCase.Id;
                wishChildRec.Contact__c  = dbWishChildList.Contact__c;
                wishChildRec.Already_wish_granted_by_MAW_Other_Org__c = dbWishChildList.Already_wish_granted_by_MAW_Other_Org__c; 
                wishChildRec.If_yes_Enter_Org_Name_Wish_Date_it_wa__c = dbWishChildList.If_yes_Enter_Org_Name_Wish_Date_it_wa__c; 
                wishChildRec.Social_Media_Link__c = dbWishChildList.Social_Media_Link__c;
                wishChildRec.Preferred_Name__c = dbWishChildList.Preferred_Name__c;
                wishChildRec.Hidden_Same_as_Family__c = dbWishChildList.Hidden_Same_as_Family__c;
                if(ethnicityList.size() > 0)
                {
                    String ect = '';
                    for(String str : ethnicityList){
                        if(str != null){
                            ect+=str+';';
                        }
                    }
                    ect = ect.removeEnd(';');                
                    wishChildRec.Race_Ethnicity__c = ect;
                }
                if(wishChildRec.Race_Ethnicity__c != Null){
                    wishChildRec.Race_Ethnicity_Details__c = dbWishChildList.Race_Ethnicity_Details__c;
                }
                saveWishFormList.add(wishChildRec);
            }
        }
        
        for(Wish_Child_Form__c dbWishFamilyParentGurdian : displayWishFamilyList){
            Wish_Child_Form__c wishFamilyRec = new Wish_Child_Form__c();
            if(dbWishFamilyParentGurdian.Migrated__c == false){
            if(dbWishFamilyParentGurdian.Id != Null){
                wishFamilyRec.Id = dbWishFamilyParentGurdian.Id;
            }
            if(!familyNameSet.contains(wishFamilyRec.FirstName__c+wishFamilyRec.Middle_Name__c+wishFamilyRec.LastName__c)){
                wishFamilyRec.FirstName__c = dbWishFamilyParentGurdian.FirstName__c ;
                wishFamilyRec.Middle_Name__c = dbWishFamilyParentGurdian.Middle_Name__c;
                wishFamilyRec.LastName__c  = dbWishFamilyParentGurdian.LastName__c;
                wishFamilyRec.mobilePhone__c = dbWishFamilyParentGurdian.mobilePhone__c ;
                wishFamilyRec.BirthDate__c = dbWishFamilyParentGurdian.BirthDate__c;
                wishFamilyRec.Email__c =  dbWishFamilyParentGurdian.Email__c ;
                wishFamilyRec.city__c  = dbWishFamilyParentGurdian.city__c; 
                wishFamilyRec.Street__c = dbWishFamilyParentGurdian.Street__c ;
                wishFamilyRec.State__c = dbWishFamilyParentGurdian.State__c ;
                wishFamilyRec.Zip_code__c = dbWishFamilyParentGurdian.Zip_code__c;
                wishFamilyRec.Emergency_Relationship__c = dbWishFamilyParentGurdian.Emergency_Relationship__c;
                wishFamilyRec.Home_Phone__c =  dbWishFamilyParentGurdian.Home_Phone__c ;
                wishFamilyRec.TelePhone__c =  dbWishFamilyParentGurdian.TelePhone__c;
                wishFamilyRec.T_Shirt_Size__c = dbWishFamilyParentGurdian.T_Shirt_Size__c ;
                wishFamilyRec.Residing_With_Wish_Child__c= dbWishFamilyParentGurdian.Residing_With_Wish_Child__c;
                wishFamilyRec.Hidden_Same_as_Family__c = dbWishFamilyParentGurdian.Hidden_Same_as_Family__c;
                wishFamilyRec.Case__c = currCase.Id;
                wishFamilyRec.Wish_Determination_Case_Id__c  = dbWishFamilyParentGurdian.Wish_Determination_Case_Id__c;
                wishFamilyRec.RecordTypeId = familyContactRecordTypeId;
                wishFamilyRec.Contact__c  = dbWishFamilyParentGurdian.Contact__c;
                if(wishFamilyRec.Hidden_Same_as_Family__c == true){
                    wishFamilyRec.IsParticipant__c = false;
                }
                else{
                    wishFamilyRec.IsParticipant__c = false;
                }
                familyNameSet.add(wishFamilyRec.FirstName__c+wishFamilyRec.Middle_Name__c+wishFamilyRec.LastName__c);
                processedNameMap.put(wishFamilyRec.FirstName__c+' '+wishFamilyRec.LastName__c,wishFamilyRec.Email__c);
                saveWishFormList.add(wishFamilyRec);
            }
           }
        }
        
        for(Wish_Child_Form__c dbWishFamilyParticipant : displayWishFamilyParticipantList){
            Wish_Child_Form__c wishFamilyParticipantRec = new Wish_Child_Form__c();
            if(dbWishFamilyParticipant.Migrated__c == false){
            if(dbWishFamilyParticipant.Id != Null){
                wishFamilyParticipantRec.Id = dbWishFamilyParticipant.Id;
            }
            if(!familyNameSet.contains(dbWishFamilyParticipant.FirstName__c+dbWishFamilyParticipant.Middle_Name__c+dbWishFamilyParticipant.LastName__c)){
                wishFamilyParticipantRec.FirstName__c = dbWishFamilyParticipant.FirstName__c ;
                wishFamilyParticipantRec.Middle_Name__c = dbWishFamilyParticipant .Middle_Name__c;
                wishFamilyParticipantRec.LastName__c  = dbWishFamilyParticipant .LastName__c;
                wishFamilyParticipantRec.BirthDate__c = dbWishFamilyParticipant .BirthDate__c;
                wishFamilyParticipantRec.Email__c =  dbWishFamilyParticipant .Email__c ;
                wishFamilyParticipantRec.T_Shirt_Size__c = dbWishFamilyParticipant .T_Shirt_Size__c ;
                wishFamilyParticipantRec.Residing_With_Wish_Child__c= dbWishFamilyParticipant .Residing_With_Wish_Child__c;
                wishFamilyParticipantRec.Case__c = currCase.Id;
                wishFamilyParticipantRec.Wish_Determination_Case_Id__c  = dbWishFamilyParticipant .Wish_Determination_Case_Id__c;
                wishFamilyParticipantRec.RecordTypeId = familyContactRecordTypeId;
                wishFamilyParticipantRec.IsParticipant__c = true;
                wishFamilyParticipantRec.Hidden_Same_as_Family__c = false;
                wishFamilyParticipantRec.Contact__c  = dbWishFamilyParticipant.Contact__c;
                wishFamilyParticipantRec.Emergency_Relationship__c = dbWishFamilyParticipant.Emergency_Relationship__c;
                saveWishFormList.add(wishFamilyParticipantRec);
                familyNameSet.add(dbWishFamilyParticipant.FirstName__c+dbWishFamilyParticipant.Middle_Name__c+dbWishFamilyParticipant.LastName__c);
            }
         }
        }
        List<Wish_Child_Form__c> emergencyList = [SELECT Id,FirstName__c,LastName__c,Migrated__c,RecordTypeId FROM Wish_Child_Form__c WHERE RecordTypeId =: emergencyContactRecordTypeId AND  Case__c =: currCase.Id];
        if(emergencyChild.Emergency_Relationship__c != Null && emergencyChild.Migrated__c == false){
            Wish_Child_Form__c wishFamilyEmergencyContact = new Wish_Child_Form__c();
            if(emergencyChild.id != Null){
                wishFamilyEmergencyContact.Id = emergencyChild.Id;
            }
            if(emergencyList.size() > 0){
                wishFamilyEmergencyContact.Id = emergencyList[0].Id;
            }
            if(!nameset.contains(emergencyChild.FirstName__c+ ' '+emergencyChild.LastName__c)){
                wishFamilyEmergencyContact.FirstName__c = emergencyChild.FirstName__c ;
                wishFamilyEmergencyContact.Middle_Name__c = emergencyChild.Middle_Name__c;
                wishFamilyEmergencyContact.LastName__c  = emergencyChild.LastName__c;
                wishFamilyEmergencyContact.Email__c = emergencyChild.Email__c;
                wishFamilyEmergencyContact.mobilePhone__c = emergencyChild.mobilePhone__c;
                wishFamilyEmergencyContact.Emergency_Relationship__c = emergencyChild.Emergency_Relationship__c;
                wishFamilyEmergencyContact.Case_Team_Member1__c = emergencyChild.Case_Team_Member1__c; 
                wishFamilyEmergencyContact.Case_Team_Member2__c = emergencyChild.Case_Team_Member2__c;
                wishFamilyEmergencyContact.RecordTypeId = emergencyContactRecordTypeId;
                wishFamilyEmergencyContact.Case__c = currCase.Id;
                wishFamilyEmergencyContact.Contact__c  = emergencyChild.Contact__c;
                wishFamilyEmergencyContact.House_Hold_Account_Id__c = currCase.contact.AccountId;
                nameset.add(emergencyChild.FirstName__c+ ' '+emergencyChild.LastName__c);
                saveWishFormList.add(wishFamilyEmergencyContact);
            }
        }
        
        for(Wish_Child_Form__c dbDriverInfo: driverInformationList){
            Wish_Child_Form__c driverInfo  = new Wish_Child_Form__c();
            if(dbDriverInfo.Migrated__c == false){
            if(dbDriverInfo.id != Null){
                driverInfo.Id = dbDriverInfo.Id;
            }
            driverInfo.Driver_Name__c = dbDriverInfo.Driver_Name__c;
            driverInfo.State__c = dbDriverInfo.State__c;
            driverInfo.Expiration_Date__c = dbDriverInfo.Expiration_Date__c;
            driverInfo.Driver_License_Number__c  = dbDriverInfo.Driver_License_Number__c;
            driverInfo.RecordTypeId = driverContactRecordType;
            driverInfo.Case__c = currCase.Id;
            driverInfo.Contact__c  = dbDriverInfo.Contact__c;
            system.debug('@@@ Before DriverInfo @@@'+driverdetails );
            
            if(driverdetails == ''){
                if(string.valueof(dbDriverInfo.Expiration_Date__c) != null ){
                    String S = String.valueof(dbDriverInfo.Expiration_Date__c);
                    String s1 = S.remove(' 00:00:00');
                    driverdetails   = dbDriverInfo.Driver_Name__c+' '+'|'+' '+dbDriverInfo.Driver_License_Number__c+' '+'|'+' '+dbDriverInfo.State__c +' '+'|'+' '+ s1;      
                    system.debug('@@@ Before DriverInfo 11 @@@'+driverdetails );
                }
            } 
            
            else{
                if(string.valueof(dbDriverInfo.Expiration_Date__c) != null){
                    String S = String.valueof(dbDriverInfo.Expiration_Date__c);
                    String s1 = S.remove(' 00:00:00');
                    driverdetails= driverdetails+'<br/>'+dbDriverInfo.Driver_Name__c+' '+'|'+' '+dbDriverInfo.Driver_License_Number__c+' '+'|'+' '+dbDriverInfo.State__c +' '+'|'+' '+ s1;      
                    system.debug('@@@ After DriverInfo 22@@@'+driverdetails );
                }
            }
            saveWishFormList.add(driverInfo);
            driverNameSet.add(driverdetails);
        }
        }
        List<Wish_Child_Form__c> determinationList = [SELECT Id,FirstName__c,LastName__c,Migrated__c,RecordTypeId FROM Wish_Child_Form__c WHERE RecordTypeId =: wishDterminationCaseRecordTypeId AND  Case__c =: currCase.Id AND Migrated__c =: false];
        
        Wish_Child_Form__c determinationcase = new Wish_Child_Form__c();
        
        if(determinationcaseInfo .id != null){
            determinationcase.id = determinationcaseInfo.Id;
        }
        if(determinationList.size() > 0){
            determinationcase.id = determinationList[0].Id;
        }
        determinationcase.Wish_Determination_Case_Id__c = determinationcaseId; 
        if(wcfUtil.isInformation == True){
            determinationcase.Availability_Time_Period_1__c = wcfUtil.availableMonth1+'/'+wcfUtil.availableYear1;
            determinationcase.Availability_Time_Period_2__c = wcfUtil.availableMonth2+'/'+wcfUtil.availableYear2;
            determinationcase.Availability_Time_Period_3__c = wcfUtil.availableMonth3+'/'+wcfUtil.availableYear3;
            determinationcase.Requested_Participant_Name_forWheelchair__c = selectedNamesss(tempName);
            determinationcase.Participant_Name_for_Dietary_Restriction__c = selectedNamesss(currrentDietaryNameList);
            determinationcase.Requested_Participant_Name_for_OtherNeed__c = selectedNamesss(currentOtherNeedsList);
            determinationcase.Requested_Participant_Name_for_Oxygen__c = selectedNamesss(currentOxygenNamesList);
            determinationcase.Requested_Participant_Name_for_Allergies__c = selectedNamesss(currentAllergyNamesList);
            determinationcase.Bringing_Own_Wheel_Chair__c = selectedNamesss(currentOwnWheelChairList);
            determinationcase.Name_of_wheelchair_collapsible__c= selectedNamesss(currentWCCollapsibleList);
            determinationcase.Pariticipant_name_havingWheelchair_Power__c= selectedNamesss(currentWCPowerList);
            determinationcase.Medication_require_refrigeration_name__c= selectedNamesss(currentMedicationList);
            determinationcase.Names_for_receiving_nursing_care__c= selectedNamesss(currentNursingCareList);
            determinationcase.Race_Ethnicity__c = selectedNamesss(ethnicityList);
        }
        determinationcase.Details_about_Impact__c = determinationcaseInfo .Details_about_Impact__c;
        determinationcase.Participant_require_oxygen_how_often__c = determinationcaseInfo .Participant_require_oxygen_how_often__c;
        determinationcase.Participant_require_oxygen_Note__c = determinationcaseInfo .Participant_require_oxygen_Note__c;
        determinationcase.Participant_dietary_restrictions__c = determinationcaseInfo .Participant_dietary_restrictions__c;
        determinationcase.Participant_dietary_restrictions_Note__c = determinationcaseInfo .Participant_dietary_restrictions_Note__c;
        determinationcase.Participant_have_allergies_to_food__c = determinationcaseInfo .Participant_have_allergies_to_food__c; 
        determinationcase.Participant_have_allergies_to_food_Note__c = determinationcaseInfo .Participant_have_allergies_to_food_Note__c;
        determinationcase.Medication_require_refrigeration__c = determinationcaseInfo .Medication_require_refrigeration__c; 
        determinationcase.Medication_require_refrigeration_Note__c = determinationcaseInfo .Medication_require_refrigeration_Note__c;
        determinationcase.Wish_child_receive_nursing_care__c = determinationcaseInfo .Wish_child_receive_nursing_care__c;
        determinationcase.Participant_require_medical_supplies__c = determinationcaseInfo .Participant_require_medical_supplies__c; 
        determinationcase.Participant_require_medical_suppliesNote__c = determinationcaseInfo .Participant_require_medical_suppliesNote__c;
        determinationcase.Participant_require_a_wheelchair__c = determinationcaseInfo .Participant_require_a_wheelchair__c; 
        determinationcase.Participant_require_a_wheelchair_Note__c = determinationcaseInfo .Participant_require_a_wheelchair_Note__c;
        determinationcase.Will_your_family_bring_wheelchair__c = determinationcaseInfo .Will_your_family_bring_wheelchair__c; 
        determinationcase.Will_your_family_bring_wheelchair_Note__c = determinationcaseInfo .Will_your_family_bring_wheelchair_Note__c;
        determinationcase.Is_the_wheelchair_collapsible__c = determinationcaseInfo .Is_the_wheelchair_collapsible__c; 
        determinationcase.Is_the_wheelchair_collapsible_Note__c = determinationcaseInfo .Is_the_wheelchair_collapsible_Note__c; 
        determinationcase.Is_the_wheelchair_power__c = determinationcaseInfo .Is_the_wheelchair_power__c;
        determinationcase.Is_the_wheelchair_power_Note__c = determinationcaseInfo .Is_the_wheelchair_power_Note__c;
        determinationcase.Has_your_family_flown_before__c = determinationcaseInfo .Has_your_family_flown_before__c;
        determinationcase.Has_your_family_flown__c = determinationcaseInfo .Has_your_family_flown__c;
        determinationcase.Will_an_interpreter_be_needed__c = determinationcaseInfo .Will_an_interpreter_be_needed__c;
        determinationcase.Will_an_interpreter_be_needed_Details__c = determinationcaseInfo .Will_an_interpreter_be_needed_Details__c;
        determinationcase.Will_a_rental_car_seat_s_be_needed__c = determinationcaseInfo .Will_a_rental_car_seat_s_be_needed__c;
        determinationcase.Will_a_rental_car_seat_s_Details__c = determinationcaseInfo .Will_a_rental_car_seat_s_Details__c;
        determinationcase.Sit_up_takeoff_landing_on_airplane__c = determinationcaseInfo .Sit_up_takeoff_landing_on_airplane__c;
        determinationcase.Are_all_requested_participants_Details__c = determinationcaseInfo .Are_all_requested_participants_Details__c; 
        determinationcase.Will_a_rental_stroller_be_needed__c = determinationcaseInfo .Will_a_rental_stroller_be_needed__c; 
        determinationcase.Will_a_rental_stroller_Details__c = determinationcaseInfo .Will_a_rental_stroller_Details__c;
        determinationcase.Handicap_accommodations_be_required__c = determinationcaseInfo .Handicap_accommodations_be_required__c;
        determinationcase.Will_handicap_accessible_Details__c = determinationcaseInfo .Will_handicap_accessible_Details__c;
        determinationcase.Participant_have_valid_passports__c = determinationcaseInfo .Participant_have_valid_passports__c; 
        determinationcase.Does_each_requested_participant_Details__c = determinationcaseInfo .Does_each_requested_participant_Details__c; 
        determinationcase.Does_participant_have_valid_photo_ID__c = determinationcaseInfo .Does_participant_have_valid_photo_ID__c; 
        determinationcase.Does_each_requested_participan__c = determinationcaseInfo .Does_each_requested_participan__c;
        determinationcase.Does_Your_Medical_Insurance_Include__c = determinationcaseInfo .Does_Your_Medical_Insurance_Include__c; 
        determinationcase.Does_Your_Medical_Insurance_Details__c = determinationcaseInfo .Does_Your_Medical_Insurance_Details__c;
        determinationcase.Does_your_family_have_a_credit_card__c = determinationcaseInfo .Does_your_family_have_a_credit_card__c; 
        determinationcase.Does_your_family_Details__c = determinationcaseInfo .Does_your_family_Details__c;
        determinationcase.Driver_Information__c = driverdetails; 
        determinationcase.Information_Provided__c = determinationcaseInfo .Information_Provided__c;
        determinationcase.RecordTypeId = wishDterminationCaseRecordTypeId;
        determinationcase.Case__c = currCase.Id;
        determinationcase.Contact__c  = determinationcaseInfo.Contact__c;
        determinationcase.Have_current_automobile_insurance__c = determinationcaseInfo.Have_current_automobile_insurance__c;
        determinationcase.Automobile_insurance_provide_coverage__c = determinationcaseInfo.Automobile_insurance_provide_coverage__c; 
        determinationcase.Is_your_family_comfortable_in_rendal_car__c = determinationcaseInfo.Is_your_family_comfortable_in_rendal_car__c; 
        determinationcase.Is_a_wheelchair_accessible_vehicle_neede__c = determinationcaseInfo .Is_a_wheelchair_accessible_vehicle_neede__c;
        determinationcase.Wish_child_receive_nursing_care_Note__c= determinationcaseInfo.Wish_child_receive_nursing_care_Note__c;
        saveWishFormList.add(determinationcase);
        
        if(saveWishFormList.size() > 0)
            upsert saveWishFormList;
        displayWishFamilyList.clear();
        displayWishFamilyParticipantList.clear();
        driverInformationList.clear();
        if(saveWishFormList.size() > 0){
            for(Wish_Child_Form__c processdbWishForm: saveWishFormList){
                
                if(processdbWishForm.RecordTypeId == familyContactRecordTypeId && processdbWishForm.Id != Null && processdbWishForm.IsParticipant__c == true && processdbWishForm.Migrated__c == false){
                    displayWishFamilyParticipantList.add(processdbWishForm);
                }
                else if(processdbWishForm.RecordTypeId == familyContactRecordTypeId && processdbWishForm.Id != Null && processdbWishForm.IsParticipant__c != true && processdbWishForm.Migrated__c == false){
                    displayWishFamilyList.add(processdbWishForm);
                }
                
                else if(processdbWishForm.RecordTypeId == driverContactRecordType  && processdbWishForm.Id != Null && processdbWishForm.Migrated__c == false){
                    driverInformationList.add(processdbWishForm);
                }
                
            }
        }
    }
    
    
    /******************************************************************************************************
This is the SaveandWishChildExit() method is used nevigate the user to corresponding form like 
if the user in wish child form and if the user wants to go wishinformation form they can click 
the corresponding link then the user redirect to that form and information are saved in backend 
object.
*******************************************************************************************************/
    public void SaveandWishChildExit(){
        String Logvalue;
        
        String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        if(pageName == 'WishChildForm_VF'){
            saveContact();
        }
        if(pageName == 'WishFamilyForm_VF'){
            saveContact();
        }
        if(pageName == 'WishInformationForm_VF'){
            WishInfoSave();
        }
    }
    
    
    /******************************************************************************************************
This WCFNext() method is used to redirect the user from wish child form to wish family form.
*******************************************************************************************************/
    public PageReference WCFNext(){ 
        String Logvalue;
        saveContact();
        Logvalue = String.valueOf(this.currCase);
        PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    
    /******************************************************************************************************
This WCFtoWIF() method is used to redirect the user from wish family form to wish information form 
*******************************************************************************************************/    
    public PageReference WCFtoWIF(){
        String Logvalue;
        
        saveContact();
        Logvalue = String.valueOf(this.currCase);
        PageReference reference=new PageReference('/apex/WishInformationForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);     
        return reference;
        
    }
    
    /******************************************************************************************************
This WCFtoWFF() method is used to redirect the user from wish child form to wish information form 
*******************************************************************************************************/ 
    public PageReference WCFtoWFF(){
        PageReference reference;
        String Logvalue;
        
        saveContact();
        Logvalue = String.valueOf(this.currCase);
        reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
        reference.setRedirect(true);                 
        return reference;
    }
    
    /******************************************************************************************************
This WCFtoWFF() method is used to redirect to wish information form 
*******************************************************************************************************/ 
    public PageReference WishFamilytoWishInfo(){
        PageReference reference;
        String Logvalue;
        try
        {  
            
            saveContact();
            Logvalue = String.valueOf(this.currCase);
            reference=new PageReference('/apex/WishInformationForm_VF?id='+this.currCase.id);            
            reference.setRedirect(true);
            
        }
        Catch(DMLException e)
        {   
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','WishFamilytoWishInfo',currCase.id,e,Logvalue));
            displayErrorMessage(e);           
        }
        return reference;
    }
    
    /******************************************************************************************************
This WCFtoWFF() method is used to redirect the user to wish child form
*******************************************************************************************************/ 
    public PageReference WishInfotoWishChild(){
        PageReference reference;
        String Logvalue;
        try
        {    
            
            wcfUtil.isInformation = True;
            saveContact();
            Logvalue = String.valueOf(this.currCase);            
            reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);
            
        }
        Catch(DMLException e)
        {  
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','WishInfotoWishChild',currCase.id,e,Logvalue));
            displayErrorMessage(e);           
        }
        return reference;
    }
    
    /******************************************************************************************************
This WCFtoWFF() method is used to redirect the user to wish family form
*******************************************************************************************************/ 
    public PageReference WishInfotoWishFamily(){
        PageReference reference;
        String Logvalue;
        try
        {    
            
            wcfUtil.isInformation = True;
            saveContact();
            Logvalue = String.valueOf(this.currCase);
            reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);
            
        }
        Catch(DMLException e)
        {    
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','WishInfotoWishFamily',currCase.id,e,Logvalue));
            displayErrorMessage(e);          
        }
        return reference;
    }
    
    /******************************************************************************************************
This WCFtoWFF() method is used to redirect the user to wish child form
*******************************************************************************************************/ 
    public PageReference NavigatetoWishChildForm(){
        PageReference reference;
        String Logvalue;
        try
        {   
            
            wcfUtil.isInformation = True;
            saveContact();
            Logvalue = String.valueOf(this.currCase);
            reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id + '&required=true');
            reference.setRedirect(true);
            
        }
        Catch(DMLException e)
        {   
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','NavigatetoWishChildForm',currCase.id,e,Logvalue));
            displayErrorMessage(e);            
        }
        return reference;
    }
    
    /******************************************************************************************************
This WCFtoWFF() method is used to redirect the user to wish family form
*******************************************************************************************************/ 
    public PageReference NavigatetoWishFamily(){
        PageReference reference;
        String Logvalue;
        try
        {   
            
            wcfUtil.isInformation = True;
            SaveContact();  
            Logvalue = String.valueOf(this.currCase);
            reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id + '&required=true');
            reference.setRedirect(true);
            
        }
        Catch(DMLException e)
        {
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','NavigatetoWishFamily',currCase.id,e,Logvalue));
            displayErrorMessage(e);           
        }
        return reference;
    }
    
    /******************************************************************************************************
This cancelfunction() method is used to redirect the user case details page
*******************************************************************************************************/ 
    public PageReference cancelfunction(){
        PageReference reference=new PageReference('/'+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    /******************************************************************************************************
This WCFtoWFF() method is used to redirect the user to wish information form.
*******************************************************************************************************/ 
    public pageReference cancel(){
        PageReference reference=new PageReference('/apex/WishInformationForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    /******************************************************************************************************
This SavewithExit() method is used save the current page details and redirect the user to case detail page.
*******************************************************************************************************/ 
    public PageReference SavewithExit(){
        String Logvalue;
        try{
            
            saveContact();
            Logvalue = String.valueOf(currCase);
            PageReference reference=new PageReference('/'+currCase.id);
            reference.setRedirect(true);     
            return reference;
            
        }      
        catch(DMLException e)
        {   
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SavewithExit',currCase.id,e,Logvalue));
            displayErrorMessage(e);
        }  
        return null; 
    }
    
    /******************************************************************************************************
This removeFamily() method is used remove the parent legual guardian details from paren guardian sections..
*******************************************************************************************************/ 
    public void removeFamily(){
        
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        Id recId = displayWishFamilyList.get(indexVal).Id;
        Set<Id> ContactIdSet = new Set<Id>();
        List<npe4__Relationship__c> dbRelationShipList = new List<npe4__Relationship__c>();
        List<Contact> contactList = new List<Contact>();
        displayWishFamilyList.remove(indexVal);   
        if(recId != Null){
            for(Wish_Child_Form__c removeFamily : [SELECT Id,Contact__c,Migrated__c From Wish_Child_Form__c WHERE Id =:recId AND Contact__c != Null AND Migrated__c = False]){
                ContactIdSet.add(removeFamily.Contact__c);
            }
            if(ContactIdSet.size() > 0){
                for(npe4__Relationship__c dbRelationShip : [SELECT Id,npe4__RelatedContact__c,Parent_Legal_Guardian__c,Wish_Participant__c FROM npe4__Relationship__c WHERE npe4__RelatedContact__c IN: ContactIdSet]){
                    if(ContactIdSet.contains(dbRelationShip.npe4__RelatedContact__c)){
                        dbRelationShip.Parent_Legal_Guardian__c = false;
                        dbRelationShip.Wish_Participant__c  = false;
                        dbRelationShipList.add(dbRelationShip);
                    }
                }
                
                for(Contact dbContact : [SELECT Id,Hidden_Wish_Form_Id__c FROM Contact WHERE Id IN: ContactIdSet]){
                    If(ContactIdSet.contains(dbContact.Id)){
                        dbContact.Hidden_Wish_Form_Id__c = Null;
                        contactList.add(dbContact);
                    }
                }
                
                if(dbRelationShipList.size() > 0)
                    update dbRelationShipList;
                
                if(contactList.size() > 0)
                    update contactList;
            }
            
            else{
                List<Wish_Child_Form__c> removeFamilyList = [SELECT Id From Wish_Child_Form__c WHERE Id =:recId ];
                delete removeFamilyList;
            }
            
        }   
    }
    /******************************************************************************************************
This removeParticipants() method is used remove the participant details from participant sections..
*******************************************************************************************************/ 
    public void removeParticipants(){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('Participant'));
        Id recId = displayWishFamilyParticipantList.get(indexVal).Id;
        displayWishFamilyParticipantList.remove(indexVal);
        Set<Id> ContactIdSet = new Set<Id>();
        List<npe4__Relationship__c> dbRelationShipList = new List<npe4__Relationship__c>();
        List<Contact> contactList = new List<Contact>();
        if(recId != Null){
            for(Wish_Child_Form__c removeFamily : [SELECT Id,Contact__c,Migrated__c From Wish_Child_Form__c WHERE Id =:recId AND Contact__c != Null AND Migrated__c = False]){
                ContactIdSet.add(removeFamily.Contact__c);
            }
            if(ContactIdSet.size() > 0){
                for(npe4__Relationship__c dbRelationShip : [SELECT Id,npe4__RelatedContact__c,Parent_Legal_Guardian__c,Wish_Participant__c FROM npe4__Relationship__c WHERE npe4__RelatedContact__c IN: ContactIdSet]){
                    if(ContactIdSet.contains(dbRelationShip.npe4__RelatedContact__c)){
                        dbRelationShip.Parent_Legal_Guardian__c = false;
                        dbRelationShip.Wish_Participant__c  = false;
                        dbRelationShipList.add(dbRelationShip);
                    }
                }
                
                for(Contact dbContact : [SELECT Id,Hidden_Wish_Form_Id__c FROM Contact WHERE Id IN: ContactIdSet]){
                    If(ContactIdSet.contains(dbContact.Id)){
                        dbContact.Hidden_Wish_Form_Id__c = Null;
                        contactList.add(dbContact);
                    }
                }
                
                if(dbRelationShipList.size() > 0)
                    update dbRelationShipList;
                
                if(contactList.size() > 0)
                    update contactList;
            } 
            else{
                List<Wish_Child_Form__c> removeFamilyList = [SELECT Id From Wish_Child_Form__c WHERE Id =:recId ];
                delete removeFamilyList;
            }  
        }          
    } 
    
    /******************************************************************************************************
This removeDriver() method is used remove the driver details from driver information section.
*******************************************************************************************************/
    public void removeDriver(){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('driver'));
        Id recId = driverInformationList.get(indexVal).Id;
        driverInformationList.remove(indexVal); 
        if(recId != Null){
            List<Wish_Child_Form__c> removeFamilyList = [SELECT Id From Wish_Child_Form__c WHERE Id =:recId ];
            delete removeFamilyList;
        }
        
    }    
    
    /********************************************************************
This ExitwithApprovalError() redirect the user to case detail page.
*********************************************************************/
    public PageReference ExitwithApprovalError(){
        PageReference reference=new PageReference('/'+currentPageId);
        reference.setRedirect(true);     
        return reference;
    }
    
    /*************************************************************************************************
This addFamily() is used to initilaze the wishFamilyWrapList when the wish family form is loaded.
**************************************************************************************************/
    public void addFamily(){
        System.debug('Function called+++++++++++');
        displayWishFamilyList.add(new Wish_Child_Form__c());
    }
    
    /*************************************************************************************************
This addDriver() is used to initilaze the driverWrapperCls when the wish information form is loaded.
**************************************************************************************************/
    public void addDriver(){
        // if(wcfUtil.driverWrapperCls.size() < wcfUtil.wishParticipantList.size())
        driverInformationList.add(new Wish_Child_Form__c());
    }
    
    /*************************************************************************************************
This addParticipants() is used to initilaze the wishParticipantList when the wish family form is 
loaded.
**************************************************************************************************/
    public void addParticipants(){ 
        displayWishFamilyParticipantList.add(new Wish_Child_Form__c());
    }
    
    /*************************************************************************************************
This BackToWCF() is used to redrict the user to wish child form and save the current page information.
**************************************************************************************************/
    public pageReference BackToWCF()
    {
        String Logvalue;
        try{
            
            SaveContact();
            System.debug('AFTER SAVE');
            Logvalue = string.valueOf(currCase);
            PageReference reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
            
        }
        catch(Exception e){
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','BackToWCF',currCase.id,e,Logvalue));
            displayErrorMessage(e);
            
        }
        return null;
    }
    
    
    /*************************************************************************************************
This SaveandwishFamilyExit() is used to redrict the user to wish family form and save the current page information.
**************************************************************************************************/
    public PageReference SaveandwishFamilyExit()
    {
        String Logvalue;
        try{
            
            saveContact();
            Logvalue = string.valueOf(currCase);
            PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+currCase.id+'&part='+isParticipants);
            reference.setRedirect(true);  
            return reference;
            
        }      
        catch(DMLException e)
        {   
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SaveandwishFamilyExit',currCase.id,e,Logvalue));
            displayErrorMessage(e);
        }      
        return null;   
    }
    
    
    /*********************************************************************************************************
This WFFNext() is used to redrict the user to wish information form and save the current page information.
**********************************************************************************************************/
    public PageReference WFFNext(){ 
        String Logvalue;
        try
        {
            
            saveContact();
            Logvalue = string.valueOf(currCase);
            PageReference reference=new PageReference('/apex/WishInformationForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
            
        }      
        catch(DMLException e)
        {   
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','WFFNext',currCase.id,e,Logvalue));
            displayErrorMessage(e);
        }
        return null; 
    }
    
    
    /*****************************************************************************************************************
This withOutSavefromWCFtoWIF() is used to redrict the user to wish information form with out save the current page.
*******************************************************************************************************************/
    Public pageReference withOutSavefromWCFtoWIF(){
        
        PageReference reference=new PageReference('/apex/WishInformationForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    /*****************************************************************************************************************
This withOutSavetoChild() is used to redrict the user to wish child form with out save the current page.
*******************************************************************************************************************/
    Public pageReference withOutSavetoChild(){
        PageReference reference=new PageReference('/apex/WishChildForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    /*****************************************************************************************************************
This withOutSaveWCCF() is used to redrict the user to wish information form with out save the current page.
*******************************************************************************************************************/
    Public pageReference withOutSaveWCCF(){
        system.debug('withOutSaveWCCF method');
        PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+currCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    /*************************************************************************************************
This wishChildMap() is used to add the wish child name in medical information section. This method 
is called when wish information page is loded.
**************************************************************************************************/
    Public void wishChildMap(string firstName,String lastName){
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftDietaryNameList.add('Wish Child - '+firstName+' ' +lastName);
        if(firstName != Null && lastName != Null)
            wcfUtil.leftWCNamesList.add('Wish Child - '+firstName+' ' +lastName);
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftOxygenNamesList.add('Wish Child - '+firstName+' ' +lastName);
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftAllergyNamesList.add('Wish Child - '+firstName+' ' +lastName);
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftOtherNeedsList.add('Wish Child - '+firstName+' ' +lastName);
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftOwnWheelChairList.add('Wish Child - '+firstName+' ' +lastName);
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftWCCollapsibleList.add('Wish Child - '+firstName+' ' +lastName);
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftWCPowerList.add('Wish Child - '+firstName+' ' +lastName);
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftMedicationList.add('Wish Child - '+firstName+' ' +lastName);
        
        if(firstName != Null && lastName != Null)
            wcfUtil.leftNursingCareList.add('Wish Child - '+firstName+' ' +lastName);
    }
    
    /*************************************************************************************************
This ParentLegalMapping() is used to add the parent legual guardian name in medical information section 
and drive details. This method is called when wish information page is loded.
**************************************************************************************************/
    public void ParentLegalMapping(List<Wish_Child_Form__c> parentGurdianList){
        
        for(Wish_Child_Form__c processRec : parentGurdianList){
            
            if(processRec.RecordTypeId == familyContactRecordTypeId){
                if(processRec.BirthDate__c != Null && processRec.Emergency_Relationship__c != 'Wish Child (self)') {
                    if(Integer.valueOf(processRec.BirthDate__c.daysBetween(Date.Today())/365) >= 18 && processRec.Hidden_Same_as_Family__c  == true) {
                        String Name = processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c;
                        wcfUtil.driverNameList.add((new SelectOption(Name,Name)));
                    }
                }
            }
            
            if(processRec.Hidden_Same_as_Family__c  == true){
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftDietaryNameList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftWCNamesList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftOxygenNamesList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftAllergyNamesList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftOtherNeedsList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftOwnWheelChairList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftWCCollapsibleList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftWCPowerList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftMedicationList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
                
                if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                    wcfUtil.leftNursingCareList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            }
            
        }
    } 
    
    /*************************************************************************************************
This ParticipantsMapping() is used to add the participant name in medical information section 
and drive details. This method is called when wish information page is loded.
**************************************************************************************************/
    public void ParticipantsMapping(List<Wish_Child_Form__c> parentGurdianList){
        
        for(Wish_Child_Form__c processRec : parentGurdianList){
            if(processRec.Migrated__c == false){
            if(processRec.RecordTypeId == familyContactRecordTypeId ){
                if(processRec.BirthDate__c != Null && processRec.Emergency_Relationship__c != 'Wish Child (self)') {
                    if(Integer.valueOf(processRec.BirthDate__c.daysBetween(Date.Today())/365) >= 18) {
                        String Name = processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c;
                        wcfUtil.driverNameList.add((new SelectOption(Name,Name)));
                    }
                }
            }
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftDietaryNameList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftWCNamesList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftOxygenNamesList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftAllergyNamesList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftOtherNeedsList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftOwnWheelChairList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftWCCollapsibleList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftWCPowerList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftMedicationList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
            
            if(processRec.FirstName__c != Null && processRec.LastName__c != Null)
                wcfUtil.leftNursingCareList.add(processRec.Emergency_Relationship__c +' - '+processRec.FirstName__c+' '+processRec.LastName__c);
        }
    }
   }
    
    /****************************************************************************************************
This SaveandRedirectChildForm() is used to redirect the user to wish child form and save the current.
page information
*****************************************************************************************************/
    public PageReference SaveandRedirectChildForm(){
        String Logvalue;
        try{
            
            saveContact();
            Logvalue = String.valueOf(this.currCase);
            PageReference reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
            
        }
        catch(Exception e){
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SaveandRedirectChildForm',currCase.id,e,Logvalue));
            displayErrorMessage(e);
        }
        return null;
    }
    
    /****************************************************************************************************
This SaveAndRedirectFamilyForm() is used to redirect the user to wish family form and save the current.
page information
*****************************************************************************************************/
    public PageReference SaveAndRedirectFamilyForm(){
        
        String Logvalue;
        try{
            
            saveContact();
            PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
            
        }
        catch(Exception e){
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SaveAndRedirectFamilyForm',currCase.id,e,Logvalue));
            displayErrorMessage(e);
        }
        return null;
    }
    
    /****************************************************************************************************
This SaveAndRedirectInformationForm() is used to redirect the user to wish family form and save the current.
page information
*****************************************************************************************************/
    public PageReference SaveAndRedirectInformationForm(){
        String Logvalue;
        try{
            
            WishInfoSave();
            PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
            
        }
        catch(Exception e){
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SaveAndRedirectInformationForm',currCase.id,e,Logvalue));
            displayErrorMessage(e);
        }
        return null;
    }
    
    /****************************************************************************************************
This SaveFromInformationToChildForm() is used to redirect the user to wish child form and save the current.
page information
*****************************************************************************************************/   
    public PageReference SaveFromInformationToChildForm()
    {
        String Logvalue;
        try{
            
            WishInfoSave();
            PageReference reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
            
        }
        catch(Exception e){
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SaveFromInformationToChildForm',currCase.id,e,Logvalue));
            displayErrorMessage(e);
        }
        return null;
    }
    
    /****************************************************************************************************
This confirmSignNow() is used to query the parent legual guardian who are all going to sign the
wish form.
*****************************************************************************************************/  
    public void confirmSignNow()
    {
        wcfUtil.isInformation = True;
        SaveContact();        
    }
    
    /****************************************************************************************************
This SignNowmultiEmail() is used to display the parent legual guardian who are all going to sign the
wish form using the sign now option.
*****************************************************************************************************/  
    public void displaySignNowList(){
        signNowList = new List<SelectOption>();  
        Set<String> completedNameSet = new Set<String>();
        for(dsfs__DocuSign_Recipient_Status__c dbdsfs : [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__r.dsfs__Case__c, 
                                                         dsfs__Parent_Status_Record__r.dsfs__Subject__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Parent_Status_Record__r.dsfs__Case__c =: currentPageId  AND 
                                                         dsfs__Recipient_Status__c =: 'Completed' AND dsfs__Parent_Status_Record__r.dsfs__Subject__c =: 'Signature Required - Wish Form & Liability And Publicity Release Form']){
                                                             completedNameSet.add(dbdsfs.Name);
                                                             
                                                         }
        
        for(Wish_Child_Form__c parentGurdian : [SELECT Id,Case__c,FirstName__c,LastName__c,BirthDate__c ,Email__c,RecordTypeId,IsParticipant__c,Migrated__c   FROM Wish_Child_Form__c WHERE
                                                Case__c =: currentPageId AND (RecordTypeId =: familyContactRecordTypeId OR RecordTypeId =: wichChildRecordTypeId) AND IsParticipant__c = False AND Migrated__c = False]){
                                                    
                                                    String name = parentGurdian.FirstName__c+' '+parentGurdian.LastName__c;
                                                    if(!completedNameSet.contains(name) && parentGurdian.RecordTypeId == wichChildRecordTypeId && parentGurdian.BirthDate__c != Null){
                                                        if(Integer.valueOf(parentGurdian.BirthDate__c.daysBetween(Date.Today())/365) >= 18 ) {
                                                            signNowList.add(new SelectOption(name,name));
                                                        }
                                                    }
                                                    if(!completedNameSet.contains(name) && parentGurdian.RecordTypeId == familyContactRecordTypeId){
                                                        signNowList.add(new SelectOption(name,name));
                                                    }                                            
                                                }          
        
        if(signNowList.size() == 0){
            wcfUtil.displayError = true;
        }
    }
    
    public Pagereference SubmitAndSign(){
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        String endPointURL;
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        List<string> LstLog = new List<string>();
        String Logvalue;
        String recId;
        String exisitingEnv = '';
        
        try
        {     
            List<dsfs__DocuSign_Recipient_Status__c> dbRecipient = [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__r.dsfs__Case__c, 
                                                                    dsfs__Parent_Status_Record__r.dsfs__Subject__c FROM dsfs__DocuSign_Recipient_Status__c WHERE Name =: signerName AND dsfs__DocuSign_Recipient_Email__c =: 'NotSent@NoEmail.com' 
                                                                    AND dsfs__Parent_Status_Record__r.dsfs__Case__c =: currCase.Id AND dsfs__Recipient_Status__c != 'Completed' AND dsfs__Parent_Status_Record__r.dsfs__Subject__c =: 'Signature Required - Wish Form & Liability And Publicity Release Form' Limit 1];
            if(dbRecipient.size() > 0){
                ResendEnvelopController resendEnv = new ResendEnvelopController();
                return resendEnv.signNowEnvelop(dbRecipient[0].dsfs__Envelope_Id__c,dbRecipient[0].Name,currCase.id,'WishInformationForm_VF');
            }
            else{
                for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
                    account = credentialIns.account__c;
                    IntegratorKey  = credentialIns.IntegratorKey__c;
                    
                }
                String authorizationHeader = '<DocuSignCredentials><Username>{!$Credential.Username}</Username><Password>{!$Credential.Password}</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
                String boundary = 'AAA';
                
                Pagereference PDF = Page.SignNowPDF;
                PDF.getParameters().put('id',currCase.id);
                
                String documentPDF;
                
                documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
                
                   String body =  '{'+
                    '  "status":"sent",'+
                    '  "enableWetSign": "false",'+
                    '  "emailBlurb":"Wish Form & Liability And Publicity Release Form",'+
                    '  "emailSubject": "Signature Required - Wish Form & Liability And Publicity Release Form",'+
                    '  "enforceSignerVisibility":"True",'+
                    '  "documents": [{'+
                    '      "name": "document.pdf",'+
                    '      "documentId":"1",'+
                    '      "order":"1",'+
                    '      "documentBase64":"'+documentPDF+'"'+
                    '  }],'+
                    '"recipients": {'+
                    '    "signers" : [{'+
                    '      "email": "NotSent@NoEmail.com",'+
                    '      "name": "'+signerName+'",'+
                    '      "recipientId":"1",'+
                    '      "clientUserId":"1",'+
                    '      "tabs": {'+
                    '                "signHereTabs": [{'+
                    '                    "anchorString": "~s1",'+
                    '                    "anchorXOffset": "0.1",'+
                    '                    "anchorYOffset": "0.1",'+
                    '                    "anchorIgnoreIfNotPresent": "false",'+
                    '                    "anchorUnits": "inches"'+
                    '                }],'+
                    '                 "radioGroupTabs": [{'+
                    '                    "groupName": "Radio Group 1",'+
                    '                    "required": "true",'+
                    '                    "radios": [{'+
                    '                    "anchorString": "~FirstRadio",'+
                    '                    "anchorXOffset": "0",'+
                    '                    "anchorYOffset": "0",'+
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches",'+
                    '                    "optional"   :"false",'+
                    '                    "selected": "false",'+
                    '                    "value": "one1Radio",'+
                    '                    "xPosition": "7200",'+
                    '                    "yPosition": "19020"},{'+
                    '                    "anchorString": "~secondRadio",'+
                    '                    "anchorXOffset": "0",'+
                    '                    "anchorYOffset": "0",'+
                    '                    "optional"   :"false",'+
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches",'+
                    '                    "selected": "false",'+
                    '                     "value": "twoRadio",'+
                    '                    "xPosition": "7200",'+
                    '                    "yPosition": "19020"'+
                    '                    }]'+
                    '                   }],'+
                    '                 "checkboxTabs": [{'+
                    '                    "tabLabel": "pubOk",'+
                    '                    "anchorString": "~FirstcheckBox",'+
                    '                    "conditionalParentLabel":"Radio Group 1",'+
                    '                    "conditionalParentValue" :"one1Radio",'+
                    '                    "anchorXOffset": "0",'+                
                    '                    "anchorYOffset": "0",'+
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches",'+
                    '                    "optional"   :"false",'+
                    '                    "selected": "true",'+
                    '                    "value": "one1Radio",'+
                    '                    "mergeField" : {"configurationType":"salesforce","path":"Case.Option1__c","writeBack":"true","allowSenderToEdit":"true","value":"true"},'+
                    '                    "xPosition": "7200",'+
                    '                    "yPosition": "19020"},{'+
                    '                   "tabLabel": "pubNotOk",'+
                    '                    "anchorString": "~secondcheckBox",'+ 
                    '                    "conditionalParentLabel":"Radio Group 1",'+
                    '                    "conditionalParentValue" :"twoRadio",'+               
                    '                    "anchorXOffset": "0",'+
                    '                    "anchorYOffset": "0",'+
                    '                    "optional"   :"false",'+
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches",'+
                    '                    "selected": "true",'+
                    '                     "value": "twoRadio",'+
                    '                    "mergeField" : {"configurationType":"salesforce","path":"Case.Option2__c","writeBack":"true","allowSenderToEdit":"true","value":"true"},'+
                    '                    "xPosition": "7200",'+
                    '                    "yPosition": "19020"'+
                    '                   }],'+
                    '                "initialHereTabs": [{' +
                    '                    "anchorString": "~123abcinitial",' +
                    '                    "conditionalParentLabel":"Radio Group 1",'+
                    '                    "conditionalParentValue" :"one1Radio",'+
                    '                    "optional"    :  "false",' +
                    '                    "anchorXOffset": "0",' +
                    '                    "anchorYOffset": "0.2",' +
                    '                    "name"       : "FirstInitial",'+                                   
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "value" : "option1",' +
                    '                    "anchorUnits": "inches"},{'+
                    '                    "anchorString": "~initial2",' +
                    '                    "optional"    :  "false",' +
                    '                    "conditionalParentLabel":"Radio Group 1",'+
                    '                    "conditionalParentValue" :"twoRadio",'+
                    '                    "name"       : "SecondInitial",'+
                    '                    "anchorXOffset": "0",' +
                    '                    "anchorYOffset": "0.2",' +
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches"'+
                    '                }],' +
                    '                "dateSignedTabs": [{'+
                    '                      "anchorString": "~date",'+
                    '                       "anchorXOffset": "0",'+
                    '                       "fontSize":      "Size14",'+
                    '                       "fontColor":     "Black",'+
                    '                       "fonttype":     "Helvetica",'+
                    '                        "anchorYOffset": "0",'+
                    '                        "anchorIgnoreIfNotPresent": "false",'+
                    '                        "xPosition": "100",'+
                    '                        "yPosition": "72",'+
                    '                        "anchorUnits": "inches"'+
                    '                    }]'+
                    '            }'+
                    '    }]'+
                    '  }'+
                    '}';
                
                String header = '--'+boundary+'\nContent-Type: application/json\nContent-Disposition: form-data';
                String jsonBody = header +'\n\n'+body+'\n\n--'+boundary+'--';
                system.debug(jsonBody);
                //Callout to Docusign.
                HttpRequest req = new HttpRequest();
                req.setHeader('X-DocuSign-Authentication', authorizationHeader);
                req.setHeader('Accept','application/json');
                req.setHeader('Host','demo.docusign.net');
                req.setHeader('Content-Length','162100');
                req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
                req.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes');
                req.setMethod('POST'); 
                req.setBody(jsonBody);
                Http http = new Http();
                HTTPResponse res;
                
                res = http.send(req);
                if(res.getstatusCode() != 200 && res.getstatusCode() != 201){
                    // displaySignNowPopup = false;
                    new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SubmitAndSign',currCase.Id,null,res.getBody()));
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Debug_log_error_message);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                else{
                    String env;
                    //String authorizationHeader = '<DocuSignCredentials><Username>{!$Credential.Username}</Username><Password>{!$Credential.Password}</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
                    Map<String, Object> envresults = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    env = (String) envresults.get('envelopeId'); 
                    if( env != ''){
                        system.debug('@@@ authorizationHeader @@@'+authorizationHeader);
                        HttpRequest request = new HttpRequest();
                        request.setHeader('X-DocuSign-Authentication', authorizationHeader);
                        request.setHeader('Accept','application/json');
                        request.setHeader('Host','demo.docusign.net');
                        request.setHeader('Content-Length','162100');
                        request.setHeader('Content-Type','application/json');
                        request.setMethod('POST'); 
                        Http httprequest = new Http();
                        HTTPResponse response;
                        request.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes/'+env+'/views/recipient');
                        string jsonPayload;
                        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
                        jsonPayload = '{'+
                            '    "userName": "'+signerName+'",'+
                            '     "email": "NotSent@NoEmail.com",'+
                            '    "recipientId": "1",'+
                            '    "clientUserId": "1",'+
                            '    "authenticationMethod": "None",'+
                            '   "returnUrl": "'+baseUrl +'/apex/WishInformationForm_VF?Id='+currCase.id+'"'+   
                            '}';     
                        request.setBody(jsonPayload);
                        response = httprequest.send(request); 
                        if(res.getstatusCode() != 200 && res.getstatusCode() != 201){
                            //displaySignNowPopup = false;
                            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SubmitAndSign',recId,null,string.valueof(response.getstatusCode())));
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Debug_log_error_message);
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                        else{
                            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                            
                            if((String) results.get('url') != '' || (String) results.get('url') != null){
                                // String env = (String) results.get('envelopeId');
                                dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                                dsfs.dsfs__DocuSign_Envelope_ID__c = env ;
                                dsfs.Form_Name__c = 'Wish Form & Liability Form';
                                string wichChildName = currWishChild.FirstName__c+' '+currWishChild.LastName__c;
                                if(signerName != wichChildName )
                                dsfs.Associated_Childeren__c = currWishChild.FirstName__c+' '+currWishChild.LastName__c;
                                dsfs.dsfs__Case__c= currCase.id;
                                Insert dsfs;  
                                
                                PageReference reference=new PageReference((String) results.get('url'));
                                reference.setRedirect(true);
                                return reference;
                            }
                        }
                    }
                }
            }
        }
        catch(Exception ex)      
        {
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','SubmitAndSign',currCase.Id,ex,Logvalue));
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.Debug_log_error_message);
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;       
    }
    
    
    /****************************************************************************************************
This BackToWFF() is used to redirect the user into wishFamily form and save the current page details.
*****************************************************************************************************/
    public pageReference BackToWFF() {
        String Logvalue;
        try
        {  
            
            WishInfoSave();
            PageReference reference=new PageReference('/apex/WishFamilyForm_VF?id='+this.currCase.id);
            reference.setRedirect(true);     
            return reference;
            
        }
        Catch(DMLException e)
        {   //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','BackToWFF',currCase.id,e,Logvalue)); 
            displayErrorMessage(e);
        }
        return null;
        
    } 
    
    /****************************************************************************************************
This WishInfoSave() is used to redirect the user into wish information form and save the current page details.
*****************************************************************************************************/
    public PageReference WishInfoSave(){
        String Logvalue;
        try
        {
            
            wcfUtil.isInformation = True;
            saveContact();
            PageReference  reference=new PageReference('/apex/WishInformationForm_VF?id='+currcase.Id+'&part='+isParticipants);
            reference.setRedirect(true);     
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.CONFIRM,'You Have Successfully Saved Your Information');
            ApexPages.addMessage(myMsg);
            return reference;
            
        }
        Catch(DMLException e)
        {   
            //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','WishInfoSave',Null,e,Logvalue));  
            displayErrorMessage(e);
        }
        return null;
    }
    
    /****************************************************************************************************
This submitforApproval() is used to send the wish form to approval process. Once chapter staff approved
the changes are updated into corresponding records.
*****************************************************************************************************/
    public pagereference submitforApproval(){
        boolean isApproval;
        PageReference reference;        
        String Logvalue;
        try{
            
            List<ProcessInstance> approvalIns =  [SELECT TargetObjectId,Status,ProcessDefinitionId,ProcessDefinition.Name FROM ProcessInstance WHERE TargetObjectId =: currCase.id AND Status =: 'Pending' limit 50000];
            If(approvalIns.size() > 0){
                isApproval = true;
            }
            else{
                
                wcfUtil.isInformation = True;
                saveContact();
                case updateParentCase = new Case();
                updateParentCase.Id = currCase.id;
                updateParentCase.Wish_Family_Form_Submitted__c = true;
                Logvalue = String.valueOf(updateParentCase);
                update updateParentCase ;
                
                String chapterName = currCase.ChapterName__r.Name;
                String queueName = chapterName.substringAfter('Make-A-Wish ');
                Group approvarQueue = [SELECT Id,Name FROM Group WHERE Type = 'Queue' AND Name =: queueName LIMIT 1];
                
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting request for approval.');
                req.setObjectId(currCase.id);
                req.setProcessDefinitionNameOrId('Wish_Child_Form_Approval_Process');
                req.setSkipEntryCriteria(true);
                req.setNextApproverIds(new Id[]{approvarQueue.Id});
                Logvalue = String.valueOf(req);
                Approval.ProcessResult result = Approval.process(req);
            }
            reference=new PageReference('/'+currCase.id);
            reference.setRedirect(true);     
            return reference;
        }
        catch(Exception e){          
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','submitforApproval',currCase.id,e,Logvalue));
            e.setMessage(Label.Debug_log_error_message);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null; 
        }  
    }
    
    /****************************************************************************************************
This generatePDF() is used to generate the pdf file which contains the wish child, wish family and wish
information form.
*****************************************************************************************************/ 
    public pagereference generatePDF(){
        String Logvalue;
        try{
            String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
            if(pageName == 'WishChildForm_VF'){
                saveContact();
            }
            if(pageName == 'WishFamilyForm_VF'){
                saveContact();
            }
            if(pageName == 'WishInformationForm_VF'){
                WishInfoSave();
            }
            
            PageReference reference=new PageReference('/apex/WishFormDownloadPDF?Id='+currCase.id+'&force_download=true');
            reference.setRedirect(true);     
            return reference;
            
        }
        catch(Exception e){
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','generatePDF',Null,e,Logvalue));
            displayErrorMessage(e);
        }
        return null;
    }
    
    /****************************************************************************************************
This searchCaseFile() is used to query the case file and return the list of case file records.
information form.
*****************************************************************************************************/ 
    @RemoteAction
    public static Boolean searchCaseFile(String contId) {
        String Logvalue;
        
        List<cg__CaseFile__c> caseFileList = [SELECT id,cg__Case__c FROM cg__CaseFile__c WHERE cg__Case__c =:contId AND cg__Content_Type__c != 'Folder' limit 50000];
        if(caseFileList.size() > 0) {
            return false;
        } else {
            return true;
        }
    } 
    /****************************************************************************************************
This multiEmail() is used query the list of parent legual gurdian name and email who are all going to
sign the wish form
*****************************************************************************************************/ 
    public pageReference multiEmail(){
        String Logvalue;
        try{
            if(currWishChild.IsParticipant__c != true){
                wcfUtil.isInformation = True;
                saveContact();
                signNowList = new List<SelectOption>();  
                Set<String> completedNameSet = new Set<String>();
                for(dsfs__DocuSign_Recipient_Status__c dbdsfs : [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__r.dsfs__Case__c, 
                                                                 dsfs__Parent_Status_Record__r.dsfs__Subject__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Parent_Status_Record__r.dsfs__Case__c =: currentPageId  AND 
                                                                 dsfs__Recipient_Status__c =: 'Completed' AND dsfs__Parent_Status_Record__r.dsfs__Subject__c =: 'Signature Required - Wish Form & Liability And Publicity Release Form']){
                                                                     completedNameSet.add(dbdsfs.Name);
                                                                 }
                
                for(Wish_Child_Form__c parentGurdian : [SELECT Id,Case__c,FirstName__c,LastName__c,BirthDate__c,Email__c,RecordTypeId,IsParticipant__c,Migrated__c   FROM Wish_Child_Form__c WHERE
                                                        Case__c =: currentPageId AND (RecordTypeId =: familyContactRecordTypeId OR RecordTypeId =: wichChildRecordTypeId) AND IsParticipant__c = False AND Email__c != Null AND Migrated__c = false]){
                                                            
                                                            String name = parentGurdian.FirstName__c+' '+parentGurdian.LastName__c;
                                                            
                                                            if((!completedNameSet.contains(name)) && parentGurdian.RecordTypeId == wichChildRecordTypeId && parentGurdian.BirthDate__c != Null && parentGurdian.Email__c != Null){
                                                                if(Integer.valueOf(parentGurdian.BirthDate__c.daysBetween(Date.Today())/365) >= 18 ) {
                                                                    String email = parentGurdian.Email__c;
                                                                    signNowList.add(new SelectOption(name,name));
                                                                    sendEmailMap.put(name,email);
                                                                }
                                                            }
                                                            if((!completedNameSet.contains(name)) && parentGurdian.RecordTypeId == familyContactRecordTypeId && parentGurdian.Email__c != Null){
                                                                String email = parentGurdian.Email__c;
                                                                signNowList.add(new SelectOption(name,name));
                                                                sendEmailMap.put(name,email);
                                                            }                                            
                                                        }
                
            }
        }
        catch(Exception e){
            
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','multiEmail',currentPageId,e,Logvalue));
            displayErrorMessage(e);
        }
        return null;
    }
    
    
    /****************************************************************************************************
This multiEmail() is used display the list of parent legual gurdian name and email who are all going to
sign the wish form
*****************************************************************************************************/ 
    public pageReference sendpdftoEmail (){
        wcfUtil.displayPopup = false;
        
        for(String currString : sendEmailMap.KeySet()){
            wcfUtil.sendEmailMap.put(SignNowName,sendEmailMap.get(SignNowName));
        }
        
        
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipient = [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__r.dsfs__Case__c, 
                                                                dsfs__Parent_Status_Record__r.dsfs__Subject__c FROM dsfs__DocuSign_Recipient_Status__c WHERE Name =: SignNowName AND dsfs__DocuSign_Recipient_Email__c =: wcfUtil.sendEmailMap.values() 
                                                                AND dsfs__Parent_Status_Record__r.dsfs__Case__c =: CurrCase.id AND dsfs__Recipient_Status__c != 'Completed' AND dsfs__Parent_Status_Record__r.dsfs__Subject__c =: 'Signature Required - Wish Form & Liability And Publicity Release Form' Limit 1];
        
        if(dbRecipient.size() > 0){
            boolean ischanged = false;
            ResendEnvelopController resendEnv = new ResendEnvelopController();
            resendEnv.resendEnvelop(dbRecipient[0].dsfs__Envelope_Id__c,dbRecipient[0].Name,dbRecipient[0].dsfs__DocuSign_Recipient_Email__c,ischanged);
        }
        
        else{  
            callouttoDocusing(wcfUtil.sendEmailMap,CurrCase.id,wcfUtil.wishChildId,currWishChild.FirstName__c+' '+currWishChild.LastName__c,'Wish Form & Liability Form', '');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'An email has been sent successfully'));
        }
        PageReference acctPage = new PageReference ('/apex/WishInformationForm_VF?id='+currCase.id+'&part='+isParticipants);
        acctPage.setRedirect(true);
        return acctPage; 
        
    }
    
    /****************************************************************************************************
This callouttoDocusing() is used initiate the call out to docusign to send an email to sign the wish
form.
*****************************************************************************************************/ 
    @Future(callout=true)
    public static void callouttoDocusing(map<String,String> sendEmailMap,String caseId,Id wishChildId,string wishChildName,string formName, String guardianName ){
        
        System.debug('>>>>sendEmailMap>>'+sendEmailMap);
        String Logvalue;
        String subject;
        String emailblar;
        List<Contact> relationShipList = new List<Contact>();
        List<Case> wishChildContact;
        String recId;
        try{
            wishChildContact = [SELECT Id, Contact.FirstName FROM Case WHERE Id =: caseId];
            String childFirstName = '';
            
            if(wishChildContact.size() > 0) {
                childFirstName = wishChildContact[0].Contact.FirstName;
            }
            Pagereference PDF;
            if(formName == 'Wish Form & Liability Form'){ 
                PDF = Page.SendPDF;
                subject = 'Signature Required - Wish Form & Liability And Publicity Release Form';
                emailblar = 'Wish Form and Liability and Publicity Release Form';
            }
            else if(formName == 'Combo Family Form & Liability/Publicity Release Form'){
                PDF = Page.Combo_Wish_Form_VF;
                subject = 'Signature Required - Combo Family Form & Liability/Publicity Release Form';
                emailblar = 'Combo Family Form & Liability/Publicity Release Form';
            }
            String documentPDF;
            PDF.setRedirect(false);
            PDF.getParameters().put('Id',caseId);
            String names = wishChildName;
            if (guardianName != null && guardianName != '' && wishChildName.contains('Self')) {
                wishChildName = wishChildName.remove('Self');
                wishChildName = guardianName + ';' + wishChildName;
            }
            PDF.getParameters().put('name',wishChildName);
            documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
            system.debug(PDF+'base64 value '+documentPDF);
            String recipients = '';
            Integer i = 1;
            String status;
            String boundary = 'AAA';
            String ContactName = '';
            List<contact> contactList = new List<contact>(); 
            List<contact> finalList = new List<contact>();
            String account;
            String IntegratorKey;
            boolean isFirstParent = True;
            Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
            
            for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
                account = credentialIns.account__c;
                IntegratorKey  = credentialIns.IntegratorKey__c;
            }
            
            
            String authorizationHeader = '<DocuSignCredentials><Username>{!$Credential.Username}</Username><Password>{!$Credential.Password}</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
            String clientUserId = '';
            String email;
            String Name;
            //Fetching related contacts that has email address and forming recipients with signature location.
            for(String currString : sendEmailMap.KeySet()){
                Name = currString;
                email = sendEmailMap.get(currString);
                
                if(recipients != '')
                    recipients = recipients + ',';
                recipients = recipients + '{'+
                    '      "email": "'+email+'",'+
                    '      "name": "'+Name+'",'+
                    '      "recipientId":"' + i + '",' + clientUserId +
                    '      "tabs": {'+
                    '                "signHereTabs": [{'+
                    '                     "anchorString":"~s1",'+
                    '                    "anchorXOffset": "0",'+
                    '                   "anchorYOffset": "0",'+
                    '                    "anchorIgnoreIfNotPresent": "false",'+
                    '                    "anchorUnits": "inches"'+
                    '                  }],'+
                    '                 "radioGroupTabs": [{'+
                    '                    "groupName": "Radio Group 1",'+
                    '                    "required": "true",'+
                    '                    "radios": [{'+
                    '                    "anchorString": "~FirstRadio",'+
                    '                    "anchorXOffset": "0",'+
                    '                    "anchorYOffset": "0",'+
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches",'+
                    '                    "optional"   :"false",'+
                    '                    "selected": "false",'+
                    '                    "value": "one1Radio",'+
                    '                    "mergeField" : {"configurationType":"Salesforce","path":"case.Option1__c","writeBack":"true","allowSenderToEdit":"true"},'+
                    '                    "xPosition": "7200",'+
                    '                    "yPosition": "19020"},{'+
                    '                    "anchorString": "~secondRadio",'+
                    '                    "anchorXOffset": "0",'+
                    '                    "anchorYOffset": "0",'+
                    '                    "optional"   :"false",'+
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches",'+
                    '                    "selected": "false",'+
                    '                     "value": "twoRadio",'+
                    '                    "mergeField" : {"configurationType":"Salesforce","path":"case.Option2__c","writeBack":"true","allowSenderToEdit":"true"},'+
                    '                    "xPosition": "7200",'+
                    '                    "yPosition": "19020"'+
                    '                    }]'+
                    '                   }],'+
                    '                "initialHereTabs": [{' +
                    '                    "anchorString": "~123abcinitial",' +
                    '                    "conditionalParentLabel":"Radio Group 1",'+
                    '                    "conditionalParentValue" :"one1Radio",'+
                    '                    "optional"    :  "false",' +
                    '                    "anchorXOffset": "0",' +
                    '                    "anchorYOffset": "0.2",' +
                    '                    "name"       : "FirstInitial",'+
                    '                    "mergeField" : {"configurationType":"Salesforce","path":"case.Option1__c","writeBack":"true","allowSenderToEdit":"true"},'+
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches"},{'+
                    '                    "anchorString": "~initial2",' +
                    '                    "optional"    :  "false",' +
                    '                    "conditionalParentLabel":"Radio Group 1",'+
                    '                    "mergeField" : {"configurationType":"Salesforce","path":"case.Option2__c","writeBack":"true","allowSenderToEdit":"true"},'+
                    '                    "conditionalParentValue" :"twoRadio",'+
                    '                    "name"       : "SecondInitial",'+
                    '                    "anchorXOffset": "0",' +
                    '                    "anchorYOffset": "0.2",' +
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches"'+
                    '                }],' +
                    '                  "dateSignedTabs": [{'+
                    '                      "anchorString": "~date1",'+
                    '                       "anchorXOffset": "0",'+
                    '                       "fontSize":      "Size14",'+
                    '                       "fontColor":     "Black",'+
                    '                        "anchorYOffset": "0",'+
                    '                        "anchorIgnoreIfNotPresent": "false",'+
                    '                        "xPosition": "100",'+
                    '                         "yPosition": "72",'+
                    '                         "anchorUnits": "inches"'+
                    '                    }]'+
                    '            }'+
                    '    }';
                
                
                
                
            }
            //forming payload with the document and recipients.
            String body =  '{'+
                '  "status":"sent",'+
                '  "enableWetSign": "false",'+
                '  "emailBlurb":"Hello,'+'\r\n\n Please sign the attached'+' '+emailblar+ ' necessary for '+ childFirstName +'\'s wish. \r\n\nThank You,\r\n Wish & Volunteer Center",'+
                '  "emailSubject": "'+subject+'",'+
                '  "enforceSignerVisibility":"True",'+
                '  "documents": [{'+
                '      "name": "document.pdf",'+
                '      "documentId":"1",'+
                '      "order":"1",'+
                '      "documentBase64":"'+documentPDF+'"'+
                '  }],'+
                '"notification":{'+
                '"useAccountDefaults":"false",'+
                '"reminders":{'+
                '"reminderEnabled":"true",'+
                '"reminderDelay":"1",'+
                '"reminderFrequency":"1"'+
                '},'+
                '"expirations":{'+
                '"expireEnabled":"true",'+
                '"expireAfter":"10",'+
                '"expireWarn":"7"'+
                '}'+
                ' },'+
                '"recipients": {'+
                '    "signers" : ['+recipients+']'+
                ' }'+
                '}';
            String viewBody = '{'+
                '"returnUrl": "https://www.docusign.com/devcenter"'+
                '}';
            String header = '--'+boundary+'\nContent-Type: application/json\nContent-Disposition: form-data';
            String jsonBody = header +'\n\n'+body+'\n\n--'+boundary+'--';
            system.debug('@@@@@JSONBODY@@@@@'+jsonBody);
            //Callout to Docusign.
            HttpRequest req = new HttpRequest();
            req.setHeader('X-DocuSign-Authentication', authorizationHeader);
            req.setHeader('Accept','application/json');
            req.setHeader('Host','demo.docusign.net');
            req.setHeader('Content-Length','162100');
            req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
            req.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes');
            req.setMethod('POST'); 
            req.setBody(jsonBody);
            system.debug('reqbodyLog'+req.getBody());
            Http http = new Http();
            HTTPResponse res;
            
            if(recipients != '')
            {
                Logvalue = String.valueOf(req);
                res = http.send(req);
                system.debug('@@ systemdebug @@'+res.getstatusCode());
                system.debug('@@ systemdebug @@'+res.getbody());
                //Docusign status record creation.
                if(res.getstatusCode() != 200 && res.getstatusCode() != 201){
                    new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','callouttoDocusing',caseId,null,res.getBody()));
                }
                
                else{
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    if((String) results.get('status') == 'Sent'){
                        status = 'Agreement sent to email.';
                        dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                        dsfs.dsfs__DocuSign_Envelope_ID__c = (String) results.get('envelopeId');
                        dsfs.dsfs__Case__c= caseId;
                        dsfs.Form_Name__c = 'Wish Form & Liability Form';
                        if(Name != wishChildName)
                        dsfs.Associated_Childeren__c = wishChildName;
                        Logvalue = String.valueOf(dsfs);
                        Insert dsfs;
                    }else
                        status = (String) results.get('errorCode');
                }
            }
        }
        catch(Exception e){
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','callouttoDocusing',Null,e,Logvalue));
            e.setMessage(Label.Debug_log_error_message);
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            //ApexPages.addMessage(myMsg);
        } 
        
    }
    
    /*********************************************************************
This WishInfoWithSave() is used to save the wish information form.
**********************************************************************/
    public void WishInfoWithSave(){
        String Logvalue;
        try
        {
            wcfUtil.isInformation = True;
            saveContact();
        } 
        Catch(Exception e)
        {   //showException = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','WishInfoWithSave',Null,e,Logvalue));
            displayErrorMessage(e);
        }
    }
    
    /****************************************************************************************************
This forceDownloadPDF() is used to save the current page and download the entire wish form
*****************************************************************************************************/   
    public void forceDownloadPDF(){
        String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        String Logvalue;
        try{
            if(pageName == 'WishChildForm_VF'){
                saveContact();
            }
            if(pageName == 'WishFamilyForm_VF'){
                saveContact();
            }
            if(pageName == 'WishInformationForm_VF'){
                WishInfoSave();
            }
            
            
            if(ApexPages.currentPage().getParameters().get('force_download') != null && ApexPages.currentPage().getParameters().get('force_download') == 'true') 
            {
                string fileName = 'Wish Forms'+date.today()+'.pdf';
                if(apexPages.currentPage().getParameters().get('filename') != null)
                {
                    fileName = apexPages.currentPage().getParameters().get('filename') +'.pdf';
                }
                Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt; filename='+fileName);
            }
            
        }
        catch(Exception e){
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','forceDownloadPDF',Null,e,Logvalue));
            displayErrorMessage(e);
        }   
    }
    
    /***********
***********************************************************************************************
This DisplayApprovalProcess() is used to display the error message when the wish form is approval process
***********************************************************************************************************/
    public pageReference DisplayApprovalProcess(){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,' This record is already in approval process'));
        return null;
    } 
    
    /**********************************************************************************************************
This getRaceEthnicity() is used to get the raceethnicity details values and displayed in wish family form.
***********************************************************************************************************/
    public List<SelectOption> getRaceEthnicity(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  Wish_Child_Form__c.Race_Ethnicity__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('', '')); 
        for( Schema.PicklistEntry currVal : picklistValues)
        {      
            options.add(new SelectOption(currVal.getLabel(), currVal.getValue())); 
        }  
        return options;
    }  
    
    /**********************************************************************************************************
This getRaceEthnicity() is used to get the raceethnicity details values and displayed in wish family form.
***********************************************************************************************************/
    public List<SelectOption> getDoesParticipantReqWheelchair(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','')); 
        
        for(String name : wcfUtil.leftWCNamesList){
            options.add(new SelectOption(name,name)); 
        }
        
        return options;
    }  
    
    /**********************************************************************************************************
This getWillYourFamilyBringWheelChair() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getWillYourFamilyBringWheelChair(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','')); 
        
        for(String name : wcfUtil.leftOwnWheelChairList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    /**********************************************************************************************************
This getWheelChairColapsable() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getWheelChairColapsable(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        
        for(String name : wcfUtil.leftWCCollapsibleList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    /**********************************************************************************************************
This getwheelChairPower() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getwheelChairPower(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftWCPowerList){
            options.add(new SelectOption(name,name)); 
        }
        
        return options;
    } 
    
    /**********************************************************************************************************
This getparticipantRequireOxygan() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getparticipantRequireOxygan(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftOxygenNamesList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    /**********************************************************************************************************
This getparticipantHaveSpecialRestrictaion() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getparticipantHaveSpecialRestrictaion(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftDietaryNameList){
            options.add(new SelectOption(name,name)); 
        }
        
        return options;
    } 
    
    /**********************************************************************************************************
This getparticipantHaveSpecialRestrictaion() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getparticipantHaveSpecialallergies(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        
        for(String name : wcfUtil.leftNursingCareList){
            options.add(new SelectOption(name,name)); 
        }
        
        return options;
    } 
    
    /**********************************************************************************************************
This getmedicationRequireRefeigeration() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getmedicationRequireRefeigeration(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));         
        
        for(String name : wcfUtil.leftMedicationList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    /**********************************************************************************************************
This getcurrentlyReceiveNursingCare() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getcurrentlyReceiveNursingCare(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        for(String name : wcfUtil.leftAllergyNamesList){
            options.add(new SelectOption(name,name)); 
        }
        
        return options;
    } 
    
    /**********************************************************************************************************
This getanyOtherMedicalSupplies() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public List<SelectOption>getanyOtherMedicalSupplies(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '')); 
        
        for(String name : wcfUtil.leftOtherNeedsList){
            options.add(new SelectOption(name,name)); 
        }
        return options;
    } 
    
    /************************************************************************
This withOutNavigate() is used nevegate the user to corresponding form.
**************************************************************************/
    Public pageReference withOutNavigate(){
        pageReference reference;
        String Logvalue;
        String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        try{
            
            if(pageName == 'WishChildForm_VF'){
                reference=new PageReference('/apex/WishChildForm_VF?id='+this.currCase.id);
                reference.setRedirect(true);  
            }
            if(pageName == 'WishFamilyForm_VF'){
                reference=new PageReference('/apex/WishFamilyForm_VF?id='+currCase.id+'&part='+isParticipants);
                reference.setRedirect(true); 
            }
            if(pageName == 'WishInformationForm_VF'){
                reference=new PageReference('/apex/WishInformationForm_VF?id='+currCase.id+'&part='+isParticipants);
                reference.setRedirect(true);  
            }
            
            return reference;
        }
        catch(Exception e){
            //showException  = true;
            new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','withOutNavigate',Null,e,Logvalue));
            displayErrorMessage(e);
        }
        return null;
    }
    
    /**********************************************************************************************************
This RetrunToWish() is used to is used nevegate the user to corresponding form.
**********************************************************************************************************/
    public pageReference RetrunToWish(){
        String Logvalue;
        pageReference reference;
        String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        if(pageName == 'WishChildForm_VF'){
            saveContact();
        }
        if(pageName == 'WishFamilyForm_VF'){
            saveContact();
        }
        if(pageName == 'WishInformationForm_VF'){
            WishInfoSave();
        }
        system.debug('pageName'+pageName);
        reference=new PageReference('/'+currCase.id);
        reference.setRedirect(true);  
        return reference;
    }
    
    /**********************************************************************************************************
This selectedNamesss() is used to get the participant name from wish participant section
***********************************************************************************************************/
    Public String selectedNamesss(List<String> selectedNames)
    {
        Boolean start=True;
        String currString = '';
        String returnName;
        String returnSecondName;
        if(selectedNames != Null) {           
            for(String Str : selectedNames) {
                if(currString == '')
                    currString = str;
                else
                    currString +=','+str;
            }
        }
        return currString ;
    }
    
    /**********************************************************************************************************
This getTempName() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public list<String> getTempName(){
        
        if(determinationcaseInfo.Requested_Participant_Name_forWheelchair__c != null){
            tempName = (determinationcaseInfo.Requested_Participant_Name_forWheelchair__c).split(',');                                  
        }
        return tempName;
    }
    
    /*******************************************************************************************
This setTempName() is used to display the participant name in medical information section.
********************************************************************************************/
    public void setTempName(list<string> val){
        this.tempName = val;
    }
    
    /**********************************************************************************************************
This getCurrentOwnWheelChairList() is used to get the participant name from wish participant section
***********************************************************************************************************/
    public list<String> getCurrentOwnWheelChairList(){
        
        if(determinationcaseInfo.Bringing_Own_Wheel_Chair__c != null){
            currentOwnWheelChairList = (determinationcaseInfo.Bringing_Own_Wheel_Chair__c).split(',');
        }
        return currentOwnWheelChairList;
    }
    
    /***************************************************************************************************************
This setCurrentOwnWheelChairList() is used to display the participant name in medical information section.
*****************************************************************************************************************/
    public void setCurrentOwnWheelChairList(list<string> val){
        this.currentOwnWheelChairList= val;
    }
    
    /**********************************************************************************************************
This getCurrentWCCollapsibleList() is used to get the participant name from wish participant section
***********************************************************************************************************/
    Public list<String> getCurrentWCCollapsibleList(){
        if(determinationcaseInfo.Name_of_wheelchair_collapsible__c != Null){
            currentWCCollapsibleList = (determinationcaseInfo.Name_of_wheelchair_collapsible__c).split(',');
        }
        return currentWCCollapsibleList;
    }
    
    /**********************************************************************************************************
This setCurrentWCCollapsibleList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    public void setCurrentWCCollapsibleList(list<string> val){
        this.currentWCCollapsibleList = val;
    }
    
    /**********************************************************************************************************
This getCurrentWCPowerList() is used to get the participant name from wish participant section
***********************************************************************************************************/
    Public list<String> getCurrentWCPowerList(){
        if(determinationcaseInfo.Pariticipant_name_havingWheelchair_Power__c != Null){
            currentWCPowerList = (determinationcaseInfo.Pariticipant_name_havingWheelchair_Power__c).split(',');
        }
        return currentWCPowerList;
    }
    
    /**********************************************************************************************************
This setCurrentWCPowerList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    public void setCurrentWCPowerList(list<string> val){
        this.currentWCPowerList = val;
    }
    
    /**********************************************************************************************************
This getCurrentOxygenNamesList() is used to get the participant name from wish participant section
***********************************************************************************************************/
    Public list<String> getCurrentOxygenNamesList(){
        if( determinationcaseInfo.Requested_Participant_Name_for_Oxygen__c != Null){
            currentOxygenNamesList = ( determinationcaseInfo.Requested_Participant_Name_for_Oxygen__c).split(',');
        }
        return currentOxygenNamesList;
    }
    
    /**********************************************************************************************************
This setCurrentOxygenNamesList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    public void setCurrentOxygenNamesList(list<string> val){
        this.currentOxygenNamesList = val;
    }
    
    /**********************************************************************************************************
This getCurrrentDietaryNameList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    Public list<String> getCurrrentDietaryNameList(){
        if(determinationcaseInfo.Participant_Name_for_Dietary_Restriction__c != Null){
            currrentDietaryNameList = (determinationcaseInfo.Participant_Name_for_Dietary_Restriction__c).split(',');
        }
        return currrentDietaryNameList;
    }
    
    /**********************************************************************************************************
This setCurrrentDietaryNameList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    public void setCurrrentDietaryNameList(list<string> val){
        this.currrentDietaryNameList= val;
    }
    
    /**********************************************************************************************************
This getCurrentNursingCareList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    
    Public list<String> getCurrentNursingCareList(){
        if(determinationcaseInfo.Names_for_receiving_nursing_care__c != Null){
            currentNursingCareList = (determinationcaseInfo.Names_for_receiving_nursing_care__c).split(',');
        }
        return currentNursingCareList;
    }
    
    /**********************************************************************************************************
This setCurrentNursingCareList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    public void setCurrentNursingCareList(list<string> val){
        this.currentNursingCareList = val;
    }
    
    /**********************************************************************************************************
This getCurrentMedicationList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    Public list<String> getCurrentMedicationList(){
        if(determinationcaseInfo.Medication_require_refrigeration_name__c != Null){
            currentMedicationList = (determinationcaseInfo.Medication_require_refrigeration_name__c).split(',');
        }
        
        return currentMedicationList;
    }
    
    /**********************************************************************************************************
This setCurrentMedicationList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    public void setCurrentMedicationList(list<string> val){
        this.currentMedicationList = val;
    }
    
    /**********************************************************************************************************
This getCurrentAllergyNamesList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    Public list<String> getCurrentAllergyNamesList(){
        
        if(determinationcaseInfo.Requested_Participant_Name_for_Allergies__c  != Null){
            currentAllergyNamesList = (determinationcaseInfo.Requested_Participant_Name_for_Allergies__c).split(',');
        }
        
        return currentAllergyNamesList;
    }
    
    /**********************************************************************************************************
This setCurrentAllergyNamesList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    public void setCurrentAllergyNamesList(list<string> val){
        this.currentAllergyNamesList = val;
    }
    
    /**********************************************************************************************************
This getCurrentOtherNeedsList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    Public list<String> getCurrentOtherNeedsList(){
        if(determinationcaseInfo.Requested_Participant_Name_for_OtherNeed__c  != Null){
            currentOtherNeedsList = (determinationcaseInfo.Requested_Participant_Name_for_OtherNeed__c ).split(',');
        }
        return currentOtherNeedsList;
    }
    
    /**********************************************************************************************************
This setCurrentOtherNeedsList() is used to display the participant name in medical information section.
***********************************************************************************************************/
    public void setCurrentOtherNeedsList(list<string> val){
        this.CurrentOtherNeedsList = val;
    }
    
    public list<String> getethnicityList(){
        if(determinationcaseInfo.Race_Ethnicity__c != Null){
            ethnicityList = (determinationcaseInfo.Race_Ethnicity__c).split(',');
        }
        system.debug('@@@ ethnicityList  @@@@'+ethnicityList);
        return ethnicityList;
    }
    
    public void setethnicityList(list<string> val){
        system.debug('@@@ val  @@@@'+val);
        this.ethnicityList = val;
    }
    
    /*****************************************************************************************************
It redirect to the File  Upload page when the wish fomr in Submit for approval Process.
******************************************************************************************************/
    public pageReference UploadFile(){       
        pageReference reference;
        reference = new PageReference('/apex/WishFormAttachments_VF?id='+currCase.Id);
        reference.setRedirect(true);
        return reference;
    }
    
    public List<cg__CaseFile__c> getAttachments() {
        attachmentList = [select Id, File_Path__c,cg__Description__c, cg__Case__c, cg__File_Name__c from cg__CaseFile__c where cg__Case__c =: recId AND cg__Parent_Folder_Id__c != Null LIMIT 50000];
        return attachmentList;
    }
    //Used to save new attachment theat attached from Wish child form
    public void saveAttachment() {
        if (newAttachment.Body!=null) {
            newAttachment.parentId = recId;
            insert newAttachment;  
            
            if(pageName != Null && participantName != Null && participantEmail != Null && formName != Null && associatedParticipant != Null){
                
                Minor_Participant__c newMinorRec = new Minor_Participant__c();
                newMinorRec.Name__c = participantName;
                newMinorRec.Associated_Childeren__c = associatedParticipant;
                newMinorRec.Case__c = currentPageId;
                newMinorRec.Email__c = participantEmail;
                newMinorRec.Case__c= currentPageId;
                newMinorRec.Form_Name__c = formName; 
                newMinorRec.AttachmentId__c = newAttachment.Name;
                
                insert newMinorRec;
            }
            
            
            attachmentList.clear();
            attachmentList = [select Id, File_Path__c,cg__Description__c, cg__Case__c, cg__File_Name__c from cg__CaseFile__c where cg__Case__c =: recId AND cg__Parent_Folder_Id__c != Null order by Name desc];                   
            newAttachment = new Attachment();
            sucess = True;
        }
        
    }
    
    //Used to refresh the block
    public PageReference refresh() {
        PageReference redirect = new PageReference('/apex/WishFormAttachments_VF?id='+recId);
        redirect.setRedirect(true);
        return redirect;
    }
    
    //Used to delete the attachment from wish child form
    public PageReference removeAttachment() {
        system.debug('attachmentId'+attachmentId);
        List<cg__CaseFile__c> attachmentToBeDeleted = [SELECT Id FROM cg__CaseFile__c WHERE Id =: attachmentId LIMIT 50000 ];
        if(attachmentToBeDeleted.size() > 0) {
            try{
                delete attachmentToBeDeleted;  
                PageReference redirect = new PageReference('/apex/WishFormAttachments_VF?id='+recId); 
                redirect.setRedirect(true);
                return redirect; 
            }
            Catch(Exception e){
                String Logvalue = String.valueof(attachmentToBeDeleted);
                new ApexDebugLog().createLog(new ApexDebugLog.Error('WishChildForm_AC','removeAttachment',recId,e,Logvalue)); 
                displayErrorMessage(e);
                return null;
            }            
        }
        
        return null;
    }
    
    // This method is used to display the error message when an exception has occured.
    Public Pagereference displayErrorMessage(Exception ex){
        ex.setMessage(Label.Debug_log_error_message);
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
        ApexPages.addMessage(myMsg);
        return null;
        
    }
}