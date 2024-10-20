# LFP

## App execution
In order to execute this program, please run the following commands through the bash.

```bash
    # 1. Generate executable (compiled)

    gfortran ./Proyecto1/modules/AppModule.f90 ./Proyecto1/modules/ErrorModule.f90 ./Proyecto1/utils/HelperModule.f90 ./Proyecto1/utils/LexerModule.f90 ./Proyecto1/modules/TokenModule.f90 ./Proyecto1/main.f90 -o ./Proyecto1/built/main

    # 2. Run executable
    ./Proyecto1/built/main

    # 3. Run Desktop app
    python3 ./Proyecto1/GUI/index.py
```


```bash
    # 1. Generate executable (compiled)

    gfortran ./Proyecto2/transpiler/src/modules/token.f90 ./Proyecto2/transpiler/src/modules/error.f90 ./Proyecto2/transpiler/src/tools/scanner.f90 ./Proyecto2/transpiler/src/tools/parser.f90 ./Proyecto2/transpiler/src/utils.f90 ./Proyecto2/transpiler/src/transpiler.f90 -o ./Proyecto2/transpiler/built/transpiler

    # 2. Run executable
    ./Proyecto2/built/main

    # 3. Run Desktop app
    python3 ./Proyecto2/main.py
```




## Troubleshooting

It seems like Anaconda uses another version of a certain Python/PIP library
```bash
    conda deactivate
```

## Documentation

- User manual
- Technical manual


---------

Built with :blue_heart: by **OpenECYS**