program main
    use LexerModule
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
            
            if (checkLexeme(str_collector, line(i:i), row_index, i, tokens, tokens_count)) then
                str_collector = ""
            end if

            i = i + 1
        end do

        row_index = row_index + 1

    end do

    ! print *, "Print data"

    ! do i = 1, size(tokens), 1
    !     print *, "NO: ", tokens(i)%no, " Lexeme: ", tokens(i)%lexeme
    ! end do

    ! Close the file for better performance
    close(io)

end program main