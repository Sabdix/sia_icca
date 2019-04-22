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
/****** Object:  StoredProcedure [dbo].[DT_SP_CONSULTAR_AUTORIZADORES_PROYECTO]    Script Date: 06/04/2019 10:44:29 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_CONSULTAR_AUTORIZADORES_PROYECTO]
	-- Add the parameters for the stored procedure here
	@Em_Cve_Empleado VARCHAR(100),
	@id_rol_usuario int,
	@usuario varchar(100)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE
		@proyecto_empleado varchar(500)

    -- Insert statements for procedure here

	--1.-Obtenemos la información del proyecto del empleado que esta generando el permiso
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		/*
		select *
		from Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado
		*/
		if @id_rol_usuario in (2,3)
		begin
			select *
			from DT_TBL_USUARIOS_AUTORIZADORES a
			join empleado b
			on a.em_cve_empleado=b.em_cve_empleado
			where Id_Rol_Usuario=@id_rol_usuario-- DT_CAT_ROL_USUARIO: 2 Autorizador PVI	3 Autorizador viaticos
			and Proyecto=@proyecto_empleado
		end
		else if @id_rol_usuario in (4,5)
		begin
			select 
				Id_Usuario_Administrador
				,Nombre
				,Apellido_Paterno
				,Apellido_Materno
				,Correo_1 em_email
				,Correo_2 em_email2
				,Usuario
				,Contrasena
				,Id_Rol_Usuario
				,Activo
				,Fecha_Alta
			from DT_TBL_USUARIOS_ADMINISTRADOR
			where Id_Rol_Usuario=@id_rol_usuario-- DT_CAT_ROL_USUARIO: 4	Administrador RH 5 Administrador Viaticos
			and usuario=@usuario
		end
END



/****** Object:  StoredProcedure [dbo].[DT_SP_CONSULTAR_SOLICITUDES_POR_AUTORIZAR]    Script Date: 26/03/2019 11:02:10 p.m. ******/
SET ANSI_NULLS ON
