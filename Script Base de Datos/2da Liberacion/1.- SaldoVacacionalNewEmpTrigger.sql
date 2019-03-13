USE IICA_1
GO


IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'SaldoVacacionalNewEmpTrigger'))
	DROP TRIGGER SaldoVacacionalNewEmpTrigger
GO
GO
 
-- Cremamos un Trigger sobre la tabla Viaticos_Autorizadores
CREATE TRIGGER SaldoVacacionalNewEmpTrigger
ON Empleado
 AFTER INSERT AS 
	
	DECLARE
		@Id_Ultimo_Empleado VARCHAR(100),
		@Anios int,
		@Hoy varchar(50),
		@Contador int=1,
		@Tope int,
		@Id_Temp int,
		@Fecha_Ingreso DATETIME
	
	SET @Hoy=CONVERT(VARCHAR,DATEADD(DD,2,GETDATE()),103)

	SELECT
		@Id_Ultimo_Empleado=Max(Em_Cve_Empleado)
	FROM Empleado
	
	IF NOT EXISTS(SELECT 1 FROM Empleado WHERE Em_Cve_Empleado=@Id_Ultimo_Empleado)
	BEGIN
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
			convert(int,@Id_Ultimo_Empleado) id_temp,
			a.Em_Cve_Empleado,
			Em_Fecha_Ingreso
		FROM Empleado a
		WHERE Em_Cve_Empleado=@Id_Ultimo_Empleado
		
		SELECT
			@Fecha_Ingreso=Em_Fecha_Ingreso
		FROM #TASK1

		SELECT
			@Anios=ANIOS
		FROM FN_DSI_DIFERENCIA_FECHAS (@Fecha_Ingreso,@Hoy)

		UPDATE #TASK1
		SET Anios=@Anios

		INSERT 
			INTO DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			(
			Em_Cve_Empleado,
			Anios,
			Fecha_Inicio_Periodo,
			Fecha_Fin_Periodo,
			Saldo_Periodo_Anterior,
			Saldo_Periodo_Anterior_Usado,
			Saldo_Proporcional_Actual,
			Saldo_Proporcional_Actual_Usado,
			Saldo_Actual_Disponible,
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
			0 Saldo_Periodo_Anterior,
			0 Saldo_Periodo_Anterior_Usado,
			((DATEDIFF(DD,DATEADD(yy,a.Anios,b.Em_Fecha_Ingreso),GETDATE()))*c.Dias_Vacaciones)/365 Saldo_Proporcional_Actual,
			0 Saldo_Proporcional_Actual_Usado,
			0+((DATEDIFF(DD,DATEADD(yy,a.Anios,b.Em_Fecha_Ingreso),GETDATE()))*c.Dias_Vacaciones)/365 Saldo_Actual_Disponible,
			0 Saldo_Actual_Utilizado,
			c.Dias_Vacaciones Saldo_Correspondiente,
			GETDATE() Fecha_Actualizacion,
			1
		FROM #TASK1 A
		INNER JOIN Empleado B ON a.Em_Cve_Empleado=b.Em_Cve_Empleado AND B.Em_Cve_Empleado=@Id_Ultimo_Empleado
		INNER JOIN DT_CAT_DIAS_VACACIONES c on a.Anios=c.Anios

	END

 GO