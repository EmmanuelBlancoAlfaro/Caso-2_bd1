
#TABLAS

------------------------- CURRENCY PATTERN ------------------------------

	## Users
	- userId: serial auto-increment (PK)
	- name: VARCHAR (50)
	
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
	- userId: integer (FK)
	- countryId: integer (FK)
	
	## ExchangeRates
	- exchangeRateId: serial auto-increment (PK)
	- currencyId1: integer (FK)
	- currencyId2: integer (FK)
	- exchangeRate: DECIMAL (18, 6)
	- postTime: TIMESTAMP
	- userId: integer (FK)
	- checksum: BYTEA
	
	## ExchangeHistories
	- exchangeHistoryId: serial auto-increment (PK)
	- startDateTime: TIMESTAMP
	- endDateTime: TIMESTAMP
	- currencyId1: integer (FK)
	- currencyId2: integer (FK)
	- exchangeRate: DECIMAL (18, 6)
	- postTime: TIMESTAMP
	- userId: integer (FK)
	- checksum: BYTEA
	- exchangeRateId: integer (FK)