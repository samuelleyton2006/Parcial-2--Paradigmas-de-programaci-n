package com.app.calculadora.cientifica.clases

import com.app.calculadora.cientifica.excepciones.EntradaInvalidaException

// Clase base Calculadora
open class Calculadora(private val valor: Double) {

    // Operación de suma
    fun suma(otro: Calculadora): Calculadora {
        return Calculadora(this.valor + otro.valor)
    }

    // Operación de resta
    fun resta(otro: Calculadora): Calculadora {
        return Calculadora(this.valor - otro.valor)
    }

    // Operación de multiplicación
    fun multiplicacion(otro: Calculadora): Calculadora {
        return Calculadora(this.valor * otro.valor)
    }

    // Operación de división con manejo de excepción
    @Throws(EntradaInvalidaException::class)
    fun division(otro: Calculadora): Calculadora {
        if (otro.valor == 0.0) {
            throw EntradaInvalidaException("Error: No se puede dividir entre cero.")
        }
        return Calculadora(this.valor / otro.valor)
    }

    // Método para obtener el valor actual
    fun obtenerValor(): Double {
        return valor
    }
}