Public class ResendEnvelopController{
    
    String account;
    String UserName;
    String Password;
    String IntegratorKey;
    String endPointURL;
    String boundary = 'AAA';
    String authorizationHeader;
    String documentPDF;
    String endpoint;
    public String reciName;
    Public String envelopId;
    public Id CurrentRecId;
    public ResendEnvelopController(){
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        
        for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
            account = credentialIns.account__c;
            IntegratorKey  = credentialIns.IntegratorKey__c;
        }
        
        authorizationHeader = '<DocuSignCredentials><Username>{!$Credential.Username}</Username><Password>{!$Credential.Password}</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
    }
    public void resendEnvelop(string envelop,string name,string email,boolean ischanged){
        
        
        String body =  '{'+
            '  "signers": [{'+
            '      "email": "'+email+'",'+
            '      "name": "'+name+'",'+
            '      "resend_envelope":"true",'+
            '      "recipientId": "1"'+
            '  }]'+
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
        if(ischanged){
        req.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes/'+envelop+'/recipients/resend_envelope=true');
        }
        else{
        req.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes/'+envelop+'/recipients?resend_envelope=true');
        }
        req.setMethod('PUT'); 
        req.setBody(jsonBody);
        Http http = new Http();
        HTTPResponse res;
        res = http.send(req);
        List<dsfs__DocuSign_Status__c> dbstatusList = new List<dsfs__DocuSign_Status__c>();
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipientList = new List<dsfs__DocuSign_Recipient_Status__c> ();
        
        for(dsfs__DocuSign_Status__c dbStatus : [SELECT Id,dsfs__Sent_Date_Time__c,dsfs__DocuSign_Envelope_ID__c FROM dsfs__DocuSign_Status__c  WHERE dsfs__DocuSign_Envelope_ID__c =: envelop]){
            
            dsfs__DocuSign_Status__c newStatus = new dsfs__DocuSign_Status__c();
            newStatus.Id = dbStatus .Id;
            newStatus.dsfs__Sent_Date_Time__c = system.Now();
            dbstatusList.add(newStatus);
        }
        
        for(dsfs__DocuSign_Recipient_Status__c dbRecipnt : [SELECT Id,dsfs__Date_Sent__c,dsfs__Envelope_Id__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Envelope_Id__c =: envelop]){
            dsfs__DocuSign_Recipient_Status__c updatedsfsReci  = new dsfs__DocuSign_Recipient_Status__c ();
            updatedsfsReci .Id = dbRecipnt.Id;
            updatedsfsReci.dsfs__Date_Sent__c = system.Now();
            updatedsfsReci.dsfs__DocuSign_Recipient_Email__c = email;
            dbRecipientList.add(updatedsfsReci);
        }
        
        if(dbRecipientList.size() > 0 && dbstatusList.size() > 0){
            update dbRecipientList;
            update dbstatusList;
        }
        
    }
    
    /***
     * Update the docusign status record as voided whe the dosuign record get deleted from form tracker.
     * WVC-2156 
     * 
     */
     public  void updateDocusingStatus(String envelop,String chapterName){        
        String body =  '{'+  
                                   
                            '"emailSettings": {},'+
                            '"lockInformation": {},'+
                            '"notification": {},'+
                            '"status":"Voided",'+
                            '"voidedReason":"This form has been voided. If you believe you still need to sign this form, please contact the staff at '+chapterName+'."'+
                        '}';
         system.debug('body value'+body);     
        String header = '--'+boundary+'\nContent-Type: application/json\nContent-Disposition: form-data';
        String jsonBody = header +'\n\n'+body+'\n\n--'+boundary+'--';        
        //Callout to Docusign.
        HttpRequest req = new HttpRequest();
        req.setHeader('X-DocuSign-Authentication', authorizationHeader);
        req.setHeader('Accept','application/json');
        req.setHeader('Host','demo.docusign.net');
        req.setHeader('Content-Length','162100');
        req.setHeader('Content-Type','application/json; boundary='+boundary);
        req.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes/'+envelop);
        req.setMethod('PUT'); 
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res;
        res = http.send(req);
         If(res.getStatusCode() == 400){ 
             system.debug('res.getBody()'+res.getBody());
         }
         system.debug('res*************'+res);
     }
    /****************** WVC2156 **********************/
  /**
     * [chapterNameByCase is used to find a chapter name by case]
     * @param  caseId [String]
     * @return        [List of cases]
     */

    public static List<Case> chapterNameByCase(Id caseId){
        List<Case> Records = new List<Case>();
        Records = [SELECT Id,ContactId,Contact.name,ChapterName__r.Name FROM Case WHERE Id =: caseId];
        return Records;
    }
    

    /**
     * [singleAbsentParentDocusign used to send docusign from form tracker dashboard pages]
     * @param config [is used to send all the config parameters ]
     */
    @Future(callout=true)
    public static void singleAbsentParentDocusign(Map<String,String> config) {
        Integer i = 1;
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        String endPointURL;
        String clientUserId;
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        String Name;
        String Email = config.get('email');
        String guardian = config.get('guardian');
        String subject = config.get('subject');
        String pageLabel = config.get('pageLabel');
        String selectedForm = config.get('selectedForm');
        String emailbody;
        String templateID;
        Boolean allowCallout = false;
        String participantName = config.get('miniorParticipantName');
        Id caseId = (Id) config.get('currentPageId');
        String ChapterName;
        String ContactName;
        List<Case> chapterInfo = chapterNameByCase(caseId);
        for (Case c : chapterInfo)
        { 
            ChapterName = c.ChapterName__r != null ? c.ChapterName__r.Name : null;
            ContactName = c.Contact != null ? c.Contact.Name : null;
        }
        
        Name = (guardian == 'Not Listed') ? config.get('Name') : guardian;
        if(pageLabel == 'absent'){
        templateID = label.AbsentForm;
        }
        else if(pageLabel == 'single'){
        templateID = label.SingleForm;
        }
       
       Case dbParentCase = [SELECT Id,ContactId,OwnerId,Owner.Name,Owner.Phone,Contact.Hidden_Chapter_Name__c FROM Case WHERE Id =: caseId];
       string ownerPhone = dbParentCase.Owner.Phone;
       string ownerName = dbParentCase.Owner.Name;
        String  Absentemailbody= 'Dear'+' '+Name+'\r\n\r\n'+'All of us at'+' '+ChapterName+' '+'look forward to granting'+' '+ContactName+'’s wish!'+'\r\n\r\n'+
            'As a matter of practice, Make-A-Wish® requires that both parents or legal guardians of all minor children participating in a wish sign the required documents. However, where it is not possible to obtain the signature of one biological parent, we may be able to move forward with your signature only, provided you can truthfully sign the enclosed document.'+'\r\n\r\n'+ 
            'The attached Absent Parent Form is a sworn declaration by you, signed under penalties of perjury, certifying that one of the following statements is true of the biological parent of'+' '+participantName+':'+'\r\n\r\t\n\t'+
            
            '    a) You do not know the whereabouts of the other biological'+'\r\n\t\t'+' parent and have no means of contacting him/her;'+'\r\n\t'+
            '    b) The other biological parent is deceased; or  '+'\r\n\t'+
            '    c) The identity of the child’s biological father is unknown'+'\r\n\r\n'+
            
            'If none of the three circumstances described above accurately describes your situation, do not sign the attached Absent Parent Form; instead, please contact'+' '+ChapterName+' '+'so we can discuss the best way to move forward with your child’s wish.'+'\r\n\r\n'+
            
            'Please feel free to contact our office with any questions. I look forward to working with you to grant'+' '+ContactName+'’s wish.'+'\r\n\r\n'+
            'Thank You,'+'\r\n\r\n'+
            ChapterName;
        
        
        String singleEmailBody = 'Dear'+' '+Name+'\r\n\r\n'+'All of us at'+' '+ChapterName+' '+'look forward to granting'+' '+ContactName+'’s wish!'+'\r\n\r\n'+
            'As a matter of practice, the Make-A-Wish Foundation requires that both parents or legal guardians of all minor children participating in a wish sign the required documents. However, where the custodial parent does not want to involve the other biological parent based on concerns for the child’s well being, as you have stated is the case here, we may be able to move forward with your signature only, provided you can truthfully sign the attached document.'+'\r\n\r\n'+ 
            'The attached Single Parent Form is a sworn declaration by you, signed under penalties of perjury, certifying that all of the following statements are true of the following child(ren):'+' '+participantName+'\r\n\r\t'+
            
            '    a) You have been awarded legal custody of the child;'+'\r\n\t'+
            '    b) You have the legal right to make important decisions about'+'\r\n\t\t'+' the child without consultation with and/or approval from'+'\r\n\t\t'+' the child’s other biological parent; and'+'\r\n\t'+
            '    c) You have requested that the Make-A-Wish Foundation'+'\r\n\t\t'+' make an exception to its standard signature requirements,'+'\r\n\t\t'+' and grant your child’s wish or allow your child to'+'\r\n\t\t'+' participate in a wish without the signature of his/her other'+'\r\n\t\t'+' biological parent based on your concerns for your child’s'+'\r\n\t\t'+' well being.'+'\r\n\r\n'+ 
            
            'If at least one of the statements listed above does not accurately describe your situation, do not sign the attached Single Parent Form; instead, please contact'+' '+ChapterName+' '+'so we can discuss the best way to move forward.'+'\r\n\r\n'+
            
            'Please feel free to contact our office with any questions. I look forward to working with you to grant'+' '+ContactName+'’s wish.'+'\r\n\r\n'+
            'Thank You,'+'\r\n\r\n'+
            ChapterName;
            
        if(subject == 'Signature Required - Absent Parent Form'){
            emailbody = Absentemailbody;
        }
        if( subject == 'Signature Required - Single Parent Form'){
            emailbody = singleEmailBody;
        }
        
        if(allowCallout == false){
            for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
                account = credentialIns.account__c;
                IntegratorKey  = credentialIns.IntegratorKey__c;
            }
            String authorizationHeader = '<DocuSignCredentials><Username>{!$Credential.Username}</Username><Password>{!$Credential.Password}</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
            HttpRequest req = new HttpRequest(); 
            req.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes');
            req.setMethod('POST'); 
            req.setHeader('X-DocuSign-Authentication', authorizationHeader); 
            req.setHeader('Accept','application/json'); 
            req.setHeader('Content-Length','162100'); 
            req.setHeader('Content-Type','application/json'); 
            req.setHeader('Content-Disposition','form-data'); 
            String recipient = '';
            recipient = recipient + '{'+ 
                '"roleName": "'+'Signer'+i+'",'+ 
                '"name": "'+Name+'",'+ 
                '"email": "'+Email+'",'+ 
                '"emailSubject": "'+subject+'",'+
                '"emailBody": "'+Name+emailbody+'",'+ 
                '"supportedLanguage": "en",'+
                '"recipientId": '+i+''+ 
                '}';
            
            recipient = recipient+',';
            
            
            String json='{'+ 
                ' '+ 
                ' "emailSubject": "'+subject+'",'+
                '"emailBody": "'+emailbody+'",'+
                ' "templateId": "'+templateID+'",'+ 
                ' "envelopeIdStamping": "false",'+ 
                ' "customFields":{'+
                '    "textCustomFields":['+
                '      {'+
                '        "name":"##SFCase",'+
                '        "required":"true",'+
                '        "show":"false",'+
                '        "value":"'+caseId+'"'+
                '      }'+
                '    ]'+
                '  },'+
                ' "templateRoles": ['+ recipient+
                '{'+ 
                '    "roleName": "Signer 1",'+ 
                '    "name": "'+name+'",'+ 
                '    "email": "'+email+'",'+
                '    "emailNotification": {'+
                '    "emailSubject": "'+subject+'",'+
                '    "emailBody": "'+emailbody+'",'+
                '    "supportedLanguage": "en"'+
                '},'+
                '},'+ 
                ' ],'+ 
                ' "status": "sent"'+ 
                '}'; 
            
            System.debug('Json = ' + json);
            
            req.setBody(json); 
            Http http = new Http(); 
            HTTPResponse res; 
            try{ 
                res = http.send(req); 
                system.debug('DocuSign Response'+ res.getBody()); 
            } 
            catch(Exception e){ 
                // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage())); 
                system.debug('Error Response'+ e.getMessage()); 
            } 
            
            WrapperDocuSign wrapInst = WrapperDocuSign.parse(res.getBody());
            if(wrapInst.status == 'Sent'){
                dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                dsfs.dsfs__DocuSign_Envelope_ID__c = wrapInst.envelopeId;
                dsfs.dsfs__Case__c= caseId;
                dsfs.Form_Name__c = selectedForm;
                dsfs.Associated_Childeren__c = participantName;
                Insert dsfs;
                }
        }
    }
    
    
     /**
     * [singleAbsentParentDocusign used to send docusign from form tracker dashboard pages]
     * @param config [is used to send all the config parameters ]
     */
    @Future(callout=true)
    public static void comboFormSendEnvelop(Map<String,String> config,Id minorRecId) {
        Integer i = 1;
        String account;
        String UserName;
        String Password;
        String IntegratorKey;
        String endPointURL;
        String clientUserId;
        Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
        String Name;
        String Email = config.get('email');
        String guardian = config.get('guardian');
        String subject = config.get('subject');
        String pageLabel = config.get('pageLabel');
        String selectedForm = config.get('selectedForm');
        String emailbody;
        String templateID;
        Boolean allowCallout = false;
        String participantName = config.get('miniorParticipantName');
        Id caseId = (Id) config.get('currentPageId');
        String ChapterName;
        String ContactName;
        List<Case> chapterInfo = chapterNameByCase(caseId);
        for (Case c : chapterInfo)
        { 
            ChapterName = c.ChapterName__r != null ? c.ChapterName__r.Name : null;
            ContactName = c.Contact != null ? c.Contact.Name : null;
        }
       Name = (guardian == 'Not Listed') ? config.get('Name') : guardian;
       templateID = label.Combo_Wish_Form;
       Case dbParentCase = [SELECT Id,ContactId,OwnerId,Owner.Name,Owner.Phone,Contact.Hidden_Chapter_Name__c FROM Case WHERE Id =: caseId];
       string ownerPhone = dbParentCase.Owner.Phone;
       string ownerName = dbParentCase.Owner.Name;
       
       emailbody = 'Dear'+' '+Name+','+'\r\n\r\n'+'As you may know, your child,'+' '+ContactName+','+' '+'recently became eligible for a wish through Make-A-Wish® '+dbParentCase.Contact.Hidden_Chapter_Name__c+'.'+'\r\n\r\n'+
            'Make-A-Wish America requires that our chapter obtain approval of the wish from both parents or legal guardians. Please take a moment to review and sign the attached Wish Family Form and Liability Release. Once the signed documents are received we can proceed with'+ ' '+ContactName+'’s wish.'+'\r\n\r\n'+ 
            'If you have any questions, please don’t hesitate to contact me at'+' '+ownerPhone+'.'+'\r\n\r\n'+
            'Thank you! We look forward to granting'+' '+ContactName+'’s wish.'+'\r\n\r\n'+
            'Best wishes,'+'\r\n\r\n'+
            ownerName+'\r\n\r'+
            ChapterName;
        
        
        if(allowCallout == false){
            for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
                account = credentialIns.account__c;
                IntegratorKey  = credentialIns.IntegratorKey__c;
            }
            String authorizationHeader = '<DocuSignCredentials><Username>{!$Credential.Username}</Username><Password>{!$Credential.Password}</Password><IntegratorKey>'+IntegratorKey+'</IntegratorKey></DocuSignCredentials>';
            HttpRequest req = new HttpRequest(); 
            req.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes');
            req.setMethod('POST'); 
            req.setHeader('X-DocuSign-Authentication', authorizationHeader); 
            req.setHeader('Accept','application/json'); 
            req.setHeader('Content-Length','162100'); 
            req.setHeader('Content-Type','application/json'); 
            req.setHeader('Content-Disposition','form-data'); 
            String recipient = '';
            recipient = recipient + '{'+ 
                '"roleName": "'+'Signer'+i+'",'+ 
                '"name": "'+Name+'",'+ 
                '"email": "'+Email+'",'+ 
                '"emailSubject": "'+subject+'",'+
                '"emailBody": "'+Name+emailbody+'",'+ 
                '"supportedLanguage": "en",'+
                '"recipientId": '+i+''+ 
                '}';
            
            recipient = recipient+',';
            
            
            String json='{'+ 
                ' '+ 
                ' "emailSubject": "'+subject+'",'+
                '"emailBody": "'+emailbody+'",'+
                ' "templateId": "'+templateID+'",'+ 
                ' "envelopeIdStamping": "false",'+ 
                ' "customFields":{'+
                '    "textCustomFields":['+
                '      {'+
                '        "name":"##SFMinor_Participant__c",'+
                '        "required":"true",'+
                '        "show":"false",'+
                '        "value":"'+minorRecId+'"'+
                '      }'+
                '    ]'+
                '  },'+
                ' "templateRoles": ['+ recipient+
                '{'+ 
                '    "roleName": "Signer 1",'+ 
                '    "name": "'+name+'",'+ 
                '    "email": "'+email+'",'+
                '    "emailNotification": {'+
                '    "emailSubject": "'+subject+'",'+
                '    "emailBody": "'+emailbody+'",'+
                '    "supportedLanguage": "en"'+
                '},'+
                '},'+ 
                ' ],'+ 
                ' "status": "sent"'+ 
                '}'; 
            
            System.debug('Json = ' + json);
            
            req.setBody(json); 
            Http http = new Http(); 
            HTTPResponse res; 
            try{ 
                res = http.send(req); 
                system.debug('DocuSign Response'+ res.getBody()); 
            } 
            catch(Exception e){ 
                // ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage())); 
                system.debug('Error Response'+ e.getMessage()); 
            } 
            
            WrapperDocuSign wrapInst = WrapperDocuSign.parse(res.getBody());
            if(wrapInst.status == 'Sent'){
                dsfs__DocuSign_Status__c dsfs= NEW dsfs__DocuSign_Status__c();
                dsfs.dsfs__DocuSign_Envelope_ID__c = wrapInst.envelopeId;
                dsfs.dsfs__Case__c= caseId;
                dsfs.Form_Name__c = selectedForm;
                dsfs.Minor_Participant__c = minorRecId;
                dsfs.Associated_Childeren__c = participantName;
                Insert dsfs;
                
                if(subject == 'Signature Required - Combo Family Form & Liability/Publicity Release Form'){
                    String envelopString = dsfs.dsfs__DocuSign_Envelope_ID__c;
                    Minor_Participant__c updateMinorRec= new Minor_Participant__c();
                    updateMinorRec.Id = minorRecId;
                    if(!Test.isRunningTest())
                    updateMinorRec.Hidden_Combo_Envelop_Id__c = envelopString.toUpperCase();
                    update updateMinorRec;
                }
            }
        }
    }
    
    
    public Pagereference signNowEnvelop(string envelop,string name,String currCaseId,String pageName){
        PageReference reference;
        Pagereference PDF;
        Id caseId;
        if(pageName == 'WishInformationForm_VF'){
            PDF = Page.SignNowPDF;
        }
        if(pageName == 'WishLiabilityForm_VF'){
            PDF = Page.WishLiabilitySignNow;
            caseId = currCaseId;
            currCaseId =currCaseId+'&option=Three';
        }
        if(pageName == 'WishFormWishGranting_VF'){
            pageName = 'WishGranting_VF';
            PDF = Page.SignNowPDF;
        }
        if(pageName == 'WishLiabilityWishGranting_VF'){
            pageName = 'WishGranting_VF';
            caseId = currCaseId;
            PDF = Page.WishLiabilitySignNow;
        }
        if(currCaseId != currCaseId+'&option=Three'){
            PDF.getParameters().put('Id',currCaseId);
        }
        if(currCaseId != currCaseId+'&option=Three'){
            PDF.getParameters().put('Id',caseId);
        }
        try {
            //If(!Test.isrunningtest())
            documentPDF = EncodingUtil.base64Encode(PDF.getContentAsPDF());
        }
        catch(Exception e){
            e.getMessage();
        }
        
        
        HttpRequest request = new HttpRequest();
        request.setHeader('X-DocuSign-Authentication', authorizationHeader);
        request.setHeader('Accept','application/json');
        request.setHeader('Host','demo.docusign.net');
        request.setHeader('Content-Length','162100');
        request.setHeader('Content-Type','application/json');
        request.setMethod('POST'); 
        Http httprequest = new Http();
        HTTPResponse response;
        request.setEndpoint('Callout:Docusign_Credential/accounts/'+account+'/envelopes/'+envelop+'/views/recipient');
        string jsonPayload;
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        jsonPayload = '{'+
            '    "userName": "'+name+'",'+
            '    "email": "NotSent@NoEmail.com",'+
            '    "recipientId": "1",'+
            '    "clientUserId": "1",'+
            '    "authenticationMethod": "None",'+
            '   "returnUrl": "'+baseUrl +'/apex/'+pageName+'?Id='+currCaseId+'"'+   
            '}';     
        request.setBody(jsonPayload);
        response = httprequest.send(request); 
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
        
        List<dsfs__DocuSign_Status__c> dbstatusList = new List<dsfs__DocuSign_Status__c>();
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipientList = new List<dsfs__DocuSign_Recipient_Status__c> ();
        
        for(dsfs__DocuSign_Status__c dbStatus : [SELECT Id,dsfs__Sent_Date_Time__c,dsfs__DocuSign_Envelope_ID__c FROM dsfs__DocuSign_Status__c  WHERE dsfs__DocuSign_Envelope_ID__c =: envelop]){
            
            dsfs__DocuSign_Status__c newStatus = new dsfs__DocuSign_Status__c();
            newStatus.Id = dbStatus .Id;
            newStatus.dsfs__Sent_Date_Time__c = system.Now()  ;
            dbstatusList.add(newStatus);
        }
        
        for(dsfs__DocuSign_Recipient_Status__c dbRecipnt : [SELECT Id,dsfs__Date_Sent__c,dsfs__Envelope_Id__c FROM dsfs__DocuSign_Recipient_Status__c WHERE dsfs__Envelope_Id__c =: envelop]){
            dsfs__DocuSign_Recipient_Status__c updatedsfsReci  = new dsfs__DocuSign_Recipient_Status__c ();
            updatedsfsReci .Id = dbRecipnt.Id;
            updatedsfsReci.dsfs__Date_Sent__c = system.Now();
            
            dbRecipientList.add(updatedsfsReci);
        }
        
        if(dbRecipientList.size() > 0 && dbstatusList.size() > 0){
            update dbRecipientList;
            update dbstatusList;
        }
        
        reference = new PageReference((String) results.get('url'));
        reference.setRedirect(true);
        return reference;
    }
}