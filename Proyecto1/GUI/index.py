import subprocess
from tkinter import *
from tkinter import messagebox as MessageBox
from pathlib import Path
from graphviz import Digraph
from tkinter import filedialog as FileDialog
from io import open
from PIL import Image, ImageTk

# Create a new directed data_graph
dot = Digraph()
data_graph = { "name": "", "continents": []}

path = ""
graph_images_counter = 0

# función que se ejecuta al presionar el botón "Analizar"
def analize():
    # Obtener el dato ingresado en la entrada
    data = text_area.get("1.0", END)
    
    if data.strip() == "":
        MessageBox.showinfo("Informaicon", "Debe ingresar texto")
        return

    
    # Ejecutar el programa Fortran y enviar el dato
    result = subprocess.run(
        ["./built/main"],  # Ejecutable compilado
        input=data,  # Enviar el dato como cadena de texto
        stdout=subprocess.PIPE,  # Capturar la salida del programa
        text=True  # Asegurarse de que la salida se maneje como texto
    )

    if not result.stdout:
        MessageBox.showerror("Error", "Algo salio mal : ()")
        return

    output_lines = result.stdout.strip().split('\n')
    data_graph = { "name": "", "continents": []}
    continents = []

    for i in range(len(output_lines)):
        continent_contries_values = output_lines[i].split(";")

        if i == 0:
            data_graph["name"] = continent_contries_values[0]

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
                    "flag": country.split(",")[3].replace("\\", "/"),
                    "color": country.split(",")[4] 
                } for country in continent_contries_values[1::] ],
            }

            data_graph["continents"].append(continent)

    dot.node(data_graph["name"], data_graph["name"])

    for continent in data_graph["continents"]:
        dot.node(continent["name"], f"{continent['name']} | {continent['saturation']}", style='filled', fillcolor=f"{continent['color']}")
        dot.edge(data_graph["name"], continent["name"])

        for country in continent["countries"]:
            dot.node(country["name"], f"{country['name']} | {country['saturation']}", style='filled', fillcolor=f"{country['color']}")
            dot.edge(continent["name"], country["name"])

    global graph_images_counter
    graph_images_counter += 1

    dot.render(f"graph{graph_images_counter}", format='png', cleanup=True)
    load_image_graph()


def show_student_info():
    MessageBox.showerror("Datos estudiante", "202202410 - Marcos Daniel Bonifasi de Leon")

def open_file():
    global path
    path = FileDialog.askopenfilename(
        initialdir='.', 
        filetypes=(("Ficheros de texto", "*.ORG"),),
        title="Abrir un archivo ORG")

    if path != "":
        fichero = open(path, 'r')
        content = fichero.read()
        text_area.delete(1.0,'end')
        text_area.insert('insert', content)
        fichero.close()
        root.title(path + " - Mi editor")

def save():
    if path != "":
        content = text_area.get(1.0,'end-1c')
        fichero = open(path, 'w+')
        fichero.write(content)
        fichero.close()
    else:
        save_as()

def save_as():
    global path

    fichero = FileDialog.asksaveasfile(title="Guardar fichero", mode="w", defaultextension=".ORG")

    if fichero is not None:
        path = fichero.name
        content = text_area.get(1.0,'end-1c')
        fichero = open(path, 'w+')
        fichero.write(content)
        fichero.close()
    else:
        path = ""


def load_image_graph():
    global graph_images_counter

    if graph_images_counter == 0:
        return

    image = Image.open(f"graph{graph_images_counter}.png")
    photo = ImageTk.PhotoImage(image)
    
    # Update the label with the image
    image_label.config(image=photo)
    
    # Keep a reference to the image to prevent garbage collection
    image_label.image = photo


root = Tk()

menubar = Menu(root)
filemenu = Menu(menubar, tearoff=0)
# filemenu.add_command(label="Nuevo")
filemenu.add_command(label="Abrir", command=open_file)
filemenu.add_command(label="Guardar", command=save)
filemenu.add_command(label="Guardar como", command=save_as)
filemenu.add_separator()
filemenu.add_command(label="Salir", command=root.quit)
menubar.add_cascade(label="Menu", menu=filemenu)

filemenu_student = Menu(menubar, tearoff=0)
filemenu_student.add_command(label="Datos estudiante", command=show_student_info)
menubar.add_cascade(label="Acerca de", menu=filemenu_student)

# etiqueta 
etq = Label(root, text="Lexer LFP")
etq.pack()

# area de texto para el código fuente
text_area = Text(root, width=140, height=30)
text_area.place(x=20, y=30)

# igual al anterior text_area pero va ser utilizado como consola para mostrar los resultados
image_label = Label(root)
image_label.place(x=80, y=500)

# botón para analizar el código fuente
boton = Button(root, text="Analizar", width=10, height=2, command=analize)
boton.place(x=1050, y=100)

# boton_salir = Button(root, text="Salir", width=10, height=2, command=root.quit)
# boton_salir.place(x=670, y=550)

# boton_abrir = Button(root, text="Abrir", width=10, height=2, command=btn_abrir)
# boton_abrir.place(x=470, y=550)


root.config(menu=menubar)

root.title("LFP - Analizador Léxico")
root.geometry("1200x850")
root.mainloop()
