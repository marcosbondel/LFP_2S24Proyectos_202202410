module TokenModule
    implicit none

    type :: Token
        integer :: no
        character(len=100) :: lexeme
        character(len=100) :: lex_type
        integer :: row
        integer :: column
    end type

    contains

        ! This Subroutine is thought to implement dynamic memory management
        subroutine add_token(length, newRecord, records)
            implicit none

            integer :: i
            integer, intent(in) :: length
            type(Token), intent(in) :: newRecord

            type(Token), intent(inout), allocatable :: records(:)
            type(Token), allocatable :: tempRecords(:)

            ! The temprary array will always be greater than the actual array
            allocate(tempRecords(length + 1))

            do i = 1, size(records) 
                tempRecords(i) = records(i)
            end do

            ! We add the new record
            tempRecords(length + 1) = newRecord

            if(allocated(records)) then
                deallocate(records)
            end if

            allocate(records(length + 1))

            records = tempRecords
        end subroutine add_token

        subroutine write_html_tokens(tokens)
            implicit none
            
            type(Token), intent(in), allocatable :: tokens(:)
            integer :: i, ios
            ! Abrir archivo HTML
            open(unit=20, file="./Proyecto1/temp/tokens.html", status="replace", action="write", iostat=ios)

            if (ios /= 0) then
                print *, "Error al abrir el archivo."
                stop
            end if

            ! Escribir el código HTML
            write(20, *) '<!DOCTYPE html>'
            write(20, *) '<html>'
            write(20, *) '<head>'
            write(20, *) '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css">'
            write(20, *) '<title>Lexer Tokens - LFP</title>'
            write(20, *) '</head>'
            write(20, *) '<body class="container">'
            write(20, *) '<h1>TOKENS:</h1>'
            write(20, *) '<br>'
            write(20, *) '<table class="table">'
            write(20, *) '<thead><tr><th>No</th><th>Lexema</th><th>Tipo</th><th>Fila</th><th>Columna</th></tr></thead>'
            write(20, *) '<tbody>'

            ! Escribir filas de la tabla con los datos
            do i = 1, size(tokens), 1
                write(20, '(A, I15, A, A, A, A, A, I15, A, I15, A)') '<tr><td>', tokens(i)%no, '</td><td>', trim(tokens(i)%lexeme), '</td><td>', trim(tokens(i)%lex_type), '</td><td>', tokens(i)%row, '</td><td>', tokens(i)%column, '</td></tr>'
            end do
            write(20, *) '</tbody>'

            ! Cerrar la tabla y el HTML
            write(20, *) '</table>'
            write(20, *) '</body>'
            write(20, *) '</html>'

            ! Cerrar el archivo
            close(20)
        end subroutine write_html_tokens

end module TokenModule