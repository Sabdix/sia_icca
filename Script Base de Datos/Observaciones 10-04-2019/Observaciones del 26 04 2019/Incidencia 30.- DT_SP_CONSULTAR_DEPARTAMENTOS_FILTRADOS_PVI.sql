--USE IICA_1
--GO

--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTAR_DEPARTAMENTOS_FILTRADOS_PVI')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTAR_DEPARTAMENTOS_FILTRADOS_PVI
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
-- Author:		CHRISTIAN PEÑA ROMERO
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTAR_DEPARTAMENTOS_FILTRADOS_PVI
	-- Add the parameters for the stored procedure here
	@Abreviatura_Proyecto VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		'0000' De_Cve_Departamento_Empleado,
		'TODOS' De_Descripcion

	UNION
	SELECT
		De_Cve_Departamento_Empleado,
		De_Descripcion
	FROM Departamento_Empleado
	WHERE De_UserDef_2=@Abreviatura_Proyecto

END
GO


GRANT EXECUTE ON DT_SP_CONSULTAR_DEPARTAMENTOS_FILTRADOS_PVI TO public;  
GO