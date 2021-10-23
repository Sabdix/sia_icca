

USE IICA_1;
GO

-- se crea procedimiento DT_SP_ACTUALIZA_SUCURSAL

IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE name LIKE 'DT_SP_ACTUALIZA_SUCURSAL'
          AND xtype = 'p'
          AND DB_NAME() = 'IICA_1'
)
  DROP PROC DT_SP_ACTUALIZA_SUCURSAL;
GO

/*********************
Autor			Autor
UsuarioRed		aaaa111111
Fecha			yyyymmdd
Objetivo		Objetivo
Proyecto		Proyecto
Ticket			ticket
*********************/

CREATE PROC DT_SP_ACTUALIZA_SUCURSAL

-- parametros
@Clave  VARCHAR(100), 
@Nombre VARCHAR(100)
AS
  BEGIN -- procedimiento

    BEGIN TRY -- try principal

      BEGIN -- validaciones			
        IF EXISTS
        (
            SELECT 1
            FROM Sucursal
            WHERE Sc_Descripcion = @Nombre
        )
          RAISERROR('Ya existe una sucursal con ese nombre', 11, 0);

		 IF NOT EXISTS
        (
            SELECT 1
            FROM Sucursal
            WHERE Sc_Cve_Sucursal = @Clave
        )
          RAISERROR('La sucursal no exite', 11, 0);
      END; -- validaciones

      BEGIN -- inicio
        UPDATE Sucursal
          SET 
              Sc_Descripcion = @Nombre
        WHERE Sc_Cve_Sucursal = @Clave;
      END; -- fin 

      BEGIN -- estatus

        SELECT 'Sucursal actualizada exitosamente!' mensaje, 
               CAST(1 AS BIT) STATUS;
      END; -- estatus
    END TRY -- try principal
    BEGIN CATCH -- catch principal

      SELECT ERROR_MESSAGE() mensaje, 
             CAST(0 AS BIT) STATUS;
    END CATCH; -- catch principal		
  END; -- procedimiento

GO

GRANT EXEC ON DT_SP_ACTUALIZA_SUCURSAL TO public;