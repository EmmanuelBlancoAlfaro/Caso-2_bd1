

	#TABLAS DATA WAREHOUSE

		## MonthlyRentabilityRegisters
		- registerId: serial auto-increment (PK)
		- destinyCountry: VARCHAR (50)
		- supplierCountry: VARCHAR (50)
		- brandName: VARCHAR (60)
		- courierService: VARCHAR (60)
		- year: integer
		- month: integer
		- amountImported: integer
		- amountSold: integer
		- amountReturned: integer
		- finalStock: intger
		- importationCost: NUMERIC (15, 2)
		- salesIncome: NUMERIC (15, 2)
		- courierCost: NUMERIC (15, 2)
		- totalEarning: NUMERIC (15, 2)
		