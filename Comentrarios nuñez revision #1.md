Dynamic Brands Errores:



1\. Patron address faltan campos en el patron (La verdad no se que falta xD)

2\. Batch no se usa para nada (si se esta usando)

3\. En products usar patron de características variables

4\. En product inventory el hubLocation se necesita normalizar

5\. En el productPriceHistory evitar updates mejor diseñar para hacer inserts únicamente

6\. En websites, el marketingFocus es muy pequeño, el validUntil debería borrarse, el theme se debe dividir en una tabla aparte

7\. En websitesProducts la columna display priceLocal falta asociar a currencies y rates

8\. Customers falta ponerle password

9\. En orders agregar un orderNumber

10\. En shippingCarries el TEXT en trackingTemplate no sirve de nada

11\. En shipmentsStatusHistory se necesita mas trazabilidad

12\. ProductRestrictionsPerCountry en la restrictionDescription no usar TEXT.



DIFICULTADES:

FACIL: 2, 8, 9, 10, 12

MEDIO: 1, 5, 6, 7, 11

DIFICIL: 3, 4









Etheria errores:

1\. Countries, control de vigencia (un enabled) y manejar tiempos, se puede aplicar a diferentes tablas dentro del modulo

2\. En states, se necesita algún mecanismo para manejar estados activos/inactivos o historial de cambios

3\. Addresses, no cubre geográficas, no tiene referencias o control de cambios

4\. Employees, solo es un comentario, pero no se sabe si es necesaria la tabla

5\. ContactTypes, revisar tamaño definido, pensar en convención uniforme para campos booleanos

6\. EmpoyeeContacts, no usar TEXT

7\. Incoterms, NO ENTENDI NI COSTRA XD

8\. Suppliers, revisar si la información es suficiente para identificar y dar seguimiento a proveedores a lo largo del tiempo

9\. SuppliersContacts, unirlo con contactTypes

10\. StatusTypes, cambiar la columna name y darle un nombre que no genere confucion, esto aplica en varias tablas

11\. UnitsOfMeasure, validar el naming con el resto del modelo.

12\. PaymentMethods, incompleto estos methods

13\. CostsTypes, mejorar mecanismos de control

14\. Products, no podes tener dateOfImportacion, esto va suceder muchas veces en el tiempo

15\. PurchaseOrders, no permite dar seguimiento completo al ciclo de una compra, tanto en términos logísticos como financieros.

16\. PurchaseOrdersDetails, lo mismo de arriba, y que pasó con las monedas? pagos, transacciones, ver por donde va el producto, etc. 



DIFICULTADES:

FACIL: 4, 5, 6, 7, 10

MEDIO: 1, 2, 3, 9, 11, 14

DIFICIL: 8, 12, 13, 15, 16













