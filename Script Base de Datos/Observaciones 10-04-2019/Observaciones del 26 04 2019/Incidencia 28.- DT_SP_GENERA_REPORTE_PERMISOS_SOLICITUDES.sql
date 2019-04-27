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
/****** Object:  StoredProcedure [dbo].[DT_SP_GENERA_REPORTE_PERMISOS_SOLICITUDES]    Script Date: 26/04/2019 12:36:18 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_GENERA_REPORTE_PERMISOS_SOLICITUDES]
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
	order by B.Em_Apellido_Paterno
END 
