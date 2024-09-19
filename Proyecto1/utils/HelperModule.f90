module HelperModule
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

        function isANumericValue(string) result(isANumber)
            implicit none

            character(len=*), intent(in) :: string
            integer :: ios, parsedValue
            logical :: isANumber

            isANumber = .true.

            ! Parse the string to an integer
            read(string, '(I10)', IOSTAT=ios) parsedValue

            ! Check for errors during the conversion
            if (ios /= 0) then
                isANumber = .false.
            end if
        end function isANumericValue

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

        function clean_string(string) result(output_string)
            implicit none

            character(len=*), intent(in) :: string
            character(len=len(string)) :: output_string
            character :: tabChar
            integer :: i, pos

            tabChar = char(9)  ! Tab character
            output_string = ''  ! Initialize the result string as empty
            pos = 1            ! Position in the result string

            ! Loop through each character in the input string
            do i = 1, len_trim(string)
                if (string(i:i) /= tabChar) then
                    output_string(pos:pos) = string(i:i)  ! Copy non-tab characters
                    pos = pos + 1                             ! Move to the next position
                end if
            end do

            ! Trim the output string to remove extra spaces
            output_string = trim(output_string)
        end function clean_string

end module HelperModule