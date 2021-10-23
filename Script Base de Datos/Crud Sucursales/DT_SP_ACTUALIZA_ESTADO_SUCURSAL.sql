

USE IICA_1;
GO

-- se crea procedimiento DT_SP_ACTUALIZA_ESTADO_SUCURSAL

IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE name LIKE 'DT_SP_ACTUALIZA_ESTADO_SUCURSAL'
          AND xtype = 'p'
          AND DB_NAME() = 'IICA_1'
)
  DROP PROC DT_SP_ACTUALIZA_ESTADO_SUCURSAL;
GO

/*********************
Autor			Autor
UsuarioRed		aaaa111111
Fecha			yyyymmdd
Objetivo		Objetivo
Proyecto		Proyecto
Ticket			ticket
*********************/

CREATE PROC DT_SP_ACTUALIZA_ESTADO_SUCURSAL

-- parametros
@Clave VARCHAR(100)
AS
  BEGIN -- procedimiento

    BEGIN TRY -- try principal

      BEGIN -- validaciones			

        IF NOT EXISTS
        (
            SELECT 1
            FROM Sucursal
            WHERE Sc_Cve_Sucursal = @Clave
        )
          RAISERROR('Sucursal no eixstente', 11, 0);
      END; -- validaciones

      BEGIN -- inicio

        UPDATE Sucursal
          SET 
              Es_Cve_Estado = CASE
                                WHEN Es_Cve_Estado = 'AC'
                                  THEN 'BA'
                              ELSE 'AC'
                              END, 
              Fecha_Baja = CASE
                             WHEN Es_Cve_Estado = 'AC'
                               THEN CURRENT_TIMESTAMP
                           ELSE NULL
                           END
        WHERE Sc_Cve_Sucursal = @Clave;
      END; -- fin 

      BEGIN -- estatus

        SELECT 'Sucursal deshabilitada exitosamente!' mensaje, 
               CAST(1 AS BIT) STATUS;
      END; -- estatus
    END TRY -- try principal
    BEGIN CATCH -- catch principal
      -- declaraciones

      SELECT ERROR_MESSAGE() mensaje, 
             CAST(0 AS BIT) STATUS;
    END CATCH; -- catch principal		
  END; -- procedimiento

GO

GRANT EXEC ON DT_SP_ACTUALIZA_ESTADO_SUCURSAL TO public;