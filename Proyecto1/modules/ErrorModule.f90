module ErrorModule
    implicit none

    type :: Error
        integer :: no
        character(len=100) :: err
        character(len=100) :: description
        integer :: row
        integer :: column
    end type


    contains 

        ! This Subroutine is thought to implement dynamic memory management
        subroutine add_error(length, newRecord, records)
            implicit none

            integer :: i
            integer, intent(in) :: length
            type(Error), intent(in) :: newRecord

            type(Error), intent(inout), allocatable :: records(:)
            type(Error), allocatable :: tempRecords(:)

            ! The temprary array will always be greater than the actual array
            allocate(tempRecords(length + 1))

            do i = 1, size(records) 
                tempRecords(i) = records(i)
            end do

            ! We add the new record
            tempRecords(length + 1) = newRecord

            if(allocated(records)) then
                deallocate(records)
            end if

            allocate(records(length + 1))

            records = tempRecords
        end subroutine add_error

end module ErrorModule