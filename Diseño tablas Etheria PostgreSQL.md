# tablas

------------------- ADRESS PATTERN --------------------------------------------------

		## Countries
		- countryId: serial auto-increment (PK)
		- isoCode: UNIQUE VARCHAR (3) 
		- name: VARCHAR (50)

		## States
		- stateId: serial auto-increment (PK)
		- countryId: integer (FK)
		- name: VARCHAR (40)

		## Cities
		- cityId: serial auto-increment (PK)
		- stateId: integer (FK)
		- name: VARCHAR (50)

		## Addresses
		- addressId: serial auto-increment (PK)
		- cityId: integer (FK)
		- address1: VARCHAR (100)
		- address2: VARCHAR (100)
		- zipCode: VARCHAR (20)
		
----------------- OTHER IMPORTANT TABLES / CONTACT INFO PATTERN ----------------------		
		
		## Employees
		- employeeId: serial auto-increment (PK)
		- addresId: integer (FK)
		- firstname: VARCHAR (20)
		- lastname: VARCHAR (20)
		- available: BOOLEAN
		- hiringDate: DATE
		- createdAt: TIMESTAMP
		- updatedAt: TIMESTAMP
		- updatedByEmployeeId: integer (FK)
		
		## ContactTypes
		- contactTypeId: serial auto-increment (PK)
		- name: VARCHAR (10)
		- isActive: BOOLEAN
		
		## EmployeeContacts
		- employeeContactId: serial auto-increment (PK)
		- employeeId: integer (FK)
		- contactTypeId: integer (FK)
		- value: TEXT
		- isPrincipal: BOOLEAN
		
		## Incoterms
		- incotermId: serial auto-increment (PK)
		- code: UNIQUE VARCHAR (3)
		- description: VARCHAR (100)
		
			
----------------- MASTER - DETAIL ---------------------------------------------------

		## Suppliers
		- supplierId: serial auto-increment (PK)
		- addresId: integer (FK)
		- suplierName: VARCHAR (40)
	
		## SuppliersContacts
		- supplierContactId: serial auto-increment (PK)
		- supplierId: integer (FK)
		- contactTypeId: integer (FK)
		- value: TEXT
		- isPrincipal: BOOLEAN
	
		## StatusTypes
		- StatusTypeId: serial auto-increment (PK)
		- name: VARCHAR (15)
		
		## ProductsCategories
		- categoryId: serial auto-increment (PK)
		- name: VARCHAR (40)
		- description: VARCHAR (100)
		
		## UnitsOfMeasure
		- unitsOfMeasure: serial auto-increment (PK)
		- symbol: UNIQUE VARCHAR (5)
		- name: VARCHAR (25)
		
		## PaymentMethods
		- paymentMethodId: serial auto-increment (PK)
		- name: VARCHAR (30)
		
		## CostsTypes
		- costTypeId: serial auto-increment (PK)
		- name: VARCHAR (50)
		
		## Products
		- ProductId: serial auto-increment (PK)
		- categoryId: integer (FK)
		- unitOfMeasureId: integer (FK)
		- name: VARCHAR (40)
		- dateOfImportation: DATE
		- description: VARCHAR (100)
		- isEnabled: boolean
		
		## PurchaseOrders
		- purchaseOrderId: serial auto-increment (PK)
		- supplierId: integer (FK)
		- incotermId: integer (FK)
		- statusTypeId: integer (FK)
		- paymentMethodId: integer (FK)
		- order_date: DATE
		- madeBy: integer (FK)
		
		## PurchaseOrdersDetails
		- purchaseDetailId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- ProductId: integer (FK)
		- quantity: NUMERIC
		- unitPriceUSD: NUMERIC

		## PurchaseOrdersLandedCosts
		- purchaseCostsId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- costTypeId: integer (FK)
		- amountUSD: NUMERIC
		- description: VARCHAR (150)
		
		
		
		