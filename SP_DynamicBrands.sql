USE dynamic_brands;

-- =============================================
-- 0. LIMPIEZA DE AMBIENTE
-- =============================================
DROP PROCEDURE IF EXISTS sp_log_step;
DROP PROCEDURE IF EXISTS sp_load_base_data;
DROP PROCEDURE IF EXISTS sp_load_100_products;
DROP PROCEDURE IF EXISTS sp_load_9_websites;
DROP PROCEDURE IF EXISTS sp_orchestrate_full_load;

DELIMITER //

-- =============================================
-- 1. PROCEDIMIENTO DE AUDITORÍA (LOGS)
-- =============================================
CREATE PROCEDURE sp_log_step(
    -- Parámetros para el log de auditoría
    IN p_orderId INT, 
    IN p_statusName VARCHAR(50), 
    IN p_stepName VARCHAR(100), 
    IN p_obs TEXT
)
BEGIN
    -- Variable para el ID del estado
    DECLARE v_statusId INT;
    -- Si existe algun estado con el nombre dado, se obtiene su ID, sino se crea uno nuevo
    SELECT statusTypeId INTO v_statusId FROM statusTransactionType WHERE statusName = p_statusName LIMIT 1;
    
    -- Aqui se crea un nuevo estado si no existe, y se obtiene su ID para usarlo en el log de transacciones
    IF v_statusId IS NULL THEN
        INSERT INTO statusTransactionType (statusName, statusDescription) 
        VALUES (p_statusName, CONCAT('Estado: ', p_statusName));
        SET v_statusId = LAST_INSERT_ID();
    END IF;

    -- Inserta el log en la tabla de estados
    INSERT INTO spTransactionState (orderId, statusTypeId, stepName, observations)
    VALUES (p_orderId, v_statusId, p_stepName, p_obs);
END //

-- =============================================
-- 2. CARGA DE CONFIGURACIÓN BASE
-- =============================================
CREATE PROCEDURE sp_load_base_data()
BEGIN
    -- Variables para capturar IDs de monedas insertadas dinámicamente
    DECLARE v_curr_colon, v_curr_dolar, v_curr_euro, v_curr_mx, v_curr_col INT;
    
    -- Manejo de errores para asegurar que cualquier fallo en la inserción de datos se capture y se registre adecuadamente
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Captura del mensaje de error y registro en el log de auditoría
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        -- Registro del error en el log de auditoría con el mensaje capturado
        CALL sp_log_step(NULL, 'ERROR', 'Carga Base', @msg);
    END;

    START TRANSACTION;
    
    -- Insertar Monedas y capturar IDs dinámicamente
    INSERT INTO Currency (name, simbol) VALUES ('Colon', '₡'); SET v_curr_colon = LAST_INSERT_ID();
    INSERT INTO Currency (name, simbol) VALUES ('Dolar', '$'); SET v_curr_dolar = LAST_INSERT_ID();
    INSERT INTO Currency (name, simbol) VALUES ('Euro', '€'); SET v_curr_euro = LAST_INSERT_ID();
    INSERT INTO Currency (name, simbol) VALUES ('Peso MX', '$'); SET v_curr_mx = LAST_INSERT_ID();
    INSERT INTO Currency (name, simbol) VALUES ('Peso COL', '$'); SET v_curr_col = LAST_INSERT_ID();

    -- Insertar Países vinculados a las monedas
    INSERT INTO countries (isoCode, countryName, currencyId, enabled) VALUES 
    ('CRC', 'Costa Rica', v_curr_colon, 1),
    ('USA', 'USA', v_curr_dolar, 1),
    ('ESP', 'España', v_curr_euro, 1),
    ('MEX', 'México', v_curr_mx, 1),
    ('COL', 'Colombia', v_curr_col, 1);

    -- Tipos de Posicionamiento de Marca
    INSERT INTO BrandsPositionsTypes (brandTypeName, brandTypeDescription) 
    VALUES ('Premium', 'Lujo y Exclusividad'), ('Eco', 'Sostenibilidad y Ambiente');

    -- Log de éxito para la carga base
    CALL sp_log_step(NULL, 'EXITO', 'Carga Base', 'Configuración de países y monedas completada.');
    COMMIT;
