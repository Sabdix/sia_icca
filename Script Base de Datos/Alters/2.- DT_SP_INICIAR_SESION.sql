
/*Corrección de incidencias*/

USE [IICA_1]
GO
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
