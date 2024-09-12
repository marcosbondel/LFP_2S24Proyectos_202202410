module HelperModule
    implicit none


    contains

        function parseStringToInt(string) result(parsedValue) 
            implicit none

            character(len=*), intent(in) :: string
            integer :: ios, parsedValue, length

            ! Parse the string to an integer
            read(string, '(I10)', IOSTAT=ios) parsedValue

            ! Check for errors during the conversion
            if (ios /= 0) then
                print *, 'Error when parsing string to interger!'
            end if

        end function parseStringToInt

end module HelperModule