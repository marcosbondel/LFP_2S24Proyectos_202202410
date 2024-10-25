module LexicalAnalyzer
    use TokenModule
    use ErrorModule
    use Utils
    implicit none

    type :: Scanner
        integer :: current_state
        integer :: no_tokens ! number of tokens
        type(Token), allocatable :: tokens(:)
        type(Error), allocatable :: errors(:)
        character(len=:), allocatable :: str_collector

        contains
            procedure :: analyze
            procedure :: build_token
            procedure :: add_token
    end type

    contains

        subroutine analyze(self, character_stream)
            implicit none

            class(Scanner), intent(inout) :: self

            integer :: i, j, j_track, ios, len_temp
            character(len=:), intent(inout), allocatable :: character_stream
            ! character(len=:), allocatable :: str_collector
            character(len=256) :: temp

            ! Init values
            j = 1
            j_track = 1
            self%str_collector = ""
            self%current_state = 0
            self%no_tokens = 0
            allocate(self%tokens(0))

            ! We handle the input stream
            do
                read(*, '(A)', IOSTAT=len_temp, END=10) temp
                
                ! Trim and allocate space for the input
                len_temp = len_trim(temp)
                allocate(character(len=len_temp) :: character_stream)
                character_stream = trim(temp)

                i = 1

                do while( i <= len(character_stream) )
                    ! We sanitize/clean the string from empty spaces and break lines
                    self%str_collector = trim(self%str_collector) // sanitize_string(trim(character_stream(i:i)))

                    ! STATUS 0 - Controles block
                    if(self%str_collector == '<' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '<', 'MENOR_QUE')
                    else if(self%str_collector == '!' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '!', 'EXCLAMACION')
                    else if(self%str_collector == '-' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '-', 'GUION')
                    else if(self%str_collector == 'Controles') then
                        call self%build_token(i, j, 'Controles', 'BLOQUE_CONTROLES')
                    else if(self%str_collector == 'Boton') then
                        call self%build_token(i, j, 'Boton', 'CTE_CONTROLES')
                    else if(self%str_collector == 'Etiqueta') then
                        call self%build_token(i, j, 'Etiqueta', 'CTE_CONTROLES')
                    else if(self%str_collector == 'Check') then
                        call self%build_token(i, j, 'Check', 'CTE_CONTROLES')
                    else if(self%str_collector == 'RadioBoton') then
                        call self%build_token(i, j, 'RadioBoton', 'CTE_CONTROLES')
                    else if(self%str_collector == 'Texto' .and. character_stream(i + 1:i + 1) == ' ') then
                        call self%build_token(i, j, 'Texto', 'CTE_CONTROLES')
                    else if(self%str_collector == 'AreaTexto') then
                        call self%build_token(i, j, 'AreaTexto', 'CTE_CONTROLES')
                    else if(self%str_collector == 'Clave') then
                        call self%build_token(i, j, 'Clave', 'CTE_CONTROLES')
                    else if(self%str_collector == 'Contenedor') then
                        call self%build_token(i, j, 'Contenedor', 'CTE_CONTROLES')
                    else if(self%str_collector == '>' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '>', 'MAYOR_QUE')
                    else if(self%str_collector == ';' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, ';', 'PUNTO_Y_COMA')
                    
                    ! propiedades block
                    else if(self%str_collector == 'propiedades') then
                        call self%build_token(i, j, 'propiedades', 'BLOQUE_PROPIEDADES')
                    else if(self%str_collector == '.' .and. not_go_before_line_comment(character_stream(1:i))) then
                        print *, "NOT HERE"
                        call self%build_token(i, j, '.', 'PUNTO')
                    else if(self%str_collector == ',' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, ',', 'COMA')
                    else if(self%str_collector == '(' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '(', 'PARENTESIS_ABRE')
                    else if(self%str_collector == ')' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, ')', 'PARENTESIS_CIERRE')
                    else if(self%str_collector == 'setColorLetra') then
                        call self%build_token(i, j, 'setColorLetra', 'PROPIEDAD_PROPIEDADES')
                    else if(self%str_collector == 'setTexto') then
                        call self%build_token(i, j, 'setTexto', 'PROPIEDAD_PROPIEDADES')
                    else if(self%str_collector == 'setAlineacion') then
                        call self%build_token(i, j, 'setAlineacion', 'PROPIEDAD_PROPIEDADES')
                    else if(self%str_collector == 'setColorFondo') then
                        call self%build_token(i, j, 'setColorFondo', 'PROPIEDAD_PROPIEDADES')
                    else if(self%str_collector == 'setMarcada') then
                        call self%build_token(i, j, 'setMarcada', 'PROPIEDAD_PROPIEDADES')
                    else if(self%str_collector == 'setGrupo') then
                        call self%build_token(i, j, 'setGrupo', 'PROPIEDAD_PROPIEDADES')
                    else if(self%str_collector == 'setAncho') then
                        call self%build_token(i, j, 'setAncho', 'PROPIEDAD_PROPIEDADES')
                    else if(self%str_collector == 'setAlto') then
                        call self%build_token(i, j, 'setAlto', 'PROPIEDAD_PROPIEDADES')
                    else if(self%str_collector == 'true') then
                        call self%build_token(i, j, 'true', 'VALOR_PROPIEDAD')
                    else if(self%str_collector == 'false') then
                        call self%build_token(i, j, 'false', 'VALOR_PROPIEDAD')
                    else if(self%str_collector == 'centro') then
                        call self%build_token(i, j, 'centro', 'VALOR_PROPIEDAD')
                    else if(self%str_collector == 'izquierdo') then
                        call self%build_token(i, j, 'izquierdo', 'VALOR_PROPIEDAD')
                    else if(self%str_collector == 'derecho') then
                        call self%build_token(i, j, 'derecho', 'VALOR_PROPIEDAD')
                    
                    ! else if(self%str_collector == '"') then
                    !     call self%build_token(i, j, '"', 'COMILLAS_DOBLES')
                    

                    ! Colocacion block
                    else if(self%str_collector == 'Colocacion') then
                        call self%build_token(i, j, 'Colocacion', 'BLOQUE_COLOCACION')
                    else if(self%str_collector == 'setPosicion') then
                        call self%build_token(i, j, 'setPosicion', 'PROPIEDAD_COLOCACION')
                    else if(self%str_collector == 'add') then
                        call self%build_token(i, j, 'add', 'PROPIEDAD_COLOCACION')
                    else if(self%str_collector == 'this') then
                        call self%build_token(i, j, 'this', 'COLOCACION_THIS')
 

                    ! Support for comments ????
                    else if(self%str_collector == '/' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '/', 'BARRA_DIAGONAL')
                    else if(self%str_collector == '\' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '\', 'BARRA_INVERSA')
                    else if(self%str_collector == '*' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '*', 'ASTERISCO')
                    else if(self%str_collector == '#' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '#', 'NUMERAL')
                    else if(self%str_collector == '$' .and. not_go_before_line_comment(character_stream(1:i))) then
                        call self%build_token(i, j, '$', 'DOLAR')

                    else if(character_stream(i: i) == '*' .and. character_stream(i+1:i+1) == '/' .and. is_alpha(self%str_collector(1:1))) then
                        call self%build_token(1, j, self%str_collector(1:len(self%str_collector) - 2), 'COMMENT', .false.)
                        call self%build_token(i, j, '*', 'ASTERISCO', .false.)
                        call self%build_token(i+1, j, '/', 'BARRA_DIAGONAL', .false.)
                        self%str_collector = "" ! We clean the buffer
                        i = i + 2
                    else if(character_stream(i - 1: i - 1) == '/' .and. character_stream(i - 2: i - 2) == '/') then
                        call self%build_token(i, j, character_stream(i:len(character_stream)), 'COMMENT')
                        i = len(character_stream)
                    ! We check if the buffer contains an identifier
                    else if(is_delimiter(character_stream(i:i)) .and. is_alpha(self%str_collector(1:1))) then

                        ! if( (j - 1) == j_track .and. is_slash(self%str_collector(1:1))) then
                            call self%build_token(i, j, self%str_collector(1:len(self%str_collector) - 1), 'IDENTIFICADOR', .false.)
                            call self%build_token(i, j, character_stream(i:i), get_delimiter_name(character_stream(i:i)), .false.)
                            self%str_collector = "" ! We clean the buffer
                        ! else
                            ! call self%build_token(i, j, self%str_collector(1:len(self%str_collector) - 1), 'IDENTIFICADOR', .false.)
                            ! call self%build_token(i, j, character_stream(i:i), get_delimiter_name(character_stream(i:i)), .false.)
                            ! self%str_collector = "" ! We clean the buffer
                        ! end if

                    ! We check if the buffer contains a number
                    else if(is_delimiter(character_stream(i:i)) .and. is_number(self%str_collector(1:len(self%str_collector) - 1))) then
                        call self%build_token(i, j, self%str_collector(1:len(self%str_collector) - 1), 'NUMERO', .false.)
                        call self%build_token(i, j, character_stream(i:i), get_delimiter_name(character_stream(i:i)), .false.)
                        self%str_collector = "" ! We clean the buffer
                    else if(character_stream(i:i) == achar(10)) then
                        print *, "BREAK LINE"
                        ! We save errors
                        ! print *, "ERROR: ", character_stream(i:i), self%str_collector
                    end if

                
                    ! TODO: analyze strings separately
                    if(len(self%str_collector) > 1 .and. self%str_collector(1:1) == '"' .and. self%str_collector(len(self%str_collector):len(self%str_collector)) == '"') then
                        call self%build_token(i, j, self%str_collector, 'CADENA')
                        ! i = len(character_stream)
                    end if


                    i = i + 1
                end do

                j = j + 1

                ! Deallocate the string to avoid memory leaks
                deallocate(character_stream)
            end do

            10 continue

        end subroutine analyze


        subroutine build_token(self, i, j, character_, lex_type, clean_str_collector)
            implicit none

            class(Scanner), intent(inout) :: self
            character(len=*) :: character_, lex_type
            integer, intent(in) :: i, j
            logical, intent(in), optional :: clean_str_collector

            type(Token) :: new_lexeme
            
            new_lexeme%no = self%no_tokens
            new_lexeme%lexeme = trim(character_)
            new_lexeme%lex_type = lex_type
            new_lexeme%row = i
            new_lexeme%column = j

            call self%add_token(self%no_tokens, new_lexeme)

            self%no_tokens = self%no_tokens + 1

            if( .not. present(clean_str_collector)) then
                self%str_collector = "" ! We clean the buffer
            end if

        end subroutine build_token

        subroutine add_token(self, length, new_record)
            implicit none

            class(Scanner), intent(inout) :: self

            integer :: i
            integer, intent(in) :: length
            type(Token), intent(in) :: new_record

            type(Token), allocatable :: temp_records(:)

            ! The temprary array will always be greater than the actual array
            allocate(temp_records(length + 1))

            do i = 1, size(self%tokens)
                temp_records(i) = self%tokens(i)
            end do

            ! We add the new record
            temp_records(length + 1) = new_record

            if(allocated(self%tokens)) then
                deallocate(self%tokens)
            end if

            allocate(self%tokens(length + 1))

            self%tokens = temp_records
        end subroutine add_token

end module LexicalAnalyzer