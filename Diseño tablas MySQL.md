# Tablas mySQL (Dynamic Brands)

==============================================================
|          				   Currency	                     	 |                                     
==============================================================
## Currency
- currencyId : INT AUTO_INCREMENT (PK)
- name : VARCHAR(50)				
- simbol : VARCHAR(1)				

## currencyRates (Nueva)
- rateId : INT AUTO_INCREMENT (PK)
- currencyId : INT (FK)
- exchangeRate : DECIMAL(18,6) 
- rateDate : DATE

==============================================================
|          				   Addresses	                     |                                     
==============================================================


## countries
- countryId : INT AUTO_INCREMENT (PK)
- isoCode : VARCHAR(3) 	 				
- countryName : VARCHAR (50) 			
- currencyId : INT (FK)  				
- enabled : BOOLEAN 	 				

## estates
- estateId : INT AUTO_INCREMENT (PK)
- countryId : INT (FK)					
- estateName : VARCHAR(70)				

## cities
- cityId : INT AUTO_INCREMENT(PK)	
- estateId : INT (FK)					
- cityName : VARCHAR(100)				

## addresses
- addressId : INT AUTO_INCREMENT (PK)
- cityId : INT (FK)					
- address1 : VARCHAR(100)				
- address2 : VARCHAR(100)
- - postalCode VARCHAR(20)			


==============================================================
|          				   Products 	                     |                                     
==============================================================

## product_categories
- productCategoryId : INT AUTO_INCREMENT (PK)
- name : VARCHAR(40)					
- description : VARCHAR(100)			

## BrandsPositionsTypes
- brandTypeId : INT AUTO_INCREMENT (PK)
- brandTypeName : VARCHAR(50)			
- brandTypeDescription : VARCHAR(100)	

## products
- productId : INT AUTO_INCREMENT (PK)
- productCategoryId : INT (FK)			
- productName : VARCHAR (100)			
- attributes : JSON						
- batchBase : VARCHAR(50)	
- lotNumber : INT	
- stockQuantity :  INT

==============================================================
|          				     Website 	                     |                                     
==============================================================

## websites
- websiteId : INT AUTO_INCREMENT (PK)
- countryId : INT (FK) 					
- brandName : VARCHAR(150)				
- domain : VARCHAR(32)					
- marketingFocus : VARCHAR(50)			
- enabled : BOOLEAN						
- validFrom : DATE						
- validUntil : DATE						
- creadetAt : TIMESTAMP					
- theme : JSON							

## websitesProducts
- websiteProductId : INT AUTO_INCREMENT (PK)
- websiteId : INT (FK)					
- productId : INT (FK)					
- displayName : VARCHAR(100)			
- displayPriceLocal : DECIMAL(10,2)		
- enabled : BOOLEAN						
- brandTypeId : INT (FK)				

## siteTemplates
- templateId : INT AUTO_INCREMENT (PK)
- websiteId : INT (FK)					
- theme : JSON            --(La plantilla de la pagina web, el header, colores, etc)


==============================================================
|          				   Customers 	                     |                                     
==============================================================

## customers
- customerId : INT AUTO_INCREMENT (PK)
- websiteId : INT (FK)				 	
- name : VARCHAR(50)					
- lastName : VARCHAR(50)				
- email : VARCHAR(100)					
- phone : INT 							
- creadetAt : TIMESTAMP					
- enabled : BOOLEAN						

## customersAddresses
- customerAddressId : INT AUTO_INCREMENT (PK)
- customerId : INT (FK)					
- addressID : INT (FK)					
- enabled : BOOLEAN						
- checksum : VARBINARY					


==============================================================
|          				   orders	 	                     |                                     
==============================================================

##ordersStatus
- orderStatuId : INT AUTO_INCREMENT (PK)
- orderStatusName : VARCHAR(20)			
- orderStatuDescription : VARCHAR(100)	

