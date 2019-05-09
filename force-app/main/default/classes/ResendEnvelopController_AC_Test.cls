@isTest
public class ResendEnvelopController_AC_Test {
    
    @isTest
    public static void resendEnvelope_test(){
        
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
        
        ResendEnvelopController ctrl = new ResendEnvelopController();
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        ctrl.resendEnvelop(dsfs.dsfs__DocuSign_Envelope_ID__c, 'Test', 'Test@Test.com', true);
        ResendEnvelopController.chapterNameByCase(wish.Id);
        List<dsfs__DocuSign_Status__c> dbstatusList = [SELECT Id,
                                                       dsfs__Sent_Date_Time__c,
                                                       dsfs__DocuSign_Envelope_ID__c 
                                                       FROM dsfs__DocuSign_Status__c  
                                                       WHERE dsfs__DocuSign_Envelope_ID__c =: dsfs.dsfs__DocuSign_Envelope_ID__c 
                                                       AND dsfs__Sent_Date_Time__c != null];
        
        List<dsfs__DocuSign_Recipient_Status__c> dbRecipientList = [SELECT Id,
                                                                    dsfs__Date_Sent__c,
                                                                    dsfs__Envelope_Id__c 
                                                                    FROM dsfs__DocuSign_Recipient_Status__c 
                                                                    WHERE dsfs__Envelope_Id__c =: dsfs.dsfs__DocuSign_Envelope_ID__c
                                                                    AND dsfs__Date_Sent__c != null];
        
        Test.StopTest();
        System.assertEquals(dbstatusList.size(), 1);
        System.assertEquals(dbRecipientList.size(), 1);         
    }
    
    @isTest
    public static void singleAbsentParentDocusign_Test_1(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
        
        Map<String,String> config = new  Map<String,String>();
        config.put('email','Test@Test.com');
        config.put('guardian','Not Listed');
        config.put('subject','Signature Required - Absent Parent Form');
        config.put('pageLabel','absent');
        config.put('selectedForm','TestForm');
        config.put('miniorParticipantName','Test Name');
        config.put('currentPageId', (String) wish.Id);
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        ResendEnvelopController.singleAbsentParentDocusign(config);
        Test.StopTest();
    }
    
    @isTest
    public static void singleAbsentParentDocusign_Test_2(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
        
        Map<String,String> config = new  Map<String,String>();
        config.put('email','Test@Test.com');
        config.put('guardian','Test Gaurdian');
        config.put('subject','Signature Required - Single Parent Form');
        config.put('pageLabel','parent');
        config.put('selectedForm','TestForm');
        config.put('miniorParticipantName','Test Name');
        config.put('currentPageId', (String) wish.Id);
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        ResendEnvelopController.singleAbsentParentDocusign(config);
        Test.StopTest();
    }
    
    @isTest
    public static void signNowEnvelop_test_1(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
        
        ResendEnvelopController ctrl = new ResendEnvelopController();
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        ctrl.signNowEnvelop(dsfs.dsfs__DocuSign_Envelope_ID__c, 'test', (String)wish.Id, 'WishInformationForm_VF');
        Test.StopTest();
    }
    
    @isTest
    public static void signNowEnvelop_test_2(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
        
        ResendEnvelopController ctrl = new ResendEnvelopController();
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        ctrl.signNowEnvelop(dsfs.dsfs__DocuSign_Envelope_ID__c, 'test', (String)wish.Id, 'WishLiabilityForm_VF');     
        Test.StopTest();
    }
    
    @isTest
    public static void signNowEnvelop_test_3(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
        
        ResendEnvelopController ctrl = new ResendEnvelopController();
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();       
        ctrl.signNowEnvelop(dsfs.dsfs__DocuSign_Envelope_ID__c, 'test', (String)wish.Id, 'WishFormWishGranting_VF');      
        Test.StopTest();
    }
    
    @isTest
    public static void signNowEnvelop_test_4(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
        
        ResendEnvelopController ctrl = new ResendEnvelopController();
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();       
        ctrl.signNowEnvelop(dsfs.dsfs__DocuSign_Envelope_ID__c, 'test', (String)wish.Id, 'WishLiabilityWishGranting_VF');
        
        Test.StopTest();
    }
     @isTest
    public static void updateDocusignStatus_test(){
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
        
        ResendEnvelopController ctrl = new ResendEnvelopController();
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();       
        ctrl.updateDocusingStatus(dsfs.dsfs__DocuSign_Envelope_ID__c, chapterAcc.Name);
        
        Test.StopTest();
    }
    
       @isTest
    public static void comboFormSendEnvelopTest(){
        Constant_AC cons = new Constant_AC();
        Id comboRecordTypeId = Schema.Sobjecttype.Minor_Participant__c.getRecordTypeInfosByName().get(cons.comboRecord).getRecordTypeId();
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild =  OrientationandTrainingUtil.CreateWishChild();
        case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        OrientationandTrainingUtil.insertDocusignSetting();
        dsfs__DocuSign_Status__c dsfs = OrientationandTrainingUtil.createDocusignStatuswithCase(wish.Id);
        dsfs__DocuSign_Recipient_Status__c dsfsRecipient = OrientationandTrainingUtil.CreatedsfsRec(dsfs.Id);
       
        Minor_Participant__c createcomboRec = new Minor_Participant__c();
        createcomboRec.Hidden_Combo_FirstName__c = 'TesFirstName';
        createcomboRec.Hidden_Combo_MiddleName__c = 'MiddleName';
        createcomboRec.Hidden_Combo_LastName__c = 'TestLastName';
        createcomboRec.Hidden_Combo_Relationship__c = 'father';
        createcomboRec.Hidden_Combo_DOB__c = system.today() - 1232;
        createcomboRec.Hidden_Combo_Street__c = 'TestStreet';
        createcomboRec.Hidden_Combo_City__c = 'Trichy';
        createcomboRec.Hidden_Combo_State__c = 'Arizona';
        createcomboRec.Hidden_Combo_HomePhone__c = '9600467559';
        createcomboRec.Hidden_Combo_MobilePhone__c = '8056913402';
        createcomboRec.Hidden_Combo_TelePhone__c = '9003910426';
        createcomboRec.Hidden_Combo_Email__c = 'test@gmail.com';
        createcomboRec.Hidden_Combo_ContactId__c = wishChild .Id; 
        createcomboRec.Hidden_Combo_Zipcode__c = '621010';
        createcomboRec.RecordTypeId = comboRecordTypeId;
        createcomboRec.Case__c = wish.Id;
        insert createcomboRec; 
        
        Map<String,String> config = new  Map<String,String>();
        config.put('email','Test@Test.com');
        config.put('guardian','Not Listed');
        config.put('subject','Signature Required - Combo Family Form & Liability/Publicity Release Form');
        config.put('pageLabel','absent');
        config.put('selectedForm','TestForm');
        config.put('miniorParticipantName','Test Name');
        config.put('currentPageId', (String) wish.Id);
        
        Test.setMock(HttpCalloutMock.class, new Mock_ResponseGenerator()); 
        Test.StartTest();
        ResendEnvelopController.comboFormSendEnvelop(config,createcomboRec.Id);
        Test.StopTest();
    }
}