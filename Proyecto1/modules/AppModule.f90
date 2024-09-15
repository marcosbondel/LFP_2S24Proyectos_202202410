module AppModule
    use TokenModule
    implicit none
    
    type :: Country
        character(len=100) :: name
        integer :: population
        character(len=100) :: saturation
        character(len=100) :: flag
        character(len=100) :: color
    end type

    type :: continent
        character(len=100) :: name
        type(Country), allocatable :: countries(:)
        character(len=100) :: color
    end type

    contains

        subroutine copy_data(tokens)
            implicit none

            type(Token), intent(inout), allocatable :: tokens(:)

        end subroutine copy_data


end module AppModule