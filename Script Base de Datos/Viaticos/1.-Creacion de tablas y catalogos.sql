USE IICA_1
GO

--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_TIPO_VIAJE]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_TIPO_VIAJE]
GO

CREATE TABLE DT_CAT_TIPO_VIAJE (
Id_Tipo_Viaje INT IDENTITY(1,1),
Descripcion VARCHAR(40)
)
GO

TRUNCATE TABLE DT_CAT_TIPO_VIAJE

INSERT INTO DT_CAT_TIPO_VIAJE(Descripcion) VALUES('NACIONAL')
INSERT INTO DT_CAT_TIPO_VIAJE(Descripcion) VALUES('INTERNACIONAL')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_MEDIO_TRANSPORTE]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_MEDIO_TRANSPORTE]
GO

CREATE TABLE DT_CAT_MEDIO_TRANSPORTE (
Id_Medio_Transporte INT IDENTITY(1,1),
Descripcion VARCHAR(40)
)
GO

TRUNCATE TABLE DT_CAT_MEDIO_TRANSPORTE

INSERT INTO DT_CAT_MEDIO_TRANSPORTE(Descripcion) VALUES('TERRESTRE')
INSERT INTO DT_CAT_MEDIO_TRANSPORTE(Descripcion) VALUES('AÉREO')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_JUSTIFICACION]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_JUSTIFICACION]
GO

CREATE TABLE DT_CAT_JUSTIFICACION (
Id_Justificacion INT IDENTITY(1,1),
Descripcion VARCHAR(100)
)
GO

TRUNCATE TABLE DT_CAT_JUSTIFICACION

INSERT INTO DT_CAT_JUSTIFICACION(Descripcion) VALUES('SOLICITUD DEL REPRESENTANTE O INSTITUCIÓN')
INSERT INTO DT_CAT_JUSTIFICACION(Descripcion) VALUES('OFRECIMIENTO DE DIRECTOR Y/O COORDINADOR')
INSERT INTO DT_CAT_JUSTIFICACION(Descripcion) VALUES('MECANISMO DE PROGRAMACIÓN, SUPERVISIÓN, AUDITORIA Y EVALUACIÓN')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_TIPO_SALIDA]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_TIPO_SALIDA]
GO

CREATE TABLE DT_CAT_TIPO_SALIDA (
Id_Tipo_Salida INT IDENTITY(1,1),
Descripcion VARCHAR(40)
)
GO

TRUNCATE TABLE DT_CAT_TIPO_SALIDA

INSERT INTO DT_CAT_TIPO_SALIDA(Descripcion) VALUES('IDA')
INSERT INTO DT_CAT_TIPO_SALIDA(Descripcion) VALUES('REGRESO')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_TIPO_DIVISA]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_TIPO_DIVISA]
GO

CREATE TABLE DT_CAT_TIPO_DIVISA (
Id_Tipo_Divisa INT IDENTITY(1,1),
Descripcion VARCHAR(40)
)
GO

TRUNCATE TABLE DT_CAT_TIPO_DIVISA

INSERT INTO DT_CAT_TIPO_DIVISA(Descripcion) VALUES('PESOS (MX)')
INSERT INTO DT_CAT_TIPO_DIVISA(Descripcion) VALUES('DOLAR (DLS)')
INSERT INTO DT_CAT_TIPO_DIVISA(Descripcion) VALUES('EURO (EURO)')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_GASTO_EXTRA]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_GASTO_EXTRA]
GO

CREATE TABLE DT_CAT_GASTO_EXTRA (
Id_Gasto_Extra INT IDENTITY(1,1),
Descripcion VARCHAR(100)
)
GO

TRUNCATE TABLE DT_CAT_GASTO_EXTRA

INSERT INTO DT_CAT_GASTO_EXTRA(Descripcion) VALUES('TRANSPORTE AÉREO')
INSERT INTO DT_CAT_GASTO_EXTRA(Descripcion) VALUES('PEAJE / GASOLINA')
INSERT INTO DT_CAT_GASTO_EXTRA(Descripcion) VALUES('AUTOBÚS')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_GASTO_COMPROBACION]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_GASTO_COMPROBACION]
GO

CREATE TABLE DT_CAT_GASTO_COMPROBACION (
Id_Gasto_Comprobacion INT IDENTITY(1,1),
Descripcion VARCHAR(100)
)
GO

TRUNCATE TABLE DT_CAT_GASTO_COMPROBACION

INSERT INTO DT_CAT_GASTO_COMPROBACION(Descripcion) VALUES('HOTEL')
INSERT INTO DT_CAT_GASTO_COMPROBACION(Descripcion) VALUES('TRANSPORTE')
INSERT INTO DT_CAT_GASTO_COMPROBACION(Descripcion) VALUES('ALIMENTOS')
INSERT INTO DT_CAT_GASTO_COMPROBACION(Descripcion) VALUES('GASOLINA')
INSERT INTO DT_CAT_GASTO_COMPROBACION(Descripcion) VALUES('PEAJE')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_ETAPAS_SOLICITUD_VIATICO]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_ETAPAS_SOLICITUD_VIATICO]
GO

