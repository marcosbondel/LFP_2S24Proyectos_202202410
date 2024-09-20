from tkinter import *
from pathlib import Path
import subprocess
from graphviz import Digraph

# Create a new directed graph
dot = Digraph()

data_graph = {}

# función que se ejecuta al presionar el botón "Analizar"
def analize():
    # Obtener el dato ingresado en la entrada
    dato = text_area.get("1.0", END)
    
    # Ejecutar el programa Fortran y enviar el dato
    resultado = subprocess.run(
        ["./built/main"],  # Ejecutable compilado
        input=dato,  # Enviar el dato como cadena de texto
        stdout=subprocess.PIPE,  # Capturar la salida del programa
        text=True  # Asegurarse de que la salida se maneje como texto
    )

    if not resultado.stdout:
        return

    # print("")
    # print(resultado.stdout)
    # print("")

    output_lines = resultado.stdout.strip().split('\n')  # Dividir la salida en líneas
    graph = { "name": "", "continents": []}
    continents = []

    # print("")
    # print(output_lines)
    # print("")

    for i in range(len(output_lines)):
        continent_contries_values = output_lines[i].split(";")

        if i == 0:
            graph["name"] = continent_contries_values[0]

        if len(continent_contries_values) > 0 and i > 0:
            continent_info = continent_contries_values[0].split(",")
            continent = {
                "name": continent_info[0],
                "saturation": int(continent_info[1]),
                "color": continent_info[2],
                "countries": [{
                    "name": country.split(",")[0], 
                    "saturation": int(country.split(",")[1]), 
                    "population": int(country.split(",")[2]), 
                    # "flag": fr"{country.split(',')[3]}", 
                    "flag": country.split(",")[3].replace("\\", "/"),
                    "color": country.split(",")[4] 
                } for country in continent_contries_values[1::] ],
            }

            graph["continents"].append(continent)
        
    print(graph) 

    dot.node(graph["name"], graph["name"])

    for continent in graph["continents"]:
        dot.node(continent["name"], f"{continent['name']} | {continent['saturation']}", style='filled', fillcolor=f"{continent['color']}")
        dot.edge(graph["name"], continent["name"])

        for country in continent["countries"]:
            dot.node(country["name"], f"{country['name']} | {country['saturation']}", style='filled', fillcolor=f"{country['color']}")
            dot.edge(continent["name"], country["name"])



    dot.render('graph', format='png', cleanup=True)
    # dot.view()
    
    # if(resultado.stdout):
    #     print(resultado.stdout[0])
    
    # else:
    #     print("ERROR EN EL ARCHIVO DE ENTRADA")



def btn_abrir():
    archivo = open("./entrada.lfp", "r")
    texto = archivo.read()
    text_area.delete("1.0", END)
    text_area.insert("1.0", texto)
    archivo.close()

raiz = Tk()

# etiqueta 
etq = Label(raiz, text="EJEMPLO ANALIZADOR LÉXICO")
etq.pack()

# area de texto para el código fuente
text_area = Text(raiz, width=70, height=30)
text_area.place(x=30, y=50)

# igual al anterior text_area pero va ser utilizado como consola para mostrar los resultados
consola = Text(raiz, width=72, height=30)
consola.config(state=DISABLED)
consola.place(x=600, y=50)

# botón para analizar el código fuente
boton = Button(raiz, text="Analizar", width=10, height=2, command=analize)
boton.place(x=570, y=550)

boton_salir = Button(raiz, text="Salir", width=10, height=2, command=raiz.quit)
boton_salir.place(x=670, y=550)

boton_abrir = Button(raiz, text="Abrir", width=10, height=2, command=btn_abrir)
boton_abrir.place(x=470, y=550)

# tamaño de la ventana principal (ancho x alto)
raiz.geometry("1200x600")
# título de la ventana principal
raiz.title("LFP - Analizador Léxico")
raiz.mainloop()
