/***************************************************************************
Author : MAWA
Created Date : 4/25/2019
Description : This class is used to schedule batch_leadChildAge class
****************************************************************************/
global class batch_LeadChildAgeReqSchedule implements Schedulable{

    global void execute(SchedulableContext SC){
        Database.executeBatch(new batch_leadChildAgeReq(),200);
    }
}