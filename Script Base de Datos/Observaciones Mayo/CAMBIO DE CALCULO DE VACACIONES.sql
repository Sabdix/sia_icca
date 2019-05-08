--============================================================
--PRIMER PASO
USE IICA_1
GO

ALTER TABLE DT_CAT_DIAS_VACACIONES
ADD Factor_Integracion INT
GO
--1 es par moscafrut
update DT_CAT_DIAS_VACACIONES
set Factor_Integracion=1
GO
UPDATE DT_CAT_DIAS_VACACIONES
SET Dias_Vacaciones=10
WHERE Anios IN (0,1,2,3)
GO
UPDATE DT_CAT_DIAS_VACACIONES
SET Dias_Vacaciones=14
WHERE Anios = 4
GO
UPDATE DT_CAT_DIAS_VACACIONES
SET Dias_Vacaciones=16
WHERE Anios IN (5,6,7,8,9)
GO
UPDATE DT_CAT_DIAS_VACACIONES
SET Dias_Vacaciones=18
WHERE Anios IN (10,11,12,13,14)
GO
UPDATE DT_CAT_DIAS_VACACIONES
SET Dias_Vacaciones=20
WHERE Anios IN (15,16,17,18,19)
GO
UPDATE DT_CAT_DIAS_VACACIONES
SET Dias_Vacaciones=22
WHERE Anios IN (20,21,22,23,24)
GO
UPDATE DT_CAT_DIAS_VACACIONES
SET Dias_Vacaciones=24
WHERE Anios >24
GO
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (10,0,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (10,1,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (10,2,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (10,3,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (12,4,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (14,5,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (14,6,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (14,7,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (14,8,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (14,9,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (16,10,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (16,11,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (16,12,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (16,13,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (16,14,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (18,15,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (18,16,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (18,17,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (18,18,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (18,19,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (20,20,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (20,21,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (20,22,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (20,23,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (20,24,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (22,25,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (22,26,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (22,27,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (22,28,2)
INSERT INTO DT_CAT_DIAS_VACACIONES (Dias_Vacaciones ,Anios, Factor_Integracion) VALUES (22,29,2)
GO
--============================================================
--SEGUNDO PASO, SE TRUNCAN LAS TABLAS DE LAS VACACIONES
TRUNCATE TABLE [dbo].[DT_TBL_VACACIONES]
GO
--============================================================
--TERCER PASO, SE EJECUTA LA RUTINA QUE POR UNICA OCACIÓN VA
--VOLVER A HACER EL CALCULO DE LAS VACACIONES
DECLARE
		@Anios int,
		@Hoy varchar(50),
		@Contador int=1,
		@Tope int,
		@Id_Temp int,
		@Fecha_Ingreso DATETIME

	TRUNCATE TABLE DT_TBL_PERIODO_VACACIONAL_EMPLEADO

	SET @Hoy=CONVERT(VARCHAR,GETDATE(),103)

	CREATE TABLE #TASK1
	(
		Id_Temp int,
		Em_Cve_Empleado VARCHAR(100),
		Em_Fecha_Ingreso DATETIME,
		Anios INT,
		Factor_Integracion INT
	)

	INSERT 
		INTO #TASK1 (Id_Temp,Em_Cve_Empleado,Em_Fecha_Ingreso,Factor_Integracion)
		SELECT
			convert(int,a.Em_Cve_Empleado) id_temp,
			a.Em_Cve_Empleado,
			Em_Fecha_Ingreso,
			case
				when Sc_UserDef_2 like 'MF' then 1
				else 2 end
		FROM Empleado a
		INNER JOIN Sucursal b on a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal

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

		INSERT INTO DT_TBL_PERIODO_VACACIONAL_EMPLEADO (Em_Cve_Empleado)
		SELECT
			Em_Cve_Empleado
		FROM #TASK1
		WHERE id_temp=@Contador 

		SET @Contador=@Contador+1

	end

	UPDATE A
	SET
		Anios=C.anios,
		Fecha_Inicio_Periodo=DATEADD(yy,B.Anios,D.Em_Fecha_Ingreso),
		Fecha_Fin_Periodo=DATEADD(yy,B.Anios+1,D.Em_Fecha_Ingreso),
		Saldo_Periodo_Anterior=COALESCE(Saldo_Actual_Disponible,0),
		a.Saldo_Periodo_Anterior_Usado=0,
		a.Saldo_Proporcional_Actual=((DATEDIFF(DD,DATEADD(yy,B.Anios,D.Em_Fecha_Ingreso),GETDATE()))*c.Dias_Vacaciones)/365,
		--a.Saldo_Proporcional_Actual=((DATEDIFF(DD,DATEADD(yy,B.Anios,D.Em_Fecha_Ingreso),'20190301'))*c.Dias_Vacaciones)/365,
		Saldo_Proporcional_Actual_Usado=0,
		Saldo_Actual_Disponible=COALESCE(Saldo_Periodo_Anterior,0)+COALESCE(Saldo_Proporcional_Actual,0),
		Saldo_Actual_Utilizado=0,
		Saldo_Correspondiente=C.Dias_Vacaciones,
		Fecha_Actualizacion=GETDATE(),
		Activo=1
	FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
	INNER JOIN #TASK1 B ON a.Em_Cve_Empleado=B.Em_Cve_Empleado
	INNER JOIN DT_CAT_DIAS_VACACIONES c on B.Anios=c.Anios and B.Factor_Integracion=C.Factor_Integracion
	INNER JOIN Empleado D on A.Em_Cve_Empleado=D.Em_Cve_Empleado


	UPDATE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
	SET
		Saldo_Proporcional_Actual=((DATEDIFF(DD,DATEADD(yy,A.Anios,B.Em_Fecha_Ingreso),GETDATE()))*c.Dias_Vacaciones)/365
	from DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
	LEFT JOIN Empleado B on A.Em_Cve_Empleado=B.Em_Cve_Empleado
	INNER JOIN DT_CAT_DIAS_VACACIONES c on A.Anios=c.Anios
	LEFT JOIN #TASK1 D on A.Em_Cve_Empleado=D.Em_Cve_Empleado and D.Factor_Integracion=C.Factor_Integracion
	WHERE D.Em_Cve_Empleado IS NULL
GO

--============================================================
--4TO PASO, SE MODIFICA EL SP QUE VA A ESTAR ACTUALIZANDO LOS SALDOS
/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2012 (11.0.5388)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE IICA_1
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_RENUEVA_SALDOS_VACACIONALES]    Script Date: 05/05/2019 11:20:58 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<CHRISTIAN PEÑA ROMERO>
-- Description:	<SP que renueva los saldos vacacionales de los empleados>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_RENUEVA_SALDOS_VACACIONALES]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@Anios int,
		@Hoy varchar(50),
		@Contador int=1,
		@Tope int,
		@Id_Temp int,
		@Fecha_Ingreso DATETIME

	SET @Hoy=CONVERT(VARCHAR,GETDATE(),103)

	CREATE TABLE #TASK1
	(
		Id_Temp int,
		Em_Cve_Empleado VARCHAR(100),
		Em_Fecha_Ingreso DATETIME,
		Anios INT,
		Factor_Integracion INT
	)

	INSERT 
		INTO #TASK1 (Id_Temp,Em_Cve_Empleado,Em_Fecha_Ingreso,Factor_Integracion)
		SELECT
			convert(int,B.Em_Cve_Empleado) id_temp,
			a.Em_Cve_Empleado,
			Em_Fecha_Ingreso,
			case
				when Sc_UserDef_2 like 'MF' then 1
				else 2 end
		FROM Empleado a
		INNER JOIN DT_TBL_PERIODO_VACACIONAL_EMPLEADO B ON a.Em_Cve_Empleado=b.Em_Cve_Empleado
		INNER JOIN Sucursal c on a.Sc_Cve_Sucursal=c.Sc_Cve_Sucursal
		WHERE FECHA_FIN_PERIODO=CONVERT(VARCHAR,GETDATE(),103)
		--WHERE FECHA_FIN_PERIODO='20190301'

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

	UPDATE A
	SET
		Anios=C.anios,
		Fecha_Inicio_Periodo=DATEADD(yy,B.Anios,D.Em_Fecha_Ingreso),
		Fecha_Fin_Periodo=DATEADD(yy,B.Anios+1,D.Em_Fecha_Ingreso),
		Saldo_Periodo_Anterior=Saldo_Actual_Disponible,
		a.Saldo_Periodo_Anterior_Usado=0,
		a.Saldo_Proporcional_Actual=((DATEDIFF(DD,DATEADD(yy,B.Anios,D.Em_Fecha_Ingreso),GETDATE()))*c.Dias_Vacaciones)/365,
		--a.Saldo_Proporcional_Actual=((DATEDIFF(DD,DATEADD(yy,B.Anios,D.Em_Fecha_Ingreso),'20190301'))*c.Dias_Vacaciones)/365,
		Saldo_Proporcional_Actual_Usado=0,
		Saldo_Actual_Disponible=COALESCE(Saldo_Periodo_Anterior,0)+COALESCE(Saldo_Proporcional_Actual,0),
		Saldo_Actual_Utilizado=0,
		Saldo_Correspondiente=C.Dias_Vacaciones,
		Fecha_Actualizacion=GETDATE(),
		Activo=1
	FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
	INNER JOIN #TASK1 B ON a.Em_Cve_Empleado=B.Em_Cve_Empleado
	INNER JOIN DT_CAT_DIAS_VACACIONES c on B.Anios=c.Anios and B.Factor_Integracion=C.Factor_Integracion
	INNER JOIN Empleado D on A.Em_Cve_Empleado=D.Em_Cve_Empleado


	UPDATE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
	SET
		Saldo_Proporcional_Actual=((DATEDIFF(DD,DATEADD(yy,A.Anios,B.Em_Fecha_Ingreso),GETDATE()))*c.Dias_Vacaciones)/365
	from DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
	LEFT JOIN Empleado B on A.Em_Cve_Empleado=B.Em_Cve_Empleado
	INNER JOIN DT_CAT_DIAS_VACACIONES c on A.Anios=c.Anios
	LEFT JOIN #TASK1 D on A.Em_Cve_Empleado=D.Em_Cve_Empleado and D.Factor_Integracion=C.Factor_Integracion
	WHERE D.Em_Cve_Empleado IS NULL

END

--============================================================