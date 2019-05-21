use IICA_1
go

IF  NOT EXISTS(SELECT * FROM sys.columns 
	WHERE Name = N'Formato_RT_cuestionario' AND OBJECT_ID = OBJECT_ID(N'DT_TBL_INCAPACIDAD'))
BEGIN
	ALTER TABLE DT_TBL_INCAPACIDAD add Formato_RT_cuestionario varchar(400)
END