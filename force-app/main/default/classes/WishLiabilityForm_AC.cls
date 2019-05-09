/*****************************************************************************
Created by: Kanagaraj
Author : MST Solutions
CreateDate : 10/05/2016
Description : WishLiabilityForm_AC is used to send the WishLiability Form for Users to sign that liability form.
******************************************************************************/

public class WishLiabilityForm_AC
{
    public Id caseId;
    //public List<Case> currentCaseList{get;set;}
    public Case currentCase{get;set;}
    public Map<String,String> emailSignatureMap{get;set;}
    public List<string> contactEmailList{get;set;}
    public Map<String,String> signNowemailMap{get;set;}
    public Boolean displayPopup{get;set;}
    public List<SelectOption> multiPickoptions {get;set;}
    public String receipientName{get;set;}
    public Map<String,String> sendEmailMap {get;set;}
    public List<String> listofSenderName{get;set;}
    public Boolean isRedriect{get;set;}
    Public String Name{get;set;}
    PUBLIC String WishChildId{get;set;}
    Public List<String> typeString{get;set;}
    public List<String> receipent{get;set;}
    public Boolean displaySignNowPopup{get;set;}
    public Boolean displayReturnToWish{get;set;} 
    public String SingerName{get;set;}
    public Boolean isFirstParent {get;set;}
    public Boolean displayError{get;set;}
    public Boolean displayAlert{get;set;}
    public String documentPDF;
    public String envelopeId;
    public Map<String,String> signersKeyPairMap{get;set;}
    public List<String> SignNowList{get;set;}
    public Boolean isFirstParentSendEmail{get;set;}
    public Boolean SignNowdisplayError{get;set;}
    public String participantsName{get;set;}
    
    public Integer j = 0;
    public Integer k = 0;
    public boolean displaypopwindow{get;set;}
    public Map<String,String> participantEmailMap{get;set;}
    Public boolean showButton{get;set;}
    Public set<String> parentLegalSet{get;set;}
    public boolean displaymsgPop{get;set;}
    public boolean isEmpty{get;set;}
    public list<Wish_Child_Form__c> wishChildFormRecrodList {get;set;}
    public Integer currentAge {get;set;}
    public Map<String,String> multiNameEmailMap {get;set;}
    public WishLiabilityForm_AC(ApexPages.StandardController controller) {
        contactEmailList = new List<String>();
        signNowemailMap = new Map<String,String>();
        emailSignatureMap = new Map<String,String>();
        sendEmailMap = new Map<String,String>();
        participantEmailMap = new Map<String,String>();
        parentLegalSet = new Set<String>();
        listofSenderName = new List<String>();
        wishChildFormRecrodList = new list<Wish_Child_Form__c>();
        multiNameEmailMap = new Map<String,String>();
        currentAge = 0;
        caseId = Apexpages.currentPage().getParameters().get('Id');
        system.debug('@@@ caseId @@@'+caseId);
        if(Apexpages.currentPage().getParameters().get('option') == 'Three' || Apexpages.currentPage().getParameters().get('event') == 'signing_complete'){
            showButton = true;
        }
        typeString = new List<String>();
        receipent = new List<String>();
        
        
        envelopeId = '';
        signersKeyPairMap = new Map<String,String>();
        displaypopwindow = false;
        currentCase = [SELECT ID,ContactID,Contact.Name,Contact.Publicity_OK__c,LiabilitySignerMapKeyPair__c,Hidden_Email_List__c,Hidden_Name_List__c,ChapterName__c,ChapterName__r.Name  FROM Case WHERE ID =:caseId LIMIT 1];
        WishChildId = currentCase.ContactId; 
        for(Wish_Child_Form__c currentWishForm:[Select id,FirstName__c,LastName__c,recordType.Name,Email__c,BirthDate__c,Parent_Gurdian_above_18__c,IsParticipant__c,Migrated__c from Wish_Child_Form__c where (recordType.Name = 'Wish Form Family' or recordType.Name = 'Wish Child') AND Case__c =: caseId AND Migrated__c =: False ] ){
            if(currentWishForm.BirthDate__c != Null){
                currentAge = Integer.valueOf(currentWishForm.BirthDate__c.daysBetween(Date.today())/365);
            }
            
//            if(currentWishForm.recordType.Name == 'Wish Child' && currentWishForm.BirthDate__c != Null && currentAge >= 18){
//                wishChildFormRecrodList.add(currentWishForm);
//                participantsName = currentWishForm.FirstName__c +' ' + currentWishForm.LastName__c;
//            }else if(currentWishForm.recordType.Name == 'Wish Form Family' && currentWishForm.IsParticipant__c == False){
//                wishChildFormRecrodList.add(currentWishForm);
//                if(participantsName != Null || participantsName != ''){
//                    participantsName = participantsName + ', ' +currentWishForm.FirstName__c +' ' + currentWishForm.LastName__c;
//                }
//                else{
//                    participantsName = currentWishForm.FirstName__c +' ' + currentWishForm.LastName__c;
//                }
//            }else if(currentWishForm.recordType.Name == 'Wish Form Family' && currentWishForm.IsParticipant__c == True && currentWishForm.BirthDate__c != Null && currentAge >= 18){
//                wishChildFormRecrodList.add(currentWishForm);
//                if(participantsName != Null || participantsName != ''){
//                    participantsName = participantsName + ', ' +currentWishForm.FirstName__c +' ' + currentWishForm.LastName__c;
//                }
//                else{
//                    participantsName = currentWishForm.FirstName__c +' ' + currentWishForm.LastName__c;
//                }
//            }

        }

//        System.debug('particpantsName 1: ' + participantsName);
//        if (participantsName != null || participantsName != '') {
//            participantsName = participantsName + Apexpages.currentPage().getParameters().get('name');
//        }
//        else {
//            participantsName = Apexpages.currentPage().getParameters().get('name');
//        }
//        System.debug('particpantsName: ' + participantsName);

        participantsName = Apexpages.currentPage().getParameters().get('name');

        if(participantsName != Null && participantsName != ''){
            participantsName = participantsName.replace(';', ', ');
            participantsName = participantsName.removeEndIgnoreCase(', ');

            if(participantsName.startsWith(',')){
                participantsName = participantsName.removeStart(',');
            }

            if(participantsName.startsWith('null')){
                participantsName = participantsName.removeStartIgnoreCase('null,');
            }
        }
        if(wishChildFormRecrodList.size() > 0){
            system.debug('-----> wishChildFormRecrodList'+ wishChildFormRecrodList);
            displayAlert = true;
        }
    }
    
