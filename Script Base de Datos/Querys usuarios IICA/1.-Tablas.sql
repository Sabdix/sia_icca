--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_CAT_ROL_USUARIO]') AND type in (N'U'))
DROP TABLE [dbo].[DT_CAT_ROL_USUARIO]
GO

CREATE TABLE DT_CAT_ROL_USUARIO (
Id_Rol_Usuario INT IDENTITY(1,1),
Descripcion VARCHAR(40),
Empleado BIT
)
GO

INSERT INTO DT_CAT_ROL_USUARIO(Descripcion,Empleado) VALUES ('Empleado',1)
INSERT INTO DT_CAT_ROL_USUARIO(Descripcion,Empleado) VALUES ('Autorizador PVI',1)
INSERT INTO DT_CAT_ROL_USUARIO(Descripcion,Empleado) VALUES ('Autorizador Viaticos',1)
INSERT INTO DT_CAT_ROL_USUARIO(Descripcion,Empleado) VALUES ('Administrador RH',0)
INSERT INTO DT_CAT_ROL_USUARIO(Descripcion,Empleado) VALUES ('Administrador Viaticos',0)
INSERT INTO DT_CAT_ROL_USUARIO(Descripcion,Empleado) VALUES ('SuperAdministrador',0)
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_TBL_USUARIOS_ADMINISTRADOR]') AND type in (N'U'))
DROP TABLE [dbo].[DT_TBL_USUARIOS_ADMINISTRADOR]
GO


CREATE TABLE DT_TBL_USUARIOS_ADMINISTRADOR(
	Id_Usuario_Administrador INT IDENTITY(1,1),
	Nombre VARCHAR(50),
	Apellido_Paterno VARCHAR(50),
	Apellido_Materno VARCHAR(50),
	Correo_1 VARCHAR(50),
	Correo_2 VARCHAR(50),
	Usuario VARCHAR(12),
	Contrasena VARCHAR(12),
	Id_Rol_Usuario INT
)
GO
--==========================================================================================================================
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT_TBL_USUARIOS_AUTORIZADORES]') AND type in (N'U'))
DROP TABLE [dbo].[DT_TBL_USUARIOS_AUTORIZADORES]
GO

CREATE TABLE DT_TBL_USUARIOS_AUTORIZADORES(
	Id_Autorizador INT IDENTITY(1,1),
	Em_Cve_Empleado VARCHAR(12),
	Proyecto VARCHAR(12),
	Id_Rol_Usuario INT
)
GO