# Manual de Usuario

## Tabla de contenidos

## Ejecutar App

Primero nos aseguramos de estar en la ubicación raiz de nuestra aplicación.

Luego, se debe compilar el analizador por medio de la terminal con el siguiente comando.

```bash
    gfortran ./Proyecto1/modules/AppModule.f90 ./Proyecto1/modules/ErrorModule.f90 ./Proyecto1/utils/HelperModule.f90 ./Proyecto1/utils/LexerModule.f90 ./Proyecto1/modules/TokenModule.f90 ./Proyecto1/main.f90 -o ./Proyecto1/built/main
```

Esto generará nuestro archivo ejecutable, para luego ser utilizado por la aplicación de escritorio.

Luego procedemos a ejecutar la aplicación de escritorio por me dio de la terminal con el siguiente comando.


```bash
    python3 ./Proyecto1/GUI/index.py
```

Te deberia abrir el una ventana emergente mostrando lo siguiente.

[Inicio app](./screenshots_guide/ug_1.png)