    /*This method will take you back to the Case page */
    public pageReference cancel(){
        displayAlert = false;
        PageReference reference=new PageReference('/'+currentCase.Id);
        reference.setRedirect(true);     
        return reference;
    }
    
    /*This method will take you back to Liabilityform*/
    public pageReference returnToLiabilityForm(){
        isRedriect = false;
        string currPage = Apexpages.currentPage().getParameters().get('option'); 
        PageReference reference = new PageReference('/apex/WishLiabilityForm_VF?id='+currentCase.Id+'&option='+currPage);
        reference.setRedirect(true);     
        return reference;
    }
    
    /*This method will return back to wish*/
    public void returnToWish(){
        displayReturnToWish = true;
    }
    
    /*This method is used to fetch the multiple email address to send the liability form.*/
    public pageReference multiEmail(){
        for(Wish_Child_Form__c getNameEmailMap :wishChildFormRecrodList){
            multiNameEmailMap.put(getNameEmailMap.FirstName__c+ ' '+ getNameEmailMap.LastName__c, getNameEmailMap.Email__c);
            
        }
        if((Apexpages.currentPage().getParameters().get('option') == 'Three') || (Apexpages.currentPage().getParameters().get('event') == 'signing_complete')){
            if(multiNameEmailMap.size() > 0 ){
                displayPopup = true;
                multiPickoptions = new List<SelectOption>();
                for(String currString : multiNameEmailMap.keySet()){
                    if(currString != Null){
                        multiPickoptions.add(new SelectOption(currString.trim(),currString.trim()));
                    }
                }
            }
            else{
                
                displayError = true;
                
            }
        }
        else{
            if(multiNameEmailMap.size()> 0 ){
                displayPopup = true;
                multiPickoptions = new List<SelectOption>();
                for(String currString : multiNameEmailMap.keySet()){
                    if(currString != Null){
                        multiPickoptions.add(new SelectOption(currString.trim(),currString.trim()));
                    }
                }
            }
            else{
                displaymsgPop = true;
            }
        }
        return null;
    }
    