## orders
- orderId : INT AUTO_INCREMENT(PK)
- websiteId : INT (FK)
- customerId : INT (FK)
- countryId : INT (FK)
- orderStatuId : INT (FK)
- netAmountLocal : DECIMAL(10,2)
- taxAmountLocal : DECIMAL(10,2)
- totalGrossLocal : DECIMAL(10,2)
- orderDate : DATE
- netAmountUSD : DECIMAL(10,4) 
- rateId : INT (FK)

## orderItems
- orderItemId : INT AUTO_INCREMENT (PK)
- orderId : INT (FK)
- productId : INT (FK)
- quantity : INT
- itemPriceLocal : DECIMAL(10,2)
- itemPriceUSD : DECIMAL(10,2)
- taxLocal : DECIMAL(10,2) 
- itemTotalLocal : DECIMAL(10,2)
- itemTotalUSD : DECIMAL(10,2)

==============================================================
|            		orderTransportation	 	                 |                                     
==============================================================

## shippingCarriers
- carrierId : INT AUTO_INCREMENT (PK)
- name : VARCHAR(50)
- lastName : VARCHAR(30)
- contactInfo : VARCHAR(100)
- trackingTemplate : TEXT

## shipmentsStatus
- shipmentStatusId : INT AUTO_INCREMENT (PK)
- name : VARCHAR(20)
- description : VARCHAR(50)

## shipments
- shipmentId : INT AUTO_INCREMENT(PK)
- orderId : INT (FK)
- carrierId : INT (FK)
- shipmentStatusId : INT (FK)
- addressId : INT (FK)
- shippedAt : DATETIME
- deliveredAt : DATETIME
- estimatedDeliveryDaye : DATE
- shippingTaxUSD : DECIMAL(5, 2)

## shipments_status_history
- shipmentHistoryId : INT AUTO_INCREMENT (PK)
- shipmentId : INT (FK)
- shipmentStatusId : INT (FK)
- statusDate : DATETIME
- notes : VARCHAR(150)


==============================================================
|        	taxes and restriction per product	 	         |                                     
==============================================================

## taxesPerCountry
- taxId : INT AUTO_INCREMENT(PK)
- countryId : INT (FK)
- productCategoryId : INT (FK)
- tax_percent DECIMAL(5,2)
- enabled : BOOLEAN

## restrictionsTypes
- restrictionTypeId : INT AUTO_INCREMENT (PK)
- restrictionTypeName : VARCHAR (50)
- restrictionTypeDescription : VARCHAR(100)

## productRestrictionsPerCountry
- restrictionId : INT AUTO_INCREMENT (PK)
- productId : INT (FK)
- countryId : INT (FK)
- restrictionTypeId : INT (FK)
- restrictionDescription : TEXT
- enabled : BOOLEAN

==============================================================
|        					logs              	 	         |                                     
==============================================================

## sessions
- sessionId : INT AUTO_INCREMENT (PK)
- customerId : INT(FK)
- sessionToken : VARCHAR(100)
- creadetAt : TIMESTAMP

## eventsTypes
- eventTypeId : INT AUTO_INCREMENT (PK)
- name : VARCHAR(50)
- description : VARCHAR(150)

## dataObjects
- dataObjectId : INT AUTO_INCREMENT(PK)
- name : VARCHAR(50)
- description : VARCHAR(100)

## severities
- severityId : INT AUTO_INCREMENT (PK)
- name : VARCHAR(50)
- description : VARCHAR(100)

## usersLogs
- logId : INT AUTO_INCREMENT(PK)
- eventType : INT(FK)
- dataObjectId : INT(FK)
- websiteId : INT(FK)
- sessionId : INT(FK)
- description : VARCHAR(255)
- creadetAt : TIMESTAMP
- metadata : JSON 			--(viewProduct, addToCart, Purchase, etc)

## systemErrorsLogs
- errorId : INT AUTO_INCREMENT (PK)
- severityId : INT (FK)
- processUuid : VARCHAR(100)
- processName : VARCHAR(100)
- stepName : VARCHAR(100)
- inputData : JSON
- errorMesage : TEXT
- creadetAt : DATE 