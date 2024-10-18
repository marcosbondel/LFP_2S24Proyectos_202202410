module LexicalAnalyzer
    use TokenModule
    use ErrorModule
    implicit none

    type :: Scanner
        type(Token), allocatable :: tokens(:)
        type(Error), allocatable :: errors(:)

        contains
            procedure :: analyze
    end type

    contains

        subroutine analyze(self, character_stream)

            class(Scanner), intent(in) :: self

            integer :: i, j, ios, len_temp
            character(len=:), intent(inout), allocatable :: character_stream
            character(len=:), allocatable :: str_collector
            character(len=256) :: temp


            ! Init values
            j = 1

            ! We handle the input stream
            do
                read(*, '(A)', IOSTAT=ios) temp

                ! Trim and allocate space for the input
                len_temp = len_trim(temp)
                allocate(character(len=len_temp) :: character_stream)
                character_stream = trim(temp)

                i = 1

                do while( i <= len(character_stream) )
                    str_collector = trim(str_collector) // clean_string(trim(input_text(i:i)))
                    
                    ! if (checkLexeme(str_collector, input_text(i:i), row_index, i, tokens, tokens_count, errors, errors_count, current_country, current_continent, current_graph, continents_count, str_context)) then
                    !     str_collector = ""
                    ! end if

                    i = i + 1
                end do

                j = j + 1

                ! Deallocate the string to avoid memory leaks
                deallocate(character_stream)
            end do


        end subroutine analyze


end module LexicalAnalyzer