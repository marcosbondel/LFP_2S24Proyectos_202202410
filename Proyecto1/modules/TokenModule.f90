module TokenModule
    implicit none

    type :: Token
        integer :: no
        character(len=100) :: lexeme
        character(len=100) :: lex_type
        integer :: row
        integer :: column
    end type

    contains

        subroutine addToken()
            implicit none

            
        end subroutine addToken

end module TokenModule