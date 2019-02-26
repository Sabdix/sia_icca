
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_ACTUALIZAR_FORMATO_INCAPACIDAD')
BEGIN
	DROP PROCEDURE DT_SP_ACTUALIZAR_FORMATO_INCAPACIDAD
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Edson Peña>
-- Description:	<Actualizar el path de un formato en particular de una solicitud de incapacidad>
-- =============================================
CREATE PROCEDURE DT_SP_ACTUALIZAR_FORMATO_INCAPACIDAD
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
		IF @Id_Incapacidad = 1
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_Incapacidad=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO DE LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='FORMATO GUARDADO CON ÉXITO.'

			GOTO EXIT_
		END

		IF @Id_Incapacidad = 2
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_Adicional=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO DE LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='FORMATO GUARDADO CON ÉXITO.'

			GOTO EXIT_
		END


		IF @Id_Incapacidad = 3
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_ST7_Calificacion_RT=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO DE LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			SET @status=1
			SET @mensaje='FORMATO GUARDADO CON ÉXITO.'

			GOTO EXIT_
		END


		IF @Id_Incapacidad = 4
		BEGIN
			UPDATE DT_TBL_INCAPACIDAD
			SET Formato_ST7_Alta_RT=@path_formato
			WHERE Id_Incapacidad=@Id_Incapacidad

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL ALMACENAR EL FORMATO DE LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
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
GO

GRANT EXECUTE ON DT_SP_ACTUALIZAR_FORMATO_INCAPACIDAD TO public;  
GO