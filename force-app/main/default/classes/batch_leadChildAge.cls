/***************************************************************************
Author : MAWA
Created Date : 4/25/2019
Description : This class is used to set the Age_Requirement_Met__c field to 
			  True on lead when a wish child turns 2.5 years old.
****************************************************************************/
global class batch_leadChildAge implements Database.Batchable<Sobject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return database.getQueryLocator([SELECT Id,DOB__c,Child_Age__c, Status, Age_Requirement_Met__c 
                                         FROM Lead WHERE Status = 'Inquiry' AND Age_Requirement_Met__c = False AND (Child_Age__c = 'Under 2.5' OR Child_Age__c = '2')]);        
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        
        List<lead> updateLeads = new List<lead>();
        
        for (Lead leads : scope) {
            Integer birthMonth = leads.DOB__c.month();  
            Integer birthDay = leads.DOB__c.day();
            Integer birthYear = leads.DOB__c.Year();
            Integer currentMonth =  System.Today().Month();
            Integer sixMonthbefore = System.Today().Month()+6;
            Integer threeYearsBefore = System.Today().Year()-3;
            Integer todayDate = System.Today().Day();
            
            if(birthMonth == sixMonthbefore && birthDay == System.today().Day() && birthYear == threeYearsBefore){ 
                leads.Age_Requirement_Met__c = true;
            }
            
            updateLeads.add(leads);
        }
        
        if(updateLeads.size()>0){
            update updateLeads;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}