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
		- suplierName: VARCHAR (40)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## Services Providers
		- providerId: serial auto-increment (PK)
		- countryId: integer (FK)
		- addressId: integer (FK)
		- providerName: VARCHAR (40)
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
		- userId: integer (FK)
		- contactTypeId: integer (FK)
		- value: VARCHAR (100)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
				
			
----------------- MASTER - DETAIL ---------------------------------------------------
		
	
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
		- name: VARCHAR (50)
		- isActive: BOOLEAN
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedBy: integer (FK)
		
		## Products
		- ProductId: serial auto-increment (PK)
		- categoryId: integer (FK)
		- unitOfMeasureId: integer (FK)
		- name: VARCHAR (40)
		- description: VARCHAR (100)
		- isEnabled: boolean
		
		## PurchaseOrders
		- purchaseOrderId: serial auto-increment (PK)
		- supplierId: integer (FK)
		- incotermId: integer (FK)
		- statusTypeId: integer (FK)
		- paymentMethodId: integer (FK)
		- currencyId: integer (FK)
		- billOfLadinNumber: VARCHAR (12)
		- orderDate: DATE
		- expectedShipDate: DATE
		- shippingDate: DATE
		- estimatedDateOfArrival: DATE
		- customsClearanceDate: DATE
		- actualDeliveryDate: DATE
		- createdBy: integer (FK)
		- updatedBy: integer (FK) 
		
		## PurchaseOrdersDetails
		- purchaseDetailId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- productId: integer (FK)
		- quantityOrdered: integer
		- quantityReceived: integer
		- unitPrice: NUMERIC (6, 2)
		- subTotal: NUMERIC (10, 2)
		- batchNumber: VARCHAR (20)
		- expirationDate: DATE
		- createdBy: integer (FK)
		- updatedBy: integer (FK)

		## PurchaseOrdersLandedCosts
		- purchaseCostsId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- providerId: integer (FK)
		- costTypeId: integer (FK)
		- totalAmount: NUMERIC (10, 2)
		- currencyId: integer (FK)
		- description: VARCHAR (150)
		
		
		
		