/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           11 de Enero del 2024
-- Descripción:		Función | Control de cadena string
/*==================================================================================================*/
CREATE FUNCTION [dbo].[funStr]
(
    @Cadena             varchar(max)        --*** Texto
)

RETURNS VARCHAR(MAX)

WITH ENCRYPTION

AS

BEGIN

    set @Cadena = iif ( @Cadena is null , '', @Cadena )

    return ltrim(rtrim(@Cadena))

END

