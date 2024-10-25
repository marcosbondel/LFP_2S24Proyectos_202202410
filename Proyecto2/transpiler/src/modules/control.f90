module ControlModule
    implicit none

    type :: Control
        
        character(len=100) :: control_id
        character(len=100) :: cte_control
        character(len=100) :: belongs_to_id
        character(len=100) :: font_color(3)
        character(len=100) :: text
        character(len=100) :: alignment
        character(len=100) :: background_color(3)
        character(len=100) :: control_marked
        character(len=100) :: group
        character(len=100) :: height
        character(len=100) :: width

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

            new_control%control_id = trim(control_id)
            new_control%cte_control = trim(cte_control)

            new_control%belongs_to_id = ''
            new_control%font_color(1) = ''
            new_control%font_color(2) = ''
            new_control%font_color(3) = ''
            new_control%text = ''
            new_control%alignment = ''
            new_control%background_color(1) = ''
            new_control%background_color(2) = ''
            new_control%background_color(3) = ''
            new_control%control_marked = ''
            new_control%group = ''
            new_control%height = ''
            new_control%width = ''

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

        subroutine add_properties(controls, control_id, cte_control, style_property, param1, param2, param3)
            implicit none

            type(Control), intent(inout), allocatable :: controls(:)
            character(len=*), intent(in) :: control_id, cte_control, style_property, param1, param2, param3
            integer :: i

            do i = 1, size(controls), 1
                
                if(trim(adjustl(controls(i)%control_id)) == trim(adjustl(control_id))) then
                    print *, control_id, ' - ', style_property, param1, param2, param3
                    if(style_property == 'setColorLetra') then
                        controls(i)%font_color(1) = trim(param1)
                        controls(i)%font_color(2) = trim(param2)
                        controls(i)%font_color(3) = trim(param3)
                    else if(style_property == 'setTexto') then
                        controls(i)%text = trim(param1)
                    else if(style_property == 'setAlineacion') then
                        controls(i)%alignment = trim(param1)
                    else if(style_property == 'setColorFondo') then
                        controls(i)%background_color(1) = trim(param1)
                        controls(i)%background_color(2) = trim(param2)
                        controls(i)%background_color(3) = trim(param3)
                    else if(style_property == 'setMarcada') then
                        controls(i)%control_marked = trim(param1)
                    else if(style_property == 'setGrupo') then
                        controls(i)%group = trim(param1)
                    else if(style_property == 'setAncho') then
                        controls(i)%width = trim(param1)
                    else if(style_property == 'setAlto') then
                        controls(i)%height = trim(param1)
                    end if

                end if

            end do
            

        end subroutine add_properties

end module ControlModule