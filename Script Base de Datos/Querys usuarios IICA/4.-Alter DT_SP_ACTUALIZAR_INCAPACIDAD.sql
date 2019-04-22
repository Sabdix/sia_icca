/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2012 (11.0.5388)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE IICA_1
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_INCAPACIDAD]    Script Date: 06/04/2019 09:49:26 p. m. ******/
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
