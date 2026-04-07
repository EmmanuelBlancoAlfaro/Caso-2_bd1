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
	- checksum: BYTEA
	- exchangeRateId: integer (FK)
	
	## FactGlobalProfitability
	- factId : serial (PK)
	- order : integer -- Referencia a la venta
	- batchId_Postgres : integer -- Referencia al costo de origen
	- dateId : date -- Para filtros de tiempo en Dashboards
	- countryId : integer (FK)
	
	-- Datos de Venta (Vienen de MySQL)
	- saleGrossLocal : DECIMAL(18,2)
	- saleTaxLocal : DECIMAL(18,2)
	- saleNetLocal : DECIMAL(18,2)
	- exchangeRateUsed : DECIMAL(18,6) -- La tasa que se saco de ExchangeHistories

	-- Datos de Costo (Vienen de Postgres)
	- costRawUSD : DECIMAL(18,2) 			-- Costo de materia prima
	- costImportFeesUSD : DECIMAL(18,2) 	-- Aranceles/Landed Cost

	-- Resultado Final (Lo que pide la gerencia)
	- profitUSD : DECIMAL(18,2) -- (saleNetLocal / exchangeRateUsed) - (costRawUSD + costImportFeesUSD)