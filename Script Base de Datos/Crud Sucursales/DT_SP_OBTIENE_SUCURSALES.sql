

USE [IICA_1];
GO

-- se crea procedimiento DT_SP_OBTIENE_SUCURSALES

IF EXISTS
(
    SELECT *
    FROM sysobjects
    WHERE name LIKE 'DT_SP_OBTIENE_SUCURSALES'
          AND xtype = 'p'
          AND DB_NAME() = '[IICA_1]'
)
  DROP PROC DT_SP_OBTIENE_SUCURSALES;
GO

/*********************
Autor			Autor
UsuarioRed		aaaa111111
Fecha			yyyymmdd
Objetivo		Objetivo
Proyecto		IICA`
Ticket			ticket
*********************/

CREATE PROC DT_SP_OBTIENE_SUCURSALES
AS
  BEGIN -- procedimiento

    BEGIN -- inicio
      SELECT Sc_Cve_Sucursal, 
             Sc_Descripcion,
             CASE
               WHEN Es_Cve_Estado = 'AC'
                 THEN CAST(1 AS BIT)
             ELSE CAST(0 AS BIT)
             END Es_Cve_Estado
      FROM Sucursal;
    END; -- fin 
  END; -- procedimiento

GO

GRANT EXEC ON DT_SP_OBTIENE_SUCURSALES TO public;