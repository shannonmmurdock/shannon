/*****************************************************************************************************************
Author      : MST Solutions
Date        : 5/31/2018
Description : This class is update the case based on user choice from the popup message.
*******************************************************************************************************************/

global class Case_ReadytoInterview_Popup_AC{ 

   webservice static String UpdateCaseStatus(String caseId , String Status){  
          If(Status == 'Ready to Interview'){
              Case obj = [select id,status,Sub_Status__c,Wish_Type__c ,Hidden_bypass_Validation__c,OwnerId from Case where id=: caseId];
              Case updateCase = new Case();
              updateCase.Status = obj.Hidden_bypass_Validation__c.left(obj.Hidden_bypass_Validation__c.IndexOf('/'));
              updateCase.Sub_Status__c = obj.Hidden_bypass_Validation__c.substring(obj.Hidden_bypass_Validation__c.indexOf('/')+1);
              String validation = 'Please Enter the value for Wish Type';
              If(updateCase.Status == 'Wish Determined' && updateCase.Sub_Status__c == 'Within Policy' && obj.Wish_Type__c == Null){
                  updateCase.Id = obj.Id;
                  updateCase.Status = obj.Status;
                  updateCase.Sub_Status__c =obj.Sub_Status__c;
                  updateCase.Hidden_bypass_Validation__c = '';
                  Update updateCase;
                  return validation;
              
              }else{
                  updateCase.Id = obj.Id;           
                  updateCase.Hidden_bypass_Validation__c = 'Proceed Rush Wish';
                  update updateCase;          
                  return obj.Id;
              }
          }
          else {
              system.debug('Before');
              Case obj = [select id,Sub_Status__c ,status,Hidden_bypass_Validation__c from Case where id=: caseId];          
              obj.Hidden_bypass_Validation__c = '';
              update obj;
              system.debug('After Update'+obj);
              return obj.Id;
          }
    }
   /* webservice static Id UpdateCaseStatus(String caseId , String Status){  
          If(Status == 'Ready to Interview'){
              Case obj = [select id,status,Sub_Status__c ,Hidden_bypass_Validation__c,OwnerId from Case where id=: caseId];
              obj.Status = 'Ready to Interview';
              obj.Sub_Status__c = obj.Hidden_bypass_Validation__c.substring(obj.Hidden_bypass_Validation__c.indexOf('/')+1);
              obj.Hidden_bypass_Validation__c = 'Proceed Rush Wish';
              update obj;          
              return obj.Id;
          }
          else {
              system.debug('Before');
              Case obj = [select id,Sub_Status__c ,status,Hidden_bypass_Validation__c from Case where id=: caseId];          
              obj.Hidden_bypass_Validation__c = '';
              update obj;
              system.debug('After Update'+obj);
              return obj.Id;
          }
    }*/
  
 }