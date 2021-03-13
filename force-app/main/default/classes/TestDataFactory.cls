/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.

        CollaborationGroup cg = new CollaborationGroup(
            Name = 'TEST'+ Constants.INVENTORY_ANNOUNCEMENTS,
            CollaborationType = 'Public'
        );
        return cg;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        List<Product2> productList = new List<Product2>();
        
        for(Integer i=0; i< cnt; i++){
            Product2 p = new Product2(Name='Test Product '+i, Initial_Inventory__c = 10, IsActive = true);
            p.Family=Constants.PRODUCT_FAMILY.get(math.mod(i,4)).getValue();
            productList.add(p);
        }
        return  productList;
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
        for(Product2 p: prods){
            PriceBookEntry pbe = new PriceBookEntry();
            pbe.Product2Id = p.Id;
            pbe.UnitPrice = 0;
            pbe.IsActive = true;
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pbeList.add(pbe);
        }
        return pbeList;

        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> acclist = new List<Account>();
        for(Integer i=0; i< cnt; i++){
            Account acc = new Account(Name = 'Test Account '+i);
            acclist.add(acc);
        }
        return acclist;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> clist= new List<Contact>();
        for(integer i = 0; i < cnt; i++){
            Contact c = new Contact(Lastname = 'Test Contact '+i, AccountId=accts.get(i).Id);
            clist.add(c);
        }
        return clist;

    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static  List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> orderList = new List<Order>();
        for(Integer i=0; i < cnt ; i++){
            Order o = new Order(name = 'order '+i);
            o.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            o.accountid = accts.get(i).Id;
            o.status = 'Draft';
            o.EffectiveDate = System.today();
            orderList.add(o);
        }
        return orderList;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> items = new List<OrderItem>();
        for(Integer i=0;i<cnt;i++){
            OrderItem ord = new OrderItem();
            ord.Quantity = Constants.DEFAULT_ROWS;
            ord.UnitPrice = 250;
            ord.OrderId =ords.get(Math.mod(i, ords.size())).Id;
            ord.PricebookEntryId = pbes.get(math.mod(i, pbes.size())).Id;
            items.add(ord);
        }
        
        return items;

    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        CollaborationGroup groups = TestDataFactory.ConstructCollaborationGroup();
        insert groups;
        
        List<Product2>  products= TestDataFactory.ConstructProducts(cnt);
        insert products;
        
        List<PriceBookEntry> entries = TestDataFactory.ConstructPricebookEntries(products);
        insert entries;
        
        List<Account> accts = TestDataFactory.ConstructAccounts(cnt);
        insert accts;
        
        List<Contact> contacts = TestDataFactory.ConstructContacts(cnt,accts);
        insert contacts;
        
        List<Order> orders = TestDataFactory.ConstructOrders( cnt,  accts);
        insert orders;
        
        List<OrderItem> items = TestDataFactory.ConstructOrderItems(cnt, entries, orders);
        insert items;
    }
    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals((updatedProduct.Quantity_Ordered__c - originalProduct.Quantity_Ordered__c), qtyOrdered);
    }

}