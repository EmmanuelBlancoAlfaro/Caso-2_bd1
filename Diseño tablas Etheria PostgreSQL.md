# tablas Etheria Globals

------------------- ADRESS PATTERN --------------------------------------------------

		## Countries
		- countryId: serial auto-increment (PK)
		- isoCode: UNIQUE VARCHAR (3) 
		- countryName: VARCHAR (50)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)

		## States
		- stateId: serial auto-increment (PK)
		- countryId: integer (FK)
		- stateName: VARCHAR (40)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)

		## Cities
		- cityId: serial auto-increment (PK)
		- stateId: integer (FK)
		- cityName: VARCHAR (50)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)

		## Addresses
		- addressId: serial auto-increment (PK)
		- cityId: integer (FK)
		- address: VARCHAR (100)
		- zipCode: VARCHAR (20)
		- latitude: NUMERIC (9,6)
		- longitude: NUMERIC (10,6)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
----------------- CONTACT INFO PATTERN ----------------------------------------------		
		
		## Employees
		- employeeId: serial auto-increment (PK)
		- addressId: integer (FK)
		- firstName: VARCHAR (20)
		- lastName: VARCHAR (20)
		- isActive: BOOLEAN
		- hiringDate: DATE
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## Suppliers 
		- supplierId: serial auto-increment (PK)
		- countryId: integer (FK)
		- addressId: integer (FK)
		- defaultCurrencyId: integer (FK)
		- supplierName: VARCHAR (40)
		- fdaRegistrationNumber: VARCHAR (50)
		- taxIdentificationNumber: VARCHAR (50)
		- isActive: BOOLEAN
		- isGmpCertified: BOOLEAN 
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## Services Providers
		- providerId: serial auto-increment (PK)
		- countryId: integer (FK)
		- addressId: integer (FK)
		- logisticsRoleId: integer (FK)
		- transportMethodId: integer (FK)
		- providerName: VARCHAR (40)
		- trackingPortalUrl: VARCHAR (255)
		- taxIdentificationNumber: VARCHAR (50)
		- specificAttributes: JSONB
		- liabilityInsuranceLimit: NUMERIC (12, 2)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## ContactTypes
		- contactTypeId: serial auto-increment (PK)
		- contactTypeName: VARCHAR (50)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		
		## Contacts
		- contactId: serial auto-increment (PK)
		- employeeId: integer (FK) [NULLABLE]
		- providerId: integer (FK) [NULLABLE]
		- supplierId: integer (FK) [NULLABLE]
		- contactTypeId: integer (FK)
		- value: VARCHAR (100)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
				
----------------- CURRENCY PATTERN --------------------------------------------------

		## Currencies
		- currencyId: serial auto-increment (PK)
		- currencySymbol: VARCHAR (5)
		- currencyName: VARCHAR (40)
		- isActive: BOOLEAN
		- postTime: TIMESTAMP
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)

		## ExchangeRates
		- exchangeRateId: serial auto-increment (PK)
		- currencyId1: integer (FK)
		- currencyId2: integer (FK)
		- exchangeRate: DECIMAL (18, 6)
		- postTime: TIMESTAMP
		- checkSum: BYTEA
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK) 

		## ExchangeHistories
		- exchangeHistoryId: serial auto-increment (PK)
		- startDateTime: TIMESTAMP
		- endDateTime: TIMESTAMP
		- currencyId1: integer (FK)
		- currencyId2: integer (FK)
		- exchangeRate: DECIMAL (18, 6)
		- postTime: TIMESTAMP
		- checkSum: BYTEA
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		- exchangeRateId: integer (FK)
			
----------------- MASTER - DETAIL ---------------------------------------------------
		
		## LogisticsRoles
		- logisticsRoleId: serial auto-increment (PK)
		- roleName: VARCHAR (40)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
	
		## TransportMethods
		- transportMethodId: serial auto-increment (PK)
		- transportName: VARCHAR (30)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
	
		## Incoterms
		- incotermId: serial auto-increment (PK)
		- incotermCode: UNIQUE VARCHAR (3)
		- description: VARCHAR (100)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
	
		## StatusTypes
		- StatusTypeId: serial auto-increment (PK)
		- statusName: VARCHAR (15)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## CountriesRegulations
		- countryRegulationId: serial auto-increment (PK)
		- countryId: integer (FK)
		- regulationName: VARCHAR (60)
		- documentURL: VARCHAR (150)
		- expiryDate: DATE
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## ProductsCategories
		- categoryId: serial auto-increment (PK)
		- categoryName: VARCHAR (40)
		- description: VARCHAR (100)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## UnitsOfMeasure
		- unitOfMeasureId: serial auto-increment (PK)
		- symbol: UNIQUE VARCHAR (5)
		- measureName: VARCHAR (25)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## PaymentMethods
		- paymentMethodId: serial auto-increment (PK)
		- paymentMethodName: VARCHAR (30)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## CostsTypes
		- costTypeId: serial auto-increment (PK)
		- costTypeName: VARCHAR (50)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## IncotermsRules
		- ruleId: serial auto-increment (PK)
		- incotermId: integer (FK)
		- costTypeId: integer (FK)
		- isImporterResponsibility: BOOLEAN
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## Products
		- productId: serial auto-increment (PK)
		- categoryId: integer (FK)
		- unitOfMeasureId: integer (FK)
		- productName: VARCHAR (40)
		- description: VARCHAR (100)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## PurchaseOrders
		- purchaseOrderId: serial auto-increment (PK)
		- supplierId: integer (FK)
		- paymentMethodId: integer (FK)
		- incotermId: integer (FK)
		- destinationAddressId: integer (FK)
		- supplierCurrencyId: integer (FK)
		- etheriaCurrencyId: integer (FK)
		- currentStatusId: integer (FK)
		- exchangeRate: DECIMAL (18, 6)
		- billOfLadingNumber: VARCHAR (12)
		- orderDate: DATE
		- duePaymentDate: DATE
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- createdBy: integer (FK)
		- updatedBy: integer (FK) 
		
		## PurchaseOrdersDetails
		- purchaseDetailId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- productId: integer (FK)
		- quantityOrdered: integer
		- quantityReceived: integer
		- originalUnitPrice: NUMERIC (10, 2)
		- originalSubTotal: NUMERIC (12, 2)
		- unitPriceUSD: NUMERIC (10, 2)
		- subTotalUSD: NUMERIC (12, 2)
		- batchNumber: VARCHAR (20)
		- expirationDate: DATE
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- createdBy: integer (FK)
		- updatedBy: integer (FK)
		
		## PurchaseOrdersLandedCosts
		- purchaseCostsId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- providerId: integer (FK)
		- costTypeId: integer (FK)
		- originalAmount: NUMERIC (10, 2)
		- exchangeRate: DECIMAL (18, 6)
		- totalAmountUSD: NUMERIC (10, 2)
		- currencyId: integer (FK)
		- description: VARCHAR (150)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- createdBy: integer (FK)
		- updatedBy: integer (FK)
		
		## PurchaseOrdersTracking
		- orderTrackingId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- statusTypeId: integer (FK)
		- currentAddressId: integer (FK)
		- eventDate: TIMESTAMP
		- auditInfo: JSONB
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	