/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2012 (11.0.5388)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [DB_A0966E_iica]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_INICIAR_SESION]    Script Date: 06/04/2019 04:16:46 p. m. ******/
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
		@Status int=1,
		@Mensaje varchar(500)='OK',
		@Id_Tipo_Usuario int=0,
		@Rol_Usuario varchar(100),
		@Empleado BIT,
		@Query nvarchar(max)


    -- Insert statements for procedure here

	CREATE TABLE #RESULTADO (
	[Status] INT,
	Mensaje VARCHAR(100),
	Id_Tipo_Usuario INT,
	Rol_Usuario VARCHAR(100),
	Empleado BIT,
	Em_Nombre VARCHAR(100),
	Em_Apellido_Paterno VARCHAR(100),
	Em_Apellido_Materno VARCHAR(100),
	Programa VARCHAR(100),
	Departamento VARCHAR(100)
	)

	--1.-Saber si es empleado

	IF EXISTS(SELECT 1 FROM Empleado WHERE Em_UserDef_1=@Numero_Usuario AND Em_UserDef_2=@Password)
	BEGIN
		
		IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_AUTORIZADORES WHERE Em_Cve_Empleado=@Numero_Usuario)
		BEGIN
			SELECT
				@Id_Tipo_Usuario=A.Id_Rol_Usuario,
				@Rol_Usuario=B.descripcion,
				@Empleado=b.Empleado
			FROM DT_TBL_USUARIOS_AUTORIZADORES A
			INNER JOIN DT_CAT_ROL_USUARIO B ON A.Id_Rol_Usuario=B.Id_Rol_Usuario
			WHERE Em_Cve_Empleado=@Numero_Usuario
			GROUP BY A.Id_Rol_Usuario,B.descripcion,b.Empleado
		END
		ELSE
		BEGIN
			SELECT
				@Id_Tipo_Usuario=Id_Rol_Usuario,
				@Rol_Usuario=Descripcion,
				@Empleado=Empleado
			FROM DT_CAT_ROL_USUARIO
			WHERE Id_Rol_Usuario=1
		END

		INSERT 
			INTO #RESULTADO
			(
				[Status],
				Mensaje,
				Id_Tipo_Usuario,
				Rol_Usuario,
				Empleado,
				Em_Nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				Programa,
				Departamento
			)
		SELECT
			@Status,
			@Mensaje,
			@Id_Tipo_Usuario,
			@Rol_Usuario,
			@Empleado,
			a.Em_nombre,
			a.Em_Apellido_Paterno,
			a.Em_Apellido_Materno,
			b.Sc_Descripcion Programa,
			COALESCE(NULL,c.De_Descripcion,'SIN DEPARTAMENTO') Departamento
		FROM Empleado a
		LEFT JOIN Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
		LEFT JOIN Departamento_Empleado c ON a.De_Cve_Departamento_Empleado=c.De_Cve_Departamento_Empleado
		WHERE Em_Cve_Empleado=@Numero_Usuario
		
		GOTO EXIT_
		
	END

	IF EXISTS(SELECT 1 FROM DT_TBL_USUARIOS_ADMINISTRADOR WHERE Usuario=@Numero_Usuario AND Contrasena=@Password)
	BEGIN
		INSERT 
			INTO #RESULTADO
			(
				[Status],
				Mensaje,
				Id_Tipo_Usuario,
				Rol_Usuario,
				Empleado,
				Em_Nombre,
				Em_Apellido_Paterno,
				Em_Apellido_Materno,
				Programa,
				Departamento
			)
		SELECT
			@Status,
			@Mensaje,
			A.Id_Rol_Usuario,
			B.Descripcion,
			B.Empleado,
			Nombre,
			Apellido_Paterno,
			Apellido_Materno,
			B.Descripcion Programa,
			'SIN DEPARTAMENTO' Departamento
		FROM DT_TBL_USUARIOS_ADMINISTRADOR A
		INNER JOIN DT_CAT_ROL_USUARIO B ON A.Id_Rol_Usuario=B.Id_Rol_Usuario
		WHERE Usuario=@Numero_Usuario

		GOTO EXIT_

	END

	INSERT INTO #RESULTADO	([Status],Mensaje)
	VALUES(0,'USUARIO O CONTRASEÑA INCORRECTA')

	Exit_:
			SELECT * FROM #RESULTADO

END



/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_INCAPACIDADES_USUARIO]    Script Date: 26/03/2019 11:08:15 p.m. ******/
SET ANSI_NULLS ON
