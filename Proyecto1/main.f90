program main
    use LexerModule
    use TokenModule
    use ErrorModule
    use AppModule
    implicit none

    ! Variables declaration
    integer :: io, stat, i, j, line_len, row_index, tokens_count, errors_count, continents_count
    character(len=512) :: msg
    character(len=100) :: line
    character(len=:), allocatable :: str_collector, str_context

    ! Data persistance vectors
    type(Token), allocatable :: tokens(:)
    type(Error), allocatable :: errors(:)
    type(Country) :: current_country
    type(Continent) :: current_continent
    type(Graph) :: current_graph

    ! Init values
    row_index = 1
    line_len = 0
    tokens_count = 0
    errors_count = 0
    continents_count = 0
    str_collector = ""
    str_context = ""
    allocate(tokens(0))
    allocate(errors(0))

    allocate(current_graph%continents(0))
    ! allocate(current_graph%continents(0))

    current_continent%name = ""
    current_country%name = ""
    current_country%population = 0
    current_country%flag = ""
    current_country%saturation = ""
    
    ! We try to open the entry file
    open(newunit=io, file="./entry.org", status="old", action="read", iostat=stat, iomsg=msg)
    
    ! In case we get any error when opening the file we stop the program
    if (stat /= 0) then
        print *, "-ERROR: ", trim(msg)
        return
    end if

    ! Reading the file, line by line
    ! In each iteration we check if the character(s) belong to the language
    ! otherwise, we save it as an error
    do
        read(io, '(A)', iostat=stat) line
                
        ! Check if the reading has been successful
        if (stat /= 0) exit

        i = 1
        line_len = len(line)

        do while( i <= line_len )

            str_collector = trim(str_collector) // trim(line(i:i))
            
            if (checkLexeme(str_collector, line(i:i), row_index, i, tokens, tokens_count, errors, errors_count, current_country, current_continent, current_graph, continents_count, str_context)) then
                str_collector = ""
            end if

            i = i + 1
        end do

        row_index = row_index + 1
    end do

    print *, ""
    print *, ""

    ! integer :: j
    do i = 1, size(current_graph%continents), 1
        print *, current_graph%continents(i)%name
        do j = 1, size(current_graph%continents(i)%countries), 1
            print *, current_graph%continents(i)%countries(j)%name, current_graph%continents(i)%countries(j)%saturation
        end do

        print *, ""
        print *, ""
    end do

    ! print *, "LEXEMAS"
    ! do i = 1, size(tokens), 1
    !     print *, "NO: ", tokens(i)%no, " Lexeme: ", tokens(i)%lexeme
    ! end do
    
    print *, "ERRORES"
    do i = 1, size(errors), 1
        print *, "NO: ", errors(i)%no, " Error: ", errors(i)%err
    end do

    ! Close the file for better performance
    close(io)

end program main