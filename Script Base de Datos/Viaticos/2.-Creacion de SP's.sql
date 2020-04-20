USE IICA_1
GO

--==========================================================================================================================
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
--==========================================================================================================================
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

--==========================================================================================================================
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
--==========================================================================================================================
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
--==========================================================================================================================
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

--==========================================================================================================================
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
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_NIVEL_MANDO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_NIVEL_MANDO
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
CREATE PROCEDURE DT_SP_OBTENER_NIVEL_MANDO
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM DT_CAT_NIVEL_MANDO
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_NIVEL_MANDO TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_GASTO_COMPROBACION')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_GASTO_COMPROBACION
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
CREATE PROCEDURE DT_SP_OBTENER_GASTO_COMPROBACION
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM DT_CAT_GASTO_COMPROBACION
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_GASTO_COMPROBACION TO public;  
GO
--==========================================================================================================================
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
				if((select COUNT(*) from DT_TBL_VIATICO_SOLICITUD where Em_Cve_Empleado=@Em_Cve_Empleado 
				and id_etapa_solicitud <> 7 and Id_estatus_solicitud <> 3)>1)
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
go
--==========================================================================================================================
-- se crea procedimiento DT_SP_CONSULTAR_SOLICITUDES_USUARIO
if exists (select * from sysobjects where name like 'DT_SP_CONSULTAR_SOLICITUDES_USUARIO' and xtype = 'p')
	drop proc DT_SP_CONSULTAR_SOLICITUDES_USUARIO
go

/*

Autor			PICHARDO HURTADO OSCAR
Fecha			20190319
Objetivo		VERIFICA SI SE PUEDE ORIGINAR UNA SOLICITUD


*/

create proc DT_SP_CONSULTAR_SOLICITUDES_USUARIO

	@Em_Cve_Empleado varchar(20),
	@Id_Etapa_Solicitud int
		-- parametros
		-- [aqu� van los par�metros]

as

	begin -- procedimiento
				select vs.*
					,mt.Descripcion medio_transporte
					,j.Descripcion justificacion
					,td.Descripcion tipo_divisa
					,etapa.Id_etapa_solicitud
					,etapa.Descripcion desc_etapa
					,es.Id_estatus_solicitud
					,es.Descripcion desc_estatus
					,tv.Descripcion tipo_viaje
					,coalesce(emp.Em_Nombre,'')Em_Nombre
					,coalesce(emp.Em_Apellido_Paterno,'')Em_Apellido_Paterno
					,coalesce(emp.Em_Apellido_Materno,'') Em_Apellido_Materno
					,Em_Email
				from 
					DT_TBL_VIATICO_SOLICITUD  vs
					join DT_CAT_MEDIO_TRANSPORTE mt
					on vs.Id_Medio_Transporte=mt.Id_Medio_Transporte
					join DT_CAT_JUSTIFICACION j
					on vs.Id_Justificacion=j.Id_Justificacion
					join DT_CAT_TIPO_DIVISA td
					on vs.Id_Tipo_Divisa=td.Id_Tipo_Divisa
					join DT_CAT_ETAPAS_SOLICITUD_VIATICO etapa
					on vs.Id_etapa_solicitud=etapa.Id_etapa_solicitud
					join DT_CAT_ESTATUS_SOLICITUD_VIATICO es
					on vs.Id_Estatus_Solicitud=es.Id_estatus_solicitud
					join DT_CAT_TIPO_VIAJE tv
					on vs.Id_Tipo_Viaje=tv.Id_Tipo_Viaje
					join Empleado emp
					on vs.Em_Cve_Empleado=emp.Em_Cve_Empleado
				where 
					vs.Em_Cve_Empleado=@Em_Cve_Empleado 
					--and vs.Id_etapa_solicitud = 1
					and vs.Id_estatus_solicitud <> 3
					and vs.Id_Etapa_Solicitud = @Id_Etapa_Solicitud
			
	end -- procedimiento
	
go

