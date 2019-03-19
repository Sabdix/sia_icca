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
-- Author:		<Christian Pe�a Romero>

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
-- Author:		<Christian Pe�a Romero>

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
-- Author:		<Christian Pe�a Romero>

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
-- Author:		<Christian Pe�a Romero>

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
-- Author:		<Christian Pe�a Romero>

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
-- Author:		<Christian Pe�a Romero>

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

-- se crea procedimiento DT_SP_VERIFICAR_ORIGINACION_SOLICITUD
if exists (select * from sysobjects where name like 'DT_SP_VERIFICAR_ORIGINACION_SOLICITUD' and xtype = 'p')
	drop proc DT_SP_VERIFICAR_ORIGINACION_SOLICITUD
go

/*

Autor			PICHARDO HURTADO OSCAR
Fecha			20190319
Objetivo		VERIFICA SI SE PUEDE ORIGINAR UNA SOLICITUD


*/

create proc DT_SP_VERIFICAR_ORIGINACION_SOLICITUD

	@Em_Cve_Empleado varchar(20)
	
		-- parametros
		-- [aqu� van los par�metros]

as

	begin -- procedimiento
		
		begin try -- try principal
		
			begin -- inicio

				-- declaraciones
				declare @status int = 1,
						@error_message varchar(255) = '',
						@error_line varchar(255) = '',
						@error_severity varchar(255) = '',
						@error_procedure varchar(255) = ''
						
			end -- inicio
			
			begin -- validaciones
			
				-- -- se realiza la validaci�n que exista el empleado
				 if not exists (select * from Empleado where Em_Cve_Empleado=@Em_Cve_Empleado)
				 	raiserror('El empleado no existe', 11, 0)
				
			end -- validaciones
			
			begin -- �mbito de la actualizaci�n
			--select * from DT_CAT_STATUS_SOLICITUD
				if((select COUNT(*) from DT_TBL_VIATICO_SOLICITUD where Em_Cve_Empleado=@Em_Cve_Empleado and Id_Estatus_Solicitud not in (2,3))>1)
				begin
					set @status=0
					set @error_message='El empleado excede el n�mero de solicitudes permitidas'
				end
			
			end -- �mbito de la actualizaci�n

		end try -- try principal
		
		begin catch -- catch principal
		
			-- captura del error
			select	@status = -error_state(),
					@error_procedure = coalesce(error_procedure(), 'CONSULTA DIN�MICA'),
					@error_line = error_line(),
					@error_message = error_message(),
					@error_severity =
						case error_severity()
							when 11 then 'Error en validaci�n'
							when 12 then 'Error en consulta'
							when 13 then 'Error en actualizaci�n'
							else 'Error general'
						end
		
		end catch -- catch principal
		
		begin -- reporte de estatus

			select	@status status,
					@error_procedure mensaje ,
					@error_line error_line,
					@error_severity error_severity,
					@error_message error_message
					
		end -- reporte de estatus
		
	end -- procedimiento
	
go

grant exec on DT_SP_VERIFICAR_ORIGINACION_SOLICITUD to public


