#TABLAS

------------------------- CURRENCY PATTERN ------------------------------
	## Countries
	- countryId: serial auto-increment (PK)
	- isoCode: UNIQUE VARCHAR (3) 
	- name: VARCHAR (50)

	## CURRENCIES
	- currencyId: serial auto-increment (PK)
	- currencySymbol: VARCHAR (1)
	- currencyName: VARCHAR (20)
	- isEnabled: BOOLEAN
	- postTime: TIMESTAMP
	- countryId: integer (FK)
	
	## ExchangeRates
	- exchangeRateId: serial auto-increment (PK)
	- currencyId1: integer (FK)
	- currencyId2: integer (FK)
	- exchangeRate: DECIMAL (18, 6)
	- postTime: TIMESTAMP
	- checksum: BYTEA
	
	## ExchangeHistories
	- exchangeHistoryId: serial auto-increment (PK)
	- startDateTime: TIMESTAMP
	- endDateTime: TIMESTAMP
	- currencyId1: integer (FK)
	- currencyId2: integer (FK)
	- exchangeRate: DECIMAL (18, 6)
	- checksum: BYTEA
	- exchangeRateId: integer (FK)
	
----------------------- FINANCIAL ANALYSIS TABLES ----------------------- 
	
	## Dates
	- dateId: serial auto-increment (PK)
	- dayOfTheWeek: VARCHAR (10)
	- day: integer
	- month: integer
	- year: integer
	
	## Shops
	- shopId: serial auto-increment (PK)
	- countryId: integer (FK)
	- shopName: VARCHAR (30)
	- isActive: BOOLEAN
	
	## Products
	- productId: serial auto-increment (PK)
	- productName: VARCHAR (40)
	
	## FactGlobalProfitability
	- factId: serial auto-increment (PK)
	- exchangeRateId: integer (FK)
	- dateId: integer (FK)
	- shopId: integer (FK)
	- productId: integer (FK)
	- localRevenue: NUMERIC (12, 4)
	- usdRevenue: NUMERIC (12, 4)
	- purchaseCosts: NUMERIC (12, 4)
	- netProfitUSD: NUMERIC (12, 4)