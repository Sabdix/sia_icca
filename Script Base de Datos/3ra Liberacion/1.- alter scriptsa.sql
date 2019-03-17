use IICA_1
go

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
alter PROCEDURE DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL
	
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
		b.Em_Fecha_Ingreso,
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

/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_PERMISOS_USUARIO]    Script Date: 15/03/2019 06:15:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_PERMISOS_USUARIO]
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
				d.Motivo_Permiso,
				a.Em_Cve_Empleado
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
go



/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_VACACIONES_USUARIO]    Script Date: 09/03/2019 06:26:30 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_VACACIONES_USUARIO]
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
				CONVERT (VARCHAR,DATEADD(DD,-1,d.Fecha_Fin),103)Fecha_Fin,
				d.Total_Dias,
				CONVERT (VARCHAR,d.Fecha_Fin,103) Reanudar_Labores,
				d.Motivo_Vacaciones,
				a.Em_Cve_Empleado
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