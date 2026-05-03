CREATE TABLE Currency (
    currencyId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    simbol VARCHAR(10) NOT NULL
);

CREATE TABLE addressType (
    addressTypeId INT AUTO_INCREMENT PRIMARY KEY,
    addressTypeName VARCHAR(100) NOT NULL
);

CREATE TABLE batch (
    batchId INT AUTO_INCREMENT PRIMARY KEY,
    batchNumber VARCHAR(50) NOT NULL,
    batchDescription VARCHAR(150) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE TABLE UnitsOfMeasures (
    unitOfMeasureId INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE BrandsPositionsTypes (
    brandTypeId INT AUTO_INCREMENT PRIMARY KEY,
    brandTypeName VARCHAR(50) NOT NULL,
    brandTypeDescription VARCHAR(100) NOT NULL
);

CREATE TABLE hubZones (
    zoneId INT AUTO_INCREMENT PRIMARY KEY,
    zoneName VARCHAR(50) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE TABLE productAttributes (
    attributeId INT AUTO_INCREMENT PRIMARY KEY,
    attributeName VARCHAR(50) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE TABLE ordersStatus (
    orderStatuId INT AUTO_INCREMENT PRIMARY KEY,
    orderStatusName VARCHAR(20) NOT NULL,
    orderStatuDescription VARCHAR(100) NOT NULL
);

CREATE TABLE shippingMethods (
    methodId INT AUTO_INCREMENT PRIMARY KEY,
    methodName VARCHAR(50) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE TABLE shipmentsStatus (
    shipmentStatusId INT AUTO_INCREMENT PRIMARY KEY,
    shipmentStatusName VARCHAR(20) NOT NULL,
    description VARCHAR(50) NOT NULL
);

CREATE TABLE taxesTypes (
    taxTypeId INT AUTO_INCREMENT PRIMARY KEY,
    taxTypeName VARCHAR(100) NOT NULL,
    taxTypeDescription VARCHAR(150) NOT NULL
);

CREATE TABLE restrictionsTypes (
    restrictionId INT AUTO_INCREMENT PRIMARY KEY,
    restrictionTypeName VARCHAR(50) NOT NULL,
    restrictionTypeDescription VARCHAR(100) NOT NULL
);

CREATE TABLE eventsTypes (
    eventTypeId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(150) NOT NULL
);

CREATE TABLE dataObjects (
    dataObjectId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(100) NOT NULL
);

CREATE TABLE severities (
    severityId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(100) NOT NULL
);

CREATE TABLE statusTransactionType (
    statusTypeId INT AUTO_INCREMENT PRIMARY KEY,
    statusName VARCHAR(50) NOT NULL,
    statusDescription VARCHAR(150) NOT NULL
);

CREATE TABLE productCategories (
    productCategoryId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    description VARCHAR(100) NOT NULL,
    healthRiskLevel VARCHAR(20) NOT NULL
);

CREATE TABLE shippingCarriers (
    carrierId INT AUTO_INCREMENT PRIMARY KEY,
    shippingCarrierName VARCHAR(50) NOT NULL,
    lastName VARCHAR(30),
    contactInfo VARCHAR(100) NOT NULL,
    trackingTemplate VARCHAR(200),
    enabled BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE TABLE currencyRates (
    rateId INT AUTO_INCREMENT PRIMARY KEY,
    currencyId INT NOT NULL,
    exchangeRate DECIMAL(18,6) NOT NULL,
    rateDate DATE NOT NULL,
    FOREIGN KEY (currencyId) REFERENCES Currency(currencyId)
);

CREATE TABLE countries (
    countryId INT AUTO_INCREMENT PRIMARY KEY,
    isoCode VARCHAR(3) NOT NULL UNIQUE,
    countryName VARCHAR(50) NOT NULL,
    currencyId INT NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL,
    FOREIGN KEY (currencyId) REFERENCES Currency(currencyId)
);

CREATE TABLE hubLayout (
    locationId INT AUTO_INCREMENT PRIMARY KEY,
    zoneId INT NOT NULL,
    aisle VARCHAR(10) NOT NULL,
    shelf VARCHAR(10) NOT NULL,
    bin VARCHAR(10) NOT NULL,
    FOREIGN KEY (zoneId) REFERENCES hubZones(zoneId)
);

CREATE TABLE categoryAttributes (
    categoryAttributeId INT AUTO_INCREMENT PRIMARY KEY,
    productCategoryId INT NOT NULL,
    attributeId INT NOT NULL,
    FOREIGN KEY (productCategoryId) REFERENCES productCategories(productCategoryId),
    FOREIGN KEY (attributeId) REFERENCES productAttributes(attributeId)
);

CREATE TABLE users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARBINARY(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE TABLE priceShippingMethod (
    priceMethodId INT AUTO_INCREMENT PRIMARY KEY,
    methodId INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (methodId) REFERENCES shippingMethods(methodId)
);

CREATE TABLE shippingTaxes (
    shippingTaxId INT AUTO_INCREMENT PRIMARY KEY,
    countryId INT NOT NULL,
    taxPercent DECIMAL(5,2) NOT NULL,
    description VARCHAR(50) NOT NULL,
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE systemErrorsLogs (
    errorId INT AUTO_INCREMENT PRIMARY KEY,
    severityId INT NOT NULL,
    processUuid VARCHAR(100) NOT NULL,
    processName VARCHAR(100) NOT NULL,
    stepName VARCHAR(100) NOT NULL,
    inputData JSON,
    errorMesage TEXT NOT NULL,
    createdAt DATE NOT NULL,
    FOREIGN KEY (severityId) REFERENCES severities(severityId)
);

CREATE TABLE estates (
    estateId INT AUTO_INCREMENT PRIMARY KEY,
    countryId INT NOT NULL,
    estateName VARCHAR(70) NOT NULL,
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE products (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productCategoryId INT NOT NULL,
    unitOfMeasureId INT NOT NULL,
    productName VARCHAR(100) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL,
    FOREIGN KEY (productCategoryId) REFERENCES productCategories(productCategoryId),
    FOREIGN KEY (unitOfMeasureId) REFERENCES UnitsOfMeasures(unitOfMeasureId)
);

CREATE TABLE websites (
    websiteId INT AUTO_INCREMENT PRIMARY KEY,
    countryId INT NOT NULL,
    brandName VARCHAR(150) NOT NULL,
    domain VARCHAR(100) NOT NULL UNIQUE,
    marketingFocus TEXT,
    enabled BOOLEAN DEFAULT TRUE NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (countryId) REFERENCES countries(countryId)
);

CREATE TABLE sessions (
    sessionId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    sessionToken VARCHAR(100) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (userId) REFERENCES users(userId)
);

CREATE TABLE taxesPerCountry (
    taxId INT AUTO_INCREMENT PRIMARY KEY,
    countryId INT NOT NULL,
    taxTypeId INT NOT NULL,
    validFrom DATE NOT NULL,
    validUntil DATE,
    productCategoryId INT NOT NULL,
    tax_percent DECIMAL(5,2) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL,
    FOREIGN KEY (countryId) REFERENCES countries(countryId),
    FOREIGN KEY (taxTypeId) REFERENCES taxesTypes(taxTypeId),
    FOREIGN KEY (productCategoryId) REFERENCES productCategories(productCategoryId)
);

CREATE TABLE cities (
    cityId INT AUTO_INCREMENT PRIMARY KEY,
    estateId INT NOT NULL,
    cityName VARCHAR(100) NOT NULL,
    FOREIGN KEY (estateId) REFERENCES estates(estateId)
);

CREATE TABLE productAttributeValues (
    valueId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT NOT NULL,
    attributeId INT NOT NULL,
    valueText VARCHAR(255) NOT NULL,
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (attributeId) REFERENCES productAttributes(attributeId)
);

CREATE TABLE productInventory (
    inventoryId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT NOT NULL,
    batchId INT NOT NULL,
    currentStock INT NOT NULL DEFAULT 0,
    locationId INT NOT NULL,
    lastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (batchId) REFERENCES batch(batchId),
    FOREIGN KEY (locationId) REFERENCES hubLayout(locationId)
);

CREATE TABLE productPriceHistory (
    priceHistoryId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT NOT NULL,
    websiteId INT NOT NULL,
    newPrice DECIMAL(10,2) NOT NULL,
    changeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updatedBy INT NOT NULL,
    checksum VARBINARY(32),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId),
    FOREIGN KEY (updatedBy) REFERENCES users(userId)
);

CREATE TABLE websiteThemes (
    themeId INT AUTO_INCREMENT PRIMARY KEY,
    websiteId INT NOT NULL,
    themeName VARCHAR(50) NOT NULL,
    colors JSON NOT NULL,
    fonts JSON,
    logoUrl VARCHAR(255),
    enabled BOOLEAN DEFAULT TRUE NOT NULL,
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId)
);

CREATE TABLE websitesProducts (
    websiteProductId INT AUTO_INCREMENT PRIMARY KEY,
    websiteId INT NOT NULL,
    productId INT NOT NULL,
    displayName VARCHAR(100) NOT NULL,
    displayPriceLocal DECIMAL(10,2) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL,
    brandTypeId INT NOT NULL,
    currencyId INT NOT NULL,
    rateId INT NOT NULL,
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId),
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (brandTypeId) REFERENCES BrandsPositionsTypes(brandTypeId),
    FOREIGN KEY (currencyId) REFERENCES Currency(currencyId),
    FOREIGN KEY (rateId) REFERENCES currencyRates(rateId)
);

CREATE TABLE productRestrictionsPerCountry (
    restrictionId INT AUTO_INCREMENT PRIMARY KEY,
    productId INT NOT NULL,
    countryId INT NOT NULL,
    restrictionTypeId INT NOT NULL,
    healthRegistrationNumber VARCHAR(50) NOT NULL,
    registrationExpiration DATE NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL,
    FOREIGN KEY (productId) REFERENCES products(productId),
    FOREIGN KEY (countryId) REFERENCES countries(countryId),
    FOREIGN KEY (restrictionTypeId) REFERENCES restrictionsTypes(restrictionId)
);

CREATE TABLE usersLogs (
    logId INT AUTO_INCREMENT PRIMARY KEY,
    eventType INT NOT NULL,
    dataObjectId INT NOT NULL,
    websiteId INT NOT NULL,
    sessionId INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    metadata JSON,
    FOREIGN KEY (eventType) REFERENCES eventsTypes(eventTypeId),
    FOREIGN KEY (dataObjectId) REFERENCES dataObjects(dataObjectId),
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId),
    FOREIGN KEY (sessionId) REFERENCES sessions(sessionId)
);

CREATE TABLE orders (
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    websiteId INT NOT NULL,
    userId INT NOT NULL,
    countryId INT NOT NULL,
    orderStatuId INT NOT NULL,
    orderNumber VARCHAR(50) NOT NULL UNIQUE,
    netAmountLocal DECIMAL(10,2) NOT NULL,
    taxAmountLocal DECIMAL(10,2) NOT NULL,
    totalGrossLocal DECIMAL(10,2) NOT NULL,
    orderDate DATE NOT NULL,
    netAmountUSD DECIMAL(10,4),
    rateId INT,
    FOREIGN KEY (websiteId) REFERENCES websites(websiteId),
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (countryId) REFERENCES countries(countryId),
    FOREIGN KEY (orderStatuId) REFERENCES ordersStatus(orderStatuId),
    FOREIGN KEY (rateId) REFERENCES currencyRates(rateId)
);

CREATE TABLE addresses (
    addressId INT AUTO_INCREMENT PRIMARY KEY,
    cityId INT NOT NULL,
    addressTypeId INT NOT NULL,
    address1 VARCHAR(100) NOT NULL,
    address2 VARCHAR(100),
    postalCode VARCHAR(20) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(10, 8),
    FOREIGN KEY (cityId) REFERENCES cities(cityId),
    FOREIGN KEY (addressTypeId) REFERENCES addressType(addressTypeId)
);

CREATE TABLE orderItems (
    orderItemId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    itemPriceLocal DECIMAL(10,2) NOT NULL,
    itemPriceUSD DECIMAL(10,2),
    taxLocal DECIMAL(10,2) NOT NULL,
    itemTotalLocal DECIMAL(10,2) NOT NULL,
    itemTotalUSD DECIMAL(10,2),
    FOREIGN KEY (orderId) REFERENCES orders(orderId),
    FOREIGN KEY (productId) REFERENCES products(productId)
);

CREATE TABLE spTransactionState (
    stateId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT,
    statusTypeId INT NOT NULL,
    stepName VARCHAR(100) NOT NULL,
    executionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    observations TEXT,
    FOREIGN KEY (orderId) REFERENCES orders(orderId),
    FOREIGN KEY (statusTypeId) REFERENCES statusTransactionType(statusTypeId)
);

CREATE TABLE usersAddresses (
    userAddressId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    addressID INT NOT NULL,
    enabled BOOLEAN DEFAULT TRUE NOT NULL,
    checksum VARBINARY(255),
    FOREIGN KEY (userId) REFERENCES users(userId),
    FOREIGN KEY (addressID) REFERENCES addresses(addressId)
);

CREATE TABLE shipments (
    shipmentId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT NOT NULL,
    methodId INT NOT NULL,
    carrierId INT NOT NULL,
    shipmentStatusId INT NOT NULL,
    addressId INT NOT NULL,
    shippedAt DATETIME,
    deliveredAt DATETIME,
    estimatedDeliveryDate DATE,
    shippingTaxId INT NOT NULL,
    FOREIGN KEY (orderId) REFERENCES orders(orderId),
    FOREIGN KEY (methodId) REFERENCES shippingMethods(methodId),
    FOREIGN KEY (carrierId) REFERENCES shippingCarriers(carrierId),
    FOREIGN KEY (shipmentStatusId) REFERENCES shipmentsStatus(shipmentStatusId),
    FOREIGN KEY (addressId) REFERENCES addresses(addressId),
    FOREIGN KEY (shippingTaxId) REFERENCES shippingTaxes(shippingTaxId)
);

CREATE TABLE shipmentsStatusHistory (
    shipmentHistoryId INT AUTO_INCREMENT PRIMARY KEY,
    shipmentId INT NOT NULL,
    shipmentStatusId INT NOT NULL,
    statusDate DATETIME NOT NULL,
    notes VARCHAR(150) NOT NULL,
    evidence VARCHAR(255),
    addressId INT NOT NULL,
    FOREIGN KEY (shipmentId) REFERENCES shipments(shipmentId),
    FOREIGN KEY (shipmentStatusId) REFERENCES shipmentsStatus(shipmentStatusId),
    FOREIGN KEY (addressId) REFERENCES addresses(addressId)
);