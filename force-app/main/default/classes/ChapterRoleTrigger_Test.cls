/* ---------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class ChapterRoleTrigger_Test{
    
    //Used to create a Chapter Role record for National Staff as Owner.
    private testmethod static void  createChapterRole(){
        Chapter_Vs_Role__c arizonaChap = OrientationandTrainingUtil.createArizonaChapter();
        Chapter_Vs_Role__c alabamaChap = OrientationandTrainingUtil.createAlabamaChapter();
        Insert alabamaChap;
        Insert arizonaChap;
        
        User currUser = [SELECT id from User where id = :Userinfo.getUserId() limit 1]; 
        User nationalStaff;
        System.RunAs(currUser)
        {     
            nationalStaff = OrientationandTrainingUtil.createUserWithRole([select Id from UserRole where Name='National Staff'].Id); 
        }
        
        System.runAs(nationalStaff) {            
            Chapter_Role__c newChapRole = new Chapter_Role__c();
            newChapRole.Chapter_Name__c = OrientationandTrainingUtil.createchapterAccount().Id;
            Role__c newRole = new Role__c();
            newRole.Name = 'Wish Granter';
            newRole.isWishRole__c = true;
            insert newRole;
            Role__c newRole1 = new Role__c();
            newRole1.Name = 'Wish Granter1';
            newRole1.isWishRole__c = true;
            insert newRole1;
            
            newChapRole.Role_Name__c = newRole.Id;
            newChapRole.OwnerId= nationalStaff.Id;
            insert newChapRole;
            newChapRole.Role_Name__c = newRole1.Id;
            Update newChapRole;
            System.assertEquals('National Staff',[SELECT UserRole.Name FROM User WHERE Id =:nationalStaff.Id].userRole.Name);
            System.assertEquals(nationalStaff.Id,[SELECT OwnerId FROM Chapter_Role__c WHERE Id =:newChapRole.Id].OwnerId);
            
            
        }
    }   
}