import UIKit

final class Quiz: PantallaEducapp {
    private let temas = Tema.catalogo
    private var indice = 0
    private var aciertos = 0
    private var respondida = false

    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarInicio()
    }

    private func mostrarInicio() {
        limpiarContenido()
        encabezado("Quiz final")
        icono("scope")
        contenido.addArrangedSubview(etiqueta("Contenidos del quiz", estilo: .title2))
        contenido.addArrangedSubview(etiqueta("Responde una pregunta por cada lección. Después de cada respuesta podrás leer una explicación."))
        boton("Poner a prueba mis conocimientos") { [weak self] in self?.iniciar() }
    }

    private func iniciar() {
        indice = 0
        aciertos = 0
        mostrarPregunta()
    }

    private func mostrarPregunta() {
        respondida = false
        limpiarContenido()
        let tema = temas[indice]
        mostrarProgreso(tema)
        encabezado(tema.pregunta, color: PantallaEducapp.pizarra)
        for opcion in (tema.distractores + [tema.correcta]).shuffled() {
            boton(opcion) { [weak self] in self?.responder(opcion) }
        }
    }

    private func mostrarProgreso(_ tema: Tema) {
        encabezado("Quiz final\n\(tema.nombre)")
        contenido.addArrangedSubview(etiqueta("Pregunta \(indice + 1) de \(temas.count)", centrada: true))
        let progreso = UIProgressView(progressViewStyle: .default)
        progreso.progress = Float(indice + (respondida ? 1 : 0)) / Float(temas.count)
        progreso.progressTintColor = PantallaEducapp.pizarra
        progreso.isAccessibilityElement = false
        contenido.addArrangedSubview(progreso)
    }

    private func responder(_ opcion: String) {
        guard !respondida else { return }
        respondida = true
        let tema = temas[indice]
        let correcta = opcion == tema.correcta
        if correcta { aciertos += 1 }

        limpiarContenido()
        mostrarProgreso(tema)
        encabezado(correcta ? "Respuesta correcta" : "Respuesta incorrecta",
                   color: correcta ? UIColor(red: 0.16, green: 0.42, blue: 0.27, alpha: 1)
                                   : UIColor(red: 0.64, green: 0.23, blue: 0.21, alpha: 1))
        contenido.addArrangedSubview(etiqueta(tema.explicacion))
        let ultima = indice == temas.count - 1
        boton(ultima ? "Ver resultado" : "Siguiente pregunta") { [weak self] in
            guard let self = self else { return }
            if ultima {
                self.mostrarResultado()
            } else {
                self.indice += 1
                self.mostrarPregunta()
            }
        }
        UIAccessibility.post(notification: .screenChanged, argument: contenido.arrangedSubviews.first)
    }

    private func mostrarResultado() {
        limpiarContenido()
        encabezado("Resultado del quiz")
        icono("flag.checkered")
        contenido.addArrangedSubview(etiqueta("\(aciertos) de \(temas.count) respuestas correctas", estilo: .title2, centrada: true))
        boton("Volver a intentar") { [weak self] in self?.iniciar() }
        boton("Volver al inicio del quiz", secundario: true) { [weak self] in self?.mostrarInicio() }
    }
}
