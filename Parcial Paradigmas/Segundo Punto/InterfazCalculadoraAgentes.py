import tkinter as tk
from mesa import Agent, Model
from mesa.time import BaseScheduler
from collections import deque



#Para elevar se utiliza ** .




class AgenteMatematico(Agent):
    def __init__(self, id_unico, modelo):
        super().__init__(id_unico, modelo)
        self.resultado = None

    def ejecutar(self, operandos):
        pass

class AgenteSuma(AgenteMatematico):
    def ejecutar(self, operandos):
        self.resultado = operandos[0] + operandos[1]
        return self.resultado

class AgenteResta(AgenteMatematico):
    def ejecutar(self, operandos):
        self.resultado = operandos[0] - operandos[1]
        return self.resultado

class AgenteMultiplicacion(AgenteMatematico):
    def ejecutar(self, operandos):
        self.resultado = operandos[0] * operandos[1]
        return self.resultado

class AgenteDivision(AgenteMatematico):
    def ejecutar(self, operandos):
        if operandos[1] != 0:
            self.resultado = operandos[0] / operandos[1]
        else:
            self.resultado = "Error: División por cero"
        return self.resultado

class AgentePotencia(AgenteMatematico):
    def ejecutar(self, operandos):
        self.resultado = operandos[0] ** operandos[1]
        return self.resultado

class AgenteEntradaSalida(Agent):
    def __init__(self, id_unico, modelo, var_resultado):
        super().__init__(id_unico, modelo)
        self.cola = deque()
        self.var_resultado = var_resultado

    def paso(self):
        if self.cola:
            expresion = self.cola.popleft()
            resultado = self.procesar_expresion(expresion)
            self.var_resultado.set(f"Resultado: {resultado}")

    def procesar_expresion(self, expresion):
        try:
            resultado = eval(expresion)
            return resultado
        except Exception:
            return "Error"

    def recibir_expresion(self, expresion):
        self.cola.append(expresion)

class ModeloCalculadora(Model):
    def __init__(self, var_resultado):
        self.scheduler = BaseScheduler(self)
        self.agentes = {
            'suma': AgenteSuma(1, self),
            'resta': AgenteResta(2, self),
            'multiplicacion': AgenteMultiplicacion(3, self),
            'division': AgenteDivision(4, self),
            'potencia': AgentePotencia(5, self),
            'entrada_salida': AgenteEntradaSalida(6, self, var_resultado)
        }
        
        for agente in self.agentes.values():
            self.scheduler.add(agente)

    def paso(self):
        self.scheduler.step()

class InterfazCalculadora:
    def __init__(self, ventana):
        self.ventana = ventana
        self.ventana.title("Calculadora Interactiva")
        self.entrada = tk.Entry(ventana, width=40)
        self.entrada.grid(row=0, column=0, columnspan=4)
        resultado_var = tk.StringVar()
        self.modelo_calculadora = ModeloCalculadora(resultado_var)

        botones = [
            ('1', 1), ('2', 1), ('3', 1), ('+', 1),
            ('4', 2), ('5', 2), ('6', 2), ('-', 2),
            ('7', 3), ('8', 3), ('9', 3), ('*', 3),
            ('C', 4), ('0', 4), ('=', 4), ('/', 4),
            ('^', 4)
        ]

        for texto_boton in botones:
            accion = lambda x=texto_boton[0]: self.presionar_boton(x)
            tk.Button(ventana, text=texto_boton[0], width=10, command=accion).grid(row=texto_boton[1], column=botones.index(texto_boton) % 4)

        tk.Button(ventana, text='C', width=10, command=self.limpiar).grid(row=4, column=0)
        tk.Button(ventana, text='=', width=10, command=self.calcular).grid(row=4, column=2)

    def presionar_boton(self, valor):
        actual = self.entrada.get()
        self.entrada.delete(0, tk.END)
        self.entrada.insert(0, actual + valor)

    def limpiar(self):
        self.entrada.delete(0, tk.END)

    def calcular(self):
        expresion = self.entrada.get()
        
        if expresion:  
            expresion = expresion.replace('^', '**')
            self.modelo_calculadora.agentes['entrada_salida'].recibir_expresion(expresion)
            resultado = str(self.modelo_calculadora.agentes['entrada_salida'].procesar_expresion(expresion))
            self.entrada.delete(0, tk.END)
            self.entrada.insert(0, resultado)

if __name__ == '__main__':
    ventana_principal = tk.Tk()
    app_calculadora = InterfazCalculadora(ventana_principal)
    
    ventana_principal.mainloop()



