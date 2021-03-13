public without sharing class ChartHelper {

    @AuraEnabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();

        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        AggregateResult[] aggregatedResults = [SELECT Family, SUM(Quantity_Remaining__c) Qty from product2 where  IsActive = true and Quantity_Remaining__c > 0 GROUP BY Family];
        for(AggregateResult ar: aggregatedResults){
            cht.add(new ChartData(String.valueOf(ar.get('Family')), Integer.valueOf(ar.get('Qty'))));
        }
        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}