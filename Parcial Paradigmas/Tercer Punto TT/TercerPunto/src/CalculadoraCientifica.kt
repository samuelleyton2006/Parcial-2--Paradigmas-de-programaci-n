package com.app.calculadora.cientifica.clases

import com.app.calculadora.cientifica.excepciones.EntradaInvalidaException
import java.lang.Math.toDegrees
import java.lang.Math.toRadians
import kotlin.math.pow
import kotlin.math.sqrt
import kotlin.math.cbrt
import kotlin.math.sin
import kotlin.math.cos
import kotlin.math.tan
import kotlin.math.log10
import kotlin.math.ln


// Calculadora científica, heredando de Calculadora
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
`
    // Funciones trigonométricas
    fun calcularSeno(): Double = sin(obtenerValor())
    fun calcularCoseno(): Double = cos(obtenerValor())
    fun calcularTangente(): Double = tan(obtenerValor())

    // Potencia
    fun potencia(exponente: Double): Double {
        return obtenerValor().pow(exponente)
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
    fun gradosARadianes(): Double = toRadians(obtenerValor())
    fun radianesAGrados(): Double = toDegrees(obtenerValor())
}