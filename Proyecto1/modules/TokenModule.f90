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

        ! This Subroutine is thought to implement dynamic memory management
        subroutine addToken(length, newRecord, records)
            implicit none

            integer :: i
            integer, intent(in) :: length
            type(token), intent(in) :: newRecord

            type(token), intent(inout), allocatable :: records(:)
            type(token), allocatable :: tempRecords(:)

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
        end subroutine addToken

end module TokenModule