grant exec on DT_SP_CONSULTAR_SOLICITUDES_USUARIO to public
go
--==========================================================================================================================
-- se crea procedimiento DT_SP_CONSULTAR_SOLICITUDES_USUARIO
if exists (select * from sysobjects where name like 'DT_SP_ACTUALIZAR_ESTATUS_SOLICITUD' and xtype = 'p')
	drop proc DT_SP_ACTUALIZAR_ESTATUS_SOLICITUD
go

/*

Autor			PICHARDO HURTADO OSCAR
Fecha			20190322
Objetivo		ACTUALIZA EL ESTATUS DE LA SOLICITUD


*/

create proc DT_SP_ACTUALIZAR_ESTATUS_SOLICITUD

	@id_etapa_solicitud int,
	@id_estatus_solicitud int,
	@id_solicitud int,
	@Em_Cve_Empleado varchar(20) = null
	
		-- parametros
		-- [aqu� van los par�metros]

as

	begin -- procedimiento
		
		begin try -- try principal
		
			begin -- inicio

				-- declaraciones
				declare @status int = 1,
						@error_message varchar(255) = 'Solicitud actualizada correctamente.',
						@error_line varchar(255) = '',
						@error_severity varchar(255) = '',
						@error_procedure varchar(255) = ''
			
			end -- inicio
			
			begin -- validaciones
			
				-- -- se realiza la validaci�n que exista la solicitud
				 if not exists(select * from DT_TBL_VIATICO_SOLICITUD where Id_Solicitud=@id_solicitud)
					raiserror('La solicitud actual no existe', 11, 0)

				-- -- se realiza la validaci�n que exista la etapa de la solicitud
				 if not exists(select * from DT_CAT_ETAPAS_SOLICITUD_VIATICO where Id_etapa_solicitud=@id_etapa_solicitud)
					raiserror('La etapa actual no existe', 11, 0)

					-- -- se realiza la validaci�n que exista el estatus de la solicitud
				 if not exists(select * from DT_CAT_ESTATUS_SOLICITUD_VIATICO where Id_estatus_solicitud=@id_estatus_solicitud)
					raiserror('El estatus de la solicitud no existe', 11, 0)
				
			end -- validaciones
			
			begin -- �mbito de la actualizaci�n
			
			if @id_etapa_solicitud = 3 and @id_estatus_solicitud = 1--Se autoriza la sol.
			begin
				update DT_TBL_VIATICO_SOLICITUD 
					set Id_etapa_solicitud=@id_etapa_solicitud
					,Id_estatus_solicitud=@id_estatus_solicitud
					,Em_Cve_Empleado_Autoriza = @Em_Cve_Empleado
				where 
					Id_Solicitud=@id_solicitud
			end
			else
				update DT_TBL_VIATICO_SOLICITUD 
				set Id_etapa_solicitud=@id_etapa_solicitud
				,Id_estatus_solicitud=@id_estatus_solicitud
				where 
					Id_Solicitud=@id_solicitud
			
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
					@error_procedure error_procedure,
					@error_line error_line,
					@error_severity error_severity,
					@error_message error_message
					
		end -- reporte de estatus
		
	end -- procedimiento
	
go

