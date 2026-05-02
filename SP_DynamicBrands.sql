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
        VALUES (IF(i % 2 = 0, v_cat_calzado, v_cat_acc), v_uom_par, CONCAT('Producto de Calzado Mod-', i), 1);
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




-- =============================================
-- 6. SIMULACIÓN DE ACTIVIDAD DE NEGOCIO (Órdenes, Inventario, Precios). Esto no se pide en el .md del caso#2 pero es para poder informacion extra en el dashboard
-- =============================================

USE dynamic_brands;

DELIMITER //

CREATE PROCEDURE sp_load_business_activity()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_order_id INT;
    DECLARE v_product_id INT;
    DECLARE v_website_id INT;
    DECLARE v_country_id INT;

    -- Manejo de errores[cite: 3]
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'Actividad Negocio', @msg);
    END;

    START TRANSACTION;

    -- 1. CREAR USUARIOS DE PRUEBA
    INSERT INTO users (name, lastName, email, enabled) VALUES 
    ('Juan', 'Pérez', 'juan@mail.com', 1),
    ('María', 'García', 'maria@mail.com', 1),
    ('John', 'Doe', 'john@mail.us', 1);

    -- 2. ASIGNAR INVENTARIO Y COSTOS (Para poder calcular ganancias)
    -- Vamos a recorrer los 100 productos y darles un stock y un costo base
    SET i = 1;
    WHILE i <= 100 DO
        INSERT INTO productInventory (productId, currentStock, lastUpdated)
        VALUES (i, FLOOR(10 + (RAND() * 50)), NOW());
        
        -- Historial de precios (Precio de Venta sugerido)
        INSERT INTO productPriceHistory (productId, websiteId, newPrice, changeDate)
        VALUES (i, (i % 9) + 1, (20 + (RAND() * 80)), NOW());
        
        SET i = i + 1;
    END WHILE;

    -- 3. SIMULAR 50 ÓRDENES ALEATORIAS[cite: 6]
    SET i = 1;
    WHILE i <= 50 DO
        -- Seleccionamos un sitio web y un producto al azar
        SET v_website_id = (SELECT websiteId FROM websites ORDER BY RAND() LIMIT 1);
        SET v_country_id = (SELECT countryId FROM websites WHERE websiteId = v_website_id);
        SET v_product_id = (SELECT productId FROM products ORDER BY RAND() LIMIT 1);

        -- Insertar la Orden[cite: 6]
        INSERT INTO orders (websiteId, userId, countryId, orderNumber, netAmountLocal, totalGrossLocal, orderDate)
        VALUES (v_website_id, (i % 3) + 1, v_country_id, 1000 + i, 50.00, 56.50, DATE_SUB(NOW(), INTERVAL i DAY));
        
        SET v_order_id = LAST_INSERT_ID();

        -- Insertar el Item de la orden[cite: 6]
        INSERT INTO orderItems (orderId, productId, quantity, itemPriceLocal, itemTotalLocal)
        VALUES (v_order_id, v_product_id, FLOOR(1 + RAND() * 3), 50.00, 50.00);

        -- 4. SIMULAR ENVÍO (Para ver pérdidas/gastos logísticos)[cite: 6]
        INSERT INTO shipments (orderId, methodId, carrierId, shipmentStatusId, shippedAt)
        VALUES (v_order_id, 1, 1, 1, NOW());

        SET i = i + 1;
    END WHILE;

    CALL sp_log_step(NULL, 'EXITO', 'Actividad Negocio', 'Inventario, Precios y 50 Órdenes generadas.');
    COMMIT;
END //

DELIMITER ;

-- Ejecutar la carga
CALL sp_load_business_activity();