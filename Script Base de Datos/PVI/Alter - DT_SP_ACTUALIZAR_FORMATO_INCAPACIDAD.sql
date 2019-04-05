USE [IICA_1]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_FORMATO_INCAPACIDAD]    Script Date: 02/04/2019 10:42:30 a.m. ******/
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

		IF @tipo_formato = 5
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_RT_cuestionario=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO RT CUESTIONARIO, CONTACTE A SOPORTE TÉCNICO.'
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
