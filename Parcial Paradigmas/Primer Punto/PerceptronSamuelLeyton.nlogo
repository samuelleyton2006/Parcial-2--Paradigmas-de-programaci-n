globals [
  epoch-error   ;; average error in this epoch
  perceptron    ;; a single output-node
  input-node-1  ;; keep the input nodes in globals so we can refer
  input-node-2  ;; to them directly and distinctly
]

;; A perceptron is modeled by input-node and bias-node agents
;; connected to an output-node agent.

;; Connections from input nodes to output nodes
;; in a perceptron.
links-own [ weight ]

;; all nodes have an activation
;; input nodes have a value of 1 or -1
;; bias-nodes are always 1
turtles-own [activation]

breed [ input-nodes input-node ]

;; bias nodes are input-nodes whose activation
;; is always 1.
breed [ bias-nodes bias-node ]

;; output nodes compute the weighted sum of their
;; inputs and then set their activation to 1 if
;; the sum is greater than their threshold.  An
;; output node can also be the input-node for another
;; perceptron.
breed [ output-nodes output-node ]
output-nodes-own [threshold]

;;
;; Setup Procedures
;;

to setup
  clear-all

  ;; set our background to something more viewable than black
  ask patches [ set pcolor white - 3 ]

  set-default-shape input-nodes "circle"
  set-default-shape bias-nodes "bias-node"
  set-default-shape output-nodes "output-node"

  create-output-nodes 1 [
    set activation random-activation
    set xcor 6
    set size 2
    set threshold 0
    set perceptron self
  ]

  create-bias-nodes 1 [
    set activation 1
    setxy 3 7
    set size 1.5
    my-create-link-to perceptron
  ]

  create-input-nodes 1 [
    setup-input-node
    set label "Node 1"
    setxy -6 5
    set input-node-1 self
  ]

  create-input-nodes 1 [
    setup-input-node
    set label "Node 2"
    setxy -6 0
    set input-node-2 self
  ]

  ask perceptron [ compute-activation ]
  reset-ticks
end

to setup-input-node
    set activation random-activation
    set size 1.5
    my-create-link-to perceptron
    set label-color magenta
end

;; links an input or bias node to an output node
to my-create-link-to [ anode ] ;; input or bias node procedure
  create-link-to anode [
    set color red + 1
    ;; links start with a random weight
    set weight random-float 0.1 - 0.05
  ]
end

;;
;; Runtime Procedures
;;

;; train sets the input nodes to a random input
;; it then computes the output
;; it determines the correct answer and back propagates the weight changes
to train ;; observer procedure
  set epoch-error 0
  repeat examples-per-epoch
  [
    ;; set the input nodes randomly
    ask input-nodes
      [ set activation random-activation ]

    ;; distribute error
    ask perceptron [
      compute-activation
      update-weights target-answer
      recolor
    ]
  ]

  ;; plot stats
  set epoch-error epoch-error / examples-per-epoch
  set epoch-error epoch-error * 0.5
  tick
end

;; compute activation by summing the inputs * weights
;; and run through sign function which determines whether
;; the computed value is above or below the threshold
to compute-activation ;; output-node procedure
  set activation sign sum [ [activation] of end1 * weight ] of my-in-links
  recolor
end

to update-weights [ answer ] ;; output-node procedure
  let output-answer activation

  ;; calculate error for output nodes
  let output-error answer - output-answer

  ;; update the epoch-error
  set epoch-error epoch-error + (answer - sign output-answer) ^ 2

  ;; examine input output edges and set their new weight
  ;; increasing or decreasing it by a value determined by the learning-rate
  ask my-in-links [
    set weight weight + learning-rate * output-error * [activation] of end1
  ]
end

;; computes the sign function given an input value
to-report sign [input]  ;; output-node procedure
  ifelse input > threshold
  [ report 1 ]
  [ report -1 ]
end

to-report random-activation ;; observer procedure
  ifelse random 2 = 0
  [ report 1 ]
  [ report -1 ]
end

to-report target-answer ;; observer procedure
  let a [activation] of input-node-1 = 1
  let b [activation] of input-node-2 = 1
  report ifelse-value (run-result (word "my-" target-function " a b")) [1][-1]
end

to-report my-or [a b];; output-node procedure
  report (a or b)
end

