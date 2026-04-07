# tablas

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

		## IncoTerms
		- incotermId: serial auto-increment (PK)
		- code: UNIQUE VARCHAR (3)
		- description: VARCHAR (100)

		## CostsTypes
		- costTypeId: serial auto-increment (PK)
		- name: VARCHAR (50)

		## Suppliers
		- supplierId: serial auto-increment (PK)
		- cityId: integer (FK)
		- companyName: VARCHAR (50)

		## StatusTypes
		- statusTypeId: serial auto-increment (PK)
		- name: VARCHAR (15)	

		## ProductsCategories
		- categoryId: serial auto-increment (PK)
		- name: VARCHAR (40)
		- description: VARCHAR (100)
		- isEnabled: boolean

		## UnitsOfMeasures
		- unitOfMeasureId: serial auto-increment (PK)
		- symbol: UNIQUE VARCHAR (5)
		- name: VARCHAR (30)

		## Hubs
		- hubId: serial auto-increment (PK)
		- cityId: integer (FK)
		- address: VARCHAR (40)
		- name: VARCHAR (40)

		## Storages
		- storageId: serial auto-increment (PK)
		- hubId: integer (FK)
		- name: VARCHAR (20)

		## RawProducts
		- rawProductId: serial auto-increment (PK)
		- categoryId: integer (FK)
		- unitOfMeasureId: integer (FK)
		- name: VARCHAR (40)
		- description: VARCHAR (100)
		- isEnabled: boolean

		## FinishedProducts
		- finishedProductId: serial auto-increment (PK)
		- name: VARCHAR (40)
		- description: VARCHAR (100)

		## BillOfMaterials
		- bomId: serial auto-increment (PK)
		- finishedProductId: integer (FK)
		- rawProductId: integer (FK)
		- quantityNeeded: NUMERIC

		## PurchaseOrders
		- purchaseOrderId: serial auto-increment (PK)
		- supplierId: integer (FK)
		- destinationCountryId: integer (FK)
		- incotermId: integer (FK)
		- statusTypeId: integer (FK)
		- order_date: DATE

		## PurchaseOrdersDetails
		- purchaseDetailId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- rawProductId: integer (FK)
		- quantity: NUMERIC
		- unitPriceUSD: NUMERIC

		## PurchaseOrdersLandedCosts
		- purchaseCostsId: serial auto-increment (PK)
		- purchaseOrderId: integer (FK)
		- costTypeId: integer (FK)
		- amountUSD: NUMERIC
		- description: VARCHAR (150)

		## RawInventoryBatches
		- rawBatchId: serial auto-increment (PK)
		- rawProductId: integer (FK)
		- purchaseDetailId: integer (FK)
		- storageId: integer (FK)
		- lotNumber: VARCHAR (50)
		- initialQuantity: NUMERIC
		- currentQuantity: NUMERIC
		- expirationDate: DATE
	
		## KittingWorkOrders
		- kitWorkOrderId: serial auto-increment (PK)
		- finishedProductId: integer (FK)
		- quantity: integer
		- executionDate: DATE

		## FinishedInventoryBatches
		- finishedBatchId: serial auto-increment (PK)
		- finishedProductId: integer (FK)
		- kitWorkOrderId: integer (FK)
		- internalLotNumber: VARCHAR (50)
		- quantityProduced: integer
		- productionDate: DATE

		## KittingMaterialConsumption
		- kitMaterialConsumptionId: serial auto-increment (PK)
		- kitWorkOrderId: integer (FK)
		- rawBatchId: integer (FK)
		- quantityConsumed: NUMERIC