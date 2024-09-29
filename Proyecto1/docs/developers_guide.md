# Manual técnico - Lexer LFP

## Tabla de contenidos

- [Introducción](#introducción)
- [Objectivos](#objectivos)
- [Alcances del sistema](#alcances-del-sistema)
- [Especificación técnica](#especificación-técnica)
    - [Requisitos de Hardware](#requisitos-de-hardware)
    - [Requisitos de Software](#requisitos-de-software)
- [Descripción de la solución](#descripción-de-la-solución)
- [Lógica del programa](#lógica-del-programa)
    - [Estructura de la aplicacion](#estructura-de-la-aplicacion)
    - [Main](#main)
    - [Modulos](#modulos)
    - [Funciones](#funciones)
    - [Subrutinas](#subrutinas)

---------
## Introducción
Este  manual  será  de  utilidad  para  los  programadores  que  deseen  agregar funcionalidades y mejoras al código existente.

---------
## Objectivos

Brindar documentación sobre el flujo del funcionamiento de esta aplicación, las funciones, subrutinas, módulos utilizados en el programa y la forma en la que se implementaron para solucionar el problema propuesto.

---------
## Alcances del sistema

Es documentar cada una de las subrutinas y módulos y cual fu la lógica detrás de ellas para esta manera otros programadores pueden entender por qué se realizaron.

---------
## Especificación técnica
### Requisitos de Hardware
- Procesador 
- Memoria RAM 
- Almacenamiento 
- Sistema Operativo 
- Tarjeta gráfica 

### Requisitos de Software
- Compilador 
- Sistema Operativo Compatible 
- Entorno de ejecución 
- Variables de entorno

---------
## Descripción de la solución

El analizador léxico se implemento utilizando el lenguaje de programación Fortran.

Durante el desarrollo del programa se planificaron modulos, subrutinas y funciones de tal forma que sean reutilizables para hacer un código más legible y reutilizable. 

Se crearon 3 módulos para manejar la lógica, uno que almacena un tipo derivado llamado `Token`, otro  llamado `Error` y último para trabajar con la lógica de la solución como tal, asi como para la persistencia y memoria dinámica, llamado `App`.

También se crearon 2 módulos más que funcionan como utilidades, uno llamado `Helper` que contiene una serie de funciones útiles para no repetir código, y el otro `Lexer` que respresentar toda la lógica necesaria para el analizador lógico como tal.

Se crearon 8 subrutinas y 8 funciones.

La aplicación de escritorio fue realizada con el lenguaje de programación Python, con la herramienta Tkinter. En caso de la app de escritorio se escribieron 8 funciones en Python.

---------
## Lógica del programa


#### PROGRAM

```fortran
program main
```

Define el inicio del programa principal, el punto de inicio de  ejecución del programa. 
En ese punto se declaran variables para la  persistencia de datos, variables importantes, y se llaman los demás componentes necesarios para el funcionamiento de la aplicación.

#### SUBROUTINES

```fortran
subroutine add_token(length, newRecord, records)
```

```fortran
subroutine write_html_tokens(tokens)
```
```fortran
subroutine add_error(length, newRecord, records)
```
```fortran
subroutine write_html_errors(errors)
```

```fortran
subroutine add_field_value(current_graph, current_continent, current_country, str_collector, str_context)
```
```fortran
subroutine add_continent(length, newRecord, records)
```
```fortran
subroutine add_country(length, newRecord, records)
```
```fortran
subroutine write_graph(self)
```

#### FUNCTIONS


```fortran
function parseStringToInt(string) result(parsedValue) 
```
```fortran
function parseStringToDecimal(string) result(parsedValue) 
```
```fortran
function isANumericValue(string) result(isANumber)
```
```fortran
function to_lower_case(string) result(lower_case)
```
```fortran
function clean_string(string) result(output_string)
```
```fortran
function checkLexeme(str_collector, current_character, row, column, tokens, tokens_count, errors, errors_count, current_country, current_continent, current_graph, continents_count, str_context) result(isALexeme)
```
```fortran
function checkParams(current_country) result(valid)
```
```fortran
function get_saturation_color(saturation) result(color) 
```

---------
### Estructura de la aplicacion

```
├── Proyecto1
│   ├── GUI
│   │   └── index.py
│   ├── LFP_2S24Proyectos_202202410.code-workspace
│   ├── built
│   ├── docs
│   │   ├── developers_guide.md
│   │   ├── enunciado.pdf
│   │   ├── screenshots_guide
│   │   └── users_guide.md
│   ├── license
│   ├── main.f90
│   ├── modules
│   │   ├── AppModule.f90
│   │   ├── ErrorModule.f90
│   │   └── TokenModule.f90
│   ├── readme.md
│   ├── temp
│   └── utils
│       ├── HelperModule.f90
│       └── LexerModule.f90
├── license
├── readme.md
```