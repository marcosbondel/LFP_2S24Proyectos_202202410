module SyntaxAnalyzer
    use TokenModule
    use ErrorModule
    use Utils
    implicit none

    type :: Parser
        character(len=:), allocatable :: pile(:)
        character(len=:), allocatable :: s ! stands for S status, initial status

        type(Token), allocatable :: tokens(:)

        contains
            procedure :: analyze
            procedure :: init_pile
    end type

    contains
        subroutine analyze(self, tokens)
            implicit none

            class(Parser), intent(inout) :: self
            type(Token), intent(in), allocatable :: tokens(:)
            integer :: i

            ! self%s = "<--!Controles CDeclaration CProperties CPosition Controles-->"
            self%s = "<--!Controles CDeclaration Controles-->"
            self%tokens = tokens

            call self%init_pile()

            ! Once the pile is ready we start comparisons against the characters stream

            do i = 1, size(self%tokens), -1

                print *, "Token: ", trim(self%tokens(i)%lexeme)

                if(self%tokens(i)%lexeme == self%pile(len(self%pile))) then

                end if

            end do
        end subroutine analyze






        ! We init the pile by adding 'S' status
        subroutine init_pile(self)
            implicit none

            class(Parser), intent(inout) :: self
            character(len=:), allocatable :: buffer1
            integer :: i

            allocate(self%pile(0), source=self%pile)
            buffer1 = ""

            do i = len(self%s), 1, -1

                buffer1 = trim(buffer1) // trim(self%s(i:i))

                if(len(buffer1) == 1) then
                    if(buffer1 == ">" .or. buffer1 == "-" .or. buffer1 == "Controles" .or. buffer1 == "CDeclaration" .or. buffer1 == "!" .or. buffer1 == "<") then
                        call add_record(size(self%pile), reverse_string(buffer1), self%pile)
                        print *, "saved: ", buffer1
                        buffer1 = ""
                    end if

                else if(len(buffer1) > 1) then
                    if( reverse_string(buffer1) == "Controles" .or. reverse_string(buffer1) == "CDeclaration") then
                        call add_record(size(self%pile), reverse_string(buffer1), self%pile)
                        print *, "saved: ", reverse_string(buffer1)
                        buffer1 = ""
                    end if
                end if
            end do
            

        end subroutine init_pile

end module SyntaxAnalyzer