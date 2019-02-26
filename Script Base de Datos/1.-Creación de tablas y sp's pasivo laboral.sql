--Se agregan los indices para las tablas a las que se realizan busquedas por los id's
USE IICA_COMPRAS
GO

IF NOT EXISTS( SELECT * FROM sys.indexes WHERE name='IDX_IICA_COMPRAS_SUCURSAL' AND object_id = OBJECT_ID('dbo.Sucursal'))
BEGIN
	CREATE INDEX IDX_IICA_COMPRAS_SUCURSAL
	ON Sucursal (Sc_Cve_Sucursal);
END
GO

IF NOT EXISTS( SELECT * FROM sys.indexes WHERE name='IDX_IICA_COMPRAS_DEPARTAMENTO' AND object_id = OBJECT_ID('dbo.Departamento'))
BEGIN
	CREATE INDEX IDX_IICA_COMPRAS_DEPARTAMENTO
	ON Departamento (Dp_Cve_Departamento);
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'AgregaAutorizadorPVITrigger'))
	DROP TRIGGER AgregaAutorizadorPVITrigger
GO
GO
 
-- Cremamos un Trigger sobre la tabla Viaticos_Autorizadores
CREATE TRIGGER AgregaAutorizadorPVITrigger
ON Viaticos_Autorizadores
 AFTER INSERT AS 
	
	DECLARE
		@Id_Ultimo_Autorizador VARCHAR(100),
		@Em_Cve_Empleado_Ultimo_Autorizador VARCHAR(100),
		@Proyecto_Ultimo_Autorizador VARCHAR(20)
		
	SELECT
		@Id_Ultimo_Autorizador=aut_id,
		@Em_Cve_Empleado_Ultimo_Autorizador=Em_Cve_Empleado,
		@Proyecto_Ultimo_Autorizador=aut_proyecto
	FROM Viaticos_Autorizadores
	WHERE aut_id=(SELECT MAX(aut_id) FROM Viaticos_Autorizadores)
	
	IF NOT EXISTS(SELECT 1 FROM Viaticos_Autorizadores WHERE Em_Cve_Empleado=@Em_Cve_Empleado_Ultimo_Autorizador and aut_proyecto=@Proyecto_Ultimo_Autorizador and aut_nivel='D')
	BEGIN
		INSERT
			INTO Viaticos_Autorizadores 
					(
					aut_id,
					aut_nombre,
					aut_username,
					aut_correo,
					aut_proyecto,
					aut_nivel,
					Es_Cve_Estado,
					Em_Cve_Empleado,
					Em_UserDef_1,
					Em_UserDef_2
				)
			SELECT 
				RIGHT('00000' + Ltrim(Rtrim(1+CONVERT(INT,@Id_Ultimo_Autorizador))),7),--Nuevo Id
				aut_nombre,
				aut_username,
				aut_correo,
				aut_proyecto,
				'D',
				Es_Cve_Estado,
				Em_Cve_Empleado,
				Em_UserDef_1,
				Em_UserDef_2
			FROM
				Viaticos_Autorizadores
			WHERE
				aut_id=@Id_Ultimo_Autorizador
	END

 GO

USE IICA_1
GO

/****** Object:  UserDefinedFunction [dbo].[FN_DSI_DIFERENCIA_FECHAS]    Script Date: 23/02/2019 05:02:46 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*

AUTOR			CHRISTIAN PEÑA ROMERO
OBJETIVO		OBTENER LA DIFERENCIA EN DIAS, MESES Y AÑOS ENTRE 2 FECHAS

*/

