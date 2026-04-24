-- ==============================================================
-- 1. CATÁLOGOS BASE (Sin Dependencias)
-- ==============================================================
CREATE TABLE Currency (
    currencyId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    simbol VARCHAR(1) NOT NULL
);

CREATE TABLE addressType (
    addressTypeId INT AUTO_INCREMENT PRIMARY KEY,
    addressTypeName VARCHAR(100)
);

CREATE TABLE batch (
    batchId INT AUTO_INCREMENT PRIMARY KEY,
    batchNumber INT,
    batchDescription VARCHAR(150),
    enabled BOOLEAN DEFAULT TRUE
);

CREATE TABLE UnitsOfMeasures (
    unitOfMeasureId INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(5) UNIQUE,
    name VARCHAR(30)
);

CREATE TABLE BrandsPositionsTypes (
    brandTypeId INT AUTO_INCREMENT PRIMARY KEY,
    brandTypeName VARCHAR(50),
    brandTypeDescription VARCHAR(100)
);

CREATE TABLE hubZones (
    zoneId INT AUTO_INCREMENT PRIMARY KEY,
    zoneName VARCHAR(50),
    enabled BOOLEAN DEFAULT TRUE
);

CREATE TABLE productAttributes (
    attributeId INT AUTO_INCREMENT PRIMARY KEY,
    attributeName VARCHAR(50),
    enabled BOOLEAN DEFAULT TRUE
);

CREATE TABLE ordersStatus (
    orderStatuId INT AUTO_INCREMENT PRIMARY KEY,
    orderStatusName VARCHAR(20),
    orderStatuDescription VARCHAR(100)
);

CREATE TABLE shippingMethods (
    methodId INT AUTO_INCREMENT PRIMARY KEY,
    methodName VARCHAR(50) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE
);

CREATE TABLE shipmentsStatus (
    shipmentStatusId INT AUTO_INCREMENT PRIMARY KEY,
    shipmentStatusName VARCHAR(20),
    description VARCHAR(50)
);

CREATE TABLE taxesTypes (
    taxTypeId INT AUTO_INCREMENT PRIMARY KEY,
    taxTypeName VARCHAR(100),
    taxTypeDescription VARCHAR(150)
);

CREATE TABLE restrictionsTypes (
    restrictionId INT AUTO_INCREMENT PRIMARY KEY,
    restrictionTypeName VARCHAR(50),
    restrictionTypeDescription VARCHAR(100)
);

CREATE TABLE eventsTypes (
    eventTypeId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(150)
);

CREATE TABLE dataObjects (
    dataObjectId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(100)
);

CREATE TABLE severities (
    severityId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(100)
);

CREATE TABLE statusTransactionType (
    statusTypeId INT AUTO_INCREMENT PRIMARY KEY,
    statusName VARCHAR(50),
    statusDescription VARCHAR(150)
);

CREATE TABLE productCategories (
    productCategoryId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40),
    description VARCHAR(100),
    healthRiskLevel VARCHAR(20)
);

CREATE TABLE shippingCarriers (
    carrierId INT AUTO_INCREMENT PRIMARY KEY,
    shippingCarrierName VARCHAR(50),
    lastName VARCHAR(30),
    contactInfo VARCHAR(100),
    trackingTemplate VARCHAR(200),
    enabled BOOLEAN DEFAULT TRUE
);

-- ==============================================================
-- 2. TABLAS CON DEPENDENCIAS NIVEL 1
-- ==============================================================
CREATE TABLE currencyRates (
    rateId INT AUTO_INCREMENT PRIMARY KEY,
    currencyId INT,
    exchangeRate DECIMAL(18,6),
    rateDate DATE,
    FOREIGN KEY (currencyId) REFERENCES Currency(currencyId)
);

CREATE TABLE countries (
    countryId INT AUTO_INCREMENT PRIMARY KEY,
    isoCode VARCHAR(3) NOT NULL,
    countryName VARCHAR(50) NOT NULL,
    currencyId INT,
    enabled BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (currencyId) REFERENCES Currency(currencyId)
);

CREATE TABLE hubLayout (
    locationId INT AUTO_INCREMENT PRIMARY KEY,
    zoneId INT,
    aisle VARCHAR(10),
    shelf VARCHAR(10),
    bin VARCHAR(10),
    FOREIGN KEY (zoneId) REFERENCES hubZones(zoneId)
);

CREATE TABLE categoryAttributes (
    categoryAttributeId INT AUTO_INCREMENT PRIMARY KEY,
    productCategoryId INT,
    attributeId INT,
    FOREIGN KEY (productCategoryId) REFERENCES productCategories(productCategoryId),
    FOREIGN KEY (attributeId) REFERENCES productAttributes(attributeId)
);

CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    password VARBINARY(255),
    phone INT,
    creadetAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN DEFAULT TRUE
);

CREATE TABLE priceShippingMethod (
    priceMethodId INT AUTO_INCREMENT PRIMARY KEY,
    methodId INT,
    price DECIMAL(10,2),
    FOREIGN KEY (methodId) REFERENCES shippingMethods(methodId)
);

CREATE TABLE shippingTaxes (
    shippingTaxId INT AUTO_INCREMENT PRIMARY KEY,
    countryId INT,
    taxPercent DECIMAL(5,2),
    description VARCHAR(50),
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE systemErrorsLogs (
    errorId INT AUTO_INCREMENT PRIMARY KEY,
    severityId INT,
    processUuid VARCHAR(100),
    processName VARCHAR(100),
    stepName VARCHAR(100),
    inputData JSON,
    errorMesage TEXT,
    creadetAt DATE,
    FOREIGN KEY (severityId) REFERENCES severities(severityId)
);

-- ==============================================================
-- 3. TABLAS CON DEPENDENCIAS NIVEL 2
-- ==============================================================
CREATE TABLE estates (
    estateId INT AUTO_INCREMENT PRIMARY KEY,
    countryId INT,
    estateName VARCHAR(70),
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE products (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productCategoryId INT,
    unitOfMeasureId INT,
    productName VARCHAR(100),
    enabled BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (productCategoryId) REFERENCES productCategories(productCategoryId),
    FOREIGN KEY (unitOfMeasureId) REFERENCES UnitsOfMeasures(unitOfMeasureId)
);

CREATE TABLE websites (
    websiteId INT AUTO_INCREMENT PRIMARY KEY,
    countryId INT,
    brandName VARCHAR(150),
    domain VARCHAR(32),
    marketingFocus TEXT,
    enabled BOOLEAN DEFAULT TRUE,
    creadetAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE sessions (
    sessionId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    sessionToken VARCHAR(100),
    creadetAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(userId)
);

CREATE TABLE taxesPerCountry (
    taxId INT AUTO_INCREMENT PRIMARY KEY,
    countryId INT,
    taxTypeId INT,
    validFrom DATE,
    validUntil DATE,
    productCategoryId INT,
    tax_percent DECIMAL(5,2),
    enabled BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (countryId) REFERENCES countries(countryId),
    FOREIGN KEY (taxTypeId) REFERENCES taxesTypes(taxTypeId),
    FOREIGN KEY (productCategoryId) REFERENCES productCategories(productCategoryId)
);

-- ==============================================================
-- 4. TABLAS CON DEPENDENCIAS NIVEL 3
-- ==============================================================
CREATE TABLE cities (
    cityId INT AUTO_INCREMENT PRIMARY KEY,
    estateId INT,
    cityName VARCHAR(100),
    FOREIGN KEY (estateId) REFERENCES estates(estateId)
);

CREATE TABLE productAttributeValues (
    valueId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT,
    attributeId INT,
    valueText VARCHAR(255),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (attributeId) REFERENCES productAttributes(attributeId)
);

CREATE TABLE productInventory (
    inventoryId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT,
    batchId INT,
    currentStock INT,
    locationId INT,
    lastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (batchId) REFERENCES batch(batchId),
    FOREIGN KEY (locationId) REFERENCES hubLayout(locationId)
);

CREATE TABLE productPriceHistory (
    priceHistoryId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT,
    websiteId INT,
    newPrice DECIMAL(10,2),
    changeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedBy INT,
    checksum VARBINARY(32),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId),
    FOREIGN KEY (updatedBy) REFERENCES users(userId)
);

CREATE TABLE websiteThemes (
    themeId INT AUTO_INCREMENT PRIMARY KEY,
    websiteId INT,
    themeName VARCHAR(50),
    colors JSON,
    fonts JSON,
    logoUrl VARCHAR(255),
    enabled BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId)
);

CREATE TABLE websitesProducts (
    websiteProductId INT AUTO_INCREMENT PRIMARY KEY,
    websiteId INT,
    productId INT,
    displayName VARCHAR(100),
    displayPriceLocal DECIMAL(10,2),
    enabled BOOLEAN DEFAULT TRUE,
    brandTypeId INT,
    currencyId INT,
    rateId INT,
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (brandTypeId) REFERENCES BrandsPositionsTypes(brandTypeId),
    FOREIGN KEY (currencyId) REFERENCES Currency(currencyId),
    FOREIGN KEY (rateId) REFERENCES currencyRates(rateId)
);

CREATE TABLE productRestrictionsPerCountry (
    restrictionId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT,
    countryId INT,
    restrictionTypeId INT,
    healthRegistrationNumber VARCHAR(50),
    registrationExpiration DATE,
    enabled BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (countryId) REFERENCES countries(countryId),
    FOREIGN KEY (restrictionTypeId) REFERENCES restrictionsTypes(restrictionId)
);

CREATE TABLE usersLogs (
    logId INT AUTO_INCREMENT PRIMARY KEY,
    eventType INT,
    dataObjectId INT,
    websiteId INT,
    sessionId INT,
    description VARCHAR(255),
    creadetAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSON,
    FOREIGN KEY (eventType) REFERENCES eventsTypes(eventTypeId),
    FOREIGN KEY (dataObjectId) REFERENCES dataObjects(dataObjectId),
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId),
    FOREIGN KEY (sessionId) REFERENCES sessions(sessionId)
);

