/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2012 (11.0.5388)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [DB_A0966E_iica]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_VACACIONES_USUARIO]    Script Date: 06/04/2019 11:20:01 p. m. ******/
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
				/*
				select aut_proyecto
				from Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
				*/
				SELECT Proyecto
				FROM DT_TBL_USUARIOS_AUTORIZADORES
				WHERE Id_Rol_Usuario=2-- DT_CAT_ROL_USUARIO: 2	Autorizador PVI	1
				AND Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				GROUP BY Proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END
