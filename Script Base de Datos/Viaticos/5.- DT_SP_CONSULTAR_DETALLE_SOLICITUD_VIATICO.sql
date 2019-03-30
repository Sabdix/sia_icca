USE IICA_1
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTAR_DETALLE_SOLICITUD_VIATICO')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTAR_DETALLE_SOLICITUD_VIATICO
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Autor			EDSON PEÑA	
--Fecha			20190319
--Objetivo		OBTIENE EL DETALLE DE UNA SOLICITUD
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTAR_DETALLE_SOLICITUD_VIATICO
	@Id_solicitud varchar(20)
AS
BEGIN
	
	DECLARE
		@Aplica_Reintegro INT=0
			
	IF NOT EXISTS (SELECT * FROM DT_TBL_VIATICO_SOLICITUD WHERE Id_Solicitud=@Id_solicitud)
	BEGIN 
		SELECT 0 status, 'La solicitud que intenta consultar no existe' as mensaje
	END
	ELSE
	BEGIN
		
		--Se define si aplica el reintegro o no para una solicitud

		
		IF EXISTS (SELECT 1 FROM DT_TBL_VIATICO_SOLICITUD WHERE Id_Solicitud=@Id_solicitud AND Id_Etapa_Solicitud>=4)
		BEGIN

			IF (SELECT Marginal FROM DT_TBL_VIATICO_SOLICITUD WHERE Id_Solicitud=@Id_solicitud)=1
			BEGIN
				IF (SELECT SUM(Monto) FROM DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD WHERE Id_Solicitud=@Id_solicitud)>=(SELECT SUM(Total) FROM DT_TBL_VIATICO_COMPROBACION_GASTOS WHERE Id_Solicitud=@Id_solicitud)
					SET @Aplica_Reintegro=0
				ELSE
					SET @Aplica_Reintegro=1
			END
			ELSE
			BEGIN
				IF( (SELECT (Tarifa_de_Ida+Tarifa_de_Vuelta)+((Tarifa_de_Ida+Tarifa_de_Vuelta)*.1) FROM DT_TBL_VIATICO_SOLICITUD WHERE Id_Solicitud=@Id_solicitud)+(SELECT SUM(Monto) FROM DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD WHERE Id_Solicitud=@Id_solicitud) )>=(SELECT SUM(Total) FROM DT_TBL_VIATICO_COMPROBACION_GASTOS WHERE Id_Solicitud=@Id_solicitud)
					SET @Aplica_Reintegro=0
				ELSE
					SET @Aplica_Reintegro=1
			END

		END

		select 
			1 as status,
			'Solicitud encontra' mensaje,
			vs.*
			,mt.Descripcion medio_transporte
			,j.Descripcion justificacion
			,td.Descripcion tipo_divisa
			,etapa.Id_etapa_solicitud
			,etapa.Descripcion desc_etapa
			,es.Id_estatus_solicitud
			,es.Descripcion desc_estatus
			,tv.Descripcion tipo_viaje,
			em.Em_nombre,
			em.Em_Apellido_Paterno,
			em.Em_Apellido_Materno,
			CONVERT (VARCHAR,em.Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
			em.Em_Email,
			s.Sc_Descripcion Programa,
			COALESCE(NULL,c.De_Descripcion ,'SIN DEPARTAMENTO') Departamento,
			autorizador.Em_nombre Em_nombre_Autorizador,
			autorizador.Em_Apellido_Paterno Em_Apellido_Paterno_autorizador,
			autorizador.Em_Apellido_Materno Em_Apellido_Materno_autorizador,
			pe.Pe_Descripcion puesto_empleado,
			pea.Pe_Descripcion puesto_autorizador,
			@Aplica_Reintegro Aplica_Reintegro,
			case 
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
			LEFT JOIN Departamento_Empleado c ON em.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
			left join empleado autorizador on vs.em_cve_empleado_autoriza=autorizador.Em_UserDef_1
			left join Puesto_Empleado pe on em.pe_cve_puesto_empleado=pe.Pe_Cve_Puesto_Empleado
			left join Puesto_Empleado pea on autorizador.pe_cve_puesto_empleado=pea.Pe_Cve_Puesto_Empleado
		where 
			vs.Id_Solicitud = @Id_solicitud
	
		-------------itinerario-------------
		select 
			iti.* ,
			medio.Descripcion medio_transporte,
			tSalida.Descripcion tipo_salida
		from DT_TBL_VIATICO_ITINERARIO iti
		inner join 
			DT_CAT_MEDIO_TRANSPORTE medio on iti.Id_Medio_Transporte = medio.Id_Medio_Transporte
		inner join 
			DT_CAT_TIPO_SALIDA tSalida on iti.Id_Tipo_Salida= tSalida.Id_Tipo_Salida
		where Id_Solicitud = @Id_solicitud
	
		-------------gastos extras-------------
		select * from DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD 
		where
			Id_Solicitud = @Id_solicitud

		-------------comprobaciones-------------
		SELECT 
			cg.*,
			catGC.Descripcion gasto_comprobacion
		FROM 
			DT_TBL_VIATICO_COMPROBACION_GASTOS cg
		inner join 
			DT_CAT_GASTO_COMPROBACION catGC on cg.Id_Gasto_Comprobacion = catGC.Id_Gasto_Comprobacion
		WHERE Id_Solicitud=@Id_Solicitud

	END

END
GO

GRANT EXECUTE ON DT_SP_CONSULTAR_DETALLE_SOLICITUD_VIATICO TO public;  
GO