to-report my-xor [a b] ;; output-node procedure
  report (a xor b)
end

to-report my-and [a b] ;; output-node procedure
  report (a and b)
end

to-report my-nor [a b] ;; output-node procedure
  report not (a or b)
end

to-report my-nand [a b] ;; output-node procedure
  report not (a and b)
end

;; test runs one instance and computes the output
to test ;; observer procedure
  ask input-node-1 [ set activation test-input-node-1-value ]
  ask input-node-2 [ set activation test-input-node-2-value ]

  ;; compute the correct answer
  let correct-answer target-answer

  ;; color the nodes
  ask perceptron [ compute-activation ]

  ;; compute the answer

  let output-answer [activation] of perceptron

  ;; output the result
  ifelse output-answer = correct-answer
  [
    user-message (word "Output: " output-answer "\\nTarget: " correct-answer "\\nCorrect Answer!")
  ]
  [
    user-message (word "Output: " output-answer "\\nTarget: " correct-answer "\\nIncorrect Answer!")
  ]
end


;; Sets the color of the perceptron's nodes appropriately
;; based on activation
to recolor ;; output, input, or bias node procedure
  ifelse activation = 1
    [ set color white ]
    [ set color black ]
  ask in-link-neighbors [ recolor ]

  ifelse show-weights?
  [ resize-recolor-links ]
  [
    ask my-in-links [
      set thickness 0
      set label ""
      set color red + 1
    ]
  ]
end

