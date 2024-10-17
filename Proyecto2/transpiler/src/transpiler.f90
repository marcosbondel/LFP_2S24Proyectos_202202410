program transpiler
    ! Import module in use
    implicit none

    ! Variables declaration
    integer :: i, j, len_temp, line_len, row_index, tokens_count, errors_count, continents_count
    character(len=:), allocatable :: input_text
    character(len=256) :: temp

    ! Data persistance vectors
    type(Token), allocatable :: tokens(:)
    type(Error), allocatable :: errors(:)

    ! Init values
    row_index = 1
    tokens_count = 0
    errors_count = 0


    ! We handle the entry and send it to the Lexical analyzer (Scanner) 

end program transpiler