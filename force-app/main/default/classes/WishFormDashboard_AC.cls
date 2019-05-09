public class WishFormDashboard_AC{
    Constant_AC  constant = new Constant_AC();  
    public List<WishGrantingWrapper> wishGrantingWrapperList{get;set;}
    public List<Wish_Child_Form__c> wishChildFormList{get;set;}
    public Id currentPageId{get;set;}
    Public string childName{get;set;}
    public boolean displaypopup{get;set;}
    public String formStatus{get;set;}
    public boolean displayguardian{get;set;}
    public Map<String,String> participantMap; 
    public Map<String,String> recipientMap;
    public integer n =0;
    public integer m = 0;
    public boolean deletePopup{get;set;}
    Public String  docuEnve;
    public string participantRecId;
    Public Id familyContactRecordTypeId{get;set;}
    Public Id wichChildRecordTypeId{get;set;}
    
    /**
* [WishFormDashboard_AC description]
* @param  currentPageId [description]
* @return               [description]
*/
    public WishFormDashboard_AC(Id currentPageId){
        integer j = 0;
        integer k = 0;
        integer l = 0;
        displaypopup = false;
        displayguardian = false;
        deletePopup = false;
        participantMap = new Map<String,String>();
        recipientMap = new Map<String,String>();
        wishGrantingWrapperList = new List<WishGrantingWrapper>();
        set<String> fileDupset = new Set<String>();
        Constant_AC cons = new Constant_AC();
        familyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormFamily).getRecordTypeId();
        wichChildRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChild).getRecordTypeId();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        
        
        List<Minor_Participant__c> dbMinorList = [SELECT Id,Name,hiddenFormat__c,Associated_Childeren__c,Case__c,Email__c,Form_Name__c,
                                                  RecordTypeId,Guardian_Name__c,Name__c,AttachmentId__c  FROM Minor_Participant__c WHERE 
                                                  Case__c =:currentPageId AND RecordTypeId =: formTrackerAttachMentRecordTypeId];
        
        wishChildFormList = [SELECT Id,FirstName__c,LastName__c,Middle_Name__c,Email__c,BirthDate__c,Emergency_Relationship__c,Case__r.ContactId,
                             Case__r.Contact.Name,RecordTypeId,IsParticipant__c,Migrated__c  FROM Wish_Child_Form__c WHERE Case__c =: currentPageId 
                             AND (RecordTypeId =: familyContactRecordTypeId OR RecordTypeId =: wichChildRecordTypeId) AND Migrated__c = False];
        
        childName = wishChildFormList[0].Case__r.Contact.Name;
        
        
        for(Wish_Child_Form__c processString : wishChildFormList ){
            
            if(processString.RecordTypeId == familyContactRecordTypeId && processString.IsParticipant__c == false){
                String dupString = processString.FirstName__c+' '+processString.LastName__c+' '+processString.Email__c;
                fileDupset.add(dupString);
                WishGrantingWrapper wrapperIns = new WishGrantingWrapper();
                wrapperIns.name = processString.FirstName__c+' '+processString.LastName__c;
                
                wrapperIns.relationship = processString.Emergency_Relationship__c;
                wrapperIns.unsigned = inCompletedRecipient(wrapperIns.name,currentPageId);
                wrapperIns.signed = completedRecipient(wrapperIns.name,currentPageId);
                if(wrapperIns.unsigned == 0 && wrapperIns.signed == 0)
                {
                    j = 1;
                } 
                if(wrapperIns.signed == 0){
                    k = 1;
                }
                if(wrapperIns.unsigned >= wrapperIns.signed)
                {
                    k = 1;
                }
                if(wrapperIns.unsigned <  wrapperIns.signed)
                {
                    l = 1;
                }
                string formstatus = checkEnvelopSent(wrapperIns.name,currentPageId);
                if(formstatus == 'Not Sent'){
                    wrapperIns.forms = 'Send';
                }
                else{
                    wrapperIns.forms = 'View';
                }
                
                wishGrantingWrapperList.add(wrapperIns);
                participantMap.put(processString.FirstName__c+' '+processString.LastName__c,processString.Email__c);
            } 
            if((processString.RecordTypeId == familyContactRecordTypeId && processString.IsParticipant__c == true) || (processString.RecordTypeId == wichChildRecordTypeId)){
                
                if(processString.BirthDate__c != Null){
                    Date dt = Date.Valueof(processString.BirthDate__c);
                    Integer days = dt.daysBetween(Date.Today());
                    Integer age = Integer.valueOf(days/365);
                   
                    if(age >= 18){
                        String dupString = processString.FirstName__c+' '+processString.LastName__c+' '+processString.Email__c;
                        fileDupset.add(dupString);
                        WishGrantingWrapper wrapperIns = new WishGrantingWrapper();
                        wrapperIns.name = processString.FirstName__c+' '+processString.LastName__c;
                        wrapperIns.relationship = processString.Emergency_Relationship__c;
                        wrapperIns.unsigned = inCompletedRecipient(wrapperIns.name,currentPageId);
                        wrapperIns.signed = completedRecipient(wrapperIns.name,currentPageId);
                        if(wrapperIns.unsigned == 0 && wrapperIns.signed == 0)
                        {
                            j = 1;
                        } 
                        if(wrapperIns.signed == 0){
                            k = 1;
                        }
                        if(wrapperIns.unsigned >= wrapperIns.signed)
                        {
                            k = 1;
                        }
                        if(wrapperIns.unsigned <  wrapperIns.signed)
                        {
                            l = 1;
                        }
                        string formstatus = checkEnvelopSent(wrapperIns.name,currentPageId);
                        if(formstatus == 'Not Sent'){
                            wrapperIns.forms = 'Send';
                        }
                        else{
                            wrapperIns.forms = 'View';
                        }
                        wishGrantingWrapperList.add(wrapperIns);
                        participantMap.put(processString.FirstName__c+' '+processString.LastName__c,processString.Email__c);
                        recipientMap.put(processString.FirstName__c+' '+processString.LastName__c,'participent');
                    }
                }
            }
            
        }
        
        
        
        if(dbMinorList.size() > 0){
            set<String> dupset = new Set<String>();
            for(Minor_Participant__c dbMinor : dbMinorList){
                String dupString = dbMinor.Name__c+' '+dbMinor.email__c;
                if(!dupset.contains(dupString) && dbMinor.AttachmentId__c == Null && (!dbMinor.hiddenFormat__c) && (!fileDupset.contains(dupString))){
                    WishGrantingWrapper wrapperIns = new WishGrantingWrapper();
                    wrapperIns.name = dbMinor.Name__c;
                    wrapperIns.relationship = 'Parent of Minor';
                    wrapperIns.unsigned = inCompletedRecipient(wrapperIns.name,currentPageId) ;
                    wrapperIns.signed = completedRecipient(wrapperIns.name,currentPageId);
                    if(wrapperIns.unsigned == 0 && wrapperIns.signed == 0)
                    {
                        j = 1;
                    } 
                    if(wrapperIns.signed == 0){
                        k = 1;
                    }
                    if(wrapperIns.unsigned >= wrapperIns.signed)
                    {
                        k = 1;
                    }
                    if(wrapperIns.unsigned <  wrapperIns.signed)
                    {
                        l = 1;
                    }
                    string formstatus = checkEnvelopSent(wrapperIns.name,currentPageId);
                    if(formstatus == 'Not Sent'){
                        wrapperIns.forms = 'Send';
                    }
                    else{
                        wrapperIns.forms = 'View';
                    }
                    dupset.add(dbMinor.Name__c+' '+dbMinor.Email__c);
                    wishGrantingWrapperList.add(wrapperIns);
                }
                
                if(!fileDupset.contains(dupString) && dbMinor.AttachmentId__c != Null && (!dupset.contains(dupString))){
                    WishGrantingWrapper wrapperIns = new WishGrantingWrapper();
                    wrapperIns.name = dbMinor.Name__c;
                    wrapperIns.relationship = 'Parent of Minor';
                    wrapperIns.unsigned = inCompletedRecipient(wrapperIns.name,currentPageId) ;
                    wrapperIns.signed = completedRecipient(wrapperIns.name,currentPageId);
                    if(wrapperIns.unsigned == 0 && wrapperIns.signed == 0)
                    {
                        j = 1;
                    } 
                    if(wrapperIns.signed == 0){
                        k = 1;
                    }
                    if(wrapperIns.unsigned >= wrapperIns.signed)
                    {
                        k = 1;
                    }
                    if(wrapperIns.unsigned <  wrapperIns.signed)
                    {
                        l = 1;
                    }
                    string formstatus = checkEnvelopSent(wrapperIns.name,currentPageId);
                    if(formstatus == 'Not Sent'){
                        wrapperIns.forms = 'Send';
                    }
                    else{
                        wrapperIns.forms = 'View';
                    }
                    fileDupset.add(dbMinor.Name__c+' '+dbMinor.Email__c);
                    wishGrantingWrapperList.add(wrapperIns);
                }
                
            }
        }
       
        if(j == 0 && k ==0 && l == 1){
            formStatus = 'Completed';
        }
        if( k == 1 || j == 1){
            formStatus = 'Pending';
        }
        
       updateFormTrackerStatus(formStatus,currentPageId); 
    } 
    
    public void updateFormTrackerStatus(string status,Id parentCaseId){
        Constant_AC  constant = new Constant_Ac(); 
        String wishPlanningRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishPlanningAnticipationRT).getRecordTypeId();
        List<Case> dbPlaningCaseList = new List<Case>();
       
        for(Case dbPlaningCase : [SELECT Id,ParentId,Form_Tracker_Status__c,RecordTypeId FROM Case WHERE ParentId =:parentCaseId AND RecordTypeId =: wishPlanningRecordTypeId]){
        if(dbPlaningCase.Form_Tracker_Status__c != status){
            dbPlaningCase.Form_Tracker_Status__c = status;
            dbPlaningCaseList.add(dbPlaningCase);
        }
        }
        if(dbPlaningCaseList.size() > 0){
            update dbPlaningCaseList;
        }
    } 
   
    public integer completedRecipient(string recipientName,Id currentPageId){
        Constant_AC cons = new Constant_AC();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        List<String> completedFormList = new List<String>();
        string wishClearencesubject = 'Signature Required – Make-A-Wish Wish Clearance Form';
        string wishClearencechildsubject = 'Signature Required – Make-A-Wish Wish Clearance, Child'+'\'s'+' '+ 'Medical Summary:';
        string childMedicalsubject = 'Signature Required – Make-A-Wish Child'+'\'s'+' '+'Medical Summary Form:';
        string wishClearenceNoTraval = 'Signature Required – Make-A-Wish Wish Clearance No Travel Form';
        for(dsfs__DocuSign_Status__c dbdocStatusRec : [SELECT Id,Name,dsfs__Case__c,dsfs__Envelope_Status__c,Recipient_names__c,dsfs__Subject__c,dsfs__Sent_Date_Time__c,dsfs__Completed_Date_Time__c FROM dsfs__DocuSign_Status__c  WHERE Recipient_names__c =: recipientName AND Recipient_names__c != Null AND dsfs__Case__c =: currentPageId ]){
            
            if(dbdocStatusRec.dsfs__Envelope_Status__c == 'Completed' && dbdocStatusRec.dsfs__Completed_Date_Time__c != Null && 
            (dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Wish Form & Liability And Publicity Release Form' || dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Liability And Publicity Release Form' ||
             dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Absent Parent Form' || dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Single Parent Form' 
             || dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Combo Family Form & Liability/Publicity Release Form')){
                
                completedFormList.add(dbdocStatusRec.Name);
            }
        }
        
        for(Minor_Participant__c dbMinorRec : [SELECT Id,AttachmentId__c,Name__c,Case__c,Email__c,RecordTypeId 
                                               FROM Minor_Participant__c  WHERE AttachmentId__c != Null AND Name__c =: recipientName AND 
                                               Case__c =: currentPageId AND RecordTypeId =: formTrackerAttachMentRecordTypeId]){
                                                   completedFormList.add(dbMinorRec.AttachmentId__c);
                                               } 
        
        return completedFormList.size();
    }
    
    /**
* [inCompletedRecipient description]
* @param  recipientName [description]
* @param  currentPageId [description]
* @return               [description]
*/
    public integer inCompletedRecipient(string recipientName,Id currentPageId){
        Constant_AC cons = new Constant_AC();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        List<String> inCompletedFormList = new List<String>();
        Set<String> fileNameSet = new Set<String>();
        
        string wishClearencesubject = 'Signature Required – Make-A-Wish Wish Clearance Form';
        string wishClearencechildsubject = 'Signature Required – Make-A-Wish Wish Clearance, Child'+'\'s'+' '+ 'Medical Summary:';
        string childMedicalsubject = 'Signature Required – Make-A-Wish Child'+'\'s'+' '+'Medical Summary Form:';
        string wishClearenceNoTraval = 'Signature Required – Make-A-Wish Wish Clearance No Travel Form';
        
        for(dsfs__DocuSign_Status__c dbdocStatusRec : [SELECT Id,Name,dsfs__Case__c,dsfs__Envelope_Status__c,Recipient_names__c,dsfs__Subject__c,dsfs__Sent_Date_Time__c,dsfs__Completed_Date_Time__c FROM dsfs__DocuSign_Status__c  WHERE Recipient_names__c =: recipientName AND Recipient_names__c != Null AND dsfs__Case__c =: currentPageId ]){
            
            if(dbdocStatusRec.dsfs__Envelope_Status__c != 'Completed' && dbdocStatusRec.dsfs__Envelope_Status__c != 'Voided' && 
              (dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Wish Form & Liability And Publicity Release Form' || dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Liability And Publicity Release Form' ||
               dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Absent Parent Form' || dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Single Parent Form' 
               || dbdocStatusRec.dsfs__Subject__c == 'Signature Required - Combo Family Form & Liability/Publicity Release Form')){
               
                inCompletedFormList .add(dbdocStatusRec.Name);
            }
        }
        for(Minor_Participant__c dbMinorRec : [SELECT Id,AttachmentId__c,Name__c,Case__c,Email__c,hiddenFormat__c,selectedFormat__c,RecordTypeId 
                                               FROM Minor_Participant__c  WHERE  Name__c =: recipientName AND Case__c =: currentPageId 
                                               AND RecordTypeId =: formTrackerAttachMentRecordTypeId]){
                                                   
                                                   if(dbMinorRec.AttachmentId__c == Null && dbMinorRec.selectedFormat__c == 'Paper'){
                                                       inCompletedFormList.add(dbMinorRec.Id);    
                                                   }
                                                   
                                               }
        return inCompletedFormList.size();
    }
    
    /**
* [checkEnvelopSent description]
* @param  recipientName [description]
* @param  currentPageId [description]
* @return               [description]
*/
    
    public string checkEnvelopSent(string recipientName,Id currentPageId){
        Constant_AC cons = new Constant_AC();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        String subject = '';
        system.debug('@@ recipientName @@'+recipientName);
        for(dsfs__DocuSign_Status__c dbdocStatusRec : [SELECT Id,Name,dsfs__Case__c,dsfs__Envelope_Status__c,Recipient_names__c,dsfs__Subject__c,dsfs__Sent_Date_Time__c,dsfs__Completed_Date_Time__c FROM dsfs__DocuSign_Status__c  WHERE dsfs__Case__c =: currentPageId ]){
            system.debug('@@ dbdocStatusRec.Recipient_names__c@@'+dbdocStatusRec.Recipient_names__c);
            if(dbdocStatusRec.Id != Null && dbdocStatusRec.Recipient_names__c == recipientName && dbdocStatusRec.dsfs__Envelope_Status__c != 'Voided'){
                subject = dbdocStatusRec.dsfs__Subject__c;
            }
        
        }
        for(Minor_Participant__c dbMinorRec : [SELECT Id,AttachmentId__c,Name__c,Case__c,Email__c, selectedFormat__c,RecordTypeId
                                               FROM Minor_Participant__c  WHERE Name__c =: recipientName AND Case__c =: currentPageId 
                                               AND RecordTypeId =: formTrackerAttachMentRecordTypeId]){
                                                   if(dbMinorRec.selectedFormat__c != 'E-Signature')  
                                                       subject = dbMinorRec.AttachmentId__c;
                                               } 
        
        if(subject == ''){
            subject = 'Not Sent';
        }
        return subject;
    }
    
    /**
* [sendEnvelopId description]
* @param  envId [description]
* @return       [description]
*/
    
    @AuraEnabled
    public static String sendEnvelopId(String envId,string emailId){
        //displaypopup = false;
        //String envId = ApexPages.currentPage().getParameters().get('envelopId');
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipient = [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,
                                                                dsfs__Parent_Status_Record__c,dsfs__Parent_Status_Record__r.Form_Name__c,
                                                                dsfs__Recipient_Status__c FROM dsfs__DocuSign_Recipient_Status__c
                                                                WHERE dsfs__Envelope_Id__c =: envId Limit 1];
        if(!Test.isRunningTest()){
        boolean ischanged;
        if(emailId != dbRecipient[0].dsfs__DocuSign_Recipient_Email__c)
        ischanged = true;
        else
        ischanged = false;
        ResendEnvelopController resendEnv = new ResendEnvelopController();
        resendEnv.resendEnvelop(envId,dbRecipient[0].Name,emailId,ischanged);
        }
        return 'success';
    }
    
          
    @AuraEnabled
    public static String deleteStatusRec(String docuEnve, String participantRecId){
        Constant_AC cons = new Constant_AC();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        string formName;
        string name;
        if(docuEnve != null || docuEnve != Null){           
            List<dsfs__DocuSign_Status__c> dbStatusRecList = [SELECT Id,dsfs__DocuSign_Envelope_ID__c,dsfs__Envelope_Status__c,
                                                              dsfs__Case__r.Hidden_Chapter_Name__c,dsfs__Completed_Date_Time__c,Recipient_names__c,Form_Name__c 
                                                              FROM dsfs__DocuSign_Status__c WHERE dsfs__DocuSign_Envelope_ID__c =: docuEnve LIMIT 1];
            If(dbStatusRecList.Size() > 0){
                If((!Test.isRunningTest()) && dbStatusRecList[0].dsfs__Completed_Date_Time__c == Null){
                    formName = dbStatusRecList[0].Form_Name__c;
                    name = dbStatusRecList[0].Recipient_names__c;
                    ResendEnvelopController resendEnv = new ResendEnvelopController();
                    resendEnv.updateDocusingStatus(docuEnve,dbStatusRecList[0].dsfs__Case__r.Hidden_Chapter_Name__c);
                }                                                      
                
                /******************* WVC-2156 ***************/
                
                If(dbStatusRecList[0].dsfs__Completed_Date_Time__c != Null){
                    formName = dbStatusRecList[0].Form_Name__c;
                    name = dbStatusRecList[0].Recipient_names__c;
                    dsfs__DocuSign_Status__c  dsfsIns = new dsfs__DocuSign_Status__c();
                    dsfsIns.Id = dbStatusRecList[0].Id;
                    dsfsIns.dsfs__Envelope_Status__c = 'Voided';
                    update dsfsIns;
                }
            }           
        }
        
        if((formName != Null || formName != '') && (name != Null || name != '' )){
            List<Minor_Participant__c> dbMionrParticipantList = [SELECT Id,Name,RecordTypeId,Form_Name__c,Name__c,SelectedFormat__c FROM Minor_Participant__c WHERE
                                                                 Form_Name__c =: formName AND Name__c =: name AND RecordTypeId =: formTrackerAttachMentRecordTypeId];  
            if(dbMionrParticipantList.size() > 0)
                delete dbMionrParticipantList;
        }
        
        if( participantRecId != Null || participantRecId != '' && participantRecId != Null){
            List<Minor_Participant__c> dbMionrParticipantList = [SELECT Id,Name,RecordTypeId FROM Minor_Participant__c WHERE
                                                                 Id =: participantRecId AND RecordTypeId =: formTrackerAttachMentRecordTypeId];  
            if(dbMionrParticipantList.size() > 0)
                delete dbMionrParticipantList;
        }
        
        return 'success';
    }
    
    /**
* [displayErrorMessage description]
* @return [description]
*/        
   
    
    /**
* WishGrantingWrapper
*/
    
    public class WishGrantingWrapper{
        public string name{get;set;}
        public string relationship{get;set;}
        public integer signed{get;set;}
        public integer unsigned{get;set;}
        public string forms{get;set;}
        
    }
    
    /**
* WishGrantingSubTabWrapper
*/
    
    public class WishGrantingSubTabWrapper{
        public string formName{get;set;}
        public string onBehalfOf{get;set;}
        public Date sent{get;set;}
        public Date formSigned{get;set;}
        public String format{get;set;}
        public String formAttachMentId{get;set;}
        public String docuEnvelopId{get;set;}
        public string recipientemail{get;set;}
        public string recipentName{get;set;}
        public Id recordId{get;set;}
        //public string forms{get;set;}
    }  
    
    /**
* [getWishFamilyList description]
* @param  currentPageId [description]
* @return               [description]
*/
    
    @AuraEnabled
    public static String getWishFamilyList(Id currentPageId){
        WishFormDashboard_AC returnwrapperClass = new WishFormDashboard_AC(currentPageId); 
        System.debug('Return Wrapper Class = ' + returnwrapperClass);
        String s = JSON.serialize(returnwrapperClass,true);
        return s;
    }
    
    /**
* [sendWishFamilyEnvelope description]
* @param  config [description]
* @return        [description]
*/
    
    @AuraEnabled
    public static String sendWishFamilyEnvelope(String config){
        Constant_AC cons = new Constant_AC();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        Id comborec= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.comboRecord).getRecordTypeId();
        List<Wish_Child_Form__c> updateWishChildFormList = new List<Wish_Child_Form__c>();
        ResendEnvelopController resendEnv = new ResendEnvelopController();
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(config);
        String Name  =  (String) meta.get('Name');
        String email = (String)  meta.get('email');
        String selectedForm = (String) meta.get('selectedForm');
        String guardian = (String) meta.get('guardian');
        String miniorParticipantName = (String) meta.get('miniorParticipantName');
        Id currentPageId = (Id) meta.get('currentPageId');
        Id WishChildContactId = (Id) meta.get('WishChildContactId');
        integer n = 0;
        integer m = 0;
        String selectedFormat = (String) meta.get('selectedFormat');
        Boolean isEmail = (selectedFormat == 'E-Signature') ? true : false;
        String documentTitle = (String) meta.get('documentTitle');

        if (guardian != null && guardian != '' && miniorParticipantName.contains('Self')) {
            miniorParticipantName = miniorParticipantName.remove('Self');
            miniorParticipantName = guardian + ';' + miniorParticipantName;
        }
        
        Map<String, String> formParams = new Map<String, String>{
            'Name' => Name,
                'email' => email,
                'selectedForm' => selectedForm,
                'guardian' =>  guardian,
                'miniorParticipantName' => miniorParticipantName,
                'currentPageId' => currentPageId,
                'WishChildContactId' => WishChildContactId
                };
                    
        List<Minor_Participant__c> createComboRecList = new List<Minor_Participant__c>();
        Constant_AC  constant = new Constant_AC();  
        Id familyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormFamily).getRecordTypeId();
        Id  wichChildRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChild).getRecordTypeId();
        for(Wish_Child_Form__c dbParticipant : [SELECT Id,FirstName__c,Email__c,LastName__c,IsParticipant__c,Case__c,Emergency_Relationship__c,
                                                RecordTypeId,Self__c,Middle_Name__c,BirthDate__c,Age__c,Home_Phone__c,TelePhone__c,
                                                mobilePhone__c,Street__c,City__c,State__c,Zip_Code__c,Contact__c,Migrated__c FROM Wish_Child_Form__c 
                                                WHERE Case__c =:currentPageId AND (RecordTypeId =: familyContactRecordTypeId OR RecordTypeId =: wichChildRecordTypeId)  AND Migrated__c = False]){
                                                    
                                                    string participantName = dbParticipant.FirstName__c+' '+dbParticipant.LastName__c;
                                                    
                                                    if(participantName == guardian && selectedForm == 'Combo Family Form & Liability/Publicity Release Form' && dbParticipant.IsParticipant__c == false){
                                                        
                                                        Minor_Participant__c createcomboRec = new Minor_Participant__c();
                                                        
                                                        createcomboRec.Hidden_Combo_FirstName__c = dbParticipant.FirstName__c;
                                                        createcomboRec.Hidden_Combo_MiddleName__c = dbParticipant.Middle_Name__c;
                                                        createcomboRec.Hidden_Combo_LastName__c = dbParticipant.LastName__c;
                                                        createcomboRec.Hidden_Combo_Relationship__c = dbParticipant.Emergency_Relationship__c;
                                                        createcomboRec.Hidden_Combo_DOB__c = dbParticipant.BirthDate__c;
                                                        createcomboRec.Hidden_Combo_Street__c = dbParticipant.Street__c;
                                                        createcomboRec.Hidden_Combo_City__c = dbParticipant.City__c;
                                                        createcomboRec.Hidden_Combo_State__c = dbParticipant.State__c;
                                                        createcomboRec.Hidden_Combo_HomePhone__c = dbParticipant.Home_Phone__c;
                                                        createcomboRec.Hidden_Combo_MobilePhone__c = dbParticipant.mobilePhone__c;
                                                        createcomboRec.Hidden_Combo_TelePhone__c = dbParticipant.TelePhone__c;
                                                        createcomboRec.Hidden_Combo_Email__c = dbParticipant.Email__c;
                                                        createcomboRec.Hidden_Combo_ContactId__c = dbParticipant.Contact__c; 
                                                        createcomboRec.Hidden_Combo_Zipcode__c = dbParticipant.Zip_Code__c;
                                                        createcomboRec.RecordTypeId = comborec;
                                                        createcomboRec.Case__c = dbParticipant.Case__c;
                                                        
                                                        
                                                        for(string selectedParticipant : miniorParticipantName.split(';')){
                                                            if(createcomboRec.Hidden_Combo_Participant__c == Null){
                                                            createcomboRec.Hidden_Combo_Participant__c = selectedParticipant;
                                                            }
                                                            else{
                                                                createcomboRec.Hidden_Combo_Participant__c = createcomboRec.Hidden_Combo_Participant__c+','+' '+selectedParticipant;
                                                            }
                                                            
                                                        }
                                                        createComboRecList.add(createcomboRec);
                                                        /*if(miniorParticipantName.contains('Self')){
                                                            dbParticipant.Self__c = true;
                                                            updateWishChildFormList.add(dbParticipant);
                                                        }*/
                                                    }
                                                    else if(participantName == guardian && selectedForm == 'Combo Family Form & Liability/Publicity Release Form' && dbParticipant.IsParticipant__c == true){
                                                        return 'failure-participant';
                                                    }
                                                }
        
        if(createComboRecList .size() > 0){
            insert createComboRecList ;
         }
        
        Map<String,String> emailMap = new Map<String,String>();
        List<Minor_Participant__c> minorParticipantList = new List<Minor_Participant__c>();
        
        if(guardian != 'Not listed' && n == 0 && isEmail) {
            emailMap.put(guardian,email);
            formParams.put(guardian,email);
            if(selectedForm == 'Wish Form & Liability Form'){
                m = 1;
                n = 1;
                if(!Test.isRunningTest()){
                WishChildForm_AC.callouttoDocusing(emailMap,currentPageId,WishChildContactId,miniorParticipantName,selectedForm,guardian);
                }              
            }
            if(selectedForm == 'Liability Form'){
                m = 1;
                n = 1;
                if(!Test.isRunningTest()){
                    WishLiabilityForm_AC.callOuttoDocusign(emailMap,currentPageId,'Three',miniorParticipantName,guardian);

                }
            }
            if(selectedForm == 'Combo Family Form & Liability/Publicity Release Form'){
                m = 1;
                n = 1;
                formParams.put('pageLabel','combo');
                formParams.put('subject','Signature Required - Combo Family Form & Liability/Publicity Release Form');
                if(!Test.isRunningTest()){
                ResendEnvelopController.comboFormSendEnvelop(formParams,createComboRecList[0].id);
                }
            } 
            if(selectedForm == 'Absent Parent Form'){
                m = 1;
                n = 1;
                formParams.put('pageLabel','absent');
                formParams.put('subject','Signature Required - Absent Parent Form');
                if(!Test.isRunningTest()){
                ResendEnvelopController.singleAbsentParentDocusign(formParams);
                }
            }
            if(selectedForm == 'Single Parent Form'){
                m = 1;
                n = 1;
                formParams.put('pageLabel','single');
                formParams.put('subject','Signature Required - Single Parent Form');
                 if(!Test.isRunningTest()){
                ResendEnvelopController.singleAbsentParentDocusign(formParams);
                }
            }
        }
        
        if((guardian == 'Not listed') || (guardian != 'Not listed' && selectedFormat == 'Paper')){
            List<Minor_Participant__c> dbMinorParticipantList = [SELECT Id,Name__c,Associated_Childeren__c,Case__c,Form_Name__c,Email__c,
                                                                 RecordTypeId FROM Minor_Participant__c  WHERE Case__c =: currentPageId AND
                                                                 RecordTypeId =: formTrackerAttachMentRecordTypeId];
            String minorPartname = miniorParticipantName;
            string name1 = minorPartname.removeStart('[');
            string AssosiatedChilderen= name1.removeEnd(']');
            
            if(dbMinorParticipantList.size() == 0){
                Minor_Participant__c newMinorRec = new Minor_Participant__c();
                newMinorRec.Name__c = Name;
                newMinorRec.Associated_Childeren__c = AssosiatedChilderen;
                newMinorRec.Case__c = currentPageId;
                newMinorRec.Email__c = email;
                newMinorRec.Guardian_Name__c = guardian;
                newMinorRec.RecordTypeId = formTrackerAttachMentRecordTypeId;
                newMinorRec.Form_Name__c = selectedForm; 
                if(selectedFormat == 'paper') {
                    newMinorRec.SelectedFormat__c = selectedFormat;
                    newMinorRec.hiddenFormat__c = (guardian != 'Not listed' && selectedFormat == 'Paper') ? true : false;
                    newMinorRec.Attachment_Title__c = documentTitle;
                   
                }
                newMinorRec.SelectedFormat__c = selectedFormat;
                minorParticipantList.add(newMinorRec);
                
            }
            if(dbMinorParticipantList.size() > 0){
                Minor_Participant__c newMinorRec = new Minor_Participant__c();
                newMinorRec.Name__c = Name;
                newMinorRec.Associated_Childeren__c = AssosiatedChilderen;
                newMinorRec.Case__c = currentPageId;
                newMinorRec.Email__c = email;
                newMinorRec.RecordTypeId = formTrackerAttachMentRecordTypeId;
                newMinorRec.Guardian_Name__c = guardian;
                
                newMinorRec.Form_Name__c = selectedForm;
                if(selectedFormat == 'paper') {
                    newMinorRec.SelectedFormat__c = selectedFormat;
                    newMinorRec.hiddenFormat__c = (guardian != 'Not listed' && selectedFormat == 'Paper') ? true : false;
                    newMinorRec.Attachment_Title__c = documentTitle;
                    
                }
                newMinorRec.SelectedFormat__c = selectedFormat;
                minorParticipantList.add(newMinorRec); 
                
            }
            if(minorParticipantList.size() > 0){
                insert minorParticipantList;
                emailMap.put(minorParticipantList[0].Name__c ,minorParticipantList[0].Email__c );
                formParams.put(guardian,email);
                
                System.debug('Email = ' + isEmail);
                
                if(isEmail){
                    if(selectedForm == 'Wish Form & Liability Form'){
                        m = 1;
                        n = 1;
                         if(!Test.isRunningTest()){
                         WishChildForm_AC.callouttoDocusing(emailMap,currentPageId,WishChildContactId,miniorParticipantName,selectedForm,guardian);
                        }
                    }
                    if(selectedForm == 'Combo Family Form & Liability/Publicity Release Form'){
                        m = 1;
                        n = 1;
                       formParams.put('pageLabel','combo');
                       formParams.put('subject','Signature Required - Combo Family Form & Liability/Publicity Release Form');
                       if(!Test.isRunningTest()){
                       ResendEnvelopController.comboFormSendEnvelop(formParams,minorParticipantList[0].Id);
                       }
                    }
                    if(selectedForm == 'Liability Form'){
                        m = 1;
                        n = 1;
                        if(!Test.isRunningTest()){
                        WishLiabilityForm_AC.callOuttoDocusign(emailMap,currentPageId,'Three',miniorParticipantName,guardian);
                        }
                    }  
                    if(selectedForm == 'Absent Parent Form'){
                        m = 1;
                        n = 1;
                        formParams.put('pageLabel','absent');
                        formParams.put('subject','Signature Required - Absent Parent Form');
                        if(!Test.isRunningTest()){
                        ResendEnvelopController.singleAbsentParentDocusign(formParams);
                        }
                        
                    }
                    if(selectedForm == 'Single Parent Form'){
                        m = 1;
                        n = 1;
                        formParams.put('pageLabel','single');
                        formParams.put('subject','Signature Required - Single Parent Form');
                        if(!Test.isRunningTest()){
                        ResendEnvelopController.singleAbsentParentDocusign(formParams);
                        }
                    }
                }
            }   
        }
        return 'success';
    }
    
    /**
* [displayFormStatusPopup description]
* @param  rename        [description]
* @param  currentPageId [description]
* @return               [description]
*/
    
    @AuraEnabled
    public static String displayFormStatusPopup(String rename, Id currentPageId){
        Constant_AC cons = new Constant_AC();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        String returnString = '';
        String receipantName = rename;
        List<WishGrantingSubTabWrapper> wishGrantingSubTabWrapperList = new List<WishGrantingSubTabWrapper>();
        Set<String> MinorParticipantfileNameSet = new Set<String>();
        for(dsfs__DocuSign_Recipient_Status__c dbdocStatusRec : [SELECT Id,Name,CreatedDate,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__r.dsfs__Case__c, 
                                                                 dsfs__Parent_Status_Record__r.dsfs__Subject__c,dsfs__Parent_Status_Record__r.AttachmentId__c,dsfs__Date_Signed__c,dsfs__Date_Sent__c,dsfs__Date_Delivered__c,dsfs__Parent_Status_Record__r.Associated_Childeren__c,SystemModstamp FROM dsfs__DocuSign_Recipient_Status__c WHERE Name =: receipantName   
                                                                 AND dsfs__Parent_Status_Record__r.dsfs__Case__c =: currentPageId AND dsfs__Parent_Status_Record__r.dsfs__Envelope_Status__c != 'Voided' ORDER BY SystemModstamp DESC]){
                                                                     
                                                                     if(dbdocStatusRec .dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Wish Form & Liability And Publicity Release Form' || 
                                                                        dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Liability And Publicity Release Form' ||
                                                                        dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Absent Parent Form' ||
                                                                        dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Single Parent Form' || 
                                                                        dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Combo Family Form & Liability/Publicity Release Form'
                                                                       ){
                                                                           //i = 1;
                                                                           if(dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Wish Form & Liability And Publicity Release Form')
                                                                               dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  =  'Wish Form & Liability And Publicity Release Form';
                                                                           if(dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Liability And Publicity Release Form')
                                                                               dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  =  'Liability And Publicity Release Form';
                                                                           if(dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Absent Parent Form')
                                                                               dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  =  'Absent Parent Form';
                                                                           if(dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Single Parent Form')
                                                                               dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  =  'Single Parent Form';
                                                                           if(dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  == 'Signature Required - Combo Family Form & Liability/Publicity Release Form')
                                                                               dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c  =  'Combo Family Form & Liability/Publicity Release Form';
                                                                           
                                                                           WishGrantingSubTabWrapper wishGrantsubIns = new WishGrantingSubTabWrapper();
                                                                           wishGrantsubIns.formName =  dbdocStatusRec.dsfs__Parent_Status_Record__r.dsfs__Subject__c;
                                                                           wishGrantsubIns.onBehalfOf = dbdocStatusRec.dsfs__Parent_Status_Record__r.Associated_Childeren__c;
                                                                           wishGrantsubIns.sent = Date.valueof(dbdocStatusRec.dsfs__Date_Sent__c);
                                                                           wishGrantsubIns.formSigned = Date.valueof(dbdocStatusRec.dsfs__Date_Signed__c);
                                                                           wishGrantsubIns.recipentName = dbdocStatusRec.Name;
                                                                           wishGrantsubIns.recipientemail = dbdocStatusRec.dsfs__DocuSign_Recipient_Email__c;
                                                                           if(dbdocStatusRec.dsfs__DocuSign_Recipient_Email__c == 'notsent@noemail.com'){
                                                                               wishGrantsubIns.format = 'In Person';
                                                                           }
                                                                           if(dbdocStatusRec.dsfs__DocuSign_Recipient_Email__c != 'notsent@noemail.com'){
                                                                               wishGrantsubIns.format = 'E-Signature';
                                                                           }
                                                                           wishGrantsubIns.docuEnvelopId = dbdocStatusRec.dsfs__Envelope_Id__c;
                                                                           wishGrantsubIns.formAttachMentId = dbdocStatusRec.dsfs__Parent_Status_Record__r.AttachmentId__c;
                                                                           System.debug('wishGrantsubIns = ' + wishGrantsubIns);
                                                                           wishGrantingSubTabWrapperList.add(wishGrantsubIns);
                                                                           //i++;
                                                                       }
                                                                 }
        
      //  System.debug('Query = ' + [SELECT Id,CreatedDate,AttachmentId__c,Name__c,Case__c,Email__c,File_Path__c,Associated_Childeren__c,Form_Name__c,SystemModstamp,Attachment_Title__c,hiddenFormat__c FROM Minor_Participant__c  WHERE Name__c =: receipantName AND Case__c =: currentPageId ORDER BY SystemModstamp DESC]);
        
        for(Minor_Participant__c dbMinorRec : [SELECT Id,CreatedDate,selectedFormat__c,SignedDate__c,AttachmentId__c,Name__c,Case__c,Email__c,
                                               File_Path__c,Associated_Childeren__c,Form_Name__c,SystemModstamp,Attachment_Title__c,
                                               hiddenFormat__c,RecordTypeId FROM Minor_Participant__c  WHERE Name__c =: receipantName AND RecordTypeId =: formTrackerAttachMentRecordTypeId 
                                               AND Case__c =: currentPageId ORDER BY SystemModstamp DESC]){
                                                   
                                                   
                                                   if(dbMinorRec.selectedFormat__c != 'E-Signature') {
                                                       
                                                       WishGrantingSubTabWrapper wishGrantsubInsd = new WishGrantingSubTabWrapper();
                                                       wishGrantsubInsd.recordId = dbMinorRec.Id;
                                                       wishGrantsubInsd.formName = (dbMinorRec.Attachment_Title__c == 'null' || dbMinorRec.Attachment_Title__c == null) ? dbMinorRec.Form_Name__c : dbMinorRec.Attachment_Title__c;
                                                       wishGrantsubInsd.onBehalfOf = dbMinorRec.Associated_Childeren__c;
                                                       wishGrantsubInsd.sent = Date.valueof(dbMinorRec.CreatedDate);
                                                       wishGrantsubInsd.formSigned = (dbMinorRec.SignedDate__c != Null) ? dbMinorRec.SignedDate__c : Null;
                                                       wishGrantsubInsd.recipientemail = dbMinorRec.Email__c;
                                                       wishGrantsubInsd.format = 'Paper';
                                                       wishGrantsubInsd.formAttachMentId = dbMinorRec.File_Path__c;
                                                       wishGrantingSubTabWrapperList.add(wishGrantsubInsd);    
                                                   }
                                                   
                                               } 
        
        returnString = JSON.serialize(wishGrantingSubTabWrapperList);
        return returnString;
        
        
    }   
    
    /**
* [signNowEnvelopStatus description]
* @param  envelopeId [description]
* @return            [description]
*/
    
    @AuraEnabled
    public static String signNowEnvelopStatus(String envelopeId){
        //pageReference reference;
        // displaypopup = false;
        String envId = envelopeId;
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipient = [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__r.dsfs__Case__c,dsfs__Parent_Status_Record__r.dsfs__Subject__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Envelope_Id__c =: envId Limit 1];
        
        ResendEnvelopController resendEnv = new ResendEnvelopController();
        string pageName;
        if(dbRecipient[0].dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Wish Form & Liability And Publicity Release Form'){
            
            pageName = 'WishFormWishGranting_VF';
            
        }
        if(dbRecipient[0].dsfs__Parent_Status_Record__r.dsfs__Subject__c == 'Signature Required - Liability And Publicity Release Form'){
            
            pageName = 'WishLiabilityWishGranting_VF' ;  
        }
        
        String s;
        if(!Test.isRunningTest()){
        Map<String, String> parameters = resendEnv.signNowEnvelop(envId,dbRecipient[0].Name,dbRecipient[0].dsfs__Parent_Status_Record__r.dsfs__Case__c,pageName).getParameters();
        s = parameters.get('t');
        }
        return s;
    }
    
    @AuraEnabled
    public static List<Minor_Participant__c> editWishChildInformation(Id participantId, Id currentPageId){
        Constant_AC cons = new Constant_AC();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        List<Minor_Participant__c> minorList; 
        if(participantId != null)
            minorList = [SELECT Id,CreatedDate,SelectedFormat__c,AttachmentId__c,RecordTypeId,Name__c,Case__c,Email__c,
                         File_Path__c,Associated_Childeren__c,Form_Name__c,SystemModstamp,Attachment_Title__c 
                         FROM Minor_Participant__c  WHERE Id =: participantId AND Case__c =: currentPageId AND RecordTypeId =:formTrackerAttachMentRecordTypeId];
        return minorList;
    }
    
    @AuraEnabled
    public static List<dsfs__DocuSign_Recipient_Status__c> editDocuSignInformation(String envelopId, Id currentPageId){
        List<dsfs__DocuSign_Recipient_Status__c> minorList; 
        minorList = [SELECT Id,Name,CreatedDate,dsfs__Parent_Status_Record__r.Associated_Childeren__c,dsfs__Parent_Status_Record__r.Form_Name__c,dsfs__Parent_Status_Record__r.AttachmentId__c,dsfs__Parent_Status_Record__r.dsfs__Subject__c,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Parent_Status_Record__r.dsfs__Case__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Envelope_Id__c =: envelopId  AND dsfs__Parent_Status_Record__r.dsfs__Case__c =: currentPageId];
        return minorList;
    }
    
    @AuraEnabled    
    public static String updateDocuSignInformation(String envelopId, Id currentPageId,String Name, String Email, String associatedChildren){
        List<dsfs__DocuSign_Recipient_Status__c> updateRecipientList = new List<dsfs__DocuSign_Recipient_Status__c>();
        List<dsfs__DocuSign_Status__c> updateStatusRec  = new List<dsfs__DocuSign_Status__c>();
        for(dsfs__DocuSign_Status__c dbStatusRec : [SELECT Id,Associated_Childeren__c,dsfs__DocuSign_Envelope_ID__c,(SELECT Id,Name FROM 
                                                                                                                     R00NS0000000WUO2MAO),Recipient_names__c FROM dsfs__DocuSign_Status__c WHERE 
                                                    dsfs__DocuSign_Envelope_ID__c =: envelopId AND
                                                    dsfs__Case__c =: currentPageId Limit 1]){
                                                        
                                                        for(dsfs__DocuSign_Recipient_Status__c dbRecipient : dbStatusRec.R00NS0000000WUO2MAO){
                                                            dbRecipient.Name = Name;
                                                            updateRecipientList.add(dbRecipient);
                                                        }
                                                        dbStatusRec.Recipient_names__c  = Name;
                                                        dbStatusRec.Associated_Childeren__c = associatedChildren;
                                                        updateStatusRec.add(dbStatusRec);
                                                    }
        if(updateRecipientList.size() > 0 && updateStatusRec.size() > 0){
            update updateRecipientList;
            update updateStatusRec;
            return 'success';
        }else
            return 'failure';
    }
    @AuraEnabled
    /*This method is used to update the participant informations for Paper format records in the form tracker sub table */
    public static String updateParticipantInformation(String config){
        Constant_AC cons = new Constant_AC();
        Id formTrackerAttachMentRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.formTrackerAttachment ).getRecordTypeId();
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(config);
        List<Minor_Participant__c> participantList = new List<Minor_Participant__c>();
        Minor_Participant__c newMinorRec = new Minor_Participant__c();
        newMinorRec.Name__c = (String) meta.get('Name');
        newMinorRec.Associated_Childeren__c = (String) meta.get('miniorParticipantName');
        newMinorRec.Case__c = (Id) meta.get('currentPageId');
        newMinorRec.Email__c = (String)  meta.get('email');
        newMinorRec.Guardian_Name__c = (String) meta.get('guardian');
        newMinorRec.Form_Name__c = (String) meta.get('selectedForm');
        newMinorRec.SelectedFormat__c = (String) meta.get('selectedFormat');
        newMinorRec.RecordTypeId = formTrackerAttachMentRecordTypeId;
        newMinorRec.Attachment_Title__c = (String) meta.get('documentTitle');
        newMinorRec.Id = (Id) meta.get('editParticipantId');
        if(newMinorRec.Guardian_Name__c == 'Not listed'){
            newMinorRec.hiddenFormat__c = false;
        }
        participantList.add(newMinorRec); 
        
        if(participantList.size() > 0){
            update participantList;
            return 'success';
        }else
            return 'failure';
    }
    
    
}