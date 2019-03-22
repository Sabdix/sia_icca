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
		@aut_proyecto varchar(10)

	select 
		vs.*
		,mt.Descripcion medio_transporte
		,j.Descripcion justificacion
		,td.Descripcion tipo_divisa
		,es.Descripcion desc_estatus
		,es.Descripcion desc_estatus
		,tv.Descripcion tipo_viaje
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
	where 
		vs.Id_Solicitud = @Id_solicitud
	

	select * from DT_TBL_VIATICO_ITINERARIO
	where Id_Solicitud = @Id_solicitud

	select * from DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD 
	where
		Id_Solicitud = @Id_solicitud

END
GO

GRANT EXECUTE ON DT_SP_CONSULTAR_DETALLE_SOLICITUD_VIATICO TO public;  
GO


select * from DT_TBL_VIATICO_SOLICITUD



