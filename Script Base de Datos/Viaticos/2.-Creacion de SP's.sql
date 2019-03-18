USE IICA_1
GO


IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_TIPO_VIAJE')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_TIPO_VIAJE
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
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_TIPO_VIAJE
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM DT_CAT_TIPO_VIAJE
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_TIPO_VIAJE TO public;  
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_TIPO_MEDIO_TRANSPORTE')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_TIPO_MEDIO_TRANSPORTE
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
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_TIPO_MEDIO_TRANSPORTE
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM DT_CAT_MEDIO_TRANSPORTE
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_TIPO_MEDIO_TRANSPORTE TO public;  
GO


USE IICA_1
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_JUSTIFICACION')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_JUSTIFICACION
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
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_JUSTIFICACION
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM DT_CAT_JUSTIFICACION
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_JUSTIFICACION TO public;  
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_TIPO_SALIDA')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_TIPO_SALIDA
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
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_TIPO_SALIDA
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM DT_CAT_TIPO_SALIDA
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_TIPO_SALIDA TO public;  
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_TIPO_DIVISA')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_TIPO_DIVISA
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
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_TIPO_DIVISA
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM DT_CAT_TIPO_DIVISA
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_TIPO_DIVISA TO public;  
GO


IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_GASTO_EXTRA')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_GASTO_EXTRA
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
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_GASTO_EXTRA
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM DT_CAT_GASTO_EXTRA
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_GASTO_EXTRA TO public;  
GO