grant exec on DT_SP_ACTUALIZAR_ESTATUS_SOLICITUD to public
go
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTAR_SOLICITUDES_PARA_CREAR_CHEQUE')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTAR_SOLICITUDES_PARA_CREAR_CHEQUE
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Autor			PICHARDO
--Fecha			20190322
--Objetivo		OBTIENE LA LISTA DE LAS SOLICITUDES PARA CREAR CHEQUE
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTAR_SOLICITUDES_PARA_CREAR_CHEQUE
AS
BEGIN

	select 
	vs.*
		,mt.Descripcion medio_transporte
		,j.Descripcion justificacion
		,td.Descripcion tipo_divisa
		,etapa.Id_etapa_solicitud
		,etapa.Descripcion desc_etapa
		,es.Id_estatus_solicitud
		,es.Descripcion desc_estatus
		,tv.Descripcion tipo_viaje
		,coalesce(em.Em_Nombre,'')Em_Nombre
		,coalesce(em.Em_Apellido_Paterno,'')Em_Apellido_Paterno
		,coalesce(em.Em_Apellido_Materno,'') Em_Apellido_Materno
		,em.Em_Email
		,Monto_Viatico_Autorizado
	from 
		DT_TBL_VIATICO_SOLICITUD  vs
		join DT_CAT_MEDIO_TRANSPORTE mt
		on vs.Id_Medio_Transporte=mt.Id_Medio_Transporte
		join DT_CAT_JUSTIFICACION j
		on vs.Id_Justificacion=j.Id_Justificacion
		join DT_CAT_TIPO_DIVISA td
		on vs.Id_Tipo_Divisa=td.Id_Tipo_Divisa
		join DT_CAT_ETAPAS_SOLICITUD_VIATICO etapa
		on vs.Id_etapa_solicitud=etapa.Id_etapa_solicitud
		join DT_CAT_ESTATUS_SOLICITUD_VIATICO es
		on vs.Id_Estatus_Solicitud=es.Id_estatus_solicitud
		join DT_CAT_TIPO_VIAJE tv
		on vs.Id_Tipo_Viaje=tv.Id_Tipo_Viaje
		join Empleado em on vs.Em_Cve_Empleado = em.Em_UserDef_1
		join Sucursal s on s.Sc_Cve_Sucursal = em.Sc_Cve_Sucursal
		join Empleado emp
		on vs.Em_Cve_Empleado=emp.Em_Cve_Empleado
	where 
		vs.Id_etapa_solicitud = 3
		and vs.Id_estatus_solicitud <> 3

END
GO

GRANT EXECUTE ON DT_SP_CONSULTAR_SOLICITUDES_PARA_CREAR_CHEQUE TO public
GO

--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_TARIFAS_VIATICO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_TARIFAS_VIATICO
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
CREATE PROCEDURE DT_SP_OBTENER_TARIFAS_VIATICO
	-- Add the parameters for the stored procedure here
	@Id_Solicitud INT,
	@Pernocta BIT,
	@Marginal BIT,
	@Id_Nivel_Mando INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='TARIFA CALCULADA DE MANERA CORRECTA',
		@Id_Tipo_Viaje INT,
		@Id_Tipo_Divisa INT,
		@Duracion_Viaje DECIMAL(5,2),
		@Monto_Viatico_Autorizado MONEY,
		@Tarifa_Viatico MONEY,
		@Monto_Gastos_Extras MONEY


	SELECT 
		@Id_Tipo_Viaje=Id_Tipo_Viaje,
		@Id_Tipo_Divisa=Id_Tipo_Divisa,
		@Duracion_Viaje=Duracion_Viaje
	FROM DT_TBL_VIATICO_SOLICITUD 
	WHERE Id_Solicitud=@Id_Solicitud


	SELECT
		@Tarifa_Viatico=tarifa
	FROM DT_CAT_TARIFA_VIATICO
	WHERE
		Pernocta=@Pernocta AND
		Marginal=@Marginal AND
		Id_Tipo_Viaje=@Id_Tipo_Viaje AND
		Id_Tipo_Divisa=@Id_Tipo_Divisa AND 
		Id_Nivel_Mando=@Id_Nivel_Mando
	
	IF @Tarifa_Viatico IS NULL
	BEGIN
		SET @mensaje='NO EXISTE TARIFA PARA LOS PARAMETROS INGRESADOS.'
		GOTO ERROR_1
	END
	
	SELECT @Monto_Gastos_Extras=coalesce (SUM(Monto),0)
	FROM DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD
	WHERE Id_Solicitud=@Id_Solicitud AND Descripcion NOT LIKE 'TRANSPORTE A�REO'

	UPDATE DT_TBL_VIATICO_SOLICITUD 
	SET 
		Monto_Viatico_Autorizado=(@Tarifa_Viatico*(@Duracion_Viaje))+@Monto_Gastos_Extras,
		Pernocta=@Pernocta,
		Marginal=@Marginal,
		Tarifa_de_Ida=@Tarifa_Viatico*(@Duracion_Viaje-.5),
		Tarifa_de_Vuelta=@Tarifa_Viatico*(.5)
	WHERE Id_Solicitud=@Id_Solicitud

	GOTO EXIT_

	ERROR_1:
		SET @status=0
		SET @Tarifa_Viatico=0
		GOTO EXIT_
	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE, (@Tarifa_Viatico*(@Duracion_Viaje-.5)) TARIFA_DE_IDA,(@Tarifa_Viatico*(.5))TARIFA_DE_VUELTA

