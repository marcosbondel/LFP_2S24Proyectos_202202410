program main
    use LexerModule
    use TokenModule
    use ErrorModule
    use AppModule
    implicit none

    ! Variables declaration
    integer :: io, stat, i, line_len, row_index, tokens_count
    character(len=512) :: msg
    character(len=100) :: line
    character(:), allocatable :: str_collector

    ! Data persistance vectors
    type(Token), allocatable :: tokens(:)
    type(Error), allocatable :: errors(:)

    ! Init values
    tokens_count = 0
    row_index = 1
    line_len = 0
    str_collector = ""
    allocate(tokens(0))
    allocate(errors(0))
    
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
            
            if (checkLexeme(str_collector, line(i:i), row_index, i, tokens, tokens_count)) then
                str_collector = ""
            end if

            i = i + 1
        end do

        row_index = row_index + 1
    end do

    ! If it does exist any error we won't create any graphic
    if(size(errors) > 0) then
        ! we copy data from the input
        call copy_data(tokens)
    end if

    ! print *, "Print data"

    ! do i = 1, size(tokens), 1
    !     print *, "NO: ", tokens(i)%no, " Lexeme: ", tokens(i)%lexeme
    ! end do

    ! Close the file for better performance
    close(io)

end program main