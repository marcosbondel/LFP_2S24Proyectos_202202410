module ControlModule
    implicit none

    type :: Control
        
        character(len=100) :: control_id
        character(len=100) :: cte_control
        character(len=100) :: belongs_to_id
        character(len=:), allocatable :: params(:)

        ! contains
        !     procedure :: build_control
        !     procedure :: add_attrs
        !     procedure :: add_location

    end type

    contains

        subroutine build_control(controls, control_id, cte_control)
            implicit none

            type(Control), intent(inout), allocatable :: controls(:)
            character(len=*), intent(in) :: control_id
            character(len=*), intent(in) :: cte_control
            type(Control) :: new_control

            new_control%control_id = control_id
            new_control%cte_control = cte_control

            call add_control(size(controls), new_control, controls)


        end subroutine build_control

        ! This Subroutine is thought to implement dynamic memory management
        subroutine add_control(length, new_record, records)
            implicit none

            integer :: i
            integer, intent(in) :: length
            type(Control), intent(in) :: new_record

            type(Control), intent(inout), allocatable :: records(:)
            type(Control), allocatable :: tempRecords(:)

            ! The temprary array will always be greater than the actual array
            allocate(tempRecords(length + 1))

            do i = 1, size(records) 
                tempRecords(i) = records(i)
            end do

            ! We add the new record
            tempRecords(length + 1) = new_record

            if(allocated(records)) then
                deallocate(records)
            end if

            allocate(records(length + 1))

            records = tempRecords
        end subroutine add_control

        ! subroutine build_control(self)
        !     implicit none

        !     class(Control), intent(in) :: self

        ! end subroutine build_control

        ! subroutine add_attrs(self)
        !     implicit none

        !     class(Control), intent(in) :: self

        ! end subroutine add_attrs

        ! subroutine add_location(self)
        !     implicit none

        !     class(Control), intent(in) :: self

        ! end subroutine add_location

end module ControlModule