public class SendIAtoJDE {
    
    public class JDE_JSON_BODY {
        public String itemNumberShort;
        public String secondItemNumber;
        public String thirdItemNumber;
        public String description;
        public String searchText;
        public String brand;
        public String size;
        public String pack;
        public String vintage;
        public String beverageCode;
        public String proof;
        public String region;
        public String appellation;
        public String categoryCodeNine;
        public String varietal;
        public String color;
        public String masterPlanningFamily;
        public String groupWarehouseProcessOne;
        public Integer carrierNumber;
        public String selections;
        public String UoM_Primary;
        public String UoM_Secondary;
        public String UoM_Purchasing;
        public String UoM_Pricing;
        public String UoM_Shipping;
        public String UoM_Production;
        public String UoM_Component;
        public String UoM_Weight;
        public String UoM_Volume;
        public String UoM_VolumeOrWeight;
        public String Category_GL;
        public String level_SalesBasePrice;
        public String level_InventoryCost;
        public String gradePotencyPricing;
        public String checkAvailability;
        public String bulkPackedFlag;
        public String stockingType;
        public String lineType;
        public String backordersAllowed;
        public String serialNumbersRequired;
        public Integer shelfLifeDays;
        public String planningCode;
        public String orderPolicyCode;
        public Integer quantityAccountingCost;
        public String leadTime;
        public String commitmentMethod;
        public String UPCNumber;
        public String UoM_UPC;
        public integer bestBeforeDefaultDays;
        public String commitmentDateMethod;
        public String lotExpirationMethod;
        public Integer sellByDefaultDays;
        
        
    }
    
    @future (callout=true)
    public static void makeJDECallout(Set<Id> itemIds) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String username = 'KAPOORV';
        String password = '8082siNg';
        //String password = '8083siNg';
        
        request.setEndpoint('http://ais-dv920.twg.com:9081/jderest/orchestrator/ItmvalOrchItemCreationUsingP4101');
        //request.setEndpoint('https://api.ipify.org?format=json');
        //request.setEndpoint('https://80c67499-9c99-4db7-a1a4-49b55fabf419.mock.pstmn.io/test');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        //request.setHeader('proxySet', 'true');
        // Set the body as a JSON object
        // 
        String a = 'test';
        
        List<Item__c> items = queryItems(itemIds);
        
