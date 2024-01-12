/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           11 de Enero del 2024
-- Descripción:		Función | Obtiene la longitud de una cadena
/*==================================================================================================*/
CREATE FUNCTION [dbo].[funStrLong]
(
    @Cadena             varchar(max)        --*** Texto
)

RETURNS VARCHAR(MAX)

WITH ENCRYPTION

AS

BEGIN

    set @Cadena = dbo.funStr(@Cadena)

    RETURN len(@Cadena)

END

