from tkinter import *
from tkinter import filedialog as FileDialog
from tkinter import messagebox as MessageBox
from io import open

path = ""

def new_file():
    global path
    message.set("Nuevo fichero")
    path = ""
    text_editor.delete(1.0, "end")
    root.title("Mi editor")

def open_file():
    global path
    message.set("Abrir fichero")
    path = FileDialog.askopenfilename(
        initialdir='.', 
        filetypes=(("Text files", "*.txt"),),
        title="Abrir un fichero de text_editor")

    if path != "":
        file = open(path, 'r')
        content = file.read()
        text_editor.delete(1.0,'end')
        text_editor.insert('insert', content)
        file.close()
        root.title(path + " - Mi editor")

def save_file():
    message.set("Guardar fichero")
    if path != "":
        content = text_editor.get(1.0,'end-1c')
        file = open(path, 'w+')
        file.write(content)
        file.close()
        message.set("Fichero guardado correctamente")
    else:
        save_as()

def save_as():
    global path
    message.set("Guardar fichero como")

    file = FileDialog.asksaveasfile(title="Guardar fichero", 
        mode="w", defaultextension=".txt")

    if file is not None:
        path = file.name
        content = text_editor.get(1.0,'end-1c')
        file = open(path, 'w+')
        file.write(content)
        file.close()
        message.set("Fichero guardado correctamente")
    else:
        message.set("Guardado cancelado")
        path = ""

def about():
    MessageBox.showinfo("Acerca de", "202202410 - Marcos Daniel Bonifasi de Leon")

# Root window configuration
root = Tk()
root.title("Mi editor")

# Top menu
menubar = Menu(root)
filemenu1 = Menu(menubar, tearoff=0)
filemenu1.add_command(label="Nuevo", command=new_file)
filemenu1.add_command(label="Abrir", command=open_file)
filemenu1.add_command(label="Guardar", command=save_file)
filemenu1.add_command(label="Guardar como", command=save_as)
filemenu1.add_separator()
filemenu1.add_command(label="Exit", command=root.quit)
menubar.add_cascade(menu=filemenu1, label="File")

filemenu2 = Menu(menubar, tearoff=0)
filemenu2.add_command(label="Estudiante", command=about)
menubar.add_cascade(menu=filemenu2, label="Acerca de")

# Central text editor
text_editor = Text(root)
text_editor.pack(fill="both", expand=1)
text_editor.config(bd=0, padx=6, pady=4, font=("Consolas",12))

# Bottom monitor
message = StringVar()
message.set("Bienvenido a tu LFP Editor")
monitor = Label(root, textvar=message, justify='left')
monitor.pack(side="left")

root.config(menu=menubar)
# Application loop
root.mainloop()
