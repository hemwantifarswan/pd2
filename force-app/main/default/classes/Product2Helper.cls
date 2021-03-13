public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList){
        //ToDo: Declare a List of Product2 records named needsAnnouncement
        List<Product2> needsAnnouncement = new List<Product2>();

        //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
        Map<String, Inventory_Setting__mdt> invSettingMap = new Map<String, Inventory_Setting__mdt>();

        //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
        List<Inventory_Setting__mdt> invSettings = [SELECT Id, DeveloperName, Low_Quantity_Alert__c FROM Inventory_Setting__mdt];

        //ToDo: Loop through the Products in newList
        for(Inventory_Setting__mdt e : invSettings) {
            invSettingMap.put(e.DeveloperName, e);
          }

        // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
        // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
        //      add it to the needsAnnouncement list
        for(Product2 c : newList) {
            if(invSettingMap.containsKey(c.Family) && c.Quantity_Remaining__c < invSettingMap.get(c.Family).Low_Quantity_Alert__c) {
              needsAnnouncement.add(c);
            }
          }

        //ToDo: Pass records to the postAlerts method
        PostAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
            ConnectApi.AnnouncementInput k = new ConnectApi.AnnouncementInput();
            k.expirationDate = Date.today().addDays(1);
            k.sendEmails = false;
            k.parentId = COLLABORATION_GROUP[0].Id;

            textSegmentInput.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            messageBodyInput.messageSegments = new List<ConnectApi.messageSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);
            k.body = messageBodyInput;

            toPost.add(k);
        }
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
        AnnouncementQueueable n = new AnnouncementQueueable();
        n.toPost = toPost;
        System.enqueueJob(n);
    }
}