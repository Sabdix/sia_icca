USE [DB_A0966E_iica]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL]    Script Date: 23/04/2019 09:47:41 p.m. ******/
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
	@Em_Cve_Empleado INT
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
END