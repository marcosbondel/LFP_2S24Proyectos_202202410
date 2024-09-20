module LexerModule
    use HelperModule
    use TokenModule
    use ErrorModule
    use AppModule
    implicit none

    contains

        function checkLexeme(str_collector, current_character, row, column, tokens, tokens_count, errors, errors_count, current_country, current_continent, current_graph, continents_count, str_context) result(isALexeme)
            implicit none

            character(len=:), intent(inout), allocatable :: str_collector, str_context
            character(len=*), intent(in) :: current_character
            character(len=:), allocatable :: aux_str_collector
            integer, intent(in) :: row, column
            integer, intent(inout) :: tokens_count, errors_count, continents_count
            logical :: isALexeme
            type(Token), intent(inout), allocatable :: tokens(:) ! Tokens data persistence
            type(Error), intent(inout), allocatable :: errors(:) ! Errors data persistence
            type(Token) :: new_lexeme
            type(Error) :: new_error
            type(Country), intent(inout) :: current_country
            type(Continent), intent(inout) :: current_continent
            type(Graph), intent(inout) :: current_graph
            real :: continent_saturation


            isALexeme = .false.

            if(to_lower_case(str_collector) == "grafica") then
                str_context = str_context // "grafica"
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "grafica"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == ":") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = ":"
                new_lexeme%lex_type = "DOS_PUNTOS"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == ";") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = ";"
                new_lexeme%lex_type = "PUNTO_Y_COMA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "{") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "{"
                new_lexeme%lex_type = "LLAVE_ABIERTA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "}") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "}"
                new_lexeme%lex_type = "LLAVE_CERRADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(trim(to_lower_case(str_collector)) == "nombre") then
                str_context = str_context // ";" // "nombre"
                
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "nombre"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(to_lower_case(str_collector) == "continente") then
                str_context = "grafica;continente"

                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "continente"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(to_lower_case(str_collector) == "pais") then
                str_context = str_context // ";" // "pais"

                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "pais"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(to_lower_case(str_collector) == "bandera") then
                str_context = str_context // ";" // "bandera"

                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "bandera"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(to_lower_case(str_collector) == "poblacion") then
                str_context = str_context // ";" // "poblacion"

                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "poblacion"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(to_lower_case(str_collector) == "saturacion") then
                str_context = str_context // ";" // "saturacion"

                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "saturacion"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call add_token(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(current_character == "%") then

                ! we check if the previous content of the character "%" is a valid number
                ! if so we save it as a "real"/"numeric" token
                if(isANumericValue(str_collector(1: len_trim(str_collector) - 1))) then
                    tokens_count = tokens_count + 1

                    aux_str_collector = str_collector(1: len_trim(str_collector) - 1)

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = str_collector(1: len_trim(str_collector) - 1)
                    new_lexeme%lex_type = "NUMERO"
                    new_lexeme%row = row
                    new_lexeme%column = column
                    
                    call add_token(size(tokens), new_lexeme, tokens)
                    call add_field_value(current_graph, current_continent, current_country, aux_str_collector, str_context)

                    tokens_count = tokens_count + 1

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = "%"
                    new_lexeme%lex_type = "PORCENTAJE"
                    new_lexeme%row = row
                    new_lexeme%column = column
                    
                    call add_token(size(tokens), new_lexeme, tokens)

                    isALexeme = .true.
                end if

            else if(current_character == ";") then

                ! we check if the previous content of the character ";" is a valid number
                ! if so we save it as a "real"/"numeric" token
                if(isANumericValue(str_collector(1: len_trim(str_collector) - 1))) then
                    tokens_count = tokens_count + 1

                    aux_str_collector = str_collector(1: len_trim(str_collector) - 1)

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = aux_str_collector
                    new_lexeme%lex_type = "NUMERO"
                    new_lexeme%row = row
                    new_lexeme%column = column
                    
                    call add_token(size(tokens), new_lexeme, tokens)
                    call add_field_value(current_graph, current_continent, current_country, aux_str_collector, str_context)
                    
                    tokens_count = tokens_count + 1

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = ";"
                    new_lexeme%lex_type = "PUNTO_Y_COMA"
                    new_lexeme%row = row
                    new_lexeme%column = column

                    call add_token(size(tokens), new_lexeme, tokens)
                
                    isALexeme = .true.
                end if
            else
                if(current_character /= ' ' .and. current_character /= '\t' .and. &
                    current_character /= '\r' .and. current_character /= '\f' .and. current_character /= char(9) .and. &
                    current_character /= '\0' .and. .not. ((current_character >= 'a' .and. current_character <= 'z') .or. &
                    (current_character >= 'A' .and. current_character <= 'Z')) .and. &
                    .not. isANumericValue(current_character) .and. &
                    current_character /= '"' .and. &
                    .not. (str_collector(1:1) == '"' .or. str_collector(len(str_collector):len(str_collector)) == '"')) then
                
                    errors_count = errors_count + 1

                    new_error%no = errors_count
                    new_error%err = current_character
                    new_error%description = "Elemento Lexico desconocido"
                    new_error%row = row
                    new_error%column = column

                    call add_error(size(errors), new_error, errors)

                    str_collector = ""
                end if
            end if
            
            if(current_character == '"') then
                
                ! TODO: analyze strings separately
                if(len(str_collector) > 1 .and. str_collector(1:1) == '"' .and. str_collector(len(str_collector):len(str_collector)) == '"') then
                    tokens_count = tokens_count + 1

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = str_collector
                    new_lexeme%lex_type = "CADENA"
                    new_lexeme%row = row
                    new_lexeme%column = column

                    call add_token(size(tokens), new_lexeme, tokens)

                    aux_str_collector = str_collector(2: len_trim(str_collector) - 1)

                    call add_field_value(current_graph, current_continent, current_country, aux_str_collector, str_context)

                    
                    isALexeme = .true.
                end if
            else
                ! if (current_character /= ' ' .and. current_character /= '\t' .and. &
                !     current_character /= '\r' .and. current_character /= '\f' .and. &
                !     current_character /= '\0' .and. .not. ((current_character >= 'a' .and. current_character <= 'z') .or. &
                !     (current_character >= 'A' .and. current_character <= 'Z'))) then 
                    
                ! end if
                ! if(current_character /= ' ' .and. current_character /= '\t' .and. &
                !     current_character /= '\r' .and. current_character /= '\f' .and. &
                !     current_character /= '\0' .and. .not. ((current_character >= 'a' .and. current_character <= 'z') .and. &
                !     .not. (current_character >= 'A' .and. current_character <= 'Z')) .and. &
                !     .not. isANumericValue(current_character) ) then
                
                !     print *, "ERROR: current_character: ", current_character, ", buffer: ", str_collector
                ! end if
            end if

            if(current_continent%name /= "" .and. size(errors) == 0) then
                if(allocated(current_continent%countries)) then
                    deallocate(current_continent%countries)
                end if

                allocate(current_continent%countries(0))

                call add_continent(size(current_graph%continents), current_continent, current_graph%continents)
                
                ! We clean the continent properties to storage the next one
                current_continent%name = ""

                str_context = "grafica;continente"
            end if
            
            if(checkParams(current_country) .and. size(errors) == 0) then

                if( .not. (allocated(current_graph%continents(size(current_graph%continents))%countries))) then
                    allocate(current_graph%continents(size(current_graph%continents))%countries(0))
                end if

                call add_country( &
                    size(current_graph%continents(size(current_graph%continents))%countries), &
                    current_country, &
                    current_graph%continents(size(current_graph%continents))%countries &
                )

                ! Recalculate the saturation for the continente
                continent_saturation = ((current_graph%continents(size(current_graph%continents))%saturation * (size(current_graph%continents(size(current_graph%continents))%countries) - 1)) + current_country%saturation) / size(current_graph%continents(size(current_graph%continents))%countries)

                current_graph%continents(size(current_graph%continents))%saturation = continent_saturation
                current_graph%continents(size(current_graph%continents))%color = get_saturation_color(continent_saturation)

                ! We clean the continent and country properties to storage the next one
                current_country%name = ""
                current_country%population = 0
                current_country%saturation = 0
                current_country%flag = ""

                str_context = "grafica;continente"
            end if
        end function checkLexeme


        function checkParams(current_country) result(valid)
            type(Country), intent(in) :: current_country
            logical :: valid

            valid = .false.

            if(current_country%name /= "" .and. current_country%population > 0 .and. current_country%saturation > 0 .and. current_country%flag /= "") then
                valid = .true.
            end if

        end function checkParams
end module LexerModule