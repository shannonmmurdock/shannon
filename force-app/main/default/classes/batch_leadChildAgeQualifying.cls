global class batch_leadChildAgeQualifying implements Database.Batchable<Sobject> {
    
    global integer recordsProcessed = 1;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Integer currentMonth =  System.Today().Month();
        Integer sixMonthbefore = System.Today().Month()+6;
        Integer todayDate = System.Today().Day();
        return database.getQueryLocator([SELECT Id,DOB__c,Child_currentAge__c, Status, Age_Requirement_Met__c  FROM Lead
                                         WHERE Status = 'Inquiry' AND
                                         (CALENDAR_MONTH(DOB__c) =: sixMonthbefore) AND 
                                         (DAY_IN_MONTH(DOB__c) =: todayDate OR DAY_IN_MONTH(DOB__c) = 30 OR (DAY_IN_MONTH(DOB__c) = 28 AND CALENDAR_MONTH(DOB__c) = 2))]);        
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        for (Lead leads : scope) {
            //List<Lead> leadsUpdate = new List<Lead>();
            leads.Age_Requirement_Met__c = true;
            //leadsUpdate.add(leads);
            update leads;
        }
        //try {
        	//update scope;    
        //update leadsUpdate;
        //    system.debug('@@@@'  + scope[0].Id);
      //  }
       // catch(exception e){
      //      system.debug(e);
       // }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email 
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
    }
}