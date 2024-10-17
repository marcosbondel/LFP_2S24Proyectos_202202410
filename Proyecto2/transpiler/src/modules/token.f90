module tokens

    type :: Token
        integer :: no
        character(len=100) :: lexeme
        character(len=100) :: lex_type
        integer :: row
        integer :: column
    end type    

end module token