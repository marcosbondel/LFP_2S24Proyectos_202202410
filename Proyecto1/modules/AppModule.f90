module AppModule
    use TokenModule
    use HelperModule
    implicit none
    
    type :: Country
        character(len=100) :: name
        integer :: population
        character(len=100) :: saturation
        character(len=100) :: flag
        character(len=100) :: color
    end type

    type :: Continent
        integer :: i
        character(len=100) :: name
        type(Country), allocatable :: countries(:)
        character(len=100) :: color
    end type

    type :: Graph
        character(len=100) :: name
        type(Continent), allocatable :: continents(:)
    end type

    contains

        subroutine add_field_value(current_graph, current_continent, current_country, str_collector, str_context)
            implicit none

            character(len=:), intent(in), allocatable :: str_collector
            character(len=:), intent(inout), allocatable :: str_context
            type(Country), intent(inout) :: current_country
            type(Continent), intent(inout) :: current_continent
            type(Graph), intent(inout) :: current_graph


            if(str_context == "grafica;nombre") then
                current_graph%name = trim(str_collector)
                ! print *, "grafica;nombre"

                str_context = "grafica"
            else if (str_context == "grafica;continente;nombre") then
                current_continent%name = trim(str_collector)
                ! print *, "grafica;continente;nombre"

                str_context = "grafica;continente"
            else if (str_context == "grafica;continente;pais;nombre") then
                current_country%name = trim(str_collector)
                ! print *, "grafica;continente;pais;nombre"

                str_context = "grafica;continente;pais"
            else if (str_context == "grafica;continente;pais;poblacion") then
                current_country%population = parseStringToInt(str_collector)
                ! print *, "grafica;continente;pais;poblacion"

                str_context = "grafica;continente;pais"
            else if (str_context == "grafica;continente;pais;saturacion") then
                current_country%saturation = trim(str_collector)
                ! print *, "grafica;continente;pais;saturacion"

                str_context = "grafica;continente;pais"
            else if (str_context == "grafica;continente;pais;bandera") then
                current_country%flag = trim(str_collector)
                ! print *, "grafica;continente;pais;bandera"

                str_context = "grafica;continente;pais"
            end if

        end subroutine add_field_value

        ! This Subroutine is thought to implement dynamic memory management
        subroutine add_continent(length, newRecord, records)
            implicit none

            integer :: i
            integer, intent(in) :: length
            type(Continent), intent(in) :: newRecord

            type(Continent), intent(inout), allocatable :: records(:)
            type(Continent), allocatable :: tempRecords(:)

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
        end subroutine add_continent
        
        ! This Subroutine is thought to implement dynamic memory management
        subroutine add_country(length, newRecord, records)
            implicit none

            integer :: i
            integer, intent(in) :: length
            type(Country), intent(in) :: newRecord

            type(Country), intent(inout), allocatable :: records(:)
            type(Country), allocatable :: tempRecords(:)

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
        end subroutine add_country


end module AppModule