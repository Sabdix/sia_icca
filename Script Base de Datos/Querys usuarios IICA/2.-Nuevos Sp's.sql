--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_ROL_USUARIO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_ROL_USUARIO
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_ROL_USUARIO
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT *
	FROM DT_CAT_ROL_USUARIO
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_ROL_USUARIO TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZA_USUARIO_ADMINISTRADOR')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZA_USUARIO_ADMINISTRADOR
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_ACTUALIZA_USUARIO_ADMINISTRADOR
	@Id_Usuario_Administrador INT=NULL,
	@Nombre VARCHAR(50)=NULL,
	@Apellido_Paterno VARCHAR(50)=NULL,
	@Apellido_Materno VARCHAR(50)=NULL,
	@Correo_1 VARCHAR(50)=NULL,
	@Correo_2 VARCHAR(50)=NULL,
	@Usuario VARCHAR(12)=NULL,
	@Contrasena VARCHAR(12)=NULL,
	@Id_Rol_Usuario INT =NULL
AS
BEGIN
	
	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='Registro éxitoso.'

	--=========================Inicio Alta de usuario administrador =====================================================

	IF @Id_Usuario_Administrador IS NULL OR @Id_Usuario_Administrador = 0
	BEGIN
		--1.- Se valida si no existe el usuario en la tabla.
		IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_ADMINISTRADOR WHERE Usuario=@Usuario)
		BEGIN
			SET @status=0
			SET @mensaje='ESTE USUARIO YA SE ENCUENTRA REGISTRADO.'
			GOTO EXIT_
		END
		--2.- Se inserta el nuevo usuario
		INSERT 
			INTO DT_TBL_USUARIOS_ADMINISTRADOR
			(
				Nombre,
				Apellido_Paterno,
				Apellido_Materno,
				Correo_1,
				Correo_2,
				Usuario,
				Contrasena,
				Id_Rol_Usuario,
				Activo
			)
			VALUES
			(
				@Nombre,
				@Apellido_Paterno,
				@Apellido_Materno,
				@Correo_1,
				@Correo_2,
				@Usuario,
				@Contrasena,
				@Id_Rol_Usuario,
				1
			)
			IF @@ERROR<>0
			BEGIN
				SET @status=0
				SET @mensaje='ERROR AL GUARDAR USUARIO.'
				GOTO EXIT_
			END
	END

	ELSE
	BEGIN
		
		UPDATE DT_TBL_USUARIOS_ADMINISTRADOR
		SET
			Nombre=@Nombre,
			Apellido_Paterno=@Apellido_Paterno,
			Apellido_Materno=@Apellido_Materno,
			Correo_1=@Correo_1,
			Correo_2=@Correo_2,
			Contrasena=@Contrasena,
			@Id_Rol_Usuario=@Id_Rol_Usuario
		WHERE Id_Usuario_Administrador=@Id_Usuario_Administrador

		IF @@ERROR<>0
			BEGIN
				SET @status=0
				SET @mensaje='ERROR AL GUARDAR USUARIO.'
				GOTO EXIT_
			END

	END

	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE
	
END
GO

GRANT EXECUTE ON DT_SP_ACTUALIZA_USUARIO_ADMINISTRADOR TO public;  
GO
--==========================================================================================================================

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ALTA_AUTORIZADOR_PROYECTO')
BEGIN
	DROP PROCEDURE DT_SP_ALTA_AUTORIZADOR_PROYECTO
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_ALTA_AUTORIZADOR_PROYECTO
	@Em_Cve_Empleado VARCHAR(12),
	@Proyecto VARCHAR(12),
	@Id_Rol_Usuario INT
	
AS
BEGIN
	
	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='Registro éxitoso.',
		@Proyecto_desc VARCHAR(12)


	IF EXISTS (SELECT 1 FROM DT_TBL_USUARIOS_AUTORIZADORES WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Proyecto=@Proyecto AND Id_Rol_Usuario=@Id_Rol_Usuario)
	BEGIN
		SET @status=0
		SET @mensaje='ERROR YA EXISTE EL AUTORIZADOR DE ESTE PROYECTO.'
		GOTO EXIT_
	END

	SELECT @Proyecto_desc=Sc_UserDef_2
	FROM Sucursal
	WHERE Sc_Cve_Sucursal=RIGHT('0000' + Ltrim(Rtrim(@Proyecto)),4)


	INSERT 
		INTO DT_TBL_USUARIOS_AUTORIZADORES
		(
			Em_Cve_Empleado,
			Proyecto,
			Id_Rol_Usuario
		)
		VALUES
		(
			@Em_Cve_Empleado,
			@Proyecto_desc,
			@Id_Rol_Usuario
		)
	
	IF @@ERROR<>0
	BEGIN
		SET @status=0
		SET @mensaje='ERROR AL GUARDAR USUARIO.'
		GOTO EXIT_
	END

	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE
	
