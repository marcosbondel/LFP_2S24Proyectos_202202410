module SyntaxAnalyzer
    use TokenModule
    use ErrorModule
    use ControlModule
    use Utils
    implicit none

    type :: Parser
        character(len=:), allocatable :: pile(:)
        character(len=:), allocatable :: s ! stands for S status, initial status
        character(len=:), allocatable :: context

        ! Variables for tracking HTML tags creation
        ! For controls
        character(len=:), allocatable :: cte_controles ! CTE_CONTROLES
        character(len=:), allocatable :: control_id ! IDENTIFIER

        type(Control), allocatable :: controls(:)
        type(Token), allocatable :: tokens(:)
        
        character(len=:), allocatable :: html(:)

        contains
            procedure :: init_pile
            procedure :: analyze
            procedure :: analyze_controls
            procedure :: transitioner
            procedure :: check_context
            procedure :: build_controls
            procedure :: build_intermediate_code
            procedure :: create_files
    end type

    contains
        subroutine analyze(self, tokens)
            implicit none

            class(Parser), intent(inout) :: self
            type(Token), intent(in), allocatable :: tokens(:)
            integer :: i

            ! Init value
            allocate(self%controls(0))
            self%context = ''
            ! self%s = '<!--Controles COMMENT CDeclaration COMMENT Controles--><!--propiedades COMMENT CProperties COMMENT propiedades--><!--Colocacion COMMENT CLocate COMMENT Colocacion -->'
            self%s = '<!--Controles COMMENT CDeclaration COMMENT Controles--><!--propiedades COMMENT CProperties COMMENT propiedades-->'
            self%tokens = tokens
            self%context = ""
            self%cte_controles = ""
            self%control_id = ""

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
            call create_files(self, 'test')

        end subroutine analyze

        ! We init the pile by adding 'S' status
        subroutine init_pile(self)
            implicit none

            class(Parser), intent(inout) :: self
            character(len=:), allocatable :: buffer1
            integer :: i

            buffer1 = ""
            
            ! '<!--Controles COMMENT CDeclaration COMMENT Controles--><!--propiedades COMMENT CProperties COMMENT propiedades-->'
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
            !CDeclaration   ->      CTE_CONTROLES IDENTIFIER ;
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
                call check_context(self, trim(self%tokens(i)%lexeme))

                
                if(trim(self%tokens(i)%lexeme) == trim(self%pile(size(self%pile))) .or. trim(self%tokens(i)%lex_type) == trim(self%pile(size(self%pile)))) then

                    if(trim(self%pile(size(self%pile))) == 'PUNTO_Y_COMA') then
                        print *, "JODEERRRRRR"
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

            ! print *, symbol
            ! print *, token
            ! print *, lexeme

            if(symbol == 'CDeclaration') then
                if (token == 'CTE_CONTROLES') then
                    call add_record(size(self%pile), "PUNTO_Y_COMA", self%pile)
                    call add_record(size(self%pile), "IDENTIFICADOR", self%pile)
                    call add_record(size(self%pile), "CTE_CONTROLES", self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                end if
            else if(symbol == 'COMMENT') then
                if(token == "BARRA_DIAGONAL") then
                    call add_record(size(self%pile), "COMMENT", self%pile)
                    call add_record(size(self%pile), "BARRA_DIAGONAL", self%pile)
                    call add_record(size(self%pile), "BARRA_DIAGONAL", self%pile)
                else if(token == "CTE_CONTROLES") then
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                    call add_record(size(self%pile), "PUNTO_Y_COMA", self%pile)
                    call add_record(size(self%pile), "IDENTIFICADOR", self%pile)
                    call add_record(size(self%pile), "CTE_CONTROLES", self%pile)
                else
                end if
            else if(symbol == 'CProperties') then
                if(token == "IDENTIFICADOR") then
                    call add_record(size(self%pile), "IDENTIFICADOR", self%pile)
                    call add_record(size(self%pile), "PUNTO", self%pile)
                    call add_record(size(self%pile), "PROPIEDAD_PROPIEDADES", self%pile)
                    call add_record(size(self%pile), "PARENTESIS_ABRE", self%pile)
                    call add_record(size(self%pile), "PARAM", self%pile)
                    call add_record(size(self%pile), "PARENTESIS_CIERRE", self%pile)
                    call add_record(size(self%pile), "PUNTO_Y_COMA", self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
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
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                end if
            else if(symbol == 'NUMERO') then
                if(token == "NUMERO") then
                    call add_record(size(self%pile), "COMA", self%pile)
                    call add_record(size(self%pile), "NUMERO", self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'NUMERO'
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'NUMERO'
                end if
            else if(symbol == 'CLocate') then
                if(token == "NUMERO") then
                    call add_record(size(self%pile), "COMA", self%pile)
                    call add_record(size(self%pile), "NUMERO", self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'NUMERO'
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! We remove 'NUMERO'
                end if
            end if

        end subroutine transitioner

        subroutine check_token_symbol(self, symbol, lexeme, token)
            implicit none
            
            class(Parser), intent(inout) :: self
            character(len=*), intent(in) :: symbol, lexeme, token

            if(symbol == "PUNTO_Y_COMA" .and. token == "PUNTO_Y_COMA") then
                call remove_record(size(self%pile), size(self%pile), self%pile)
                call build_controls(self)
            else if(symbol == 'IDENTIFICADOR' .and. token == 'IDENTIFICADOR') then
                self%control_id = lexeme
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'CTE_CONTROLES' .and. token == 'CTE_CONTROLES') then
                self%cte_controles = lexeme
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'BARRA_DIAGONAL' .and. token == 'BARRA_DIAGONAL') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'COMENTARIO' .and. token == 'COMENTARIO') then
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
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'NUMERO' .and. token == 'NUMERO') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            end if

        end subroutine check_token_symbol

        subroutine check_context(self, str)
            implicit none
            
            class(Parser), intent(inout) :: self
            character(len=*), intent(in) :: str

            if(str == 'Controles') then
                self%context = 'Controles'
            else if(str == 'propiedades') then
                self%context = 'propiedades'
            else if(str == 'Colocacion') then
                self%context = 'Colocacion'
            end if

        end subroutine check_context

        subroutine build_controls(self)
            implicit none
            
            class(Parser), intent(inout) :: self

            if(self%context == 'Controles') then
                call build_control(self%controls, self%control_id, self%cte_controles)
                print *, "control added"
            else if(self%context == 'propiedades') then

            else if(self%context == 'Colocacion') then
            
            end if

        end subroutine build_controls

        subroutine build_intermediate_code(self)
            implicit none

            class(Parser), intent(inout) :: self
            integer :: i
            character(len=:), allocatable :: tag
            character(len=20) :: html_end

            tag = ""

            do i = 1, size(self%controls), 1
                
                if(self%controls(i)%cte_control == 'Etiqueta') then
                    tag = '<label id="ID"> TEXT </label>'
                    print *, "entro"
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Boton') then
                    print *, "entro"
                    tag = '<input type="submit" id="ID" value="Texto" style="text-align: Alineacion"/>'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Check') then
                    print *, "entro"
                    tag = '<input type="checkbox" id="JCheckBox0" Marcado(checked) />JCheckBox0'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'RadioBoton') then
                    print *, "entro"
                    tag = '<input type="radio" name="Group" id="ID"Marcado />Texto'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Texto') then
                    print *, "entro"
                    tag = '<input type = "text" id="ID" value="Texto" style="text-align: Alineacion" />'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'AreaTexto') then
                    print *, "entro"
                    tag = '<textarea id="ID">Texto</textarea>'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Clave') then
                    print *, "entro"
                    tag = '<input type = "password" id="ID" value="Texto" style="text-align: Alineacion"/>'
                    call add_record(size(self%html), trim(tag), self%html)
                else if(self%controls(i)%cte_control == 'Contenedor') then
                    print *, "entro"
                    tag = '<div id="ID"> </div>'
                    call add_record(size(self%html), trim(tag), self%html)
                end if
            end do

        end subroutine build_intermediate_code

        subroutine create_files(self, file_name)
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
            write(10,*) '    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css">'
            write(10,*) '    <title>Transpilador LFP</title>'
            write(10,*) '</head>'
            write(10,*) '<body>'

            do i = 1, size(self%html), 1
                write(10,*) trim(self%html(i))
            end do

            write(10,*) '</body>'
            write(10,*) '</html>'


            ! Close the file
            close(10)

        end subroutine create_files

end module SyntaxAnalyzer