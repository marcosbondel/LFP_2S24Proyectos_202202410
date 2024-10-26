
import subprocess
from tkinter import *
from tkinter import messagebox as MessageBox
from tkinter import ttk
from pathlib import Path
from tkinter import filedialog as FileDialog
from io import open
from PIL import Image, ImageTk


path = ""
graph_images_counter = 0

tokens = []
errors = []

def analyze():
    global tokens
    data = text_area.get("1.0", END)
    if data.strip() == "":
        MessageBox.showinfo("Information", "Please enter text")
        return
    result = subprocess.run(
        ["./Proyecto2/transpiler/built/transpiler"],
        input=data,
        stdout=subprocess.PIPE,
        text=True
    )
    if not result.stdout:
        MessageBox.showerror("Error", "Something went wrong : ()")
        return

    # print(result.stdout.strip().split('-ERROR-'))
    output_lines = result.stdout.strip().split('\n')
    
    result = []
    MessageBox.showinfo("Information", "Analisis Finalizado!")

    for i in range(len(output_lines)):
        lines = output_lines[i].split(',')

        if(lines[0] == '-ERROR-'):
            global tokens
            tokens = []
            tree_errors.insert("", "end", values=lines[1:])
        elif(lines[0] == '-SUCCESS-'):
            tokens.append(lines[1:])

def show_student_info():
    MessageBox.showerror("Student Data", "202202410 - Marcos Daniel Bonifasi de Leon")

def delete_all_records_tree_errors():
    for record in tree_errors.get_children():
        tree_errors.delete(record)

def new_file():
    global path
    path = FileDialog.askopenfilename(
        initialdir='.', 
        filetypes=(("Text files", "*.LFP"),),
        title="Open an LFP file")
    if path != "":
        with open(path, 'r') as fichero:
            content = fichero.read()
            text_area.delete(1.0,'end')
            text_area.insert('insert', content)
        root.title(path + " - My Editor")

def open_file():
    global path
    path = FileDialog.askopenfilename(
        initialdir='.', 
        filetypes=(("Ficheros de texto", "*.LFP *.lfp"),),
        title="Open an LFP file")
    if path != "":
        with open(path, 'r') as fichero:
            content = fichero.read()
            text_area.delete(1.0, 'end')
            text_area.insert('insert', content)
        root.title(path + " - My Editor")

def save():
    data = text_area.get("1.0", END)
    if data.strip() == "":
        MessageBox.showinfo("Information", "Please enter text")
        return
    if path != "":
        with open(path, 'w+') as fichero:
            content = text_area.get(1.0,'end-1c')
            fichero.write(content)
    else:
        save_as()

def save_as():
    global path
    fichero = FileDialog.asksaveasfile(title="Save file", mode="w", defaultextension=".LFP")
    data = text_area.get("1.0", END)
    if data.strip() == "":
        MessageBox.showinfo("Information", "Please enter text")
        return
    if fichero is not None:
        path = fichero.name
        with open(path, 'w+') as fichero:
            content = text_area.get(1.0,'end-1c')
            fichero.write(content)
    else:
        path = ""
def show_tokens():
    global tokens
    token_window = Toplevel(root)
    token_window.title("Tokens")
    token_window.geometry("400x300")

    # Create a Treeview widget in the new window
    tree = ttk.Treeview(token_window, columns=("No", "Lexema", "Fila", "Columna", "Tipo"), show='headings')
    tree.heading("No", text="No")
    tree.heading("Lexema", text="Lexema")
    tree.heading("Fila", text="Fila")
    tree.heading("Columna", text="Columna")
    tree.heading("Tipo", text="Tipo")
    tree.pack(fill=BOTH, expand=True)

    # # Insert tokens into the table
    for token in tokens:
        tree.insert("", "end", values=token)

def clear_text():
    text_area.delete('1.0', END)

def add_record(records):
    tree.insert("", "end", values=records)

# Function to update coordinates
def update_coordinates(event):
    coord_label.config(text=f"Posicion: x={event.x}, y={event.y}")

root = Tk()

menubar = Menu(root)
filemenu = Menu(menubar, tearoff=0)
filemenu.add_command(label="Open", command=open_file)
filemenu.add_command(label="New", command=new_file)
filemenu.add_command(label="Save", command=save)
filemenu.add_command(label="Save As", command=save_as)
filemenu.add_separator()
filemenu.add_command(label="Exit", command=root.quit)
menubar.add_cascade(label="Menu", menu=filemenu)

filemenu_student = Menu(menubar, tearoff=0)
filemenu_student.add_command(label="Analisis", command=show_student_info)
menubar.add_cascade(label="About", menu=filemenu_student)

view_tokens_menu = Menu(menubar, tearoff=0)
view_tokens_menu.add_command(label="Tokens", command=show_tokens)
menubar.add_cascade(label="Ver Tokens", menu=view_tokens_menu)

filemenu_student = Menu(menubar, tearoff=0)
filemenu_student.add_command(label="Student Data", command=show_student_info)
menubar.add_cascade(label="About", menu=filemenu_student)

etq = Label(root, text="LFP Transpiler")
etq.pack()

text_area = Text(root, width=140, height=20)
text_area.place(x=20, y=30)
# text_area.insert(END, '''

# ''')

image_label = Label(root)
image_label.place(x=80, y=500)

btnAnalyze = Button(root, text="Analyze", width=10, height=2, command=analyze)
btnAnalyze.place(x=1050, y=100)

btnClear = Button(root, text="Clear", width=10, height=2, command=clear_text)
btnClear.place(x=1050, y=200)

# Table setup
table_frame = Frame(root)
table_frame.place(x=20, y=450)

tree_errors = ttk.Treeview(table_frame, columns=("Column1", "Column2", "Column3", "Column4", "Column5"), show='headings')
tree_errors.heading("Column1", text="Tipo")
tree_errors.heading("Column2", text="Linea")
tree_errors.heading("Column3", text="Columna")
tree_errors.heading("Column4", text="Token")
tree_errors.heading("Column5", text="Descripcion")
tree_errors.pack()

# btnAddRecord = Button(root, text="Add Record", width=10, height=2, command=add_record)
# btnAddRecord.place(x=1050, y=300)

# Coordinate label setup
coord_label = Label(root, text="Coordinates: x=0, y=0", font=("Arial", 10))
coord_label.place(x=20, y=820)

# Binding motion event to update_coordinates function
root.bind("<Motion>", update_coordinates)

root.config(menu=menubar)

root.title("LFP - Transpiler")
root.geometry("1200x850")
root.mainloop()
