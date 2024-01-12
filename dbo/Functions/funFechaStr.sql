/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           11 Enero del 2024
-- Descripción:		Función | Convierte una fecha en string con un formato específico
--                  Formato 1  : 13/01/2021
--                  Formato 2  : 13/01/2021 08:23
--                  Formato 3  : 13/Enero/2021
--                  Formato 4  : 13/Enero/2021 08:23
--                  Formato 5  : 13/Ene/2021
--                  Formato 6  : 13/Ene/2021 08:23
--                  Formato 7  : 01/13/2021
--                  Formato 8  : 01/13/2021 08:23
--                  Formato 9  : 13 de Enero del 2021
--                  Formato 10 : 13 de Enero del 2021 a las 08:23:58
--                  Formato 11 : Sábado, 13 de Enero del 2021
--                  Formato 12 : Sábado, 13 de Enero del 2021 a las 08:23:58
--                  Formato 13 : 13 de Ene del 2021
--                  Formato 14 : 13 de Ene del 2021 a las 08:23
--                  Formato 15 : Sab, 13 de Ene del 2021
--                  Formato 16 : Sab, 13 de Ene del 2021 a las 08:23
--                  Formato 20 : 2021-01-13                                         --> FORMATO DE BASE DE DATOS
--                  Formato 21 : 2021-01-13 08:23                                   --> FORMATO DE BASE DE DATOS (CON HORA)
--                  Formato 22 : 2021-01-13 08:23:58                                --> FORMATO DE BASE DE DATOS (CON HORA-SEG)
--                  Formato 23 : 2021-01-13T08:23:58                                --> FORMATO LOG
/*==================================================================================================*/

CREATE FUNCTION [dbo].[funFechaStr]
(
    @Fecha              datetime,           --*** Fecha
    @Formato            int,                --*** Formato
    @Separador          varchar(5)          --*** Separador de Fecha    : Usar # para el espacio
)

RETURNS VARCHAR(MAX)

--# WITH ENCRYPTION

AS

