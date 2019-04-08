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
/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_PERMISO]    Script Date: 06/04/2019 10:41:14 p. m. ******/
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
		
		/*
		select @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado
		*/

		select TOP 1 @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from DT_TBL_USUARIOS_AUTORIZADORES
		where Id_Rol_Usuario=2-- DT_CAT_ROL_USUARIO: 2	Autorizador PVI	1
		and Proyecto=@proyecto_empleado

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
