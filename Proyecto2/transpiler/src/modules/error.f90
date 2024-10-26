module ErrorModule
    implicit none

    type :: Error
        integer :: no
        character(len=100) :: err_type
        character(len=10000) :: err
        character(len=10000) :: description
        integer :: row
        integer :: column
    end type

end module ErrorModule