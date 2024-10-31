package com.app.calculadora.cientifica.clases

import com.app.calculadora.cientifica.excepciones.EntradaInvalidaException
import java.lang.Math.pow
import kotlin.math.*

class CalculadoraCientifica(valor: Double) : Calculadora(valor) {

    // Raíz cuadrada con manejo de excepción
    @Throws(EntradaInvalidaException::class)
    fun raizCuadrada(): Double {
        if (obtenerValor() < 0) {
            throw EntradaInvalidaException("Error: No se puede calcular la raíz cuadrada de un número negativo.")
        }
        return sqrt(obtenerValor())
    }

    // Raíz cúbica
    fun raizCubica(): Double {
        return cbrt(obtenerValor())
    }

    // Funciones trigonométricas
    fun calcularSeno(): Double = sin(obtenerValor())
    fun calcularCoseno(): Double = cos(obtenerValor())
    fun calcularTangente(): Double = tan(obtenerValor())

    // Potencia
    fun potencia(exponente: Double): Double {
        return pow(obtenerValor(), exponente)
    }

    // Logaritmos con manejo de excepción
    @Throws(EntradaInvalidaException::class)
    fun logaritmoBase10(): Double {
        if (obtenerValor() <= 0) {
            throw EntradaInvalidaException("El número debe ser mayor que cero.")
        }
        return log10(obtenerValor())
    }

    fun logaritmoNatural(): Double {
        if (obtenerValor() <= 0) {
            throw EntradaInvalidaException("El número debe ser mayor que cero.")
        }
        return ln(obtenerValor())
    }

    // Conversión de grados a radianes y viceversa
    fun gradosARadianes(): Double = Math.toRadians(obtenerValor())
    fun radianesAGrados(): Double = Math.toDegrees(obtenerValor())
}