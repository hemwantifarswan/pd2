/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (
    after update
    ,after delete
    ,after undelete
) {
    Map<Id,Order> orders = trigger.newMap;
    
    if ( Trigger.New != null ){

        OrderHelper.AfterUpdate(trigger.new, trigger.old);            
    }
    
}