IF EXISTS (SELECT * FROM   sys.objects WHERE  object_id = OBJECT_ID(N'[dbo].[FN_DSI_DIFERENCIA_FECHAS]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
  DROP FUNCTION [dbo].[FN_DSI_DIFERENCIA_FECHAS]
GO 


CREATE FUNCTION [dbo].[FN_DSI_DIFERENCIA_FECHAS](@FECHA_INICIAL AS DATETIME, @FECHA_FIN AS DATETIME) RETURNS @CALCULO TABLE(ANIOS INT, MESES INT, DIAS INT)
AS
BEGIN
	DECLARE @AÑOS INT, @MESES INT, @DIAS INT
	SET @años = datediff(yy, @FECHA_INICIAL, @FECHA_FIN)
	if dateadd(yy, @años, @FECHA_INICIAL) > @FECHA_FIN 
		set @años = @años - 1 

	set @FECHA_INICIAL = dateadd(yy, @años, @FECHA_INICIAL) 
	set @meses = datediff(mm, @FECHA_INICIAL, @FECHA_FIN) 
	if dateadd(mm, @meses, @FECHA_INICIAL) > @FECHA_FIN 
		set @meses = @meses - 1 

	set @FECHA_INICIAL = dateadd(mm, @meses, @FECHA_INICIAL) 
	set @dias = datediff(dd, @FECHA_INICIAL, @FECHA_FIN) 
	set @FECHA_INICIAL = dateadd(dd, @dias, @FECHA_INICIAL)

	INSERT INTO @CALCULO VALUES(@AÑOS,@MESES,@DIAS)

	RETURN
END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_CAT_STATUS_SOLICITUD')
BEGIN
	DROP TABLE DT_CAT_STATUS_SOLICITUD
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_CAT_STATUS_SOLICITUD')
BEGIN
	CREATE TABLE DT_CAT_STATUS_SOLICITUD
	(
		Id_Status_Solicitud INT IDENTITY (1,1),
		Descripcion_Status_Solicitud VARCHAR (100)
	)
	TRUNCATE TABLE DT_CAT_STATUS_SOLICITUD
	INSERT INTO DT_CAT_STATUS_SOLICITUD(Descripcion_Status_Solicitud) VALUES('SOLICITUD ENVIADA')
	INSERT INTO DT_CAT_STATUS_SOLICITUD(Descripcion_Status_Solicitud) VALUES('SOLICITUD APROBADA')
	INSERT INTO DT_CAT_STATUS_SOLICITUD(Descripcion_Status_Solicitud) VALUES('SOLICITUD CANCELADA')
	INSERT INTO DT_CAT_STATUS_SOLICITUD(Descripcion_Status_Solicitud) VALUES('SOLICITUD PENDIENTE DE ENVIAR')
	
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_TBL_PERMISO')
BEGIN
	DROP TABLE DT_TBL_PERMISO
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_TBL_PERMISO')
BEGIN
	CREATE TABLE DT_TBL_PERMISO
	(
		Id_Permiso INT IDENTITY (1,1),
		Fecha_Permiso DATE,
		Hora_inicio varchar(10),
		Hora_fin varchar(10),
		Total_Horas DECIMAL (10,2) null,
		Motivo_Permiso VARCHAR(1000),
		Fecha_Alta DATETIME,
		Id_Status_Solicitud INT,
		Motivo_Rechazo VARCHAR(1000),
		Em_Cve_Empleado varchar(100),
		Em_Cve_Empleado_Autoriza varchar(100),
		Fecha_Actualizacion DATETIME null
	)
END
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZAR_PERMISO')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZAR_PERMISO
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Insertar o actualizar una solicitud de permiso>
-- =============================================
CREATE PROCEDURE DT_SP_ACTUALIZAR_PERMISO
	-- Add the parameters for the stored procedure here
		@Id_Permiso INT=NULL,
		@Fecha_Permiso DATE=NULL,
		@Hora_inicio varchar(10)=NULL,
		@Hora_fin varchar(10)=NULL,
		@Total_Horas DECIMAL (10,2)=NULL,
		@Motivo_Permiso VARCHAR(1000)=NULL,
		@Id_Status_Solicitud INT=NULL,
		@Motivo_Rechazo VARCHAR(1000)=NULL,
		@Em_Cve_Empleado varchar(100)=NULL,
		@Em_Cve_Empleado_Autoriza varchar(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE 
		@status int=0,
		@mensaje varchar(250)='',
		@proyecto_empleado varchar (10)


	IF(@Id_Permiso is null or @Id_Permiso=0)
	BEGIN

		--1.-Obtenemos la información del proyecto del empleado que esta generando el permiso
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		IF(@proyecto_empleado is null)
		BEGIN
			SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--2.-Revisamos que exista un autorizador para este proyecto
		
		select @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from IICA_COMPRAS.dbo.Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado

		IF(@Em_Cve_Empleado_Autoriza is null)
		BEGIN
			SET @mensaje='NO EXISTEN AUTORIZADORES PARA EL PROYECTO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--3.-SE TERMINAN LAS VALIDACIONES, PROCEDEMOS A REALIZAR EL INSERT

		INSERT
			INTO DT_TBL_PERMISO(
				Fecha_Permiso,
				Hora_inicio,
				Hora_fin,
				Total_Horas,
				Motivo_Permiso,
				Fecha_Alta,
				Id_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado
				--,Em_Cve_Empleado_Autoriza
			)
			VALUES (
				@Fecha_Permiso,
				@Hora_inicio,
				@Hora_fin,
				@Total_Horas,
				@Motivo_Permiso,
				GETDATE(),
				1,
				'',
				@Em_Cve_Empleado
				--,@Em_Cve_Empleado_Autoriza
			)

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GENERAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SELECT @Id_Permiso=MAX(Id_Permiso)
			FROM DT_TBL_PERMISO
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado

			SET @status=1
			SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'

			GOTO EXIT_
	END
	ELSE
	BEGIN
		--4.- SE TRATA DE UNA ACTUALIZACION DE LA SOLICITUD
		UPDATE DT_TBL_PERMISO
		SET Id_Status_Solicitud=@Id_Status_Solicitud,
		Fecha_Actualizacion=GETDATE(),
		Motivo_Rechazo=@Motivo_Rechazo,
		Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
		WHERE Id_Permiso=@Id_Permiso

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL ACTUALZIAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		SET @status=1
		SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'
		GOTO EXIT_
	END

	Exit_: SELECT @status STATUS, @mensaje MENSAJE, coalesce(@Id_Permiso,0) ID_PERMISO
END
GO

GRANT EXECUTE ON DT_SP_ACTUALIZAR_PERMISO TO public;  
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (#taskNew Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Devuelve la información para armar el formato del permiso>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO
	-- Add the parameters for the stored procedure here
	@Id_Permiso int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		Em_nombre,
		Em_Apellido_Paterno,
		Em_Apellido_Materno,
		CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
		b.Sc_UserDef_2,
		b.Sc_Descripcion Programa,
		COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
		CONVERT (VARCHAR,d.Fecha_Permiso,103)Fecha_Permiso,
		CONVERT (VARCHAR,d.Fecha_Alta,103)Fecha_Alta,
		d.Hora_Inicio,
		d.Hora_Fin,
		d.Total_Horas,
		d.Hora_Fin Hora_Raunuda_Labores,
		d.Motivo_Permiso
	from Empleado a
	left join IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
	LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
	INNER JOIN DT_TBL_PERMISO d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
	WHERE Id_Permiso=@Id_Permiso


END
GO

GRANT EXECUTE ON DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO TO public;  

--=========================
--SALDOS VACACIONALES
--========================

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_CAT_DIAS_VACACIONES')
BEGIN
	DROP TABLE DT_CAT_DIAS_VACACIONES
END
GO

CREATE TABLE DT_CAT_DIAS_VACACIONES
(
	Id_Dias_Vacaciones INT IDENTITY (1,1),
	Dias_Vacaciones INT,
	Anios INT
)
GO
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (0,0)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (8,1)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (10,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (12,3)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (14,4)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (16,5)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (16,6)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (17,7)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (17,8)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,9)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,10)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,11)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,12)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,13)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,14)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,15)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,16)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,17)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,18)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,19)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,20)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,21)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,22)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,23)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,24)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,25)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,26)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,27)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,28)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,29)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones,Anios) VALUES (18,30)
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_TBL_PERIODO_VACACIONAL_EMPLEADO')
BEGIN
	DROP TABLE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
