; Notas Musicales

(deffacts notes "Notas musicales con su grado de frecuencia"
    (note do natural -9)
    (note do sostenido -8)
    (note re bemol -8)
    (note re natural -7)
    (note note re sostenido -6)
    (note mi bemol -6)
    (note mi natural -5)
    (note fa natural -4)
    (note fa sostenido -3)
    (note sol bemol -3)
    (note sol natural -2)
    (note sol sostenido -1)
    (note la bemol -1)
    (note la natural 0)
    (note la sostenido 1)
    (note si bemol 1)
    (note si natural 2)
)

; Alteraciones

(deffacts alterations "Alteraciones comunes de las notas"
    (alter natural "")
    (alter sostenido "♯")
    (alter bemol "♭")
)

; Menú principal

(defrule MAIN::main_menu "Menú principal" 
    (initial-fact)
    => 
    (printout t crlf 
    "¡Bienvenido al Sistema Experto en Música (SEM)!" crlf 
    "¿Que quisiera consultar?" crlf crlf 
    "   (1) Frecuencia de una nota." crlf 
    "   (2) Distancia entre dos notas." crlf 
    "   (3) Nota del intervalo de una nota." crlf 
    "   (4) Escala mayor de una nota." crlf 
    "   (5) Progresión circular (círculo armónico) para una escala mayor." crlf crlf 
    "Por favor, ingrese el número correspondiente a su necesidad" crlf 
    "(número entre paréntesis): ") 
    (assert (mode (read))) 
    (printout t crlf 
    "------------------------------------------------------------------------------------------" crlf)
)

; Modo inválido (Menú principal)

(defrule MAIN::wrong_mode "No seleccionó un modo correcto" 
    ?option <- (mode ~1&~2&~3&~4&~5)
    => 
    (retract ?option)
    (printout t crlf 
    "La opción escogida no es una opción válida. Inténtelo de nuevo:" crlf
    "   (1) Frecuencia de una nota." crlf 
    "   (2) Distancia entre dos notas." crlf 
    "   (3) Nota del intervalo de una nota." crlf 
    "   (4) Escala mayor de una nota." crlf 
    "   (5) Progresión circular (círculo armónico) para una escala mayor." crlf crlf 
    "Por favor, ingrese el número correspondiente a su necesidad" crlf 
    "(número entre paréntesis): ")
    (assert (mode (read))) 
    (printout t crlf 
    "------------------------------------------------------------------------------------------" crlf)
)

; Modo 1 (Frecuencia)

(defrule mode_1_ask_note "Solicitud de nota"
    (mode 1)
    =>
    (printout t crlf
    "Las notas musicales pueden ser representadas de la siguiente forma: " crlf
    "   -> <nota> <alteracion> <octava> (Ej: la natural 4)" crlf crlf
    "   Notas: do, re, mi, fa, sol, la, si." crlf
    "   Alteraciones: natural, sostenido, bemol." crlf
    "   Octava: número entero entre 0 y 8." crlf crlf
    "Por favor, ingrese la nota a la cual desea obtener su frecuencia " crlf 
    "(sin los paréntesis cuadrados):")
    (bind ?input (readline))
    (assert-string (str-cat "(what_frequency " ?input ")"))
    (printout t crlf 
    "------------------------------------------------------------------------------------------" crlf)
)

; Cálculo de frecuencia (Modo 1)

(defrule mode_1_compute_frequency "Cálculo de frecuencia"
    (declare (salience 4))
    ?operation <- (what_frequency ?note ?alter ?octave)
    (alter ?alter ?alter_symbol)
    (note ?note ?alter ?index_k)
    ?mode <- (mode 1)
    (test (>= 8 ?octave 0))
    =>
    (printout t crlf
    "La frecuencia para la nota " ?note ?alter_symbol ?octave " es: "
    (* 440 (** (** 2 (/ 1 12)) (+ (* 12 (- ?octave 4)) ?index_k))) crlf crlf
    "------------------------------------------------------------------------------------------" crlf)
    (retract ?mode ?operation)
)

; Error: Sintaxis incorrecta (Modo 1)

(defrule mode_1_syntax_error "Valores ingresados erróneos"
    (declare (salience 0))
    ?operation <- (what_frequency $?)
    ?mode <- (mode 1)
    =>
    (printout t crlf "¡Error: La sintaxis es incorrecta!")
    (retract ?mode ?operation)
    (assert (mode 1))
)