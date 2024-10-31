import com.app.calculadora.cientifica.clases.CalculadoraCientifica
import com.app.calculadora.cientifica.excepciones.EntradaInvalidaException
import kotlin.math.sin

fun main() {
    println("Ingrese una expresión matemática (ejemplo: 2 + 3 * sin(45) - log(10)): ")
    val entrada = readLine() ?: return

    try {
        val resultado = evaluarExpresion(entrada)
        println("Resultado: $resultado")
    } catch (e: EntradaInvalidaException) {
        println("Error: ${e.message}")
    } catch (e: Exception) {
        println("Error en la evaluación: ${e.message}")
    }
}

fun evaluarExpresion(expresion: String): Double {
    // Aquí debes implementar la lógica para analizar y evaluar la expresión.
    // Esto puede ser complicado y es recomendable usar una biblioteca de análisis de expresiones.
    // Para simplicidad, vamos a hacer un ejemplo muy básico.

    // Este es solo un ejemplo simple para manejar operaciones aritméticas básicas.
    val partes = expresion.split(" ")
    val calculadora = CalculadoraCientifica(0.0)

    for (i in partes.indices) {
        when (partes[i]) {
            "+" -> calculadora.suma(CalculadoraCientifica(partes[i + 1].toDouble()))
            "-" -> calculadora.resta(CalculadoraCientifica(partes[i + 1].toDouble()))
            "*" -> calculadora.multiplicacion(CalculadoraCientifica(partes[i + 1].toDouble()))
            "/" -> calculadora.division(CalculadoraCientifica(partes[i + 1].toDouble()))
            "sin" -> calculadora.calcularSeno() // Debes adaptar este método para pasar el argumento
            "log" -> calculadora.logaritmoNatural() // Lo mismo aquí
            // Añadir otros operadores según sea necesario
        }
    }

    return calculadora.obtenerValor()
}