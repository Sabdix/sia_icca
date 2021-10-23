

USE IICA_1;
GO

-- se crea procedimiento DT_SP_INSERTA_SUCURSAL

IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE name LIKE 'DT_SP_INSERTA_SUCURSAL'
          AND xtype = 'p'
          AND DB_NAME() = 'IICA_1'
)
  DROP PROC DT_SP_INSERTA_SUCURSAL;
GO

/*********************
Autor			Autor
UsuarioRed		aaaa111111
Fecha			yyyymmdd
Objetivo		Objetivo
Proyecto		Proyecto
Ticket			ticket
*********************/

CREATE PROC DT_SP_INSERTA_SUCURSAL

-- parámetros
@Nombre VARCHAR(100)
AS
  BEGIN -- procedimiento

    BEGIN TRY -- try principal

      BEGIN -- inicio
        -- declaraciones
        DECLARE @status          INT          = 1, 
                @error_message   VARCHAR(255) = '', 
                @error_line      VARCHAR(255) = '', 
                @error_severity  VARCHAR(255) = '', 
                @error_procedure VARCHAR(255) = '';

        DECLARE @tran_name       VARCHAR(32) = 'INSERTA_SUCURSAL', 
                @tran_count      INT         = @@trancount, 
                @tran_scope      BIT         = 0, 
                @nvo_id          VARCHAR(8), 
                @last_id         VARCHAR(8), 
                @prefijo_general VARCHAR(4);
      END; -- inicio

      BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM Sucursal
            WHERE Sc_Descripcion = @Nombre
        )
          RAISERROR('Sucursal ya existente', 11, 0);
      END;

      BEGIN -- transacción

        BEGIN -- inicio

          IF @tran_count = 0
          BEGIN TRAN @tran_name;
          ELSE
            SAVE TRAN @tran_name;

          SELECT @tran_scope = 1;
        END; -- inicio

        BEGIN -- componente de la transacción

          SELECT TOP 1 @nvo_id = REPLICATE('0', 4 - LEN(RTRIM(CAST(MAX(Sc_Cve_Sucursal) AS INT) + 1))) + RTRIM(CAST(MAX(Sc_Cve_Sucursal) AS INT) + 1)
          FROM Sucursal;
          SELECT @last_id = MAX(Sc_Cve_Sucursal)
          FROM Sucursal;
          SELECT @prefijo_general = REPLICATE('0', 2 - LEN(RTRIM(CAST(MAX(Sc_Cve_Sucursal) AS INT) + 1))) + RTRIM(CAST(MAX(Sc_Cve_Sucursal) AS INT) + 1)
          FROM Sucursal;
          INSERT INTO Sucursal
                 SELECT @nvo_id, 
                        Zn_Cve_Zona, 
                        Em_Cve_Empresa, 
                        Gs_Cve_Grupo_Sucursal, 
                        Sc_Centro_Costo, 
                        Sc_Centro_Distribucion, 
                        Sc_Cuenta_Contable, 
                        Sc_Grupo_Impuesto, 
                        Sc_Condicion_Venta, 
                        @Nombre, 
                        Sc_Direccion_1, 
                        Sc_Direccion_2, 
                        Sc_Direccion_3, 
                        Sc_Ciudad, 
                        Sc_Municipio, 
                        Sc_Estado, 
                        Sc_Pais, 
                        Sc_Telefono_1, 
                        Sc_Telefono_2, 
                        Sc_Telefono_3, 
                        Sc_Gerente, 
                        Sc_Comentario, 
                        @prefijo_general, 
                        Sc_Factura_Serie, 
                        Sc_Nota_Credito_Serie, 
                        Sc_Comprobante_Pago_Serie, 
                        Sc_Factura_Serie_Web, 
                        Sc_Formato_Factura, 
                        Sc_Formato_Nota_Credito, 
                        Sc_Formato_Comprobante_Pago, 
                        Sc_Formato_Factura_Web, 
                        Sc_Sucursal_Remota, 
                        Sc_Url_Servidor_Remoto, 
                        Sc_Servidor_Id, 
                        Sc_Servidor, 
                        Sc_Usuario, 
                        Sc_Password, 
                        Sc_Empresa, 
                        Sc_Calle, 
                        Sc_Numero_Exterior, 
                        Sc_Numero_Interior, 
                        Sc_Colonia, 
                        Sc_Referencia, 
                        Sc_Municipio_Fiscal, 
                        Sc_Codigo_Postal, 
                        Sc_Razon_Social, 
                        Sc_Ciudad_Fiscal, 
                        Sc_Estado_Fiscal, 
                        Sc_Pais_Fiscal, 
                        Sc_R_F_C, 
                        Sc_Plantilla_Mail_CFD, 
                        Sc_Bcc_Mail_CFD, 
                        Sc_Call_Center_Webservice, 
                        Sc_Plantilla_XML, 
                        Sc_Plantilla_XML2, 
                        Sc_Latitud, 
                        Sc_Longitud, 
                        Sc_Recibo_Nomina_Serie, 
                        Sc_Formato_Recibo_Nomina, 
                        Sc_Analizar, 
                        Sc_UserDef_1, 
                        Sc_UserDef_2, 
                        Sc_UserDef_3, 
                        Sc_UserDef_4, 
                        Sc_UserDef_5, 
                        Sc_UserDef_6, 
                        Oper_Alta, 
                        Fecha_Alta, 
                        Oper_Ult_Modif, 
                        Fecha_Ult_Modif, 
                        Oper_Baja, 
                        Fecha_Baja, 
                        Es_Cve_Estado, 
                        Sc_Retencion_Serie, 
                        Sc_Formato_Retencion, 
                        Sc_Cve_Ciudad, 
                        Sc_Cve_Municipio, 
                        Sc_Cve_Estado, 
                        Sc_Cve_Pais, 
                        Sc_Cve_Colonia_Expedicion, 
                        Sc_Cve_Codigo_Postal_Expedicion, 
                        Sc_Cve_Colonia, 
                        Sc_Cve_Ciudad_Fiscal, 
                        Sc_Cve_Municipio_Fiscal, 
                        Sc_Cve_Estado_Fiscal, 
                        Sc_Cve_Pais_Fiscal, 
                        Sc_Cve_Codigo_Postal, 
                        Sc_Plantilla_Mail_CFD_Cancelado, 
                        Sc_Traslado_Serie, 
                        Sc_Formato_Traslado
                 FROM Sucursal
                 WHERE Sc_Cve_Sucursal = @last_id;
        END; -- componente de la transacción

        BEGIN -- estatus

          SELECT 'Sucursal creada exitosamente!' mensaje, 
                 CAST(1 AS BIT) STATUS;
        END; -- estatus

        BEGIN -- commit

          IF @tran_count = 0

            BEGIN -- si la transacción se inició dentro de este ámbito

              COMMIT TRAN @tran_name;
              SELECT @tran_scope = 0;
            END; -- si la transacción se inició dentro de este ámbito
        END; -- commit
      END;
    END TRY -- try principal
    BEGIN CATCH -- catch principal
      -- revertir transacción si es necesario
      IF @tran_scope = 1
        ROLLBACK TRAN @tran_name;

      SELECT ERROR_MESSAGE() mensaje, 
             CAST(0 AS BIT) STATUS;
    END CATCH; -- catch principal
  END; -- procedimiento
GO

GRANT EXEC ON DT_SP_INSERTA_SUCURSAL TO public;