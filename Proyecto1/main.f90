program main
    use LexerModule
    use TokenModule
    use ErrorModule
    use HelperModule
    use AppModule
    implicit none

    ! Variables declaration
    integer :: i, j, len_temp, line_len, row_index, tokens_count, errors_count, continents_count
    character(len=:), allocatable :: input_text
    character(len=256) :: temp
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

    current_continent%name = ""
    current_continent%saturation = 0
    current_country%name = ""
    current_country%population = 0
    current_country%flag = ""
    current_country%saturation = 0
    

    ! Reading the file, line by line
    ! In each iteration we check if the character(s) belong to the language
    ! otherwise, we save it as an error
    do
        ! Read a line from input, with error handling for end-of-file
        read(*, '(A)', IOSTAT=len_temp, END=10) temp

        ! Trim and allocate space for the input
        len_temp = len_trim(temp)
        allocate(character(len=len_temp) :: input_text)
        input_text = trim(temp)

        i = 1
        line_len = len(input_text)

        do while( i <= line_len )
            str_collector = trim(str_collector) // clean_string(trim(input_text(i:i)))
            
            if (checkLexeme(str_collector, input_text(i:i), row_index, i, tokens, tokens_count, errors, errors_count, current_country, current_continent, current_graph, continents_count, str_context)) then
                str_collector = ""
            end if

            i = i + 1
        end do

        row_index = row_index + 1
 
        ! Deallocate the string to avoid memory leaks
        deallocate(input_text)
    end do

    10 continue

    if (size(errors) > 0) then
        ! Create HTML Errors
        call write_html_errors(errors)
    else
        ! Create HTML Tokens
        call write_html_tokens(tokens)

        ! Send data for rendering
        call current_graph%write_graph
    end if


end program main