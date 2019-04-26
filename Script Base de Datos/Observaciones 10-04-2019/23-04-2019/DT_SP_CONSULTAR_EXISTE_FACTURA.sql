
IF EXISTS (SELECT * FROM sysobjects WHERE name='DT_SP_CONSULTAR_EXISTE_FACTURA')
BEGIN
	DROP PROCEDURE DT_SP_CONSULTAR_EXISTE_FACTURA
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Autor			EDSON PEÑA	
--Fecha			20190319
--Objetivo		OBTIENE LA LISTA DE LAS SOLICITUDES POR COMPROBACION
-- =============================================
CREATE PROCEDURE DT_SP_CONSULTAR_EXISTE_FACTURA
	@uuid varchar(50)
AS
BEGIN


	declare 
		@estatus bit = 1,
		@mensaje varchar(500)

	if exists(select * from DT_TBL_VIATICO_COMPROBACION_GASTOS where uuid = @uuid)
	begin
		select @estatus = 0, @mensaje = 'La factura que intenta registrar ya se encuentra registrada en el sistema.'
	end

	select @estatus status, @mensaje mensaje

END
GO

GRANT EXECUTE ON DT_SP_CONSULTAR_EXISTE_FACTURA TO public;  
GO