CREATE TABLE DT_CAT_ETAPAS_SOLICITUD_VIATICO (
Id_etapa_solicitud INT IDENTITY(1,1),
Descripcion VARCHAR(40)
)
GO

TRUNCATE TABLE DT_CAT_ETAPAS_SOLICITUD_VIATICO
INSERT INTO DT_CAT_ETAPAS_SOLICITUD_VIATICO(Descripcion) VALUES('GENERADA')
INSERT INTO DT_CAT_ETAPAS_SOLICITUD_VIATICO(Descripcion) VALUES('ENVIADA')
INSERT INTO DT_CAT_ETAPAS_SOLICITUD_VIATICO(Descripcion) VALUES('COMPLETAR DATOS')
INSERT INTO DT_CAT_ETAPAS_SOLICITUD_VIATICO(Descripcion) VALUES('GENERACION CHEQUE')
INSERT INTO DT_CAT_ETAPAS_SOLICITUD_VIATICO(Descripcion) VALUES('COMPROBACION GASTOS')
INSERT INTO DT_CAT_ETAPAS_SOLICITUD_VIATICO(Descripcion) VALUES('VERIFICACION DE GASTOS')
INSERT INTO DT_CAT_ETAPAS_SOLICITUD_VIATICO(Descripcion) VALUES('FINALIZADA')
GO

--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_ESTATUS_SOLICITUD_VIATICO]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_ESTATUS_SOLICITUD_VIATICO]
GO

CREATE TABLE DT_CAT_ESTATUS_SOLICITUD_VIATICO (
Id_estatus_solicitud INT IDENTITY(1,1),
Descripcion VARCHAR(40)
)
GO
TRUNCATE TABLE DT_CAT_ESTATUS_SOLICITUD_VIATICO
INSERT INTO DT_CAT_ESTATUS_SOLICITUD_VIATICO(Descripcion) VALUES('CORRECTA')
INSERT INTO DT_CAT_ESTATUS_SOLICITUD_VIATICO(Descripcion) VALUES('DEVUELTA')
INSERT INTO DT_CAT_ESTATUS_SOLICITUD_VIATICO(Descripcion) VALUES('CANCELADA')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_NIVEL_MANDO]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_NIVEL_MANDO]
GO

CREATE TABLE DT_CAT_NIVEL_MANDO (
Id_Nivel_Mando INT IDENTITY(1,1),
Descripcion VARCHAR(40)
)
GO

TRUNCATE TABLE DT_CAT_NIVEL_MANDO

INSERT INTO DT_CAT_NIVEL_MANDO(Descripcion) VALUES('OPERATIVO')
INSERT INTO DT_CAT_NIVEL_MANDO(Descripcion) VALUES('MEDIO')
INSERT INTO DT_CAT_NIVEL_MANDO(Descripcion) VALUES('SUPERIOR')
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_TARIFA_VIATICO]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_TARIFA_VIATICO]
GO

CREATE TABLE DT_CAT_TARIFA_VIATICO (
Id_Tarifa_Viatico INT IDENTITY(1,1),
Tarifa MONEY,
Pernocta BIT,
Marginal BIT,
Id_Tipo_Viaje INT,
Id_Tipo_Divisa INT,
Id_Nivel_Mando INT
)
GO

TRUNCATE TABLE DT_CAT_TARIFA_VIATICO

--Combinaciones de mando Operativo
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(980,1,0,1,1,1)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(490,0,0,1,1,1)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(450,1,0,2,2,1)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(450,1,0,2,3,1)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(225,0,0,2,2,1)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(225,0,0,2,3,1)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(550,1,1,1,1,1)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(435,0,1,1,1,1)

--Combinaciones de mando Medio
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(1700,1,0,1,1,2)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(850,0,0,1,1,2)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(450,1,0,2,2,2)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(450,1,0,2,3,2)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(225,0,0,2,2,2)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(225,0,0,2,3,2)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(750,1,1,1,1,2)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(625,0,1,1,1,2)

--Combinaciones de mando Superior
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(2850,1,0,1,1,3)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(1425,0,0,1,1,3)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(450,1,0,2,2,3)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(450,1,0,2,3,3)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(225,0,0,2,2,3)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(225,0,0,2,3,3)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(925,1,1,1,1,3)
INSERT INTO DT_CAT_TARIFA_VIATICO(Tarifa,Pernocta,Marginal,Id_Tipo_Viaje,Id_Tipo_Divisa,Id_Nivel_Mando) VALUES(900,0,1,1,1,3)
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_TBL_VIATICO_SOLICITUD]') AND type in (N'U'))
DROP TABLE [dbo].[DT_TBL_VIATICO_SOLICITUD]
GO

