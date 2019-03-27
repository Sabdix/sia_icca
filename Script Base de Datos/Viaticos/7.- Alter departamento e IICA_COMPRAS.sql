USE [IICA_1]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_INCAPACIDAD]    Script Date: 26/03/2019 10:26:57 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Insertar o actualizar una solicitud de vacaciones>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_ACTUALIZAR_INCAPACIDAD]
	-- Add the parameters for the stored procedure here
		@Id_Incapacidad INT=NULL,
		@Fecha_Inicio DATE=NULL,
		@Fecha_Fin DATE=NULL,
		@Total_Dias INT=NULL,
		@Id_Tipo_Incapacidad INT=NULL,
		@Id_Tipo_Seguimiento INT=NULL,
		@Fecha_Ingreso_Labores DATETIME=NULL,
		@Fecha_Solicitud DATETIME=NULL,
		@Id_Status INT=NULL,
		@Motivo_Rechazo VARCHAR(1000)=NULL,
		@Em_Cve_Empleado varchar(100)=NULL,
		@Formato_Incapacidad varchar(400)=NULL,
		@Formato_Adicional varchar(400)=NULL,
		@Formato_ST7_Calificacion_RT varchar(400)=NULL,
		@Formato_ST7_Alta_RT varchar(400)=NULL,
		@Em_Cve_Empleado_Autoriza varchar(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE 
		@status int=0,
		@mensaje varchar(250)='',
		@proyecto_empleado varchar (10)


	IF(@Id_Incapacidad is null or @Id_Incapacidad=0)
	BEGIN
		
		--0.-VALIDAMOS SI SE ESTA CREANDO COMO SUBSECUENTE, VALIDEMOS QUE EXISTE UNA COMO INICIAL
		IF(@Id_Tipo_Seguimiento=2/*SUBSECUENTE*/)
		BEGIN
			/* NOTA: ESTO SE DEFE DE DEFINIR POR PARTE DE GABI, YA QUE NO SE SI VAN EN PARES */
			IF NOT EXISTS (SELECT 1 FROM DT_TBL_INCAPACIDAD WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Id_Tipo_Incapacidad=1 AND Id_Status_Solicitud=4)
			BEGIN
				SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END
		END

		--1.-Obtenemos la información del proyecto del empleado que esta solicitando las vacaciones
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		IF(@proyecto_empleado is null)
		BEGIN
			SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--2.-Revisamos que exista un autorizador para este proyecto
		
		select @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado

		IF(@Em_Cve_Empleado_Autoriza is null)
		BEGIN
			SET @mensaje='NO EXISTEN AUTORIZADORES PARA EL PROYECTO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--3.-SE TERMINAN LAS VALIDACIONES, PROCEDEMOS A REALIZAR EL INSERT

		INSERT
			INTO DT_TBL_INCAPACIDAD(
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				Id_Tipo_Incapacidad,
				Id_Tipo_Seguimiento,
				Fecha_Ingreso_Labores,
				Fecha_Solicitud,
				Id_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado,
				--Em_Cve_Empleado_Autoriza,
				Formato_Incapacidad,
				Formato_Adicional,
				Formato_ST7_Calificacion_RT,
				Formato_ST7_Alta_RT
			)
			VALUES (
				@Fecha_Inicio,
				@Fecha_Fin,
				@Total_Dias,
				@Id_Tipo_Incapacidad,
				@Id_Tipo_Seguimiento,
				@Fecha_Ingreso_Labores,
				@Fecha_Solicitud,
				4,
				@Motivo_Rechazo,
				@Em_Cve_Empleado,
				--@Em_Cve_Empleado_Autoriza,
				@Formato_Incapacidad,
				@Formato_Adicional,
				@Formato_ST7_Calificacion_RT,
				@Formato_ST7_Alta_RT
			)

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GENERAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'

			GOTO EXIT_
	END
	ELSE
	BEGIN
		--4.- SE TRATA DE UNA ACTUALIZACION DE LA INCAPACIDAD

		--4.1.-SE TRATA DE UNA ACTUALIZACIÓN DE DOCUMENTOS
		--ESTO QUEDA PENDIENTE

		IF @Formato_Incapacidad IS NOT NULL
			UPDATE DT_TBL_INCAPACIDAD SET Formato_Incapacidad=@Formato_Incapacidad WHERE Id_Incapacidad=@Id_Incapacidad
		IF @Formato_Adicional IS NOT NULL
			UPDATE DT_TBL_INCAPACIDAD SET Formato_Adicional=@Formato_Adicional WHERE Id_Incapacidad=@Id_Incapacidad
		IF @Formato_ST7_Calificacion_RT IS NOT NULL
			UPDATE DT_TBL_INCAPACIDAD SET Formato_ST7_Calificacion_RT=@Formato_ST7_Calificacion_RT WHERE Id_Incapacidad=@Id_Incapacidad
		IF @Formato_ST7_Alta_RT IS NOT NULL
			UPDATE DT_TBL_INCAPACIDAD SET Formato_ST7_Alta_RT=@Formato_ST7_Alta_RT WHERE Id_Incapacidad=@Id_Incapacidad

		UPDATE DT_TBL_INCAPACIDAD
		SET Id_Status_Solicitud=@Id_Status,
		Fecha_Actualizacion=GETDATE(),
		Motivo_Rechazo=@Motivo_Rechazo,
		Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
		WHERE Id_Incapacidad=@Id_Incapacidad

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL ACTUALIZAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		SET @status=1
		SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'
		GOTO EXIT_
	END

	Exit_: SELECT @status STATUS, @mensaje MENSAJE, @Id_Incapacidad ID_INCAPACIDAD
END



/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_PERMISO]    Script Date: 26/03/2019 10:55:01 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Insertar o actualizar una solicitud de permiso>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_ACTUALIZAR_PERMISO]
	-- Add the parameters for the stored procedure here
		@Id_Permiso INT=NULL,
		@Fecha_Permiso DATE=NULL,
		@Hora_inicio varchar(10)=NULL,
		@Hora_fin varchar(10)=NULL,
		@Total_Horas DECIMAL (10,2)=NULL,
		@Motivo_Permiso VARCHAR(1000)=NULL,
		@Id_Status_Solicitud INT=NULL,
		@Motivo_Rechazo VARCHAR(1000)=NULL,
		@Em_Cve_Empleado varchar(100)=NULL,
		@Em_Cve_Empleado_Autoriza varchar(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE 
		@status int=0,
		@mensaje varchar(250)='',
		@proyecto_empleado varchar (10)


	IF(@Id_Permiso is null or @Id_Permiso=0)
	BEGIN

		--1.-Obtenemos la información del proyecto del empleado que esta generando el permiso
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		IF(@proyecto_empleado is null)
		BEGIN
			SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--2.-Revisamos que exista un autorizador para este proyecto
		
		select @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado

		IF(@Em_Cve_Empleado_Autoriza is null)
		BEGIN
			SET @mensaje='NO EXISTEN AUTORIZADORES PARA EL PROYECTO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--3.-SE TERMINAN LAS VALIDACIONES, PROCEDEMOS A REALIZAR EL INSERT

		INSERT
			INTO DT_TBL_PERMISO(
				Fecha_Permiso,
				Hora_inicio,
				Hora_fin,
				Total_Horas,
				Motivo_Permiso,
				Fecha_Alta,
				Id_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado
				--,Em_Cve_Empleado_Autoriza
			)
			VALUES (
				@Fecha_Permiso,
				@Hora_inicio,
				@Hora_fin,
				@Total_Horas,
				@Motivo_Permiso,
				GETDATE(),
				1,
				'',
				@Em_Cve_Empleado
				--,@Em_Cve_Empleado_Autoriza
			)

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GENERAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SELECT @Id_Permiso=MAX(Id_Permiso)
			FROM DT_TBL_PERMISO
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado

			SET @status=1
			SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'

			GOTO EXIT_
	END
	ELSE
	BEGIN
		--4.- SE TRATA DE UNA ACTUALIZACION DE LA SOLICITUD
		UPDATE DT_TBL_PERMISO
		SET Id_Status_Solicitud=@Id_Status_Solicitud,
		Fecha_Actualizacion=GETDATE(),
		Motivo_Rechazo=@Motivo_Rechazo,
		Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
		WHERE Id_Permiso=@Id_Permiso

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL ACTUALZIAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		SET @status=1
		SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'
		GOTO EXIT_
	END

	Exit_: SELECT @status STATUS, @mensaje MENSAJE, coalesce(@Id_Permiso,0) ID_PERMISO
END



/****** Object:  StoredProcedure [dbo].[DT_SP_CONSULTAR_AUTORIZADORES_PROYECTO]    Script Date: 26/03/2019 10:58:08 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_CONSULTAR_AUTORIZADORES_PROYECTO]
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE
		@proyecto_empleado varchar(500)

    -- Insert statements for procedure here

	--1.-Obtenemos la información del proyecto del empleado que esta generando el permiso
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		select *
		from Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado

END



/****** Object:  StoredProcedure [dbo].[DT_SP_CONSULTAR_SOLICITUDES_POR_AUTORIZAR]    Script Date: 26/03/2019 11:02:10 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Autor			EDSON PEÑA	
--Fecha			20190319
--Objetivo		OBTIENE LA LISTA DE LAS SOLICITUDES POR AUTORIZAR
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_CONSULTAR_SOLICITUDES_POR_AUTORIZAR]
	@Em_Cve_Empleado varchar(20)
AS
BEGIN


	select distinct
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
		COALESCE(NULL,c.De_Descripcion ,'SIN DEPARTAMENTO') Departamento
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
		join Viaticos_Autorizadores autorizadores on autorizadores.aut_proyecto = s.Sc_UserDef_2
	where 
		vs.Id_etapa_solicitud = 2
		and vs.Id_estatus_solicitud <> 3
		and autorizadores.Em_Cve_Empleado = @Em_Cve_Empleado

END



/****** Object:  StoredProcedure [dbo].[DT_SP_INICIAR_SESION]    Script Date: 26/03/2019 11:02:52 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_INICIAR_SESION]
	-- Add the parameters for the stored procedure here
	@Numero_Usuario VARCHAR(100),
	@Password VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE
		@Status int=0,
		@Mensaje varchar(500)='OK',
		@Id_Tipo_Usuario int=0,
		@Rol_Usuario varchar(100),
		@Query nvarchar(max)


    -- Insert statements for procedure here

	IF @Numero_Usuario='ADMIN' AND @Password='ADMIN'
	BEGIN
		SET @Status=1
		SET @Id_Tipo_Usuario=1
		SET @Rol_Usuario='ADMINISTRADOR'

		set @Query='
		SELECT '+
			CONVERT(varchar,@Status)+' STATUS,'''+
			@Mensaje+''' MENSAJE,'+
			CONVERT(varchar,@Id_Tipo_Usuario)+' Id_Tipo_Usuario,'''+
			@Rol_Usuario+''' Rol_Usuario,'+'
			''Administrador'' Em_nombre,
			''Administrador'' Em_Apellido_Paterno,
			''Administrador'' Em_Apellido_Materno,
			''SIN PROGRAMA'' Programa,
			''SIN DEPARTAMENTO'' Departamento'
		GOTO Exit_
	END

	IF NOT EXISTS(SELECT 1 FROM Empleado WHERE Em_UserDef_1=@Numero_Usuario and Em_UserDef_2=@Password)
	BEGIN
		SET @Mensaje='EL USUARIO O LA CONTRASEÑA SON INCORRECTAS.'
		set @Query='
		SELECT '+
			CONVERT(varchar,@Status)+' STATUS,'''+
			@Mensaje+''' MENSAJE'
		GOTO Exit_
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 1 FROM Viaticos_Autorizadores WHERE Em_UserDef_1=@Numero_Usuario)
		BEGIN
			SET @Status=1
			SET @Id_Tipo_Usuario=3--usuario autorizador
			SET @Rol_Usuario='AUTORIZADOR'

			set @Query='
			SELECT '+
				CONVERT(varchar,@Status)+' STATUS,'''+
				@Mensaje+''' MENSAJE,'+
				CONVERT(varchar,@Id_Tipo_Usuario)+' Id_Tipo_Usuario,'''+
				@Rol_Usuario+''' Rol_Usuario,'+'
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,''SIN DEPARTAMENTO'') Departamento
			FROM Empleado a
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
			WHERE Em_UserDef_1='''+@Numero_Usuario +''' and Em_UserDef_2='''+@Password+''''
			GOTO Exit_
		END
		ELSE
		BEGIN
			SET @Status=1
			SET @Id_Tipo_Usuario=2--usuario empleado
			SET @Rol_Usuario='EMPLEADO'

			set @Query='
			SELECT '+
				CONVERT(varchar,@Status)+' STATUS,'''+
				@Mensaje+''' MENSAJE,'+
				CONVERT(varchar,@Id_Tipo_Usuario)+' Id_Tipo_Usuario,'''+
				@Rol_Usuario+''' Rol_Usuario,'+'
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,''SIN DEPARTAMENTO'') Departamento
			FROM Empleado a
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
			WHERE Em_UserDef_1='''+@Numero_Usuario +''' and Em_UserDef_2='''+@Password+''''
			GOTO Exit_
		END
	END

	Exit_:
			print(@Query)
			EXEC SP_EXECUTESQL @Query

END



/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_INCAPACIDADES_USUARIO]    Script Date: 26/03/2019 11:08:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_INCAPACIDADES_USUARIO]
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(100)=NULL,
	@Em_Cve_Empleado_Autoriza VARCHAR(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@query nvarchar(max)

	IF (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza='') 
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza='')
		select 0 STATUS, 'ERROR, NÚMERO DE PARAMETROS INCORRECTO' MENSAJE
	ELSE
	BEGIN
		IF @Em_Cve_Empleado IS NOT NULL
		BEGIN
			select
				1 STATUS,
				'' MENSAJE,
				Id_Incapacidad,
				Fecha_Ingreso_Labores,
				Fecha_Solicitud,
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				a.Id_Status_Solicitud,
				b.Descripcion_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado,
				Em_Cve_Empleado_Autoriza,
				COALESCE(Fecha_Actualizacion,'') Fecha_Revision,
				a.Id_Tipo_Seguimiento,
				d.Descripcion_Tipo_Seguimiento,
				a.Id_Tipo_Incapacidad,
				c.Descripcion_Tipo_Incapacidad
			from
				DT_TBL_INCAPACIDAD a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			join DT_CAT_TIPO_INCAPACIDAD c on a.Id_Tipo_Incapacidad=c.Id_Tipo_Incapacidad
			join DT_CAT_TIPO_SEGUIMIENTO d on a.Id_Tipo_Seguimiento=d.Id_Tipo_Seguimiento
			WHERE a.Em_Cve_Empleado=@Em_Cve_Empleado
		END
		IF @Em_Cve_Empleado_Autoriza IS NOT NULL
		BEGIN
			select
				d.Id_Incapacidad,
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
				CONVERT (VARCHAR,d.Fecha_Solicitud,103)Fecha_Alta,
				d.Id_Tipo_Incapacidad,
				CONVERT (VARCHAR,d.Fecha_Inicio,103)Fecha_Inicio,
				CONVERT (VARCHAR,d.Fecha_Fin,103)Fecha_Fin,
				d.Total_Dias,
				CONVERT (VARCHAR,DATEADD(DD,1,d.Fecha_Fin),103) Reanudar_Labores,
				d.Motivo_Rechazo,
				d.Id_Tipo_Seguimiento,
				-----------ACTUALIZACION PARA MOSTRAR LOS FORMATOS	---------------
				d.Formato_Incapacidad,
				d.Formato_Adicional,
				d.Formato_ST7_Alta_RT,
				d.Formato_ST7_Calificacion_RT
			from Empleado a
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
			INNER JOIN DT_TBL_INCAPACIDAD d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END



/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_PERMISOS_USUARIO]    Script Date: 26/03/2019 11:09:38 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_PERMISOS_USUARIO]
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(100)=NULL,
	@Em_Cve_Empleado_Autoriza VARCHAR(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@query nvarchar(max),
		@Proyecto_Empleado_Autoriza varchar(10)

	IF (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza='') 
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza='')
		select 0 STATUS, 'ERROR, NÚMERO DE PARAMETROS INCORRECTO' MENSAJE
	ELSE
	BEGIN
		IF @Em_Cve_Empleado IS NOT NULL
		BEGIN
			select
				1 STATUS,
				'' MENSAJE,
				Id_Permiso,
				Fecha_Permiso,
				Hora_inicio,
				Hora_fin,
				Total_Horas,
				Motivo_Permiso,
				a.Fecha_Alta,
				a.Id_Status_Solicitud,
				b.Descripcion_Status_Solicitud,
				Motivo_Rechazo,
				COALESCE(Fecha_Actualizacion,'') Fecha_Revision
			from
				DT_TBL_PERMISO a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			WHERE a.Em_Cve_Empleado=@Em_Cve_Empleado
		END
		IF @Em_Cve_Empleado_Autoriza IS NOT NULL
		BEGIN

			select
				d.Id_Permiso,
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
				CONVERT (VARCHAR,d.Fecha_Permiso,103)Fecha_Permiso,
				CONVERT (VARCHAR,d.Fecha_Alta,103)Fecha_Alta,
				d.Hora_Inicio,
				d.Hora_Fin,
				d.Total_Horas,
				d.Motivo_Permiso
			from Empleado a
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
			INNER JOIN DT_TBL_PERMISO d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END




/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_VACACIONES_USUARIO]    Script Date: 26/03/2019 11:10:26 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<COnsultar los registros segun el usuario>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_VACACIONES_USUARIO]
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(100)=NULL,
	@Em_Cve_Empleado_Autoriza VARCHAR(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@query nvarchar(max)

	IF (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado IS NOT NULL AND @Em_Cve_Empleado_Autoriza='') 
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza IS NOT NULL)
	 OR (@Em_Cve_Empleado='' AND @Em_Cve_Empleado_Autoriza='')
		select 0 STATUS, 'ERROR, NÚMERO DE PARAMETROS INCORRECTO' MENSAJE
	ELSE
	BEGIN
		IF @Em_Cve_Empleado IS NOT NULL
		BEGIN
			select
				1 STATUS,
				'' MENSAJE,
				Id_Vacaciones,
				Periodo_Anterior,
				Proporcional,
				Total_Dias_Saldo_Vacacional,
				Fecha_Solicitud,
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				Motivo_Vacaciones,
				a.Id_Status_Solicitud,
				b.Descripcion_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado,
				Em_Cve_Empleado_Autoriza,
				COALESCE(Fecha_Actualizacion,'') Fecha_Revision
			from
				DT_TBL_VACACIONES a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			WHERE a.Em_Cve_Empleado=@Em_Cve_Empleado
		END
		IF @Em_Cve_Empleado_Autoriza IS NOT NULL
		BEGIN
			select
				d.Id_Vacaciones,
				Em_nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
				b.Sc_Descripcion Programa,
				COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
				CONVERT (VARCHAR,d.Fecha_Solicitud,103)Fecha_Alta,
				d.Total_Dias_Saldo_Vacacional,
				CONVERT (VARCHAR,d.Fecha_Inicio,103)Fecha_Inicio,
				CONVERT (VARCHAR,DATEADD(DD,-1,d.Fecha_Fin),103)Fecha_Fin,
				d.Total_Dias,
				CONVERT (VARCHAR,d.Fecha_Fin,103) Reanudar_Labores,
				d.Motivo_Vacaciones
			from Empleado a
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
			INNER JOIN DT_TBL_VACACIONES d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END


/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2017 (14.0.2002)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_VACACIONES]    Script Date: 26/03/2019 11:35:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Insertar o actualizar una solicitud de vacaciones>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_ACTUALIZAR_VACACIONES]
	-- Add the parameters for the stored procedure here
		@Id_Vacaciones INT=null,
		@Periodo_Anterior INT=null,
		@Proporcional INT=null,
		@Total_Dias_Saldo_Vacacional INT=null,
		@Fecha_Solicitud DATETIME=null,
		@Fecha_Inicio DATE=null,
		@Fecha_Fin DATE=null,
		@Total_Dias INT=null,
		@Motivo_Vacaciones VARCHAR(1000)=null,
		@Id_Status_Solicitud INT=null,
		@Motivo_Rechazo VARCHAR(1000)=null,
		@Em_Cve_Empleado varchar(100)=null,
		@Em_Cve_Empleado_Autoriza varchar(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE 
		@status int=0,
		@mensaje varchar(250)='',
		@proyecto_empleado varchar (10),
		@Total_Dias_Solicitud INT,
		@Saldo_Periodo_Anterior_Usado INT,
		@Saldo_Proporcional_Actual_Usado INT,
		@Saldo_Periodo_Anterior INT,
		@Saldo_Proporcional_Actual INT,
		@Saldo_Actual_Disponible INT


	IF(@Id_Vacaciones is null or @Id_Vacaciones=0)
	BEGIN

		--1.-Obtenemos la información del proyecto del empleado que esta solicitando las vacaciones
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		IF(@proyecto_empleado is null)
		BEGIN
			SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--2.-Revisamos que exista un autorizador para este proyecto
		
		select @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado

		IF(@Em_Cve_Empleado_Autoriza is null)
		BEGIN
			SET @mensaje='NO EXISTEN AUTORIZADORES PARA EL PROYECTO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END
		--Se valida el saldo vacacional
		IF @Total_Dias>(SELECT (Saldo_Periodo_Anterior -  Saldo_Periodo_Anterior_Usado)+(Saldo_Proporcional_Actual-Saldo_Proporcional_Actual_Usado) FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Activo=1)
		BEGIN
			SET @mensaje='SU SALDO VACACIONAL ES MENOR A LOS DÍAS SOLICITADOS, CONTACTE A UN ADMINISTRADOR.'
			GOTO EXIT_
		END

		--3.-SE TERMINAN LAS VALIDACIONES, PROCEDEMOS A REALIZAR EL INSERT

		INSERT
			INTO DT_TBL_VACACIONES(
				Periodo_Anterior,
				Proporcional,
				Total_Dias_Saldo_Vacacional,
				Fecha_Solicitud,
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				Motivo_Vacaciones,
				Id_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado
				--,Em_Cve_Empleado_Autoriza
			)
			VALUES (
				@Periodo_Anterior,
				@Proporcional,
				@Total_Dias_Saldo_Vacacional,
				@Fecha_Solicitud,
				@Fecha_Inicio,
				@Fecha_Fin,
				@Total_Dias,
				@Motivo_Vacaciones,
				1,
				'',
				@Em_Cve_Empleado
				--,@Em_Cve_Empleado_Autoriza
			)

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GENERAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			/**/
			
			SELECT
				@Saldo_Periodo_Anterior=Saldo_Periodo_Anterior,
				@Saldo_Actual_Disponible=Saldo_Actual_Disponible,
				@Saldo_Periodo_Anterior_Usado=Saldo_Proporcional_Actual_Usado,
				@Saldo_Proporcional_Actual=Saldo_Proporcional_Actual
			FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado
			AND Activo=1
			
			IF @Saldo_Periodo_Anterior>=@Total_Dias
				SET @Saldo_Periodo_Anterior=@Saldo_Periodo_Anterior-@Total_Dias
			ELSE
				SET @Saldo_Periodo_Anterior=0

			SET @Saldo_Actual_Disponible=@Saldo_Actual_Disponible-@Total_Dias

			UPDATE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			SET Saldo_Actual_Utilizado=Saldo_Actual_Utilizado+@Total_Dias,
			Saldo_Periodo_Anterior=@Saldo_Periodo_Anterior,
			Saldo_Actual_Disponible=@Saldo_Actual_Disponible,
			Saldo_Proporcional_Actual_Usado=Saldo_Proporcional_Actual_Usado+@Total_Dias
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado
			/**/

			SELECT @Id_Vacaciones=MAX(Id_Vacaciones)
			FROM DT_TBL_VACACIONES
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado

			UPDATE DT_TBL_VACACIONES
			SET Periodo_Anterior=@Saldo_Periodo_Anterior,
			Proporcional=@Saldo_Proporcional_Actual,
			Total_Dias_Saldo_Vacacional=@Saldo_Actual_Disponible
			WHERE Id_Vacaciones=@Id_Vacaciones

			SET @status=1
			SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'

			GOTO EXIT_
	END
	ELSE
	BEGIN
		--4.- SE TRATA DE UNA ACTUALIZACION DE LAS VACACIONES

		UPDATE DT_TBL_VACACIONES
		SET Id_Status_Solicitud=@Id_Status_Solicitud,
		Fecha_Actualizacion=GETDATE(),
		Motivo_Rechazo=@Motivo_Rechazo,
		Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
		WHERE Id_Vacaciones=@Id_Vacaciones

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL ACTUALIZAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END
				
		--4.1 SE CANCELA LA SOLICITUD
		IF @Id_Status_Solicitud=3
		BEGIN

			SELECT @Total_Dias=Total_Dias,@Em_Cve_Empleado=Em_Cve_Empleado FROM DT_TBL_VACACIONES WHERE Id_Vacaciones=@Id_Vacaciones

			SELECT 
				@Saldo_Periodo_Anterior=Saldo_Periodo_Anterior,
				@Saldo_Periodo_Anterior_Usado=Saldo_Periodo_Anterior_Usado,
				@Saldo_Proporcional_Actual=Saldo_Proporcional_Actual,
				@Saldo_Proporcional_Actual_Usado=Saldo_Proporcional_Actual_Usado
			FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado

			IF @Total_Dias<=@Saldo_Proporcional_Actual_Usado
				SET @Saldo_Proporcional_Actual_Usado=@Saldo_Proporcional_Actual_Usado-@Total_Dias
			ELSE
			BEGIN
				SET @Saldo_Periodo_Anterior_Usado=(@Saldo_Periodo_Anterior_Usado+@Saldo_Proporcional_Actual_Usado)-@Total_Dias
				SET @Saldo_Proporcional_Actual_Usado=0
			END

			UPDATE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			SET Saldo_Actual_Utilizado=Saldo_Actual_Utilizado-@Total_Dias,
			Saldo_Actual_Disponible=Saldo_Actual_Disponible+@Total_Dias,
			Saldo_Periodo_Anterior_Usado=@Saldo_Periodo_Anterior_Usado,
			Saldo_Proporcional_Actual_Usado=@Saldo_Proporcional_Actual_Usado
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado
			AND Activo=1

		END


		SET @status=1
		SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'
		GOTO EXIT_
	END

	Exit_: SELECT @status STATUS, @mensaje MENSAJE, coalesce(@Id_Vacaciones,0) ID_VACACIONES
END