END
GO

GRANT EXECUTE ON DT_SP_OBTENER_TARIFAS_VIATICO TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZA_FECHA_CHEQUE_VIATICO')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZA_FECHA_CHEQUE_VIATICO
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
CREATE PROCEDURE DT_SP_ACTUALIZA_FECHA_CHEQUE_VIATICO
	-- Add the parameters for the stored procedure here
	@Id_Solicitud INT,
	@Fecha_Cheque varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='GUARDADO DE MANERA CORRECTA'


	UPDATE DT_TBL_VIATICO_SOLICITUD 
	SET 
		Fecha_Cheque=@Fecha_Cheque
	WHERE Id_Solicitud=@Id_Solicitud
	IF @@ERROR<>0
	BEGIN
		SET @mensaje='ERROR AL GUARDAR INFORMACION DEL CHEQUE.'
		GOTO ERROR_1
	END


	GOTO EXIT_

	ERROR_1:
		SET @status=0
		GOTO EXIT_
	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE

END
GO

GRANT EXECUTE ON DT_SP_ACTUALIZA_FECHA_CHEQUE_VIATICO TO public;  
GO

--==========================================================================================================================

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_INSERTA_COMPROBACION_GASTO')
BEGIN
	DROP PROCEDURE DT_SP_INSERTA_COMPROBACION_GASTO
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
CREATE PROCEDURE DT_SP_INSERTA_COMPROBACION_GASTO
	-- Add the parameters for the stored procedure here
	@Id_Solicitud INT,
	@Comentario VARCHAR(500),
	@Path_Archivo_XML VARCHAR(500),
	@Path_Archivo_PDF VARCHAR(500),
	@Id_Gasto_Comprobacion INT,
	@Emisor VARCHAR(500),
	@Subtotal MONEY,
	@Total MONEY,
	@Lugar VARCHAR(500),
	@Fecha DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='GUARDADO DE MANERA CORRECTA',
		@id bigint = 0


	INSERT
		INTO DT_TBL_VIATICO_COMPROBACION_GASTOS
			(
				Id_Solicitud,
				Comentario,
				Path_Archivo_XML,
				Path_Archivo_PDF,
				Id_Gasto_Comprobacion,
				Emisor,
				Subtotal,
				Total,
				Lugar,
				Fecha
			)
		VALUES 
			(
				@Id_Solicitud,
				@Comentario,
				@Path_Archivo_XML,
				@Path_Archivo_PDF,
				@Id_Gasto_Comprobacion,
				@Emisor,
				@Subtotal,
				@Total,
				@Lugar,
				@Fecha
			)
		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL GUARDAR LA COMPROBACION DEL GASTO.'
			GOTO ERROR_1
		END
		ELSE
		BEGIN
			select @id = Max(Id_Comprobacion_Gasto) from 
			DT_TBL_VIATICO_COMPROBACION_GASTOS where Id_Solicitud=@Id_Solicitud
		END


	GOTO EXIT_

	ERROR_1:
		SET @status=0
		GOTO EXIT_
	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE,@id id

END
GO

