USE IICA_1
GO

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


IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_GENERA_REPORTE_PERMISOS')
BEGIN
	DROP PROCEDURE DT_SP_GENERA_REPORTE_PERMISOS
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
-- Description:	<Genera el reporte de las solicitudes de permisos>
-- =============================================
CREATE PROCEDURE DT_SP_GENERA_REPORTE_PERMISOS
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	SELECT
		B.Em_Nombre,
		B.Em_Apellido_Paterno,
		B.Em_Apellido_Materno,
		C.Sc_Descripcion Proyecto,
		COALESCE(NULL,D.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
		B.Fecha_Alta,
		A.Fecha_Permiso,
		A.Motivo_Permiso,
		A.Motivo_Rechazo,
		E.Descripcion_Status_Solicitud
	FROM DT_TBL_PERMISO A
	INNER JOIN EMPLEADO B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
	LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
	LEFT JOIN DEPARTAMENTO D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.DP_CVE_DEPARTAMENTO
	INNER JOIN DT_CAT_STATUS_SOLICITUD E ON A.Id_Status_Solicitud=E.Id_Status_Solicitud

END
GO

GRANT EXECUTE ON DT_SP_GENERA_REPORTE_PERMISOS TO public;
GO



IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_GENERA_REPORTE_VACACIONES_SOLICITUDES')
BEGIN
	DROP PROCEDURE DT_SP_GENERA_REPORTE_VACACIONES_SOLICITUDES
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
CREATE PROCEDURE DT_SP_GENERA_REPORTE_VACACIONES_SOLICITUDES
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		Id_Vacaciones,
		B.Em_Nombre,
		B.Em_Apellido_Paterno,
		B.Em_Apellido_Materno,
		C.Sc_Descripcion Proyecto,
		COALESCE(NULL,D.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
		A.Fecha_Solicitud,
		A.Fecha_Inicio,
		A.Fecha_Fin,
		E.Descripcion_Status_Solicitud
	FROM DT_TBL_VACACIONES A
	INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
	LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
	LEFT JOIN DEPARTAMENTO D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.DP_CVE_DEPARTAMENTO
	INNER JOIN DT_CAT_STATUS_SOLICITUD E ON A.Id_Status_Solicitud=E.Id_Status_Solicitud

END
GO

GRANT EXECUTE ON DT_SP_GENERA_REPORTE_VACACIONES_SOLICITUDES TO public;  
GO



IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL')
BEGIN
	DROP PROCEDURE DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL
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
CREATE PROCEDURE DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		b.Em_Cve_Empleado,
		B.Em_Nombre,
		B.Em_Apellido_Paterno,
		B.Em_Apellido_Materno,
		C.Sc_Descripcion Proyecto,
		COALESCE(NULL,D.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
		A.Saldo_Periodo_Anterior-a.Saldo_Periodo_Anterior_Usado Saldo_Anterior,
		A.Saldo_Actual_Utilizado Vacaciones_Tomandas,
		A.Saldo_Proporcional_Actual Saldo_Proporcional,
		A.Saldo_Actual_Disponible Saldo_Final
	FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
	INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
	LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
	LEFT JOIN DEPARTAMENTO D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.DP_CVE_DEPARTAMENTO

END
GO

GRANT EXECUTE ON DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL TO public;  
GO



IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_GENERA_REPORTE_PERMISOS_SOLICITUDES')
BEGIN
	DROP PROCEDURE DT_SP_GENERA_REPORTE_PERMISOS_SOLICITUDES
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
CREATE PROCEDURE DT_SP_GENERA_REPORTE_PERMISOS_SOLICITUDES
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		Id_Permiso,
		B.Em_Nombre,
		B.Em_Apellido_Paterno,
		B.Em_Apellido_Materno,
		C.Sc_Descripcion Proyecto,
		COALESCE(NULL,D.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
		A.Fecha_Alta,
		A.Fecha_Permiso,
		A.Motivo_Permiso,
		E.Descripcion_Status_Solicitud
	FROM DT_TBL_PERMISO A
	INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
	LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
	LEFT JOIN DEPARTAMENTO D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.DP_CVE_DEPARTAMENTO
	INNER JOIN DT_CAT_STATUS_SOLICITUD E ON A.Id_Status_Solicitud=E.Id_Status_Solicitud

END 
GO

GRANT EXECUTE ON DT_SP_GENERA_REPORTE_PERMISOS_SOLICITUDES TO public;  
GO
