USE [DB_A0966E_iica]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_CONSULTAR_SOLICITUDES_PARA_CREAR_CHEQUE]    Script Date: 16/04/2019 06:33:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Autor			PICHARDO
--Fecha			20190322
--Objetivo		OBTIENE LA LISTA DE LAS SOLICITUDES PARA CREAR CHEQUE
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_CONSULTAR_SOLICITUDES_PARA_CREAR_CHEQUE]
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
		,(select sum(monto) from DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD where id_solicitud=vs.id_solicitud) gastos_extras
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