    public pagereference sendpdftoEmail (){
        displayPopup = false;
        String queryName = '';
        String querySignature = '' ;
        isEmpty = false;
        Set<String> senderNameSet = new Set<String>();
        
        senderNameSet.add(receipientName);
        
        for(String currString : multiNameEmailMap.keySet()){
            if(senderNameset.Contains(currString)){
                if((!(String.isEmpty(multiNameEmailMap.get(currString)) || String.isBlank(multiNameEmailMap.get(currString)))) && currString != Null){
                    sendEmailMap.put(currString.trim(),multiNameEmailMap.get(currString).trim());
                }
                else if(currString != Null && (String.isEmpty(multiNameEmailMap.get(currString)) || String.isBlank(multiNameEmailMap.get(currString)))){
                    isEmpty = true;
                }
            }
        }
        
        
        
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipient = [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__r.dsfs__Case__c, 
                                                                dsfs__Parent_Status_Record__r.dsfs__Subject__c FROM dsfs__DocuSign_Recipient_Status__c WHERE Name =: sendEmailMap.keyset() AND dsfs__DocuSign_Recipient_Email__c =: sendEmailMap.values() 
                                                                AND dsfs__Parent_Status_Record__r.dsfs__Case__c =: caseId AND dsfs__Recipient_Status__c != 'Completed' AND dsfs__Parent_Status_Record__r.dsfs__Subject__c =: 'Signature Required - Liability And Publicity Release Form' Limit 1];
        
        if(dbRecipient.size() > 0){
            boolean ischanged = false;
            ResendEnvelopController resendEnv = new ResendEnvelopController();
            resendEnv.resendEnvelop(dbRecipient[0].dsfs__Envelope_Id__c,dbRecipient[0].Name,dbRecipient[0].dsfs__DocuSign_Recipient_Email__c,ischanged);
        }
        else{
            callOuttoDocusign(sendEmailMap,caseId,Apexpages.currentPage().getParameters().get('option'),currentCase.contact.Name, '');
            isRedriect = true;
        }
        return null;
    }
    
