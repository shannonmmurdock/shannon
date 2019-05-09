@isTest
public class CustomLookUpController_Test 
{
    public static  testmethod void customLookUp()
    {   
        Contact confamily = OrientationandTrainingUtil.CreateWishFamily();
        List<String> additionalAttributes = new List<String>();
        additionalAttributes.add('Email');
        additionalAttributes.add('Phone');
        customLookUpController.fetchLookUpValues('MAWAFirstName','Contact',additionalAttributes);
    }
}