GRANT EXECUTE ON DT_SP_INSERTA_COMPROBACION_GASTO TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ELIMINA_COMPROBACION_GASTO')
BEGIN
	DROP PROCEDURE DT_SP_ELIMINA_COMPROBACION_GASTO
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
CREATE PROCEDURE DT_SP_ELIMINA_COMPROBACION_GASTO
	-- Add the parameters for the stored procedure here
	@Id_Comprobacion_Gasto INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='ELIMINADO DE MANERA CORRECTA'


		DELETE DT_TBL_VIATICO_COMPROBACION_GASTOS
		WHERE Id_Comprobacion_Gasto=@Id_Comprobacion_Gasto

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL ELIMINAR LA COMPROBACION DEL GASTO.'
			GOTO ERROR_1
		END


	GOTO EXIT_

	ERROR_1:
		SET @status=0
		GOTO EXIT_
	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE

END
GO

GRANT EXECUTE ON DT_SP_ELIMINA_COMPROBACION_GASTO TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_COMPROBACION_GASTO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_COMPROBACION_GASTO
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
CREATE PROCEDURE DT_SP_OBTENER_COMPROBACION_GASTO
	-- Add the parameters for the stored procedure here
	@Id_Solicitud INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		cg.*,
		catGC.Descripcion gasto_comprobacion
	FROM 
		DT_TBL_VIATICO_COMPROBACION_GASTOS cg
	inner join 
		DT_CAT_GASTO_COMPROBACION catGC on cg.Id_Gasto_Comprobacion = catGC.Id_Gasto_Comprobacion
	WHERE Id_Solicitud=@Id_Solicitud

END
GO

GRANT EXECUTE ON DT_SP_OBTENER_COMPROBACION_GASTO TO public;  
GO
--==========================================================================================================================

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_GUARDA_COMPROBACION_GASTOS')
BEGIN
	DROP PROCEDURE DT_SP_GUARDA_COMPROBACION_GASTOS
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
CREATE PROCEDURE DT_SP_GUARDA_COMPROBACION_GASTOS
	-- Add the parameters for the stored procedure here
	@Id_Solicitud INT,
	@Path_Archivo_Reintegro VARCHAR(300)=NULL,
	@Fecha_Reintegro VARCHAR(30)=NULL,
	@Importe_Reintegro MONEY=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='COMPROBACI�N GUARDADA DE MANERA CORRECTA.',
		@Monto_Viatico_Comprobado MONEY


	--SE OBTIENE EL MONTO COMPROBADO

	SELECT 
		@Monto_Viatico_Comprobado=COALESCE(SUM(Total),0)
	FROM DT_TBL_VIATICO_COMPROBACION_GASTOS
	WHERE Id_Solicitud=@Id_Solicitud

	--SE COMIENZAN LAS AFECTACIONES
	UPDATE DT_TBL_VIATICO_SOLICITUD
	SET 
		Id_Estatus_Solicitud=1,
		Fecha_Reintegro=COALESCE(@Fecha_Reintegro,GETDATE()),
		Importe_Reintegro=COALESCE(@Importe_Reintegro,0),
		Path_Archivo_Reintegro=COALESCE(@Path_Archivo_Reintegro,''),
		Id_Etapa_Solicitud=Id_Etapa_Solicitud+1,
		Monto_Viatico_Comprobado=@Monto_Viatico_Comprobado
	WHERE Id_Solicitud=@Id_Solicitud

	IF @@ERROR<>0
	BEGIN
		SET @status=0
		SET @mensaje ='ERROR AL GUARDAR LA COMPROBACI�N.'
	END

	EXIT_: SELECT @status STATUS, @mensaje MENSAJE

END
GO

GRANT EXECUTE ON DT_SP_GUARDA_COMPROBACION_GASTOS TO public;  
GO

