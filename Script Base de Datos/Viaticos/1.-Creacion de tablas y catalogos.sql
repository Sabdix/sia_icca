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
INSERT INTO DT_CAT_TIPO_DIVISA(Descripcion) VALUES('DOLAR (USA)')
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
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_TBL_VIATICO_SOLICITUD]') AND type in (N'U'))
DROP TABLE [dbo].[DT_TBL_VIATICO_SOLICITUD]
GO

CREATE TABLE DT_TBL_VIATICO_SOLICITUD (
Id_Solicitud INT IDENTITY(1,1),
Fecha_Alta DATETIME DEFAULT GETDATE(),
Fecha_Inicio DATETIME,
Fecha_Fin DATETIME,
Duracion_Viaje DECIMAL(3,1),
Id_Medio_Transporte INT,
Proposito VARCHAR(300),
Resultados_Esperados VARCHAR(300),
Id_Justificacion INT,
Condiciones_Especiales VARCHAR(300) NULL,
Id_Tipo_Divisa INT,
Id_Estatus_Solicitud INT,
Em_Cve_Empleado VARCHAR(20),
Em_Cve_Empleado_Autoriza VARCHAR(20) NULL,
Id_Tipo_Viaje INT
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
Id_Tipo_Salida INT
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