CREATE TABLE DT_TBL_VIATICO_SOLICITUD (
Id_Solicitud INT IDENTITY(1,1),
Fecha_Alta DATETIME DEFAULT GETDATE(),
Fecha_Inicio DATETIME,
Fecha_Fin DATETIME,
Duracion_Viaje DECIMAL(3,1),
Pernocta bit,
Marginal bit,
Proposito VARCHAR(300),
Resultados_Esperados VARCHAR(300),
Condiciones_Especiales VARCHAR(300) NULL,
Tarifa_de_Ida MONEY,
Tarifa_de_Vuelta MONEY,
Monto_Viatico_Autorizado MONEY,
Monto_Viatico_Comprobado MONEY,
Fecha_Cheque DATETIME,
Path_Archivo_Autorizacion VARCHAR(300) NULL,
Monto_Viatico_Reintegro MONEY NULL,
Path_Comprobante_Estancia VARCHAR(300) NULL,
Path_Archivo_10_No_Comprobable VARCHAR(300) NULL,
Path_Informe_Viaje VARCHAR(300) NULL,
Fecha_Reintegro DATETIME,
Importe_Reintegro MONEY,
Path_Archivo_Reintegro VARCHAR(300) NULL,
Consecutivo_Anual VARCHAR(100),
Id_Medio_Transporte INT,
Id_Justificacion INT,
Id_Tipo_Divisa INT,
Id_Etapa_Solicitud INT,
Id_Estatus_Solicitud INT,
Em_Cve_Empleado VARCHAR(20),
Em_Cve_Empleado_Autoriza VARCHAR(20) NULL,
Id_Tipo_Viaje INT,
Path_i4 VARCHAR(300) NULL,
Path_i5 VARCHAR(300) NULL,
)
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_TBL_VIATICO_ITINERARIO]') AND type in (N'U'))
DROP TABLE [dbo].[DT_TBL_VIATICO_ITINERARIO]
GO

CREATE TABLE DT_TBL_VIATICO_ITINERARIO (
Id_Itinerario INT IDENTITY(1,1),
Origen VARCHAR(300),
Destino VARCHAR(300),
Id_Medio_Transporte INT,
Linea VARCHAR(35) NULL,
Numero_Asiento VARCHAR(35) NULL,
Hora_Salida VARCHAR(6) NULL,
Hora_Llegada VARCHAR(6) NULL,
Fecha_Salida DATETIME NULL,
Fecha_Llegada DATETIME NULL, 
Dias DECIMAL(3,1),
Path_Boleto VARCHAR(250) NULL,
Id_Solicitud INT,
Id_Tipo_Salida INT,
Path_Pasaje_Abordar VARCHAR(300)
)
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD]') AND type in (N'U'))
DROP TABLE [dbo].[DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD]
GO

CREATE TABLE DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD (
Contador INT IDENTITY(1,1),
Descripcion VARCHAR(100),
Monto MONEY,
Id_Solicitud INT
)
GO

--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_TBL_VIATICO_COMPROBACION_GASTOS]') AND type in (N'U'))
DROP TABLE [dbo].[DT_TBL_VIATICO_COMPROBACION_GASTOS]
GO

CREATE TABLE DT_TBL_VIATICO_COMPROBACION_GASTOS (
Id_Comprobacion_Gasto INT IDENTITY(1,1),
Id_Solicitud INT,
Comentario VARCHAR(500),
Path_Archivo_XML VARCHAR(500),
Path_Archivo_PDF VARCHAR(500),
Path_Archivo_SAT VARCHAR(500),
Path_Archivo_Otros VARCHAR(500),
Id_Gasto_Comprobacion INT,
Emisor VARCHAR(500),
Subtotal MONEY,
Total MONEY,
Lugar VARCHAR(500),
Fecha DATETIME
)
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_CONSECUTIVO_VIAJE_NACIONAL]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_CONSECUTIVO_VIAJE_NACIONAL]
GO

CREATE TABLE DT_CAT_CONSECUTIVO_VIAJE_NACIONAL (
Contador INT IDENTITY(1,1),
Ejercicio INT,
Consecutivo INT
)
GO

TRUNCATE TABLE DT_CAT_CONSECUTIVO_VIAJE_NACIONAL

INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2019,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2020,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2021,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2022,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2023,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2024,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2025,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2026,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2027,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2028,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2029,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_NACIONAL(Ejercicio,Consecutivo) VALUES(2030,1)
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL]
GO

CREATE TABLE DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL (
Contador INT IDENTITY(1,1),
Ejercicio INT,
Consecutivo INT
)
GO

TRUNCATE TABLE DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL

INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2019,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2020,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2021,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2022,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2023,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2024,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2025,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2026,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2027,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2028,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2029,1)
INSERT INTO DT_CAT_CONSECUTIVO_VIAJE_INTERNACIONAL(Ejercicio,Consecutivo) VALUES(2030,1)

GO
--==========================================================================================================================