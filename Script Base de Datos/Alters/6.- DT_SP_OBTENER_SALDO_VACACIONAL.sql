USE [IICA_1]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_SALDO_VACACIONAL]    Script Date: 09/03/2019 05:29:56 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_SALDO_VACACIONAL]
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		Fecha_Inicio_Periodo,
		Fecha_Fin_Periodo,
		Saldo_Periodo_Anterior,
		Saldo_Proporcional_Actual,
		Saldo_Actual_Disponible ,
		Saldo_Actual_Utilizado,
		Saldo_Correspondiente
	FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO
	WHERE Em_Cve_Empleado=@Em_Cve_Empleado
	AND Activo=1


END
