/******************************************************************************************************************
Created by: Kanagaraj
Author : MST Solutions
CreateDate : 06/01/2016
Description : This SignNow_AC class is used to featch all the details given in the wish child form, 
wish family form and wish information form to display when the user sign the document usign electronic signature.
******************************************************************************************************************/
public Class SignNow_AC{
    Constant_AC  constant = new Constant_AC();
    public WishChildFormUtil wcfUtil{get;set;}
    public Case currCase{get;set;}
    public Id currentPageId;
    public String participantsName{get;set;} 
    public String comboParticipantName{get;set;} 
    public boolean isSelf;
    public List<Wish_Child_Form__c> displayWishFamilyList{get;set;}
    public List<Wish_Child_Form__c> displayWishFamilyParticipantList{get;set;}
    public List<Wish_Child_Form__c> driverInformationList{get;set;}
    Public List<Wish_Child_Form__c> wishFormList{get;set;}
    public Wish_Child_Form__c currWishChild{get;set;}
    public Wish_Child_Form__c emergencyChild{get;set;}
    public Wish_Child_Form__c determinationcaseInfo{get;set;}
    Public Id familyContactRecordTypeId{get;set;}
    Public Id wichChildRecordTypeId{get;set;}
    Public Id emergencyContactRecordTypeId{get;set;}
    Public Id wishDterminationCaseRecordTypeId{get;set;}
    Public Id driverContactRecordType{get;set;}
    /*********************************************************************************************************
SignNow_AC this is the construcotr method it will load when the user trying to get electronic signature.
**********************************************************************************************************/
    public SignNow_AC(Apexpages.StandardController controller){
        familyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormFamily).getRecordTypeId();
        wichChildRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChild).getRecordTypeId();
        wishDterminationCaseRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormDeterMination).getRecordTypeId(); 
        driverContactRecordType = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildDriver).getRecordTypeId(); 
        emergencyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildEmergency).getRecordTypeId(); 
        wishFormList  = new List<Wish_Child_Form__c>();
        displayWishFamilyList = new List<Wish_Child_Form__c>();
        displayWishFamilyParticipantList = new List<Wish_Child_Form__c>();
        driverInformationList = new List<Wish_Child_Form__c>(); 
        currWishChild = new Wish_Child_Form__c();
        emergencyChild = new Wish_Child_Form__c();
        determinationcaseInfo = new Wish_Child_Form__c();
        currentPageId =  ApexPages.currentPage().getParameters().get('id');
        participantsName = '';
        comboParticipantName = '';
        if(wcfUtil == null)   
            wcfUtil = new WishChildFormUtil();
       
        currentPageId =  ApexPages.currentPage().getParameters().get('id');
        
        if(currentPageId != null){
            
            this.currCase = (Case)controller.getRecord();
            currWishChild = new Wish_Child_Form__c();  
            
            this.currCase = [SELECT id,Hidden_Email_List__c,ContactId,Contact.FirstName,Contact.LastName,Contact.Name,Contact.Middle_Name__c,
                             Contact.Diagnosis__c , Contact.Email, Contact.MobilePhone, Contact.Gender__C,
                             Contact.BirthDate, Contact.T_Shirt_Size__c, Contact.MailingStreet,
                             Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode,ChapterName__c,ChapterName__r.Name
                             FROM Case WHERE Id = :this.currCase.id limit 1];
            
            List<CaseTeamMember> caseTeamMemberList = [SELECT id,Member.Name FROM CaseTeamMember WHERE ParentId =: this.currCase.id AND TeamRole.Name = 'Wish Granter' limit 2];
            if(caseTeamMemberList.size() > 0){
                wcfUtil.caseTeamMemberNo1 = caseTeamMemberList[0].Member.Name;
                if(caseTeamMemberList.size() > 1)
                    wcfUtil.caseTeamMemberNo2 = caseTeamMemberList[1].Member.Name;
            }
            
            //build wish child list
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
                
                
                for(Wish_Child_Form__c dbWishFormRec : wishFormList){
                    if(dbWishFormRec.RecordTypeId == emergencyContactRecordTypeId ){
                        if(caseTeamMemberList.size() > 0){
                            dbWishFormRec.Case_Team_Member1__c = caseTeamMemberList[0].Member.Name;
                            if(caseTeamMemberList.size() > 1){
							dbWishFormRec.Case_Team_Member2__c = caseTeamMemberList[1].Member.Name;
							}
                        }
                        emergencyChild = dbWishFormRec;
                     }
                     if(dbWishFormRec.RecordTypeId == wichChildRecordTypeId){
                        if(dbWishFormRec.BirthDate__c != Null){
                            Date dt = Date.Valueof(dbWishFormRec.BirthDate__c);
                            Integer days = dt.daysBetween(Date.Today());
                            Integer age = Integer.valueOf(days/365);
                            String name = dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
                            if(age > = 18){
//                               if(participantsName == ''){
//                                    participantsName = dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
//                               }
//                                else{
//                                    participantsName = participantsName+','+' '+dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
//                                }
//                               if(comboParticipantName == ''){
//                                    comboParticipantName  = dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
//                               }
//                              else{
//                                  comboParticipantName= comboParticipantName+','+' '+dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
//                            }
                          }
                       }
                      }
//                    if(dbWishFormRec.RecordTypeId == familyContactRecordTypeId){
//                        if(participantsName == ''){
//                            participantsName = dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
//                        }
//                        else{
//                        participantsName = participantsName+','+' '+dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
//                        }
//                        if(comboParticipantName == ''){
//                        comboParticipantName  = dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
//                        }
//                         else{
//                        comboParticipantName= comboParticipantName+','+' '+dbWishFormRec.FirstName__c+' '+dbWishFormRec.LastName__c;
//                        }
//                        if(dbWishFormRec.Self__c == true){
//                            isSelf = true;
//                        }
//
//                    }
                    
                    if(dbWishFormRec.RecordTypeId == familyContactRecordTypeId && dbWishFormRec.IsParticipant__c == false){
                        displayWishFamilyList.add(dbWishFormRec);
                    }
                    if(dbWishFormRec.RecordTypeId == familyContactRecordTypeId && dbWishFormRec.IsParticipant__c == true){
                        displayWishFamilyParticipantList.add(dbWishFormRec);
                    }
                   if(dbWishFormRec.RecordTypeId == wichChildRecordTypeId){
                         currWishChild = dbWishFormRec;
                     }
                    if(dbWishFormRec.RecordTypeId == driverContactRecordType){
                        driverInformationList.add(dbWishFormRec);
                    }
                    if(dbWishFormRec.RecordTypeId == wishDterminationCaseRecordTypeId){
                        determinationcaseInfo = dbWishFormRec;
                    }    
                }
//                if(isSelf == true){
//                        comboParticipantName = comboParticipantName+','+' '+'Self';
//                }


                participantsName = Apexpages.currentPage().getParameters().get('name');
                if (participantsName != null) {
                    participantsName = participantsName.replace(';', ', ');
                    participantsName = participantsName.removeEndIgnoreCase(', ');
                }
                comboParticipantName = participantsName;
         }   
      }
    }
}