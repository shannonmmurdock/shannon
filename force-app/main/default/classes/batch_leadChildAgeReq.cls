global class batch_leadChildAgeReq implements Database.Batchable<Sobject> {

    
    global Database.QueryLocator start(Database.BatchableContext bc) {

        return database.getQueryLocator([SELECT Id,DOB__c,Child_currentAge__c, Status, Age_Requirement_Met__c FROM Lead WHERE Status = 'Inquiry' AND Age_Requirement_Met__c = False
                                         //(CALENDAR_MONTH(DOB__c) =: sixMonthbefore) AND 
                                         //(DAY_IN_MONTH(DOB__c) =: todayDate OR DAY_IN_MONTH(DOB__c) = 30 OR (DAY_IN_MONTH(DOB__c) = 28 AND CALENDAR_MONTH(DOB__c) = 2))
                                        ]);        
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        
        List<lead> updateLeads = new List<lead>();
        Set<Id> updateLeadIds = new Set<Id>();
        
        for (Lead leads : scope) {
        Integer birthMonth = leads.DOB__c.month();  
    	Integer birthDay = leads.DOB__c.day();
        Integer currentMonth =  System.Today().Month();
        Integer sixMonthbefore = System.Today().Month()+6;
        Integer todayDate = System.Today().Day();
         
            if(birthMonth == sixMonthbefore && birthDay == System.today().Day()){ 
            	Lead newLead = new Lead();
                newLead.Id = leads.Id;
                newLead.Age_Requirement_Met__c = true;
                //leads.Age_Requirement_Met__c = true;
            	//updateLeads.add(leads);
            	updateLeads.add(newLead);
            }

            //updateLeads.add(leads);
            
        }
        //if(updateLeads.size()>0){
           // System.debug('@@updateLeads list size: ' + updateLeads.size());
            //update updateLeads;
        //}
    }
    
    global void finish(Database.BatchableContext bc){

    }
}