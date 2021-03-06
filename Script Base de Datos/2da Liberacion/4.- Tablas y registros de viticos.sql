USE IICA_1
GO
/****** Object:  Table [dbo].[Viaticos_Tipo_Gasto] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Tipo_Gasto]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Tipo_Gasto]
GO
/****** Object:  Table [dbo].[Viaticos_Solicitud] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Solicitud]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Solicitud]
GO
/****** Object:  Table [dbo].[Viaticos_Log_Estatus] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Log_Estatus]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Log_Estatus]
GO
/****** Object:  Table [dbo].[Viaticos_Itinerario] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Itinerario]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Itinerario]
GO
/****** Object:  Table [dbo].[Viaticos_Importes_Extras] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Importes_Extras]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Importes_Extras]
GO
/****** Object:  Table [dbo].[Viaticos_GastoCentroCostos] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_GastoCentroCostos]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_GastoCentroCostos]
GO
/****** Object:  Table [dbo].[Viaticos_Gasto] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Gasto]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Gasto]
GO
/****** Object:  Table [dbo].[Viaticos_Deposito_Caja] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Deposito_Caja]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Deposito_Caja]
GO
/****** Object:  Table [dbo].[Viaticos_Comprobacion] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Comprobacion]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Comprobacion]
GO
/****** Object:  Table [dbo].[Viaticos_Cheque] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Cheque]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Cheque]
GO
/****** Object:  Table [dbo].[Viaticos_Autorizadores] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Autorizadores]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Autorizadores]
GO
/****** Object:  Table [dbo].[Viaticos_Aprobacion] Script Date: 12/03/2019 08:02:25 p.m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Aprobacion]') AND type in (N'U'))
DROP TABLE [dbo].[Viaticos_Aprobacion]
GO
/****** Object:  Table [dbo].[Viaticos_Aprobacion] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Aprobacion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Aprobacion](
	[ap_id] [nchar](10) NOT NULL,
	[id_solicitud] [int] NULL,
	[ap_a_usuario] [nchar](20) NULL,
	[ap_a_fecha] [smalldatetime] NULL,
	[ap_b_usuario] [nchar](20) NULL,
	[ap_b_fecha] [smalldatetime] NULL,
	[ap_c_usuario] [nchar](20) NULL,
	[ap_c_fecha] [smalldatetime] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_Autorizadores] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Autorizadores]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Autorizadores](
	[aut_id] [nchar](10) NULL,
	[aut_nombre] [nchar](150) NULL,
	[aut_username] [nchar](25) NULL,
	[aut_correo] [nchar](80) NULL,
	[aut_proyecto] [nchar](4) NULL,
	[aut_nivel] [nchar](1) NULL,
	[Es_Cve_Estado] [nchar](4) NULL,
	[Em_Cve_Empleado] [varchar](100) NULL,
	[Em_UserDef_1] [varchar](100) NULL,
	[Em_UserDef_2] [varchar](100) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Viaticos_Cheque] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Cheque]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Cheque](
	[ec_id] [nchar](10) NOT NULL,
	[id_solicitud] [int] NULL,
	[ec_referencia] [nchar](10) NOT NULL,
	[Oper_Alta] [nchar](10) NOT NULL,
	[Fecha_Alta] [datetime] NOT NULL,
	[Es_Cve_Estado] [nchar](4) NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_Comprobacion] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Comprobacion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Comprobacion](
	[co_id] [nchar](10) NOT NULL,
	[id_Solicitud] [int] NULL,
	[id_Sucursal] [nchar](30) NOT NULL,
	[comentario] [nchar](100) NULL,
	[Oper_Alta] [nchar](15) NOT NULL,
	[Fecha_Alta] [datetime] NOT NULL,
	[Oper_Ult_Modif] [nchar](15) NULL,
	[Fecha_Ult_Modif] [datetime] NULL,
	[Oper_Baja] [nchar](15) NULL,
	[Fecha_Baja] [datetime] NULL,
	[Es_Cve_Estado] [nvarchar](10) NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_Deposito_Caja] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Deposito_Caja]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Deposito_Caja](
	[de_id] [nchar](10) NULL,
	[de_idSolicitud] [int] NULL,
	[de_importe] [decimal](7, 2) NULL,
	[Es_Cve_Estado] [nchar](4) NULL,
	[Oper_Alta] [nchar](10) NULL,
	[Fecha_Alta] [datetime] NULL,
	[url_Comprobante] [nchar](100) NULL,
	[de_proyecto] [nchar](10) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_Gasto] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Gasto]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Gasto](
	[ga_Id] [nchar](10) NOT NULL,
	[id_comprobacion] [nchar](10) NOT NULL,
	[id_TipoGastos] [nchar](10) NOT NULL,
	[ga_Referencia] [nchar](100) NOT NULL,
	[ga_Comentario] [nchar](100) NOT NULL,
	[ga_Proveedor] [nchar](350) NOT NULL,
	[ga_fecha] [datetime] NOT NULL,
	[ga_subtotal] [decimal](7, 2) NOT NULL,
	[ga_impuesto] [decimal](7, 2) NOT NULL,
	[ga_importe] [decimal](7, 2) NOT NULL,
	[ga_url_factura] [nchar](350) NULL,
	[ga_lugar] [nchar](150) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_GastoCentroCostos] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_GastoCentroCostos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_GastoCentroCostos](
	[gcc_id] [nchar](10) NOT NULL,
	[id_Centro_Costos] [nchar](10) NOT NULL,
	[id_Gasto] [nchar](10) NOT NULL,
	[gcc_porcentaje] [int] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_Importes_Extras] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Importes_Extras]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Importes_Extras](
	[im_id] [nchar](10) NOT NULL,
	[id_solicitud] [int] NULL,
	[im_transporte] [decimal](7, 2) NULL,
	[im_peaje_gasolina] [decimal](7, 2) NULL,
	[im_autobus] [decimal](7, 2) NULL,
	[im_otros] [decimal](7, 2) NULL,
	[im_otros_descripcion] [nchar](25) NULL,
 CONSTRAINT [PK_Viaticos_Importes_Extras] PRIMARY KEY CLUSTERED 
(
	[im_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_Itinerario] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Itinerario]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Itinerario](
	[it_id] [int] NULL,
	[vt_id] [int] NULL,
	[it_origen] [nchar](40) NULL,
	[it_destino] [nchar](40) NULL,
	[it_medio] [nchar](20) NULL,
	[it_aerolinea] [varchar](20) NULL,
	[it_numero] [nchar](12) NULL,
	[it_hora_salida] [smalldatetime] NULL,
	[it_hora_llegada] [smalldatetime] NULL,
	[it_dias] [float] NULL,
	[it_importe] [decimal](5, 0) NULL,
	[it_moneda] [nchar](6) NULL,
	[it_tipo] [nchar](20) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Viaticos_Log_Estatus] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Log_Estatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Log_Estatus](
	[id_solicitud] [int] NULL,
	[Oper_Alta] [nvarchar](30) NULL,
	[Fecha_Alta] [datetime] NULL,
	[Es_Cve_Estado] [nvarchar](4) NULL,
	[id_log] [nchar](10) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_Solicitud] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Solicitud]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Solicitud](
	[vt_id] [int] NULL,
	[vt_folio] [nchar](20) NULL,
	[usr_deudor] [nchar](20) NULL,
	[vt_isNacional] [nchar](4) NULL,
	[vt_isTerrestre] [nchar](4) NULL,
	[vt_proposito] [nchar](300) NULL,
	[vt_resultado] [nchar](300) NULL,
	[vt_justificacion] [nchar](300) NULL,
	[vt_duracion] [int] NULL DEFAULT ((0)),
	[vt_especiales] [nchar](300) NULL,
	[vt_gastos_pendiente] [nchar](4) NULL,
	[vt_informe_pendiente] [nchar](4) NULL,
	[vt_marginal] [nchar](4) NULL,
	[vt_importe] [decimal](5, 0) NULL,
	[vt_prefijo] [nvarchar](8) NULL,
	[Oper_Alta] [nvarchar](30) NULL,
	[Fecha_Alta] [datetime] NULL,
	[Oper_Ult_Modif] [nvarchar](30) NULL,
	[Fecha_Ult_Modif] [datetime] NULL,
	[Oper_Baja] [nvarchar](30) NULL,
	[Fecha_Baja] [datetime] NULL,
	[Es_Cve_Estado] [nvarchar](8) NULL,
	[vt_fecha_inicio] [datetime] NULL,
	[vt_fecha_fin] [datetime] NULL,
	[vt_pernocta] [bit] NULL DEFAULT ((0))
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Viaticos_Tipo_Gasto] Script Date: 12/03/2019 08:02:25 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Viaticos_Tipo_Gasto]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Viaticos_Tipo_Gasto](
	[id_Tipo_Gasto] [nchar](10) NULL,
	[tg_Descripcion] [nchar](20) NULL
) ON [PRIMARY]
END
GO
--INSERT [dbo].[Viaticos_Aprobacion] ([ap_id], [id_solicitud], [ap_a_usuario], [ap_a_fecha], [ap_b_usuario], [ap_b_fecha], [ap_c_usuario], [ap_c_fecha]) VALUES (N'0000009', 2, N'CARLOS.VILLANUEVA', CAST(N'2019-03-04 16:14:00' AS SmallDateTime), NULL, NULL, NULL, NULL)
--INSERT [dbo].[Viaticos_Aprobacion] ([ap_id], [id_solicitud], [ap_a_usuario], [ap_a_fecha], [ap_b_usuario], [ap_b_fecha], [ap_c_usuario], [ap_c_fecha]) VALUES (N'0000008', 1, N'CARLOS.VILLANUEVA', CAST(N'2019-03-04 14:02:00' AS SmallDateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000001', N'ING. MIGUEL ALBERTO ABIACA LEE', N'miguel.abiaca  ', N'miguel.abiaca@iica-senasica.com  ', N'INSP', N'A', N'AC  ', N'0000003272', N'0000003272', N'Q183615')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000002', N'ING. MIGUEL ALBERTO ABIACA LEE', N'yanet.hernandez@iica.int ', N'  ', N' ', N'A', N'CER ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000003', N'ING. MIGUEL ALBERTO ABIACA LEE', N'miguel.abiaca  ', N'miguel.abiaca@iica-senasica.com  ', N'VEGE', N'A', N'AC  ', N'0000003272', N'0000003272', N'Q183615')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000004', N'ING. MIGUEL ALBERTO ABIACA LEE', N'miguel.abiaca  ', N'miguel.abiaca@iica-senasica.com  ', N'INOC', N'A', N'AC  ', N'0000003272', N'0000003272', N'Q183615')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000005', N'ING. MIGUEL ALBERTO ABIACA LEE', N'miguel.abiaca  ', N'miguel.abiaca@iica-senasica.com  ', N'EPID', N'A', N'AC  ', N'0000003272', N'0000003272', N'Q183615')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000006', N'ING. MIGUEL ALBERTO ABIACA LEE', N'miguel.abiaca  ', N'miguel.abiaca@iica-senasica.com  ', N'REG ', N'A', N'AC  ', N'0000003272', N'0000003272', N'Q183615')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000007', N'ING. MIGUEL ALBERTO ABIACA LEE', N'miguel.abiaca  ', N'miguel.abiaca@iica-senasica.com  ', N'FUN ', N'A', N'AC  ', N'0000003272', N'0000003272', N'Q183615')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000008', N'LIC. ROBERTO LUIS TOLEDO', N'robertoluis.iica ', N'robertoluis.iica@gmail.com  ', N'RRAJ', N'A', N'AC  ', N'0000002474', N'0000002474', N'Q182474')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000009', N'LIC. FRANCISCO MIRANDA TELLEZ ', N'oceniica  ', N'oceniica@ran.gob.mx ', N'MOD ', N'A', N'AC  ', N'0000002903', N'0000002903', N'Q182903')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000010', N'EDUARDO MARTINEZ HERNANDEZ ', N'eduardom  ', N'eduardom@agentetecnico.com  ', N'SIAP', N'A', N'AC  ', N'0000003615', N'0000003615', N'Q183615')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000010', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'carlos.villanueva@iica-senasica.com', N'INSP', N'B', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000011', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'carlos.villanueva@iica-senasica.com', N'ANIM', N'B', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000012', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'carlos.villanueva@iica-senasica.com', N'VEGE', N'B', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000013', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'carlos.villanueva@iica-senasica.com', N'INOC', N'B', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000014', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'carlos.villanueva@iica-senasica.com', N'EPID', N'B', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000015', N'ING. JOSE LUIS AYALA ESPINOSA ', N'jose.ayala', N'jose.ayala@iica.int ', N'RRAJ', N'B', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000016', N'ING. JOSE LUIS AYALA ESPINOSA ', N'jose.ayala', N'jose.ayala@iica.int ', N'MOD ', N'B', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000017', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'carlos.villanueva@iica-senasica.com', N'REG ', N'B', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000018', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'  ', N'MF  ', N'C', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000019', N'ING. CÃ‰SAR SEGURA ', N'cesar.segura', N'cesar.segura@iica.int  ', N'SIAP', N'B', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000020', N'DR. ARMANDO MATEOS POUMIAN ', N'armando.mateos ', N'armando.mateos@iica.int', N'INSP', N'C', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000021', N'DR. ARMANDO MATEOS POUMIAN ', N'armando.mateos ', N'armando.mateos@iica.int', N'ANIM', N'C', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000022', N'DR. ARMANDO MATEOS POUMIAN ', N'armando.mateos ', N'armando.mateos@iica.int', N'VEGE', N'C', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000023', N'DR. ARMANDO MATEOS POUMIAN ', N'armando.mateos ', N'armando.mateos@iica.int', N'INOC', N'C', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000024', N'DR. ARMANDO MATEOS POUMIAN ', N'armando.mateos ', N'armando.mateos@iica.int', N'EPID', N'C', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000025', N'DR. ARMANDO MATEOS POUMIAN ', N'armando.mateos ', N'armando.mateos@iica.int', N'REG ', N'C', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000026', N'DR. ARMANDO MATEOS POUMIAN ', N'armando.mateos ', N'armando.mateos@iica.int', N'FUN ', N'C', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000027', N'ING. MIGUEL ALBERTO ABIACA LEE', N'miguel.abiaca  ', N'miguel.abiaca@iica-senasica.com  ', N'MF  ', N'A', N'AC  ', N'0000003272', N'0000003272', N'Q183615')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000028', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'yanet.hernandez@iica.int ', N'MF  ', N'B', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000029', N'DR. ARMANDO MATEOS POUMIAN ', N'armando.mateos ', N'armando.mateos@iica.int', N'MF  ', N'C', N'AC  ', NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000030', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'yanet.hernandez@iica.int ', N'MF  ', N'D', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000031', NULL, NULL, NULL, NULL, N'D', NULL, NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000031', N'C.P. CARLOS VILLANUEVA ARAIZA ', N'CARLOS.VILLANUEVA', N'yanet.hernandez@iica.int ', N'MF  ', N'A', N'AC  ', N'0000003435', N'0000003435', N'Q183435')
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000032', NULL, NULL, NULL, NULL, N'D', NULL, NULL, NULL, NULL)
INSERT [dbo].[Viaticos_Autorizadores] ([aut_id], [aut_nombre], [aut_username], [aut_correo], [aut_proyecto], [aut_nivel], [Es_Cve_Estado], [Em_Cve_Empleado], [Em_UserDef_1], [Em_UserDef_2]) VALUES (N'0000032', NULL, NULL, NULL, NULL, N'D', NULL, NULL, NULL, NULL)
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000001', 3, N'INSP-61', N'0000000', CAST(N'2019-01-14 11:07:58.243' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000002', 6, N'INSP-61', N'0000000', CAST(N'2019-01-15 11:36:21.407' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000003', 2, N'INSP-02', N'0000000', CAST(N'2019-01-15 12:33:42.880' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000005', 9, N'15/01/2019', N'0000000', CAST(N'2019-01-21 11:37:22.927' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000006', 11, N'23/01/2019', N'0000000', CAST(N'2019-01-23 11:48:31.007' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000007', 1, N'0001 ', N'0000000', CAST(N'2019-03-04 14:24:48.350' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000008', 2, N'0001 ', N'0000000', CAST(N'2019-03-04 16:16:25.903' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000009', 4, N'0000 ', N'0000000', CAST(N'2019-03-05 14:26:26.620' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000010', 6, N'00000', N'0000000', CAST(N'2019-03-05 14:32:59.287' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000004', 7, N'INSP-07', N'0000000', CAST(N'2019-01-15 12:33:42.880' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000011', 8, N'000  ', N'0000000', CAST(N'2019-03-05 18:01:26.543' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000012', 9, N'07.03.2019', N'0000000', CAST(N'2019-03-07 11:55:15.393' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Cheque] ([ec_id], [id_solicitud], [ec_referencia], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado]) VALUES (N'0000013', 21, N'11.03.2019', N'0000000', CAST(N'2019-03-11 17:23:13.673' AS DateTime), N'AC  ')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000001', 3, N'INSPECCION', N'sin comentario  ', N'0000000659', CAST(N'2019-01-14 11:18:02.397' AS DateTime), N'0000000659', CAST(N'2019-01-14 11:18:02.397' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000002', 6, N'INSPECCION', N'sin comentario  ', N'0000000335', CAST(N'2019-01-15 11:52:53.897' AS DateTime), N'0000000335', CAST(N'2019-01-15 11:52:53.897' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000004', 7, N'INSPECCION', N'sin comentario  ', N'0000000659', CAST(N'2019-01-15 12:52:15.443' AS DateTime), N'0000000659', CAST(N'2019-01-15 12:52:15.443' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000006', 9, N'INSPECCION', N'COMPROBACIÓN DE VIÁTICOS', N'0000001030', CAST(N'2019-01-21 11:53:25.610' AS DateTime), N'0000001030', CAST(N'2019-01-21 11:53:25.610' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000007', 11, N'INSPECCION', N'ANEXO TICKETS', N'0000001052', CAST(N'2019-01-23 12:07:58.230' AS DateTime), N'0000001052', CAST(N'2019-01-23 12:07:58.230' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000008', 6, N'MOSCAFRUT', N'sin comentario  ', N'0000000003', CAST(N'2019-03-05 14:55:57.517' AS DateTime), N'0000000003', CAST(N'2019-03-05 14:55:57.517' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000009', 8, N'MOSCAFRUT', N'sin comentario  ', N'0000000003', CAST(N'2019-03-05 18:34:14.640' AS DateTime), N'0000000003', CAST(N'2019-03-05 18:34:14.640' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000010', 4, N'MOSCAFRUT', N'sin comentario  ', N'0000000003', CAST(N'2019-03-05 18:45:04.363' AS DateTime), N'0000000003', CAST(N'2019-03-05 18:45:04.363' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000011', 4, N'MOSCAFRUT', N'sin comentario  ', N'0000000003', CAST(N'2019-03-05 19:06:03.733' AS DateTime), N'0000000003', CAST(N'2019-03-05 19:06:03.733' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000012', 4, N'MOSCAFRUT', N'sin comentario  ', N'0000000003', CAST(N'2019-03-05 19:07:11.547' AS DateTime), N'0000000003', CAST(N'2019-03-05 19:07:11.547' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000013', 21, N'MOSCAFRUT', N'sin comentario  ', N'0000000010', CAST(N'2019-03-11 17:44:06.310' AS DateTime), N'0000000010', CAST(N'2019-03-11 17:44:06.310' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000014', 21, N'MOSCAFRUT', N'sin comentario  ', N'0000000010', CAST(N'2019-03-11 17:45:41.100' AS DateTime), N'0000000010', CAST(N'2019-03-11 17:45:41.100' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000003', 7, N'INSPECCION', N'sin comentario  ', N'0000000659', CAST(N'2019-01-15 12:51:18.737' AS DateTime), N'0000000659', CAST(N'2019-01-15 12:51:18.737' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Comprobacion] ([co_id], [id_Solicitud], [id_Sucursal], [comentario], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado]) VALUES (N'0000005', 7, N'INSPECCION', N'sin comentario  ', N'0000000659', CAST(N'2019-01-15 12:53:35.537' AS DateTime), N'0000000659', CAST(N'2019-01-15 12:53:35.537' AS DateTime), NULL, NULL, N'AC')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000001', 3, CAST(827.00 AS Decimal(7, 2)), N'AC  ', N'0000000659', CAST(N'2019-01-14 11:19:34.097' AS DateTime), N'c:\files\viaticos\solicitudes\0000000659\0000003\\reintegro 295.pdf  ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000002', 3, CAST(827.00 AS Decimal(7, 2)), N'CAN ', N'0000000659', CAST(N'2019-01-14 11:19:37.263' AS DateTime), N'c:\files\viaticos\solicitudes\0000000659\0000003\\reintegro 295.pdf  ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000003', 3, CAST(827.00 AS Decimal(7, 2)), N'AC  ', N'0000000659', CAST(N'2019-01-14 11:19:40.183' AS DateTime), N'c:\files\viaticos\solicitudes\0000000659\0000003\\reintegro 295.pdf  ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000004', 6, CAST(642.50 AS Decimal(7, 2)), N'AC  ', N'0000000335', CAST(N'2019-01-15 11:59:20.140' AS DateTime), N'c:\files\viaticos\solicitudes\0000000335\0000006\\Reintegro.pdf ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000005', 6, CAST(642.50 AS Decimal(7, 2)), N'AC  ', N'0000000335', CAST(N'2019-01-15 11:59:23.603' AS DateTime), N'c:\files\viaticos\solicitudes\0000000335\0000006\\Reintegro.pdf ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000006', 7, CAST(6751.61 AS Decimal(7, 2)), N'AC  ', N'0000000659', CAST(N'2019-01-15 12:57:24.150' AS DateTime), N'c:\files\viaticos\solicitudes\0000000659\0000007\\Reintegro.pdf ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000007', 7, CAST(6751.61 AS Decimal(7, 2)), N'AC  ', N'0000000659', CAST(N'2019-01-15 12:57:28.040' AS DateTime), N'c:\files\viaticos\solicitudes\0000000659\0000007\\Reintegro.pdf ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000008', 9, CAST(5944.00 AS Decimal(7, 2)), N'AC  ', N'0000001030', CAST(N'2019-01-21 12:06:07.253' AS DateTime), N'c:\files\viaticos\solicitudes\0000001030\0000009\\Reintegro_GCRV.pdf ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000009', 9, CAST(5944.00 AS Decimal(7, 2)), N'AC  ', N'0000001030', CAST(N'2019-01-21 12:06:10.983' AS DateTime), N'c:\files\viaticos\solicitudes\0000001030\0000009\\Reintegro_GCRV.pdf ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000010', 11, CAST(4313.00 AS Decimal(7, 2)), N'AC  ', N'0000001052', CAST(N'2019-01-23 12:14:41.153' AS DateTime), N'c:\files\viaticos\solicitudes\0000001052\0000011\\REINTEGRO.pdf ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000011', 11, CAST(4313.00 AS Decimal(7, 2)), N'AC  ', N'0000001052', CAST(N'2019-01-23 12:14:45.633' AS DateTime), N'c:\files\viaticos\solicitudes\0000001052\0000011\\REINTEGRO.pdf ', N'INSP ')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000012', 6, CAST(2630.84 AS Decimal(7, 2)), N'CAN ', N'0000000003', CAST(N'2019-03-05 15:02:21.027' AS DateTime), N'c:\files\viaticos\solicitudes\0000000003\6\\Pago IICA 228.23.pdf', N'MF')
--INSERT [dbo].[Viaticos_Deposito_Caja] ([de_id], [de_idSolicitud], [de_importe], [Es_Cve_Estado], [Oper_Alta], [Fecha_Alta], [url_Comprobante], [de_proyecto]) VALUES (N'0000013', 4, CAST(3756.00 AS Decimal(7, 2)), N'CER ', N'0000000003', CAST(N'2019-03-05 19:07:43.353' AS DateTime), N'c:\files\viaticos\solicitudes\0000000003\4\\Solicitud-I4-2.pdf  ', N'MF')
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000001', N'0000001', N'0000003', N'1', N'sin comentario  ', N'SIRAHI MORALES VELEZ', CAST(N'2019-01-14 11:18:02.397' AS DateTime), CAST(1508.62 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(1750.00 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000000659\0000003\ALIMENTOS 502 FACTURA.pdf', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000002', N'0000001', N'0000004', N'2', N'sin comentario  ', N'AEROVIAS DE MEXICO SA DE CV', CAST(N'2019-01-14 11:18:02.397' AS DateTime), CAST(862.50 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(1000.00 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000000659\0000003\TRANSPORTE CANINO F-1391501427504 TICKET.pdf', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000003', N'0000002', N'0000003', N'1', N'sin comentario  ', N'ANTONIO ALFONSO SEDAS HANDALL ', CAST(N'2019-01-15 11:52:53.897' AS DateTime), CAST(334.05 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(387.50 AS Decimal(7, 2)), NULL, NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000004', N'0000002', N'0000001', N'2', N'sin comentario  ', N'IMPORTADORA TRIPOLI SA DE CV  ', CAST(N'2019-01-15 11:52:53.897' AS DateTime), CAST(1613.44 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(1920.00 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000000335\0000006\ALIMENTOS 48EC FACTURA.pdf  ', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000005', N'0000003', N'0000003', N'1', N'sin comentario  ', N'GONZALO MARRUFO RIVERO', CAST(N'2019-01-15 12:51:18.737' AS DateTime), CAST(275.85 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(319.99 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000000659\0000007\ALIMENTOS 699B SAT.pdf ', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000006', N'0000004', N'0000003', N'3', N'sin comentario  ', N'JOHAN DESPREZ ', CAST(N'2019-01-15 12:52:15.443' AS DateTime), CAST(344.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(399.04 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000000659\0000007\ALIMENTOS ABD7 FACTURA.pdf  ', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000008', N'0000006', N'0000003', N'1', N'ALIMENTOS  ', N'JOAQUIN HEREDIA VELEZ ', CAST(N'2019-01-21 11:53:25.633' AS DateTime), CAST(74.14 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(86.00 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000001030\0000009\Alimentos 9374E Factura.pdf ', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000010', N'0000008', N'0000001', N' ', N'sin comentario  ', N'DESARROLLO DE PROYECTOS NOVEL FIESTA SA DE CV ', CAST(N'2019-03-05 14:55:57.520' AS DateTime), CAST(2637.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(3111.66 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000000003\6\Hospedaje (70897).pdf', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000011', N'0000012', N'0000001', N' ', N'sin comentario  ', N'ZEFERINO ROSILES HERNANDEZ ', CAST(N'2019-03-05 19:07:11.550' AS DateTime), CAST(2150.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(2494.00 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000000003\4\ROHZ841116HD7FCFDI0000001705.pdf  ', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000007', N'0000005', N'0000004', N'4', N'TAXI  ', N'RICARDO HERNANDEZ SOTO', CAST(N'2019-01-15 12:53:35.537' AS DateTime), CAST(240.83 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(279.36 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000000659\0000007\TAXI 01052 FACTURA.pdf ', NULL)
--INSERT [dbo].[Viaticos_Gasto] ([ga_Id], [id_comprobacion], [id_TipoGastos], [ga_Referencia], [ga_Comentario], [ga_Proveedor], [ga_fecha], [ga_subtotal], [ga_impuesto], [ga_importe], [ga_url_factura], [ga_lugar]) VALUES (N'0000009', N'0000007', N'0000004', N'1', N'TRANSPORTE ', N'AUTOBUSES ESTRELLA BLANCA,S.A. DE C.V.', CAST(N'2019-01-23 12:07:58.233' AS DateTime), CAST(83.62 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(97.00 AS Decimal(7, 2)), N'c:\files\viaticos\solicitudes\0000001052\0000011\RECIBO DE GASTOS NO COMPROBABLES.pdf', NULL)
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000001', 1, CAST(8000.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000002', 2, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000003', 3, CAST(0.00 AS Decimal(7, 2)), CAST(1027.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000004', 4, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(300.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000005', 5, CAST(2322.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000006', 6, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(400.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000007', 7, CAST(4500.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(100.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000008', 8, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000009', 9, CAST(5300.00 AS Decimal(7, 2)), CAST(2000.00 AS Decimal(7, 2)), CAST(600.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000010', 10, CAST(2500.00 AS Decimal(7, 2)), NULL, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000011', 11, CAST(3000.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000012', 1, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000013', 2, NULL, CAST(0.00 AS Decimal(7, 2)), CAST(300.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000014', 3, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000015', 4, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000016', 5, CAST(500.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000017', 6, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(300.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000018', 7, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(500.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000019', 8, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000020', 9, CAST(2500.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000021', 10, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000022', 11, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(200.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000023', 12, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(250.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000024', 13, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(250.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000025', 20, CAST(0.00 AS Decimal(7, 2)), CAST(800.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Importes_Extras] ([im_id], [id_solicitud], [im_transporte], [im_peaje_gasolina], [im_autobus], [im_otros], [im_otros_descripcion]) VALUES (N'0000026', 21, CAST(0.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), CAST(250.00 AS Decimal(7, 2)), CAST(0.00 AS Decimal(7, 2)), N' ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (1, 1, N'CD MEXICO', N'CANCÚN', N'Terrestre ', N'ETN', N'10', CAST(N'1970-01-01 04:00:00' AS SmallDateTime), CAST(N'1970-01-01 05:25:00' AS SmallDateTime), 12, CAST(9000 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (2, 1, N'GUADALAJARA', N'CD MEXICO', N'Terrestre ', N'ETN', N'20', CAST(N'1970-01-01 12:00:00' AS SmallDateTime), CAST(N'1970-01-01 20:00:00' AS SmallDateTime), 1, CAST(625 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (3, 2, N'CDMX', N'TEXCOCO  ', N'Terrestre ', N'1', N'3 ', CAST(N'1970-01-01 09:00:00' AS SmallDateTime), CAST(N'1970-01-01 11:00:00' AS SmallDateTime), 1, CAST(1700 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (4, 2, N'TEXCOCO  ', N'CDMX', N'Terrestre ', N'2', N'5 ', CAST(N'1970-01-01 05:00:00' AS SmallDateTime), CAST(N'1970-01-01 06:00:00' AS SmallDateTime), 1, CAST(850 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (5, 3, N'CD MEXICO', N'MORELIA  ', N'Terrestre ', N'ETN', N'23', CAST(N'1970-01-01 07:00:00' AS SmallDateTime), CAST(N'1970-01-01 21:00:00' AS SmallDateTime), 2, CAST(3400 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (9, 5, N'CDMX', N'MORELOS  ', N'Terrestre ', N'10', N'5 ', CAST(N'1970-01-01 07:00:00' AS SmallDateTime), CAST(N'1970-01-01 08:00:00' AS SmallDateTime), 1, CAST(1700 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (10, 5, N'MORELOS  ', N'CDMX', N'Terrestre ', N'11', N'6 ', CAST(N'1970-01-01 10:00:00' AS SmallDateTime), CAST(N'1970-01-01 11:00:00' AS SmallDateTime), 1, CAST(850 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (11, 6, N'CDMX', N'TEXCOCO  ', N'Terrestre ', N'1234', N'12', CAST(N'1970-01-01 08:00:00' AS SmallDateTime), CAST(N'1970-01-01 09:00:00' AS SmallDateTime), 4, CAST(6800 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (12, 6, N'TEXCOCO  ', N'CDMX', N'Terrestre ', N'1234', N'13', CAST(N'1970-01-01 11:00:00' AS SmallDateTime), CAST(N'1970-01-01 12:00:00' AS SmallDateTime), 1, CAST(850 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (13, 7, N'CDMX', N'MORELOS  ', N'Terrestre ', N'1234', N'23', CAST(N'1970-01-01 08:00:00' AS SmallDateTime), CAST(N'1970-01-01 09:00:00' AS SmallDateTime), 1, NULL, N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (14, 7, N'MORELOS  ', N'CDMX', N'Terrestre ', N'1234', N'25', CAST(N'1970-01-01 10:00:00' AS SmallDateTime), CAST(N'1970-01-01 11:00:00' AS SmallDateTime), 1, NULL, N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (19, 10, N'CD MEXICO', N'CANCÚN', N'Terrestre ', N'ETN', N'001 ', CAST(N'1970-01-01 07:00:00' AS SmallDateTime), CAST(N'1970-01-01 14:00:00' AS SmallDateTime), 6, NULL, N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (20, 10, N'CANCÚN', N'GUADALAJARA', N'Terrestre ', N'HP', N'033 ', CAST(N'1970-01-01 04:00:00' AS SmallDateTime), CAST(N'1970-01-01 14:00:00' AS SmallDateTime), 0, NULL, N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (21, 10, N'GUADALAJARA', N'MORELIA  ', N'Terrestre ', N'ETN', N'20', CAST(N'1970-01-01 05:00:00' AS SmallDateTime), CAST(N'1970-01-01 19:00:00' AS SmallDateTime), 1, NULL, N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (22, 11, N'CDMX', N'TECAMAC  ', N'Terrestre ', N'ETN', N'15', CAST(N'1970-01-01 07:00:00' AS SmallDateTime), CAST(N'1970-01-01 08:00:00' AS SmallDateTime), 1, NULL, N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (23, 11, N'TECAMAC  ', N'CDMX', N'Terrestre ', N'ETN', N'1234', CAST(N'1970-01-01 14:00:00' AS SmallDateTime), CAST(N'1970-01-01 15:00:00' AS SmallDateTime), 1, NULL, N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (26, 13, N'CDMX', N'TOLUCA', N'Terrestre ', N'', N'  ', CAST(N'1970-01-01 06:00:00' AS SmallDateTime), CAST(N'1970-01-01 07:00:00' AS SmallDateTime), 5, NULL, N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (27, 13, N'TOLUCA', N'CDMX', N'Terrestre ', N'', N'  ', CAST(N'1970-01-01 10:00:00' AS SmallDateTime), CAST(N'1970-01-01 11:00:00' AS SmallDateTime), 0, NULL, N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (6, 3, N'CD MEXICO', N'MORELIA  ', N'Terrestre ', N'ETN', N'23', CAST(N'1970-01-01 04:30:00' AS SmallDateTime), CAST(N'1970-01-01 16:00:00' AS SmallDateTime), 1, CAST(850 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (7, 4, N'CDMX', N'GTO ', N'Terrestre ', N'FUTURA', N'35', CAST(N'1970-01-01 05:00:00' AS SmallDateTime), CAST(N'1970-01-01 10:00:00' AS SmallDateTime), 3, CAST(5100 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (8, 4, N'GTO ', N'CDMX', N'Terrestre ', N'FUTURA', N'24', CAST(N'1970-01-01 09:00:00' AS SmallDateTime), CAST(N'1970-01-01 14:00:00' AS SmallDateTime), 1, CAST(850 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (36, 21, N'CDMX', N'TEXCOC', N'Terrestre ', N'', N'  ', CAST(N'1970-01-01 08:00:00' AS SmallDateTime), CAST(N'1970-01-01 08:00:00' AS SmallDateTime), 2, CAST(3400 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (37, 21, N' TEXCOCO ', N'CDMX', N'Terrestre ', N'', N'  ', CAST(N'1970-01-01 10:00:00' AS SmallDateTime), CAST(N'1970-01-01 11:00:00' AS SmallDateTime), 0.5, CAST(850 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (15, 8, N'CD MEXICO', N'MORELIA  ', N'Terrestre ', N'ETN', N'001 ', CAST(N'1970-01-01 07:00:00' AS SmallDateTime), CAST(N'1970-01-01 08:00:00' AS SmallDateTime), 3, CAST(1650 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (16, 8, N'CD MEXICO', N'MORELIA  ', N'Terrestre ', N'ETN', N'23', CAST(N'1970-01-01 06:00:00' AS SmallDateTime), CAST(N'1970-01-01 12:00:00' AS SmallDateTime), 1, CAST(435 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (24, 12, N'CDMX', N'PUEBLA', N'Terrestre ', N'', N'  ', CAST(N'1970-01-01 05:00:00' AS SmallDateTime), CAST(N'1970-01-01 07:00:00' AS SmallDateTime), 5, NULL, N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (25, 12, N'PUEBLA', N'CDMX', N'Terrestre ', N'', N'  ', CAST(N'1970-01-01 14:00:00' AS SmallDateTime), CAST(N'1970-01-01 16:00:00' AS SmallDateTime), 0, NULL, N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (34, 20, N'more', N'uru ', N'Terrestre ', N'abejita', N'12', CAST(N'1970-01-01 09:00:00' AS SmallDateTime), CAST(N'1970-01-01 06:00:00' AS SmallDateTime), 1, NULL, N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (35, 20, N'uru ', N'more', N'Terrestre ', N'abejita', N'12', CAST(N'1970-01-01 10:00:00' AS SmallDateTime), CAST(N'1970-01-01 09:00:00' AS SmallDateTime), 0.5, NULL, N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (17, 9, N'CDMX', N'Querétaro', N'Aéreo', N'AM', N'123 ', CAST(N'1970-01-01 08:00:00' AS SmallDateTime), CAST(N'1970-01-01 09:30:00' AS SmallDateTime), 3, CAST(2250 AS Decimal(5, 0)), N'MXN', N'Ida  ')
--INSERT [dbo].[Viaticos_Itinerario] ([it_id], [vt_id], [it_origen], [it_destino], [it_medio], [it_aerolinea], [it_numero], [it_hora_salida], [it_hora_llegada], [it_dias], [it_importe], [it_moneda], [it_tipo]) VALUES (18, 9, N'Querétaro', N'CDMX', N'Aéreo', N'AM', N'1234', CAST(N'1970-01-01 10:00:00' AS SmallDateTime), CAST(N'1970-01-01 10:29:00' AS SmallDateTime), 1, CAST(625 AS Decimal(5, 0)), N'MXN', N'Regreso')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (2, N'CARLOS.VILLANUEVA', CAST(N'2019-01-14 10:43:10.923' AS DateTime), N'COM', N'0000001')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (3, N'CARLOS.VILLANUEVA', CAST(N'2019-01-14 11:00:52.713' AS DateTime), N'COM', N'0000002')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (3, N'0000000659', CAST(N'2019-01-14 11:19:34.100' AS DateTime), N'CER', N'0000003')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (4, N'CARLOS.VILLANUEVA', CAST(N'2019-01-14 12:34:46.777' AS DateTime), N'COM', N'0000006')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (5, N'CARLOS.VILLANUEVA', CAST(N'2019-01-14 16:38:04.033' AS DateTime), N'COM', N'0000007')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (6, N'CARLOS.VILLANUEVA', CAST(N'2019-01-15 11:32:26.760' AS DateTime), N'COM', N'0000008')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (6, N'0000000335', CAST(N'2019-01-15 11:59:20.140' AS DateTime), N'CER', N'0000009')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (6, N'0000000335', CAST(N'2019-01-15 11:59:23.607' AS DateTime), N'CER', N'0000010')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (7, N'CARLOS.VILLANUEVA', CAST(N'2019-01-15 12:29:08.320' AS DateTime), N'COM', N'0000011')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (9, N'CARLOS.VILLANUEVA', CAST(N'2019-01-21 10:24:04.817' AS DateTime), N'COM', N'0000014')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (9, N'0000001030', CAST(N'2019-01-21 12:06:07.257' AS DateTime), N'CER', N'0000015')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (9, N'0000001030', CAST(N'2019-01-21 12:06:10.983' AS DateTime), N'CER', N'0000016')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (10, N'CARLOS.VILLANUEVA', CAST(N'2019-01-23 10:59:31.673' AS DateTime), N'COM', N'0000017')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (11, N'0000001052', CAST(N'2019-01-23 12:14:41.153' AS DateTime), N'CER', N'0000020')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (11, N'0000001052', CAST(N'2019-01-23 12:14:45.637' AS DateTime), N'CER', N'0000021')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (1, N'CARLOS.VILLANUEVA', CAST(N'2019-02-28 17:59:55.107' AS DateTime), N'COM', N'0000022')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (2, N'CARLOS.VILLANUEVA', CAST(N'2019-03-04 13:12:55.970' AS DateTime), N'COM', N'0000023')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (3, N'CARLOS.VILLANUEVA', CAST(N'2019-03-04 14:00:42.940' AS DateTime), N'COM', N'0000024')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (5, N'CARLOS.VILLANUEVA', CAST(N'2019-03-05 12:15:44.280' AS DateTime), N'COM', N'0000025')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (6, N'CARLOS.VILLANUEVA', CAST(N'2019-03-05 14:32:26.910' AS DateTime), N'COM', N'0000027')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (21, N'CARLOS.VILLANUEVA', CAST(N'2019-03-11 17:19:45.803' AS DateTime), N'COM', N'0000032')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (3, N'0000000659', CAST(N'2019-01-14 11:19:37.263' AS DateTime), N'CER', N'0000004')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (9, N'CARLOS.VILLANUEVA', CAST(N'2019-03-07 11:47:18.957' AS DateTime), N'COM', N'0000031')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (8, N'CARLOS.VILLANUEVA', CAST(N'2019-03-05 17:57:38.297' AS DateTime), N'COM', N'0000029')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (3, N'0000000659', CAST(N'2019-01-14 11:19:40.183' AS DateTime), N'CER', N'0000005')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (7, N'0000000659', CAST(N'2019-01-15 12:57:24.150' AS DateTime), N'CER', N'0000012')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (7, N'0000000659', CAST(N'2019-01-15 12:57:28.040' AS DateTime), N'CER', N'0000013')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (8, N'CARLOS.VILLANUEVA', CAST(N'2019-01-23 11:14:19.920' AS DateTime), N'COM', N'0000018')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (11, N'CARLOS.VILLANUEVA', CAST(N'2019-01-23 11:18:53.317' AS DateTime), N'COM', N'0000019')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (4, N'CARLOS.VILLANUEVA', CAST(N'2019-03-05 14:22:40.793' AS DateTime), N'COM', N'0000026')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (6, N'0000000003', CAST(N'2019-03-05 15:02:21.027' AS DateTime), N'CER', N'0000028')
--INSERT [dbo].[Viaticos_Log_Estatus] ([id_solicitud], [Oper_Alta], [Fecha_Alta], [Es_Cve_Estado], [id_log]) VALUES (4, N'0000000003', CAST(N'2019-03-05 19:07:43.353' AS DateTime), N'CER', N'0000030')
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (1, NULL, N'0000000123', N'SI  ', N'SI  ', N'CAPACITACION', N'EMPLEADO CAPACITADO', N'Ofrecimiento de Director y/o Coordinador', 13, N' ', N'NO  ', N'NO  ', N'NO  ', CAST(17625 AS Decimal(5, 0)), N'MF', N'0000000123', CAST(N'2019-02-28 17:55:29.697' AS DateTime), N'0000000123', CAST(N'2019-02-28 17:55:29.697' AS DateTime), NULL, NULL, N'COMP', CAST(N'2019-02-01 00:00:00.000' AS DateTime), CAST(N'2019-02-14 00:00:00.000' AS DateTime), 1)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (2, NULL, N'0000000006', N'SI  ', N'SI  ', N'Curso ', N'Capacitación', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 1, N' ', N'NO  ', N'NO  ', N'NO  ', CAST(2550 AS Decimal(5, 0)), N'MF', N'0000000006', CAST(N'2019-03-04 13:09:22.287' AS DateTime), N'0000000006', CAST(N'2019-03-04 13:09:22.287' AS DateTime), NULL, NULL, N'COMP', CAST(N'2019-03-05 00:00:00.000' AS DateTime), CAST(N'2019-03-06 00:00:00.000' AS DateTime), 1)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (3, NULL, N'0000000006', N'SI  ', N'SI  ', N'PRUEBA', N'PRUEBA', N'Solicitud del representante o Institución  ', 3, N' ', N'NO  ', N'NO  ', N'NO  ', CAST(5277 AS Decimal(5, 0)), N'MF', N'0000000006', CAST(N'2019-03-04 13:56:31.237' AS DateTime), N'0000000006', CAST(N'2019-03-04 13:56:31.237' AS DateTime), NULL, NULL, N'COM', CAST(N'2019-03-06 00:00:00.000' AS DateTime), CAST(N'2019-03-09 00:00:00.000' AS DateTime), 1)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (6, NULL, N'0000000003', N'SI  ', N'SI  ', N'Capacitación', N'Curso ', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 5, N' ', N'NO  ', N'NO  ', N'NO  ', CAST(8050 AS Decimal(5, 0)), N'MF', N'0000000003', CAST(N'2019-03-05 14:18:32.017' AS DateTime), N'0000000003', CAST(N'2019-03-05 14:18:32.017' AS DateTime), NULL, NULL, N'CER', CAST(N'2019-03-15 00:00:00.000' AS DateTime), CAST(N'2019-03-20 00:00:00.000' AS DateTime), 1)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (4, NULL, N'0000000003', N'SI  ', N'NO  ', N'VIAJE ', N'TRABAJO', N'Solicitud del representante o Institución  ', 4, N' ', N'NO  ', N'NO  ', N'NO  ', CAST(6250 AS Decimal(5, 0)), N'MF', N'0000000003', CAST(N'2019-03-05 09:15:41.337' AS DateTime), N'0000000003', CAST(N'2019-03-05 09:15:41.337' AS DateTime), NULL, NULL, N'CER', CAST(N'2019-03-06 00:00:00.000' AS DateTime), CAST(N'2019-03-10 00:00:00.000' AS DateTime), 1)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (7, NULL, N'0000000003', N'SI  ', N'SI  ', N'Curso ', N'Curso ', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 1, N' ', N'SI  ', N'NO  ', N'NO  ', CAST(0 AS Decimal(5, 0)), N'MF', N'0000000003', CAST(N'2019-03-05 14:40:02.807' AS DateTime), N'0000000003', CAST(N'2019-03-05 14:40:02.807' AS DateTime), NULL, NULL, N'AC', CAST(N'2019-03-20 00:00:00.000' AS DateTime), CAST(N'2019-03-21 00:00:00.000' AS DateTime), 0)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (5, NULL, N'0000000006', N'SI  ', N'SI  ', N'Curso ', N'Capacitación', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 2, N' ', N'SI  ', N'NO  ', N'NO  ', CAST(2550 AS Decimal(5, 0)), N'MF', N'0000000006', CAST(N'2019-03-05 11:51:50.763' AS DateTime), N'0000000006', CAST(N'2019-03-05 11:51:50.763' AS DateTime), NULL, NULL, N'COM', CAST(N'2019-03-10 00:00:00.000' AS DateTime), CAST(N'2019-03-12 00:00:00.000' AS DateTime), 1)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (8, NULL, N'0000000003', N'SI  ', N'SI  ', N'prueba', N'prueba', N'Solicitud del representante o Institución  ', 4, N'prueba Quality', N'SI  ', N'NO  ', N'NO  ', CAST(2085 AS Decimal(5, 0)), N'MF', N'0000000003', CAST(N'2019-03-05 17:33:07.917' AS DateTime), N'0000000003', CAST(N'2019-03-05 17:33:07.917' AS DateTime), NULL, NULL, N'COMP', CAST(N'2019-03-01 00:00:00.000' AS DateTime), CAST(N'2019-03-05 00:00:00.000' AS DateTime), 1)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (9, NULL, N'0000000001', N'SI  ', N'NO  ', N'Asistir a Convención  ', N'Participación ', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 4, N' ', N'NO  ', N'NO  ', N'NO  ', CAST(5475 AS Decimal(5, 0)), N'MF', N'0000000001', CAST(N'2019-03-07 11:28:34.320' AS DateTime), N'0000000001', CAST(N'2019-03-07 11:28:34.320' AS DateTime), NULL, NULL, N'COMP', CAST(N'2019-03-16 00:00:00.000' AS DateTime), CAST(N'2019-03-20 00:00:00.000' AS DateTime), 1)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (12, NULL, N'0000000001', N'SI  ', N'SI  ', N'Asistir a Curso  ', N'Capacitación', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 5, N' ', N'SI  ', N'NO  ', N'NO  ', CAST(0 AS Decimal(5, 0)), N'MF', N'0000000001', CAST(N'2019-03-11 12:57:17.770' AS DateTime), N'0000000001', CAST(N'2019-03-11 12:57:17.770' AS DateTime), NULL, NULL, N'AC', CAST(N'2019-03-15 00:00:00.000' AS DateTime), CAST(N'2019-03-20 00:00:00.000' AS DateTime), 0)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (10, NULL, N'0000000012', N'SI  ', N'SI  ', N'prueba', N'prueba', N'Solicitud del representante o Institución  ', 7, N'prueba', N'NO  ', N'NO  ', N'NO  ', CAST(0 AS Decimal(5, 0)), N'MF', N'0000000012', CAST(N'2019-03-07 15:57:22.230' AS DateTime), N'0000000012', CAST(N'2019-03-07 15:57:22.230' AS DateTime), NULL, NULL, N'PRE', CAST(N'2019-03-01 00:00:00.000' AS DateTime), CAST(N'2019-03-08 00:00:00.000' AS DateTime), 0)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (11, NULL, N'0000000001', N'SI  ', N'SI  ', N'Asistir a Curso  ', N'Capacitación', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 0, N' ', N'SI  ', N'NO  ', N'NO  ', CAST(0 AS Decimal(5, 0)), N'MF', N'0000000001', CAST(N'2019-03-08 13:12:20.480' AS DateTime), N'0000000001', CAST(N'2019-03-08 13:12:20.480' AS DateTime), NULL, NULL, N'PRE', CAST(N'2019-03-09 00:00:00.000' AS DateTime), CAST(N'2019-03-09 00:00:00.000' AS DateTime), 0)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (13, NULL, N'0000000002', N'SI  ', N'SI  ', N'Asistir a Curso  ', N'cURSO ', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 5, N' ', N'NO  ', N'NO  ', N'NO  ', CAST(0 AS Decimal(5, 0)), N'MF', N'0000000002', CAST(N'2019-03-11 14:20:49.003' AS DateTime), N'0000000002', CAST(N'2019-03-11 14:20:49.003' AS DateTime), NULL, NULL, N'AC', CAST(N'2019-03-15 00:00:00.000' AS DateTime), CAST(N'2019-03-20 00:00:00.000' AS DateTime), 0)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (20, NULL, N'0000000008', N'SI  ', N'SI  ', N'rgd', N'dfgdfg', N'Solicitud del representante o Institución  ', 1, N'dfgdg ', N'NO  ', N'NO  ', N'NO  ', CAST(0 AS Decimal(5, 0)), N'MF', N'0000000008', CAST(N'2019-03-11 16:30:32.097' AS DateTime), N'0000000008', CAST(N'2019-03-11 16:30:32.097' AS DateTime), NULL, NULL, N'AC', CAST(N'2019-03-11 00:00:00.000' AS DateTime), CAST(N'2019-03-12 00:00:00.000' AS DateTime), 0)
--INSERT [dbo].[Viaticos_Solicitud] ([vt_id], [vt_folio], [usr_deudor], [vt_isNacional], [vt_isTerrestre], [vt_proposito], [vt_resultado], [vt_justificacion], [vt_duracion], [vt_especiales], [vt_gastos_pendiente], [vt_informe_pendiente], [vt_marginal], [vt_importe], [vt_prefijo], [Oper_Alta], [Fecha_Alta], [Oper_Ult_Modif], [Fecha_Ult_Modif], [Oper_Baja], [Fecha_Baja], [Es_Cve_Estado], [vt_fecha_inicio], [vt_fecha_fin], [vt_pernocta]) VALUES (21, NULL, N'0000000010', N'SI  ', N'SI  ', N'Curso 2', N'Capacitacion 2', N'Mecanismo de Programación, supervisión, Auditoria y Evaluación  ', 2, N' ', N'NO  ', N'NO  ', N'NO  ', CAST(4500 AS Decimal(5, 0)), N'MF', N'0000000010', CAST(N'2019-03-11 17:17:31.880' AS DateTime), N'0000000010', CAST(N'2019-03-11 17:17:31.880' AS DateTime), NULL, NULL, N'COMP', CAST(N'2019-03-11 00:00:00.000' AS DateTime), CAST(N'2019-03-13 00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Viaticos_Tipo_Gasto] ([id_Tipo_Gasto], [tg_Descripcion]) VALUES (N'0000001', N'Hotel')
INSERT [dbo].[Viaticos_Tipo_Gasto] ([id_Tipo_Gasto], [tg_Descripcion]) VALUES (N'0000004', N' Transporte ')
INSERT [dbo].[Viaticos_Tipo_Gasto] ([id_Tipo_Gasto], [tg_Descripcion]) VALUES (N'0000003', N'Alimentos ')
INSERT [dbo].[Viaticos_Tipo_Gasto] ([id_Tipo_Gasto], [tg_Descripcion]) VALUES (N'0000005', N'Gasolina  ')
INSERT [dbo].[Viaticos_Tipo_Gasto] ([id_Tipo_Gasto], [tg_Descripcion]) VALUES (N'0000006', N'Peaje')
INSERT [dbo].[Viaticos_Tipo_Gasto] ([id_Tipo_Gasto], [tg_Descripcion]) VALUES (N'0000007', N'')
