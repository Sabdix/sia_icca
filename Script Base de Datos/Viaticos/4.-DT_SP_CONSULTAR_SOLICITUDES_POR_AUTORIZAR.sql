IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTAR_SOLICITUDES_POR_AUTORIZAR')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTAR_SOLICITUDES_POR_AUTORIZAR
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Autor			EDSON PEÑA	
--Fecha			20190319
--Objetivo		OBTIENE LA LISTA DE LAS SOLICITUDES POR AUTORIZAR
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTAR_SOLICITUDES_POR_AUTORIZAR
	@Em_Cve_Empleado varchar(20)
AS
BEGIN
	
	DECLARE 
		@aut_proyecto varchar(10)

	SELECT @aut_proyecto =aut_proyecto FROM IICA_COMPRAS..Viaticos_Autorizadores
	WHERE
		Em_UserDef_1= @Em_Cve_Empleado

	select Sc_UserDef_2,
	vs.*
		,mt.Descripcion medio_transporte
		,j.Descripcion justificacion
		,td.Descripcion tipo_divisa
		,etapa.Id_etapa_solicitud
		,etapa.Descripcion desc_etapa
		,es.Id_estatus_solicitud
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
		join Empleado em on vs.Em_Cve_Empleado = em.Em_UserDef_1
		join Sucursal s on s.Sc_Cve_Sucursal = em.Sc_Cve_Sucursal
	where 
		s.Sc_UserDef_2 = @aut_proyecto 
		and vs.Id_etapa_solicitud = 2
		and vs.Id_estatus_solicitud <> 3

END
GO

GRANT EXECUTE ON DT_SP_CONSULTAR_SOLICITUDES_POR_AUTORIZAR TO public;  
GO