        for (Item__c i : items) {
            JDE_JSON_BODY json_body = new JDE_JSON_BODY();
            json_body.itemNumberShort = i.Short_Item_Number_SKU__c;
            //json_body.secondItemNumber = a;
            // json_body.thirdItemNumber = a;
            json_body.description = a;
            json_body.searchText = i.Marketing_Product_Name__c;
            json_body.brand = i.Brand_Name__c;
			json_body.size = i.Size__c;
            json_body.pack = i.Base_Units_per_Case__c;
            json_body.vintage = i.Vintage__c;
            json_body.beverageCode = i.Beverage_Code__c;
            json_body.proof = i.Proof__c;
            json_body.region = i.State_Region__c;
            json_body.appellation = i.Appellation_Code__c;
            json_body.categoryCodeNine = i.Category_Code_9__c;
            json_body.varietal = i.Varietal__c;
            json_body.color = i.Color_classification__c;
            json_body.masterPlanningFamily = i.Master_Planning_Family__c;
            json_body.groupWarehouseProcessOne = i.Group_Warehouse_Process_1__c;
            if (i.Carrier_Number__c != null) json_body.carrierNumber = Integer.valueOf(i.Carrier_Number__c);
            json_body.selections = i.Selection__c;
            //json_body.UoM_Primary = a;
            json_body.UoM_Secondary = i.UoM_Secondary__c;
            json_body.UoM_Purchasing = i.UoM_Purchasing__c;
            json_body.UoM_Pricing = i.UoM_Pricing__c;
            json_body.UoM_Shipping = i.UoM_Shipping__c;
            json_body.UoM_Production = i.Production_UOM__c;
            json_body.UoM_Component = i.UoM_Component__c;
            json_body.UoM_Weight = i.UoM_Weight__c;
            json_body.UoM_Volume = i.UoM_Volume__c;
            json_body.UoM_VolumeOrWeight = a;
            json_body.Category_GL = i.Category_GL__c;
            json_body.level_SalesBasePrice = i.Level_Sales_Base_Price__c;
            json_body.level_InventoryCost = i.Level_Inventory_Cost__c;
            json_body.gradePotencyPricing = i.Grade_Potency_Pricing__c;
            json_body.checkAvailability = i.Check_Availability__c;
            json_body.bulkPackedFlag = i.Bulk_Packed__c;
            json_body.stockingType = 'V';
            
            //json_body.lineType = i.Line_Type__c;
            json_body.lineType = 'S';
            
            json_body.backordersAllowed = i.Backorders_Allowed__c;
            json_body.serialNumbersRequired = i.Serial_Number_Required__c;
            if (i.Shelf_Life_Days__c != null) json_body.shelfLifeDays = Integer.valueOf(i.Shelf_Life_Days__c);
            json_body.planningCode = i.Planning_Code__c;
            json_body.orderPolicyCode = i.Order_Policy_Code__c;
            if (i.Quantity_Accounting_Cost__c != null) json_body.quantityAccountingCost = Integer.valueOf(i.Quantity_Accounting_Cost__c);
            json_body.leadTime = i.Fixed_or_Variable_Lead_Time__c;
            json_body.commitmentMethod = i.Commitment_Method__c;
            json_body.UPCNumber = a;
            json_body.UoM_UPC = i.UoM_UPC__c;
            if (i.Best_Before_Default_Days__c != null) json_body.bestBeforeDefaultDays = Integer.valueOf(i.Best_Before_Default_Days__c);
            json_body.commitmentDateMethod = i.Commitment_Date_Method__c;
            json_body.lotExpirationMethod = i.Lot_Expiration_Calculation__c;
            if (i.Sell_by_Default_Days__c != null) json_body.sellByDefaultDays = Integer.valueOf(i.Sell_by_Default_Days__c);
            
            // request.setBody(JSON.serialize(json_body));
            // 
            //request.setBody(getJSONTEST());
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' +
                             response.getStatusCode() + ' ' + response.getStatus());
                system.debug('body: ' + request.getBody());
                system.debug('Request: ' + request.getHeader('Authorization'));
                System.debug(response.getBody());
            } else {
                System.debug(response.getBody());
                system.debug('body: ' + json_body);
            }
        }
        //return response;
    }

    public static HttpResponse makeGETCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.androidhive.info/contacts/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'contacts' key as a list
            List<Object> contacts = (List<Object>) results.get('contacts');
            System.debug('Received the following contacts:');
            for (Object contact: contacts) {
                System.debug(contact);
            }
        }
        return response;
    }
    
    public static string getJSONTEST() {
        JSONGenerator gen = JSON.createGenerator(false);
        //gen.writeStartArray();
        
        
        gen.writeStartObject();
        
        gen.writeStringField('description', 'test1');
        gen.writeStringField('stockingType', 'V');
        gen.writeStringField('2ndItemNo', 'TEST ITEM ORCHCLIENT21');
        gen.writeStringField('3rdItemNo', 'TEST ITEM ORCHCLIENT21');
        gen.writeStringField('lineType', 'S');
        
        gen.writeEndObject();
                    
        //gen.writeEndArray();
        return gen.getAsString();
    }
    
    public static List<Item__c> queryItems (Set<Id> ids){

        List<Item__c> returnItems = new List<Item__c>();
        // Initialize setup variables
        String objectName = 'Item__c';  // modify as needed
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
            query += ' ' + s + ', ';
        }
        
        // Manually add related object's fields that are needed.
        //query += 'Account.Name,'; // modify as needed
        // Strip off the last comma if it exists.
        /*if (query.subString(query.Length()-1,query.Length()) == ','){
            system.debug('has comma');
            query = query.subString(0,query.Length()-1);
        }*/
        system.debug(query.right(20));
        query = query.removeEnd(', ');
        system.debug(query.right(20));
        // Add FROM statement
        query += ' FROM ' + objectName;
        
        Set<String> stringSet = new Set<String>( (List<String>)new List<Id>( ids ) );
        
         List<String> idList = new List<String>(stringSet);
        // Add on a WHERE/ORDER/LIMIT statement as needed
        //query += ' WHERE Id IN ' + idList[0] + ''; // modify as needed
        query += ' WHERE Id = \'' + idList[0] + '\''; // modify as needed
        system.debug(query.right(100));
        //try {
            returnItems = database.query(query);
        //} catch (QueryException e){
           // system.debug(e);
            system.debug(query);
        //}
        return returnItems;
    }
}