END
GO

CREATE TABLE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
(
	Contador INT IDENTITY (1,1),
	Em_Cve_Empleado VARCHAR(100),
	Anios INT,
	Fecha_Inicio_Periodo DATETIME,
	Fecha_Fin_Periodo DATETIME,
	Saldo_Periodo_Anterior INT,
	Saldo_Actual_Proporcional INT,
	Saldo_Actual_Utilizado INT,
	Saldo_Correspondiente INT,
	Fecha_Actualizacion DATETIME,
	Activo INT
)
GO
--Se llena por unica ocación la tabla


DECLARE
	@Anios int,
	@Hoy varchar(50),
	@Contador int=1,
	@Tope int,
	@Id_Temp int,
	@Fecha_Ingreso DATETIME

SET @Hoy=CONVERT(VARCHAR,GETDATE())

CREATE TABLE #TASK1
(
	Id_Temp int,
	Em_Cve_Empleado VARCHAR(100),
	Em_Fecha_Ingreso DATETIME,
	Anios INT
)

INSERT 
	INTO #TASK1 (Id_Temp,Em_Cve_Empleado,Em_Fecha_Ingreso)
	SELECT
		convert(int,Em_Cve_Empleado) id_temp,
		Em_Cve_Empleado,
		Em_Fecha_Ingreso
	FROM Empleado

SELECT @Tope=COUNT(*) FROM Empleado

WHILE @Contador<=@Tope
begin
	
	SELECT
		@Fecha_Ingreso=Em_Fecha_Ingreso
	FROM #TASK1
	WHERE id_temp=@Contador
	
	SELECT
		@Anios=ANIOS
	FROM FN_DSI_DIFERENCIA_FECHAS (@Fecha_Ingreso,@Hoy)

	UPDATE #TASK1
	SET Anios=@Anios
	WHERE id_temp=@Contador

	SET @Contador=@Contador+1

end

INSERT 
	INTO DT_TBL_PERIODO_VACACIONAL_EMPLEADO
	(
	Em_Cve_Empleado,
	Anios,
	Fecha_Inicio_Periodo,
	Fecha_Fin_Periodo,
	Saldo_Periodo_Anterior,
	Saldo_Actual_Proporcional,
	Saldo_Actual_Utilizado,
	Saldo_Correspondiente,
	Fecha_Actualizacion,
	Activo
	)
SELECT
	b.Em_Cve_Empleado,
	c.Anios,
	DATEADD(yy,a.Anios,b.Em_Fecha_Ingreso) Fecha_Inicio_Periodo,
	DATEADD(yy,a.Anios+1,b.Em_Fecha_Ingreso) Fecha_Fin_Periodo,
	0 Saldo_Anterior,
	((DATEDIFF(DD,DATEADD(yy,a.Anios,b.Em_Fecha_Ingreso),GETDATE()))*c.Dias_Vacaciones)/365 Saldo_Proporcional,
	0 Saldo_Tomado,
	c.Dias_Vacaciones Saldo_Correspondiente,
	GETDATE() Fecha_Actualizacion,
	1
FROM #TASK1 A
LEFT JOIN Empleado B ON a.Em_Cve_Empleado=b.Em_Cve_Empleado
LEFT JOIN DT_CAT_DIAS_VACACIONES c on a.Anios=c.Anios
order by a.Anios desc

GO


IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_SALDO_VACACIONAL')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_SALDO_VACACIONAL
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_SALDO_VACACIONAL
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		Fecha_Inicio_Periodo,
		Fecha_Fin_Periodo,
		Saldo_Periodo_Anterior,
		Saldo_Actual_Proporcional,
		Saldo_Actual_Utilizado,
		Saldo_Correspondiente
	FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO
	WHERE Em_Cve_Empleado=@Em_Cve_Empleado
	AND Activo=1


END
GO


GRANT EXECUTE ON DT_SP_OBTENER_SALDO_VACACIONAL TO public;  
GO

--===================================
--Fin de los periodos vacacionales
--===================================

--=========================
--VACACIONES
--========================

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_TBL_VACACIONES')
BEGIN
	DROP TABLE DT_TBL_VACACIONES
END
GO

