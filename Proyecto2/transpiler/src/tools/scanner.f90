module scanner
    implicit none

    type :: Scanner
        ! integer :: no
        ! character(len=100) :: lexeme
        ! character(len=100) :: lex_type
        ! integer :: row
        ! integer :: column
        


        contains

            procedure :: analyze

    end type

    contains

        subroutine analyze()

        end subroutine analyze


end module scanner