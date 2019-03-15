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

GRANT EXECUTE ON DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL TO public;  
GO