CREATE TABLE DT_TBL_VACACIONES
	(
		Id_Vacaciones INT IDENTITY (1,1),
		Periodo_Anterior INT,
		Proporcional INT,
		Total_Dias_Saldo_Vacacional INT,
		Fecha_Solicitud DATETIME,
		Fecha_Inicio DATE,
		Fecha_Fin DATE,
		Total_Dias INT,
		Motivo_Vacaciones VARCHAR(1000),
		Id_Status_Solicitud INT,
		Motivo_Rechazo VARCHAR(1000),
		Em_Cve_Empleado varchar(100),
		Em_Cve_Empleado_Autoriza VARCHAR(100),
		Fecha_Actualizacion DATETIME NULL
	)





IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZAR_VACACIONES')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZAR_VACACIONES
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Insertar o actualizar una solicitud de vacaciones>
-- =============================================
CREATE PROCEDURE DT_SP_ACTUALIZAR_VACACIONES
	-- Add the parameters for the stored procedure here
		@Id_Vacaciones INT=null,
		@Periodo_Anterior INT=null,
		@Proporcional INT=null,
		@Total_Dias_Saldo_Vacacional INT=null,
		@Fecha_Solicitud DATETIME=null,
		@Fecha_Inicio DATE=null,
		@Fecha_Fin DATE=null,
		@Total_Dias INT=null,
		@Motivo_Vacaciones VARCHAR(1000)=null,
		@Id_Status_Solicitud INT=null,
		@Motivo_Rechazo VARCHAR(1000)=null,
		@Em_Cve_Empleado varchar(100)=null,
		@Em_Cve_Empleado_Autoriza varchar(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE 
		@status int=0,
		@mensaje varchar(250)='',
		@proyecto_empleado varchar (10)


	IF(@Id_Vacaciones is null or @Id_Vacaciones=0)
	BEGIN

		--1.-Obtenemos la información del proyecto del empleado que esta solicitando las vacaciones
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		IF(@proyecto_empleado is null)
		BEGIN
			SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--2.-Revisamos que exista un autorizador para este proyecto
		
		select @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from IICA_COMPRAS.dbo.Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado

		IF(@Em_Cve_Empleado_Autoriza is null)
		BEGIN
			SET @mensaje='NO EXISTEN AUTORIZADORES PARA EL PROYECTO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END
		--Se valida el saldo vacacional
		IF @Total_Dias>(SELECT (Saldo_Periodo_Anterior + Saldo_Actual_Proporcional)-Saldo_Actual_Utilizado FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Activo=1)
		BEGIN
			SET @mensaje='SU SALDO VACACIONAL ES MENOR A LOS DÍAS SOLICITADOS, CONTACTE A UN ADMINISTRADOR.'
			GOTO EXIT_
		END

		--3.-SE TERMINAN LAS VALIDACIONES, PROCEDEMOS A REALIZAR EL INSERT

		INSERT
			INTO DT_TBL_VACACIONES(
				Periodo_Anterior,
				Proporcional,
				Total_Dias_Saldo_Vacacional,
				Fecha_Solicitud,
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				Motivo_Vacaciones,
				Id_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado
				--,Em_Cve_Empleado_Autoriza
			)
			VALUES (
				@Periodo_Anterior,
				@Proporcional,
				@Total_Dias_Saldo_Vacacional,
				@Fecha_Solicitud,
				@Fecha_Inicio,
				@Fecha_Fin,
				@Total_Dias,
				@Motivo_Vacaciones,
				1,
				'',
				@Em_Cve_Empleado
				--,@Em_Cve_Empleado_Autoriza
			)

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GENERAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			/**/
			DECLARE
				@Saldo_Periodo_Anterior int,
				@Saldo_Actual_Disponible int

			SELECT
				@Saldo_Periodo_Anterior=@Saldo_Periodo_Anterior,
				@Saldo_Actual_Disponible=Saldo_Actual_Proporcional-Saldo_Actual_Utilizado
			FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado
			AND Activo=1
			
			IF @Saldo_Periodo_Anterior>=@Total_Dias
				SET @Saldo_Periodo_Anterior=@Saldo_Periodo_Anterior-@Total_Dias
			ELSE
			BEGIN
				SET @Saldo_Periodo_Anterior=0
				SET @Saldo_Actual_Disponible= (@Saldo_Actual_Disponible+@Saldo_Periodo_Anterior)-@Total_Dias
			END

			UPDATE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			SET Saldo_Actual_Utilizado=Saldo_Actual_Utilizado+@Total_Dias,
			Saldo_Periodo_Anterior=@Saldo_Periodo_Anterior

			/**/

			SELECT @Id_Vacaciones=MAX(Id_Vacaciones)
			FROM DT_TBL_VACACIONES
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado

			SET @status=1
			SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'

			GOTO EXIT_
	END
	ELSE
	BEGIN
		--4.- SE TRATA DE UNA ACTUALIZACION DE LAS VACACIONES

		--4.1 VALIDAMOS QUE EL SALDO VACACIONAL ESTE DISPONIBLE

		IF (SELECT Total_Dias FROM DT_TBL_VACACIONES WHERE Id_Vacaciones=@Id_Vacaciones )>(select (Saldo_Periodo_Anterior + Saldo_Actual_Proporcional)-Saldo_Actual_Utilizado from DT_TBL_PERIODO_VACACIONAL_EMPLEADO where Em_Cve_Empleado=@Em_Cve_Empleado AND Activo=1)
		BEGIN
			SET @mensaje='EL EMPLEADO YA NO DISPONE DE SALDO VACACIONAL, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		UPDATE DT_TBL_VACACIONES
		SET Id_Status_Solicitud=@Id_Status_Solicitud,
		Fecha_Actualizacion=GETDATE(),
		Motivo_Rechazo=@Motivo_Rechazo,
		Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
		WHERE Id_Vacaciones=@Id_Vacaciones

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL ACTUALIZAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		SET @status=1
		SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'
		GOTO EXIT_
	END

	Exit_: SELECT @status STATUS, @mensaje MENSAJE, coalesce(@Id_Vacaciones,0) ID_VACACIONES
END
GO

GRANT EXECUTE ON DT_SP_ACTUALIZAR_VACACIONES TO public;  
GO



IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_INFORMACION_FORMATO_VACACIONES')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_INFORMACION_FORMATO_VACACIONES
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Devuelve la información para armar el formato de las vacaciones>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_INFORMACION_FORMATO_VACACIONES
	-- Add the parameters for the stored procedure here
	@Id_Vacaciones int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		Em_nombre,
		Em_Apellido_Paterno,
		Em_Apellido_Materno,
		CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
		b.Sc_UserDef_2,
		b.Sc_Descripcion Programa,
		COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
		CONVERT (VARCHAR,d.Fecha_Solicitud,103)Fecha_Alta,
		d.Total_Dias_Saldo_Vacacional,
		CONVERT (VARCHAR,d.Fecha_Inicio,103)Fecha_Inicio,
		CONVERT (VARCHAR,d.Fecha_Fin,103)Fecha_Fin,
		d.Total_Dias,
		CONVERT (VARCHAR,DATEADD(DD,1,d.Fecha_Fin),103) reanudar_labores,
		d.Motivo_Vacaciones
	from Empleado a
	left join IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
	LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
	INNER JOIN DT_TBL_VACACIONES d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
	WHERE Id_Vacaciones=@Id_Vacaciones
	
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_INFORMACION_FORMATO_VACACIONES TO public;  



--====Parte de las incapacidades

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_CAT_TIPO_INCAPACIDAD')
BEGIN
	DROP TABLE DT_CAT_TIPO_INCAPACIDAD
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_CAT_TIPO_INCAPACIDAD')
BEGIN
	CREATE TABLE DT_CAT_TIPO_INCAPACIDAD
	(
		Id_Tipo_Incapacidad INT IDENTITY (1,1),
		Descripcion_Tipo_Incapacidad VARCHAR (100),
		Activo int default 1
	)
	TRUNCATE TABLE DT_CAT_TIPO_INCAPACIDAD
	INSERT INTO DT_CAT_TIPO_INCAPACIDAD(Descripcion_Tipo_Incapacidad) VALUES('ENFERMEDAD GENERAL')
	INSERT INTO DT_CAT_TIPO_INCAPACIDAD(Descripcion_Tipo_Incapacidad) VALUES('MATERNIDAD')
	INSERT INTO DT_CAT_TIPO_INCAPACIDAD(Descripcion_Tipo_Incapacidad) VALUES('RIESGO DE TRABAJO')
	
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_CAT_TIPO_SEGUIMIENTO')
BEGIN
	DROP TABLE DT_CAT_TIPO_SEGUIMIENTO
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_CAT_TIPO_SEGUIMIENTO')
BEGIN
	CREATE TABLE DT_CAT_TIPO_SEGUIMIENTO
	(
		Id_Tipo_Seguimiento INT IDENTITY (1,1),
		Descripcion_Tipo_Seguimiento VARCHAR (100),
		Activo int default 1
	)
	TRUNCATE TABLE DT_CAT_TIPO_SEGUIMIENTO
	INSERT INTO DT_CAT_TIPO_SEGUIMIENTO(Descripcion_Tipo_Seguimiento) VALUES('INICIAL')
	INSERT INTO DT_CAT_TIPO_SEGUIMIENTO(Descripcion_Tipo_Seguimiento) VALUES('SUBSECUENTE')
	INSERT INTO DT_CAT_TIPO_SEGUIMIENTO(Descripcion_Tipo_Seguimiento) VALUES('TÉRMINO')
	
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_TBL_INCAPACIDAD')
BEGIN
	DROP TABLE DT_TBL_INCAPACIDAD
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE 'DT_TBL_INCAPACIDAD')
BEGIN
	CREATE TABLE DT_TBL_INCAPACIDAD
	(
		Id_Incapacidad INT IDENTITY (1,1),
		Fecha_Inicio DATE,
		Fecha_Fin DATE,
		Total_Dias INT,
		Id_Tipo_Incapacidad INT,
		Id_Tipo_Seguimiento INT,
		Fecha_Ingreso_Labores DATETIME,
		Fecha_Solicitud DATETIME,
		Id_Status_Solicitud INT,
		Motivo_Rechazo VARCHAR(1000),
		Em_Cve_Empleado varchar(100),
		Em_Cve_Empleado_Autoriza varchar(100),
		Fecha_Actualizacion DATETIME null,
		Formato_Incapacidad varchar(400),
		Formato_Adicional varchar(400),
		Formato_ST7_Calificacion_RT varchar(400),
		Formato_ST7_Alta_RT varchar(400)
	)
