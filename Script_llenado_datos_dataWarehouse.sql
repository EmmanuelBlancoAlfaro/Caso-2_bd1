INSERT INTO monthlyrentabilityregisters (
    destinycountry,
    suppliercountry,
    brandname,
    courierservice,
    year,
    month,
    quantityimported,
    quantitysold,
    quantitytreturned, -- <--- Corregido según tu imagen
    finalstock,
    importationcost,
    salesincome,
    couriercost,
    totalearning
)
SELECT 
    COALESCE(c."countryName", 'Unknown Destination') AS destinycountry,        
    COALESCE(ec.countryName, 'Unknown Origin') AS suppliercountry,      
    COALESCE(w."brandName", 'No Brand') AS brandname,             
    COALESCE(sc."shippingCarrierName", 'No Courier') AS courierservice, 
    EXTRACT(YEAR FROM o."orderDate") AS year,
    EXTRACT(MONTH FROM o."orderDate") AS month,
    
    -- Cantidades
    COALESCE(SUM(epod.quantityReceived), 0) AS quantityimported, 
    COALESCE(SUM(oi."quantity"), 0) AS quantitysold,
    
    -- Cálculo de Devoluciones (Diferencia entre orden y recibo)[cite: 3]
    COALESCE(SUM(epod.quantityOrdered - epod.quantityReceived), 0) AS quantitytreturned,
    
    COALESCE(MIN(pi."currentStock"), 0) AS finalstock, 
    
    -- Financieros
    COALESCE(SUM(epod.subTotalUSD), 0) AS importationcost, 
    COALESCE(SUM(o."totalGrossLocal"), 0) AS salesincome, 
    COALESCE(SUM(eplc.totalAmountUSD), 0) AS couriercost, 
    
    -- Rentabilidad: Ventas - (Costo Compra + Costo Envío)
    (COALESCE(SUM(o."totalGrossLocal"), 0) - 
    (COALESCE(SUM(epod.subTotalUSD), 0) + COALESCE(SUM(eplc.totalAmountUSD), 0))) AS totalearning

FROM public.orders o
JOIN public.countries c ON o."countryId" = c."countryId" 
JOIN public.websites w ON o."websiteId" = w."websiteId" 
JOIN public."orderItems" oi ON o."orderId" = oi."orderId" 
JOIN public.products p ON oi."productId" = p."productId"
LEFT JOIN public."productInventory" pi ON p."productId" = pi."productId"
LEFT JOIN public.shipments s ON o."orderId" = s."orderId"
LEFT JOIN public."shippingCarriers" sc ON s."carrierId" = sc."carrierId"

-- CRUCE DINÁMICO CON ETHERIA[cite: 3, 5]
LEFT JOIN etheria_data.eth_products ep ON TRIM(p."productName") ILIKE TRIM(ep.productname)
LEFT JOIN etheria_data.eth_purchaseordersdetails epod ON ep.productId = epod.productId
LEFT JOIN etheria_data.eth_purchaseorders epo ON epod.purchaseOrderId = epo.purchaseOrderId
LEFT JOIN etheria_data.eth_suppliers es ON epo.supplierId = es.supplierId
LEFT JOIN etheria_data.eth_countries ec ON es.countryId = ec.countryId 
LEFT JOIN etheria_data.eth_purchaseorderslandedcosts eplc ON epo.purchaseOrderId = eplc.purchaseOrderId

GROUP BY 
    c."countryName", ec.countryName, w."brandName", sc."shippingCarrierName", 
    EXTRACT(YEAR FROM o."orderDate"), EXTRACT(MONTH FROM o."orderDate");