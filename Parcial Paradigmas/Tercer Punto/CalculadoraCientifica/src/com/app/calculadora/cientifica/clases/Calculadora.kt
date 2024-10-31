package com.app.calculadora.cientifica.clases

// Clase base para operaciones básicas
open class Calculadora(var valor: Double) {

    // Suma
    fun suma(otroValor: Double): Double {
        return valor + otroValor
    }

    // Resta
    fun resta(otroValor: Double): Double {
        return valor - otroValor
    }

    // Multiplicación
    fun multiplicacion(otroValor: Double): Double {
        return valor * otroValor
    }

    // División con manejo de excepción
    fun division(otroValor: Double): Double {
        if (otroValor == 0.0) {
            throw ArithmeticException("Error: División por cero.")
        }
        return valor / otroValor
    }

    // Método para obtener el valor actual
    fun obtenerValor(): Double {
        return valor
    }
}