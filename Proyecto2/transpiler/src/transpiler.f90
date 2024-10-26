program Transpiler
    ! Import module in use
    use LexicalAnalyzer
    use SyntaxAnalyzer
    use Utils
    implicit none

    character(len=:), allocatable :: character_stream

    ! Compiler components
    type(Scanner) :: lexical_analyzer
    type(Parser) :: syntax_analyzer
    integer :: i

    ! We let the Scanner handle the input stream
    call lexical_analyzer%analyze(character_stream)
    call syntax_analyzer%analyze(lexical_analyzer%tokens, lexical_analyzer%errors, size(lexical_analyzer%errors))

    if(size(syntax_analyzer%errors) > 0) then
        do i = 1, size(syntax_analyzer%errors), 1
            write(*, '(A, A, A, I5, A, I5, A, A, A, A)', advance='no')  '-ERROR-,', trim(syntax_analyzer%errors(i)%err_type), ',', syntax_analyzer%errors(i)%row, ',', syntax_analyzer%errors(i)%column, ',', trim(syntax_analyzer%errors(i)%err), ',', trim(syntax_analyzer%errors(i)%description)
            write(*, *) ! new line
        end do
    else
        do i = 1, size(syntax_analyzer%tokens), 1
            write(*, '(A, I5, A, A, A, I5, A, I5, A, A)', advance='no')  '-SUCCESS-,', syntax_analyzer%tokens(i)%no, ',', trim(syntax_analyzer%tokens(i)%lexeme), ',', syntax_analyzer%tokens(i)%row, ',', syntax_analyzer%tokens(i)%column, ',', trim(syntax_analyzer%tokens(i)%lex_type)
            write(*, *) ! new line
        end do
    end if


end program Transpiler