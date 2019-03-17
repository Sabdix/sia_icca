use IICA_1
go

-- se crea procedimiento DT_SP_ACTUALIZAR_FORMATO_PERMISO
if exists (select * from sysobjects where name like 'DT_SP_ACTUALIZAR_FORMATO_PERMISO' and xtype = 'p' and db_name() = 'IICA_1')
	drop proc DT_SP_ACTUALIZAR_FORMATO_PERMISO
go

/*

Autor			PICHARDO HURTADO
UsuarioRed		aaaa111111
Fecha			20190315
Objetivo		ACTUALIZA EL PATH DE LA SOLICITUD DE UN PERMISO
Proyecto		Proyecto
Ticket			ticket

*/

create proc

	DT_SP_ACTUALIZAR_FORMATO_PERMISO
	
		-- parametros
		@Id_Permiso int,
		@path_formato_autorizacion varchar(200)

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
			
			begin -- ámbito de la actualización
			
		    if not exists (select * from DT_TBL_PERMISO where Id_Permiso = @Id_Permiso)
			 raiserror('La solicitud del permiso no existe', 11, 0)
	
			UPDATE DT_TBL_PERMISO
			SET path_formato_autorizacion=@path_formato_autorizacion
			WHERE Id_Permiso=@Id_Permiso
			end -- ámbito de la actualización

		end try -- try principal
		
		begin catch -- catch principal
		
			-- captura del error
			select	@status = -error_state(),
					@error_procedure = coalesce(error_procedure(), 'CONSULTA DINÁMICA'),
					@error_line = error_line(),
					@error_message = error_message(),
					@error_severity =
						case error_severity()
							when 11 then 'Error en validación'
							when 12 then 'Error en consulta'
							when 13 then 'Error en actualización'
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

grant exec on DT_SP_ACTUALIZAR_FORMATO_PERMISO to public
go

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_PERMISO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_PERMISO
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<DSI>
-- Create date: <Obtiene los datos de una incapacidad en particular>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_PERMISO
	@Id_Permiso int
AS
BEGIN

	SET NOCOUNT ON;
	if exists (select * from DT_TBL_PERMISO where Id_Permiso = @Id_Permiso)
		select
				1 STATUS,
				'' MENSAJE,
				a.*,
				b.Descripcion_Status_Solicitud
			from
				DT_TBL_PERMISO a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			WHERE 
				a.Id_Permiso = @Id_Permiso
	else
	begin
		select 0 STATUS, 'No se encontro el permiso solicito' mensaje
	end

END
GO

GRANT EXECUTE ON DT_SP_OBTENER_PERMISO TO public;  
GO





-- se crea procedimiento DT_SP_ACTUALIZAR_FORMATO_VACACION
if exists (select * from sysobjects where name like 'DT_SP_ACTUALIZAR_FORMATO_VACACION' and xtype = 'p' and db_name() = 'IICA_1')
	drop proc DT_SP_ACTUALIZAR_FORMATO_VACACION
go

/*

Autor			PICHARDO HURTADO
UsuarioRed		aaaa111111
Fecha			20190315
Objetivo		ACTUALIZA EL PATH DE LA SOLICITUD DE UNA VACACION
Proyecto		Proyecto
Ticket			ticket

*/

create proc

	DT_SP_ACTUALIZAR_FORMATO_VACACION
	
		-- parametros
		@Id_Vacacion int,
		@path_formato_autorizacion varchar(200)

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
			
			begin -- ámbito de la actualización
			
		    if not exists (select * from DT_TBL_VACACIONES where Id_Vacaciones = @Id_Vacacion)
			 raiserror('La solicitud de la vacación no existe', 11, 0)
	
			UPDATE DT_TBL_VACACIONES
			SET path_formato_autorizacion=@path_formato_autorizacion
			WHERE Id_Vacaciones=@Id_Vacacion
			end -- ámbito de la actualización

		end try -- try principal
		
		begin catch -- catch principal
		
			-- captura del error
			select	@status = -error_state(),
					@error_procedure = coalesce(error_procedure(), 'CONSULTA DINÁMICA'),
					@error_line = error_line(),
					@error_message = error_message(),
					@error_severity =
						case error_severity()
							when 11 then 'Error en validación'
							when 12 then 'Error en consulta'
							when 13 then 'Error en actualización'
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

grant exec on DT_SP_ACTUALIZAR_FORMATO_VACACION to public
go

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_VACACION')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_VACACION
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<DSI>
-- Create date: <Obtiene los datos de una vacacion en particular>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_VACACION
	@Id_Vacacion int
AS
BEGIN

	SET NOCOUNT ON;
	if exists (select * from DT_TBL_VACACIONES where Id_Vacaciones = @Id_Vacacion)
		select
				1 STATUS,
				'' MENSAJE,
				a.*,
				b.Descripcion_Status_Solicitud
			from
				DT_TBL_VACACIONES a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			WHERE 
				a.Id_Vacaciones = @Id_Vacacion
	else
	begin
		select 0 STATUS, 'No se encontro la vacación solicita' mensaje
	end

END
GO

GRANT EXECUTE ON DT_SP_OBTENER_VACACION TO public;  
GO


