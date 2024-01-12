/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           11 Enero del 2024
-- Descripción:		Función | Completa una cadena con caracteres
/*==================================================================================================*/
CREATE FUNCTION [dbo].[funStrCptr]
(
    @Texto              varchar(max),       --*** Texto a completar
    @Longitud           int,                --*** Longitud de la cadena
    @Alineacion         int,                --*** Alineación de la cadena : 1 - Izquierda, 2 - Derecha
    @Caracter           char(1)             --*** Caracter con el que se completará
)

RETURNS VARCHAR(MAX)

WITH ENCRYPTION

AS

BEGIN

    set @Texto = ltrim(rtrim(@Texto))

    --*** Si llega null o vacío por default se completa con espacio
    set @Caracter = iif(len(rtrim(ltrim(isnull(@Caracter,'')))) = 0, ' ', @Caracter)

    --*** Si llega null o cero por default se alinea a la izquierda
    set @Alineacion = iif(isnull(@Alineacion,0) not in (1,2), 1, @Alineacion)

    --*** Si la longitud llega null, cero o menor a la longitud del texto
    set @Longitud = iif(isnull(@Longitud,0) <= len(@Texto), len(@Texto), @Longitud)

    set @Texto = iif(@Alineacion = 1, @Texto + replicate(@Caracter, @Longitud - len(@Texto)), replicate(@Caracter, @Longitud - len(@Texto)) + @Texto)

    RETURN @Texto

END

