/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.app.calculadora.cientifica.clases;

import com.app.calculadora.cientifica.excepciones.EntradaInvalidaException;

/**
 *
 * @author trian
 */
public class CalculadoraCientifica extends Calculadora {

    /*
    Raices
     */
    public double raizCuadrada(double numero) throws EntradaInvalidaException {
        if (numero < 0) {
            throw new EntradaInvalidaException("Error: No se puede calcular la raíz cuadrada de un número negativo.");
        }
        return Math.sqrt(numero);
    }

    public double raizCubica(double numero) throws EntradaInvalidaException {
        if (numero < 0) {
            throw new EntradaInvalidaException("Error: No se puede calcular la raíz cuadrada de un número negativo.");
        }
        return Math.cbrt(numero);
    }

    /*
    Funciones trigonometricas en java
     */
    public double calcularSeno(double numero) {
        return Math.sin(numero);
    }

    public double calcularCoseno(double numero) {
        return Math.cos(numero);
    }

    public double calcularTangente(double numero) {
        return Math.tan(numero);
    }

    /*
    Potencias
     */
    public double potencia(double base, double exponente) {
        return Math.pow(base, exponente);
    }

    /*
    Logaritmos
     */
    // Logaritmo base 10
    public static double calcularLogaritmoBase10(double numero) throws EntradaInvalidaException {
        if (numero <= 0) {
            throw new EntradaInvalidaException("El número debe ser mayor que cero.");
        }
        return Math.log10(numero);
    }

    // Logaritmo base e
    public static double calcularLogaritmoNatural(double numero) throws EntradaInvalidaException {
        if (numero <= 0) {
            throw new EntradaInvalidaException("El número debe ser mayor que cero.");
        }
        return Math.log(numero);
    }

    /*
    Metodos que permite la conversion de grados a radianes y viceserva
     */
    public static double gradosARadianes(double grados) {
        return Math.toRadians(grados);
    }

    public static double radianesAGrados(double radianes) {
        return Math.toDegrees(radianes);
    }

    public CalculadoraCientifica(int valor) {
        super(valor);
    }

    public CalculadoraCientifica(double valor) {
        super(valor);
    }
}
