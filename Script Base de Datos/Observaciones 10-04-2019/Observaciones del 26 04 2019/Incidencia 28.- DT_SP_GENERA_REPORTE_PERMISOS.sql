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
/****** Object:  StoredProcedure [dbo].[DT_SP_GENERA_REPORTE_PERMISOS]    Script Date: 26/04/2019 12:35:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Genera el reporte de las solicitudes de permisos>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_GENERA_REPORTE_PERMISOS]
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
	ORDER BY B.Em_Apellido_Paterno
END
