public class AccountTriggerHelper {
    public AccountTriggerHelper() {

    }

    public static void onAfterAccountInsert(List<Account> newAccountList, Map<Id,Account> newAccountMap){
        Set<Id> accountIdSet = new Set<Id>();
        Id jobId;
        accountIdSet = newAccountMap.keySet();

        if(accountIdSet.size() > 0){
            jobId = System.enqueueJob(new AttachPdf(accountIdSet));
        }
    }
}
