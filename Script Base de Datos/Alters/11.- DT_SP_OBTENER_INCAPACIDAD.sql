USE IICA_1
GO 

IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_OBTENER_INCAPACIDAD')
BEGIN
	DROP PROCEDURE DT_SP_OBTENER_INCAPACIDAD
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<DSI>
-- Create date: <Obtiene los datos de una incapacidad en particular>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DT_SP_OBTENER_INCAPACIDAD
	@Id_Incapacidad int
AS
BEGIN

	SET NOCOUNT ON;
	if exists (select * from DT_TBL_INCAPACIDAD where Id_Incapacidad = @Id_Incapacidad)
		select
				1 STATUS,
				'' MENSAJE,
				a.*,
				b.Descripcion_Status_Solicitud,
				COALESCE(Fecha_Actualizacion,'') Fecha_Revision,
				d.Descripcion_Tipo_Seguimiento,
				c.Descripcion_Tipo_Incapacidad
			from
				DT_TBL_INCAPACIDAD a
			inner join DT_CAT_STATUS_SOLICITUD b on a.Id_Status_Solicitud=b.Id_Status_Solicitud
			join DT_CAT_TIPO_INCAPACIDAD c on a.Id_Tipo_Incapacidad=c.Id_Tipo_Incapacidad
			join DT_CAT_TIPO_SEGUIMIENTO d on a.Id_Tipo_Seguimiento=d.Id_Tipo_Seguimiento
			WHERE 
				a.Id_Incapacidad = @Id_Incapacidad
	else
	begin
		select 0 STATUS, 'No se encontro la incapacidad solicitada' mensaje
	end

END
GO

GRANT EXECUTE ON DT_SP_OBTENER_INCAPACIDAD TO public;  
GO