END //

-- =============================================
-- 3. CARGA DE INVENTARIO (100 PRODUCTOS)
-- =============================================
CREATE PROCEDURE sp_load_100_products()
BEGIN
    -- Variables para controlar el bucle y almacenar IDs de categorías y unidades de medida
    DECLARE i INT DEFAULT 1;
    DECLARE v_cat_calzado, v_cat_acc, v_uom_par INT;

    -- Manejo de errores para asegurar que cualquier fallo en la inserción de productos se capture y se registre adecuadamente
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Captura del mensaje de error y registro en el log de auditoría
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'Productos', @msg);
    END;

    -- Inicia la transacción para la inserción de productos
    START TRANSACTION;

    -- Categorías y Unidades
    INSERT INTO productCategories (name, description, healthRiskLevel) 
    VALUES ('Calzado', 'Todo tipo de zapatos', 'Bajo'), ('Accesorios', 'Complementos', 'Bajo');
    
    -- Captura de IDs de categorías para usarlos en la inserción de productos
    SET v_cat_calzado = (SELECT productCategoryId FROM productCategories WHERE name = 'Calzado' LIMIT 1);
    SET v_cat_acc = (SELECT productCategoryId FROM productCategories WHERE name = 'Accesorios' LIMIT 1);

    -- Inserción de unidad de medida para pares de unidades y captura de su ID para usarlo en los productos
    INSERT INTO UnitsOfMeasures (symbol, name) VALUES ('PAR', 'Par de unidades');
    SET v_uom_par = LAST_INSERT_ID();

    -- Bucle para 100 productos
    WHILE i <= 100 DO
        INSERT INTO products (productCategoryId, unitOfMeasureId, productName, enabled)
        -- Alterna entre categorías de calzado y accesorios para diversificar el inventario, usando los IDs capturados dinámicamente
        -- El if determina que si es impar usa la categoría de accesorios, y si es par usa la categoría de calzado, para asegurar una distribución equilibrada
        VALUES (IF(i % 2 = 0, v_cat_calzado, v_cat_acc), v_uom_par, CONCAT('Etheria Item ', i), 1);
        SET i = i + 1;
    END WHILE;

    CALL sp_log_step(NULL, 'EXITO', 'Productos', 'Se han insertado 100 productos correctamente.');
    COMMIT;
END //

-- =============================================
-- 4. CARGA DE WEBSITES (9 SITIOS)
-- =============================================
CREATE PROCEDURE sp_load_9_websites()
BEGIN

    -- Manejo de errores para asegurar que cualquier fallo en la inserción de sitios web se capture y se registre adecuadamente
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Captura del mensaje de error y registro en el log de auditoría
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'Websites', @msg);
    END;

    START TRANSACTION;
    -- Inserción de 9 sitios web usando IDs de países existentes[cite: 3]
    INSERT INTO websites (countryId, brandName, domain, marketingFocus, enabled) VALUES 
    (1, 'EcoStep CR', 'ecostep.cr', 'Ecológico', 1), 
    (1, 'Luxury CR', 'luxury.cr', 'Premium', 1),
    (2, 'Elite US', 'elite.us', 'High-End', 1), 
    (2, 'Fast Shoe US', 'fastshoe.us', 'Retail', 1),
    (3, 'Madrid Shoes', 'madrid.es', 'Europeo', 1), 
    (4, 'CDMX Style', 'cdmx.mx', 'Urbano', 1),
    (4, 'Regio Zapato', 'mty.mx', 'Mayoreo', 1), 
    (5, 'Andina CO', 'andina.co', 'Tradicional', 1),
    (5, 'Bogota Run', 'bogota.co', 'Deportivo', 1);

    -- Log de éxito para la carga de sitios web
    CALL sp_log_step(NULL, 'EXITO', 'Websites', '9 sitios web configurados.');
    COMMIT;
END //

