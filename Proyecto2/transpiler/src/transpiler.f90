program Transpiler
    ! Import module in use
    use LexicalAnalyzer
    use SyntaxAnalyzer
    implicit none

    integer :: len_temp, ios
    character(len=:), allocatable :: character_stream
    character(len=256) :: temp

    ! Compiler components
    type(Scanner) :: lexical_analyzer
    type(Parser) :: syntax_analyzer

    ! Data persistance vectors
    type(Token), allocatable :: tokens(:)
    type(Error), allocatable :: errors(:)

    print *, "Hola mundo"


    ! We let the Scanner handle the input stream

    call lexical_analyzer%analyze(character_stream)

end program Transpiler