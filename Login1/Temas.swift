import AVFoundation
import UIKit

class Temas: PantallaEducapp {
    @IBOutlet private weak var busqueda: UITextField!
    @IBOutlet private weak var sinResultados: UILabel!
    @IBOutlet private var categorias: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        filtrarTemas(busqueda)
    }

    @IBAction private func cerrarBusqueda(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    @IBAction private func filtrarTemas(_ sender: UITextField) {
        let texto = (sender.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        for boton in categorias {
            let tema = Tema.catalogo[boton.tag]
            boton.isHidden = !texto.isEmpty &&
                tema.nombre.range(of: texto, options: [.caseInsensitive, .diacriticInsensitive]) == nil
        }
        sinResultados.isHidden = categorias.contains(where: { !$0.isHidden })
    }

    @IBAction private func abrirTema(_ sender: UIButton) {
        guard let leccion = storyboard?.instantiateViewController(withIdentifier: "Leccion") as? Leccion else {
            return
        }
        cerrarBusqueda(busqueda)
        leccion.tema = Tema.catalogo[sender.tag]
        navigationController?.pushViewController(leccion, animated: true)
    }
}

final class Leccion: PantallaEducapp {
    var tema: Tema?
    private let lector = AVSpeechSynthesizer()

    @IBOutlet private weak var categoria: UILabel!
    @IBOutlet private weak var imagen: UIImageView!
    @IBOutlet private weak var titulo: UILabel!
    @IBOutlet private weak var lectura: UILabel!
    @IBOutlet private weak var audio: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tema = tema else { return }
        lector.delegate = self
        categoria.text = tema.nombre
        imagen.image = UIImage(systemName: tema.icono)
        titulo.text = tema.titulo
        lectura.text = tema.leccion
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lector.stopSpeaking(at: .immediate)
        actualizarAudio("Escuchar lección")
    }

    @IBAction private func alternarAudio(_ sender: UIButton) {
        guard let tema = tema else { return }
        if lector.isSpeaking {
            lector.stopSpeaking(at: .immediate)
            actualizarAudio("Escuchar lección")
        } else {
            let texto = AVSpeechUtterance(string: "\(tema.titulo). \(tema.leccion)")
            texto.voice = AVSpeechSynthesisVoice(language: "es-MX")
            lector.speak(texto)
            actualizarAudio("Detener lectura")
        }
    }

    private func actualizarAudio(_ titulo: String) {
        audio.setTitle(titulo, for: .normal)
    }
}

extension Leccion: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.lector.isSpeaking else { return }
            self.actualizarAudio("Escuchar lección")
        }
    }
}
