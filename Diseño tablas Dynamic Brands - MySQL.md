# Tablas mySQL (Dynamic Brands)
==============================================================
|          				   Currency	                     	 | 
==============================================================
## Currency
- currencyId : INT AUTO_INCREMENT (PK)
- name : VARCHAR(50)				
- simbol : VARCHAR(1)				

## currencyRates
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

## addressType
- addressTypeId : INT AUTO_INCREMENT(PK) 
- addressTypeName : VARCHAR(100) -- Trabajo, hogar, etc.

## addresses
- addressId : INT AUTO_INCREMENT (PK)
- cityId : INT (FK)			
- addressTypeId : INT(FK)		
- address1 : VARCHAR(100)				
- address2 : VARCHAR(100)
- postalCode VARCHAR(20)			
- latitude : DECIMAL(10, 8)
- longitude : DECIMAL(10, 8)

==============================================================
|          				HUB NICARAGUA                    	 | 
==============================================================
## batch
- batchId : INT AUTO_INCREMENT (FK)
- batchNumber : INT 
- batchDescription : VARCHAR(150)
- enabled : BOOLEAN

## UnitsOfMeasures
- unitOfMeasureId: INT AUTO_INCREMENT (PK)
- symbol: UNIQUE VARCHAR (5)
- name: VARCHAR (30)

## productCategories
- productCategoryId : INT AUTO_INCREMENT (PK)
- name : VARCHAR(40)					
- description : VARCHAR(100)
- healthRiskLevel : VARCHAR(20)			

## BrandsPositionsTypes
- brandTypeId : INT AUTO_INCREMENT (PK)
- brandTypeName : VARCHAR(50)			
- brandTypeDescription : VARCHAR(100)	


## products
- productId : INT AUTO_INCREMENT (PK)
- productCategoryId : INT (FK)	
- unitOfMeasureId : INT (FK)		
- productName : VARCHAR (100)				
- enabled : BOOLEAN

## productAttributes
- attributeId : INT AUTO_INCREMENT (PK)
- attributeName : VARCHAR(50) -- (Ej: "Aroma", "Viscosidad", "Grado de Pureza")
- enabled : BOOLEAN

## categoryAttributes
- categoryAttributeId : INT AUTO_INCREMENT (PK)
- productCategoryId : INT (FK)
- attributeId : INT (FK)

## productAttributeValues
- valueId : INT AUTO_INCREMENT (PK)
- productId : INT (FK)
- attributeId : INT (FK)
- valueText : VARCHAR(255)  -- (Ej: "Menta", "Alta", "5.5")
- updatedAt : TIMESTAMP
- updatedBy : INT (FK)      -- userId
- checksum : VARBINARY(32) 

## hubZones
- zoneId : INT AUTO_INCREMENT (PK)
- zoneName : VARCHAR(50) -- (Cuarto Frío, Muelle, Carga, Peligrosos)
- enabled : BOOLEAN

## hubLayout
- locationId : INT AUTO_INCREMENT (PK)
- zoneId : INT(FK) 
- aisle : VARCHAR(10)    -- (Pasillo)
- shelf : VARCHAR(10)    -- (Estante)
- bin : VARCHAR(10)      -- (Caja/Gaveta)

## productInventory
- inventoryId : INT AUTO_INCREMENT (PK)
- productId : INT (FK)
- batchId : INT (FK)
- currentStock : INT
- locationId : INT (FK)
- lastUpdated : TIMESTAMP

## productPriceHistory
- priceHistoryId : INT AUTO_INCREMENT (PK)
- productId : INT (FK)
- websiteId : INT (FK)
- newPrice : DECIMAL(10,2)
- changeDate : TIMESTAMP

==============================================================
|          				     Website 	                     |
==============================================================
## websites
- websiteId : INT AUTO_INCREMENT (PK)
- countryId : INT (FK) 				
- brandName : VARCHAR(150)				
- domain : VARCHAR(32)					
- marketingFocus : VARCHAR(200)			
- enabled : BOOLEAN																	
- creadetAt : TIMESTAMP										

## websiteThemes
- themeId : INT AUTO_INCREMENT (PK)
- websiteId : INT (FK)
- themeName : VARCHAR(50)
- colors : JSON
- fonts : JSON
- logoUrl : VARCHAR(255)
- enabled : BOOLEAN

## websitesProducts
- websiteProductId : INT AUTO_INCREMENT (PK)
- websiteId : INT (FK)					
- productId : INT (FK)					
- displayName : VARCHAR(100)			
- displayPriceLocal : DECIMAL(10,2)		
- enabled : BOOLEAN						
- brandTypeId : INT (FK)		
- currencyId : INT (FK)
- rateId : INT (FK)


