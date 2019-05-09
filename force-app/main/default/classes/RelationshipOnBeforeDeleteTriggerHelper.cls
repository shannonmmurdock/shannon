/*****************************************************************************************************************
Author      : MST Solutions
Date        : 07/09/2018
Description : This Handler is used to when the relationship record get deleted then it will aslo delete the corresponding wish form record.
Modification Log: 
07/09/2018 - Kanagaraj - WVC-2082
*******************************************************************************************************************/
public class RelationshipOnBeforeDeleteTriggerHelper{
    
    static Constant_AC  constant = new Constant_Ac();
    static Id familyContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
    static Id medicalProfRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Medical Professional').getRecordTypeId();
    static Id parentWishRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(constant.parentWishRT).getRecordTypeId();
    static Id ContactFamilyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(constant.wishFamilyRT).getRecordTypeId();
    static Id wishFormRecordTypeId= Schema.SObjectType.Wish_Child_Form__c.getRecordTypeInfosByName().get(constant.WishFormFamily).getRecordTypeId();
    
    public static void deleteWishFormRecord(Set<Id> contactIdSet){
        List<Wish_Child_Form__c> wishFormList = new List<Wish_Child_Form__c>();
        List<Contact> contactList = new List<Contact>();
        for(Wish_Child_Form__c dbWishChildForm : [SELECT Id,Contact__c,RecordTypeId,Migrated__c  FROM Wish_Child_Form__c 
                                                 WHERE Contact__c IN:contactIdSet AND RecordTypeId =: wishFormRecordTypeId AND Migrated__c =: False]){
           wishFormList.add(dbWishChildForm); 
        }
        for(Contact dbContact : [SELECT Id,Hidden_Wish_Form_Id__c FROM Contact WHERE Id IN: contactIdSet]){
           dbContact.Hidden_Wish_Form_Id__c = null;
           contactList.add(dbContact);
        }
        if(wishFormList.size() > 0 && contactList.size() > 0){
        update contactList;
        delete wishFormList;
        }
    }
}