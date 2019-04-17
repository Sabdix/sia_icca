use DB_A0966E_iica
go

-- se crea procedimiento SP_SP_CONSULTAR_TARIFAS_VIATICOS
if exists (select * from sysobjects where name like 'DT_SP_CONSULTAR_TARIFAS_VIATICOS' and xtype = 'p' and db_name() = 'DB_A0966E_iica')
	drop proc DT_SP_CONSULTAR_TARIFAS_VIATICOS
go

/*

Autor			PICHARDO HURTADO

Fecha			20190417
Objetivo		CONSULTAS LAS TARIFAS DE VIATICOS
Proyecto		Proyecto
Ticket			ticket

*/

create proc

	DT_SP_CONSULTAR_TARIFAS_VIATICOS
	
		-- parametros
		-- [aquí van los parámetros]

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
				select * from DT_CAT_TARIFA_VIATICO tv
				join DT_CAT_TIPO_VIAJE tviaje
				on tv.id_tipo_viaje=tviaje.id_tipo_viaje
				join DT_CAT_TIPO_DIVISA td
				on tv.id_tipo_divisa=td.id_tipo_divisa
				join DT_CAT_NIVEL_MANDO nm
				on tv.Id_Nivel_Mando=nm.Id_Nivel_Mando			
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
	end -- procedimiento
	
go

grant exec on DT_SP_CONSULTAR_TARIFAS_VIATICOS to public

