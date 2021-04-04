public class EasyPartnerAccountsController {
    public EasyPartnerAccountsController() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getPartners(){
        try {
            List<Account> accList= [SELECT Id,Name FROM Account];
            return accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
