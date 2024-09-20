module AppModule
    use TokenModule
    use HelperModule
    implicit none
    
    type :: Country
        character(len=100) :: name
        integer :: population
        integer :: saturation
        character(len=100) :: flag
        character(len=100) :: color
    end type

    type :: Continent
        integer :: i
        character(len=100) :: name
        type(Country), allocatable :: countries(:)
        integer :: saturation
        character(len=100) :: color
    end type

    type :: Graph
        character(len=100) :: name
        type(Continent), allocatable :: continents(:)
    contains
        procedure :: write_graph
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

                str_context = "grafica"
            else if (str_context == "grafica;continente;nombre") then
                current_continent%name = trim(str_collector)

                str_context = "grafica;continente"
            else if (str_context == "grafica;continente;pais;nombre") then
                current_country%name = trim(str_collector)

                str_context = "grafica;continente;pais"
            else if (str_context == "grafica;continente;pais;poblacion") then
                current_country%population = parseStringToInt(str_collector)

                str_context = "grafica;continente;pais"
            else if (str_context == "grafica;continente;pais;saturacion") then
                current_country%saturation = parseStringToInt(trim(str_collector))
                current_country%color = get_saturation_color(parseStringToDecimal(str_collector))

                str_context = "grafica;continente;pais"
            else if (str_context == "grafica;continente;pais;bandera") then
                current_country%flag = trim(str_collector)

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

        function get_saturation_color(saturation) result(color) 
            implicit none

            real :: saturation
            character(len=100) :: color

            color = ""
            
            if (saturation >= 0 .and. saturation <= 15) then
                color = "#FFFFFF"
            else if (saturation >= 16 .and. saturation <= 30) then
                color = "#0000FF"
            else if (saturation >= 31 .and. saturation <= 45) then
                color = "#00FF00"
            else if (saturation >= 46 .and. saturation <= 60) then
                color = "#FFFF00"
            else if (saturation >= 61 .and. saturation <= 75) then
                color = "#FFA500"
            else if (saturation >= 76 .and. saturation <= 100) then
                color = "#FF0000"
            end if

            color = trim(color)

        end function get_saturation_color

        subroutine write_graph(self)
            integer :: i, j
            class(Graph), intent(in) :: self

            ! Graph name
            write(*, *) trim(self%name)

            do i = 1, size(self%continents), 1
                ! Continent information
                write(*, '(A, A, I15, A, A)', advance='no') trim(self%continents(i)%name), ",", self%continents(i)%saturation, ",", trim(self%continents(i)%color)
                ! print *, "hola - ", trim(self%continents(i)%name), ",", self%continents(i)%saturation, ",", trim(self%continents(i)%color) , ";"
                do j = 1, size(self%continents(i)%countries), 1
                    ! Country information
                    write(*, '(A, A, A, I15, A, I15, A, A, A, A)', advance='no') ";", trim(self%continents(i)%countries(j)%name), ",", self%continents(i)%countries(j)%saturation, ",", self%continents(i)%countries(j)%population, ",", trim(self%continents(i)%countries(j)%flag), ",", trim(self%continents(i)%countries(j)%color)
                    ! print *, "hola -", trim(self%continents(i)%countries(j)%name), ",", self%continents(i)%countries(j)%saturation, ",", self%continents(i)%countries(j)%population, ",", trim(self%continents(i)%countries(j)%flag), ",", trim(self%continents(i)%countries(j)%color), ";"
                end do
                write(*, *) ! new line
            end do

        end subroutine write_graph

end module AppModule