CREATE TABLE orders (
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    websiteId INT,
    userId INT,
    countryId INT,
    orderStatuId INT,
    orderNumber INT,
    netAmountLocal DECIMAL(10,2),
    taxAmountLocal DECIMAL(10,2),
    totalGrossLocal DECIMAL(10,2),
    orderDate DATE,
    netAmountUSD DECIMAL(10,4),
    rateId INT,
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId),
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (countryId) REFERENCES countries(countryId),
    FOREIGN KEY (orderStatuId) REFERENCES ordersStatus(orderStatuId),
    FOREIGN KEY (rateId) REFERENCES currencyRates(rateId)
);

-- ==============================================================
-- 5. TABLAS CON DEPENDENCIAS NIVEL 4 (Finales)
-- ==============================================================
CREATE TABLE addresses (
    addressId INT AUTO_INCREMENT PRIMARY KEY,
    cityId INT,
    addressTypeId INT,
    address1 VARCHAR(100),
    address2 VARCHAR(100),
    postalCode VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(10, 8),
    FOREIGN KEY (cityId) REFERENCES cities(cityId),
    FOREIGN KEY (addressTypeId) REFERENCES addressType(addressTypeId)
);

CREATE TABLE orderItems (
    orderItemId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT,
    productId INT,
    quantity INT,
    itemPriceLocal DECIMAL(10,2),
    itemPriceUSD DECIMAL(10,2),
    taxLocal DECIMAL(10,2),
    itemTotalLocal DECIMAL(10,2),
    itemTotalUSD DECIMAL(10,2),
    FOREIGN KEY (orderId) REFERENCES orders(orderId),
    FOREIGN KEY (productId) REFERENCES products(productId)
);

CREATE TABLE spTransactionState (
    stateId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT NULL,
    statusTypeId INT,
    stepName VARCHAR(100),
    executionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    observations TEXT,
    FOREIGN KEY (orderId) REFERENCES orders(orderId),
    FOREIGN KEY (statusTypeId) REFERENCES statusTransactionType(statusTypeId)
);

CREATE TABLE usersAddresses (
    userAddressId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    addressID INT,
    enabled BOOLEAN DEFAULT TRUE,
    checksum VARBINARY(255),
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (addressID) REFERENCES addresses(addressId)
);

CREATE TABLE shipments (
    shipmentId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT,
    methodId INT,
    carrierId INT,
    shipmentStatusId INT,
    addressId INT,
    shippedAt DATETIME,
    deliveredAt DATETIME,
    estimatedDeliveryDaye DATE,
    shippingTaxId INT,
    FOREIGN KEY (orderId) REFERENCES orders(orderId),
    FOREIGN KEY (methodId) REFERENCES shippingMethods(methodId),
    FOREIGN KEY (carrierId) REFERENCES shippingCarriers(carrierId),
    FOREIGN KEY (shipmentStatusId) REFERENCES shipmentsStatus(shipmentStatusId),
    FOREIGN KEY (addressId) REFERENCES addresses(addressId),
    FOREIGN KEY (shippingTaxId) REFERENCES shippingTaxes(shippingTaxId)
);

CREATE TABLE shipmentsStatusHistory (
    shipmentHistoryId INT AUTO_INCREMENT PRIMARY KEY,
    shipmentId INT,
    shipmentStatusId INT,
    statusDate DATETIME,
    notes VARCHAR(150),
    evidence VARCHAR(255),
    addressId INT,
    FOREIGN KEY (shipmentId) REFERENCES shipments(shipmentId),
    FOREIGN KEY (shipmentStatusId) REFERENCES shipmentsStatus(shipmentStatusId),
    FOREIGN KEY (addressId) REFERENCES addresses(addressId)
);