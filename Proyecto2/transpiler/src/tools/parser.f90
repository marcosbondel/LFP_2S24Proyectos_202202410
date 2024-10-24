module SyntaxAnalyzer
    use TokenModule
    use ErrorModule
    use Utils
    implicit none

    type :: Parser
        character(len=:), allocatable :: pile(:)
        character(len=:), allocatable :: s ! stands for S status, initial status

        type(Token), allocatable :: tokens(:)

        contains
            procedure :: init_pile
            procedure :: analyze
            procedure :: analyze_controls
            procedure :: transitioner
    end type

    contains
        subroutine analyze(self, tokens)
            implicit none

            class(Parser), intent(inout) :: self
            type(Token), intent(in), allocatable :: tokens(:)
            integer :: i

            ! Init value
            self%s = '<!--Controles COMMENT CDeclaration COMMENT Controles--><!--propiedades COMMENT CProperties COMMENT propiedades-->'
            self%tokens = tokens

            call self%init_pile()
            print *, "Initial pile: "
            do i = 1, size(self%pile), 1
                print *, trim(self%pile(i))
            end do
            
            ! Once the pile is ready we start comparisons against the characters stream
            call self%analyze_controls()
            print *, "Final pile: "
            do i = 1, size(self%pile), 1
                print *, trim(self%pile(i))
            end do

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
                        reverse_string(buffer1) == 'propiedades' .or. reverse_string(buffer1) == 'CProperties' &
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

            do i = 1, size(self%tokens), 1

                ! We first have to analyze the lexeme
                ! If the symbol matches exactly with the token, then it means it is a terminal symbol
                ! and we remove it just like that
                if(trim(self%tokens(i)%lexeme) == trim(self%pile(size(self%pile))) .or. trim(self%tokens(i)%lex_type) == trim(self%pile(size(self%pile)))) then
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

            if(symbol == 'CDeclaration') then
                if (token == 'CTE_CONTROLES') then
                    call add_record(size(self%pile), "CTE_CONTROLES", self%pile)
                    call add_record(size(self%pile), "IDENTIFICADOR", self%pile)
                    call add_record(size(self%pile), "PUNTO_Y_COMA", self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
                end if
            else if(symbol == 'COMMENT') then
                if(token == "BARRA_DIAGONAL") then
                    call add_record(size(self%pile), "COMMENT", self%pile)
                    call add_record(size(self%pile), "BARRA_DIAGONAL", self%pile)
                    call add_record(size(self%pile), "BARRA_DIAGONAL", self%pile)
                else
                    call remove_record(size(self%pile), size(self%pile), self%pile) ! EPSILON
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
            end if

        end subroutine transitioner

        subroutine check_token_symbol(self, symbol, lexeme, token)
            implicit none
            
            class(Parser), intent(inout) :: self
            character(len=*), intent(in) :: symbol, lexeme, token

            if(symbol == "PUNTO_Y_COMA" .and. token == "PUNTO_Y_COMA") then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'IDENTIFICADOR' .and. token == 'IDENTIFICADOR') then
                call remove_record(size(self%pile), size(self%pile), self%pile)
            else if(symbol == 'CTE_CONTROLES' .and. token == 'CTE_CONTROLES') then
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

end module SyntaxAnalyzer