;; resize and recolor the edges
;; resize to indicate weight
;; recolor to indicate positive or negative
to resize-recolor-links
  ask links [
    set label precision weight 4
    set thickness 0.1 + 4 * abs weight
    ifelse weight > 0
    [ set color red + 1 ]
    [ set color blue ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
706
13
1260
510
-1
-1
28.74
1
10
1
1
1
0
0
0
1
-9
9
-8
8
1
1
1
ticks
30.0

BUTTON
142
10
208
43
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
239
48
338
81
train
train
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
474
15
537
48
test
test
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
21
122
213
167
test-input-node-1-value
test-input-node-1-value
-1 1
1

CHOOSER
21
176
213
221
test-input-node-2-value
test-input-node-2-value
-1 1
1

MONITOR
344
317
431
362
output
[activation] of perceptron
3
1
11

SLIDER
287
126
487
159
learning-rate
learning-rate
0.0
.1
0.005
.0001
1
NIL
HORIZONTAL

PLOT
490
189
690
339
Error vs. Epochs
Epochs
Error
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks epoch-error"

SLIDER
495
127
694
160
examples-per-epoch
examples-per-epoch
1.0
1000.0
110.0
1.0
1
NIL
HORIZONTAL

PLOT
485
350
685
500
Rule Learned
x1
x2
-2.0
2.0
-2.0
2.0
false
false
"clear-plot" "clear-plot"
PENS
"rule" 1.0 0 -16777216 true "" "let edge1-weight [weight] of [out-link-to perceptron] of input-node-1\\n  let edge2-weight [weight] of [out-link-to perceptron] of input-node-2\\n  let bias-edge-weight sum [[weight] of out-link-to perceptron] of bias-nodes\\n\\n  ;; cycle through all the x-values and plot the corresponding x-values\\n  foreach n-values 5 [? - 2]\\n  [\\n    ;; put it all together\\n    let x2 ( (- bias-edge-weight - edge1-weight * ?) / edge2-weight )\\n\\n    ;; plot x1, x2\\n    plotxy ? x2\\n  ]"
"negatives" 1.0 2 -2674135 true "" "if target-function = \"or\" [\\nplotxy -1 -1\\n]\\nif target-function = \"xor\" [\\nplotxy 1 1 \\nplotxy -1 -1 ]\\nif target-function = \"and\" [\\nplotxy 1 -1\\nplotxy -1 1\\nplotxy -1 -1\\n]\\nif target-function = \"nor\" [\\nplotxy 1 1\\nplotxy 1 -1\\nplotxy -1 1\\n]\\nif target-function = \"nand\" [\\nplotxy 1 1\\n]"
"positives" 1.0 2 -10899396 true "" "if target-function = \"or\" [\\nplotxy -1 1\\nplotxy 1 1\\nplotxy 1 -1 ]\\nif target-function = \"xor\" [\\nplotxy -1 1 \\nplotxy 1 -1 ]\\nif target-function = \"and\" [\\nplotxy 1 1\\n]\\nif target-function = \"nor\" [\\nplotxy -1 -1\\n]\\nif target-function = \"nand\" [\\nplotxy -1 -1\\nplotxy 1 -1\\nplotxy -1 1\\n]"

CHOOSER
1
282
173
327
target-function
target-function
"or" "xor" "and" "nor" "nand"
2

SWITCH
0
337
237
370
show-weights?
show-weights?
0
1
-1000

TEXTBOX
10
50
130
68
2. Train perceptron:
11
0.0
0

TEXTBOX
352
16
466
34
3. Test perceptron:
11
0.0
0

TEXTBOX
10
20
134
38
1. Setup perceptron:
11
0.0
0

BUTTON
129
47
226
80
train once
train
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## Funcionamiento de variables por medio de la entrada de x1 y x2 

Valores de Entrada x1x1 y x2x2 (1 o -1)
Los valores de entrada x1x1 y x2x2 son cruciales para el entrenamiento del perceptrón. Dependiendo de estos valores, el perceptrón ajustará sus pesos para intentar clasificar correctamente las entradas. La función lógica que decidas implementar (como OR, AND o XOR) también influye en este proceso:
•	Si x1x1 y x2x2 son siempre los mismos o cambian poco, el perceptrón tendrá menos oportunidades de aprender de diferentes ejemplos. Esto puede limitar su capacidad para generalizar.
•	Para funciones lógicas como OR o AND, el perceptrón puede ajustarse fácilmente con ejemplos variados. Pero cuando se trata de XOR, necesita ver casos donde ambas entradas sean iguales y también distintos para aprender a clasificar correctamente.
2.	Tasa de Aprendizaje
La tasa de aprendizaje es lo que determina cuánto se ajustan los pesos de los enlaces después de cada ejemplo:
•	Tasa alta: Los pesos se ajustan rápidamente con cada error, lo que permite al perceptrón aprender rápido al principio. Sin embargo, si la tasa es demasiado alta, puede hacer que los pesos oscilen mucho y no lleguen a converger a valores óptimos, lo que genera inestabilidad.
•	Tasa baja: Los ajustes a los pesos serán más pequeños, lo que hace que el aprendizaje sea más lento y gradual. Esto puede ser útil para llegar a soluciones estables, pero si es demasiado baja, el modelo podría necesitar muchas más épocas para alcanzar un rendimiento adecuado o incluso quedarse atrapado en valores subóptimos.
3.	Aprendizaje por Épocas
El aprendizaje por épocas se refiere a cuántas veces el perceptrón pasa por el conjunto de ejemplos de entrenamiento. Cada época permite al modelo ajustar sus pesos según los datos:
•	Pocas épocas: Si no se entrena lo suficiente, el perceptrón puede no ajustar los pesos correctamente, dejando un error alto. Esto es especialmente problemático si el problema necesita ver varios ejemplos para aprender patrones.
•	Muchas épocas: Entrenar durante muchas épocas permite al perceptrón ajustar mejor los pesos y reducir el error. Sin embargo, esto también puede llevar a un sobreajuste si el modelo se expone demasiado a un conjunto específico de datos y pierde la capacidad de generalizar bien a nuevos datos.
Resumen
En resumen:
•	Los valores x1x1 y x2x2 afectan la diversidad de ejemplos y ayudan al perceptrón a identificar patrones en diferentes combinaciones.
•	La tasa de aprendizaje influye en la rapidez y estabilidad del aprendizaje, siendo clave para lograr una convergencia estable de los pesos.
•	El número de épocas permite al perceptrón refinar su aprendizaje y encontrar un equilibrio entre aprender los ejemplos de entrenamiento y generalizar a nuevas entradas.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bias-node
false
0
Circle -16777216 true false 0 0 300
Circle -7500403 true true 30 30 240
Polygon -16777216 true false 120 60 150 60 165 60 165 225 180 225 180 240 135 240 135 225 150 225 150 75 135 75 150 60

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

output-node
false
1
Circle -7500403 true false 0 0 300
Circle -2674135 true true 30 30 240
Polygon -7500403 true false 195 75 90 75 150 150 90 225 195 225 195 210 195 195 180 210 120 210 165 150 120 90 180 90 195 105 195 75

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
