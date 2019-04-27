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
/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO]    Script Date: 26/04/2019 11:56:13 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Devuelve la información para armar el formato del permiso>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO]
	-- Add the parameters for the stored procedure here
	@Id_Permiso int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		Em_nombre,
		Em_Apellido_Paterno,
		Em_Apellido_Materno,
		CONVERT (VARCHAR,Em_Fecha_Ingreso,103)Em_Fecha_Ingreso,
		b.Sc_UserDef_2,
		b.Sc_Descripcion Programa,
		COALESCE(NULL,C.De_Descripcion,'SIN DEPARTAMENTO') Departamento,
		CONVERT (VARCHAR,d.Fecha_Permiso,103)Fecha_Permiso,
		CONVERT (VARCHAR,d.Fecha_Alta,103)Fecha_Alta,
		d.Hora_Inicio,
		d.Hora_Fin,
		d.Total_Horas,
		d.Hora_Fin Hora_Raunuda_Labores,
		d.Motivo_Permiso
	from Empleado a
	left join Sucursal b ON a.Sc_Cve_Sucursal=b.Sc_Cve_Sucursal
	LEFT JOIN Departamento_Empleado C ON A.De_Cve_Departamento_Empleado=C.De_Cve_Departamento_Empleado
	INNER JOIN DT_TBL_PERMISO d ON a.Em_Cve_Empleado=d.Em_Cve_Empleado
	WHERE Id_Permiso=@Id_Permiso


END


/****** Object:  StoredProcedure [dbo].[DT_SP_OBTENER_INFORMACION_FORMATO_VACACIONES]    Script Date: 09/03/2019 03:46:56 p.m. ******/
SET ANSI_NULLS ON
