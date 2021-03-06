USE [IICA_1]
GO
/****** Object:  StoredProcedure [dbo].[DT_SP_ACTUALIZAR_VACACIONES]    Script Date: 09/03/2019 05:50:16 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Christian Peña Romero>
-- Description:	<Insertar o actualizar una solicitud de vacaciones>
-- =============================================
ALTER PROCEDURE [dbo].[DT_SP_ACTUALIZAR_VACACIONES]
	-- Add the parameters for the stored procedure here
		@Id_Vacaciones INT=null,
		@Periodo_Anterior INT=null,
		@Proporcional INT=null,
		@Total_Dias_Saldo_Vacacional INT=null,
		@Fecha_Solicitud DATETIME=null,
		@Fecha_Inicio DATE=null,
		@Fecha_Fin DATE=null,
		@Total_Dias INT=null,
		@Motivo_Vacaciones VARCHAR(1000)=null,
		@Id_Status_Solicitud INT=null,
		@Motivo_Rechazo VARCHAR(1000)=null,
		@Em_Cve_Empleado varchar(100)=null,
		@Em_Cve_Empleado_Autoriza varchar(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE 
		@status int=0,
		@mensaje varchar(250)='',
		@proyecto_empleado varchar (10),
		@Total_Dias_Solicitud INT,
		@Saldo_Periodo_Anterior_Usado INT,
		@Saldo_Proporcional_Actual_Usado INT,
		@Saldo_Periodo_Anterior INT,
		@Saldo_Proporcional_Actual INT,
		@Saldo_Actual_Disponible INT


	IF(@Id_Vacaciones is null or @Id_Vacaciones=0)
	BEGIN

		--1.-Obtenemos la información del proyecto del empleado que esta solicitando las vacaciones
		select @proyecto_empleado=Sucursal.Sc_UserDef_2
		from Empleado emp
		inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal
		where Em_UserDef_1=@Em_Cve_Empleado

		IF(@proyecto_empleado is null)
		BEGIN
			SET @mensaje='EL EMPLEADO NO HA SIDO ASIGNADO A UN PROYETO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END

		--2.-Revisamos que exista un autorizador para este proyecto
		
		select @Em_Cve_Empleado_Autoriza=Em_Cve_Empleado
		from IICA_COMPRAS.dbo.Viaticos_Autorizadores
		where aut_nivel='D'
		and aut_proyecto=@proyecto_empleado

		IF(@Em_Cve_Empleado_Autoriza is null)
		BEGIN
			SET @mensaje='NO EXISTEN AUTORIZADORES PARA EL PROYECTO, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END
		--Se valida el saldo vacacional
		IF @Total_Dias>(SELECT (Saldo_Periodo_Anterior -  Saldo_Periodo_Anterior_Usado)+(Saldo_Proporcional_Actual-Saldo_Proporcional_Actual_Usado) FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO WHERE Em_Cve_Empleado=@Em_Cve_Empleado AND Activo=1)
		BEGIN
			SET @mensaje='SU SALDO VACACIONAL ES MENOR A LOS DÍAS SOLICITADOS, CONTACTE A UN ADMINISTRADOR.'
			GOTO EXIT_
		END

		--3.-SE TERMINAN LAS VALIDACIONES, PROCEDEMOS A REALIZAR EL INSERT

		INSERT
			INTO DT_TBL_VACACIONES(
				Periodo_Anterior,
				Proporcional,
				Total_Dias_Saldo_Vacacional,
				Fecha_Solicitud,
				Fecha_Inicio,
				Fecha_Fin,
				Total_Dias,
				Motivo_Vacaciones,
				Id_Status_Solicitud,
				Motivo_Rechazo,
				Em_Cve_Empleado
				--,Em_Cve_Empleado_Autoriza
			)
			VALUES (
				@Periodo_Anterior,
				@Proporcional,
				@Total_Dias_Saldo_Vacacional,
				@Fecha_Solicitud,
				@Fecha_Inicio,
				@Fecha_Fin,
				@Total_Dias,
				@Motivo_Vacaciones,
				1,
				'',
				@Em_Cve_Empleado
				--,@Em_Cve_Empleado_Autoriza
			)

			IF @@ERROR<>0
			BEGIN
				SET @mensaje='ERROR AL GENERAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
				GOTO EXIT_
			END

			/**/
			
			SELECT
				@Saldo_Periodo_Anterior=Saldo_Periodo_Anterior,
				@Saldo_Actual_Disponible=Saldo_Actual_Disponible,
				@Saldo_Periodo_Anterior_Usado=Saldo_Proporcional_Actual_Usado,
				@Saldo_Proporcional_Actual=Saldo_Proporcional_Actual
			FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado
			AND Activo=1
			
			IF @Saldo_Periodo_Anterior>=@Total_Dias
				SET @Saldo_Periodo_Anterior=@Saldo_Periodo_Anterior-@Total_Dias
			ELSE
				SET @Saldo_Periodo_Anterior=0

			SET @Saldo_Actual_Disponible=@Saldo_Actual_Disponible-@Total_Dias

			UPDATE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			SET Saldo_Actual_Utilizado=Saldo_Actual_Utilizado+@Total_Dias,
			Saldo_Periodo_Anterior=@Saldo_Periodo_Anterior,
			Saldo_Actual_Disponible=@Saldo_Actual_Disponible,
			Saldo_Proporcional_Actual_Usado=Saldo_Proporcional_Actual_Usado+@Total_Dias
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado
			/**/

			SELECT @Id_Vacaciones=MAX(Id_Vacaciones)
			FROM DT_TBL_VACACIONES
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado

			UPDATE DT_TBL_VACACIONES
			SET Periodo_Anterior=@Saldo_Periodo_Anterior,
			Proporcional=@Saldo_Proporcional_Actual,
			Total_Dias_Saldo_Vacacional=@Saldo_Actual_Disponible
			WHERE Id_Vacaciones=@Id_Vacaciones

			SET @status=1
			SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'

			GOTO EXIT_
	END
	ELSE
	BEGIN
		--4.- SE TRATA DE UNA ACTUALIZACION DE LAS VACACIONES

		UPDATE DT_TBL_VACACIONES
		SET Id_Status_Solicitud=@Id_Status_Solicitud,
		Fecha_Actualizacion=GETDATE(),
		Motivo_Rechazo=@Motivo_Rechazo,
		Em_Cve_Empleado_Autoriza=@Em_Cve_Empleado_Autoriza
		WHERE Id_Vacaciones=@Id_Vacaciones

		IF @@ERROR<>0
		BEGIN
			SET @mensaje='ERROR AL ACTUALIZAR LA SOLICITUD, CONTACTE A SOPORTE TÉCNICO.'
			GOTO EXIT_
		END
				
		--4.1 SE CANCELA LA SOLICITUD
		IF @Id_Status_Solicitud=3
		BEGIN

			SELECT @Total_Dias=Total_Dias,@Em_Cve_Empleado=Em_Cve_Empleado FROM DT_TBL_VACACIONES WHERE Id_Vacaciones=@Id_Vacaciones

			SELECT 
				@Saldo_Periodo_Anterior=Saldo_Periodo_Anterior,
				@Saldo_Periodo_Anterior_Usado=Saldo_Periodo_Anterior_Usado,
				@Saldo_Proporcional_Actual=Saldo_Proporcional_Actual,
				@Saldo_Proporcional_Actual_Usado=Saldo_Proporcional_Actual_Usado
			FROM DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado

			IF @Total_Dias<=@Saldo_Proporcional_Actual_Usado
				SET @Saldo_Proporcional_Actual_Usado=@Saldo_Proporcional_Actual_Usado-@Total_Dias
			ELSE
			BEGIN
				SET @Saldo_Periodo_Anterior_Usado=(@Saldo_Periodo_Anterior_Usado+@Saldo_Proporcional_Actual_Usado)-@Total_Dias
				SET @Saldo_Proporcional_Actual_Usado=0
			END

			UPDATE DT_TBL_PERIODO_VACACIONAL_EMPLEADO
			SET Saldo_Actual_Utilizado=Saldo_Actual_Utilizado-@Total_Dias,
			Saldo_Actual_Disponible=Saldo_Actual_Disponible+@Total_Dias,
			Saldo_Periodo_Anterior_Usado=@Saldo_Periodo_Anterior_Usado,
			Saldo_Proporcional_Actual_Usado=@Saldo_Proporcional_Actual_Usado
			WHERE Em_Cve_Empleado=@Em_Cve_Empleado
			AND Activo=1

		END


		SET @status=1
		SET @mensaje='SOLICITUD GUARDADA CON ÉXITO.'
		GOTO EXIT_
	END

	Exit_: SELECT @status STATUS, @mensaje MENSAJE, coalesce(@Id_Vacaciones,0) ID_VACACIONES
END
