--USE IICA_1
--GO

--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTAR_PROYECTOS_FILTRADOS_PVI')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTAR_PROYECTOS_FILTRADOS_PVI
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
CREATE PROCEDURE DT_SP_CONSULTAR_PROYECTOS_FILTRADOS_PVI
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #RESULTADO(
		Id_Proyecto VARCHAR(20),
		Descipcion_Proyecto VARCHAR(50),
		Abreviatura_Proyecto VARCHAR(20)
	)

    -- Insert statements for procedure here
	--Consulta para los autorizadores de PVI
	IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_AUTORIZADORES WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Id_Rol_Usuario=2)
	BEGIN
		
		INSERT INTO #RESULTADO VALUES('0000','TODOS','TODOS')
		
		INSERT 
			INTO #RESULTADO
		SELECT
			A.Sc_Cve_Sucursal,
			A.Sc_Descripcion,
			A.Sc_UserDef_2
		FROM Sucursal A 
		INNER JOIN DT_TBL_USUARIOS_AUTORIZADORES B ON A.Sc_UserDef_2=b.Proyecto
		AND B.Em_Cve_Empleado=@Em_Cve_Empleado
		AND B.Id_Rol_Usuario=2
		ORDER BY A.Sc_Descripcion
		
	END
	--Consulta para los administradores de PVI
	IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_ADMINISTRADOR WHERE Usuario=@Em_Cve_Empleado AND Id_Rol_Usuario=4)
	BEGIN
		
		INSERT INTO #RESULTADO VALUES('0000','TODOS','TODOS')
		
		INSERT 
			INTO #RESULTADO
		SELECT
			A.Sc_Cve_Sucursal Id_Proyecto,
			A.Sc_Descripcion Descipcion_Proyecto,
			A.Sc_UserDef_2 Abreviatura_Proyecto
		FROM Sucursal A 
		ORDER BY A.Sc_Descripcion
	END

	IF NOT EXISTS (SELECT 1 FROM #RESULTADO )
	BEGIN
		INSERT INTO #RESULTADO VALUES('0000','SIN RESULTADOS','SIN RESULTADOS')
	END

	SELECT * FROM #RESULTADO

END
GO


GRANT EXECUTE ON DT_SP_CONSULTAR_PROYECTOS_FILTRADOS_PVI TO public;  
GO