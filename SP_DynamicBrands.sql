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
    IN p_orderId INT, 
    IN p_statusName VARCHAR(50), 
    IN p_stepName VARCHAR(100), 
    IN p_obs TEXT
)
BEGIN
    DECLARE v_statusId INT;
    -- Busca el estado o lo crea si no existe
    SELECT statusTypeId INTO v_statusId FROM statusTransactionType WHERE statusName = p_statusName LIMIT 1;
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
    DECLARE v_curr_colon, v_curr_dolar, v_curr_euro, v_curr_mx, v_curr_col INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'Carga Base', @msg);
    END;

    START TRANSACTION;
    
    -- Insertar Monedas y capturar IDs dinámicamente[cite: 3]
    INSERT INTO Currency (name, simbol) VALUES ('Colon', '₡'); SET v_curr_colon = LAST_INSERT_ID();
    INSERT INTO Currency (name, simbol) VALUES ('Dolar', '$'); SET v_curr_dolar = LAST_INSERT_ID();
    INSERT INTO Currency (name, simbol) VALUES ('Euro', '€'); SET v_curr_euro = LAST_INSERT_ID();
    INSERT INTO Currency (name, simbol) VALUES ('Peso MX', '$'); SET v_curr_mx = LAST_INSERT_ID();
    INSERT INTO Currency (name, simbol) VALUES ('Peso COL', '$'); SET v_curr_col = LAST_INSERT_ID();

    -- Insertar Países vinculados a las monedas[cite: 3]
    INSERT INTO countries (isoCode, countryName, currencyId, enabled) VALUES 
    ('CRC', 'Costa Rica', v_curr_colon, 1),
    ('USA', 'USA', v_curr_dolar, 1),
    ('ESP', 'España', v_curr_euro, 1),
    ('MEX', 'México', v_curr_mx, 1),
    ('COL', 'Colombia', v_curr_col, 1);

    -- Tipos de Posicionamiento[cite: 3]
    INSERT INTO BrandsPositionsTypes (brandTypeName, brandTypeDescription) 
    VALUES ('Premium', 'Lujo y Exclusividad'), ('Eco', 'Sostenibilidad y Ambiente');

    CALL sp_log_step(NULL, 'EXITO', 'Carga Base', 'Configuración de países y monedas completada.');
    COMMIT;
END //

-- =============================================
-- 3. CARGA DE INVENTARIO (100 PRODUCTOS)
-- =============================================
CREATE PROCEDURE sp_load_100_products()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_cat_calzado, v_cat_acc, v_uom_par INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_log_step(NULL, 'ERROR', 'Productos', @msg);
    END;

    START TRANSACTION;
    -- Categorías y Unidades[cite: 3]
    INSERT INTO productCategories (name, description, healthRiskLevel) 
    VALUES ('Calzado', 'Todo tipo de zapatos', 'Bajo'), ('Accesorios', 'Complementos', 'Bajo');
    SET v_cat_calzado = (SELECT productCategoryId FROM productCategories WHERE name = 'Calzado' LIMIT 1);
    SET v_cat_acc = (SELECT productCategoryId FROM productCategories WHERE name = 'Accesorios' LIMIT 1);

    INSERT INTO UnitsOfMeasures (symbol, name) VALUES ('PAR', 'Par de unidades');
    SET v_uom_par = LAST_INSERT_ID();

    -- Bucle para 100 productos[cite: 3]
    WHILE i <= 100 DO
        INSERT INTO products (productCategoryId, unitOfMeasureId, productName, enabled)
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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
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

    CALL sp_log_step(NULL, 'EXITO', 'Websites', '9 sitios web configurados.');
    COMMIT;
END //

-- =============================================
-- 5. ORQUESTADOR MAESTRO
-- =============================================
CREATE PROCEDURE sp_orchestrate_full_load()
BEGIN
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