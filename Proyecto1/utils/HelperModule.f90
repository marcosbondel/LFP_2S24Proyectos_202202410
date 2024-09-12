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

end module HelperModule