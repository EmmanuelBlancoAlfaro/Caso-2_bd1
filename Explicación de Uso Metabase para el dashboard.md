	
	
	##GUÍA DE USO Y CONFIGURACIÓN DE METABASE

	1. Requisitos Previos y Acceso
		Instalación de Docker: Asegúrese de tener Docker Desktop (o Docker Engine en Linux) instalado y ejecutándose en su computadora.  

		Levantamiento de Servicios: Abra una terminal en la carpeta raíz del proyecto y ejecute el comando docker-compose up -d. Esto iniciará los contenedores de las bases de datos y el servidor de BI.  

		Ingreso al Portal: Una vez que el contenedor metabase_bi esté en estado Running, abra su navegador e ingrese a la dirección http://localhost:3000.  

	2. Configuración de la Fuente de Datos
		Inicio de Sesión: Complete el asistente de bienvenida creando su cuenta de administrador.

		Conexión al Data Warehouse: Cuando el sistema le solicite añadir sus datos, seleccione PostgreSQL e ingrese los siguientes parámetros de red interna de Docker:  

		Nombre: Data Warehouse Proyecto.  

		Host: data_warehouse_db (Nombre del servicio definido en el YAML).  

		Puerto: 5432.  

		Base de Datos: data_warehouse.  

		Usuario: postgres.  

		Contraseña: tu_password_seguro.  

	3. Creación de Análisis y Visualizaciones
		Exploración de Datos: En el panel principal, diríjase a "Browse Data" y seleccione la tabla MonthlyRentabilityRegisters. Esta tabla contiene los datos ya unificados de Etheria y Dynamic Brands.

		Generación de Consultas: Haga clic en "+ New", luego en "Question" para empezar a crear gráficos.

		Filtros: Utilice la opción "Filter" para segmentar por brandname o destinycountry.

		Agrupación: Use "Summarize" para sumar los ingresos (salesincome) o costos (importationcost) agrupados por mes o año.

		Visualización: Cambie entre tablas, gráficos de barras o pasteles según el indicador de rentabilidad que desee analizar.

	4. Visualización del Dashboard Gerencial
		Armado del Tablero: Una vez creados sus gráficos (Preguntas), guárdelos y añádalos a un Dashboard.

		Interactividad: Agregue filtros globales en la parte superior del Dashboard para permitir que el usuario final realice consultas dinámicas por país o marca.

		Análisis de Rentabilidad: Interprete los resultados negativos iniciales como una inversión en inventario (finalstock), demostrando la capacidad del sistema para proyectar ganancias futuras.
		
	PD: Si este tutorial no le sirve, busque en google la solución o preguntele a una IA xD