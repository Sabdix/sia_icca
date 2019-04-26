USE [DB_A0966E_iica]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_CONSULTAR_HISTORIAL_SOLICITUDES_USUARIO]    Script Date: 23/04/2019 09:19:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

Autor			PICHARDO HURTADO OSCAR
Fecha			20190319
Objetivo		


*/

ALTER proc [dbo].[DT_SP_CONSULTAR_HISTORIAL_SOLICITUDES_USUARIO]

	@Em_Cve_Empleado varchar(20)
	,@id_rol_usuario int
		-- parametros
		-- [aquí van los parámetros]

as

	begin -- procedimiento
	if @id_rol_usuario=3
	begin
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
	,coalesce(emp.Em_Nombre,'')Em_Nombre
	,coalesce(emp.Em_Apellido_Paterno,'')Em_Apellido_Paterno
	,coalesce(emp.Em_Apellido_Materno,'') Em_Apellido_Materno
	,Em_Email
	,c.Sc_Descripcion proyecto
	,case 
	when vs.marginal = 0 then 1
	when vs.marginal = 1 and COALESCE(
		(select top 1 1 from DT_TBL_VIATICO_GASTO_EXTRA_SOLICITUD where Id_Solicitud = vs.Id_Solicitud),0) =1 then 1
	else 0
	end realizar_comprobacion_gastos,
	COALESCE((select top 1 1 from DT_TBL_VIATICO_ITINERARIO where Id_Solicitud = vs.Id_Solicitud and  Id_Medio_Transporte=2),0) comprobar_itinerario_aereo
from DT_TBL_VIATICO_SOLICITUD vs
join Empleado emp
on vs.Em_Cve_Empleado=emp.Em_Cve_Empleado
left join Sucursal c
on emp.Sc_Cve_Sucursal=c.Sc_Cve_Sucursal
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
where Sc_UserDef_2 in (select Proyecto from DT_TBL_USUARIOS_AUTORIZADORES where Id_Rol_Usuario=3 and Proyecto=c.Sc_UserDef_2 and em_cve_empleado=@Em_Cve_Empleado)
	end
	else
	begin
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
					,c.Sc_Descripcion proyecto
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
					join Empleado emp
					on vs.Em_Cve_Empleado=emp.Em_Cve_Empleado
					left join Sucursal c
					on emp.Sc_Cve_Sucursal=c.Sc_Cve_Sucursal
				where  
					vs.Em_Cve_Empleado=
					case when @id_rol_usuario = 5 then vs.Em_Cve_Empleado 
					else @Em_Cve_Empleado end 
	end
	end -- procedimiento
	


