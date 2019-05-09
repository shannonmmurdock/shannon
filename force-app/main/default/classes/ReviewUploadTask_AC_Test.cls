// Created by:MST
// This class used to do the unit testing of the functionality
@IsTest
public class ReviewUploadTask_AC_Test {
    @isTest static void testGetContactById(){
        Contact wishchildContact = OrientationandTrainingUtil.CreateWishChild();
        List<task> tasklist = new list<Task>();
        RestRequest request = new RestRequest();
        request.requestUri = 'https://yourInstance.salesforce.com/services/apexrest/Contact/'+ wishchildContact.id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        tasklist = ReviewUploadTask_AC.getUploadInterviewTask();
        tasklist = VolunteerInterviewTaskRest_AC.getClassOffering();
        
    }

}