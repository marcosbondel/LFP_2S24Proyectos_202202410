module SyntaxAnalyzer
    use TokenModule
    use ErrorModule
    use ControlModule
    use Utils
    implicit none

    type :: Parser
        integer :: no_errors
        character(len=:), allocatable :: pile(:)
        character(len=:), allocatable :: s ! stands for S status, initial status
        character(len=:), allocatable :: context

        ! Variables for tracking HTML tags creation
        ! For controls
        character(len=100) :: cte_controles ! CTE_CONTROLES
        character(len=100) :: control_id ! IDENTIFIER
        character(len=100) :: style_property, param1, param2, param3

        type(Control), allocatable :: controls(:)
        type(Token), allocatable :: tokens(:)
        type(Error), allocatable :: errors(:)
        
        character(len=:), allocatable :: html(:)

        contains
            procedure :: init_pile
            procedure :: analyze
            procedure :: analyze_controls
            procedure :: transitioner
            procedure :: check_context
            procedure :: build_controls
            procedure :: build_intermediate_code
            procedure :: create_html_file
            procedure :: track_param
            procedure :: clean_param_trackers
            
            procedure :: build_error
            procedure :: add_error
    end type

    contains
        subroutine analyze(self, tokens, errors, no_errors)
            implicit none

            class(Parser), intent(inout) :: self
            type(Token), intent(in), allocatable :: tokens(:)
            type(Error), intent(in), allocatable :: errors(:)
            integer, intent(in) :: no_errors
            integer :: i

            ! Init value
            allocate(self%controls(0))
            self%context = ''
            self%s = '<!--Controles COMMENT CDeclaration COMMENT Controles--><!--propiedades COMMENT CProperties COMMENT propiedades--><!--Colocacion COMMENT CLocate COMMENT Colocacion -->'
            ! self%s = '<!--Controles COMMENT CDeclaration COMMENT Controles--><!--propiedades COMMENT CProperties COMMENT propiedades-->'
            self%tokens = tokens
            self%errors = errors
            self%no_errors = no_errors
            self%context = ""
            self%cte_controles = ""
            self%control_id = ""
            self%style_property = ""
            self%param1 = ""
            self%param2 = ""
            self%param3 = ""

            call self%init_pile()
            ! print *, 'Initial pile: '
            ! do i = 1, size(self%pile), 1
            !     print *, trim(self%pile(i))
            ! end do
            
            ! Once the pile is ready we start comparisons against the characters stream
            call self%analyze_controls()
            ! print *, 'Final pile: '
            ! do i = 1, size(self%pile), 1
            !     print *, trim(self%pile(i))
            ! end do

            call build_intermediate_code(self)
            call create_html_file(self, 'index')
            call create_css_file(self)

        end subroutine analyze

        ! We init the pile by adding 'S' status
        subroutine init_pile(self)
            implicit none

            class(Parser), intent(inout) :: self
            character(len=:), allocatable :: buffer1
            integer :: i

            buffer1 = ""
            
            do i = len(self%s), 1, -1
                buffer1 = trim(buffer1) // trim(self%s(i:i))

                if(len(buffer1) == 1) then
                    if(buffer1 == ">" .or. buffer1 == "-" .or. buffer1 == "!" .or. buffer1 == "<") then
                        call add_record(size(self%pile), buffer1, self%pile)
                        buffer1 = ""
                    end if

                else if(len(buffer1) > 1) then
                    if( reverse_string(buffer1) == 'Controles' .or. reverse_string(buffer1) == 'CDeclaration' .or. reverse_string(buffer1) == 'COMMENT' .or. &
                        reverse_string(buffer1) == 'propiedades' .or. reverse_string(buffer1) == 'CProperties' .or. &
                        reverse_string(buffer1) == 'Colocacion' .or. reverse_string(buffer1) == 'CLocate' &
                    ) then
                        call add_record(size(self%pile), reverse_string(buffer1), self%pile)
                        buffer1 = ""
                    end if
                end if
            end do
        end subroutine init_pile

        subroutine analyze_controls(self)
            implicit none

            class(Parser), intent(inout) :: self
            integer :: i

            ! Gramatica Controles
            !S              ->      <!--Controles COMMENT CDeclaration COMMENT Controles-->
            !S              ->      <!--Controles COMMENT CDeclaration Controles-->
            !CDeclaration   ->      CTE_CONTROLES IDENTIFIER ; COMMENT
            !               |      
            !COMMENT        ->      // IDENTIFIER COMMENT
            !               |       
            !COMMENT        ->      /* CDeclaration */
            

            ! Gramatica Propiedades
            !S                      ->      <!--propiedades COMMENT CProperties COMMENT propiedades-->
            !CProperties            ->      IDENTIFIER.PROPIEDAD_PROPIEDADES;
            !               |      
            !PROPIEDAD_PROPIEDADES  ->      setAlineacion|setTexto|setGrupo()
            !COMMENT        ->      // IDENTIFIER COMMENT
            !               |       
            !COMMENT        ->      /* CDeclaration */
            
            ! Gramatica Colocacion
            !S                      ->      <!--Colocacion COMMENT CLocate COMMENT Colocacion -->
            !CProperties            ->      IDENTIFIER.PROPIEDAD_PROPIEDADES;
            !               |      
            !PROPIEDAD_PROPIEDADES  ->      setAlineacion|setTexto|setGrupo()
            !COMMENT        ->      // IDENTIFIER COMMENT
            !               |       
            !COMMENT        ->      /* CDeclaration */

            do i = 1, size(self%tokens), 1

                ! We first have to analyze the lexeme
                ! If the symbol matches exactly with the token, then it means it is a terminal symbol
                ! and we remove it just like that
                call check_context(self, trim(self%tokens(i)%lex_type))

                
                ! if(trim(self%tokens(i)%lexeme) == trim(self%pile(size(self%pile))) .or. trim(self%tokens(i)%lex_type) == trim(self%pile(size(self%pile)))) then
                if(trim(self%tokens(i)%lexeme) == trim(self%pile(size(self%pile)))) then

                    ! print *, trim(self%tokens(i)%lexeme)
                    if(trim(self%pile(size(self%pile))) == 'PUNTO_Y_COMA') then
                        call build_controls(self)
                    end if
                    

                    call remove_record(size(self%pile), size(self%pile), self%pile)
                ! We analyze the token(lex_type), and work on the production respectively
                else
                    call transitioner(self, trim(self%pile(size(self%pile))), trim(self%tokens(i)%lexeme), trim(self%tokens(i)%lex_type))
                    call check_token_symbol(self, trim(self%pile(size(self%pile))), trim(self%tokens(i)%lexeme), trim(self%tokens(i)%lex_type))

                end if

            end do
        end subroutine analyze_controls

        subroutine transitioner(self, symbol, lexeme, token)
            implicit none

            class(Parser), intent(inout) :: self
            character(len=*), intent(in) :: symbol, lexeme, token

            ! print *, trim(self%pile(size(self%pile)))
            ! print *, token
            ! print *, lexeme

            if(symbol == 'CDeclaration') then
                if (token == 'CTE_CONTROLES') then
                    call add_record(size(self%pile), 'PUNTO_Y_COMA', self%pile)
                    call add_record(size(self%pile), 'IDENTIFICADOR', self%pile)
                    call add_record(size(self%pile), 'CTE_CONTROLES', self%pile)
                else
                    ! call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    
                    ! if(token == 'BLOQUE_CONTROLES') then
                    !     call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    ! end if

                    if(token == 'BLOQUE_CONTROLES') then
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    else if(token == 'COMMENT') then
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    else
                        call self%build_error(trim(self%pile(size(self%pile))), token, lexeme)
                    end if
                end if
            else if(symbol == 'COMMENT') then
                if(token == "BARRA_DIAGONAL") then
                    call add_record(size(self%pile), "BARRA_DIAGONAL", self%pile)
                    call add_record(size(self%pile), "BARRA_DIAGONAL", self%pile)
                else if(token == "CTE_CONTROLES") then
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    call add_record(size(self%pile), "PUNTO_Y_COMA", self%pile)
                    call add_record(size(self%pile), "IDENTIFICADOR", self%pile)
                    call add_record(size(self%pile), "CTE_CONTROLES", self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON

                    if(token == 'IDENTIFICADOR') then
                        call add_record(size(self%pile), "PUNTO_Y_COMA", self%pile)
                        call add_record(size(self%pile), "PARENTESIS_CIERRE", self%pile)
                        call add_record(size(self%pile), "PARAM", self%pile)
                        call add_record(size(self%pile), "PARENTESIS_ABRE", self%pile)
                        call add_record(size(self%pile), "PROPIEDAD_PROPIEDADES", self%pile)
                        call add_record(size(self%pile), "PUNTO", self%pile)
                        call add_record(size(self%pile), "IDENTIFICADOR", self%pile)
                    end if
                end if
            else if(symbol == 'CProperties') then
                if(token == "IDENTIFICADOR") then                    
                    call add_record(size(self%pile), "PUNTO_Y_COMA", self%pile)
                    call add_record(size(self%pile), "PARENTESIS_CIERRE", self%pile)
                    call add_record(size(self%pile), "PARAM", self%pile)
                    call add_record(size(self%pile), "PARENTESIS_ABRE", self%pile)
                    call add_record(size(self%pile), "PROPIEDAD_PROPIEDADES", self%pile)
                    call add_record(size(self%pile), "PUNTO", self%pile)
                    call add_record(size(self%pile), "IDENTIFICADOR", self%pile)
                else
                    ! call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON

                    if(token == 'BLOQUE_PROPIEDADES') then
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    else if(token == 'COMMENT') then
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    else
                        call self%build_error(trim(self%pile(size(self%pile))), token, lexeme)
                    end if
                end if
            else if(symbol == 'PARAM') then
                if(token == "NUMERO") then
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'PARAM'
                    call add_record(size(self%pile), "NUMERO", self%pile)
                    call add_record(size(self%pile), "COMA", self%pile)
                    call add_record(size(self%pile), "NUMERO", self%pile)
                else if(token == "CADENA") then
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'PARAM'
                    call add_record(size(self%pile), "CADENA", self%pile)
                else if(token == "VALOR_PROPIEDAD") then
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'PARAM'
                    call add_record(size(self%pile), "VALOR_PROPIEDAD", self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                end if
            else if(symbol == 'COMA') then
                if(token == 'PARENTESIS_CIERRE') then
                    call remove_record(size(self%pile), size(self%pile), self%pile)
                    call remove_record(size(self%pile), size(self%pile), self%pile)
                end if
            else if(symbol == 'NUMERO') then
                if(token == 'NUMERO') then
                    call add_record(size(self%pile), 'COMA', self%pile)
                    call add_record(size(self%pile), 'NUMERO', self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'NUMERO'
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'NUMERO'
                end if
            else if(symbol == 'CLocate') then
                if(token == 'IDENTIFICADOR') then                    
                    call add_record(size(self%pile), 'PUNTO_Y_COMA', self%pile)
                    call add_record(size(self%pile), 'PARENTESIS_CIERRE', self%pile)
                    call add_record(size(self%pile), 'PARAM', self%pile)
                    call add_record(size(self%pile), 'PARENTESIS_ABRE', self%pile)
                    call add_record(size(self%pile), 'PROPIEDAD_PROPIEDADES', self%pile)
                    call add_record(size(self%pile), 'PUNTO', self%pile)
                    call add_record(size(self%pile), 'IDENTIFICADOR', self%pile)
                else if(token == 'THIS') then
                    call add_record(size(self%pile), 'PUNTO_Y_COMA', self%pile)
                    call add_record(size(self%pile), 'PARENTESIS_CIERRE', self%pile)
                    call add_record(size(self%pile), 'PARAM', self%pile)
                    call add_record(size(self%pile), 'PARENTESIS_ABRE', self%pile)
                    call add_record(size(self%pile), 'PROPIEDAD_PROPIEDADES', self%pile)
                    call add_record(size(self%pile), 'PUNTO', self%pile)
                    call add_record(size(self%pile), 'THIS', self%pile)
                else
                    ! call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON

                    ! if(token == 'BLOQUE_COLOCACION') then
                    !     call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    ! end if

                    if(token == 'BLOQUE_COLOCACION') then
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    else if(token == 'COMMENT') then
                        call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    else
                        ! print symbol, token, lexeme
                        call self%build_error(trim(self%pile(size(self%pile))), token, lexeme)
                    end if

                end if
            else
                if(symbol /= token .and. symbol /= lexeme) then
                    ! print *, 'SYNTAX ERROR: ', trim(self%pile(size(self%pile))), token, lexeme
                    call self%build_error(trim(self%pile(size(self%pile))), token, lexeme)
                end if
            end if


            ! print *, trim(self%pile(size(self%pile)))
            ! print *, token
            ! print *, lexeme

        end subroutine transitioner

        subroutine check_token_symbol(self, symbol, lexeme, token)
            implicit none
            
            class(Parser), intent(inout) :: self
            character(len=*), intent(in) :: symbol, lexeme, token

            if(symbol == "PUNTO_Y_COMA" .and. token == "PUNTO_Y_COMA") then
                call remove_record(size(self%pile), size(self%pile), self%pile)
                call build_controls(self)
            else if(symbol == 'IDENTIFICADOR' .and. token == 'IDENTIFICADOR') then
                self%control_id = trim(lexeme)
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'CTE_CONTROLES' .and. token == 'CTE_CONTROLES') then
                self%cte_controles = lexeme
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'BARRA_DIAGONAL' .and. token == 'BARRA_DIAGONAL') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'COMMENT' .and. token == 'COMMENT') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
        
            else if(symbol == 'PUNTO' .and. token == 'PUNTO') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'PARENTESIS_ABRE' .and. token == 'PARENTESIS_ABRE') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'PARENTESIS_CIERRE' .and. token == 'PARENTESIS_CIERRE') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'COMA' .and. token == 'COMA') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'CADENA' .and. token == 'CADENA') then
                call self%track_param(lexeme)
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'NUMERO' .and. token == 'NUMERO') then
                call self%track_param(lexeme)
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'VALOR_PROPIEDAD' .and. token == 'VALOR_PROPIEDAD') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == token .or. symbol == lexeme) then
                if(symbol == 'PROPIEDAD_PROPIEDADES' .or. symbol == 'PROPIEDAD_COLOCACION') then
                    self%style_property = lexeme
                else if(symbol == 'NUMERO') then
                    call self%track_param(lexeme)
                end if
                call remove_record(size(self%pile), size(self%pile), self%pile)
            end if

        end subroutine check_token_symbol

        subroutine track_param(self, param)
            implicit none
            
            class(Parser), intent(inout) :: self
            character(len=*), intent(in) :: param

            if(self%param1 == '') then
                self%param1 = param
            else
                if(self%param2 == '') then
                    self%param2 = param
                else
                    if(self%param3 == '') then
                        self%param3 = param
                    end if
                end if
            end if

        end subroutine track_param

        subroutine clean_param_trackers(self)
            implicit none
            
            class(Parser), intent(inout) :: self

            self%param1 = ''
            self%param2 = ''
            self%param3 = ''

        end subroutine clean_param_trackers

        subroutine check_context(self, str)
            implicit none
            
            class(Parser), intent(inout) :: self
            character(len=*), intent(in) :: str
            
            if(str == 'BLOQUE_CONTROLES') then
                self%context = 'Controles'
            else if(str == 'BLOQUE_PROPIEDADES') then
                self%context = 'propiedades'
            else if(str == 'BLOQUE_COLOCACION') then
                self%context = 'Colocacion'
            end if

        end subroutine check_context

        subroutine build_controls(self)
            implicit none
            
            class(Parser), intent(inout) :: self

            if(self%context == 'Controles') then
                call build_control(self%controls, self%control_id, self%cte_controles)
            else if(self%context == 'propiedades' .or. self%context == 'Colocacion') then
                ! print *, 'colocacion'
                call add_properties(self%controls, trim(self%control_id), trim(self%cte_controles), trim(self%style_property), trim(self%param1), trim(self%param2), trim(self%param3))
            end if

            call self%clean_param_trackers()

        end subroutine build_controls

        subroutine build_intermediate_code(self)
            implicit none

            class(Parser), intent(inout) :: self
            integer :: i
            character(len=:), allocatable :: tag
            character(len=20) :: html_end

            tag = ""

            do i = 1, size(self%controls), 1

                ! print *, self%controls(i)%width

                if(self%controls(i)%cte_control == 'Etiqueta') then
                    tag = '<label id="' // trim(self%controls(i)%control_id) // '">' // trim(self%controls(i)%text) // '</label>'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Boton') then
                    tag = '<input type="submit" id="' // trim(self%controls(i)%control_id) // '" value='  // trim(self%controls(i)%text) // ' style="text-align: '// trim(self%controls(i)%alignment) //'"/>'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Check') then
                    tag = '<input type="checkbox" id="'// trim(self%controls(i)%control_id) //'" Marcado(checked) />JCheckBox0'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'RadioBoton') then
                    tag = '<input type="radio" name="'// trim(self%controls(i)%group) //'" id="'// trim(self%controls(i)%control_id) //'" Marcado />Texto'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Texto') then
                    tag = '<input type = "text" id="'// trim(self%controls(i)%control_id) //'" value="Texto" style="text-align: '// trim(self%controls(i)%alignment) //'" />'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'AreaTexto') then
                    tag = '<textarea id="'// trim(self%controls(i)%control_id) //'">Texto</textarea>'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Clave') then
                    tag = '<input type = "password" id="'// trim(self%controls(i)%control_id) //'" value="Texto" style="text-align: '// trim(self%controls(i)%alignment) //'"/>'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Contenedor') then
                    tag = '<div id="'// trim(self%controls(i)%control_id) //'"> </div>'
                    call add_record(size(self%html), trim(tag), self%html)
                end if
            end do

        end subroutine build_intermediate_code

        subroutine create_html_file(self, file_name)
            implicit none
            
            class(Parser), intent(inout) :: self
            
            ! Input argument: name of the HTML file
            character(len=*), intent(in) :: file_name
            integer :: file_unit, io_stat, i

            ! Open the file for writing (file unit = 10)
            open(unit=10, file=file_name//'.html', status='replace', action='write', iostat=io_stat)

            ! Check if the file was opened successfully
            if (io_stat /= 0) then
                print *, 'Error opening the file: ', file_name
                stop
            end if

            ! Write the HTML content to the file
            write(10,*) '<!DOCTYPE html>'
            write(10,*) '<html lang="en">'
            write(10,*) '<head>'
            write(10,*) '    <meta charset="UTF-8">'
            write(10,*) '    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
            ! write(10,*) '    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css">'
            write(10,*) '    <link rel="stylesheet" href="./styles.css">'
            write(10,*) '    <title>Transpilador LFP</title>'
            write(10,*) '</head>'

            do i = 1, size(self%html), 1
                write(10,*) trim(self%html(i))
            end do

            write(10,*) '</body>'
            write(10,*) '</html>'


            ! Close the file
            close(10)

        end subroutine create_html_file

        subroutine create_css_file(self)
            implicit none

            class(Parser), intent(inout) :: self

            integer :: unit_number, iostat, i
            character(len=100) :: file_name

            ! Define the CSS file name
            file_name = "styles.css"

            ! Assign a unit number and open the file for writing
            open(newunit=unit_number, file=file_name, status="replace", action="write", iostat=iostat)

            ! Check if there was an error opening the file
            if (iostat /= 0) then
                print *, "Error creating the CSS file."
                return
            end if

            ! Write some CSS styles to the file
            
            do i = 1, size(self%controls), 1
                write(unit_number, '(A)') '#' // trim(self%controls(i)%control_id) // '{ ' // achar(10) // &
                    'left: '// trim(self%controls(i)%xy_position(1)) //' px;' // achar(10) // & 
                    'top: '// trim(self%controls(i)%xy_position(2)) //' px;' // achar(10) // & 
                    'width: '// trim(self%controls(i)%width) //' px;' // achar(10) // & 
                    'height: '// trim(self%controls(i)%height) //' px;' // achar(10) // & 
                    'background-color: rgb('// trim(self%controls(i)%background_color(1)) // ',' // trim(self%controls(i)%background_color(2)) // ',' // trim(self%controls(i)%background_color(3)) //');' // achar(10) // &
                    'color: rgb('// trim(self%controls(i)%font_color(1)) // ',' // trim(self%controls(i)%font_color(2)) // ',' // trim(self%controls(i)%font_color(3)) //');' // achar(10) // &
                '}' // achar(10)
            end do

            ! Close the file
            close(unit_number)

        end subroutine create_css_file

        subroutine build_error(self, expected, given, lexeme)
            implicit none

            class(Parser), intent(inout) :: self
            character(len=*) :: expected, given, lexeme

            type(Error) :: new_error
            
            self%no_errors = self%no_errors + 1

            new_error%no = self%no_errors
            new_error%err = trim(given)
            new_error%description = 'Se esperaba ' // expected //', se recibio '// given // '(' // lexeme // ')'
            new_error%row = 1
            new_error%column = 1
            new_error%err_type = 'SINTACTICO'

            call self%add_error(size(self%errors), new_error)


        end subroutine build_error

        subroutine add_error(self, length, new_record)
            implicit none

            class(Parser), intent(inout) :: self

            integer :: i
            integer, intent(in) :: length
            type(Error), intent(in) :: new_record

            type(Error), allocatable :: temp_records(:)

            ! The temprary array will always be greater than the actual array
            allocate(temp_records(length + 1))

            do i = 1, size(self%errors)
                temp_records(i) = self%errors(i)
            end do

            ! We add the new record
            temp_records(length + 1) = new_record

            if(allocated(self%errors)) then
                deallocate(self%errors)
            end if

            allocate(self%errors(length + 1))

            self%errors = temp_records
        end subroutine add_error

end module SyntaxAnalyzer