END
GO

--===Catalogo de tipo de incapacidades

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_TIPO_INCAPACIDAD')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_TIPO_INCAPACIDAD
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Devuelve la información para armar el formato de un catalogo>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_TIPO_INCAPACIDAD
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		*
	from DT_CAT_TIPO_INCAPACIDAD
	where Activo=1
	
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_TIPO_INCAPACIDAD TO public;

--===Catalogo de tipo de seguimientos

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_TIPO_SEGUIMIENTO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_TIPO_SEGUIMIENTO
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Devuelve la información para armar el formato de un catalogo>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_TIPO_SEGUIMIENTO
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		*
	from DT_CAT_TIPO_SEGUIMIENTO
	where Activo=1
	
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_TIPO_SEGUIMIENTO TO public;


IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZAR_INCAPACIDAD')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZAR_INCAPACIDAD
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Insertar o actualizar una solicitud de vacaciones>
-- =============================================
CREATE PROCEDURE DT_SP_ACTUALIZAR_INCAPACIDAD
	-- Add the parameters for the stored procedure here
		@Id_Incapacidad INT=NULL,
		@Fecha_Inicio DATE=NULL,
		@Fecha_Fin DATE=NULL,
		@Total_Dias INT=NULL,
		@Id_Tipo_Incapacidad INT=NULL,
		@Id_Tipo_Seguimiento INT=NULL,
		@Fecha_Ingreso_Labores DATETIME=NULL,
		@Fecha_Solicitud DATETIME=NULL,
		@Id_Status INT=NULL,
		@Motivo_Rechazo VARCHAR(1000)=NULL,
		@Em_Cve_Empleado varchar(100)=NULL,
		@Formato_Incapacidad varchar(400)=NULL,
		@Formato_Adicional varchar(400)=NULL,
		@Formato_ST7_Calificacion_RT varchar(400)=NULL,
		@Formato_ST7_Alta_RT varchar(400)=NULL,
		@Em_Cve_Empleado_Autoriza varchar(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE 
		@status int=0,
		@mensaje varchar(250)='',
		@proyecto_empleado varchar (10)


	IF(@Id_Incapacidad is null or @Id_Incapacidad=0)
	BEGIN
		
		--0.-VALIDAMOS SI SE ESTA CREANDO COMO SUBSECUENTE, VALIDEMOS QUE EXISTE UNA COMO INICIAL
		IF(@Id_Tipo_Seguimiento=2/*SUBSECUENTE*/)
		BEGIN
			/* NOTA: ESTO SE DEFE DE DEFINIR POR PARTE DE GABI, YA QUE NO SE SI VAN EN PARES */
			IF NOT EXISTS (SELECT 1 FROM DT_TBL_INCAPACIDAD WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Id_Tipo_Incapacidad=1 AND Id_Status_Solicitud=4)
			BEGIN
				SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END
		END

		--1.-Obtenemos la información del proyecto del empleado que esta solicitando las vacaciones
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		IF(@proyecto_empleado is null)
		BEGIN
			SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--2.-Revisamos que exista un autorizador para este proyecto
		
		select @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from IICA_COMPRAS.dbo.Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado

		IF(@Em_Cve_Empleado_Autoriza is null)
		BEGIN
			SET @mensaje='NO EXISTEN AUTORIZADORES PARA EL PROYECTO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--3.-SE TERMINAN LAS VALIDACIONES, PROCEDEMOS A REALIZAR EL INSERT

		INSERT
			INTO DT_TBL_INCAPACIDAD(
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				Id_Tipo_Incapacidad,
				Id_Tipo_Seguimiento,
				Fecha_Ingreso_Labores,
				Fecha_Solicitud,
				Id_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado,
				--Em_Cve_Empleado_Autoriza,
				Formato_Incapacidad,
				Formato_Adicional,
				Formato_ST7_Calificacion_RT,
				Formato_ST7_Alta_RT
			)
			VALUES (
				@Fecha_Inicio,
				@Fecha_Fin,
				@Total_Dias,
				@Id_Tipo_Incapacidad,
				@Id_Tipo_Seguimiento,
				@Fecha_Ingreso_Labores,
				@Fecha_Solicitud,
				4,
				@Motivo_Rechazo,
				@Em_Cve_Empleado,
				--@Em_Cve_Empleado_Autoriza,
				@Formato_Incapacidad,
				@Formato_Adicional,
				@Formato_ST7_Calificacion_RT,
				@Formato_ST7_Alta_RT
			)

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GENERAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'

			GOTO EXIT_
	END
	ELSE
	BEGIN
		--4.- SE TRATA DE UNA ACTUALIZACION DE LA INCAPACIDAD

		--4.1.-SE TRATA DE UNA ACTUALIZACIÓN DE DOCUMENTOS
		--ESTO QUEDA PENDIENTE

		UPDATE DT_TBL_INCAPACIDAD
		SET Id_Status_Solicitud=@Id_Status,
		Fecha_Actualizacion=GETDATE(),
		Motivo_Rechazo=@Motivo_Rechazo,
		Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
		WHERE Id_Incapacidad=@Id_Incapacidad

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL ACTUALIZAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		SET @status=1
		SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'
		GOTO EXIT_
	END

	Exit_: SELECT @status STATUS, @mensaje MENSAJE, @Id_Incapacidad ID_INCAPACIDAD
END
GO

GRANT EXECUTE ON DT_SP_ACTUALIZAR_INCAPACIDAD TO public;  
GO

--==================SPS PARA LLENAR LOS DATA TABLES
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_PERMISOS_USUARIO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_PERMISOS_USUARIO
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_PERMISOS_USUARIO
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(100)=NULL,
	@Em_Cve_Empleado_Autoriza VARCHAR(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@query nvarchar(max),
		@Proyecto_Empleado_Autoriza varchar(10)

	IF (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza='') 
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza='')
		select 0 STATUS, 'ERROR, NÚMERO DE PARAMETROS INCORRECTO' MENSAJE
	ELSE
	BEGIN
		IF @Em_Cve_Empleado IS NOT NULL
		BEGIN
			select
				1 STATUS,
				'' MENSAJE,
				Id_Permiso,
				Fecha_Permiso,
				Hora_inicio,
				Hora_fin,
				Total_Horas,
				Motivo_Permiso,
				a.Fecha_Alta,
				a.Id_Status_Solicitud,
				b.Descripcion_Status_Solicitud,
				Motivo_Rechazo,
				COALESCE(Fecha_Actualizacion,'') Fecha_Revision
			from
				DT_TBL_PERMISO a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			WHERE a.Em_Cve_Empleado=@Em_Cve_Empleado
		END
		IF @Em_Cve_Empleado_Autoriza IS NOT NULL
		BEGIN

			select
				d.Id_Permiso,
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
				CONVERT (VARCHAR,d.Fecha_Permiso,103)Fecha_Permiso,
				CONVERT (VARCHAR,d.Fecha_Alta,103)Fecha_Alta,
				d.Hora_Inicio,
				d.Hora_Fin,
				d.Total_Horas,
				d.Motivo_Permiso
			from Empleado a
			--LEFT JOIN IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			--LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			INNER JOIN DT_TBL_PERMISO d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from IICA_COMPRAS.dbo.Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_PERMISOS_USUARIO TO public;  
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_VACACIONES_USUARIO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_VACACIONES_USUARIO
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_VACACIONES_USUARIO
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(100)=NULL,
	@Em_Cve_Empleado_Autoriza VARCHAR(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@query nvarchar(max)

	IF (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza='') 
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza='')
		select 0 STATUS, 'ERROR, NÚMERO DE PARAMETROS INCORRECTO' MENSAJE
	ELSE
	BEGIN
		IF @Em_Cve_Empleado IS NOT NULL
		BEGIN
			select
				1 STATUS,
				'' MENSAJE,
				Id_Vacaciones,
				Periodo_Anterior,
				Proporcional,
				Total_Dias_Saldo_Vacacional,
				Fecha_Solicitud,
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				Motivo_Vacaciones,
				a.Id_Status_Solicitud,
				b.Descripcion_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado,
				Em_Cve_Empleado_Autoriza,
				COALESCE(Fecha_Actualizacion,'') Fecha_Revision
			from
				DT_TBL_VACACIONES a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			WHERE a.Em_Cve_Empleado=@Em_Cve_Empleado
		END
		IF @Em_Cve_Empleado_Autoriza IS NOT NULL
		BEGIN
			select
				d.Id_Vacaciones,
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
				CONVERT (VARCHAR,d.Fecha_Solicitud,103)Fecha_Alta,
				d.Total_Dias_Saldo_Vacacional,
				CONVERT (VARCHAR,d.Fecha_Inicio,103)Fecha_Inicio,
				CONVERT (VARCHAR,d.Fecha_Fin,103)Fecha_Fin,
				d.Total_Dias,
				CONVERT (VARCHAR,DATEADD(DD,1,d.Fecha_Fin),103) Reanudar_Labores,
				d.Motivo_Vacaciones
			from Empleado a
			--LEFT JOIN IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			--LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			INNER JOIN DT_TBL_VACACIONES d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from IICA_COMPRAS.dbo.Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_VACACIONES_USUARIO TO public;  
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_INCAPACIDADES_USUARIO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_INCAPACIDADES_USUARIO
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_INCAPACIDADES_USUARIO
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(100)=NULL,
	@Em_Cve_Empleado_Autoriza VARCHAR(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@query nvarchar(max)

	IF (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza='') 
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza='')
		select 0 STATUS, 'ERROR, NÚMERO DE PARAMETROS INCORRECTO' MENSAJE
	ELSE
	BEGIN
		IF @Em_Cve_Empleado IS NOT NULL
		BEGIN
			select
				1 STATUS,
				'' MENSAJE,
				Id_Incapacidad,
				Fecha_Ingreso_Labores,
				Fecha_Solicitud,
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				a.Id_Status_Solicitud,
				b.Descripcion_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado,
				Em_Cve_Empleado_Autoriza,
				COALESCE(Fecha_Actualizacion,'') Fecha_Revision,
				a.Id_Tipo_Seguimiento,
				d.Descripcion_Tipo_Seguimiento,
				a.Id_Tipo_Incapacidad,
				c.Descripcion_Tipo_Incapacidad
			from
				DT_TBL_INCAPACIDAD a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			join DT_CAT_TIPO_INCAPACIDAD c on a.Id_Tipo_Incapacidad=c.Id_Tipo_Incapacidad
			join DT_CAT_TIPO_SEGUIMIENTO d on a.Id_Tipo_Seguimiento=d.Id_Tipo_Seguimiento
			WHERE a.Em_Cve_Empleado=@Em_Cve_Empleado
		END
		IF @Em_Cve_Empleado_Autoriza IS NOT NULL
		BEGIN
			select
				d.Id_Incapacidad,
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
				CONVERT (VARCHAR,d.Fecha_Solicitud,103)Fecha_Alta,
				d.Id_Tipo_Incapacidad,
				CONVERT (VARCHAR,d.Fecha_Inicio,103)Fecha_Inicio,
				CONVERT (VARCHAR,d.Fecha_Fin,103)Fecha_Fin,
				d.Total_Dias,
				CONVERT (VARCHAR,DATEADD(DD,1,d.Fecha_Fin),103) Reanudar_Labores,
				d.Motivo_Rechazo,
				d.Id_Tipo_Seguimiento
			from Empleado a
			--LEFT JOIN IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			--LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			INNER JOIN DT_TBL_INCAPACIDAD d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from IICA_COMPRAS.dbo.Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_INCAPACIDADES_USUARIO TO public;  
GO

--========================SP para el inicio de sesión

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_INICIAR_SESION')
BEGIN
	DROP PROCEDURE DT_SP_INICIAR_SESION
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DT_SP_INICIAR_SESION
	-- Add the parameters for the stored procedure here
	@Numero_Usuario VARCHAR(100),
	@Password VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE
		@Status int=0,
		@Mensaje varchar(500)='OK',
		@Id_Tipo_Usuario int=0,
		@Rol_Usuario varchar(100),
		@Query nvarchar(max)


    -- Insert statements for procedure here

	IF @Numero_Usuario='ADMIN' AND @Password='ADMIN'
	BEGIN
		SET @Status=1
		SET @Id_Tipo_Usuario=1
		SET @Rol_Usuario='ADMINISTRADOR'

		set @Query='
		SELECT '+
			CONVERT(varchar,@Status)+' STATUS,'''+
			@Mensaje+''' MENSAJE,'+
			CONVERT(varchar,@Id_Tipo_Usuario)+' Id_Tipo_Usuario,'''+
			@Rol_Usuario+''' Rol_Usuario,'+'
			''Administrador'' Em_nombre,
			''Administrador'' Em_Apellido_Paterno,
			''Administrador'' Em_Apellido_Materno,
			''SIN PROGRAMA'' Programa,
			''SIN DEPARTAMENTO'' Departamento'
		GOTO Exit_
	END

	IF NOT EXISTS(SELECT 1 FROM Empleado WHERE Em_UserDef_1=@Numero_Usuario and Em_UserDef_2=@Password)
	BEGIN
		SET @Mensaje='EL USUARIO O LA CONTRASEÑA SON INCORRECTAS.'
		set @Query='
		SELECT '+
			CONVERT(varchar,@Status)+' STATUS,'''+
			@Mensaje+''' MENSAJE'
		GOTO Exit_
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM IICA_COMPRAS.dbo.Viaticos_Autorizadores WHERE Em_UserDef_1=@Numero_Usuario)
		BEGIN
			SET @Status=1
			SET @Id_Tipo_Usuario=3--usuario autorizador
			SET @Rol_Usuario='AUTORIZADOR'

			set @Query='
			SELECT '+
				CONVERT(varchar,@Status)+' STATUS,'''+
				@Mensaje+''' MENSAJE,'+
				CONVERT(varchar,@Id_Tipo_Usuario)+' Id_Tipo_Usuario,'''+
				@Rol_Usuario+''' Rol_Usuario,'+'
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,''SIN DEPARTAMENTO'') Departamento
			FROM Empleado a
			LEFT JOIN IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			WHERE Em_UserDef_1='''+@Numero_Usuario +''' and Em_UserDef_2='''+@Password+''''
			GOTO Exit_
		END
		ELSE
		BEGIN
			SET @Status=1
			SET @Id_Tipo_Usuario=2--usuario empleado
			SET @Rol_Usuario='EMPLEADO'

			set @Query='
			SELECT '+
				CONVERT(varchar,@Status)+' STATUS,'''+
				@Mensaje+''' MENSAJE,'+
				CONVERT(varchar,@Id_Tipo_Usuario)+' Id_Tipo_Usuario,'''+
				@Rol_Usuario+''' Rol_Usuario,'+'
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,''SIN DEPARTAMENTO'') Departamento
			FROM Empleado a
			LEFT JOIN IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			WHERE Em_UserDef_1='''+@Numero_Usuario +''' and Em_UserDef_2='''+@Password+''''
			GOTO Exit_
		END
	END

	Exit_:
			print(@Query)
			EXEC SP_EXECUTESQL @Query

END
GO

GRANT EXECUTE ON DT_SP_INICIAR_SESION TO public;  
GO

/*
Pruebas Christian

insert into IICA_COMPRAS.dbo.viaticos_autorizadores values('0000007','ING. MIGUEL ALBERTO ABIACA LEE','miguel.abiaca','perc9004@gmail.com','MF','D','AC','0000003272','0000003272','Q183615')
exec DT_SP_ACTUALIZAR_PERMISO NULL,'20190215','12:00 P.M.','04:00 P.M.',4,'Atender asuntos personales',1,null,'0000000001'

exec DT_SP_OBTENER_PERMISOS_USUARIO null,'0000003272'

exec DT_SP_OBTENER_PERMISOS_USUARIO '0000000001',null

exec DT_SP_ACTUALIZAR_VACACIONES NULL,4,5,9,'20190219','20190211','20190213',3,'VACACIONES',1,NULL,'0000000001'

exec DT_SP_OBTENER_VACACIONES_USUARIO '0000000001',null

exec DT_SP_INICIAR_SESION '0000000001','Q180001'
exec DT_SP_INICIAR_SESION '0000003272','Q183272'

*/