; Notas Musicales

(deffacts notes "Notas musicales con su grado de frecuencia"
    (note do natural -9)
    (note do sostenido -8)
    (note re bemol -8)
    (note re natural -7)
    (note re sostenido -6)
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

; Intervalos

(deffacts intervals "Intervalos"
    (interval 0 unisona perfecta)
    (interval 1 segunda menor)
    (interval 2 segunda mayor)
    (interval 3 tercera menor)
    (interval 4 tercera mayor)
    (interval 5 cuarta perfecta)
    (interval 6 cuarta aumentada)
    (interval 7 quinta perfecta)
    (interval 8 sexta menor)
    (interval 9 sexta mayor)
    (interval 10 septima menor)
    (interval 11 septima mayor)
    (interval 12 octava perfecta)
)

; Direcciones

(deffacts directions "Direcciones"
    (direction 1 superior)
    (direction 0 inferior)
)

; Conversiones

(deffacts convertions "Conversiones"
    (convert TRUE 1)
    (convert FALSE 0)
)

; Escalas musicales

(deffacts music_scales "Escala musicales"
    (scale major 2 4 5 7 9 11)
)

; Obtener índice de nota absoluto

(deffunction note_index "Obtener índice de nota absoluto"
    (?base ?extra)
    (- (mod (+ (+ ?base 9) ?extra) 12) 9)
)

; Plantilla para las progresiones circulares

(deftemplate processed_scale "Plantilla para las progresiones circulares"
    (slot key (type SYMBOL))
    (multislot first (type SYMBOL))
    (multislot second (type SYMBOL))
    (multislot third (type SYMBOL))
    (multislot fourth (type SYMBOL))
    (multislot fifth (type SYMBOL))
    (multislot sixth (type SYMBOL))
    (multislot seventh (type SYMBOL))
)

; Cualidad de los acordes

(deffacts chord_qualities "Cualidad de los acordes"
    (quality major "")
    (quality minor "ₘ")
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
    "(sin los paréntesis cuadrados): ")
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

; Modo 2 (Intervalo de una nota)

(defrule mode_2_ask_note_1 "Solicitud de primer nota"
    (mode 2)
    =>
    (printout t crlf
    "Las notas musicales pueden ser representadas de la siguiente forma: " crlf
    "   -> <nota> <alteracion> <octava> (Ej: la natural 4)" crlf crlf
    "   Notas: do, re, mi, fa, sol, la, si." crlf
    "   Alteraciones: natural, sostenido, bemol." crlf
    "   Octava: número entero entre 0 y 8." crlf crlf
    "Por favor, ingrese la primer nota (sin los paréntesis cuadrados): ")
    (bind ?input (readline))
    (assert-string (str-cat "(what_interval_1 " ?input ")"))
)

; Intervalo a calcular (Modo 2)

(defrule mode_2_ask_note_2 "Solicitud de segunda nota"
    (mode 2)
    (what_interval_1 $?)
    =>
    (printout t crlf
    "Ahora, ingrese la nota a la cual desea obtener el intervalo" crlf 
    "en relación con la primer nota: ")
    (bind ?input (readline))
    (assert-string (str-cat "(what_interval_2 " ?input ")"))
    (printout t crlf 
    "------------------------------------------------------------------------------------------" crlf)
)

; Análisis de intervalo (Caso unísono) (Modo 2)

(defrule mode_2_compute_interval_unisone "Análisis de intervalo (Caso unísono)"
    (declare (salience 3))
    ?mode <- (mode 2)
    ?input1 <- (what_interval_1 ?note1 ?alter1 ?octave1)
    ?input2 <- (what_interval_2 ?note2 ?alter2 ?octave2)
    (note ?note1 ?alter1 ?order1)
    (note ?note2 ?alter2 ?order2) 
    (alter ?alter1 ?alter_symbol1)
    (alter ?alter2 ?alter_symbol2)
    (test (and (eq ?octave1 ?octave2) 
        (and (eq ?note1 ?note2) (eq ?alter1 ?alter2))))
    (interval 0 ?interv_1 ?interv_2)
    =>
    (printout t crlf
    "A partir de " ?note1 ?alter_symbol1 ?octave1 
    ", la nota " ?note2 ?alter_symbol2 ?octave2
    " corresponde a una " ?interv_1 " " ?interv_2 "." crlf crlf
    "------------------------------------------------------------------------------------------" crlf)
    (retract ?mode ?input1 ?input2)
)

; Análisis de intervalo (Caso octavas) (Modo 2)

(defrule mode_2_compute_interval_octave "Análisis de intervalo (Caso octavas)"
    (declare (salience 2))
    ?mode <- (mode 2)
    ?input1 <- (what_interval_1 ?note1 ?alter1 ?octave1)
    ?input2 <- (what_interval_2 ?note2 ?alter2 ?octave2)
    (note ?note1 ?alter1 ?order1)
    (note ?note2 ?alter2 ?order2) 
    (alter ?alter1 ?alter_symbol1)
    (alter ?alter2 ?alter_symbol2)
    (test (and (eq ?note1 ?note2) (eq ?alter1 ?alter2)))
    (test (= (abs (- ?octave2 ?octave1)) 1))
    (convert ?symbol&:(eq ?symbol (> ?octave2 ?octave1)) ?direc)
    (interval 12 ?interv_1 ?interv_2)
    (direction ?direc ?direc_text)
    =>
    (printout t crlf
    "A partir de " ?note1 ?alter_symbol1 ?octave1 
    ", la nota " ?note2 ?alter_symbol2 ?octave2
    " corresponde a una " ?interv_1 " " ?interv_2 " " ?direc_text "." crlf crlf
    "------------------------------------------------------------------------------------------" crlf)
    (retract ?mode ?input1 ?input2)
)

; Análisis de intervalo (Caso compuestos) (Modo 2)

(defrule mode_2_compute_interval_compose "Análisis de intervalo (Caso compuestos)"
    (declare (salience 1))
    ?mode <- (mode 2)
    ?input1 <- (what_interval_1 ?note1 ?alter1 ?octave1)
    ?input2 <- (what_interval_2 ?note2 ?alter2 ?octave2)
    (note ?note1 ?alter1 ?order1)
    (note ?note2 ?alter2 ?order2) 
    (alter ?alter1 ?alter_symbol1)
    (alter ?alter2 ?alter_symbol2)
    (test (or (>= (abs (- ?octave2 ?octave1)) 2)
        (or (and (= (- ?octave2 ?octave1) 1) 
                (> ?order2 ?order1))
            (and (= (- ?octave2 ?octave1) -1) 
                (< ?order2 ?order1)))))
    (convert ?symbol&:(eq ?symbol (> ?octave2 ?octave1)) ?direc)
    (direction ?direc ?direc_text)
    =>
    (printout t crlf
    "A partir de " ?note1 ?alter_symbol1 ?octave1 
    ", la nota " ?note2 ?alter_symbol2 ?octave2
    " corresponde a un intervalo compuesto " ?direc_text "." crlf crlf
    "------------------------------------------------------------------------------------------" crlf)
    (retract ?mode ?input1 ?input2)
)

; Análisis de intervalo (inmediatamente superior o inferior) (Modo 2)

(defrule mode_2_compute_interval "Análisis de intervalo (inmediatamente superior o inferior)"
    (declare (salience 0))
    ?mode <- (mode 2)
    ?input1 <- (what_interval_1 ?note1 ?alter1 ?octave1)
    ?input2 <- (what_interval_2 ?note2 ?alter2 ?octave2)
    (note ?note1 ?alter1 ?order1)
    (note ?note2 ?alter2 ?order2) 
    (alter ?alter1 ?alter_symbol1)
    (alter ?alter2 ?alter_symbol2)
    (convert ?symbol1&:(eq ?symbol1 
        (or (and (< ?order2 ?order1) (> ?octave2 ?octave1))
            (and (> ?order2 ?order1) (< ?octave2 ?octave1)))) ?conver)
    (convert ?symbol2&:(eq ?symbol2 
        (or (and (< ?order2 ?order1) (= ?octave2 ?octave1))
            (< ?octave2 ?octave1))) ?direc_1)
    (convert ?symbol3&:(eq ?symbol3
        (and (> ?order2 ?order1) (< ?octave2 ?octave1))) ?direc_2)
    (interval ?x&:(= ?x 
        (* (+ 1 (* -2 ?direc_1)) 
            (+ (- ?order2 ?order1) 
                (* (+ 1 (* -2 ?direc_1)) 
                    (* 12 ?conver))))) ?interv_1 ?interv_2)
    (direction ~?direc_1 ?direc_text)
    =>
    (printout t crlf
    "A partir de " ?note1 ?alter_symbol1 ?octave1 
    ", la nota " ?note2 ?alter_symbol2 ?octave2
    " corresponde a una " ?interv_1 " " ?interv_2 " " ?direc_text "." crlf crlf
    "------------------------------------------------------------------------------------------" crlf)
    (retract ?mode ?input1 ?input2)
)

; Modo 3 (Nota de un intervalo)

(defrule mode_3_ask_note "Solicitud de nota"
    (mode 3)
    =>
    (printout t crlf
    "Las notas musicales pueden ser representadas de la siguiente forma: " crlf
    "   -> <nota> <alteracion> <octava> (Ej: la natural 4)" crlf crlf
    "   Notas: do, re, mi, fa, sol, la, si." crlf
    "   Alteraciones: natural, sostenido, bemol." crlf
    "   Octava: número entero entre 0 y 8." crlf crlf
    "Por favor, ingrese la primer nota (sin los paréntesis cuadrados): ")
    (bind ?input (readline))
    (assert-string (str-cat "(what_note_1 " ?input ")"))
)

; Nota a calcular (Modo 3)

(defrule mode_3_ask_interval "Solicitud de intervalo"
    (mode 3)
    (what_note_1 $?)
    =>
    (printout t crlf
    "Los intervalos se pueden escribir de la siguiente manera:" crlf
    "   -> <intervalo> <clase> (Ej: tercera mayor superior)" crlf crlf
    "   Intervalos: unisona, segunda, tercera, cuarta, quinta, sexta, septima, octava." crlf
    "   Clases: menor, mayor, aumentada, perfecta." crlf
    "   Dirección: inferior, superior." crlf crlf
    "Ahora, ingrese el intervalo al que desea obtener su nota: ")
    (bind ?input (readline))
    (assert-string (str-cat "(what_note_2 " ?input ")"))
    (printout t crlf 
    "------------------------------------------------------------------------------------------" crlf)
)

; Calcular nota (Modo 3)

(defrule mode_3_compute_note "Calcular nota"
    ?mode <- (mode 3)
    ?note_input <- (what_note_1 ?note1 ?alter1 ?octave1)
    ?interv_input <- (what_note_2 ?interv ?quality ?direc)
    (note ?note1 ?alter1 ?index1)
    (alter ?alter1 ?alter1_text)
    (interval ?offset ?interv ?quality)
    (direction ?value ?direc)
    (convert ?symbol1&:(eq ?symbol1 
        (and (= ?value 1) (> (+ ?index1 ?offset) 2))) ?gt2)
    (convert ?symbol2&:(eq ?symbol2 
        (and (= ?value 0) (< (- ?index1 ?offset) -9))) ?lt_9)        
    (note ?note2 ?alter2 ?index2&:(= ?index2 
        (+ ?index1 
            (+ (* (- (* 2 ?value) 1) ?offset) 
                (* 12 (+ (* -1 ?gt2) ?lt_9))))))
    (alter ?alter2 ?alter2_text)
    =>
    (printout t crlf
    "A partir de " ?note1 ?alter1_text ?octave1 
    ", la " ?interv " " ?quality " " ?direc
    " corresponde a " ?note2 ?alter2_text (+ ?octave1 (+ (* -1 ?lt_9) ?gt2))  "." crlf crlf
    "------------------------------------------------------------------------------------------" crlf)
    (retract ?mode ?note_input ?interv_input)
)

; Modo 4 (Escalas Mayores)

(defrule mode_4_ask_scale "Solicitud de escalas mayor"
    (mode 4)
    =>
    (printout t crlf
    "Las notas musicales para una escala pueden ser representadas de la siguiente forma: " crlf
    "   -> <nota> <alteracion> (Ej: do natural)" crlf crlf
    "   Notas: do, re, mi, fa, sol, la, si." crlf
    "   Alteraciones: natural, sostenido, bemol." crlf crlf
    "Por favor, ingrese la nota raíz de la escala que desea saber" crlf 
    "(sin los paréntesis cuadrados): ")
    (bind ?input (readline))
    (assert-string (str-cat "(what_major_scale " ?input ")"))
    (printout t crlf 
    "------------------------------------------------------------------------------------------" crlf)
)

; Obtener escala mayor (Modo 4)

(defrule mode_4_compute_scale "Obtener escala mayor"
    (mode 4|5)
    (what_major_scale ?note1 ?alter1)
    (note ?note1 ?alter1 ?order1)
    (scale major ?tones2 ?tones3 ?tones4 ?tones5 ?tones6 ?tones7)
    (note ?note2 ?alter2 ?index2&:(eq ?index2 (note_index ?order1 ?tones2)))
    (note ?note3 ?alter3 ?index3&:(eq ?index3 (note_index ?order1 ?tones3)))
    (note ?note4 ?alter4 ?index4&:(eq ?index4 (note_index ?order1 ?tones4)))
    (note ?note5 ?alter5 ?index5&:(eq ?index5 (note_index ?order1 ?tones5)))
    (note ?note6 ?alter6 ?index6&:(eq ?index6 (note_index ?order1 ?tones6)))
    (note ?note7 ?alter7 ?index7&:(eq ?index7 (note_index ?order1 ?tones7)))
    =>
    (assert 
        (processed_scale (key major)
            (first ?note1 ?alter1 major) 
            (second ?note2 ?alter2 minor) 
            (third ?note3 ?alter3 minor) 
            (fourth ?note4 ?alter4 major) 
            (fifth ?note5 ?alter5 major) 
            (sixth ?note6 ?alter6 minor) 
            (seventh ?note7 ?alter7 diminished))
    )
)

; Print de los resultados (Modo 4)

(defrule mode_4_print "Print de los resultados"
    ?mode <- (mode 4)
    ?req <- (what_major_scale ?note1 ?alter1)
    ?p_scale <- (processed_scale (key major)
        (first ?note1 ?alter1 ?)
        (second ?note2 ?alter2 ?)
        (third ?note3 ?alter3 ?)
        (fourth ?note4 ?alter4 ?)
        (fifth ?note5 ?alter5 ?)
        (sixth ?note6 ?alter6 ?)
        (seventh ?note7 ?alter7 ?))
    (alter ?alter1 ?alter_symbol1)
    (alter ?alter2 ?alter_symbol2)
    (alter ?alter3 ?alter_symbol3)
    (alter ?alter4 ?alter_symbol4)
    (alter ?alter5 ?alter_symbol5)
    (alter ?alter6 ?alter_symbol6)
    (alter ?alter7 ?alter_symbol7)
    =>
    (printout t crlf "La escala mayor de la nota " ?note1 ?alter_symbol1
    " es la siguiente: " 
    ?note1 ?alter_symbol1 " "
    ?note2 ?alter_symbol2 " "
    ?note3 ?alter_symbol3 " "
    ?note4 ?alter_symbol4 " "
    ?note5 ?alter_symbol5 " "
    ?note6 ?alter_symbol6 " "
    ?note7 ?alter_symbol7 "." crlf crlf
    "------------------------------------------------------------------------------------------" crlf)
    (retract ?mode ?req ?p_scale)
)

; Modo 5 (Progresiones circulares)

(defrule mode_5_ask_scale "Solicitud de tónica"
    (mode 5)
    =>
    (printout t crlf
    "Las notas musicales para una escala (con la cual se determina una progresión de acordes)" crlf 
    "pueden ser representadas de la siguiente forma: " crlf
    "   -> <nota> <alteracion> (Ej: do natural)" crlf crlf
    "   Notas: do, re, mi, fa, sol, la, si." crlf
    "   Alteraciones: natural, sostenido, bemol." crlf crlf
    "Por favor, ingrese la tónica de la que desea saber su progresión circular" crlf 
    "(sin los paréntesis cuadrados): ")
    (bind ?input (readline))
    (assert-string (str-cat "(what_major_scale " ?input ")"))
    (printout t crlf 
    "------------------------------------------------------------------------------------------" crlf)
)

; Obtener progresión circular (Modo 5)

(defrule mode_5_progression "Obtener progresión circular"
    ?mode <- (mode 5)
    ?req <- (what_major_scale ?chord1 ?alter1)
    ?p_scale <- (processed_scale (key major)
        (first ?chord1 ?alter1 ?quality1)
        (second ?chord2 ?alter2 ?quality2)
        (third $?)
        (fourth $?)
        (fifth ?chord5 ?alter5 ?quality5)
        (sixth ?chord6 ?alter6 ?quality6)
        (seventh $?))
    (alter ?alter1 ?alter_symbol1)
    (quality ?quality1 ?quality_text1)
    (alter ?alter2 ?alter_symbol2)
    (quality ?quality2 ?quality_text2)
    (alter ?alter5 ?alter_symbol5)
    (quality ?quality5 ?quality_text5)
    (alter ?alter6 ?alter_symbol6)
    (quality ?quality6 ?quality_text6)
    =>
    (printout t crlf "La progresión circular (círculo armónico) de la nota " ?chord1 ?alter_symbol1
    " es: " 
    ?chord6 ?alter_symbol6 ?quality_text6 " -> "
    ?chord2 ?alter_symbol2 ?quality_text2 " -> "
    ?chord5 ?alter_symbol5 ?quality_text5 " -> "
    ?chord1 ?alter_symbol1 ?quality_text1 "." crlf crlf
    "------------------------------------------------------------------------------------------" crlf)
    (retract ?mode ?req ?p_scale)
)