--==========================================================================================================================

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZAR_PATH_ARCHIVOS_COMPROBACION_GASTO')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZAR_PATH_ARCHIVOS_COMPROBACION_GASTO
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
CREATE PROCEDURE DT_SP_ACTUALIZAR_PATH_ARCHIVOS_COMPROBACION_GASTO
	-- Add the parameters for the stored procedure here
	@id_comprobacion_gasto int,
	@archivo int,
	@path_archivo VARCHAR(500)
	
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='ARCHIVO GUARDADO DE MANERA CORRECTA',
		@id bigint = 0

		/*
		 FACTURA_XML=1,
        FACTURA_PDF = 2,
        COMPROBACION_SAT = 3,
        OTROS_TICKET = 4
		*/
		IF(@archivo= 3)--
		begin
			 update DT_TBL_VIATICO_COMPROBACION_GASTOS set Path_Archivo_SAT = @path_archivo
			 where
				Id_Comprobacion_Gasto = @id_comprobacion_gasto

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GUARDAR EL ARCHIVO DE LA COMPROBACION DE GASTO.'
				GOTO ERROR_1
			END
		end

		IF(@archivo= 4)--
		begin
			 update DT_TBL_VIATICO_COMPROBACION_GASTOS set Path_Archivo_Otros = @path_archivo
			 where
				Id_Comprobacion_Gasto = @id_comprobacion_gasto

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GUARDAR EL ARCHIVO DE LA COMPROBACION DE GASTO.'
				GOTO ERROR_1
			END

		end


	GOTO EXIT_

	ERROR_1:
		SET @status=0
		GOTO EXIT_
	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE,@id id

END
GO

GRANT EXECUTE ON DT_SP_ACTUALIZAR_PATH_ARCHIVOS_COMPROBACION_GASTO TO public;  
GO

--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZAR_PATH_ARCHIVOS_VIATICOS_SOLICITUD')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZAR_PATH_ARCHIVOS_VIATICOS_SOLICITUD
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
CREATE PROCEDURE DT_SP_ACTUALIZAR_PATH_ARCHIVOS_VIATICOS_SOLICITUD
	-- Add the parameters for the stored procedure here
	@Id_Solicitud int,
	@Id_Archivo int,
	@Path_Archivo VARCHAR(500)
	
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='ARCHIVO GUARDADO DE MANERA CORRECTA'

		/*==========================
		1	Archivo de autorizaci�n
		2	Comprobante de instancia
		3	Archivo 10% no comprobable
		4	Informe de viatico
		5	Archivo de reintegro
		6	Formato i4
		7	Formato i5

		==========================*/
		IF(@Id_Archivo= 1)
		BEGIN
			UPDATE DT_TBL_VIATICO_SOLICITUD 
			SET Path_Archivo_Autorizacion = @Path_Archivo
			WHERE Id_Solicitud = @Id_Solicitud
		END

		IF(@Id_Archivo= 2)
		BEGIN
			UPDATE DT_TBL_VIATICO_SOLICITUD 
			SET Path_Comprobante_Estancia = @Path_Archivo
			WHERE Id_Solicitud = @Id_Solicitud
		END

		IF(@Id_Archivo= 3)
		BEGIN
			UPDATE DT_TBL_VIATICO_SOLICITUD 
			SET Path_Archivo_10_No_Comprobable = @Path_Archivo
			WHERE Id_Solicitud = @Id_Solicitud
		END
		
		IF(@Id_Archivo= 4)
		BEGIN
			UPDATE DT_TBL_VIATICO_SOLICITUD 
			SET Path_Informe_Viaje = @Path_Archivo
			WHERE Id_Solicitud = @Id_Solicitud
		END

		IF(@Id_Archivo= 5)
		BEGIN
			UPDATE DT_TBL_VIATICO_SOLICITUD 
			SET Path_Archivo_Reintegro = @Path_Archivo
			WHERE Id_Solicitud = @Id_Solicitud
		END

		IF(@Id_Archivo= 6)
		BEGIN
			UPDATE DT_TBL_VIATICO_SOLICITUD 
			SET Path_i4 = @Path_Archivo
			WHERE Id_Solicitud = @Id_Solicitud
		END

		IF(@Id_Archivo= 7)
		BEGIN
			UPDATE DT_TBL_VIATICO_SOLICITUD 
			SET Path_i5 = @Path_Archivo
			WHERE Id_Solicitud = @Id_Solicitud
		END


		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL GUARDAR EL ARCHIVO DE LA COMPROBACION DE GASTO.'
			GOTO ERROR_1
		END


	GOTO EXIT_

	ERROR_1:
		SET @status=0
		GOTO EXIT_
	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE

