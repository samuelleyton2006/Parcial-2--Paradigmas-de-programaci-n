from mesa import Agent, Model
from mesa.time import BaseScheduler
from collections import deque

# Agente base para las operaciones
class OperationAgent(Agent):
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.result = None

    def step(self):
        pass  # Los agentes realizarán las operaciones cuando se les envíe un mensaje


class SumAgent(OperationAgent):
    def handle(self, operands):
        self.result = operands[0] + operands[1]
        return self.result


class SubtractAgent(OperationAgent):
    def handle(self, operands):
        self.result = operands[0] - operands[1]
        return self.result


class MultiplyAgent(OperationAgent):
    def handle(self, operands):
        self.result = operands[0] * operands[1]
        return self.result


class DivideAgent(OperationAgent):
    def handle(self, operands):
        if operands[1] != 0:
            self.result = operands[0] / operands[1]
        else:
            self.result = "Error: División por cero"
        return self.result


class PowerAgent(OperationAgent):
    def handle(self, operands):
        self.result = operands[0] ** operands[1]
        return self.result


# Agente para gestionar la entrada/salida
class InputOutputAgent(Agent):
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.queue = deque()

    def step(self):
        if self.queue:
            expression = self.queue.popleft()
            result = self.evaluate_expression(expression)
            print(f"Resultado de la expresión {expression}: {result}")

    # Algoritmo Shunting Yard para convertir a notación postfija
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
                operator_stack.pop()  # Pop the '('

        while operator_stack:
            output_queue.append(operator_stack.pop())

        return output_queue

    # Evaluar la expresión en notación postfija
    def evaluate_postfix(self, postfix):
        stack = []
        
        for token in postfix:
            if isinstance(token, (int, float)):
                stack.append(token)
            else:
                b = stack.pop()
                a = stack.pop()
                if token == '+':
                    result = self.model.sum_agent.handle([a, b])
                elif token == '-':
                    result = self.model.subtract_agent.handle([a, b])
                elif token == '*':
                    result = self.model.multiply_agent.handle([a, b])
                elif token == '/':
                    result = self.model.divide_agent.handle([a, b])
                elif token == '^':
                    result = self.model.power_agent.handle([a, b])
                stack.append(result)

        return stack[0]  # El resultado final estará en la cima de la pila

    def evaluate_expression(self, expression):
        postfix = self.shunting_yard(expression)
        result = self.evaluate_postfix(postfix)
        return result

    def receive_expression(self, expression):
        self.queue.append(expression)


# El modelo que coordina a los agentes
class CalculatorModel(Model):
    def __init__(self):
        self.schedule = BaseScheduler(self)
        
        # Crear los agentes para las operaciones
        self.sum_agent = SumAgent(1, self)
        self.subtract_agent = SubtractAgent(2, self)
        self.multiply_agent = MultiplyAgent(3, self)
        self.divide_agent = DivideAgent(4, self)
        self.power_agent = PowerAgent(5, self)
        self.io_agent = InputOutputAgent(6, self)
        
        # Añadir los agentes al scheduler
        self.schedule.add(self.sum_agent)
        self.schedule.add(self.subtract_agent)
        self.schedule.add(self.multiply_agent)
        self.schedule.add(self.divide_agent)
        self.schedule.add(self.power_agent)
        self.schedule.add(self.io_agent)

    def step(self):
        self.schedule.step()


# Ejecución del modelo
if __name__ == '__main__':
    model = CalculatorModel()
    
    # Ejemplo de expresión
    expression = [2, '+', 3, '/', 4,'^',2]  # Esto debe dar 14, porque 3*4=12, luego 12+2=14
    model.io_agent.receive_expression(expression)
    
    # Ejecutar un paso de simulación
    model.step()