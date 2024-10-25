module Utils
    implicit none

    contains

        function parseStringToInt(string) result(parsedValue) 
            implicit none

            character(len=*), intent(in) :: string
            integer :: ios, parsedValue

            ! Parse the string to an integer
            read(string, '(I10)', IOSTAT=ios) parsedValue

            ! Check for errors during the conversion
            if (ios /= 0) then
                print *, 'Error when parsing string to interger!'
            end if

        end function parseStringToInt

        function parseStringToDecimal(string) result(parsedValue) 
            implicit none
            
            character(len=*), intent(in) :: string
            integer :: ios
            real :: parsedValue

            ! Parse the string to an integer
            read(string, *, iostat=ios) parsedValue
    
            ! Check for errors during the conversion
            if (ios /= 0) then
                print *, 'Error when parsing string to decimal!'
            end if
        end function parseStringToDecimal

        function is_numeric_value(string) result(is_numeric)
            implicit none

            character(len=*), intent(in) :: string
            integer :: ios, parsed_value
            logical :: is_numeric

            is_numeric = .true.

            ! Parse the string to an integer
            read(string, '(I10)', IOSTAT=ios) parsed_value

            ! Check for errors during the conversion
            if (ios /= 0) then
                is_numeric = .false.
            end if
        end function is_numeric_value

        function is_number(str) result(numeric)
            implicit none

            character(len=*), intent(in) :: str
            integer :: i, n, dot_count, minus_count
            logical :: valid, numeric

            numeric = .false.

            n = len_trim(str)

            ! Check for empty string
            if (n == 0) then
                return  ! An empty string is not a number
            end if

            dot_count = 0
            minus_count = 0
            valid = .true.

            do i = 1, n
                select case (str(i:i))
                case ('0':'9')
                    ! Valid character
                case ('-')
                    if (i /= 1) then
                        valid = .false.
                        exit
                    end if
                    minus_count = minus_count + 1
                    if (minus_count > 1) then
                        valid = .false.
                        exit
                    end if
                case ('.')
                    dot_count = dot_count + 1
                    if (dot_count > 1) then
                        valid = .false.
                        exit
                    end if
                case default
                    valid = .false.
                    exit
                end select
            end do

            numeric = valid .and. (minus_count <= 1) .and. (dot_count <= 1)
        end function is_number

        function to_lower_case(string) result(lower_case)
            implicit none

            character(len=*), intent(inout) :: string
            character(len=100) :: lower_case
            integer :: i

            lower_case = string

            do i = 1, len_trim(string)
                if (ichar(string(i:i)) >= ichar('A') .and. ichar(string(i:i)) <= ichar('Z')) then
                    ! Convert uppercase to lowercase
                    lower_case(i:i) = char(ichar(string(i:i)) + 32)
                end if
            end do
        end function to_lower_case

        ! function sanitize_string(string) result(output_string)
        !     implicit none

        !     character(len=*), intent(in) :: string
        !     character(len=len(string)) :: output_string
        !     character :: tabChar, newLineLF, newLineCR
        !     integer :: i, pos

        !     tabChar = char(9)        ! Tab character
        !     newLineLF = achar(10)    ! Line Feed (LF) - Unix-like systems
        !     newLineCR = achar(13)    ! Carriage Return (CR) - Windows systems
        !     output_string = ''       ! Initialize the result string as empty
        !     pos = 1                  ! Position in the result string

        !     ! Loop through each character in the input string
        !     do i = 1, len_trim(string)
        !         if (string(i:i) /= tabChar .and. string(i:i) /= newLineLF .and. string(i:i) /= newLineCR) then
        !             output_string(pos:pos) = string(i:i)  ! Copy non-tab and non-newline characters
        !             pos = pos + 1                          ! Move to the next position
        !         end if
        !     end do

        !     ! Trim the output string to remove any trailing spaces
        !     output_string = trim(output_string)

        ! end function sanitize_string
        function sanitize_string(string) result(output_string)
            implicit none

            character(len=*), intent(in) :: string
            character(len=len(string)) :: output_string
            character :: tabChar
            integer :: i, pos

            tabChar = char(9)        ! Tab character
            output_string = ''       ! Initialize the result string as empty
            pos = 1                  ! Position in the result string

            ! Loop through each character in the input string
            do i = 1, len_trim(string)
                if (string(i:i) /= tabChar) then
                    output_string(pos:pos) = string(i:i)  ! Copy non-tab characters
                    pos = pos + 1                         ! Move to the next position
                end if
            end do

            ! Trim the output string to remove any trailing spaces
            output_string = trim(output_string)

        end function sanitize_string

        function not_go_before_line_comment(str) result(yes)
            implicit none
            
            character(len=*), intent(in) :: str
            logical :: yes

            yes = .true.

            if(str(len(str) - 1: len(str) - 1) == '/' .and. str(len(str) - 2: len(str) - 2) == '/') then
                yes = .false.
            end if

        end function not_go_before_line_comment

        logical function is_alpha(c)
            implicit none
            
            character(len=1), intent(in) :: c
            integer :: ascii_val

            ascii_val = iachar(c)
            is_alpha = (ascii_val >= iachar('A') .and. ascii_val <= iachar('Z')) .or. &
                    (ascii_val >= iachar('a') .and. ascii_val <= iachar('z'))
        end function is_alpha

        function is_delimiter(c) result(delimiter)
            implicit none

            character(len=1), intent(in) :: c
            logical :: delimiter

            delimiter = .false.

            if( c == ";") then
                delimiter = .true.
            else if( c == "*") then
                delimiter = .true.
            else if( c == "/") then
                delimiter = .true.
            else if( c == "\") then
                delimiter = .true.
            else if( c == "(") then
                delimiter = .true.
            else if( c == ")") then
                delimiter = .true.
            else if( c == ".") then
                delimiter = .true.
            else if( c == ",") then
                delimiter = .true.
            else if( c == "$") then
                delimiter = .true.
            else if( c == "#") then
                delimiter = .true.
            else if( c == "-") then
                delimiter = .true.
            else if( c == ">") then
                delimiter = .true.
            end if 

        end function is_delimiter

        function is_slash(string) result(it_is)
            implicit none

            character(len=*), intent(in) :: string
            logical :: it_is

            it_is = .false.

            if(string == '/') then
                it_is = .true.
            end if

        end function is_slash


        function get_delimiter_name(c) result(delimiter_name)
            implicit none

            character(len=1), intent(in) :: c
            character(len=:), allocatable :: delimiter_name

            delimiter_name = ""

            if( c == ";") then
                delimiter_name = "PUNTO_Y_COMA"
            else if( c == "*") then
                delimiter_name = "ASTERISCO"
            else if( c == "/") then
                delimiter_name = "BARRA_DIAGONAL"
            else if( c == "\") then
                delimiter_name = "BARRA_INVERSA"
            else if( c == "(") then
                delimiter_name = "PARENTESIS_ABRE"
            else if( c == ")") then
                delimiter_name = "PARENTESIS_CIERRE"
            else if( c == "$") then
                delimiter_name = "DOLLAR"
            else if( c == "#") then
                delimiter_name = "NUMERAL"
            else if( c == "-") then
                delimiter_name = "GUION"
            else if( c == ">") then
                delimiter_name = "MAYOR_QUE"
            else if( c == ".") then
                delimiter_name = "PUNTO"
            else if( c == ",") then
                delimiter_name = "COMA"
            end if 

        end function get_delimiter_name

        ! This Subroutine is thought to implement dynamic memory management
        ! subroutine add_record(length, new_record, records)
        !     implicit none

        !     integer :: i
        !     integer, intent(in) :: length
        !     character(len=*), intent(in) :: new_record
        !     ! type(Token), intent(in) :: new_record

        !     ! type(Token), intent(inout), allocatable :: records(:)
        !     ! character(len=:), intent(inout), allocatable :: records(:)
        !     character(len=:), allocatable, intent(inout) :: records(:)
        !     character(len=:), allocatable :: temp_records(:)
        !     ! type(Token), allocatable :: temp_records(:)


        !     ! The temprary array will always be greater than the actual array
        !     allocate(temp_records(length + 1), source=records)

        !     do i = 1, size(records) 
        !         temp_records(i) = records(i)
        !     end do

        !     ! We add the new record
        !     temp_records(length + 1) = new_record

        !     if(allocated(records)) then
        !         deallocate(records)
        !     end if

        !     allocate(records(length + 1), source=records)

        !     records = temp_records
        ! end subroutine add_record
        subroutine add_record(length, new_record, records)
            implicit none

            integer :: i
            integer, intent(in) :: length
            character(len=*), intent(in) :: new_record

            character(len=:), allocatable, intent(inout) :: records(:)
            character(len=:), allocatable :: temp_records(:)

            ! Aseguramos que el nuevo arreglo tiene el mismo tamaño que el nuevo_record
            allocate(character(len=10000) :: temp_records(length + 1))

            ! Copiamos los registros existentes al arreglo temporal
            do i = 1, size(records)
                temp_records(i) = records(i)
            end do

            ! Añadimos el nuevo registro
            temp_records(length + 1) = new_record

            ! Liberamos el arreglo original si está asignado
            if (allocated(records)) then
                deallocate(records)
            end if

            ! Asignamos espacio para el nuevo arreglo de registros
            allocate(character(len=10000) :: records(length + 1))

            ! Copiamos el arreglo temporal al definitivo
            records = temp_records

            ! Liberamos el arreglo temporal
            deallocate(temp_records)
        end subroutine add_record

        subroutine remove_record(index, length, records)
            implicit none

            integer :: i, index
            integer, intent(in) :: length
            character(len=:), allocatable, intent(inout) :: records(:)
            character(len=:), allocatable :: temp_records(:)

            ! Verificamos si el índice está en el rango correcto
            if (index < 1 .or. index > length) then
                print *, "Error: El índice está fuera de rango."
                return
            end if

            ! Aseguramos que el nuevo arreglo tiene un tamaño menor al actual
            allocate(character(len=50) :: temp_records(length - 1))

            ! Copiamos todos los registros excepto el que se eliminará
            do i = 1, index - 1
                temp_records(i) = records(i)
            end do

            do i = index + 1, length
                temp_records(i - 1) = records(i)
            end do

            ! Liberamos el arreglo original si está asignado
            if (allocated(records)) then
                deallocate(records)
            end if

            ! Asignamos espacio para el nuevo arreglo de registros
            allocate(character(len=50) :: records(length - 1))

            ! Copiamos el arreglo temporal al definitivo
            records = temp_records

            ! Liberamos el arreglo temporal
            deallocate(temp_records)

        end subroutine remove_record



        ! Function to reverse a string
        function reverse_string(str) result(reversed)
            implicit none
            character(len=*), intent(in) :: str
            character(len=len(str)) :: reversed
            integer :: i, len_str

            ! Get the length of the input string
            len_str = len_trim(str)

            ! Traverse the string from the end to the beginning
            do i = 1, len_str
                reversed(i:i) = str(len_str - i + 1:len_str - i + 1)
            end do

            ! Fill the remaining characters with spaces (if the input string was shorter than the declared length)
            if (len_str < len(reversed)) reversed(len_str+1:) = ' '

        end function reverse_string

end module Utils