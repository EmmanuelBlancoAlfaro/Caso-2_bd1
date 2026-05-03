-- ============================================================================
-- ETHERIA GLOBALS - SCRIPT DE CREACIÓN DE TABLAS (PREFIX ETH_)
-- ============================================================================

-- 1. TABLAS CATÁLOGO / SIN DEPENDENCIAS
CREATE TABLE ETH_Countries (
    countryId SERIAL PRIMARY KEY,
    isoCode VARCHAR(3) UNIQUE NOT NULL,
    countryName VARCHAR(50) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_Currencies (
    currencyId SERIAL PRIMARY KEY,
    currencySymbol VARCHAR(5) NOT NULL,
    currencyName VARCHAR(40) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    postTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_LogisticsRoles (
    logisticsRoleId SERIAL PRIMARY KEY,
    roleName VARCHAR(40) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_TransportMethods (
    transportMethodId SERIAL PRIMARY KEY,
    transportName VARCHAR(30) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_Incoterms (
    incotermId SERIAL PRIMARY KEY,
    incotermCode VARCHAR(3) UNIQUE NOT NULL,
    description VARCHAR(100),
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_StatusTypes (
    StatusTypeId SERIAL PRIMARY KEY,
    statusName VARCHAR(15) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_ProductsCategories (
    categoryId SERIAL PRIMARY KEY,
    categoryName VARCHAR(40) NOT NULL,
    description VARCHAR(100),
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_UnitsOfMeasure (
    unitOfMeasureId SERIAL PRIMARY KEY,
    symbol VARCHAR(5) UNIQUE NOT NULL,
    measureName VARCHAR(25) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_PaymentMethods (
    paymentMethodId SERIAL PRIMARY KEY,
    paymentMethodName VARCHAR(30) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_CostsTypes (
    costTypeId SERIAL PRIMARY KEY,
    costTypeName VARCHAR(50) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_ContactTypes (
    contactTypeId SERIAL PRIMARY KEY,
    contactTypeName VARCHAR(50) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

-- 2. TABLAS CON DEPENDENCIAS NIVEL 1
CREATE TABLE ETH_States (
    stateId SERIAL PRIMARY KEY,
    countryId INTEGER REFERENCES ETH_Countries(countryId),
    stateName VARCHAR(40) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_ExchangeRates (
    exchangeRateId SERIAL PRIMARY KEY,
    currencyId1 INTEGER REFERENCES ETH_Currencies(currencyId),
    currencyId2 INTEGER REFERENCES ETH_Currencies(currencyId),
    exchangeRate DECIMAL(18, 6) NOT NULL,
    postTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    checkSum BYTEA,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_CountriesRegulations (
    countryRegulationId SERIAL PRIMARY KEY,
    countryId INTEGER REFERENCES ETH_Countries(countryId),
    regulationName VARCHAR(60) NOT NULL,
    documentURL VARCHAR(150),
    expiryDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_IncotermsRules (
    ruleId SERIAL PRIMARY KEY,
    incotermId INTEGER REFERENCES ETH_Incoterms(incotermId),
    costTypeId INTEGER REFERENCES ETH_CostsTypes(costTypeId),
    isImporterResponsibility BOOLEAN,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_Products (
    productId SERIAL PRIMARY KEY,
    categoryId INTEGER REFERENCES ETH_ProductsCategories(categoryId),
    unitOfMeasureId INTEGER REFERENCES ETH_UnitsOfMeasure(unitOfMeasureId),
    productName VARCHAR(40) NOT NULL,
    description VARCHAR(100),
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

-- 3. TABLAS CON DEPENDENCIAS NIVEL 2, 3 y 4 (Geografía y Entidades)
CREATE TABLE ETH_Cities (
    cityId SERIAL PRIMARY KEY,
    stateId INTEGER REFERENCES ETH_States(stateId),
    cityName VARCHAR(50) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_Addresses (
    addressId SERIAL PRIMARY KEY,
    cityId INTEGER REFERENCES ETH_Cities(cityId),
    address VARCHAR(100),
    zipCode VARCHAR(20),
    latitude NUMERIC(9,6),
    longitude NUMERIC(10,6),
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_Employees (
    employeeId SERIAL PRIMARY KEY,
    addressId INTEGER REFERENCES ETH_Addresses(addressId),
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(20) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    hiringDate DATE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_Suppliers (
    supplierId SERIAL PRIMARY KEY,
    countryId INTEGER REFERENCES ETH_Countries(countryId),
    addressId INTEGER REFERENCES ETH_Addresses(addressId),
    defaultCurrencyId INTEGER REFERENCES ETH_Currencies(currencyId),
    supplierName VARCHAR(40) NOT NULL,
    fdaRegistrationNumber VARCHAR(50),
    taxIdentificationNumber VARCHAR(50),
    isActive BOOLEAN DEFAULT TRUE,
    isGmpCertified BOOLEAN,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_ServicesProviders (
    providerId SERIAL PRIMARY KEY,
    countryId INTEGER REFERENCES ETH_Countries(countryId),
    addressId INTEGER REFERENCES ETH_Addresses(addressId),
    logisticsRoleId INTEGER REFERENCES ETH_LogisticsRoles(logisticsRoleId),
    transportMethodId INTEGER REFERENCES ETH_TransportMethods(transportMethodId),
    providerName VARCHAR(40) NOT NULL,
    trackingPortalUrl VARCHAR(255),
    taxIdentificationNumber VARCHAR(50),
    specificAttributes JSONB,
    liabilityInsuranceLimit NUMERIC(12, 2),
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

CREATE TABLE ETH_Contacts (
    contactId SERIAL PRIMARY KEY,
    employeeId INTEGER REFERENCES ETH_Employees(employeeId) NULL,
    providerId INTEGER REFERENCES ETH_ServicesProviders(providerId) NULL,
    supplierId INTEGER REFERENCES ETH_Suppliers(supplierId) NULL,
    contactTypeId INTEGER REFERENCES ETH_ContactTypes(contactTypeId),
    value VARCHAR(100) NOT NULL,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

-- 4. TABLAS CON DEPENDENCIAS NIVEL 5 (Históricos y Transaccionales Principales)
CREATE TABLE ETH_ExchangeHistories (
    exchangeHistoryId SERIAL PRIMARY KEY,
    startDateTime TIMESTAMP NOT NULL,
    endDateTime TIMESTAMP,
    currencyId1 INTEGER REFERENCES ETH_Currencies(currencyId),
    currencyId2 INTEGER REFERENCES ETH_Currencies(currencyId),
    exchangeRate DECIMAL(18, 6),
    postTime TIMESTAMP,
    checkSum BYTEA,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER,
    exchangeRateId INTEGER REFERENCES ETH_ExchangeRates(exchangeRateId)
);

CREATE TABLE ETH_PurchaseOrders (
    purchaseOrderId SERIAL PRIMARY KEY,
    supplierId INTEGER REFERENCES ETH_Suppliers(supplierId),
    paymentMethodId INTEGER REFERENCES ETH_PaymentMethods(paymentMethodId),
    incotermId INTEGER REFERENCES ETH_Incoterms(incotermId),
    destinationAddressId INTEGER REFERENCES ETH_Addresses(addressId),
    supplierCurrencyId INTEGER REFERENCES ETH_Currencies(currencyId),
    etheriaCurrencyId INTEGER REFERENCES ETH_Currencies(currencyId),
    currentStatusId INTEGER REFERENCES ETH_StatusTypes(StatusTypeId),
    exchangeRate DECIMAL(18, 6),
    billOfLadingNumber VARCHAR(12),
    orderDate DATE NOT NULL,
    duePaymentDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    createdBy INTEGER,
    updatedBy INTEGER
);

-- 5. TABLAS CON DEPENDENCIAS NIVEL 6 (Detalles de Órdenes)
CREATE TABLE ETH_PurchaseOrdersDetails (
    purchaseDetailId SERIAL PRIMARY KEY,
    purchaseOrderId INTEGER REFERENCES ETH_PurchaseOrders(purchaseOrderId),
    productId INTEGER REFERENCES ETH_Products(productId),
    quantityOrdered INTEGER NOT NULL,
    quantityReceived INTEGER,
    originalUnitPrice NUMERIC(10, 2),
    originalSubTotal NUMERIC(12, 2),
    unitPriceUSD NUMERIC(10, 2),
    subTotalUSD NUMERIC(12, 2),
    batchNumber VARCHAR(20),
    expirationDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    createdBy INTEGER,
    updatedBy INTEGER
);

CREATE TABLE ETH_PurchaseOrdersLandedCosts (
    purchaseCostsId SERIAL PRIMARY KEY,
    purchaseOrderId INTEGER REFERENCES ETH_PurchaseOrders(purchaseOrderId),
    providerId INTEGER REFERENCES ETH_ServicesProviders(providerId),
    costTypeId INTEGER REFERENCES ETH_CostsTypes(costTypeId),
    originalAmount NUMERIC(10, 2),
    exchangeRate DECIMAL(18, 6),
    totalAmountUSD NUMERIC(10, 2),
    currencyId INTEGER REFERENCES ETH_Currencies(currencyId),
    description VARCHAR(150),
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    createdBy INTEGER,
    updatedBy INTEGER
);

CREATE TABLE ETH_PurchaseOrdersTracking (
    orderTrackingId SERIAL PRIMARY KEY,
    purchaseOrderId INTEGER REFERENCES ETH_PurchaseOrders(purchaseOrderId),
    statusTypeId INTEGER REFERENCES ETH_StatusTypes(StatusTypeId),
    currentAddressId INTEGER REFERENCES ETH_Addresses(addressId),
    eventDate TIMESTAMP NOT NULL,
    auditInfo JSONB,
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INTEGER
);

-- ============================================================================
-- ETHERIA GLOBALS - ÍNDICES RECOMENDADOS (PostgreSQL - PREFIX ETH_)
-- ============================================================================

-- Geografía
CREATE INDEX idx_states_country ON ETH_States(countryId);
CREATE INDEX idx_cities_state ON ETH_Cities(stateId);
CREATE INDEX idx_addresses_city ON ETH_Addresses(cityId);

-- Entidades
CREATE INDEX idx_employees_address ON ETH_Employees(addressId);
CREATE INDEX idx_suppliers_country ON ETH_Suppliers(countryId);
CREATE INDEX idx_suppliers_address ON ETH_Suppliers(addressId);
CREATE INDEX idx_providers_country ON ETH_ServicesProviders(countryId);
CREATE INDEX idx_providers_role ON ETH_ServicesProviders(logisticsRoleId);

-- Catálogo de Productos
CREATE INDEX idx_products_category ON ETH_Products(categoryId);
CREATE INDEX idx_products_measure ON ETH_Products(unitOfMeasureId);

-- Finanzas y Transacciones
CREATE INDEX idx_exchange_curr1 ON ETH_ExchangeRates(currencyId1);
CREATE INDEX idx_exchange_curr2 ON ETH_ExchangeRates(currencyId2);

CREATE INDEX idx_po_supplier ON ETH_PurchaseOrders(supplierId);
CREATE INDEX idx_po_status ON ETH_PurchaseOrders(currentStatusId);
CREATE INDEX idx_po_incoterm ON ETH_PurchaseOrders(incotermId);
CREATE INDEX idx_po_dest_address ON ETH_PurchaseOrders(destinationAddressId);

CREATE INDEX idx_podetails_po ON ETH_PurchaseOrdersDetails(purchaseOrderId);
CREATE INDEX idx_podetails_product ON ETH_PurchaseOrdersDetails(productId);

CREATE INDEX idx_potracking_po ON ETH_PurchaseOrdersTracking(purchaseOrderId);
CREATE INDEX idx_potracking_status ON ETH_PurchaseOrdersTracking(statusTypeId);

-- ============================================================================
-- ETHERIA GLOBALS - FULL DATABASE POPULATION SCRIPT (PREFIX ETH_)
-- ============================================================================

DO $$
DECLARE
    v_po_id INT;
    v_num_items INT;
    v_i INT;
    v_prod_id INT;
    v_qty INT;
    v_price NUMERIC;
    v_random_date TIMESTAMP;
BEGIN
    -- 0. LIMPIEZA PROFUNDA Y REINICIO DE IDs
    TRUNCATE TABLE 
        ETH_Countries, ETH_Currencies, ETH_LogisticsRoles, ETH_TransportMethods, ETH_Incoterms, 
        ETH_StatusTypes, ETH_ProductsCategories, ETH_UnitsOfMeasure, ETH_PaymentMethods, 
        ETH_CostsTypes, ETH_ContactTypes, ETH_States, ETH_ExchangeRates, ETH_CountriesRegulations, 
        ETH_IncotermsRules, ETH_Products, ETH_Cities, ETH_Addresses, ETH_Employees, ETH_Suppliers, 
        ETH_ServicesProviders, ETH_Contacts, ETH_ExchangeHistories, ETH_PurchaseOrders, 
        ETH_PurchaseOrdersDetails, ETH_PurchaseOrdersLandedCosts, ETH_PurchaseOrdersTracking 
    RESTART IDENTITY CASCADE;

    -- ==========================================
    -- 1. CATÁLOGOS BASE (Mínimo 5 registros)
    -- ==========================================
    INSERT INTO ETH_Countries (isoCode, countryName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('NIC', 'Nicaragua', TRUE, CURRENT_TIMESTAMP - interval '300 days', CURRENT_TIMESTAMP - interval '20 days', 1), 
        ('COL', 'Colombia', TRUE, CURRENT_TIMESTAMP - interval '290 days', CURRENT_TIMESTAMP - interval '15 days', 1),
        ('MEX', 'Mexico', TRUE, CURRENT_TIMESTAMP - interval '280 days', CURRENT_TIMESTAMP - interval '10 days', 1),
        ('IND', 'India', TRUE, CURRENT_TIMESTAMP - interval '270 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        ('CRI', 'Costa Rica', TRUE, CURRENT_TIMESTAMP - interval '260 days', CURRENT_TIMESTAMP - interval '1 days', 1);

    INSERT INTO ETH_Currencies (currencySymbol, currencyName, isActive, postTime, createdAt, updatedAt, updatedBy) VALUES 
        ('$', 'USD', TRUE, CURRENT_TIMESTAMP - interval '300 days', CURRENT_TIMESTAMP - interval '300 days', CURRENT_TIMESTAMP - interval '10 days', 1), 
        ('C$', 'NIO', TRUE, CURRENT_TIMESTAMP - interval '290 days', CURRENT_TIMESTAMP - interval '290 days', CURRENT_TIMESTAMP - interval '15 days', 1),
        ('$', 'COP', TRUE, CURRENT_TIMESTAMP - interval '280 days', CURRENT_TIMESTAMP - interval '280 days', CURRENT_TIMESTAMP - interval '20 days', 1),
        ('$', 'MXN', TRUE, CURRENT_TIMESTAMP - interval '270 days', CURRENT_TIMESTAMP - interval '270 days', CURRENT_TIMESTAMP - interval '25 days', 1),
        ('₡', 'CRC', TRUE, CURRENT_TIMESTAMP - interval '260 days', CURRENT_TIMESTAMP - interval '260 days', CURRENT_TIMESTAMP - interval '30 days', 1);

    INSERT INTO ETH_LogisticsRoles (roleName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('Freight Forwarder', TRUE, CURRENT_TIMESTAMP - interval '200 days', CURRENT_TIMESTAMP - interval '10 days', 1),
        ('Customs Broker', TRUE, CURRENT_TIMESTAMP - interval '190 days', CURRENT_TIMESTAMP - interval '11 days', 1),
        ('Warehouse Manager', TRUE, CURRENT_TIMESTAMP - interval '180 days', CURRENT_TIMESTAMP - interval '12 days', 1),
        ('Port Authority', TRUE, CURRENT_TIMESTAMP - interval '170 days', CURRENT_TIMESTAMP - interval '13 days', 1),
        ('Last Mile Carrier', TRUE, CURRENT_TIMESTAMP - interval '160 days', CURRENT_TIMESTAMP - interval '14 days', 1);

    INSERT INTO ETH_TransportMethods (transportName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('Ocean Freight', TRUE, CURRENT_TIMESTAMP - interval '200 days', CURRENT_TIMESTAMP - interval '10 days', 1),
        ('Air Freight', TRUE, CURRENT_TIMESTAMP - interval '190 days', CURRENT_TIMESTAMP - interval '12 days', 1),
        ('Rail Freight', TRUE, CURRENT_TIMESTAMP - interval '180 days', CURRENT_TIMESTAMP - interval '14 days', 1),
        ('Road Freight', TRUE, CURRENT_TIMESTAMP - interval '170 days', CURRENT_TIMESTAMP - interval '16 days', 1),
        ('Multimodal', TRUE, CURRENT_TIMESTAMP - interval '160 days', CURRENT_TIMESTAMP - interval '18 days', 1);

    INSERT INTO ETH_Incoterms (incotermCode, description, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('FOB', 'Free on Board', TRUE, CURRENT_TIMESTAMP - interval '300 days', CURRENT_TIMESTAMP - interval '50 days', 1),
        ('CIF', 'Cost, Insurance, Freight', TRUE, CURRENT_TIMESTAMP - interval '290 days', CURRENT_TIMESTAMP - interval '40 days', 1),
        ('EXW', 'Ex Works', TRUE, CURRENT_TIMESTAMP - interval '280 days', CURRENT_TIMESTAMP - interval '30 days', 1),
        ('DDP', 'Delivered Duty Paid', TRUE, CURRENT_TIMESTAMP - interval '270 days', CURRENT_TIMESTAMP - interval '20 days', 1),
        ('FCA', 'Free Carrier', TRUE, CURRENT_TIMESTAMP - interval '260 days', CURRENT_TIMESTAMP - interval '10 days', 1);

    INSERT INTO ETH_StatusTypes (statusName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('Pendiente', TRUE, CURRENT_TIMESTAMP - interval '300 days', CURRENT_TIMESTAMP - interval '5 days', 1), 
        ('Procesando', TRUE, CURRENT_TIMESTAMP - interval '290 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        ('En Tránsito', TRUE, CURRENT_TIMESTAMP - interval '280 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        ('Aduana', TRUE, CURRENT_TIMESTAMP - interval '270 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        ('Entregado', TRUE, CURRENT_TIMESTAMP - interval '260 days', CURRENT_TIMESTAMP - interval '5 days', 1);

    INSERT INTO ETH_ProductsCategories (categoryName, description, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('Cosmética', 'Cuidado de la piel', TRUE, CURRENT_TIMESTAMP - interval '150 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        ('Suplementos', 'Ingesta y vitaminas', TRUE, CURRENT_TIMESTAMP - interval '140 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        ('Aromaterapia', 'Aceites esenciales', TRUE, CURRENT_TIMESTAMP - interval '130 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        ('Higiene Capilar', 'Shampoos y sueros', TRUE, CURRENT_TIMESTAMP - interval '120 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        ('Botánica', 'Hierbas a granel', TRUE, CURRENT_TIMESTAMP - interval '110 days', CURRENT_TIMESTAMP - interval '2 days', 1);

    INSERT INTO ETH_UnitsOfMeasure (symbol, measureName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('Kg', 'Kilogramos', TRUE, CURRENT_TIMESTAMP - interval '400 days', CURRENT_TIMESTAMP - interval '100 days', 1), 
        ('L', 'Litros', TRUE, CURRENT_TIMESTAMP - interval '390 days', CURRENT_TIMESTAMP - interval '90 days', 1),
        ('g', 'Gramos', TRUE, CURRENT_TIMESTAMP - interval '380 days', CURRENT_TIMESTAMP - interval '80 days', 1),
        ('ml', 'Mililitros', TRUE, CURRENT_TIMESTAMP - interval '370 days', CURRENT_TIMESTAMP - interval '70 days', 1),
        ('Oz', 'Onzas', TRUE, CURRENT_TIMESTAMP - interval '360 days', CURRENT_TIMESTAMP - interval '60 days', 1);

    INSERT INTO ETH_PaymentMethods (paymentMethodName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('Swift Transfer', TRUE, CURRENT_TIMESTAMP - interval '200 days', CURRENT_TIMESTAMP - interval '15 days', 1),
        ('Letter of Credit', TRUE, CURRENT_TIMESTAMP - interval '190 days', CURRENT_TIMESTAMP - interval '15 days', 1),
        ('PayPal', TRUE, CURRENT_TIMESTAMP - interval '180 days', CURRENT_TIMESTAMP - interval '15 days', 1),
        ('Stripe B2B', TRUE, CURRENT_TIMESTAMP - interval '170 days', CURRENT_TIMESTAMP - interval '15 days', 1),
        ('Wire Transfer', TRUE, CURRENT_TIMESTAMP - interval '160 days', CURRENT_TIMESTAMP - interval '15 days', 1);

    INSERT INTO ETH_CostsTypes (costTypeName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('Aranceles de Importación', TRUE, CURRENT_TIMESTAMP - interval '100 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        ('Seguro de Carga', TRUE, CURRENT_TIMESTAMP - interval '90 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        ('Manejo Portuario', TRUE, CURRENT_TIMESTAMP - interval '80 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        ('Almacenaje', TRUE, CURRENT_TIMESTAMP - interval '70 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        ('Flete Interno', TRUE, CURRENT_TIMESTAMP - interval '60 days', CURRENT_TIMESTAMP - interval '5 days', 1);

    INSERT INTO ETH_ContactTypes (contactTypeName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        ('Email Corporativo', TRUE, CURRENT_TIMESTAMP - interval '100 days', CURRENT_TIMESTAMP - interval '1 days', 1),
        ('Teléfono Móvil', TRUE, CURRENT_TIMESTAMP - interval '90 days', CURRENT_TIMESTAMP - interval '1 days', 1),
        ('Teléfono Fijo', TRUE, CURRENT_TIMESTAMP - interval '80 days', CURRENT_TIMESTAMP - interval '1 days', 1),
        ('WhatsApp Business', TRUE, CURRENT_TIMESTAMP - interval '70 days', CURRENT_TIMESTAMP - interval '1 days', 1),
        ('Portal Web', TRUE, CURRENT_TIMESTAMP - interval '60 days', CURRENT_TIMESTAMP - interval '1 days', 1);

    -- ==========================================
    -- 2. GEOGRAFÍA AVANZADA
    -- ==========================================
    INSERT INTO ETH_States (countryId, stateName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        (1, 'Managua', TRUE, CURRENT_TIMESTAMP - interval '200 days', CURRENT_TIMESTAMP - interval '10 days', 1), 
        (2, 'Cundinamarca', TRUE, CURRENT_TIMESTAMP - interval '190 days', CURRENT_TIMESTAMP - interval '10 days', 1),
        (3, 'Jalisco', TRUE, CURRENT_TIMESTAMP - interval '180 days', CURRENT_TIMESTAMP - interval '10 days', 1),
        (4, 'Maharashtra', TRUE, CURRENT_TIMESTAMP - interval '170 days', CURRENT_TIMESTAMP - interval '10 days', 1),
        (5, 'Cartago', TRUE, CURRENT_TIMESTAMP - interval '160 days', CURRENT_TIMESTAMP - interval '10 days', 1);

    INSERT INTO ETH_Cities (stateId, cityName, isActive, createdAt, updatedAt, updatedBy) VALUES 
        (1, 'Managua City', TRUE, CURRENT_TIMESTAMP - interval '150 days', CURRENT_TIMESTAMP - interval '5 days', 1), 
        (2, 'Bogota', TRUE, CURRENT_TIMESTAMP - interval '140 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        (3, 'Guadalajara', TRUE, CURRENT_TIMESTAMP - interval '130 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        (4, 'Mumbai', TRUE, CURRENT_TIMESTAMP - interval '120 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        (5, 'Cartago Centro', TRUE, CURRENT_TIMESTAMP - interval '110 days', CURRENT_TIMESTAMP - interval '5 days', 1);

    INSERT INTO ETH_Addresses (cityId, address, zipCode, latitude, longitude, isActive, createdAt, updatedAt, updatedBy) VALUES 
        (1, 'Zona Libre Logística Bodega 4', '10000', 12.136389, -86.251389, TRUE, CURRENT_TIMESTAMP - interval '100 days', CURRENT_TIMESTAMP - interval '2 days', 1), 
        (2, 'Parque Industrial 1, Lote 8', '11001', 4.710989, -74.072092, TRUE, CURRENT_TIMESTAMP - interval '90 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        (3, 'Bodegas Norte, Nave 3', '44100', 20.659698, -103.349609, TRUE, CURRENT_TIMESTAMP - interval '80 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        (4, 'Port Ave, Building A', '400001', 18.921984, 72.834654, TRUE, CURRENT_TIMESTAMP - interval '70 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        (5, 'Parque Tecnológico, Edificio B', '30101', 9.864444, -83.919444, TRUE, CURRENT_TIMESTAMP - interval '60 days', CURRENT_TIMESTAMP - interval '2 days', 1);

    -- ==========================================
    -- 3. CONFIGURACIONES Y REGLAS
    -- ==========================================
    INSERT INTO ETH_ExchangeRates (currencyId1, currencyId2, exchangeRate, postTime, checkSum, createdAt, updatedAt, updatedBy) VALUES 
        (1, 2, 36.500000, CURRENT_TIMESTAMP - interval '5 days', '\xDEADBEEF', CURRENT_TIMESTAMP - interval '5 days', CURRENT_TIMESTAMP - interval '1 days', 1),
        (1, 3, 3900.250000, CURRENT_TIMESTAMP - interval '6 days', '\xCAFEBABE', CURRENT_TIMESTAMP - interval '6 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        (1, 4, 16.850000, CURRENT_TIMESTAMP - interval '7 days', '\xBAADF00D', CURRENT_TIMESTAMP - interval '7 days', CURRENT_TIMESTAMP - interval '3 days', 1),
        (1, 5, 510.300000, CURRENT_TIMESTAMP - interval '8 days', '\xFEEDFACE', CURRENT_TIMESTAMP - interval '8 days', CURRENT_TIMESTAMP - interval '4 days', 1),
        (2, 1, 0.027000, CURRENT_TIMESTAMP - interval '9 days', '\x0D15EA5E', CURRENT_TIMESTAMP - interval '9 days', CURRENT_TIMESTAMP - interval '5 days', 1);

    INSERT INTO ETH_CountriesRegulations (countryId, regulationName, documentURL, expiryDate, isActive, createdAt, updatedAt, updatedBy) VALUES 
        (1, 'Normativa Minsa', 'https://docs.etheria.com/minsa1', CURRENT_DATE + interval '365 days', TRUE, CURRENT_TIMESTAMP - interval '100 days', CURRENT_TIMESTAMP - interval '10 days', 1),
        (2, 'INVIMA Importaciones', 'https://docs.etheria.com/invima', CURRENT_DATE + interval '400 days', TRUE, CURRENT_TIMESTAMP - interval '90 days', CURRENT_TIMESTAMP - interval '9 days', 1),
        (3, 'COFEPRIS Cosmética', 'https://docs.etheria.com/cofepris', CURRENT_DATE + interval '250 days', TRUE, CURRENT_TIMESTAMP - interval '80 days', CURRENT_TIMESTAMP - interval '8 days', 1),
        (4, 'CDSCO Guidelines', 'https://docs.etheria.com/cdsco', CURRENT_DATE + interval '300 days', TRUE, CURRENT_TIMESTAMP - interval '70 days', CURRENT_TIMESTAMP - interval '7 days', 1),
        (5, 'Ministerio Salud CR', 'https://docs.etheria.com/mscr', CURRENT_DATE + interval '500 days', TRUE, CURRENT_TIMESTAMP - interval '60 days', CURRENT_TIMESTAMP - interval '6 days', 1);

    INSERT INTO ETH_IncotermsRules (incotermId, costTypeId, isImporterResponsibility, isActive, createdAt, updatedAt, updatedBy) VALUES 
        (1, 1, TRUE, TRUE, CURRENT_TIMESTAMP - interval '100 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        (1, 5, TRUE, TRUE, CURRENT_TIMESTAMP - interval '90 days', CURRENT_TIMESTAMP - interval '4 days', 1),
        (2, 2, FALSE, TRUE, CURRENT_TIMESTAMP - interval '80 days', CURRENT_TIMESTAMP - interval '3 days', 1),
        (3, 1, TRUE, TRUE, CURRENT_TIMESTAMP - interval '70 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        (4, 1, FALSE, TRUE, CURRENT_TIMESTAMP - interval '60 days', CURRENT_TIMESTAMP - interval '1 days', 1);

    -- ==========================================
    -- 4. ENTIDADES PRINCIPALES (0 NULLs)
    -- ==========================================
    INSERT INTO ETH_Employees (addressId, firstName, lastName, isActive, hiringDate, createdAt, updatedAt, updatedBy) VALUES 
        (1, 'Fabricio', 'Hernandez', TRUE, CURRENT_DATE - interval '800 days', CURRENT_TIMESTAMP - interval '800 days', CURRENT_TIMESTAMP - interval '10 days', 1),
        (2, 'Ana', 'Gomez', TRUE, CURRENT_DATE - interval '600 days', CURRENT_TIMESTAMP - interval '600 days', CURRENT_TIMESTAMP - interval '20 days', 1),
        (3, 'Carlos', 'Ruiz', TRUE, CURRENT_DATE - interval '400 days', CURRENT_TIMESTAMP - interval '400 days', CURRENT_TIMESTAMP - interval '30 days', 1),
        (4, 'Priya', 'Sharma', TRUE, CURRENT_DATE - interval '200 days', CURRENT_TIMESTAMP - interval '200 days', CURRENT_TIMESTAMP - interval '40 days', 1),
        (5, 'Luis', 'Mora', TRUE, CURRENT_DATE - interval '100 days', CURRENT_TIMESTAMP - interval '100 days', CURRENT_TIMESTAMP - interval '50 days', 1);

    INSERT INTO ETH_Suppliers (countryId, addressId, defaultCurrencyId, supplierName, fdaRegistrationNumber, taxIdentificationNumber, isActive, isGmpCertified, createdAt, updatedAt, updatedBy) VALUES 
        (2, 2, 3, 'Latam BioSupplies Colombia', 'FDA-COL-001', 'NIT-900123456', TRUE, TRUE, CURRENT_TIMESTAMP - interval '500 days', CURRENT_TIMESTAMP - interval '15 days', 1),
        (3, 3, 4, 'Agave & Aloe Mexico Labs', 'FDA-MEX-002', 'RFC-ABC123456', TRUE, TRUE, CURRENT_TIMESTAMP - interval '450 days', CURRENT_TIMESTAMP - interval '14 days', 1),
        (4, 4, 1, 'Ayurveda Bulk India', 'FDA-IND-003', 'GST-27ABCDE1234F', TRUE, TRUE, CURRENT_TIMESTAMP - interval '400 days', CURRENT_TIMESTAMP - interval '13 days', 1),
        (5, 5, 5, 'Tico Botanicals', 'FDA-CRI-004', 'CED-3101123456', TRUE, TRUE, CURRENT_TIMESTAMP - interval '350 days', CURRENT_TIMESTAMP - interval '12 days', 1),
        (1, 1, 2, 'Nica Extracts SA', 'FDA-NIC-005', 'RUC-987654321', TRUE, TRUE, CURRENT_TIMESTAMP - interval '300 days', CURRENT_TIMESTAMP - interval '11 days', 1);

    INSERT INTO ETH_ServicesProviders (countryId, addressId, logisticsRoleId, transportMethodId, providerName, trackingPortalUrl, taxIdentificationNumber, specificAttributes, liabilityInsuranceLimit, isActive, createdAt, updatedAt, updatedBy) VALUES 
        (1, 1, 1, 1, 'Oceanic Transport DB', 'https://track.oceanic.com', 'RUC-L123', '{"cert": "BASC", "rating": "A"}'::jsonb, 5000000.00, TRUE, CURRENT_TIMESTAMP - interval '300 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        (3, 3, 2, 4, 'MexLogistics', 'https://track.mexlog.mx', 'RFC-L456', '{"cert": "ISO9001"}'::jsonb, 2000000.00, TRUE, CURRENT_TIMESTAMP - interval '280 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        (2, 2, 3, 2, 'ColAir Cargo', 'https://track.colair.co', 'NIT-L789', '{"rating": "B+"}'::jsonb, 1000000.00, TRUE, CURRENT_TIMESTAMP - interval '260 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        (4, 4, 4, 1, 'India Port Services', 'https://track.inport.in', 'GST-L101', '{"cert": "AEO"}'::jsonb, 10000000.00, TRUE, CURRENT_TIMESTAMP - interval '240 days', CURRENT_TIMESTAMP - interval '5 days', 1),
        (5, 5, 5, 4, 'Tico Express Delivery', 'https://track.ticoex.cr', 'CED-L202', '{"fleet_size": 50}'::jsonb, 500000.00, TRUE, CURRENT_TIMESTAMP - interval '220 days', CURRENT_TIMESTAMP - interval '5 days', 1);

    -- Para tener 0 NULLs en Contacts, cada contacto se asocia a un empleado, un proveedor y un suplidor simultáneamente.
    INSERT INTO ETH_Contacts (employeeId, providerId, supplierId, contactTypeId, value, isActive, createdAt, updatedAt, updatedBy) VALUES 
        (1, 1, 1, 1, 'admin1@etheria.com', TRUE, CURRENT_TIMESTAMP - interval '200 days', CURRENT_TIMESTAMP - interval '1 days', 1),
        (2, 2, 2, 2, '+506-8888-0002', TRUE, CURRENT_TIMESTAMP - interval '190 days', CURRENT_TIMESTAMP - interval '2 days', 1),
        (3, 3, 3, 3, '+52-555-0003', TRUE, CURRENT_TIMESTAMP - interval '180 days', CURRENT_TIMESTAMP - interval '3 days', 1),
        (4, 4, 4, 4, '+91-987-0004', TRUE, CURRENT_TIMESTAMP - interval '170 days', CURRENT_TIMESTAMP - interval '4 days', 1),
        (5, 5, 5, 5, 'https://portal.etheria.com/c5', TRUE, CURRENT_TIMESTAMP - interval '160 days', CURRENT_TIMESTAMP - interval '5 days', 1);

    -- ==========================================
    -- 5. CATÁLOGO DE PRODUCTOS (100 Productos con fechas orgánicas)
    -- ==========================================
    INSERT INTO ETH_Products (categoryId, unitOfMeasureId, productName, description, isActive, createdAt, updatedAt, updatedBy)
    SELECT 
        (random() * 4 + 1)::int, 
        (random() * 4 + 1)::int, 
        'Etheria Item ' || gs, 
        'Producto Premium ' || gs, 
        TRUE, 
        CURRENT_TIMESTAMP - (random() * 365 + 100 || ' days')::interval, 
        CURRENT_TIMESTAMP - (random() * 90 || ' days')::interval, 
        1
    FROM generate_series(1, 100) gs;

    -- ==========================================
    -- 6. TRANSACCIONES Y ÓRDENES (0 NULLs)
    -- ==========================================
    INSERT INTO ETH_ExchangeHistories (startDateTime, endDateTime, currencyId1, currencyId2, exchangeRate, postTime, checkSum, createdAt, updatedAt, updatedBy, exchangeRateId) VALUES 
        (CURRENT_TIMESTAMP - interval '60 days', CURRENT_TIMESTAMP - interval '50 days', 1, 2, 36.200000, CURRENT_TIMESTAMP - interval '60 days', '\xCAFEBABE', CURRENT_TIMESTAMP - interval '60 days', CURRENT_TIMESTAMP - interval '50 days', 1, 1),
        (CURRENT_TIMESTAMP - interval '50 days', CURRENT_TIMESTAMP - interval '40 days', 1, 3, 3850.000000, CURRENT_TIMESTAMP - interval '50 days', '\xBAADF00D', CURRENT_TIMESTAMP - interval '50 days', CURRENT_TIMESTAMP - interval '40 days', 1, 2),
        (CURRENT_TIMESTAMP - interval '40 days', CURRENT_TIMESTAMP - interval '30 days', 1, 4, 17.000000, CURRENT_TIMESTAMP - interval '40 days', '\xDEADBEEF', CURRENT_TIMESTAMP - interval '40 days', CURRENT_TIMESTAMP - interval '30 days', 1, 3),
        (CURRENT_TIMESTAMP - interval '30 days', CURRENT_TIMESTAMP - interval '20 days', 1, 5, 515.000000, CURRENT_TIMESTAMP - interval '30 days', '\xFEEDFACE', CURRENT_TIMESTAMP - interval '30 days', CURRENT_TIMESTAMP - interval '20 days', 1, 4),
        (CURRENT_TIMESTAMP - interval '20 days', CURRENT_TIMESTAMP - interval '10 days', 2, 1, 0.027500, CURRENT_TIMESTAMP - interval '20 days', '\x0D15EA5E', CURRENT_TIMESTAMP - interval '20 days', CURRENT_TIMESTAMP - interval '10 days', 1, 5);

    INSERT INTO ETH_PurchaseOrders (
        supplierId, paymentMethodId, incotermId, destinationAddressId, 
        supplierCurrencyId, etheriaCurrencyId, currentStatusId, exchangeRate, 
        billOfLadingNumber, orderDate, duePaymentDate, isActive, createdAt, updatedAt, createdBy, updatedBy
    )
    SELECT 
        (random() * 4 + 1)::int, 
        (random() * 4 + 1)::int, 
        (random() * 4 + 1)::int, 
        (random() * 4 + 1)::int, 
        1, 1, 
        (random() * 4 + 1)::int, 
        1.000000,
        'BOL26-' || LPAD(gs::text, 4, '0'), 
        CURRENT_DATE - (random() * 100 + 30 || ' days')::interval, 
        CURRENT_DATE + (random() * 30 || ' days')::interval,
        TRUE, 
        CURRENT_TIMESTAMP - (random() * 100 + 30 || ' days')::interval, 
        CURRENT_TIMESTAMP - (random() * 10 || ' days')::interval, 
        1, 1
    FROM generate_series(1, 30) gs;

    -- Detalles, Costos Landed y Tracking (Con fechas y valores consistentes)
    FOR v_po_id IN SELECT purchaseOrderId FROM ETH_PurchaseOrders LOOP
        v_num_items := (random() * 4 + 2)::int; 
        v_random_date := CURRENT_TIMESTAMP - (random() * 30 || ' days')::interval;

        -- Tracking (1 por orden para simplificar, pero garantizando 0 nulos)
        INSERT INTO ETH_PurchaseOrdersTracking (purchaseOrderId, statusTypeId, currentAddressId, eventDate, auditInfo, isActive, createdAt, updatedAt, updatedBy) VALUES 
            (v_po_id, (random() * 4 + 1)::int, (random() * 4 + 1)::int, v_random_date, '{"system": "Etheria Log", "verified": true}'::jsonb, TRUE, v_random_date, v_random_date, 1);

        -- Costos Landed (1 por orden)
        INSERT INTO ETH_PurchaseOrdersLandedCosts (purchaseOrderId, providerId, costTypeId, originalAmount, exchangeRate, totalAmountUSD, currencyId, description, isActive, createdAt, updatedAt, createdBy, updatedBy) VALUES 
            (v_po_id, (random() * 4 + 1)::int, (random() * 4 + 1)::int, (random() * 500 + 100)::numeric(10,2), 1.000000, 500.00, 1, 'Costos arancelarios autogenerados', TRUE, v_random_date, v_random_date, 1, 1);

        -- Ítems de la orden
        FOR v_i IN 1..v_num_items LOOP
            v_prod_id := (random() * 99 + 1)::int; 
            v_qty := (random() * 500 + 50)::int; 
            v_price := (random() * 100 + 10)::numeric(10,2); 

            INSERT INTO ETH_PurchaseOrdersDetails (
                purchaseOrderId, productId, quantityOrdered, quantityReceived, 
                originalUnitPrice, unitPriceUSD, originalSubTotal, subTotalUSD, 
                batchNumber, expirationDate, isActive, createdAt, updatedAt, createdBy, updatedBy
            )
            VALUES (
                v_po_id, v_prod_id, v_qty, v_qty,
                v_price, v_price, (v_qty * v_price), (v_qty * v_price),
                'LOTE-' || v_po_id || '-' || v_prod_id,
                CURRENT_DATE + (random() * 365 + 180 || ' days')::interval, 
                TRUE, v_random_date, v_random_date, 1, 1
            );
        END LOOP;
    END LOOP;

    RAISE NOTICE '¡Éxito! Las 27 tablas ETH_ están pobladas con mínimo 5 registros, 0 valores NULL y fechas orgánicas.';
END $$;

