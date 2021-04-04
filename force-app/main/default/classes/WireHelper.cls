public class WireHelper {

    private static Integer pricePerKg = 50;
    
    @AuraEnabled(cacheable=true)   
    public static Decimal getBillAmount(Integer qty){

        Decimal billAmount = qty * pricePerKg;
        Decimal discount = 10;   // 10% discount

        if(qty < 2){                        
            billAmount = billAmount - (discount/100)*billAmount;

        }else{
            discount = 15;  //  15% discount
            billAmount = billAmount - (discount/100)*billAmount;
        }

        return billAmount;
    }

    /*
    *  if (year is not divisible by 4) then (it is a common year)
    *  else if (year is not divisible by 100) then (it is a leap year)
    *  else if (year is not divisible by 400) then (it is a common year)
    *  else (it is a leap year)
    */     
    @AuraEnabled(cacheable=true)
    public static boolean checkLeapYear(Integer year){
        system.debug('---year is: '+year);
        Integer mod = Math.mod(year,4);
        if(mod != 0){
            return false;
        }else if(Math.mod(year,100) != 0){
            return true;
        }else if(Math.mod(year,400) != 0){
            return false;
        }else{
            return true;
        }   
    }
}
