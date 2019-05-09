@isTest
Public class InkindandReimbursement_Test
{
    
    static testmethod void createRecords()
    {
        Account chapterAcc = OrientationandTrainingUtil.createchapterAccount();
        Contact wishChild = OrientationandTrainingUtil.CreateWishChildwithAcc(chapterAcc.Id);
        Case wish = OrientationandTrainingUtil.CreateParentCase(wishChild.Id);
        Document document;
        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'InkindPDF';
        document.IsPublic = true;
        document.Name = 'InkindPDF';
        document.FolderId = [select id from folder where name = 'Drawloop Files'].id;
        insert document;
        // Test.setCurrentPage(Page.InkindandReimbursement_VF);
        //Test.setCurrentPage(pageRef);          
        //InkindandReimbursement_AC controller = new InkindandReimbursement_AC(new ApexPages.StandardController(wish));
        //controller.ReturnToWish();
        
        PageReference pageRef = Page.InkindandReimbursement_VF;
        pageRef.getParameters().put('recId', String.valueOf(wish.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(wish);
        Test.setCurrentPage(pageRef);        
        InkindandReimbursement_AC controller = new InkindandReimbursement_AC (sc);
        controller.ReturnToWish();
        
    }
}