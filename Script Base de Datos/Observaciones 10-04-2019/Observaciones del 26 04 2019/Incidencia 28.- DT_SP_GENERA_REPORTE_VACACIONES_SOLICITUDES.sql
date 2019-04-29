/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2012 (11.0.5388)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

--USE IICA_1
--GO
/****** Object:  StoredProcedure [dbo].[DT_SP_GENERA_REPORTE_VACACIONES_SOLICITUDES]    Script Date: 26/04/2019 12:37:05 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_GENERA_REPORTE_VACACIONES_SOLICITUDES]
	@Abreviatura_Proyecto VARCHAR(50),
	@De_Cve_Departamento_Empleado VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	DECLARE
		@SC_CVE_SUCURSAL VARCHAR(50)

	SELECT
		@SC_CVE_SUCURSAL=Sc_Cve_Sucursal
	FROM Sucursal
	WHERE Sc_UserDef_2=@Abreviatura_Proyecto

	IF @SC_CVE_SUCURSAL LIKE '0000'
	BEGIN
		SELECT
			Id_Vacaciones,
			B.Em_Nombre,
			B.Em_Apellido_Paterno,
			B.Em_Apellido_Materno,
			C.Sc_Descripcion Proyecto,
			COALESCE(D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
			A.Fecha_Solicitud,
			A.Fecha_Inicio,
			A.Fecha_Fin,
			E.Descripcion_Status_Solicitud
		FROM DT_TBL_VACACIONES A
		INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
		LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
		LEFT JOIN Departamento_Empleado D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.De_Cve_Departamento_Empleado
		INNER JOIN DT_CAT_STATUS_SOLICITUD E ON A.Id_Status_Solicitud=E.Id_Status_Solicitud
		ORDER BY B.Em_Apellido_Paterno 
	END
	ELSE
	BEGIN
		IF @De_Cve_Departamento_Empleado NOT LIKE '0000'
		BEGIN
			SELECT
				Id_Vacaciones,
				B.Em_Nombre,
				B.Em_Apellido_Paterno,
				B.Em_Apellido_Materno,
				C.Sc_Descripcion Proyecto,
				COALESCE(D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
				A.Fecha_Solicitud,
				A.Fecha_Inicio,
				A.Fecha_Fin,
				E.Descripcion_Status_Solicitud
			FROM DT_TBL_VACACIONES A
			INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
			LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
			LEFT JOIN Departamento_Empleado D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.De_Cve_Departamento_Empleado
			INNER JOIN DT_CAT_STATUS_SOLICITUD E ON A.Id_Status_Solicitud=E.Id_Status_Solicitud
			WHERE D.De_Cve_Departamento_Empleado=@De_Cve_Departamento_Empleado
			ORDER BY B.Em_Apellido_Paterno 
			
		END
		ELSE
		BEGIN
			SELECT
				Id_Vacaciones,
				B.Em_Nombre,
				B.Em_Apellido_Paterno,
				B.Em_Apellido_Materno,
				C.Sc_Descripcion Proyecto,
				COALESCE(D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
				A.Fecha_Solicitud,
				A.Fecha_Inicio,
				A.Fecha_Fin,
				E.Descripcion_Status_Solicitud
			FROM DT_TBL_VACACIONES A
			INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
			LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
			LEFT JOIN Departamento_Empleado D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.De_Cve_Departamento_Empleado
			INNER JOIN DT_CAT_STATUS_SOLICITUD E ON A.Id_Status_Solicitud=E.Id_Status_Solicitud
			WHERE c.SC_CVE_SUCURSAL=@SC_CVE_SUCURSAL
			ORDER BY B.Em_Apellido_Paterno 
		END

	END
	
	
END