END
GO

GRANT EXECUTE ON DT_SP_ALTA_AUTORIZADOR_PROYECTO TO public;  
GO
--==========================================================================================================================

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTA_INFORMACION_EMPLEADO')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTA_INFORMACION_EMPLEADO
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTA_INFORMACION_EMPLEADO
	@Em_Cve_Empleado VARCHAR(12)
AS
BEGIN
	
	SELECT
			a.Em_nombre,
			a.Em_Apellido_Paterno,
			a.Em_Apellido_Materno,
			a.Em_Email,
			b.Sc_Descripcion Programa,
			COALESCE(NULL,c.De_Descripcion,'SIN DEPARTAMENTO') Departamento
		FROM Empleado a
		LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
		LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
		WHERE Em_Cve_Empleado=@Em_Cve_Empleado
	
END
GO

GRANT EXECUTE ON DT_SP_CONSULTA_INFORMACION_EMPLEADO TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_ADMINISTRADORES')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_ADMINISTRADORES
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_ADMINISTRADORES
	@Id_Rol_Usuario INT
AS
BEGIN
	
	SELECT
		*
	FROM DT_TBL_USUARIOS_ADMINISTRADOR A
	INNER JOIN DT_CAT_ROL_USUARIO B ON A.Id_Rol_Usuario=B.Id_Rol_Usuario
	where B.Id_Rol_Usuario=@Id_Rol_Usuario
	ORDER BY Id_Usuario_Administrador ASC
	
END
GO

GRANT EXECUTE ON DT_SP_OBTENER_ADMINISTRADORES TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTA_SUCURSALES_PROYECTOS')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTA_SUCURSALES_PROYECTOS
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTA_SUCURSALES_PROYECTOS
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
		Sc_Cve_Sucursal,
		Sc_Descripcion,
		Sc_UserDef_2
	FROM Sucursal
	WHERE Sc_UserDef_2<>''
	ORDER BY Sc_Descripcion ASC

END
GO

GRANT EXECUTE ON DT_SP_CONSULTA_SUCURSALES_PROYECTOS TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTA_AUTORIZADORES_ROL')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTA_AUTORIZADORES_ROL
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTA_AUTORIZADORES_ROL
	@Id_Rol INT
AS
BEGIN
	
	SELECT
			d.Id_Autorizador,
			--a.Em_nombre+' '+a.Em_Apellido_Paterno+' '+a.Em_Apellido_Materno nombre,
			a.Em_nombre,
			a.Em_Apellido_Paterno,
			a.Em_Apellido_Materno,
			a.Em_UserDef_1 usuario,
			a.Em_Email,
			b.Sc_Descripcion Programa
		FROM Empleado a
		LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
		LEFT JOIN DT_TBL_USUARIOS_AUTORIZADORES d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
		WHERE d.Id_Rol_Usuario=@Id_Rol
	
END
GO

GRANT EXECUTE ON DT_SP_CONSULTA_AUTORIZADORES_ROL TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZA_STATUS_ADMINISTRADOR')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZA_STATUS_ADMINISTRADOR
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_ACTUALIZA_STATUS_ADMINISTRADOR
	@Id_Usuario_Administrador INT,
	@Activo INT
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='ACTUALIZACIÓN CORRECTA.'

	UPDATE DT_TBL_USUARIOS_ADMINISTRADOR
	SET Activo=@Activo
	WHERE Id_Usuario_Administrador=@Id_Usuario_Administrador
	IF @@ERROR<>0
	BEGIN
		SET @status =0
		SET @mensaje='ERROR EN LA ACTUALIZACIÓN.'
	END

	SELECT @status STATUS, @mensaje MENSAJE


END
GO

GRANT EXECUTE ON DT_SP_OBTENER_ROL_USUARIO TO public;  
GO
--==========================================================================================================================
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ELIMINAR_USUARIO_AUTORIZADOR')
BEGIN
	DROP PROCEDURE DT_SP_ELIMINAR_USUARIO_AUTORIZADOR
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>

-- Description:	<OBTIENE CATALOGO DE>
-- =============================================
CREATE PROCEDURE DT_SP_ELIMINAR_USUARIO_AUTORIZADOR
	@Id_Autorizador INT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='ELIMINACIÓN CORRECTA.'

	DELETE DT_TBL_USUARIOS_AUTORIZADORES
	WHERE Id_Autorizador=@Id_Autorizador
	IF @@ERROR<>0
	BEGIN
		SET @status =0
		SET @mensaje='ERROR EN LA ELIMINACIÓN.'
	END

	SELECT @status STATUS, @mensaje MENSAJE

END
GO

GRANT EXECUTE ON DT_SP_ELIMINAR_USUARIO_AUTORIZADOR TO public;  
GO
--==========================================================================================================================