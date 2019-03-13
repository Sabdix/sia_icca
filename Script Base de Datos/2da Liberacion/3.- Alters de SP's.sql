USE [IICA_1]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_INCAPACIDADES_USUARIO]    Script Date: 05/03/2019 05:27:15 p. m. ******/
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
			--LEFT JOIN IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			--LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			INNER JOIN DT_TBL_INCAPACIDAD d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from IICA_COMPRAS.dbo.Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END


/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_FORMATO_INCAPACIDAD]    Script Date: 09/03/2019 05:29:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Edson Peña>
-- Description:	<Actualizar el path de un formato en particular de una solicitud de incapacidad>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_ACTUALIZAR_FORMATO_INCAPACIDAD]
	-- Add the parameters for the stored procedure here
		@Id_Incapacidad int,
		@path_formato varchar(200),
		@tipo_formato int
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


	IF exists (select * from DT_TBL_INCAPACIDAD where Id_Incapacidad = @Id_Incapacidad)
	BEGIN
		IF @tipo_formato = 1
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_Incapacidad=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO DE INCAPACIDAD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='FORMATO GUARDADO CON ÉXITO.'

			GOTO EXIT_
		END

		IF @tipo_formato = 2
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_Adicional=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO ADICIONAL, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='FORMATO GUARDADO CON ÉXITO.'

			GOTO EXIT_
		END


		IF @tipo_formato = 3
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_ST7_Calificacion_RT=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO ST7 CALIFICACION RT, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='FORMATO GUARDADO CON ÉXITO.'

			GOTO EXIT_
		END


		IF @tipo_formato = 4
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_ST7_Alta_RT=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO ST7 ALTA RT, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='FORMATO GUARDADO CON ÉXITO.'

			GOTO EXIT_
		END
			
	END
	ELSE
	BEGIN
		SET @status=0
		SET @mensaje='NO EXISTE LA SOLICITUD.'
		GOTO EXIT_
	END

	Exit_: SELECT @status STATUS, @mensaje MENSAJE
END


/****** Object:  StoredProcedure [dbo].[DT_SP_INICIAR_SESION]    Script Date: 04/03/2019 09:16:21 p.m. ******/
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
		IF EXISTS(SELECT 1 FROM IICA_COMPRAS.dbo.Viaticos_Autorizadores WHERE Em_UserDef_1=@Numero_Usuario)
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
			LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
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
			LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			WHERE Em_UserDef_1='''+@Numero_Usuario +''' and Em_UserDef_2='''+@Password+''''
			GOTO Exit_
		END
	END

	Exit_:
			print(@Query)
			EXEC SP_EXECUTESQL @Query

END


/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO]    Script Date: 09/03/2019 03:45:27 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Devuelve la información para armar el formato del permiso>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO]
	-- Add the parameters for the stored procedure here
	@Id_Permiso int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		Em_nombre,
		Em_Apellido_Paterno,
		Em_Apellido_Materno,
		CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
		b.Sc_UserDef_2,
		b.Sc_Descripcion Programa,
		COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
		CONVERT (VARCHAR,d.Fecha_Permiso,103)Fecha_Permiso,
		CONVERT (VARCHAR,d.Fecha_Alta,103)Fecha_Alta,
		d.Hora_Inicio,
		d.Hora_Fin,
		d.Total_Horas,
		d.Hora_Fin Hora_Raunuda_Labores,
		d.Motivo_Permiso
	from Empleado a
	left join Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
	LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
	INNER JOIN DT_TBL_PERMISO d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
	WHERE Id_Permiso=@Id_Permiso


END


/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_INFORMACION_FORMATO_VACACIONES]    Script Date: 09/03/2019 03:46:56 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Devuelve la información para armar el formato de las vacaciones>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_INFORMACION_FORMATO_VACACIONES]
	-- Add the parameters for the stored procedure here
	@Id_Vacaciones int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		Em_nombre,
		Em_Apellido_Paterno,
		Em_Apellido_Materno,
		CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
		b.Sc_UserDef_2,
		b.Sc_Descripcion Programa,
		COALESCE(NULL,c.Dp_Descripcion,'SIN DEPARTAMENTO') Departamento,
		CONVERT (VARCHAR,d.Fecha_Solicitud,103)Fecha_Alta,
		d.Total_Dias_Saldo_Vacacional,
		CONVERT (VARCHAR,d.Fecha_Inicio,103)Fecha_Inicio,
		CONVERT (VARCHAR,DATEADD(DD,-1,d.Fecha_Fin),103) Fecha_Fin,
		d.Total_Dias,
		CONVERT (VARCHAR,d.Fecha_Fin,103) reanudar_labores,
		d.Motivo_Vacaciones
	from Empleado a
	left join Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
	LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
	INNER JOIN DT_TBL_VACACIONES d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
	WHERE Id_Vacaciones=@Id_Vacaciones
	
END


/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_SALDO_VACACIONAL]    Script Date: 09/03/2019 05:29:56 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_SALDO_VACACIONAL]
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		Fecha_Inicio_Periodo,
		Fecha_Fin_Periodo,
		Saldo_Periodo_Anterior,
		Saldo_Proporcional_Actual,
		Saldo_Actual_Disponible ,
		Saldo_Actual_Utilizado,
		Saldo_Correspondiente
	FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO
	WHERE Em_Cve_Empleado=@Em_Cve_Empleado
	AND Activo=1


END


/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_VACACIONES]    Script Date: 09/03/2019 05:50:16 p.m. ******/
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
		from IICA_COMPRAS.dbo.Viaticos_Autorizadores
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


/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_VACACIONES_USUARIO]    Script Date: 09/03/2019 06:26:30 p.m. ******/
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
			--LEFT JOIN IICA_COMPRAS.dbo.Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			--LEFT JOIN IICA_COMPRAS.dbo.Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
			LEFT JOIN Departamento c ON a.De_Cve_Departamento_Empleado=c.Dp_Cve_Departamento
			INNER JOIN DT_TBL_VACACIONES d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
			--WHERE d.Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
			WHERE b.Sc_UserDef_2 IN (
				select aut_proyecto
				from IICA_COMPRAS.dbo.Viaticos_Autorizadores
				where Em_Cve_Empleado=@Em_Cve_Empleado_Autoriza
				and aut_nivel='D'
				group by aut_proyecto
			)
			and Id_Status_Solicitud=1
		END

	END	
	
END
