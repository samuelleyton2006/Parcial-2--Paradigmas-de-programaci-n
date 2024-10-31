import tkinter as tk
from collections import deque


class OperationAgent:
    def __init__(self):
        self.result = None

    def handle(self, operands):
        pass  

class SumAgent(OperationAgent):
    def handle(self, operands):
        return operands[0] + operands[1]


class SubtractAgent(OperationAgent):
    def handle(self, operands):
        return operands[0] - operands[1]


class MultiplyAgent(OperationAgent):
    def handle(self, operands):
        return operands[0] * operands[1]


class DivideAgent(OperationAgent):
    def handle(self, operands):
        if operands[1] != 0:
            return operands[0] / operands[1]
        else:
            return "Error: División por cero"


class PowerAgent(OperationAgent):
    def handle(self, operands):
        return operands[0] ** operands[1]


class InputOutputAgent:
    def __init__(self):
        self.queue = deque()
        self.sum_agent = SumAgent()
        self.subtract_agent = SubtractAgent()
        self.multiply_agent = MultiplyAgent()
        self.divide_agent = DivideAgent()
        self.power_agent = PowerAgent()


    def shunting_yard(self, expression):
        precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}
        output_queue = []
        operator_stack = []

        for token in expression:
            if isinstance(token, (int, float)):
                output_queue.append(token)
            elif token in precedence:
                while (operator_stack and
                       operator_stack[-1] != '(' and
                       precedence.get(token, 0) <= precedence.get(operator_stack[-1], 0)):
                    output_queue.append(operator_stack.pop())
                operator_stack.append(token)
            elif token == '(':
                operator_stack.append(token)
            elif token == ')':
                while operator_stack and operator_stack[-1] != '(':
                    output_queue.append(operator_stack.pop())
                operator_stack.pop()

        while operator_stack:
            output_queue.append(operator_stack.pop())

        return output_queue

    # Evaluar expresión postfija
    def evaluate_postfix(self, postfix):
        stack = []
        
        for token in postfix:
            if isinstance(token, (int, float)):
                stack.append(token)
            else:
                b = stack.pop()
                a = stack.pop()
                if token == '+':
                    result = self.sum_agent.handle([a, b])
                elif token == '-':
                    result = self.subtract_agent.handle([a, b])
                elif token == '*':
                    result = self.multiply_agent.handle([a, b])
                elif token == '/':
                    result = self.divide_agent.handle([a, b])
                elif token == '^':
                    result = self.power_agent.handle([a, b])
                stack.append(result)

        return stack[0]

    def evaluate_expression(self, expression):
        postfix = self.shunting_yard(expression)
        result = self.evaluate_postfix(postfix)
        return result


# Interfaz gráfica con Tkinter
class CalculatorApp:
    def __init__(self, root):
        self.io_agent = InputOutputAgent()
        self.root = root
        self.root.title("Calculadora Basada en Agentes")
        
       
        self.expression_entry = tk.Entry(root, width=40, font=("Arial", 14))
        self.expression_entry.grid(row=0, column=0, columnspan=4)

        # Botónes 
        self.calculate_button = tk.Button(root, text="Calcular", command=self.calculate, font=("Arial", 14))
        self.calculate_button.grid(row=1, column=0, columnspan=4)

       
        self.result_label = tk.Label(root, text="Resultado:", font=("Arial", 14))
        self.result_label.grid(row=2, column=0, columnspan=4)



    def calculate(self):
        expression_str = self.expression_entry.get()
        
        
        tokens = self.tokenize_expression(expression_str)
        result = self.io_agent.evaluate_expression(tokens)
        
        
        self.result_label.config(text=f"Resultado: {result}")

    def tokenize_expression(self, expression):
        tokens = []
        number = ''
        for char in expression:
            if char.isdigit() or char == '.':
                number += char  # Construccion del numero o definicion de el numero dentro del espacio a llenar
            
            else:
                if number:
                    tokens.append(float(number) if '.' in number else int(number))
                    number = ''
                if char in '+-*/^()':
                    tokens.append(char)
        if number:
            tokens.append(float(number) if '.' in number else int(number))
        return tokens



if __name__ == '__main__':
    root = tk.Tk()
    app = CalculatorApp(root)
    root.mainloop()
