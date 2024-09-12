module LexerModule
    use HelperModule
    use TokenModule
    implicit none

    contains

        function checkLexeme(str_collector, current_character, row, column, tokens, tokens_count) result(isALexeme)
            implicit none

            character(len=*), intent(in) :: str_collector
            character(len=*), intent(in) :: current_character
            integer, intent(in) :: row, column
            integer, intent(inout) :: tokens_count
            logical :: isALexeme
            type(Token), allocatable :: tokens(:) ! data persistence
            type(Token) :: new_lexeme

            isALexeme = .false.

            if(str_collector == "grafica") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "grafica"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == ":") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = ":"
                new_lexeme%lex_type = "DOS_PUNTOS"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == ";") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = ";"
                new_lexeme%lex_type = "PUNTO_Y_COMA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "{") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "{"
                new_lexeme%lex_type = "LLAVE_ABIERTA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "}") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "}"
                new_lexeme%lex_type = "LLAVE_CERRADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "nombre") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "nombre"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "continente") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "continente"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "pais") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "pais"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "bandera") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "bandera"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "poblacion") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "poblacion"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(str_collector == "saturacion") then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = "saturacion"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row
                new_lexeme%column = column
                
                call addToken(size(tokens), new_lexeme, tokens)

                isALexeme = .true.
            else if(current_character == "%") then

                ! we check if the previous content of the character "%" is a valid number
                ! if so we save it as a "real"/"numeric" token
                if(isANumericValue(str_collector(1: len_trim(str_collector) - 1))) then
                    tokens_count = tokens_count + 1

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = str_collector(1: len_trim(str_collector) - 1)
                    new_lexeme%lex_type = "NUMERO"
                    new_lexeme%row = row
                    new_lexeme%column = column
                    
                    call addToken(size(tokens), new_lexeme, tokens)

                    tokens_count = tokens_count + 1

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = "%"
                    new_lexeme%lex_type = "PORCENTAJE"
                    new_lexeme%row = row
                    new_lexeme%column = column
                    
                    call addToken(size(tokens), new_lexeme, tokens)

                    isALexeme = .true.
                end if

            else if(current_character == ";") then

                ! we check if the previous content of the character ";" is a valid number
                ! if so we save it as a "real"/"numeric" token
                if(isANumericValue(str_collector(1: len_trim(str_collector) - 1))) then
                    tokens_count = tokens_count + 1

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = str_collector(1: len_trim(str_collector) - 1)
                    new_lexeme%lex_type = "NUMERO"
                    new_lexeme%row = row
                    new_lexeme%column = column
                    
                    call addToken(size(tokens), new_lexeme, tokens)
                    
                    tokens_count = tokens_count + 1

                    new_lexeme%no = tokens_count
                    new_lexeme%lexeme = ";"
                    new_lexeme%lex_type = "PUNTO_Y_COMA"
                    new_lexeme%row = row
                    new_lexeme%column = column

                    call addToken(size(tokens), new_lexeme, tokens)
                
                    isALexeme = .true.
                end if

            else if(current_character == '"' .and. len(str_collector) > 1 .and. str_collector(1:1) == '"' .and. str_collector(len(str_collector):len(str_collector)) == '"') then
                tokens_count = tokens_count + 1

                new_lexeme%no = tokens_count
                new_lexeme%lexeme = str_collector
                new_lexeme%lex_type = "CADENA"
                new_lexeme%row = row
                new_lexeme%column = column

                call addToken(size(tokens), new_lexeme, tokens)
                
                isALexeme = .true.
            else
                if (current_character /= ' ' .and. current_character /= '\t' .and. &
                    current_character /= '\r' .and. current_character /= '\f' .and. &
                    current_character /= '\0' .and. .not. ((current_character >= 'a' .and. current_character <= 'z') .or. &
                    (current_character >= 'A' .and. current_character <= 'Z'))) then 
                    
                    print *, "chale ", str_collector

                end if

            end if



        end function checkLexeme

end module LexerModule