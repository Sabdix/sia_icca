USE IICA_1
GO

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_USUARIO')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_USUARIO
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Autor			EDSON PEÑA	
--Fecha			20190319
--Objetivo		OBTIENE LOS DATOS DE UN USUARIO SUPER-ADMIN,ADMIN Ó AUTORIZADOR
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_USUARIO
	@id_usuario int,
	@id_rol int
AS
BEGIN
	
	DECLARE
		@Status int=1,
		@Mensaje varchar(500)='OK',
		@Id_Tipo_Usuario int=0,
		@Rol_Usuario varchar(100),
		@Empleado BIT,
		@Numero_Usuario varchar(30)


    -- Insert statements for procedure here

	CREATE TABLE #RESULTADO (
	[Status] INT,
	Mensaje VARCHAR(100),
	id_usuario int,
	Id_Tipo_Usuario INT,
	Rol_Usuario VARCHAR(100),
	Empleado BIT,
	Usuario VARCHAR(100),
	Em_Nombre VARCHAR(100),
	Em_Apellido_Paterno VARCHAR(100),
	Em_Apellido_Materno VARCHAR(100),
	Programa VARCHAR(100),
	Departamento VARCHAR(100),
	Contrasena VARCHAR(100),
	email VARCHAR(80),
	email2 VARCHAR(80)
	)

	--1.-Saber si es autorizador

		--IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_AUTORIZADORES WHERE Id_Autorizador=@id_usuario and Id_Rol_Usuario=@id_rol)
		--BEGIN
		--	SELECT
		--		@Id_Tipo_Usuario=A.Id_Rol_Usuario,
		--		@Rol_Usuario=B.descripcion,
		--		@Empleado=b.Empleado,
		--		@Numero_Usuario = Em_Cve_Empleado
		--	FROM DT_TBL_USUARIOS_AUTORIZADORES A
		--	INNER JOIN DT_CAT_ROL_USUARIO B ON A.Id_Rol_Usuario=B.Id_Rol_Usuario
		--	WHERE A.Id_Autorizador= @id_usuario
		--	GROUP BY A.Id_Rol_Usuario,B.descripcion,b.Empleado
		--END

		--INSERT 
		--	INTO #RESULTADO
		--	(
		--		[Status],
		--		Mensaje,
		--		Id_Tipo_Usuario,
		--		Rol_Usuario,
		--		Empleado,
		--		Em_Nombre,
		--		Em_Apellido_Paterno,
		--		Em_Apellido_Materno,
		--		Programa,
		--		Departamento
		--	)
		--SELECT
		--	@Status,
		--	@Mensaje,
		--	@Id_Tipo_Usuario,
		--	@Rol_Usuario,
		--	@Empleado,
		--	a.Em_nombre,
		--	a.Em_Apellido_Paterno,
		--	a.Em_Apellido_Materno,
		--	b.Sc_Descripcion Programa,
		--	COALESCE(NULL,c.De_Descripcion,'SIN DEPARTAMENTO') Departamento
		--FROM Empleado a
		--LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
		--LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
		--WHERE Em_Cve_Empleado=@Numero_Usuario
		
		--GOTO EXIT_
		


	IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_ADMINISTRADOR WHERE Id_Usuario_Administrador=@id_usuario AND Id_Rol_Usuario=@id_rol)
	BEGIN
		INSERT 
			INTO #RESULTADO
			(
				[Status],
				Mensaje,
				id_usuario,
				Id_Tipo_Usuario,
				Rol_Usuario,
				Empleado,
				Usuario,
				Em_Nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				Programa,
				Departamento,
				Contrasena,
				email,
				email2
			)
		SELECT
			@Status,
			@Mensaje,
			@id_usuario,
			A.Id_Rol_Usuario,
			B.Descripcion,
			B.Empleado,
			A.Usuario,
			Nombre,
			Apellido_Paterno,
			Apellido_Materno,
			B.Descripcion Programa,
			'SIN DEPARTAMENTO' Departamento,
			A.Contrasena,
			A.Correo_1,
			A.Correo_2
		FROM DT_TBL_USUARIOS_ADMINISTRADOR A
		INNER JOIN DT_CAT_ROL_USUARIO B ON A.Id_Rol_Usuario=B.Id_Rol_Usuario
		WHERE 
			A.Id_Usuario_Administrador=@id_usuario 
			AND A.Id_Rol_Usuario=@id_rol

		GOTO EXIT_

	END

	INSERT INTO #RESULTADO	([Status],Mensaje)
	VALUES(0,'USUARIO NO ENCONTRADO.')

	Exit_:
			SELECT * FROM #RESULTADO

END
GO

GRANT EXECUTE ON DT_SP_OBTENER_USUARIO TO public;  
GO
