global class batch_BUpdateAffiliation_AC implements Database.Batchable<sObject>  {
    
    global Database.QueryLocator start(Database.BatchableContext BC)  {
        return Database.getQueryLocator([select id,npe5__Contact__c,npe5__Status__c from npe5__Affiliation__c where npe5__Contact__r.recordType.Name = 'Volunteer Contact' AND (npe5__Status__c != 'Active' AND npe5__Status__c != 'Pending' ) AND npe5__Primary__c = true]);
    }
    
    global void execute(Database.BatchableContext BC, List<npe5__Affiliation__c> AffiliationList)  {
        // Declarations
Set<ID> volunteerIdsSet = new Set<ID>();
List<Volunteer_Roles__c> volRoleList = new List<Volunteer_Roles__c>();
map<id,list<Volunteer_Roles__c>> volunteerRoleStatusMap = new map<id,list<Volunteer_Roles__c>>();

//Fetch affiliation records based on the volunteer contact and primary

for(npe5__Affiliation__c currAff:AffiliationList){
    volunteerIdsSet.add(currAff.npe5__Contact__c);
}

//Fetch Volunteer role records based on the volunteerIdsSet

for(Volunteer_Roles__c currVolRole:[SELECT ID,Status__c,Volunteer_Name__c from Volunteer_Roles__c WHERE Volunteer_Name__c IN:volunteerIdsSet]){
    if(volunteerRoleStatusMap.containsKey(currVolRole.Volunteer_Name__c))
    {
        volunteerRoleStatusMap.get(currVolRole.Volunteer_Name__c).add(currVolRole);
    }
    else
    {
        volunteerRoleStatusMap.put(currVolRole.Volunteer_Name__c, new list<Volunteer_Roles__c>{currVolRole});
    }
    volRoleList.add(currVolRole);
}

// Call the apex method to execute the functionality
if(volunteerRoleStatusMap.size() > 0)
{
    system.debug('Number of records'+volunteerRoleStatusMap.size());
   VolunteerRole_OnAfterInsertHelper_AC.updateVolunteerRoleStatus(volunteerRoleStatusMap,'Update',volRoleList);
}

    }
    global void finish(Database.BatchableContext BC) {
        
    }
}