-- =============================================
-- 5. ORQUESTADOR MAESTRO
-- =============================================
CREATE PROCEDURE sp_orchestrate_full_load()
BEGIN
    -- Log de inicio del proceso maestro para tener un registro claro del comienzo de la carga masiva
    CALL sp_log_step(NULL, 'INICIO', 'SISTEMA', 'Iniciando carga masiva de Dynamic Brands...');
    
    CALL sp_load_base_data();
    CALL sp_load_100_products();
    CALL sp_load_9_websites();
    
    CALL sp_log_step(NULL, 'EXITO', 'SISTEMA', 'Proceso finalizado con éxito.');
END //

DELIMITER ;

-- =============================================
-- EJECUCIÓN DEL PROCESO
-- =============================================
CALL sp_orchestrate_full_load();

-- Verificación rápida de logs
SELECT * FROM spTransactionState;




-- ==============================================================
-- RECONSTRUCCIÓN DEFINITIVA - PROTECCIÓN TOTAL CONTRA NULOS
-- ==============================================================
USE dynamic_brands;

DROP PROCEDURE IF EXISTS sp_load_business_activity;

DELIMITER //

CREATE PROCEDURE sp_load_business_activity()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_order_id INT;
    DECLARE v_product_id INT;
    DECLARE v_website_id INT;
    DECLARE v_user_id INT;
    DECLARE v_status_id INT;
    DECLARE v_country_id INT;
    DECLARE v_method_id INT; 
    DECLARE v_carrier_id INT; 
    DECLARE v_ship_status_id INT; 
    DECLARE v_random_price DECIMAL(10,2);
    
    DECLARE v_batch_id INT;
    DECLARE v_location_id INT;
    DECLARE v_rate_id INT;
    DECLARE v_address_id INT;
    DECLARE v_shipping_tax_id INT;

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'Actividad Negocio', @msg);
    END;

    START TRANSACTION;

    -- 1. GARANTIZAR TODAS LAS TABLAS MAESTRAS (Requisitos NOT NULL)
    
    -- Usuarios
    INSERT IGNORE INTO users (userId, name, lastName, email, enabled) 
    VALUES (1, 'Admin', 'Sistema', 'admin@dynamic.com', 1);
    
    -- Estados de Orden (El que te dio error)
    INSERT IGNORE INTO ordersStatus (orderStatuId, orderStatusName, orderStatuDescription) 
    VALUES (1, 'Completado', 'Procesado por simulación');

    -- Ubicaciones e Inventario
    INSERT IGNORE INTO hubZones (zoneId, zoneName, enabled) VALUES (1, 'Principal', 1);
    INSERT IGNORE INTO hubLayout (locationId, zoneId, aisle, shelf, bin) VALUES (1, 1, 'A1', '1', '1');
    INSERT IGNORE INTO batch (batchId, batchNumber, batchDescription, enabled) VALUES (1, 'B-SIM', 'Simulación', 1);

    -- Envíos y Geografía
    INSERT IGNORE INTO shippingMethods (methodId, methodName, enabled) VALUES (1, 'Estándar', 1);
    INSERT IGNORE INTO shippingCarriers (carrierId, shippingCarrierName, enabled) VALUES (1, 'Courier Genérico', 1);
    INSERT IGNORE INTO shipmentsStatus (shipmentStatusId, shipmentStatusName) VALUES (1, 'Entregado');
    INSERT IGNORE INTO shippingTaxes (shippingTaxId, taxName, taxRate) VALUES (1, 'IVA Envío', 0.13);
    
    -- Direcciones y Moneda (Asegúrate de que existan países en countries antes de esto)
    -- Si falla aquí, es porque no hay países. Insertamos uno de emergencia.
    INSERT IGNORE INTO countries (countryId, countryName, isoCode) VALUES (1, 'Costa Rica', 'CR');
    INSERT IGNORE INTO addresses (addressId, countryId, city, streetAddress) VALUES (1, 1, 'San José', 'Avenida Central');
    INSERT IGNORE INTO currencyRates (rateId, fromCurrency, toCurrency, rateValue) VALUES (1, 'CRC', 'USD', 530.00);

    -- 2. ASIGNACIÓN INICIAL DE VARIABLES DE RESPALDO (Evita NULLs si el RAND() falla)
    SELECT userId INTO v_user_id FROM users LIMIT 1;
    SELECT locationId INTO v_location_id FROM hubLayout LIMIT 1;
    SELECT orderStatuId INTO v_status_id FROM ordersStatus LIMIT 1;
    SELECT rateId INTO v_rate_id FROM currencyRates LIMIT 1;
    SELECT addressId INTO v_address_id FROM addresses LIMIT 1;
    SELECT shippingTaxId INTO v_shipping_tax_id FROM shippingTaxes LIMIT 1;
    SELECT batchId INTO v_batch_id FROM batch LIMIT 1;
    SELECT methodId INTO v_method_id FROM shippingMethods LIMIT 1;
    SELECT carrierId INTO v_carrier_id FROM shippingCarriers LIMIT 1;
    SELECT shipmentStatusId INTO v_ship_status_id FROM shipmentsStatus LIMIT 1;

    -- 3. CARGA DE INVENTARIO Y PRECIOS (100 Productos)
    SET i = 1;
    WHILE i <= 100 DO
        SELECT websiteId INTO v_website_id FROM websites ORDER BY RAND() LIMIT 1;
        -- Si no hay websites, usamos un valor 1 o saltamos (asumiendo que hay al menos 1)
        
        INSERT INTO productInventory (productId, batchId, currentStock, locationId, lastUpdated)
        VALUES (i, v_batch_id, FLOOR(5 + (RAND() * 50)), v_location_id, NOW());
        
        INSERT INTO productPriceHistory (productId, websiteId, newPrice, changeDate, updatedBy)
        VALUES (i, IFNULL(v_website_id, 1), ROUND((10 + (RAND() * 90)), 2), NOW(), v_user_id);
        
        SET i = i + 1;
    END WHILE;

    -- 4. CARGA DE ÓRDENES (50 Órdenes)
    SET i = 1;
    WHILE i <= 50 DO
        -- Intentar obtener valores aleatorios, pero con respaldo (IFNULL)
        SET v_website_id = (SELECT websiteId FROM websites ORDER BY RAND() LIMIT 1);
        SET v_country_id = (SELECT countryId FROM countries ORDER BY RAND() LIMIT 1);
        SET v_product_id = (SELECT productId FROM products ORDER BY RAND() LIMIT 1);
        SET v_random_price = ROUND((20 + (RAND() * 80)), 2);

        INSERT INTO orders (
            websiteId, userId, countryId, orderNumber, 
            netAmountLocal, taxAmountLocal, totalGrossLocal, 
            orderDate, orderStatuId, netAmountUSD, rateId
        )
        VALUES (
            IFNULL(v_website_id, 1), v_user_id, IFNULL(v_country_id, 1), 30000 + i, 
            v_random_price, ROUND(v_random_price * 0.13, 2), 
            ROUND(v_random_price * 1.13, 2), DATE_SUB(NOW(), INTERVAL i DAY), 
            v_status_id, (v_random_price / 530), v_rate_id
        );

        SET v_order_id = LAST_INSERT_ID();

        INSERT INTO orderItems (
            orderId, productId, quantity, 
            itemPriceLocal, itemTotalLocal, taxLocal, 
            itemPriceUSD, itemTotalUSD
        )
        VALUES (
            v_order_id, IFNULL(v_product_id, 1), FLOOR(1 + RAND() * 2), 
            v_random_price, v_random_price, ROUND(v_random_price * 0.13, 2),
            (v_random_price / 530), (v_random_price / 530)
        );

        INSERT INTO shipments (
            orderId, methodId, carrierId, 
            shipmentStatusId, addressId, shippingTaxId, shippedAt
        )
        VALUES (
            v_order_id, v_method_id, v_carrier_id, 
            v_ship_status_id, v_address_id, v_shipping_tax_id, NOW()
        );

        SET i = i + 1;
    END WHILE;

    CALL sp_log_step(NULL, 'EXITO', 'Actividad Negocio', 'Simulación limpia: Cero valores nulos en campos obligatorios.');
    COMMIT;
END //

DELIMITER ;

CALL sp_load_business_activity();