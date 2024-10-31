/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.app.calculadora.cientifica.clases;

import com.app.calculadora.cientifica.excepciones.EntradaInvalidaException;

public class Calculadora {

    private double valor;

    // Constructor para números enteros
    public Calculadora(int valor) {
        this.valor = valor;
    }

    // Constructor para números decimales
    public Calculadora(double valor) {
        this.valor = valor;
    }

    public Calculadora suma(Calculadora numero2) {
        return new Calculadora(this.valor + numero2.valor);
    }

    public Calculadora resta(Calculadora numero2) {
        return new Calculadora(this.valor - numero2.valor);
    }

    public Calculadora multiplicacion(Calculadora numero2) {
        return new Calculadora(this.valor * numero2.valor);
    }

    public Calculadora division(Calculadora numero2) throws EntradaInvalidaException {
        if (this.valor == 0 || numero2.valor == 0) {
            throw new EntradaInvalidaException("Error: No se puede dividir entre cero.");
        }
        return new Calculadora(this.valor / numero2.valor);
    }

    public double getValor() {
        return valor;
    }
}