    @future(Callout = true)   
    public Static void callOuttoDocusign(Map<String,String> emailMap,String caseId,String currentParam,String wishChildName, String guardianName){
        
        
        boolean isParent;
        List<Contact> contactList = new List<Contact>(); 
        Wish_Child_Form__c  childFormInstance;
        Map<String,npe4__Relationship__c> recipientMap = new Map<String,npe4__Relationship__c>();
        Set<String> parentGardienSet = new Set<String>();
        childFormInstance = [SELECT Id,Parent_Gurdian_above_18__c,Parent_Gurdian_above_18_Email__c,Case__c, Case__r.Contact.Name,Case__r.Contact.FirstName, Participant_Name__c,Migrated__c FROM Wish_Child_Form__c WHERE Case__c =: caseId AND Migrated__c = False LIMIT 1];
        Pagereference PDF;
        if(currentParam == 'One')
            PDF = Page.WishLiabilityOption1_VF;
        else if(currentParam == 'Two')
            PDF = Page.WishLiabilityOption2_VF;
        else
            PDF = Page.WishLiabilitySendPDF;
        String documentPDF;
        PDF.setRedirect(false);
        PDF.getParameters().put('Id',caseId);
        System.debug('wishChildName: ' + wishChildName);
        String names = wishChildName;
        if (guardianName != null && guardianName != '' && wishChildName.contains('Self')) {
            System.debug('removing self');
            wishChildName = wishChildName.remove('Self');
            wishChildName = guardianName + ';' + wishChildName;
        }
        System.debug('wishChildName: ' + wishChildName);
        PDF.getParameters().put('name',wishChildName);
        if(!Test.isRunningTest())
            documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
        system.debug(PDF+'base64 value '+documentPDF);
        String recipients = '';
        Integer i = 1;
        String status;
        String boundary = 'AAA';
        String initial = '';
        String account;
        String IntegratorKey;
        boolean isFirstParent = true;
        
        
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
        String recipientsParticipants = '';
        if(currentParam != 'Three'){
            for (String currString: emailMap.KeySet()) {
                Name = currString;
                email = emailMap.get(Name);
                clientUserId = '';
                if (recipients != '')
                    recipients = recipients + ',';
                recipients = recipients + '{' +
                    '      "email": "' + email + '",' +
                    '      "name": "' + Name + '",' +
                    '     "roleName": "Signer ' + i + '",' +
                    //'     "routingOrder": "'+i+'",'+
                    '      "recipientId":"' + i + '",' + clientUserId +
                    '      "tabs": {' +
                    '                "signHereTabs": [{' +
                    '                     "anchorString":"~s' + i + '",' +
                    '                    "anchorXOffset": "0",' +
                    '     "anchorYOffset": "0",' +
                    '                    "anchorIgnoreIfNotPresent": "false",' +
                    '                    "anchorUnits": "inches"' +
                    '                }],' +
                    '                "dateSignedTabs": [{'+
                    '                      "anchorString": "~date'+i+'",'+
                    '                       "anchorXOffset": "0",'+
                    '                       "fontSize":      "Size14",'+
                    '                       "fontColor":     "Black",'+
                    '                        "anchorYOffset": "0",'+
                    '                        "anchorIgnoreIfNotPresent": "false",'+
                    '                        "xPosition": "100",'+
                    '                        "yPosition": "72",'+
                    '                        "anchorUnits": "inches"'+
                    '                    }]'+
                    '            }' +
                    '    }';
                i++;
            }
        }
        else{
            for(String currString : emailMap.KeySet()){
                Name = currString;
                email = emailMap.get(currString);
                
                
                
                if(recipients != '')
                    recipients = recipients + ',';
                recipients = recipients + '{'+
                    '      "email": "'+email+'",'+
                    '      "name": "'+Name+'",'+
                    '      "recipientId":"' + i + '",' + clientUserId +
                    '      "tabs": {'+
                    '                "signHereTabs": [{'+
                    '                     "anchorString":"~s'+i+'",'+
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
                    '                     "value": "one1Radio",'+
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
                    '                      "anchorString": "~date'+i+'",'+
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
        }
        if(recipientsParticipants != '')
            recipients = recipientsParticipants +','+ recipients; 
        
        //forming payload with the document and recipients.
        String body =  '{'+
            '  "status":"sent",'+
            '  "enableWetSign": "false",'+
            '  "emailBlurb":"Hello,\n'+'\r\n Please sign the attached Liability and Publicity Release Form necessary for '+ childFormInstance.Case__r.Contact.FirstName +'\'s wish. \r\n\n Thank You,\r\n Wish & Volunteer Center",'+
            '  "emailSubject": "Signature Required - Liability And Publicity Release Form",'+
            '  "enforceSignerVisibility":"True",'+
            '  "documents": [{'+
            '      "name": "document.pdf",'+
            '      "documentId":"1",'+
            '      "order":"1",'+
            '      "documentBase64":"'+documentPDF+'"'+
            '  }],'+
            '"recipients": {'+
            '    "signers" : ['+recipients+']'+
            '  },'+
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
        Http http = new Http();
        HTTPResponse res;
        try{
            if(recipients != ''){
                res = http.send(req);
                system.debug(res.getBody());
                //Docusign status record creation.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                
                if((String) results.get('status') == 'Sent'){
                    status = 'Agreement sent to email.';
                    dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                    dsfs.dsfs__DocuSign_Envelope_ID__c = (String) results.get('envelopeId');
                    dsfs.Form_Name__c = 'Liability Form';
                    if(Name != wishChildName)
                    dsfs.Associated_Childeren__c = wishChildName;
                    dsfs.dsfs__Case__c= caseId;
                    Insert dsfs;
                }else
                    status = (String) results.get('errorCode');
                
            }
            
        }catch(Exception e){
            System.debug('Some Exception has occured');
        }
        
    }
    
    public pageReference redirect(){
        PageReference acctPage = new PageReference ('/'+caseId);
        acctPage.setRedirect(true);
        return acctPage;
    }
    
    /*This method is used to Identify the users who are all going to sign the document*/
    public pageReference signNowmultiEmail(){
        for(Wish_Child_Form__c getNameEmailMap :wishChildFormRecrodList){
            multiNameEmailMap.put(getNameEmailMap.FirstName__c+ ' '+ getNameEmailMap.LastName__c, getNameEmailMap.Email__c);
            
        }
        if(multiNameEmailMap.size() > 0){
            displaySignNowPopup = true;
            multiPickoptions = new List<SelectOption>();
            for(String currString : multiNameEmailMap.keySet()){
                
                multiPickoptions.add(new SelectOption(currString,currString ));
                
            }
        }
        else{
            displayError = true;
        }
        return null;
    }          
    
    /*This method is used Sign the document by the selected user. */
    public Pagereference submitAndSign(){
        String account;
        String integratorKey;
        String wishChildName;
        List<Contact> relationShipList = new List<Contact>();
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        Map<Id,Wish_Child_Form__c> wishChildFormMap = new Map<Id,Wish_Child_Form__c>();
        Map<String, Object> results;
        String timmedName = SingerName.trim();
        PageReference reference;
        List<dsfs__DocuSign_Status__c> dsfsList = new List<dsfs__DocuSign_Status__c>();
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipient = [SELECT Name,dsfs__DocuSign_Recipient_Email__c,dsfs__Envelope_Id__c,dsfs__Parent_Status_Record__c,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__r.dsfs__Case__c, 
                                                                dsfs__Parent_Status_Record__r.dsfs__Subject__c FROM dsfs__DocuSign_Recipient_Status__c WHERE Name =: SingerName AND dsfs__DocuSign_Recipient_Email__c =: 'NotSent@NoEmail.com' 
                                                                AND dsfs__Parent_Status_Record__r.dsfs__Case__c =: caseId AND dsfs__Recipient_Status__c != 'Completed' AND dsfs__Parent_Status_Record__r.dsfs__Subject__c =: 'Signature Required - Liability And Publicity Release Form' Limit 1];
        if((!Test.isRunningTest()) && dbRecipient.size() > 0){
            ResendEnvelopController resendEnv = new ResendEnvelopController();
            return resendEnv.signNowEnvelop(dbRecipient[0].dsfs__Envelope_Id__c,dbRecipient[0].Name,caseId,'WishLiabilityForm_VF');
        }
        else{
            if(multiNameEmailMap.size() > 0){            
                boolean isParent;
                for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
                    account = credentialIns.account__c;
                    IntegratorKey  = credentialIns.IntegratorKey__c;
                    
                }
                
                String authorizationHeader = '<DocuSignCredentials><Username>{!$Credential.Username}</Username><Password>{!$Credential.Password}</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
                String status;
                String email;
                String recipients = '';
                Integer i = 1;
                String boundary = 'AAA';
                Pagereference PDF = Page.WishLiabilitySignNow;
                PDF.getParameters().put('Id',caseId);
                try {
                    documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
                }
                catch(Exception e) {
                    System.debug('Some Exception has occured');
                }
                Map<String,String> recipientMap = new Map<String,String>();
                Set<String> signerSet = new Set<String>();
                for(Wish_Child_Form__c wishChildForm : [SELECT Id,Name,Case__c,Participant_Name__c,Parent_Gurdian_above_18__c,Parent_Gurdian_above_18_Email__c,FirstName__c,LastName__c,Migrated__c FROM Wish_Child_Form__c WHERE
                                                        Case__c =: caseId AND Migrated__c = False]){
                                                            wishChildName = wishChildForm.FirstName__c+' '+wishChildForm.LastName__c; 
                                                            if(wishChildForm.Parent_Gurdian_above_18__c != Null) {                                     
                                                                for(String keys : wishChildForm.Parent_Gurdian_above_18__c .split('#')){
                                                                    String name = keys.split('-')[0];
                                                                    recipientMap.put(name.trim(),'PARENT/LEGAL GUARDIAN');
                                                                    signerSet.add(name); 
                                                                } 
                                                            }
                                                            if(wishChildForm.Participant_Name__c!= Null){
                                                                for(String keys : wishChildForm.Participant_Name__c.split('#')){
                                                                    String key = keys.split('::')[0];
                                                                    String values = keys.split('::')[1];
                                                                    recipientMap.put(key.trim(),'Participant');
                                                                    signerSet.add(key); 
                                                                } 
                                                            }
                                                        }
                
                Set<String> processSet = new Set<String>();
                
                if(SingerName != Null && recipientMap.get(SingerName) != 'PARENT/LEGAL GUARDIAN'){
                    DisplayMessage();
                }
                
                if(displaypopwindow == false){
                    if(recipientMap.get(SingerName ) == 'PARENT/LEGAL GUARDIAN' && recipientMap.containsKey(SingerName)){
                        if(recipients != '')
                            recipients = recipients + ',';
                        recipients = recipients + '{'+
                            '      "email": "NotSent@NoEmail.com",'+
                            '      "name": "'+SingerName+'",'+
                            '      "recipientId":"'+i+'",'+
                            '      "clientUserId":"'+i+'",'+
                            '      "tabs": {'+
                            '                "signHereTabs": [{'+
                            '                     "anchorString":"~s'+i+'",'+
                            '                    "anchorXOffset": "0",'+
                            '     "anchorYOffset": "0",'+
                            '                    "anchorIgnoreIfNotPresent": "false",'+
                            '                    "anchorUnits": "inches"'+
                            '                }],'+
                            '     "radioGroupTabs": [{'+
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
                            '                     "value": "one1Radio",'+
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
                            '                "initialHereTabs": [{' +
                            '                    "anchorString": "~123abcinitial",' +
                            '                    "conditionalParentLabel":"Radio Group 1",'+
                            '                    "conditionalParentValue" :"one1Radio",'+
                            '                    "optional"    :  "false",' +
                            '                    "anchorXOffset": "0",' +
                            '                    "anchorYOffset": "0.2",' +
                            '                    "name"       : "FirstInitial",'+
                            '                    "mergeField" : {"configurationType":"Salesforce","path":"Case.Option1__c","writeBack":"true","allowSenderToEdit":"true"},'+
                            '                    "anchorIgnoreIfNotPresent": "false",' +
                            '                    "anchorUnits": "inches"},{'+
                            '                    "anchorString": "~initial2",' +
                            '                    "optional"    :  "false",' +
                            '                    "conditionalParentLabel":"Radio Group 1",'+
                            '                    "mergeField" : {"configurationType":"Salesforce","path":"Case.Option2__c","writeBack":"true","allowSenderToEdit":"true"},'+
                            '                    "conditionalParentValue" :"twoRadio",'+
                            '                    "name"       : "SecondInitial",'+
                            '                    "anchorXOffset": "0",' +
                            '                    "anchorYOffset": "0.2",' +
                            '                    "anchorIgnoreIfNotPresent": "false",' +
                            '                    "anchorUnits": "inches"'+
                            '                }],' +
                            '                "TextTabs": [{' +
                            '                    "anchorString": "~123abcinitial",' +
                            '                    "conditionalParentLabel":"Radio Group 1",'+
                            '                    "conditionalParentValue" :"one1Radio",'+
                            '                    "optional"    :  "false",' +
                            '                    "anchorXOffset": "0",' +
                            '                    "anchorYOffset": "0.2",' +
                            '                    "name"       : "FirstInitial",'+
                            '                    "value"      : "Sign1",'+
                            '                    "mergeField" : {"configurationType":"Salesforce","path":"Case.Option1__c","writeBack":"true","allowSenderToEdit":"true"},'+
                            '                    "anchorIgnoreIfNotPresent": "false",' +
                            '                    "anchorUnits": "inches"},{'+
                            '                    "anchorString": "~initial2",' +
                            '                    "optional"    :  "false",' +
                            '                    "conditionalParentLabel":"Radio Group 1",'+
                            '                    "mergeField" : {"configurationType":"Salesforce","path":"Case.Option2__c","writeBack":"true","allowSenderToEdit":"true"},'+
                            '                    "conditionalParentValue" :"twoRadio",'+
                            '                    "name"       : "SecondInitial",'+
                            '                    "value"      : "Sign2",'+
                            '                    "anchorXOffset": "0",' +
                            '                    "anchorYOffset": "0.2",' +
                            '                    "anchorIgnoreIfNotPresent": "false",' +
                            '                    "anchorUnits": "inches"'+
                            '                }],' +
                            '                "dateSignedTabs": [{'+
                            '                      "anchorString": "~date'+i+'",'+
                            '                       "anchorXOffset": "0",'+
                            '                       "fontSize":      "Size14",'+
                            '                       "fontColor":     "Black",'+
                            '                        "anchorYOffset": "0",'+
                            '                        "anchorIgnoreIfNotPresent": "false",'+
                            '                        "xPosition": "100",'+
                            '                        "yPosition": "72",'+
                            '                        "anchorUnits": "inches"'+
                            '                    }]'+
                            '            }'+
                            '    }';
                        
                    }
                    else{
                        if(recipients != '')
                            recipients = recipients + ',';
                        recipients = recipients + '{'+
                            '      "email": "NotSent@NoEmail.com",'+
                            '      "name": "'+SingerName+'",'+
                            '      "recipientId":"'+i+'",'+
                            '      "clientUserId":"'+i+'",'+
                            '      "tabs": {'+
                            '                "signHereTabs": [{'+
                            '                     "anchorString":"~s'+i+'",'+
                            '                    "anchorXOffset": "0",'+
                            '     "anchorYOffset": "0",'+
                            '                    "anchorIgnoreIfNotPresent": "false",'+
                            '                    "anchorUnits": "inches"'+
                            '                }],'+
                            '                "dateSignedTabs": [{'+
                            '                      "anchorString": "~date'+i+'",'+
                            '                       "anchorXOffset": "0",'+
                            '                       "fontSize":      "Size14",'+
                            '                       "fontColor":     "Black",'+
                            '                        "anchorYOffset": "0",'+
                            '                        "anchorIgnoreIfNotPresent": "false",'+
                            '                        "xPosition": "662",'+
                            '                        "yPosition": "895",'+
                            '                        "anchorUnits": "inches"'+
                            '                    }]'+
                            '            }'+
                            '    }';
                    }
                    
                    //forming payload with the document and recipients.
                    String body =  '{'+
                        '  "status":"sent",'+
                        '  "enableWetSign": "false",'+
                        '  "emailSubject": "Signature Required - Liability And Publicity Release Form",'+
                        '  "enforceSignerVisibility":"True",'+
                        '  "documents": [{'+
                        '      "name": "document.pdf",'+
                        '      "documentId":"1",'+
                        '      "order":"1",'+
                        '      "documentBase64":"'+documentPDF+'"'+
                        '  }],'+
                        '"recipients": {'+
                        '    "signers" : ['+recipients+']'+
                        '  }'+
                        '}';
                    String viewBody = '{'+
                        '"returnUrl": "https://www.docusign.com/devcenter"'+
                        '}';
                    String header = '--'+boundary+'\nContent-Type: application/json\nContent-Disposition: form-data';
                    String jsonBody = header +'\n\n'+body+'\n\n--'+boundary+'--';
                    
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
                    system.debug('@@@ Response @@@'+res);
                    try{
                        if(recipients != ''){
                            res = http.send(req);
                            system.debug('response 1'+res.getBody());
                            //Docusign status record creation.
                            results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                            if((String) results.get('envelopeId') != '')
                                envelopeId = (String) results.get('envelopeId');
                            if((String) results.get('status') == 'Sent'){
                                status = 'Agreement sent to email.';
                                dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                                dsfs.dsfs__DocuSign_Envelope_ID__c = (String) results.get('envelopeId');
                                dsfs.dsfs__Case__c= caseId;
                                if(SingerName != wishChildName)
                                dsfs.Associated_Childeren__c = wishChildName;
                                dsfs.Form_Name__c = 'Liability Form';
                                dsfsList.add(dsfs);
                            }
                            else
                                status = (String) results.get('errorCode');
                        }
                    }catch(Exception e){
                        System.debug('Some Exception has occured');
                    }
                } 
            }
            
            if(displaypopwindow == false){
                
                String authorizationHeader = '<DocuSignCredentials><Username>{!$Credential.Username}</Username><Password>{!$Credential.Password}</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
                HttpRequest request = new HttpRequest();
                request.setHeader('X-DocuSign-Authentication', authorizationHeader);
                request.setHeader('Accept','application/json');
                request.setHeader('Host','demo.docusign.net');
                request.setHeader('Content-Length','162100');
                request.setHeader('Content-Type','application/json');
                request.setMethod('POST'); 
                Http httprequest = new Http();
                HTTPResponse response;
                request.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes/'+envelopeId+'/views/recipient');
                string jsonPayload;
                String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
                jsonPayload = '{'+
                    '    "userName": "'+SingerName+'",'+
                    '    "email": "NotSent@NoEmail.com",'+
                    '    "recipientId": "'+1+'",'+
                    '    "clientUserId": "'+1+'",'+
                    '    "authenticationMethod": "None",'+
                    '   "returnUrl": "'+baseUrl +'/apex/WishLiabilityForm_VF?Id='+CaseId+'"'+   
                    '}'; 
                request.setBody(jsonPayload);
                if(!Test.isRunningTest()){
                response = httprequest.send(request);  
                system.debug('@@@ result @@@'+response);
                results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if(dsfsList.size() > 0)
                    insert dsfsList;
                reference=new PageReference((String) results.get('url'));
                reference.setRedirect(true);
              }
            }
            return reference;
        }
    }
    /*This method will display popup messages*/
    public pageReference displayMessage(){
        displaySignNowPopup = false;
       // displaypopwindow = true;
        return null;
    }
}