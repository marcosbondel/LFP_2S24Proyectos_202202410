# Manual Técnico: Compilador para Diseño de Páginas Web en Fortran

**Autor:** Marcos Daniel Bonifasi de Leon
**Fecha:** Octubre 2024

## Tabla de Contenidos
1. [Introducción](#introducción)
2. [Requisitos del Sistema](#requisitos-del-sistema)
3. [Arquitectura del Software](#arquitectura-del-software)
4. [Algoritmos Implementados](#algoritmos-implementados)
5. [Estructura del Código](#estructura-del-código)
6. [Mantenimiento y Actualizaciones](#mantenimiento-y-actualizaciones)
7. [Solución de Problemas](#solución-de-problemas)

---

## Introducción

Este manual técnico describe la implementación de un compilador en Fortran para diseñar páginas web, que realiza análisis léxico y sintáctico y genera archivos HTML y CSS.

### Propósito del documento
Destinado a desarrolladores y técnicos para instalación, configuración, mantenimiento y actualización del sistema.

### Descripción General del Proyecto
El sistema es un compilador que procesa archivos de texto con definiciones de páginas web y genera HTML y CSS. Implementado en Fortran, con interfaz en Python (Tkinter), utiliza un AFD para análisis léxico y una GLC para el análisis sintáctico.

### Tecnologías Utilizadas
- **Lenguaje de Programación**: Fortran 95/2003
- **Compilador**: GNU Fortran (`gfortran`)
- **Interfaz Gráfica**: Python con Tkinter
- **Control de Versiones**: Git
- **Sistema Operativo**: Compatible con Unix/Linux y Windows

---

## Requisitos del Sistema

### Hardware Requerido
- **Mínimo**: CPU 32/64 bits, 2 GB RAM, 200 MB de espacio
- **Recomendado**: 4 GB RAM, 500 MB de espacio

### Software Requerido
- **Sistemas Operativos**: Unix/Linux (Debian, Ubuntu) o Windows 10+
- **Software Necesario**: `gfortran`, `Git`, Python 3.6+, Tkinter

### Configuración del Entorno de Desarrollo

1. **Instalación de `gfortran`** en Unix/Linux:
   ```bash
   sudo apt-get install gfortran
   ```
2. **Instalación de Python y Tkinter** en Unix/Linux:
   ```bash
   sudo apt-get install python3-tk
   ```
4. **Instalación de Git**:
   ```bash
   sudo apt-get install git
   ```

---

## Arquitectura del Software

### Componentes Principales

- **`lexer`**: Análisis léxico, creando tokens.
- **`parser`**: Análisis sintáctico según reglas de GLC.
- **`html_generator`**: Genera HTML.
- **`css_generator`**: Genera CSS.
- **Interfaz en Tkinter**: Permite cargar y analizar archivos.

### Visión General del Sistema

1. `lexer` convierte el archivo en tokens.
2. `parser` analiza sintaxis.
3. `html_generator` y `css_generator` generan archivos de salida.

---

## Algoritmos Implementados

### Análisis Léxico: AFD

Tokeniza el archivo en palabras clave, identificadores, operadores y números.

```text
1. Leer el archivo línea por línea.
2. Ignorar comentarios y líneas en blanco.
3. Procesar cada palabra.
4. Continuar hasta procesar todo el archivo.
```

### Análisis Sintáctico: Parser Descendente Recursivo

Verifica que los tokens sigan las reglas de una GLC:

```text
<S> ::= <comando> | <comando> <S>
<comando> ::= <declaracion> <propiedades> ";"
<declaracion> ::= "Contenedor" <identificador>
<propiedades> ::= <propiedad> | <propiedad> <propiedades>
```

### Generación de HTML y CSS

El compilador genera HTML y CSS según las definiciones en el archivo de entrada.

**Ejemplo HTML:**
```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="styles.css">
    <title>Mi Página Web</title>
</head>
<body>
    <div id="contlogin" style="width: 190px; height: 150px;">
        <label id="Nombre" style="width: 44px; height: 13px;">Nombre</label>
    </div>
</body>
</html>
```

**Ejemplo CSS:**
```css
#contlogin {
    position: absolute;
    width: 190px;
    height: 150px;
    background-color: rgb(47,79,79);
}

#Nombre {
    position: absolute;
    width: 44px;
    height: 13px;
    color: rgb(128,128,128);
}
```

---

## Estructura del Código

- **`src/`**: Contiene el código fuente.
  - `lexer.f95`: Análisis léxico.
  - `parser.f95`: Análisis sintáctico.
  - `html_generator.f95`: Genera HTML.
  - `css_generator.f95`: Genera CSS.

- **`tests/`**: Archivos de prueba.
- **`output/`**: Archivos HTML y CSS generados.

### Convenciones de Codificación
- **Nombres de Variables**: `snake_case`.
- **Comentarios**: Explicativos para funciones y bloques.
- **Indentación**: 4 espacios por nivel.

---

## Mantenimiento y Actualizaciones

### Mantenimiento Preventivo
- **Actualizar Dependencias**: Python, Tkinter y `gfortran`.
- **Pruebas de Regresión**: Ejecución tras cambios importantes.
- **Refactorización**: Revisar y limpiar código.

### Actualizaciones del Sistema
1. Descargar la última versión del repositorio.
2. Reemplazar archivos antiguos.
3. Ejecutar pruebas automáticas.

---

## Solución de Problemas

- **Error de Sintaxis**: Revisar formato del archivo de entrada.
- **Error de Lectura de Archivo**: Verificar existencia y permisos.

### Contacto para Soporte

**Correo Electrónico**: [3049321750116@ingenieria.usac.edu.gt](mailto:3049321750116@ingenieria.usac.edu.gt)

---