END
GO

GRANT EXECUTE ON DT_SP_ACTUALIZAR_PATH_ARCHIVOS_VIATICOS_SOLICITUD TO public;  
GO

--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTAR_SOLICITUDES_POR_VERIFICAR')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTAR_SOLICITUDES_POR_VERIFICAR
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Autor			PICHARDO
--Fecha			20190327
--Objetivo		OBTIENE LA LISTA DE LAS SOLICITUDES PARA VERIFICAR MONTOS AUTORIZADOS Y REINTEGRO
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTAR_SOLICITUDES_POR_VERIFICAR
AS
BEGIN
	select 
	vs.*
		,mt.Descripcion medio_transporte
		,j.Descripcion justificacion
		,td.Descripcion tipo_divisa
		,etapa.Id_etapa_solicitud
		,etapa.Descripcion desc_etapa
		,es.Id_estatus_solicitud
		,es.Descripcion desc_estatus
		,tv.Descripcion tipo_viaje
		,coalesce(em.Em_Nombre,'')Em_Nombre
		,coalesce(em.Em_Apellido_Paterno,'')Em_Apellido_Paterno
		,coalesce(em.Em_Apellido_Materno,'') Em_Apellido_Materno
		,em.Em_Email
		,Monto_Viatico_Autorizado
		,case 
			when vs.marginal = 0 then 1
			when vs.marginal = 1 and COALESCE(
				(select top 1 1 from DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD where Id_Solicitud = vs.Id_Solicitud),0) =1 then 1
			else 0
			end realizar_comprobacion_gastos,
			COALESCE((select top 1 1 from DT_TBL_VIATICO_ITINERARIO where Id_Solicitud = vs.Id_Solicitud and  Id_Medio_Transporte=2),0) comprobar_itinerario_aereo
	from 
		DT_TBL_VIATICO_SOLICITUD  vs
		join DT_CAT_MEDIO_TRANSPORTE mt
		on vs.Id_Medio_Transporte=mt.Id_Medio_Transporte
		join DT_CAT_JUSTIFICACION j
		on vs.Id_Justificacion=j.Id_Justificacion
		join DT_CAT_TIPO_DIVISA td
		on vs.Id_Tipo_Divisa=td.Id_Tipo_Divisa
		join DT_CAT_ETAPAS_SOLICITUD_VIATICO etapa
		on vs.Id_etapa_solicitud=etapa.Id_etapa_solicitud
		join DT_CAT_ESTATUS_SOLICITUD_VIATICO es
		on vs.Id_Estatus_Solicitud=es.Id_estatus_solicitud
		join DT_CAT_TIPO_VIAJE tv
		on vs.Id_Tipo_Viaje=tv.Id_Tipo_Viaje
		join Empleado em on vs.Em_Cve_Empleado = em.Em_UserDef_1
		join Sucursal s on s.Sc_Cve_Sucursal = em.Sc_Cve_Sucursal
		join Empleado emp
		on vs.Em_Cve_Empleado=emp.Em_Cve_Empleado
	where 
		vs.Id_etapa_solicitud = 5
		and vs.Id_estatus_solicitud <> 3

END
GO

GRANT EXECUTE ON DT_SP_CONSULTAR_SOLICITUDES_POR_VERIFICAR TO public
GO

