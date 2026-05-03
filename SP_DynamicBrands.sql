USE dynamic_brands;

-- ============================================================================
-- DYNAMIC BRANDS - SCRIPT MODULAR DEFINITIVO (CORREGIDO)
-- ============================================================================

DROP PROCEDURE IF EXISTS sp_log_step;
DROP PROCEDURE IF EXISTS sp_load_base_data;
DROP PROCEDURE IF EXISTS sp_load_100_products;
DROP PROCEDURE IF EXISTS sp_load_9_websites;
DROP PROCEDURE IF EXISTS sp_load_business_activity;
DROP PROCEDURE IF EXISTS sp_orchestrate_full_load;

DELIMITER //

-- ----------------------------------------------------------------------------
-- 1. PROCEDIMIENTO DE AUDITORÍA (LOGS)
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_log_step(
    IN p_orderId INT, 
    IN p_statusName VARCHAR(50), 
    IN p_stepName VARCHAR(100), 
    IN p_obs TEXT
)
BEGIN
    DECLARE v_statusId INT;
    SELECT statusTypeId INTO v_statusId FROM statusTransactionType WHERE statusName = p_statusName LIMIT 1;
    
    IF v_statusId IS NULL THEN
        INSERT INTO statusTransactionType (statusName, statusDescription) 
        VALUES (p_statusName, CONCAT('Estado: ', p_statusName));
        SET v_statusId = LAST_INSERT_ID();
    END IF;

    INSERT INTO spTransactionState (orderId, statusTypeId, stepName, observations)
    VALUES (p_orderId, v_statusId, p_stepName, p_obs);
END //

-- ----------------------------------------------------------------------------
-- 2. CARGA DE CONFIGURACIÓN BASE (El Cimiento)
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_load_base_data()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'sp_load_base_data', @msg);
    END;

    START TRANSACTION;
    CALL sp_log_step(NULL, 'INICIO', 'sp_load_base_data', 'Cargando configuración base multipaís...');

    -- Usuarios
    INSERT IGNORE INTO users (userId, name, lastName, email, password, phone, enabled) VALUES 
        (1, 'Admin', 'Sistema', 'admin@dynamic.com', 'hash123', '88880001', 1),
        (2, 'Fabricio', 'Hernandez', 'fhernandez@test.com', 'hash123', '88880002', 1),
        (3, 'Cliente', 'Frecuente', 'cliente@test.com', 'hash123', '88880003', 1);
    
    -- Estados y Ubicaciones
    INSERT IGNORE INTO ordersStatus (orderStatuId, orderStatusName, orderStatuDescription) VALUES 
        (1, 'Completado', 'Procesado por simulación');
    INSERT IGNORE INTO hubZones (zoneId, zoneName, enabled) VALUES (1, 'Principal', 1), (2, 'Secundaria', 1);
    INSERT IGNORE INTO hubLayout (locationId, zoneId, aisle, shelf, bin) VALUES (1, 1, 'A1', '1', '1'), (2, 2, 'B2', '2', '2');
    INSERT IGNORE INTO batch (batchId, batchNumber, batchDescription, enabled) VALUES (1, 'B-SIM', 'Simulación', 1);

    -- Logística
    INSERT IGNORE INTO shippingMethods (methodId, methodName, enabled) VALUES (1, 'Estándar', 1), (2, 'Express', 1);
    INSERT IGNORE INTO shippingCarriers (carrierId, shippingCarrierName, contactInfo, enabled) VALUES 
        (1, 'Courier Genérico', 'info@courier.com', 1), (2, 'Fast Track', 'fast@track.com', 1);
    INSERT IGNORE INTO shipmentsStatus (shipmentStatusId, shipmentStatusName, description) VALUES (1, 'Entregado', 'Entregado al cliente');

    -- Monedas y Países (Garantizando la variedad para el DW)
    INSERT IGNORE INTO Currency (currencyId, name, simbol) VALUES 
        (1, 'USD', '$'), (2, 'Colones', '₡'), (3, 'Pesos COP', '$'), (4, 'Pesos MXN', '$');
        
    INSERT IGNORE INTO countries (countryId, countryName, isoCode, currencyId, enabled) VALUES 
        (1, 'Costa Rica', 'CRC', 2, 1), (2, 'Colombia', 'COL', 3, 1), 
        (3, 'Mexico', 'MEX', 4, 1), (4, 'USA', 'USA', 1, 1), (5, 'Nicaragua', 'NIC', 1, 1);

    INSERT IGNORE INTO addressType (addressTypeId, addressTypeName) VALUES (1, 'Hogar'), (2, 'Oficina');
    INSERT IGNORE INTO estates (estateId, countryId, estateName) VALUES (1,1,'San Jose'), (2,2,'Bogota'), (3,3,'CDMX');
    INSERT IGNORE INTO cities (cityId, estateId, cityName) VALUES (1,1,'Central'), (2,2,'Norte'), (3,3,'Sur');
    INSERT IGNORE INTO addresses (addressId, cityId, addressTypeId, address1, postalCode) VALUES 
        (1, 1, 1, 'Avenida 1', '1000'), (2, 2, 2, 'Calle 100', '11001'), (3, 3, 1, 'Reforma', '01000');
        
    INSERT IGNORE INTO currencyRates (rateId, currencyId, exchangeRate, rateDate) VALUES 
        (1, 1, 1.00, NOW()), (2, 2, 530.00, NOW()), (3, 3, 3900.00, NOW()), (4, 4, 17.00, NOW());
        
    INSERT IGNORE INTO shippingTaxes (shippingTaxId, countryId, taxPercent, description) VALUES 
        (1, 1, 0.13, 'IVA CR'), (2, 2, 0.19, 'IVA COL'), (3, 3, 0.16, 'IVA MEX');

    -- Categorías
    INSERT IGNORE INTO productCategories (productCategoryId, name, description, healthRiskLevel) VALUES 
        (1, 'Cosmética', 'Cremas', 'Bajo'), (2, 'Suplementos', 'Vitaminas', 'Medio');
    INSERT IGNORE INTO BrandsPositionsTypes (brandTypeId, brandTypeName, brandTypeDescription) VALUES 
        (1, 'Premium', 'Lujo'), (2, 'Eco', 'Verde');
    INSERT IGNORE INTO UnitsOfMeasures (unitOfMeasureId, symbol, name) VALUES 
        (1, 'PAR', 'Par de unidades'), (2, 'U', 'Unidad');

    CALL sp_log_step(NULL, 'EXITO', 'sp_load_base_data', 'Configuración base cargada con éxito.');
    COMMIT;
