public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();        
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }
        RollUpOrderItems(orderIds);
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        Map<Id, Product2> productMap = new Map<Id, Product2>();
 
        for ( OrderItem oi : [
                    SELECT Id, Product2Id, Product2.Quantity_Ordered__c, Quantity
                    FROM OrderItem
                    WHERE OrderId IN: activatedOrderIds
        ]){            
            productMap.put(oi.Product2Id,oi.Product2);           
        }

        AggregateResult[] aggregatedResults  = [SELECT Product2Id, SUM(Quantity) aggregatedQuantity FROM OrderItem WHERE Product2Id In :productMap.keySet() GROUP BY Product2Id];
        for (AggregateResult ar : aggregatedResults)  {
            Product2 p = productMap.get((String)ar.get('Product2Id'));
            p.Quantity_Ordered__c = Integer.valueOf(ar.get('aggregatedQuantity'));
        }
        try {
            if(productMap != null && productMap.size() > 0){
                update productMap.values();
            }
        }catch ( Exception e ){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

}