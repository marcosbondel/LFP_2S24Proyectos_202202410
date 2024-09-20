# from tkinter import *
# from tkinter import filedialog as FileDialog
# from tkinter import messagebox as MessageBox
# from io import open
# import subprocess

# path = ""

# def new_file():
#     global path
#     message.set("Nuevo fichero")
#     path = ""
#     text_editor.delete(1.0, "end")
#     root.title("Mi editor")

# def open_file():
#     global path
#     message.set("Abrir fichero")
#     path = FileDialog.askopenfilename(
#         initialdir='.', 
#         filetypes=(("Text files", "*.txt"),),
#         title="Abrir un fichero de text_editor")

#     if path != "":
#         file = open(path, 'r')
#         content = file.read()
#         text_editor.delete(1.0,'end')
#         text_editor.insert('insert', content)
#         file.close()
#         root.title(path + " - Mi editor")

# def save_file():
#     message.set("Guardar fichero")
#     if path != "":
#         content = text_editor.get(1.0,'end-1c')
#         file = open(path, 'w+')
#         file.write(content)
#         file.close()
#         message.set("Fichero guardado correctamente")
#     else:
#         save_as()

# def save_as():
#     global path
#     message.set("Guardar fichero como")

#     file = FileDialog.asksaveasfile(title="Guardar fichero", 
#         mode="w", defaultextension=".txt")

#     if file is not None:
#         path = file.name
#         content = text_editor.get(1.0,'end-1c')
#         file = open(path, 'w+')
#         file.write(content)
#         file.close()
#         message.set("Fichero guardado correctamente")
#     else:
#         message.set("Guardado cancelado")
#         path = ""

# def about():
#     MessageBox.showinfo("Acerca de", "202202410 - Marcos Daniel Bonifasi de Leon")

# # Root window configuration
# root = Tk()
# root.title("Mi editor")

# # Top menu
# menubar = Menu(root)
# filemenu1 = Menu(menubar, tearoff=0)
# filemenu1.add_command(label="Nuevo", command=new_file)
# filemenu1.add_command(label="Abrir", command=open_file)
# filemenu1.add_command(label="Guardar", command=save_file)
# filemenu1.add_command(label="Guardar como", command=save_as)
# filemenu1.add_separator()
# filemenu1.add_command(label="Exit", command=root.quit)
# menubar.add_cascade(menu=filemenu1, label="File")

# filemenu2 = Menu(menubar, tearoff=0)
# filemenu2.add_command(label="Estudiante", command=about)
# menubar.add_cascade(menu=filemenu2, label="Acerca de")


# # Hijo de root, no ocurre nada
# frame = Frame(root)  



# # Central text editor
# text_editor = Text(frame)
# text_editor.pack(fill="both", expand=1)
# # text_editor.config(bd=0, padx=8, pady=6, font=("Consolas",12))

# # frame.config(width=780,height=320) 
# # frame.place(x=0, y=0) 
# frame.pack()     

# # text_editor = Text(root, width=70, height=30)
# # text_editor.place(x=0, y=0)

# # Bottom monitor
# # message = StringVar()
# # message.set("Bienvenido a tu LFP Editor")
# # monitor = Label(root, textvar=message, justify='left')
# # monitor.pack(side="left")

# root.geometry("1200x600")

# root.config(menu=menubar)
# # Application loop
# root.mainloop()



from tkinter import *
import subprocess


# función que se ejecuta al presionar el botón "Analizar"
def analize():
    # texto = text_area.get("1.0", END)
    # consola.config(state=NORMAL)
    # consola.delete("1.0", END)
    # consola.insert("1.0", texto)
    # consola.config(state=DISABLED)

    # Obtener el dato ingresado en la entrada
    dato = text_area.get("1.0", END)
    
    # Ejecutar el programa Fortran y enviar el dato
    resultado = subprocess.run(
        ["./built/main"],  # Ejecutable compilado
        input=dato,  # Enviar el dato como cadena de texto
        stdout=subprocess.PIPE,  # Capturar la salida del programa
        text=True  # Asegurarse de que la salida se maneje como texto
    )

    # Mostrar la salida en el área de texto
    consola.insert(END, resultado.stdout)
    print(resultado.stdout)

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
