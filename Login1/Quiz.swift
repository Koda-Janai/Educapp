import UIKit

final class Quiz: PantallaEducapp {
    @IBOutlet private weak var panelInicio: UIStackView!
    @IBOutlet private weak var panelProgreso: UIStackView!
    @IBOutlet private weak var panelPregunta: UIStackView!
    @IBOutlet private weak var panelRespuesta: UIStackView!
    @IBOutlet private weak var panelResultado: UIStackView!
    @IBOutlet private weak var categoria: UILabel!
    @IBOutlet private weak var numeroPregunta: UILabel!
    @IBOutlet private weak var progreso: UIProgressView!
    @IBOutlet private weak var pregunta: UILabel!
    @IBOutlet private var botonesRespuesta: [UIButton]!
    @IBOutlet private weak var estadoRespuesta: UILabel!
    @IBOutlet private weak var explicacion: UILabel!
    @IBOutlet private weak var botonAvanzar: UIButton!
    @IBOutlet private weak var puntuacion: UILabel!

    private let temas = Tema.catalogo
    private var indice = 0
    private var aciertos = 0
    private var respondida = false
    private var opciones: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mostrar(panelInicio)
    }

    @IBAction private func volverAlInicio(_ sender: UIButton) {
        mostrar(panelInicio)
    }

    @IBAction private func iniciar(_ sender: UIButton) {
        indice = 0
        aciertos = 0
        mostrarPregunta()
    }

    private func mostrarPregunta() {
        respondida = false
        let tema = temas[indice]
        categoria.text = "Quiz final · \(tema.nombre)"
        numeroPregunta.text = "Pregunta \(indice + 1) de \(temas.count)"
        progreso.progress = Float(indice) / Float(temas.count)
        pregunta.text = tema.pregunta
        opciones = (tema.distractores + [tema.correcta]).shuffled()
        for boton in botonesRespuesta {
            boton.setTitle(opciones[boton.tag], for: .normal)
        }
        mostrar(panelPregunta)
    }

    @IBAction private func responder(_ sender: UIButton) {
        guard !respondida, opciones.indices.contains(sender.tag) else { return }
        respondida = true
        let tema = temas[indice]
        let correcta = opciones[sender.tag] == tema.correcta
        if correcta { aciertos += 1 }

        progreso.progress = Float(indice + 1) / Float(temas.count)
        estadoRespuesta.text = correcta ? "Respuesta correcta" : "Respuesta incorrecta"
        estadoRespuesta.backgroundColor = correcta ? UIColor(red: 0.16, green: 0.42, blue: 0.27, alpha: 1)
                                                   : UIColor(red: 0.64, green: 0.23, blue: 0.21, alpha: 1)
        explicacion.text = tema.explicacion
        botonAvanzar.setTitle(indice == temas.count - 1 ? "Ver resultado" : "Siguiente pregunta", for: .normal)
        mostrar(panelRespuesta)
        UIAccessibility.post(notification: .screenChanged, argument: estadoRespuesta)
    }

    @IBAction private func avanzar(_ sender: UIButton) {
        guard respondida, !panelRespuesta.isHidden else { return }
        if indice == temas.count - 1 {
            puntuacion.text = "\(aciertos) de \(temas.count) respuestas correctas"
            mostrar(panelResultado)
        } else {
            indice += 1
            mostrarPregunta()
        }
    }

    private func mostrar(_ panel: UIStackView) {
        panelInicio.isHidden = panel !== panelInicio
        panelPregunta.isHidden = panel !== panelPregunta
        panelRespuesta.isHidden = panel !== panelRespuesta
        panelResultado.isHidden = panel !== panelResultado
        panelProgreso.isHidden = panel !== panelPregunta && panel !== panelRespuesta
        desplazarAlInicio()
    }
}
