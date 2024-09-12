# LFP

## App execution
In order to execute this program, please run the following commands through the bash.

```bash
    # 1. Generate executable (compiled)
    gfortran ./Proyecto1/main.f90 -o main -g -fcheck=all

    # 2. From a different directory
    gfortran ./Proyecto1/modules/TokenModule.f90 ./Proyecto1/main.f90 -o ./Proyecto1/main -g -fcheck=all
    # Run executable
    ./Proyecto1/main
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