END //

-- ----------------------------------------------------------------------------
-- 3. CARGA DE INVENTARIO (100 PRODUCTOS)
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_load_100_products()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'sp_load_100_products', @msg);
    END;

    START TRANSACTION;
    CALL sp_log_step(NULL, 'INICIO', 'sp_load_100_products', 'Generando 100 productos...');

    WHILE i <= 100 DO
        INSERT IGNORE INTO products (productId, productCategoryId, unitOfMeasureId, productName, enabled)
        VALUES (i, IF(i % 2 = 0, 1, 2), 1, CONCAT('Etheria Item ', i), 1);
        SET i = i + 1;
    END WHILE;

    CALL sp_log_step(NULL, 'EXITO', 'sp_load_100_products', '100 productos insertados.');
    COMMIT;
END //

-- ----------------------------------------------------------------------------
-- 4. CARGA DE WEBSITES (9 SITIOS)
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_load_9_websites()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'sp_load_9_websites', @msg);
    END;

    START TRANSACTION;
    CALL sp_log_step(NULL, 'INICIO', 'sp_load_9_websites', 'Generando 9 sitios web...');

    INSERT IGNORE INTO websites (websiteId, countryId, brandName, domain, marketingFocus, enabled) VALUES 
    (1, 1, 'EcoStep CR', 'ecostep.cr', 'Ecológico', 1), 
    (2, 1, 'Luxury CR', 'luxury.cr', 'Premium', 1),
    (3, 4, 'Elite US', 'elite.us', 'High-End', 1), 
    (4, 4, 'Fast Shoe US', 'fastshoe.us', 'Retail', 1),
    (5, 5, 'Nica Bio', 'nica.ni', 'Natural', 1), 
    (6, 3, 'CDMX Style', 'cdmx.mx', 'Urbano', 1),
    (7, 3, 'Regio Zapato', 'mty.mx', 'Mayoreo', 1), 
    (8, 2, 'Andina CO', 'andina.co', 'Tradicional', 1),
    (9, 2, 'Bogota Run', 'bogota.co', 'Deportivo', 1);

    CALL sp_log_step(NULL, 'EXITO', 'sp_load_9_websites', '9 sitios web configurados.');
    COMMIT;
END //

