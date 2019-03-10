USE IICA_1
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
