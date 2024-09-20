module ErrorModule
    implicit none

    type :: Error
        integer :: no
        character(len=100) :: err
        character(len=100) :: description
        integer :: row
        integer :: column
    end type


    contains 

        ! This Subroutine is thought to implement dynamic memory management
        subroutine add_error(length, newRecord, records)
            implicit none

            integer :: i
            integer, intent(in) :: length
            type(Error), intent(in) :: newRecord

            type(Error), intent(inout), allocatable :: records(:)
            type(Error), allocatable :: tempRecords(:)

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
        end subroutine add_error

        subroutine write_html_errors(errors)
            implicit none
            
            type(Error), intent(in), allocatable :: errors(:)
            integer :: i, ios
            ! Abrir archivo HTML
            open(unit=10, file="errors.html", status="replace", action="write", iostat=ios)

            if (ios /= 0) then
                print *, "Error al abrir el archivo."
                stop
            end if

            ! Escribir el código HTML
            write(10, *) '<!DOCTYPE html>'
            write(10, *) '<html>'
            write(10, *) '<head>'
            write(10, *) '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.2/css/bulma.min.css">'
            write(10, *) '<title>Lexer Errors - LFP</title>'
            write(10, *) '</head>'
            write(10, *) '<body class="container">'
            write(10, *) '<h1>ERRORS:</h1>'
            write(10, *) '<br>'
            write(10, *) '<table class="table">'
            write(10, *) '<thead><tr><th>No</th><th>Lexema</th><th>Tipo</th><th>Fila</th><th>Columna</th></tr></thead>'
            write(10, *) '<tbody>'

            ! Escribir filas de la tabla con los datos
            do i = 1, size(errors), 1
                write(10, '(A, I15, A, A, A, A, A, I15, A, I15, A)') '<td><td>', errors(i)%no, '</td><td>', trim(errors(i)%err), '</td><td>', trim(errors(i)%description), '</td><td>', errors(i)%row, '</td><td>', errors(i)%column, '</td></tr>'
            end do
            write(10, *) '</tbody>'

            ! Cerrar la tabla y el HTML
            write(10, *) '</table>'
            write(10, *) '</body>'
            write(10, *) '</html>'

            ! Cerrar el archivo
            close(10)
        end subroutine write_html_errors

end module ErrorModule