module ErrorModule
    implicit none

    type :: Error
        integer :: no
        character(len=100) :: err
        character(len=100) :: description
        integer :: row
        integer :: column
    end type


end module ErrorModule