USE [DB_A0966E_iica]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_INSERTA_COMPROBACION_GASTO]    Script Date: 23/04/2019 01:32:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_INSERTA_COMPROBACION_GASTO]
	-- Add the parameters for the stored procedure here
	@Id_Solicitud INT,
	@Comentario VARCHAR(500),
	@Path_Archivo_XML VARCHAR(500),
	@Path_Archivo_PDF VARCHAR(500),
	@Id_Gasto_Comprobacion INT,
	@Emisor VARCHAR(500),
	@Subtotal MONEY,
	@Total MONEY,
	@Lugar VARCHAR(500),
	@Fecha DATETIME,
	@uuid varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE
		@status INT=1,
		@mensaje VARCHAR(100)='GUARDADO DE MANERA CORRECTA',
		@id bigint = 0


	INSERT
		INTO DT_TBL_VIATICO_COMPROBACION_GASTOS
			(
				Id_Solicitud,
				Comentario,
				Path_Archivo_XML,
				Path_Archivo_PDF,
				Id_Gasto_Comprobacion,
				Emisor,
				Subtotal,
				Total,
				Lugar,
				Fecha,
				uuid
			)
		VALUES 
			(
				@Id_Solicitud,
				@Comentario,
				@Path_Archivo_XML,
				@Path_Archivo_PDF,
				@Id_Gasto_Comprobacion,
				@Emisor,
				@Subtotal,
				@Total,
				@Lugar,
				@Fecha,
				@uuid
			)
		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL GUARDAR LA COMPROBACION DEL GASTO.'
			GOTO ERROR_1
		END
		ELSE
		BEGIN
			select @id = Max(Id_Comprobacion_Gasto) from 
			DT_TBL_VIATICO_COMPROBACION_GASTOS where Id_Solicitud=@Id_Solicitud
		END


	GOTO EXIT_

	ERROR_1:
		SET @status=0
		GOTO EXIT_
	EXIT_:
		SELECT @status STATUS, @mensaje MENSAJE,@id id

END
