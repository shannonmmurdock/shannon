/* This WishClearanceSendNow_AC class is used to send the wish clearance form.
This wish clearance form is sent to treating medical contact. This contact is updat information 
about wish child.*/
public class WishClearanceSendNow_AC{
    
    public Case currentParentCase{get;set;}
    public List<SelectOption> multiPickoptions {get;set;}       
    Public String medicalProfContactName{get;set;}
    Constant_AC  constant = new Constant_AC();
    public Map<String,npe4__Relationship__c> medicalProfConMap; 
    public String email{get;set;}
    public String MedicalProviderType{get;set;}
    public String nameconcat;
    public boolean dis{get;set;}
    public boolean displayReturnToWish{get;set;} 
    public String type{ get;set;}
    public boolean isAttachment{get;set;} 

    Public Id MedicalProfContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.MedicalProfessionalRT).getRecordTypeId();
    public WishClearanceSendNow_AC(ApexPages.StandardController controller){
        dis = true;
        currentParentCase = [SELECT Id,ContactId,Contact.lastname,Contact.firstname,Contact.Gender__c,Description,Wish_Clarence_Attachment__c,
                             Contact.Hidden_Medical_Physician__c,Rush__c,IsRushWishClearence_ChildSummary__c,wish_involves_air_travel__c,
                             Contact.Hidden_Medical_Physician_Email__c,File_Path__c FROM Case WHERE Id =: ApexPages.currentPage().getParameters().get('id') LIMIT 1];
      nameconcat=currentParentCase.Contact.firstname+currentParentCase.Contact.lastname;
          
        currentParentCase.Wish_Clarence_Attachment__c = Null;
        
    }
    
    public List<SelectOption> getMedicalProContact(){
       medicalProfConMap = new Map<String,npe4__Relationship__c>();
       List<SelectOption> options = new List<SelectOption>();
        for(npe4__Relationship__c dbRelationShip  : [Select Id,npe4__Contact__c,npe4__RelatedContact__c,npe4__RelatedContact__r.Name,npe4__RelatedContact__r.Email,npe4__RelatedContact__r.Provider_Type__c,
                                                     npe4__RelatedContact__r.RecordTypeId FROM npe4__Relationship__c WHERE npe4__Contact__c =:currentParentCase.ContactId AND npe4__RelatedContact__r.RecordTypeId =:MedicalProfContactRecordTypeId  AND Send_Wish_Forms__c = True]){
       
           options.add(new SelectOption(dbRelationShip.npe4__RelatedContact__r.Name,dbRelationShip.npe4__RelatedContact__r.Name));
           medicalProfConMap.Put(dbRelationShip.npe4__RelatedContact__r.Name,dbRelationShip); 
       }
        If(medicalProfConMap.isEmpty()){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select the medical professional to send the wish forms to by selecting \'Send Wish Forms To\' checkbox under the Medical Professional section on the Case record.'));
        }
    
     return options;
    }
    
    public void displayEmail(){
       
        if(medicalProfConMap.containskey(medicalProfContactName)){
            if(medicalProfConMap.get(medicalProfContactName).npe4__RelatedContact__r.Email != Null){
            dis = true;
            email = medicalProfConMap.get(medicalProfContactName).npe4__RelatedContact__r.Email;
            }
            else{
            email = Null;
            }
             if(medicalProfConMap.get(medicalProfContactName).npe4__RelatedContact__r.Provider_Type__c!= Null){
             dis = true;
             MedicalProviderType = medicalProfConMap.get(medicalProfContactName).npe4__RelatedContact__r.Provider_Type__c; 
             }
             else{
              MedicalProviderType = Null;
             }
            }
        }
    
    public void ReturnToWish(){
        displayReturnToWish = true;
    }
    public pageReference ReturnToWishClearanceForm(){
     PageReference reference=new PageReference('/apex/WishClearanceSendNow_VF?id='+currentParentCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
     public pageReference ReturnToWishClearanceNoTravelForm(){
     PageReference reference=new PageReference('/apex/WishClearanceNoTravel_VF?id='+currentParentCase.id);
        reference.setRedirect(true);     
        return reference;
    }
    
    public void SendtoDocuSign(){
        if((currentParentCase.wish_involves_air_travel__c == Null && type != 'WishClearanceNoTravel') ||currentParentCase.Description == Null || medicalProfContactName == Null || (currentParentCase.Wish_Clarence_Attachment__c  == Null && type != 'WishClearanceNoTravel') ){
            DisplayErrorMessage();
        }
        else if(medicalProfConMap.get(medicalProfContactName).npe4__RelatedContact__r.Email == Null){
                DisplayErrorMessage();
            }
      else{
           case updatecase = new Case();
           updatecase.Id = currentParentCase.Id;
           updatecase.wish_involves_air_travel__c = currentParentCase.wish_involves_air_travel__c;
           updatecase.Emergency_Number__c = Null;
           updatecase.Appropriate_Comments__c = Null;
           updatecase.Please_Explain__c = Null;
           updatecase.Date_of_last_visit_treatment__c = Null;
           updatecase.Comments__c = Null;
           updatecase.Comment_1__c = Null;
           updatecase.Comment_2__c = Null;
           updatecase.Wish_Clearance_Sent_Date__c = system.today();
           updatecase.Wish_Clearance_Received_Date__c = Null;
           updatecase.Wish_Clarence_Attachment__c = currentParentCase.Wish_Clarence_Attachment__c;
           update updatecase;
           
           if(!Test.isRunningTest())
           CallouttoDocusign(updateCase.Id,medicalProfContactName,email,type);
           DisplayMessage();
        }
        // return wrapInst.status;
    }
    
    @future(Callout = true)
    public static void CallouttoDocusign(Id caseId,String conName,String conEmail,string type){
        Constant_AC cons = new Constant_AC();
        Id wishClearenceRecordTypeId= Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.wishClearenceAttachment ).getRecordTypeId();
        Case currentParentCase = [SELECT Id,ContactId,Contact.Name,File_Path__c,Contact.lastname,Contact.Gender__c,
                                  Contact.firstname,Contact.Hidden_Medical_Physician__c,wish_involves_air_travel__c,
                                  Contact.Hidden_Medical_Physician_Email__c,Rush__c,Wish_Clarence_Attachment__c,contact.Region_Chapter__r.Fax
                                  FROM Case WHERE Id =: caseId LIMIT 1];
                                  
        List<Minor_Participant__c> dbMinorParticipantList = [SELECT Id,Case__c,File_Path__c,RecordTypeId FROM Minor_Participant__c WHERE Case__c =:caseId  AND RecordTypeId =: wishClearenceRecordTypeId]; 
            
            String account;
            String IntegratorKey;
            String templateID;
            Map<String,DocuSignCredentialsSetting__c> credentialSetting = DocuSignCredentialsSetting__c.getAll();
            String  name = conName;
            String  email = conEmail;
            string filePath;
            if(currentParentCase.Wish_Clarence_Attachment__c   == 'Yes'){
                filePath = currentParentCase.File_Path__c;
            }
            else{
                filePath ='';
            }
            
            String  withAttachmentemailbody='Dear Healthcare Professional:'+'\r\n\r\n'+'Your patient has chosen a wish! Please help us prepare and keep your patient safe on their wish by completing the wish child’s Wish Clearance form.'+'\r\n\r\n'+
            '*Before completing the Wish Clearance form, please review the following document in association with the child’s chosen wish: LINK*'+'\r\n'+
            'Once you have reviewed the linked document, please complete the Wish Clearance. To do so:'+'\r\n\n\n'+
            '    '+filePath+'\r\n\r\t'+
            '    •  Click the Review Document button, above. '+'\r\n\t'+
            '    •  Fill out the form to the best of your knowledge.'+'\r\n\t'+
            '    •  Follow the prompts to sign electronically and submit the completed form.'+'\r\n\r\n\n'+
            'If this form needs to be forwarded to the physician, nurse practitioner or physician assistant to sign, you can reassign it to another provider:'+'\r\n\r\n\t'+
            
            
            '    •  Click the Review Document button above'+'\r\n\t'+
            '    •  Click Other Actions in the blue bar'+'\r\n\t'+
            '    •  Select Assign to Someone Else from the drop down'+'\r\n\t'+
            '    •  Enter the required information (New signer name & email)'+'\r\n\t'+
            '    •  Click Assign to Someone Else'+'\r\n\r\n'+
            
            'Please note: this will change the signature to the new recipient; however, if you enter content into the original document, DocuSign will not retain that information for the recipient.'+'\r\n\r\n'+
            
            'Alternatively, you can complete the form and print the document for another individual to sign:'+'\r\n\r\n\t'+
            
            '    •  Click the Review Document button above'+'\r\n\t'+
            '    •  Fill out the form to the best of your knowledge'+'\r\n\t'+
            '    •  Click Other Actions in the blue bar'+'\r\n\t'+
            '    •  Select Print & Sign from the drop-down'+'\r\n\t'+
            '    •  Select Upload, then click Continue'+'\r\n\t'+
            '    •  Click Download, which will generate a PDF version of the form'+'\r\n\t'+
            '    •  Print the form for signature'+'\r\n\t'+
            '    •  Fax the form back to your local chapter at'+' '+currentParentCase.contact.Region_Chapter__r.Fax+'\r\n\r\n'+   
            
           
            'Thank you for helping us get closer to achieving our vision of granting every eligible childs wish. Together, we create life-changing wishes for children with critical illnesses.'+
            '\r\n\r\n'+
            
            'Thank You,'+'\r\n\r\n'+
            'Make-A-Wish®'; 
            
            
            String  withOutAttachmentemailbody='Dear Healthcare Professional:'+'\r\n\r\n'+'Your patient has chosen a wish, please help us prepare and keep your patient safe on their wish by completing the wish child’s Wish Clearance form.'+'\r\n\r\n'+
            'To do so, please:'+'\r\n\t'+
            '    •  Click the Review Document button, above. '+'\r\n\t'+
            '    •  Fill out the form to the best of your knowledge.'+'\r\n\t'+
            '    •  Follow the prompts to sign electronically and submit the completed form.'+'\r\n\r\n\n'+
            'If this form needs to be forwarded to the physician, nurse practitioner or physician assistant to sign, you can reassign it to another provider:'+'\r\n\r\n\t'+
            
            
            '    •  Click the Review Document button above'+'\r\n\t'+
            '    •  Click Other Actions in the blue bar'+'\r\n\t'+
            '    •  Select Assign to Someone Else from the drop down'+'\r\n\t'+
            '    •  Enter the required information (New signer name & email)'+'\r\n\t'+
            '    •  Click Assign to Someone Else'+'\r\n\r\n'+
            
            'Please note: this will change the signature to the new recipient; however, if you enter content into the original document, DocuSign will not retain that information for the recipient.'+'\r\n\r\n'+
            
            'Alternatively, you can complete the form and print the document for another individual to sign:'+'\r\n\r\n\t'+
            
            '    •  Click the Review Document button above'+'\r\n\t'+
            '    •  Fill out the form to the best of your knowledge'+'\r\n\t'+
            '    •  Click Other Actions in the blue bar'+'\r\n\t'+
            '    •  Select Print & Sign from the drop-down'+'\r\n\t'+
            '    •  Select Upload, then click Continue'+'\r\n\t'+
            '    •  Click Download, which will generate a PDF version of the form'+'\r\n\t'+
            '    •  Print the form for signature'+'\r\n\t'+
            '    •  Fax the form back to your local chapter at'+' '+currentParentCase.contact.Region_Chapter__r.Fax+'\r\n\r\n'+   
            
           
            'Thank you for helping us get closer to achieving our vision of granting every eligible childs wish. Together, we create life-changing wishes for children with critical illnesses.'+
            '\r\n\r\n'+
            
            'Thank You,'+'\r\n\r\n'+
            'Make-A-Wish®'; 
            string emailbody;
            if(currentParentCase.Wish_Clarence_Attachment__c   == 'Yes'){
            emailbody = withAttachmentemailbody;
            }
            else{
            emailbody = withOutAttachmentemailbody;
            }
            String subject;
            String lastInitial = currentParentCase.Contact.lastname;
            lastInitial = lastInitial.left(1);
             for(DocuSignCredentialsSetting__c credentialIns : credentialSetting.values()){
                account = credentialIns.account__c;
                IntegratorKey  = credentialIns.IntegratorKey__c;
            }
            
            
           if(currentParentCase.Rush__c  != true){
               //String type = apexpages.currentpage().getparameters().get('clearenceType');
               System.debug('parameter'+type);
               If( type == 'WishClearanceNoTravel'){
                   If(currentParentCase.Contact.Gender__c != 'Self-describe' )
                      templateID = label.Wish_Clearance_No_Travel;
                    else
                        templateID = label.Wish_Clearance_No_Travel_Form_Self_describe; 
                   subject = 'Signature Required – Make-A-Wish Wish Clearance No Travel Form: '+currentParentCase.Contact.firstname+' '+lastInitial+'.';
              } else{
                   templateID = label.WishClearence;
                   subject = 'Signature Required – Make-A-Wish Wish Clearance Form: '+currentParentCase.Contact.firstname+' '+lastInitial+'.';
             }
           }
            
           if(currentParentCase.Rush__c  == true ){
               If( type == 'WishClearanceNoTravel'){
                   If(currentParentCase.Contact.Gender__c != 'Self-describe' )
                      templateID = label.Wish_Clearance_No_Travel_Form_Rush_Wish;
                    else
                        templateID = label.Wish_Clearance_No_Travel_Rush_Wish_Form_Self_describe; 
                   subject = 'Signature Required – Make-A-Wish Rush Wish Clearance No Travel Form: '+currentParentCase.Contact.firstname+' '+lastInitial+'.';
               }
               else{
                   templateID = label.Rush_Wish_Clearance;
                   subject = 'Signature Required – Make-A-Wish Rush Wish Clearance Form: '+currentParentCase.Contact.firstname+' '+lastInitial+'.';
               }
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
            String json='{'+ 
                ' '+ 
                ' "emailSubject": "'+subject+'",'+
                ' "emailBlurb": "This is emailblurb",'+ 
                ' "templateId": "'+templateID+'",'+ 
                ' "envelopeIdStamping": "false",'+ 
                ' "customFields":{'+
                '    "textCustomFields":['+
                '      {'+
                '        "name":"##SFCase",'+
                '        "required":"true",'+
                '        "show":"false",'+
                '        "value":"'+currentParentCase.Id+'"'+
                '      }'+
                '    ]'+
                '  },'+
                ' "templateRoles": ['+ 
                '{'+ 
                '"roleName": "Signer 1",'+ 
                '"name": "'+name+'",'+ 
                '"email": "'+email+'",'+
                 '"emailNotification": {'+
              '"emailSubject": "'+subject+'",'+
              '"emailBody": "'+emailbody+'",'+
              '"supportedLanguage": "en"'+
              '},'+
                '},'+ 
                 '{'+ 
                '"roleName": "Signer 3",'+ 
                '"name": "'+name+'",'+ 
                '"email": "'+email+'",'+
                 '"emailNotification": {'+
              '"emailSubject": "'+subject+'",'+
              '"emailBody": "'+emailbody+'",'+
              '"supportedLanguage": "en"'+
              '},'+
                '},'+ 
                ' ],'+ 
                ' "status": "sent"'+ 
                '}'; 
            req.setBody(json); 
            Http http = new Http(); 
            HTTPResponse res; 
            try{ 
                
                res = http.send(req); 
                system.debug('DocuSign Response'+ res.getBody()); 
            } 
            catch(Exception e){ 
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage())); 
            } 
            WrapperDocuSign wrapInst = WrapperDocuSign.parse(res.getBody()); 
           
    
    }
    public pageReference cancel(){
        PageReference reference=new PageReference('/'+currentParentCase.Id);
        reference.setRedirect(true);     
        return reference;
        
    }
    
    public pagereference DisplayMessage(){
        If(type == 'WishClearanceNoTravel'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'The Wish Clearance No Travel form has been sent successfully.'));
        }
       else
       {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'The Wish Clearance form has been sent successfully.'));
       }return null;
    }
    
    public pagereference DisplayErrorMessage(){
        if(medicalProfContactName == Null)
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select Recipient'));
        if(currentParentCase.wish_involves_air_travel__c == Null && type != 'WishClearanceNoTravel')
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select Wish Involves Air Travel'));
        if(currentParentCase.Description == Null )
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please add a value to Description on the case page.'));
        if(currentParentCase.Wish_Clarence_Attachment__c == Null)
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select the value to Attachment field.'));
        if(medicalProfConMap.containsKey(medicalProfContactName)){
         if(medicalProfConMap.get(medicalProfContactName).npe4__RelatedContact__r.Email == Null)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The contact you have selected has no email address available. Please add email on the contact record and try to send the form again.'));
        }
        return null;
    }
    
    public void displayAttachment(){
     if(currentParentCase.Wish_Clarence_Attachment__c == 'Yes')
     isAttachment = true;
     else
     isAttachment = false;
    }
}