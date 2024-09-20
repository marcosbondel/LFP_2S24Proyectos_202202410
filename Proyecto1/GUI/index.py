from tkinter import *
from tkinter import messagebox as MessageBox
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

    output_lines = resultado.stdout.strip().split('\n')
    graph = { "name": "", "continents": []}
    continents = []

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

    dot.node(graph["name"], graph["name"])

    for continent in graph["continents"]:
        dot.node(continent["name"], f"{continent['name']} | {continent['saturation']}", style='filled', fillcolor=f"{continent['color']}")
        dot.edge(graph["name"], continent["name"])

        for country in continent["countries"]:
            dot.node(country["name"], f"{country['name']} | {country['saturation']}", style='filled', fillcolor=f"{country['color']}")
            dot.edge(continent["name"], country["name"])



    dot.render('graph', format='png', cleanup=True)


def show_student_info():
    MessageBox.showinfo("Datos estudiante", "202202410 - Marcos Daniel Bonifasi de Leon")


def btn_abrir():
    archivo = open("./entrada.lfp", "r")
    texto = archivo.read()
    text_area.delete("1.0", END)
    text_area.insert("1.0", texto)
    archivo.close()


root = Tk()


menubar = Menu(root)
filemenu = Menu(menubar, tearoff=0)
filemenu.add_command(label="Nuevo")
filemenu.add_command(label="Abrir")
filemenu.add_command(label="Guardar")
filemenu.add_command(label="Guardar como")
filemenu.add_separator()
filemenu.add_command(label="Salir", command=root.quit)
menubar.add_cascade(label="Archivo", menu=filemenu)

filemenu_student = Menu(menubar, tearoff=0)
filemenu_student.add_command(label="Datos estudiante", command=show_student_info)
menubar.add_cascade(label="Acerca de", menu=filemenu_student)



# etiqueta 
etq = Label(root, text="EJEMPLO ANALIZADOR LÉXICO")
etq.pack()

# area de texto para el código fuente
text_area = Text(root, width=70, height=30)
text_area.place(x=30, y=50)

# igual al anterior text_area pero va ser utilizado como consola para mostrar los resultados
consola = Text(root, width=72, height=30)
consola.config(state=DISABLED)
consola.place(x=600, y=50)

# botón para analizar el código fuente
boton = Button(root, text="Analizar", width=10, height=2, command=analize)
boton.place(x=570, y=550)

boton_salir = Button(root, text="Salir", width=10, height=2, command=root.quit)
boton_salir.place(x=670, y=550)

boton_abrir = Button(root, text="Abrir", width=10, height=2, command=btn_abrir)
boton_abrir.place(x=470, y=550)

root.config(menu=menubar)

# tamaño de la ventana principal (ancho x alto)
root.geometry("1200x600")
# título de la ventana principal
root.title("LFP - Analizador Léxico")
root.mainloop()
