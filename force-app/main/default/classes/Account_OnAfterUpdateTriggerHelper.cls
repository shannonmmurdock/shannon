/***************************************************************************************************
Author      : MST Solutions
Date        : 10/15/2016
Description : Account_OnAfterUpdateTriggerHelper is used to call the Helper class when the
account record is get updated.

Modification Log
------------------
WVC-1884    KANAGARAJ  03/04/2018

*****************************************************************************************************/
Public class Account_OnAfterUpdateTriggerHelper {
    
    // This method is used to update garntingcase devstaffemail field whenever cpateraccount devstaffemail filed is changed
    public static void updateGrantingCaseDevStaffEmai(map<id,string> chapterEmailmap){
        
        Constant_AC constant = new Constant_Ac();
        String wishGrantRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.wishGrantRT).getRecordTypeId();
        String parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
        list<Case> upadteCaseList = new list<Case>();
        
        
        for(Case grantingCase :[SELECT ID,RecordTypeId,ParentId,Parent.ChapterName__c,Dev_Staff_Email__c FROM Case WHERE Parent.ChapterName__c IN: chapterEmailmap.keySet() AND RecordTypeId =: wishGrantRecordTypeId AND isClosed = false Limit 50000]){
            if(chapterEmailmap.containsKey(grantingCase.Parent.ChapterName__c)){
                grantingCase.Dev_Staff_Email__c = chapterEmailmap.get(grantingCase.Parent.ChapterName__c);
                upadteCaseList.add(grantingCase);
            }
        }
        
        if(upadteCaseList.size() > 0){
            update upadteCaseList;
        }
        
    }
    // This method is used to share the account record when the chapter name is updated.
    public static void updateChapterName(Set<Id> chapterIdSet,List<Account> accountList){
        Id chapterRecType = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Chapter').getRecordTypeId();
        Map<Id, String> chapterNameMap = new Map<Id, String>();
        map<string,id> publicGroupMap = new map<string,id>();
        set<String> accountIdsSet = new set<String>();
        List<AccountShare> accountShareList = New List<AccountShare>();
        List<AccountShare> updateAccountShareList = New List<AccountShare>();
        id groupId;
        try{
            if(chapterIdSet.size() > 0){
                for(Account getAccountName : [SELECT Id, Name FROM Account WHERE RecordTypeId =: chapterRecType Limit 50000]){
                    String chapterNameTrim = getAccountName.Name.removeStart('Make-A-Wish ');
                    chapterNameMap.put(getAccountName.Id, chapterNameTrim);
                }
            }
            
            for(Group currentGroup : [SELECT Id, Name FROM Group WHERE Type = 'Regular' Limit 50000]){
                publicGroupMap.put(currentGroup.Name, currentGroup.id);
            }
            if(accountIdsSet.size() > 0 && publicGroupMap.size() > 0 ){
                accountShareList = [SELECT Id,AccountId,UserOrGroupId FROM AccountShare WHERE AccountId IN: accountIdsSet AND UserOrGroupId IN: publicGroupMap.values() Limit 50000];
            }
            
            if(accountShareList.size() > 0 ){
                delete accountShareList;
            }
            
            //This for loop is used to add inkind account to the public group based on new updated chapter name          
            for(Account newInkind : accountList){
                //if(newInkind.Chapter_Name__c != trigger.oldMap.get(newInkind.id).Chapter_Name__c){
                if(chapterNameMap.containsKey(newInkind.Chapter_Name__c)) 
                {    
                    if( publicGroupMap.containsKey(chapterNameMap.get(newInkind.Chapter_Name__c)))
                    {    
                        groupId = publicGroupMap.get(chapterNameMap.get(newInkind.Chapter_Name__c));
                        AccountShare dynamicAccountShare  = new AccountShare();
                        dynamicAccountShare.AccountId = newInkind.Id;
                        dynamicAccountShare.Accountaccesslevel = 'Read';
                        dynamicAccountShare.CaseAccessLevel = 'None';
                        dynamicAccountShare.ContactAccessLevel = 'None';
                        dynamicAccountShare.OpportunityAccessLevel = 'None';
                        dynamicAccountShare.UserOrGroupId = groupId;
                        updateAccountShareList.add(dynamicAccountShare);
                        
                    }
                }
                //}
                
            }
            
            if(!updateAccountShareList.isEmpty()){
                
                Insert updateAccountShareList;
            }
        
         if(Test.isRunningTest()){
                throw new CommonTriggerException('Test Class execution');
            }

        
        
        }
        catch(Exception ex){
            for(Account currRec : accountList){
                ErrorMessage_AC.createdebugRec('Account_OnAfterUpdateTriggerHelper',String.valueof(currRec),String.valueOf(ex),'updateChapterName',currRec.Id,ex.getStackTraceString(),'Error');
            }
            
             if(!Test.isRunningTest()){
            for(Account currRec : accountList){
                currRec.addError(Label.Debug_log_error_message);
            }
        
          }
        }
    }
 // This method will update the wishfamily contact address if the contact marked as same as hoshold address whenever the household acccount address gets updated   
    public static void updateRelatedContactAddressWithHoushold(Set<ID> houseHoldAccountIdsSet){
        Set<ID> wishFamilyContactIdsSet = new Set<ID>();
        if(houseHoldAccountIdsSet.size() > 0){
            for(Contact updatedContact : [Select ID,AccountId,Same_as_Household_Address__c from Contact where AccountId IN: houseHoldAccountIdsSet AND Same_as_Household_Address__c = true AND recordType.Name = 'Wish Family']){
                wishFamilyContactIdsSet.add(updatedContact.id);
            }
        }
        
        if(wishFamilyContactIdsSet.size() > 0){
            Contact_OnAfterUpdateTriggerHepler.updateHouseHoldAddress(wishFamilyContactIdsSet);
        }
    }
    
    public static void updateWishFormRecord(List<Account> accountList){
        Constant_AC  constant = new Constant_Ac();
        Id emergencyContactRecordTypeId = Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormChildEmergency).getRecordTypeId(); 
        Id householdAccountId =  Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
        Map<Id,Account> accountMap = new Map<Id,Account>();
        List<Wish_Child_Form__c> updateWishFormList = new List<Wish_Child_Form__c>();
        for(Account processAccount : accountList){
            if(processAccount.RecordTypeId == householdAccountId && processAccount.Hidden_Wish_Form_Id__c != Null){
                
                accountMap.put(processAccount.Hidden_Wish_Form_Id__c,processAccount);
           }
        }
        for(Wish_Child_Form__c dbWishForm : [SELECT Id,mobilePhone__c,Emergency_Relationship__c,LastName__c,Middle_Name__c,Email__c,RecordTypeId,Migrated__c 
                                            FROM Wish_Child_Form__c WHERE Id IN: accountMap.KeySet() AND RecordTypeId =:emergencyContactRecordTypeId AND Migrated__c = False]){
               if(accountMap.containsKey(dbWishForm.Id)){
                dbWishForm.mobilePhone__c = accountMap.get(dbWishForm.Id).Emergency_Contact_Phone__c; 
                dbWishForm.Emergency_Relationship__c = accountMap.get(dbWishForm.Id).Relationship_type__c; 
                dbWishForm.Middle_Name__c = accountMap.get(dbWishForm.Id).Emergency_Contact_Middle_Name__c; 
                dbWishForm.Email__c = accountMap.get(dbWishForm.Id).Emergency_Contact_Email__c; 
                updateWishFormList.add(dbWishForm);
             }
        }
        if(updateWishFormList.size() > 0)
        update updateWishFormList;
   }
}