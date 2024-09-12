module LexerHandlerModule
    use HelperModule
    use TokenModule
    implicit none

    contains

        function isAValidString(str_collector, current_character) result(validQuote)

            character(len=*), intent(in) :: str_collector
            character(len=1), intent(in) :: current_character
            logical :: validQuote
            integer :: str_length

            str_length = len(str_collector)

            validQuote = .false.

            if(current_character == '"' .and. str_length > 1 .and. str_collector(1:1) == '"' .and. str_collector(str_length:str_length) == '"') then
                validQuote = .true.
            end if

        end function isAValidString

        function isALexeme(str_collector, current_character, row, column, tokens) result(validLexeme)

            character(len=*), intent(in) :: str_collector
            character(len=*), intent(in) :: current_character
            integer, intent(in) :: row, column
            logical :: validLexeme
            type(Token), allocatable :: tokens(:) ! data persistence
            type(Token) :: new_lexeme

            validLexeme = .false.

            if(str_collector == "grafica") then

                new_lexeme%no = 1
                new_lexeme%lexeme = "grafica"
                new_lexeme%lex_type = "PALABRA_RESERVADA"
                new_lexeme%row = row_index
                new_lexeme%column = column
                

                validLexeme = .true.
            else if(str_collector == ":") then
                validLexeme = .true.
            else if(str_collector == ";") then
                validLexeme = .true.
            else if(str_collector == "{") then
                validLexeme = .true.
            else if(str_collector == "}") then
                validLexeme = .true.
            else if(str_collector == "nombre") then
                validLexeme = .true.
            else if(str_collector == "continente") then
                validLexeme = .true.
            else if(str_collector == "pais") then
                validLexeme = .true.
            else if(str_collector == "bandera") then
                validLexeme = .true.
            else if(str_collector == "poblacion") then
                validLexeme = .true.
            else if(str_collector == "saturacion") then
                validLexeme = .true.
            else if(current_character == "%") then
                print *, current_character, str_collector(1: len(str_collector) - 1)
                validLexeme = .true.
            else if(current_character == ";") then
                validLexeme = .true.
            end if

        end function isALexeme

end module LexerHandlerModule