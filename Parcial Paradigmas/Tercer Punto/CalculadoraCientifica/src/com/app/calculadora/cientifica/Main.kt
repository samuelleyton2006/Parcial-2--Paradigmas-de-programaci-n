package com.app.calculadora.cientifica.clases

import javax.script.ScriptEngineManager
import javax.script.ScriptException

fun main() {
    println("Advertencia: Asegurese de dejar espacio entre los valores y los signos de operacion porfavor")
    val scanner = java.util.Scanner(System.`in`)

    println("Ingresa una expresión matemática (por ejemplo: 2 + 3 * sin(45) - log(10)): ")
    val expresion = scanner.nextLine()

    // Crear una instancia de la calculadora científica
    val calculadoraCientifica = CalculadoraCientifica(0.0)

    // Crear un ScriptEngine para evaluar la expresión
    val scriptEngine = ScriptEngineManager().getEngineByName("JavaScript")

    try {
        // Evaluar la expresión ingresada
        val resultado = scriptEngine.eval(expresion) as Double
        println("Resultado: $resultado")
    } catch (e: ScriptException) {
        println("Operación desconocida: ${e.message}")
    } catch (e: Exception) {
        println("Error: ${e.message}")
    }
}