==============================================================
|          				        users 	                     |
==============================================================

## users
- userId : INT AUTO_INCREMENT (PK)			 	
- name : VARCHAR(50)					
- lastName : VARCHAR(50)				
- email : VARCHAR(100)		
- password : VARBINARY			
- phone : INT 							
- creadetAt : TIMESTAMP					
- enabled : BOOLEAN						

## usersAddresses
- userAddressId : INT AUTO_INCREMENT (PK)
- userId : INT (FK)					
- addressID : INT (FK)					
- enabled : BOOLEAN						
- checksum : VARBINARY					


==============================================================
|          				   orders	 	                     |
==============================================================
## ordersStatus
- orderStatuId : INT AUTO_INCREMENT (PK)
- orderStatusName : VARCHAR(20)			
- orderStatuDescription : VARCHAR(100)	

## orders
- orderId : INT AUTO_INCREMENT(PK)
- websiteId : INT (FK)
- userId : INT (FK)
- countryId : INT (FK)
- orderStatuId : INT (FK)
- orderNumber : INT
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
## shippingMethods
- methodId : INT AUTO_INCREMENT (PK)
- methodName : VARCHAR(50) 		-- (Aéreo, Marítimo, Terrestre Moto, Terrestre Camión)
- enabled : BOOLEAN

## priceShippingMethod
- priceMethodId : INT AUTO_INCREMENT (PK)
- methodId : INT (FK)
- price : DECIMAL(10,2)

## shippingCarriers
- carrierId : INT AUTO_INCREMENT (PK)
- shippingCarrierName : VARCHAR(50)
- lastName : VARCHAR(30)
- contactInfo : VARCHAR(100)
- trackingTemplate : VARCHAR(200)
- enabled : BOOLEAN

## shipmentsStatus
- shipmentStatusId : INT AUTO_INCREMENT (PK)
- shipmentStatusName : VARCHAR(20)
- description : VARCHAR(50)

## shipments
- shipmentId : INT AUTO_INCREMENT(PK)
- orderId : INT (FK)
- methodId : INT (FK)
- carrierId : INT (FK)
- shipmentStatusId : INT (FK)
- addressId : INT (FK)
- shippedAt : DATETIME
- deliveredAt : DATETIME
- estimatedDeliveryDaye : DATE
- shippingTaxId : INT (FK)

## shipmentsStatusHistory
- shipmentHistoryId : INT AUTO_INCREMENT (PK)
- shipmentId : INT (FK)
- shipmentStatusId : INT (FK)
- statusDate : DATETIME
- notes : VARCHAR(150)
- evidence : VARCHAR(255)
- addressId : INT (FK)


==============================================================
|        	taxes and restriction per product	 	         |                                     
==============================================================
## taxesTypes
- taxTypeId : INT AUTO_INCREMENT(PK)
- taxTypeName : VARCHAR(100)
- taxTypeDescription : VARCHAR(150)

## shippingTaxes
- shippingTaxId : INT AUTO_INCREMENT (PK)
- countryId : INT (FK)
- taxPercent : DECIMAL (5,2)
- description : VARCHAR (50)

## taxesPerCountry
- taxId : INT AUTO_INCREMENT(PK)
- countryId : INT (FK)
- taxTypeId : INT (FK)
- validFrom : DATE						
- validUntil : DATE	
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
- healthRegistrationNumber : VARCHAR(50)
- registrationExpiration : DATE
- restrictionDescription : VARCHAR(150)
- enabled : BOOLEAN

==============================================================
|        					logs              	 	         |                                     
==============================================================
## sessions
- sessionId : INT AUTO_INCREMENT (PK)
- userId : INT(FK)
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
- metadata : JSON 			

## systemErrorsLogs
- errorId : INT AUTO_INCREMENT (PK)
- severityId : INT (FK)
- processUuid : VARCHAR(100)
- processName : VARCHAR(100)
- stepName : VARCHAR(100)
- inputData : JSON
- errorMesage : TEXT
- creadetAt : DATE 

## statusTransactionType
- statusTypeId : INT AUTO_INCREMENT (PK)
- statusName : VARCHAR(50) 
- statusDescription : VARCHAR(150)

## spTransactionState
- stateId : INT AUTO_INCREMENT (PK)
- orderId : INT (FK, NULL) 
- statusTypeId : INT (FK)
- stepName : VARCHAR(100) 
- executionTime : TIMESTAMP
- observations : TEXT 