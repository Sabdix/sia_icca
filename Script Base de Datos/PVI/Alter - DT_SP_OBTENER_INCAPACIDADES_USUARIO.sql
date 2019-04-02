USE [IICA_1]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_INCAPACIDADES_USUARIO]    Script Date: 02/04/2019 10:41:37 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_INCAPACIDADES_USUARIO]
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
				COALESCE(NULL,c.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
				CONVERT (VARCHAR,d.Fecha_Solicitud,103)Fecha_Alta,
				d.Id_Tipo_Incapacidad,
				CONVERT (VARCHAR,d.Fecha_Inicio,103)Fecha_Inicio,
				CONVERT (VARCHAR,d.Fecha_Fin,103)Fecha_Fin,
				d.Total_Dias,
				CONVERT (VARCHAR,DATEADD(DD,1,d.Fecha_Fin),103) Reanudar_Labores,
				d.Motivo_Rechazo,
				d.Id_Tipo_Seguimiento,
				-----------ACTUALIZACION PARA MOSTRAR LOS FORMATOS	---------------
				d.Formato_Incapacidad,
				d.Formato_Adicional,
				d.Formato_ST7_Alta_RT,
				d.Formato_ST7_Calificacion_RT,
				d.Formato_RT_cuestionario
			from Empleado a
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
			INNER JOIN DT_TBL_INCAPACIDAD d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END



/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_PERMISOS_USUARIO]    Script Date: 26/03/2019 11:09:38 p.m. ******/
SET ANSI_NULLS ON