--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZAR_PATH_ARCHIVO_ITINERARIO')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZAR_PATH_ARCHIVO_ITINERARIO
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
CREATE PROCEDURE DT_SP_ACTUALIZAR_PATH_ARCHIVO_ITINERARIO
	-- Add the parameters for the stored procedure here
	@Id_Itinerario int,
	@Path_Archivo VARCHAR(500)
	
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='ARCHIVO GUARDADO DE MANERA CORRECTA'


		IF (@Path_Archivo IS NULL) OR (NOT EXISTS(SELECT 1 FROM DT_TBL_VIATICO_ITINERARIO  WHERE Id_Itinerario = @Id_Itinerario))
		BEGIN
			SET @mensaje='DATOS INCOMPLETOS, FAVOR DE REVISAR.'
			GOTO ERROR_1
		END
		IF(@Path_Archivo IS NOT NULL)
		BEGIN
			UPDATE DT_TBL_VIATICO_ITINERARIO 
			SET Path_Pasaje_Abordar = @Path_Archivo
			WHERE Id_Itinerario = @Id_Itinerario
		END

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL GUARDAR EL ARCHIVO DEl ITINERARIO.'
			GOTO ERROR_1
		END


	GOTO EXIT_

	ERROR_1:
		SET @status=0
		GOTO EXIT_
	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE

END
GO

GRANT EXECUTE ON DT_SP_ACTUALIZAR_PATH_ARCHIVO_ITINERARIO TO public;  

--==========================================================================================================================
-- se crea procedimiento DT_SP_CONSULTAR_SOLICITUDES_USUARIO
if exists (select * from sysobjects where name like 'DT_SP_CONSULTAR_HISTORIAL_SOLICITUDES_USUARIO' and xtype = 'p')
	drop proc DT_SP_CONSULTAR_HISTORIAL_SOLICITUDES_USUARIO
go

/*

Autor			PICHARDO HURTADO OSCAR
Fecha			20190319
Objetivo		VERIFICA SI SE PUEDE ORIGINAR UNA SOLICITUD


*/

create proc DT_SP_CONSULTAR_HISTORIAL_SOLICITUDES_USUARIO

	@Em_Cve_Empleado varchar(20)
		-- parametros
		-- [aqu� van los par�metros]

as

	begin -- procedimiento
				select vs.*
					,mt.Descripcion medio_transporte
					,j.Descripcion justificacion
					,td.Descripcion tipo_divisa
					,etapa.Id_etapa_solicitud
					,etapa.Descripcion desc_etapa
					,es.Id_estatus_solicitud
					,es.Descripcion desc_estatus
					,tv.Descripcion tipo_viaje
					,coalesce(emp.Em_Nombre,'')Em_Nombre
					,coalesce(emp.Em_Apellido_Paterno,'')Em_Apellido_Paterno
					,coalesce(emp.Em_Apellido_Materno,'') Em_Apellido_Materno
					,Em_Email
				from 
					DT_TBL_VIATICO_SOLICITUD  vs
					join DT_CAT_MEDIO_TRANSPORTE mt
					on vs.Id_Medio_Transporte=mt.Id_Medio_Transporte
					join DT_CAT_JUSTIFICACION j
					on vs.Id_Justificacion=j.Id_Justificacion
					join DT_CAT_TIPO_DIVISA td
					on vs.Id_Tipo_Divisa=td.Id_Tipo_Divisa
					join DT_CAT_ETAPAS_SOLICITUD_VIATICO etapa
					on vs.Id_etapa_solicitud=etapa.Id_etapa_solicitud
					join DT_CAT_ESTATUS_SOLICITUD_VIATICO es
					on vs.Id_Estatus_Solicitud=es.Id_estatus_solicitud
					join DT_CAT_TIPO_VIAJE tv
					on vs.Id_Tipo_Viaje=tv.Id_Tipo_Viaje
					join Empleado emp
					on vs.Em_Cve_Empleado=emp.Em_Cve_Empleado
				where 
					vs.Em_Cve_Empleado=@Em_Cve_Empleado 
					--and vs.Id_etapa_solicitud = 1
					--and vs.Id_estatus_solicitud <> 3
					--and vs.Id_Etapa_Solicitud = @Id_Etapa_Solicitud
			
	end -- procedimiento
	
go

grant exec on DT_SP_CONSULTAR_HISTORIAL_SOLICITUDES_USUARIO to public
go
--==========================================================================================================================