-- ----------------------------------------------------------------------------
-- 5. SIMULACIÓN DE ACTIVIDAD (La Reconstrucción Podada y Potenciada)
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_load_business_activity()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_order_id, v_product_id, v_website_id, v_user_id INT;
    DECLARE v_country_id, v_method_id, v_carrier_id, v_ship_status_id INT;
    DECLARE v_batch_id, v_location_id, v_rate_id, v_address_id, v_shipping_tax_id INT;
    DECLARE v_random_price DECIMAL(10,2);
    DECLARE v_random_qty INT; -- <-- ¡CORRECCIÓN! Movido al techo del bloque BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'sp_load_business_activity', @msg);
    END;

    START TRANSACTION;
    CALL sp_log_step(NULL, 'INICIO', 'sp_load_business_activity', 'Generando transacciones aleatorias...');

    -- A. Stock y Precios
    SET i = 1;
    WHILE i <= 100 DO
        SET v_website_id = (SELECT websiteId FROM websites ORDER BY RAND() LIMIT 1);
        SET v_location_id = (SELECT locationId FROM hubLayout ORDER BY RAND() LIMIT 1);
        SET v_batch_id = (SELECT batchId FROM batch ORDER BY RAND() LIMIT 1);
        
        INSERT IGNORE INTO productInventory (productId, batchId, currentStock, locationId, lastUpdated)
        VALUES (i, IFNULL(v_batch_id, 1), FLOOR(50 + (RAND() * 500)), IFNULL(v_location_id, 1), NOW());
        
        INSERT IGNORE INTO productPriceHistory (productId, websiteId, newPrice, changeDate, updatedBy)
        VALUES (i, IFNULL(v_website_id, 1), ROUND((150 + (RAND() * 200)), 2), NOW(), 1);
        
        SET i = i + 1;
    END WHILE;

    -- B. Órdenes Reales Aleatorias (300 para asegurar rentabilidad)
    SET i = 1;
    WHILE i <= 300 DO
        -- Adiós embudo: Selección 100% aleatoria en cada iteración
        SET v_website_id = (SELECT websiteId FROM websites ORDER BY RAND() LIMIT 1);
        SET v_country_id = (SELECT countryId FROM countries ORDER BY RAND() LIMIT 1);
        SET v_product_id = (SELECT productId FROM products ORDER BY RAND() LIMIT 1);
        SET v_user_id = (SELECT userId FROM users ORDER BY RAND() LIMIT 1);
        SET v_rate_id = (SELECT rateId FROM currencyRates WHERE currencyId = (SELECT currencyId FROM countries WHERE countryId = IFNULL(v_country_id, 1)) ORDER BY RAND() LIMIT 1);
        SET v_address_id = (SELECT addressId FROM addresses ORDER BY RAND() LIMIT 1);
        SET v_method_id = (SELECT methodId FROM shippingMethods ORDER BY RAND() LIMIT 1);
        SET v_carrier_id = (SELECT carrierId FROM shippingCarriers ORDER BY RAND() LIMIT 1);
        SET v_ship_status_id = (SELECT shipmentStatusId FROM shipmentsStatus ORDER BY RAND() LIMIT 1);
        SET v_shipping_tax_id = (SELECT shippingTaxId FROM shippingTaxes ORDER BY RAND() LIMIT 1);

        -- Precios inflados para ganancias masivas
        SET v_random_price = ROUND((150 + (RAND() * 300)), 2);
        SET v_random_qty = FLOOR(2 + RAND() * 5); -- <-- ¡CORRECCIÓN! Ahora usamos SET dentro del bucle

        INSERT INTO orders (
            websiteId, userId, countryId, orderNumber, 
            netAmountLocal, taxAmountLocal, totalGrossLocal, 
            orderDate, orderStatuId, netAmountUSD, rateId
        )
        VALUES (
            IFNULL(v_website_id, 1), IFNULL(v_user_id, 1), IFNULL(v_country_id, 1), 80000 + i, 
            v_random_price * v_random_qty, ROUND((v_random_price * v_random_qty) * 0.13, 2), 
            ROUND((v_random_price * v_random_qty) * 1.13, 2), DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY), 
            1, ((v_random_price * v_random_qty) / IFNULL(v_rate_id, 1)), IFNULL(v_rate_id, 1)
        );

        SET v_order_id = LAST_INSERT_ID();

        INSERT INTO orderItems (
            orderId, productId, quantity, 
            itemPriceLocal, itemTotalLocal, taxLocal, 
            itemPriceUSD, itemTotalUSD
        )
        VALUES (
            v_order_id, IFNULL(v_product_id, 1), v_random_qty, 
            v_random_price, (v_random_price * v_random_qty), ROUND((v_random_price * v_random_qty) * 0.13, 2),
            (v_random_price / IFNULL(v_rate_id, 1)), ((v_random_price * v_random_qty) / IFNULL(v_rate_id, 1))
        );

        INSERT INTO shipments (
            orderId, methodId, carrierId, 
            shipmentStatusId, addressId, shippingTaxId, shippedAt
        )
        VALUES (
            v_order_id, IFNULL(v_method_id, 1), IFNULL(v_carrier_id, 1), 
            IFNULL(v_ship_status_id, 1), IFNULL(v_address_id, 1), IFNULL(v_shipping_tax_id, 1), NOW()
        );

        SET i = i + 1;
    END WHILE;

    CALL sp_log_step(NULL, 'EXITO', 'sp_load_business_activity', '300 transacciones insertadas limpiamente.');
    COMMIT;
END //

-- ----------------------------------------------------------------------------
-- 6. ORQUESTADOR MAESTRO (El director de la orquesta)
-- ----------------------------------------------------------------------------
CREATE PROCEDURE sp_orchestrate_full_load()
BEGIN
    CALL sp_log_step(NULL, 'INICIO', 'ORQUESTADOR', 'Iniciando secuencia de carga maestra...');
    
    CALL sp_load_base_data();
    CALL sp_load_100_products();
    CALL sp_load_9_websites();
    CALL sp_load_business_activity();
    
    CALL sp_log_step(NULL, 'EXITO', 'ORQUESTADOR', 'Secuencia maestra completada.');
END //

DELIMITER ;

-- ============================================================================
-- EJECUCIÓN DE LA ORQUESTACIÓN
-- ============================================================================
CALL sp_orchestrate_full_load();