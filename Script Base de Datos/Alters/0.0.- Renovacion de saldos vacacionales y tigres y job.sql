
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

 /*
 
 
 select *
 from DT_TBL_PERIODO_VACACIONAL_EMPLEADO
 where Em_Cve_Empleado='0000003844'

 select Em_Fecha_Ingreso,*
 from Empleado
 order by Em_Cve_Empleado desc
 
 insert into Empleado
 select 
	'0000003844',
	'0000003844',
	Em_Password,
	Em_Persona,
	Em_Nombre,
	Em_Apellido_Paterno,
	Em_Apellido_Materno,
	Gre_Cve_Grupo_Empleado,
	De_Cve_Departamento_Empleado,
	Pe_Cve_Puesto_Empleado,
	Sc_Cve_Sucursal,
	Em_Reporta,
	Em_Fecha_Nacimiento,
	Em_Sexo,
	Em_Estado_Civil,
	Em_Tipo_Sangre,
	Em_Escolaridad,
	Em_Cedula_Profesional,
	Em_Lugar_Nacimiento,
	Em_Nacionalidad,
	Em_Num_Dependientes,
	Em_Transporte,
	Em_Fuentes_Empleo,
	Em_Cambio_Residencia,
	Em_Disposicion_Viajar,
	Em_Num_IMSS,
	Em_Checa_Tarjeta,
	Em_Sindicalizado,
	Em_Licencia,
	Em_Grupo_IMSS,
	Em_Regimen,
	Em_Cruzamiento_1,
	Em_Cruzamiento_2,
	Em_Tipo_Jornada,
	Em_Numero_Interior,
	Em_Numero_Exterior,
	Em_Ingreso_IMSS,
	Ntc_Cve_Nomina_Tipo_Contrato,
	Em_Credito_FONACOT,
	Em_Credito_INFONAVIT,
	Em_Declaracion_Anual,
	Em_Tiene_Casa,
	Em_Unidad_Medica_Familiar,
	Em_R_F_C,
	Em_Cedula_Fiscal,
	Em_CURP,
	Em_Sueldo_Integrado,
	Em_Sueldo_Nominal,
	Em_Sueldo_Mensual,
	Em_Fecha_Ingreso,
	Em_Contrato_Tipo,
	Em_Contrato_Valor,
	Em_Contrato_Inicia,
	Em_Contrato_Vence,
	Em_Fecha_Baja,
	Em_Causa_Baja,
	Em_Direccion_1,
	Em_Direccion_2,
	Em_Direccion_3,
	Em_Telefono_1,
	Em_Telefono_2,
	Em_Telefono_3,
	Em_Extension_Telefono,
	Em_Ciudad,
	Em_Estado,
	Em_Email,
	Em_Email_2,
	Em_Operador,
	Em_Telefono_Contacto_1,
	Em_Direccion_Contacto_1,
	Em_Telefono_Contacto_2,
	Em_Direccion_Contacto_2,
	Em_Pais,
	Em_Sitio_Web,
	Em_Contacto_1,
	Em_email_Contacto_1,
	Em_Contacto_2,
	Em_email_Contacto_2,
	Em_Cuenta_Contable,
	Em_Cuenta_Contable_2,
	Em_Cuenta_Contable_3,
	Em_Centro_Costo,
	Em_Deudor,
	Em_Proyecto,
	Em_UEN,
	Em_Barras,
	Em_Identificacion_Oficial,
	Em_Incluir_PTU,
	Em_UserDef_1,
	Em_UserDef_2,
	Em_UserDef_3,
	Em_UserDef_4,
	Em_UserDef_5,
	Em_UserDef_6,
	Oper_Alta,
	Fecha_Alta,
	Oper_Ult_Modif,
	Fecha_Ult_Modif,
	Oper_Baja,
	Fecha_Baja,
	Es_Cve_Estado,
	Em_Entidad_Federativa
	FROM Empleado
	where Em_Cve_Empleado='0000003843'

 
 */
 
 
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_RENUEVA_SALDOS_VACACIONALES')
BEGIN
	DROP PROCEDURE DT_SP_RENUEVA_SALDOS_VACACIONALES
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
-- Author:		<CHRISTIAN PEÑA ROMERO>
-- Description:	<SP que renueva los saldos vacacionales de los empleados>
-- =============================================
CREATE PROCEDURE DT_SP_RENUEVA_SALDOS_VACACIONALES
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

	SET @Hoy=CONVERT(VARCHAR,DATEADD(DD,2,GETDATE()),103)

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
			convert(int,B.Em_Cve_Empleado) id_temp,
			a.Em_Cve_Empleado,
			Em_Fecha_Ingreso
		FROM Empleado a
		INNER JOIN DT_TBL_PERIODO_VACACIONAL_EMPLEADO B ON a.Em_Cve_Empleado=b.Em_Cve_Empleado
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
		Saldo_Actual_Disponible=Saldo_Periodo_Anterior+Saldo_Proporcional_Actual,
		Saldo_Actual_Utilizado=0,
		Saldo_Correspondiente=C.Dias_Vacaciones,
		Fecha_Actualizacion=GETDATE(),
		Activo=1
	FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
	INNER JOIN #TASK1 B ON a.Em_Cve_Empleado=B.Em_Cve_Empleado
	INNER JOIN DT_CAT_DIAS_VACACIONES c on B.Anios=c.Anios
	INNER JOIN Empleado D on A.Em_Cve_Empleado=D.Em_Cve_Empleado


	UPDATE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
	SET
		Saldo_Proporcional_Actual=((DATEDIFF(DD,DATEADD(yy,A.Anios,B.Em_Fecha_Ingreso),@Hoy))*c.Dias_Vacaciones)/365
	from DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
	LEFT JOIN Empleado B on A.Em_Cve_Empleado=B.Em_Cve_Empleado
	INNER JOIN DT_CAT_DIAS_VACACIONES c on A.Anios=c.Anios
	LEFT JOIN #TASK1 D on A.Em_Cve_Empleado=D.Em_Cve_Empleado
	WHERE D.Em_Cve_Empleado IS NULL

END
GO

GRANT EXECUTE ON DT_SP_RENUEVA_SALDOS_VACACIONALES TO public;  
GO

--Actualización de saldos vacacionales
EXECUTE DT_SP_RENUEVA_SALDOS_VACACIONALES
GO