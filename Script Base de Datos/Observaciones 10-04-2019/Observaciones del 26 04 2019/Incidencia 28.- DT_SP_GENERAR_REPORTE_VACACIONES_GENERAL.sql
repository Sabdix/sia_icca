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
/****** Object:  StoredProcedure [dbo].[DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL]    Script Date: 26/04/2019 11:15:34 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL]
	@Em_Cve_Empleado VARCHAR(30),
	@Abreviatura_Proyecto VARCHAR(50),
	@De_Cve_Departamento_Empleado VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE
		@SC_CVE_SUCURSAL VARCHAR(50)

	IF @Abreviatura_Proyecto LIKE 'TODOS'
	BEGIN
		SET @SC_CVE_SUCURSAL='0000'
	END
	ELSE
	BEGIN
		SELECT
			@SC_CVE_SUCURSAL=Sc_Cve_Sucursal
		FROM Sucursal
		WHERE Sc_UserDef_2=@Abreviatura_Proyecto
	END

    -- Insert statements for procedure here
	--Consulta para los autorizadores
	IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_AUTORIZADORES WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Id_Rol_Usuario=2)
	BEGIN

			IF @SC_CVE_SUCURSAL LIKE '0000'
			BEGIN
				SELECT
					b.Em_Cve_Empleado,
					B.Em_Nombre,
					B.Em_Apellido_Paterno,
					B.Em_Apellido_Materno,
					CONVERT(VARCHAR,b.Em_Fecha_Ingreso,101) Em_Fecha_Ingreso,
					C.Sc_Descripcion Proyecto,
					COALESCE(NULL,D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
					A.Saldo_Periodo_Anterior-a.Saldo_Periodo_Anterior_Usado Saldo_Anterior,
					A.Saldo_Actual_Utilizado Vacaciones_Tomandas,
					A.Saldo_Proporcional_Actual Saldo_Proporcional,
					A.Saldo_Actual_Disponible Saldo_Final
				FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
				INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
				LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
				LEFT JOIN Departamento_Empleado D ON B.De_Cve_Departamento_Empleado=D.De_Cve_Departamento_Empleado
				--LEFT JOIN DEPARTAMENTO D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.DP_CVE_DEPARTAMENTO
				WHERE C.Sc_UserDef_2 IN (SELECT Proyecto FROM DT_TBL_USUARIOS_AUTORIZADORES WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Id_Rol_Usuario=2 GROUP BY Proyecto)
				ORDER BY Em_Apellido_Paterno
			END

			ELSE
			BEGIN
				IF @De_Cve_Departamento_Empleado NOT LIKE '0000'
				BEGIN
					SELECT
						b.Em_Cve_Empleado,
						B.Em_Nombre,
						B.Em_Apellido_Paterno,
						B.Em_Apellido_Materno,
						CONVERT(VARCHAR,b.Em_Fecha_Ingreso,101) Em_Fecha_Ingreso,
						C.Sc_Descripcion Proyecto,
						COALESCE(NULL,D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
						A.Saldo_Periodo_Anterior-a.Saldo_Periodo_Anterior_Usado Saldo_Anterior,
						A.Saldo_Actual_Utilizado Vacaciones_Tomandas,
						A.Saldo_Proporcional_Actual Saldo_Proporcional,
						A.Saldo_Actual_Disponible Saldo_Final
					FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
					INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
					LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
					LEFT JOIN Departamento_Empleado D ON B.De_Cve_Departamento_Empleado=D.De_Cve_Departamento_Empleado
					--LEFT JOIN DEPARTAMENTO D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.DP_CVE_DEPARTAMENTO
					WHERE C.Sc_UserDef_2 IN (SELECT Proyecto FROM DT_TBL_USUARIOS_AUTORIZADORES WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Id_Rol_Usuario=2 GROUP BY Proyecto)
					AND D.De_Cve_Departamento_Empleado=@De_Cve_Departamento_Empleado
					ORDER BY Em_Apellido_Paterno
				END
				ELSE
				BEGIN
					SELECT
						b.Em_Cve_Empleado,
						B.Em_Nombre,
						B.Em_Apellido_Paterno,
						B.Em_Apellido_Materno,
						CONVERT(VARCHAR,b.Em_Fecha_Ingreso,101) Em_Fecha_Ingreso,
						C.Sc_Descripcion Proyecto,
						COALESCE(NULL,D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
						A.Saldo_Periodo_Anterior-a.Saldo_Periodo_Anterior_Usado Saldo_Anterior,
						A.Saldo_Actual_Utilizado Vacaciones_Tomandas,
						A.Saldo_Proporcional_Actual Saldo_Proporcional,
						A.Saldo_Actual_Disponible Saldo_Final
					FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
					INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
					LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
					LEFT JOIN Departamento_Empleado D ON B.De_Cve_Departamento_Empleado=D.De_Cve_Departamento_Empleado
					--LEFT JOIN DEPARTAMENTO D ON B.DE_CVE_DEPARTAMENTO_EMPLEADO=D.DP_CVE_DEPARTAMENTO
					WHERE C.Sc_UserDef_2 IN (SELECT Proyecto FROM DT_TBL_USUARIOS_AUTORIZADORES WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Id_Rol_Usuario=2 GROUP BY Proyecto)
					AND c.SC_CVE_SUCURSAL=@SC_CVE_SUCURSAL
					ORDER BY Em_Apellido_Paterno
				END

			END
	END
	
	IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_ADMINISTRADOR WHERE Usuario=@Em_Cve_Empleado AND Id_Rol_Usuario=4)
	BEGIN
		IF @SC_CVE_SUCURSAL LIKE '0000'
			BEGIN
				SELECT
					b.Em_Cve_Empleado,
					B.Em_Nombre,
					B.Em_Apellido_Paterno,
					B.Em_Apellido_Materno,
					CONVERT(VARCHAR,b.Em_Fecha_Ingreso,101) Em_Fecha_Ingreso,
					C.Sc_Descripcion Proyecto,
					COALESCE(NULL,D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
					A.Saldo_Periodo_Anterior-a.Saldo_Periodo_Anterior_Usado Saldo_Anterior,
					A.Saldo_Actual_Utilizado Vacaciones_Tomandas,
					A.Saldo_Proporcional_Actual Saldo_Proporcional,
					A.Saldo_Actual_Disponible Saldo_Final
				FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
				INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
				LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
				LEFT JOIN Departamento_Empleado D ON B.De_Cve_Departamento_Empleado=D.De_Cve_Departamento_Empleado
				ORDER BY Em_Apellido_Paterno
			END

			ELSE
			BEGIN
				IF @De_Cve_Departamento_Empleado NOT LIKE '0000'
				BEGIN
					SELECT
						b.Em_Cve_Empleado,
						B.Em_Nombre,
						B.Em_Apellido_Paterno,
						B.Em_Apellido_Materno,
						CONVERT(VARCHAR,b.Em_Fecha_Ingreso,101) Em_Fecha_Ingreso,
						C.Sc_Descripcion Proyecto,
						COALESCE(NULL,D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
						A.Saldo_Periodo_Anterior-a.Saldo_Periodo_Anterior_Usado Saldo_Anterior,
						A.Saldo_Actual_Utilizado Vacaciones_Tomandas,
						A.Saldo_Proporcional_Actual Saldo_Proporcional,
						A.Saldo_Actual_Disponible Saldo_Final
					FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
					INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
					LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
					LEFT JOIN Departamento_Empleado D ON B.De_Cve_Departamento_Empleado=D.De_Cve_Departamento_Empleado
					WHERE D.De_Cve_Departamento_Empleado=@De_Cve_Departamento_Empleado
					ORDER BY Em_Apellido_Paterno
				END
				ELSE
				BEGIN
					SELECT
						b.Em_Cve_Empleado,
						B.Em_Nombre,
						B.Em_Apellido_Paterno,
						B.Em_Apellido_Materno,
						CONVERT(VARCHAR,b.Em_Fecha_Ingreso,101) Em_Fecha_Ingreso,
						C.Sc_Descripcion Proyecto,
						COALESCE(NULL,D.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
						A.Saldo_Periodo_Anterior-a.Saldo_Periodo_Anterior_Usado Saldo_Anterior,
						A.Saldo_Actual_Utilizado Vacaciones_Tomandas,
						A.Saldo_Proporcional_Actual Saldo_Proporcional,
						A.Saldo_Actual_Disponible Saldo_Final
					FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO A
					INNER JOIN Empleado B ON A.Em_Cve_Empleado=B.Em_Cve_Empleado
					LEFT JOIN SUCURSAL C ON B.SC_CVE_SUCURSAL=C.SC_CVE_SUCURSAL
					LEFT JOIN Departamento_Empleado D ON B.De_Cve_Departamento_Empleado=D.De_Cve_Departamento_Empleado
					WHERE c.SC_CVE_SUCURSAL=@SC_CVE_SUCURSAL
					ORDER BY Em_Apellido_Paterno
				END

			END
		
	END

END