BEGIN

    set @Fecha = iif (isdate(@Fecha) = 0, '1900-01-01', @Fecha)

    declare @StrFecha varchar(100) = ''

    if isdate(@Fecha) = 0 return ''

    --*** por default separa por "/"
    set @Separador			= iif (dbo.funStrLong(@Separador) = 0, '/' , @Separador)
    set @Separador			= replace(@Separador, '#',' ')

    declare @Anio			int         = year(@Fecha)
    declare @Mes			int         = month(@Fecha)
    declare @Dia			int         = day(@Fecha)

    declare @Hora			int         = datepart(hour, @Fecha)
    declare @Minuto			int         = datepart(minute, @Fecha)
    declare @Segundo		int         = datepart(second, @Fecha)

    declare @MiliSegundo	int         = datepart(millisecond, @Fecha)


    declare @DiaSemana		int         = datepart(dw, @Fecha)
    
    declare @DiaLong		varchar(20) = ''
    declare @DiaShort		varchar(20) = ''
    declare @MesLong		varchar(20) = ''
    declare @MesShort		varchar(20) = ''
    declare @Tiempo			varchar(20) = ''
    declare @TiempoSeg		varchar(20) = ''

    --*** Mes largo
    set @MesLong =
        case @Mes
            when 1  then    'Enero'
            when 2  then    'Febrero'
            when 3  then    'Marzo'
            when 4  then    'Abril'
            when 5  then    'Mayo'
            when 6  then    'Junio'
            when 7  then    'Julio'
            when 8  then    'Agosto'
            when 9  then    'Septiembre'
            when 10 then    'Octubre'
            when 11 then    'Noviembre'
            when 12 then    'Dicimebre'
            else            '###'
        end

    --*** Mes Corto
    set @MesShort = substring(@MesLong, 1, 3)

    --*** Día largo
    set @DiaLong = 
        case @DiaSemana
			When 1  then    'Domingo'
			When 2  then    'Lunes'
			When 3  then    'Martes'
			When 4  then    'Miércoles'
			When 5  then    'Jueves'
			When 6  then    'Viernes'
			When 7  then    'Sábado'
			else            '###'
		end

    --*** Día Corto
    set @DiaShort = substring(@DiaLong, 1, 3)
    
    set @Tiempo =
        dbo.funStrCptr(dbo.funStrInt(@Hora), 2, 2, '0') + 
        ':' +
        dbo.funStrCptr(dbo.funStrInt(@Minuto), 2, 2, '0') 
            
    set @TiempoSeg =   
        @Tiempo +
        ':' +
        dbo.funStrCptr(dbo.funStrInt(@Segundo), 2, 2, '0')

	if isnull(@MiliSegundo,0) > 0 begin
		set @TiempoSeg +=  '.' + dbo.funStrInt(@MiliSegundo)
	end

    -- 13/01/2021
    if @Formato = 1 begin
        
        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            @Separador + 
            dbo.funStrInt(@Anio)

    -- 13/01/2021 08:23
    end else if @Formato = 2 begin
        
        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            @Separador + 
            dbo.funStrInt(@Anio) +
            ' ' +
            @Tiempo

    -- 13/Enero/2021
    end else if @Formato = 3 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            @MesLong + 
            @Separador + 
            dbo.funStrInt(@Anio)
    
    -- 13/Enero/2021 08:23
    end else if @Formato = 4 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            @MesLong + 
            @Separador + 
            dbo.funStrInt(@Anio) +
            ' ' +
            @Tiempo

    -- 13/Ene/2021
    end else if @Formato = 5 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            @MesShort + 
            @Separador + 
            dbo.funStrInt(@Anio)

    -- 13/Ene/2021 08:23
    end else if @Formato = 6 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            @MesShort + 
            @Separador + 
            dbo.funStrInt(@Anio) +
            ' ' +
            @Tiempo

    -- 01/13/2021
    end else if @Formato = 7 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            @Separador + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            dbo.funStrInt(@Anio)

    -- 01/13/2021 08:23
    end else if @Formato = 8 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            @Separador + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            dbo.funStrInt(@Anio) +
            ' ' +
            @Tiempo

    -- 13 de Enero del 2021
    end else if @Formato = 9 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            ' de ' + 
            @MesLong + 
            ' del ' + 
            dbo.funStrInt(@Anio)
    
    -- 13 de Enero del 2021 a las 08:23:58
    end else if @Formato = 10 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            ' de ' + 
            @MesLong + 
            ' del ' + 
            dbo.funStrInt(@Anio) +
            ' a las ' +
            @TiempoSeg

    -- Sábado, 13 de Enero del 2021
    end else if @Formato = 11 begin

        set @StrFecha = 
            @DiaLong + ', ' + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            ' de ' + 
            @MesLong + 
            ' del ' + 
            dbo.funStrInt(@Anio) 

    -- Sábado, 13 de Enero del 2021 a las 08:23:58
    end else if @Formato = 12 begin

        set @StrFecha = 
            @DiaLong + ', ' + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            ' de ' + 
            @MesLong + 
            ' del ' + 
            dbo.funStrInt(@Anio) +
            ' a las ' +
            @TiempoSeg

    -- 13 de Ene del 2021
    end else if @Formato = 13 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            ' de ' + 
            @MesShort + 
            ' del ' + 
            dbo.funStrInt(@Anio)
    
    -- 13 de Ene del 2021 a las 08:23
    end else if @Formato = 14 begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            ' de ' + 
            @MesShort + 
            ' del ' + 
            dbo.funStrInt(@Anio) +
            ' a las ' +
            @Tiempo

    -- Sab, 13 de Ene del 2021
    end else if @Formato = 15 begin

        set @StrFecha = 
            @DiaShort + ', ' + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            ' de ' + 
            @MesShort + 
            ' del ' + 
            dbo.funStrInt(@Anio)

    -- Sab, 13 de Ene del 2021 a las 08:23
    end else if @Formato = 16 begin

        set @StrFecha = 
            @DiaShort + ', ' + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            ' de ' + 
            @MesShort + 
            ' del ' + 
            dbo.funStrInt(@Anio) +
            ' a las ' +
            @Tiempo

    -- 2021-01-13               --> FORMATO DE BASE DE DATOS
    end else if @Formato = 20 begin

        set @StrFecha = 
            dbo.funStrInt(@Anio) + 
            '-' + 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            '-' + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') 

    -- 2021-01-13   08:23       --> FORMATO DE BASE DE DATOS (CON HORA)
    end else if @Formato = 21 begin

        set @StrFecha = 
            dbo.funStrInt(@Anio) + 
            '-' + 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            '-' + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') +
            ' ' +
            @Tiempo 

    -- 2021-01-13   08:23:58    --> FORMATO DE BASE DE DATOS (CON HORA)
    end else if @Formato = 22 begin

        set @StrFecha = 
            dbo.funStrInt(@Anio) + 
            '-' + 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            '-' + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') +
            ' ' +
            @TiempoSeg

    -- 2021-01-13T08:23:58      --> FORMATO LOG
    end else if @Formato = 23 begin

        set @StrFecha = 
            dbo.funStrInt(@Anio) + 
            '-' + 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            '-' + 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') +
            'T' +
            @TiempoSeg

    end else begin

        set @StrFecha = 
            dbo.funStrCptr(dbo.funStrInt(@Dia), 2, 2, '0') + 
            @Separador + 
            dbo.funStrCptr(dbo.funStrInt(@Mes), 2, 2, '0') + 
            @Separador + 
            dbo.funStrInt(@Anio)

    end

    RETURN @strFecha

END

