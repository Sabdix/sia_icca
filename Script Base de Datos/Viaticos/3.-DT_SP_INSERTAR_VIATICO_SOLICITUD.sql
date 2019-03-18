IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_INSERTAR_VIATICO_SOLICITUD')
BEGIN
	DROP PROCEDURE DT_SP_INSERTAR_VIATICO_SOLICITUD
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
-- Author:		Christian Peña
-- Description:	<Guarda la solicitud en la base de datos>
-- =============================================
CREATE PROCEDURE DT_SP_INSERTAR_VIATICO_SOLICITUD
	@Solicitud XML
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE
		@Status INT=1,
		@Mensaje VARCHAR(250)='OK',
		@Id_Solicitud_Viatico INT

		SELECT 
			XTBL.value('(fechaAlta)[1]','Datetime') Solicitud_Fecha_Alta,
			XTBL.value('(fechaInicio)[1]',' DATETIME')Solicitud_Fecha_Inicio,
			XTBL.value('(fechaFin)[1]',' DATETIME')Solicitud_Fecha_Fin,
			XTBL.value('(medioTransporte/idMedioTransporte)[1]',' INT')Solicitud_Id_Medio_Transporte,
			XTBL.value('(proposito)[1]',' VARCHAR(300)')Solicitud_Proposito,
			XTBL.value('(resultadosEsperados)[1]',' VARCHAR(300)')Solicitud_Resultados_Esperados,
			XTBL.value('(justificacion/idJustificacion)[1]',' INT')Solicitud_Id_Justificacion,
			XTBL.value('(condicionesEspeciales)[1]',' VARCHAR(300)')Solicitud_Condiciones_Especiales,
			XTBL.value('(Em_Cve_Empleado)[1]',' VARCHAR(20)')Solicitud_Em_Cve_Empleado,
			XTBL.value('(Em_Cve_Empleado_Autoriza)[1]',' VARCHAR(20)')Solicitud_Em_Cve_Empleado_Autoriza,
			XTBL.value('(tipoViaje/idTipoViaje)[1]',' INT')Solicitud_Id_Tipo_Viaje
		INTO #SOLICITUD
		FROM @Solicitud.nodes('SolicitudViatico') AS XD(XTBL)
		IF @@ERROR<>0
		BEGIN
			SELECT @Mensaje='Error al procesar XML, apartado de solicitud'
			GOTO ERROR_
		END


		SELECT
			XTBL.value('(origen)[1]', 'VARCHAR(300)')Itinerario_Origen,
			XTBL.value('(destino)[1]', 'VARCHAR(300)')Itinerario_Destino,
			XTBL.value('(medioTransporte/idMedioTransporte)[1]', 'INT')Itinerario_Id_Medio_Transporte,
			XTBL.value('(linea)[1]', 'VARCHAR(35)')Itinerario_Linea,
			XTBL.value('(numeroAsiento)[1]', 'VARCHAR(35)')Itinerario_Numero_Asiento,
			XTBL.value('(horaSalida)[1]', 'VARCHAR(6)')Itinerario_Hora_Salida,
			XTBL.value('(horaLLegada)[1]', 'VARCHAR(6)')Itinerario_Hora_Llegada,
			XTBL.value('(fechaSalida)[1]', 'DATETIME')Itinerario_Fecha_Salida,
			XTBL.value('(fechaLLegada)[1]', 'DATETIME')Itinerario_Fecha_Llegada,
			XTBL.value('(dias)[1]', 'DECIMAL(3,1)')Itinerario_Dias,
			XTBL.value('(pathBoleto)[1]', 'VARCHAR(250)')Itinerario_Path_Boleto,
			--XTBL.value('(Id_Solicitud)[1]', 'INT')Itinerario_Id_Solicitud,
			XTBL.value('(tipoSalida/idTipoSalida)[1]', 'INT')Itinerario_Id_Tipo_Salida
		INTO #ITINERARIO
		FROM @Solicitud.nodes('SolicitudViatico/itinerario/Itinerario') AS XD(XTBL)
		IF @@ERROR<>0
		BEGIN
			SELECT @Mensaje='Error al procesar XML, apartado de itinerario'
			GOTO ERROR_
		END

		SELECT
			XTBL.value('(descripcion)[1]', 'VARCHAR(100)')Gasto_Extra_Descripcion,
			XTBL.value('(monto)[1]', 'MONEY')Gasto_Extra_Monto
		INTO #GASTO_EXTRA
		FROM @Solicitud.nodes('SolicitudViatico/gastosExtrasSol/GastoExtraSol') AS XD(XTBL)
		IF @@ERROR<>0
		BEGIN
			SELECT @Mensaje='Error al procesar XML, apartado de gastos extras'
			GOTO ERROR_
		END

		--select * from #SOLICITUD
		--select * from #ITINERARIO
		--select * from #GASTO_EXTRA
		--1.-Insertamos la solicitud
		INSERT 
			INTO DT_TBL_VIATICO_SOLICITUD
			(
				Fecha_Alta,
				Fecha_Inicio,
				Fecha_Fin,
				Id_Medio_Transporte,
				Proposito,
				Resultados_Esperados,
				Id_Justificacion,
				Condiciones_Especiales,
				Id_Tipo_Divisa,
				Id_Estatus_Solicitud,
				Em_Cve_Empleado,
				Em_Cve_Empleado_Autoriza,
				Id_Tipo_Viaje
			)
		SELECT
			Solicitud_Fecha_Alta,
			Solicitud_Fecha_Inicio,
			Solicitud_Fecha_Fin,
			Solicitud_Id_Medio_Transporte,
			Solicitud_Proposito,
			Solicitud_Resultados_Esperados,
			Solicitud_Id_Justificacion,
			Solicitud_Condiciones_Especiales,
			case when Solicitud_Id_Tipo_Viaje=1 then 1 else 2 end,
			1,
			Solicitud_Em_Cve_Empleado,
			Solicitud_Em_Cve_Empleado_Autoriza,
			Solicitud_Id_Tipo_Viaje
		FROM #SOLICITUD
		IF @@ERROR<>0
		BEGIN
			SELECT @Mensaje='Error al guardar información, apartado de solicitud'
			GOTO ERROR_
		END


		SELECT @Id_Solicitud_Viatico=MAX(Id_Solicitud) FROM DT_TBL_VIATICO_SOLICITUD

		--2-Se insertan los itinerarios:
		INSERT
			INTO DT_TBL_VIATICO_ITINERARIO
			(
				Origen,
				Destino,
				Id_Medio_Transporte,
				Linea,
				Numero_Asiento,
				Hora_Salida,
				Hora_Llegada,
				Fecha_Salida,
				Fecha_Llegada,
				Dias,
				Path_Boleto,
				Id_Solicitud,
				Id_Tipo_Salida
			)
		SELECT
			Itinerario_Origen,
			Itinerario_Destino,
			Itinerario_Id_Medio_Transporte,
			Itinerario_Linea,
			Itinerario_Numero_Asiento,
			Itinerario_Hora_Salida,
			Itinerario_Hora_Llegada,
			Itinerario_Fecha_Salida,
			Itinerario_Fecha_Llegada,
			Itinerario_Dias,
			Itinerario_Path_Boleto,
			@Id_Solicitud_Viatico,
			Itinerario_Id_Tipo_Salida
		FROM #ITINERARIO
		IF @@ERROR<>0
		BEGIN
			SELECT @Mensaje='Error al guardar información, apartado de itinerario'
			GOTO ERROR_
		END


		INSERT
			INTO DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD
			(
				Descripcion,
				Monto,
				Id_Solicitud
			)
		SELECT
			Gasto_Extra_Descripcion,
			Gasto_Extra_Monto,
			@Id_Solicitud_Viatico
		FROM #GASTO_EXTRA
		IF @@ERROR<>0
		BEGIN
			SELECT @Mensaje='Error al guardar información, apartado de gastos extra'
			GOTO ERROR_
		END
		
		GOTO EXIT_
		
	ERROR_:
		SELECT @Status=0
		GOTO EXIT_

	EXIT_:
		SELECT @Status STATUS, @Mensaje MENSAJE
			
END
GO

GRANT EXECUTE ON DT_SP_INSERTAR_VIATICO_SOLICITUD TO public;  
GO