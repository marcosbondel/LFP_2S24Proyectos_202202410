from tkinter import *

# función que se ejecuta al presionar el botón "Analizar"
def btn_accion():
    texto = text_area.get("1.0", END)
    consola.config(state=NORMAL)
    consola.delete("1.0", END)
    consola.insert("1.0", texto)
    consola.config(state=DISABLED)

def btn_abrir():
    archivo = open("./entrada.lfp", "r")
    texto = archivo.read()
    text_area.delete("1.0", END)
    text_area.insert("1.0", texto)
    archivo.close()

window = Tk()

# etiqueta 
etq = Label(window, text="EJEMPLO ANALIZADOR LÉXICO")
etq.pack()

# area de texto para el código fuente
text_area = Text(window, width=70, height=30)
text_area.place(x=30, y=50)

# igual al anterior text_area pero va ser utilizado como consola para mostrar los resultados
consola = Text(window, width=72, height=30)
consola.config(state=DISABLED)
consola.place(x=600, y=50)

# botón para analizar el código fuente
boton = Button(window, text="Analizar", width=10, height=2, command=btn_accion)
boton.place(x=570, y=550)

boton_salir = Button(window, text="Salir", width=10, height=2, command=window.quit)
boton_salir.place(x=670, y=550)

boton_abrir = Button(window, text="Abrir", width=10, height=2, command=btn_abrir)
boton_abrir.place(x=470, y=550)

# tamaño de la ventana principal (ancho x alto)
window.geometry("1200x600")
# título de la ventana principal
window.title("LEXER")
window.mainloop()