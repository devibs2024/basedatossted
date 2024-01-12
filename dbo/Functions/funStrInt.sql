/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           11 de Enero del 2024
-- Descripci�n:		Funci�n | Conversi�n de entero a cadena
/*==================================================================================================*/
CREATE FUNCTION [dbo].[funStrInt]
(
    @Numero             int                 --*** N�mero
)

RETURNS VARCHAR(MAX)

WITH ENCRYPTION

AS

BEGIN

    set @Numero = iif ( @Numero is null , 0, @Numero )

    return dbo.funStr(str(@Numero))

END

