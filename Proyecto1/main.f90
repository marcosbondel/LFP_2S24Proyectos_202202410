program main
    use LexerHandlerModule
    use TokenModule
    implicit none

    ! Variables declaration
    integer :: io, stat, i, line_len, row_index, tokens_count
    character(len=512) :: msg
    character(len=100) :: line
    character(:), allocatable :: str_collector
    logical :: flag_number

    ! Data persistance vectors
    type(Token), allocatable :: tokens(:)

    ! Init values
    tokens_count = 0
    row_index = 1
    line_len = 0
    str_collector = ""
    flag_number = .false.
    allocate(tokens(0))
    
    ! We try to open the entry file
    open(newunit=io, file="./entry.org", status="old", action="read", iostat=stat, iomsg=msg)
    
    ! In case we get any error when opening the file we stop the program
    if (stat /= 0) then
        print *, "-ERROR: ", trim(msg)
        return
    end if

    ! Reading the file, line by line
    do
        read(io, '(A)', iostat=stat) line
                
        ! Check if the reading has been successful
        if (stat /= 0) exit

        i = 1
        line_len = len(line)

        do while( i <= line_len )

            str_collector = trim(str_collector) // trim(line(i:i))


            if (isAValidString(str_collector, line(i:i))) then
                ! print *, str_collector
                str_collector = ""
            end if
            
            if (isALexeme(str_collector, line(i:i), row_index, i, tokens)) then
                ! print *, str_collector
                ! type(Token) :: new_lexeme
                
                ! new_lexeme%no = 1
                ! new_lexeme%lexeme = "grafica"
                ! new_lexeme%lex_type = "PALABRA_RESERVADA"
                ! new_lexeme%row = 1
                ! new_lexeme%column = 1

                str_collector = ""


            end if


            i = i + 1
        end do

        print *, row_index
        row_index = row_index + 1

    end do

    ! Close the file for better performance
    close(io)

end program main