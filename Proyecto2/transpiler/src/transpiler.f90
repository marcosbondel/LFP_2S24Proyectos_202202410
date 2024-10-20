program Transpiler
    ! Import module in use
    use LexicalAnalyzer
    use SyntaxAnalyzer
    implicit none

    character(len=:), allocatable :: character_stream

    ! Compiler components
    type(Scanner) :: lexical_analyzer
    type(Parser) :: syntax_analyzer
    integer :: i

    print *, "Hola mundo"


    ! We let the Scanner handle the input stream

    call lexical_analyzer%analyze(character_stream)


    do i = 1, size(lexical_analyzer%tokens), 1

        print *, trim(lexical_analyzer%tokens(i)%lexeme)

    end do

end program Transpiler