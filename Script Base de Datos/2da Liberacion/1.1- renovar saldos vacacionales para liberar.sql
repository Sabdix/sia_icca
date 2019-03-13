--Se llena por unica ocación la tabla
--DROP TABLE #TASK1

USE IICA_1
GO

TRUNCATE TABLE DT_TBL_VACACIONES
TRUNCATE TABLE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
GO

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
LEFT JOIN Empleado B ON a.Em_Cve_Empleado=b.Em_Cve_Empleado
LEFT JOIN DT_CAT_DIAS_VACACIONES c on a.Anios=c.Anios
order by a.Anios desc

GO

EXEC DT_SP_RENUEVA_SALDOS_VACACIONALES
GO