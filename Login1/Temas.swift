import AVFoundation
import UIKit

class Temas: PantallaEducapp {
    private var busqueda: UITextField!
    private var resultados = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        encabezado("Lecciones")
        busqueda = campo("Busca una categoría")
        busqueda.clearButtonMode = .whileEditing
        busqueda.returnKeyType = .search
        busqueda.addTarget(self, action: #selector(filtrarTemas), for: .editingChanged)
        busqueda.addTarget(self, action: #selector(cerrarBusqueda), for: .editingDidEndOnExit)
        resultados.axis = .vertical
        resultados.spacing = 10
        contenido.addArrangedSubview(resultados)
        filtrarTemas()
    }

    @objc private func cerrarBusqueda() {
        busqueda.resignFirstResponder()
    }

    @objc private func filtrarTemas() {
        for vista in resultados.arrangedSubviews {
            resultados.removeArrangedSubview(vista)
            vista.removeFromSuperview()
        }
        let texto = (busqueda.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let coincidencias = Tema.catalogo.filter {
            texto.isEmpty || $0.nombre.range(of: texto, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
        if coincidencias.isEmpty {
            resultados.addArrangedSubview(etiqueta("No hay temas que coincidan con tu búsqueda.", centrada: true))
        }
        for tema in coincidencias {
            resultados.addArrangedSubview(tarjeta(tema))
        }
    }

    private func tarjeta(_ tema: Tema) -> UIButton {
        var configuracion = UIButton.Configuration.filled()
        configuracion.title = tema.nombre
        configuracion.image = UIImage(systemName: tema.icono)
        configuracion.imagePadding = 12
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 16)
        configuracion.baseBackgroundColor = PantallaEducapp.azul
        configuracion.baseForegroundColor = .white
        configuracion.cornerStyle = .large

        let tarjeta = UIButton(configuration: configuracion)
        tarjeta.contentHorizontalAlignment = .leading
        tarjeta.heightAnchor.constraint(greaterThanOrEqualToConstant: 54).isActive = true
        let acento = UIView()
        acento.backgroundColor = UIColor(
            red: CGFloat((tema.color >> 16) & 255) / 255,
            green: CGFloat((tema.color >> 8) & 255) / 255,
            blue: CGFloat(tema.color & 255) / 255,
            alpha: 1
        )
        acento.layer.cornerRadius = 2
        acento.isUserInteractionEnabled = false
        acento.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(acento)
        NSLayoutConstraint.activate([
            acento.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 16),
            acento.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -16),
            acento.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -7),
            acento.heightAnchor.constraint(equalToConstant: 4)
        ])
        tarjeta.addAction(UIAction { [weak self] _ in
            self?.cerrarBusqueda()
            self?.navigationController?.pushViewController(Leccion(tema: tema), animated: true)
        }, for: .touchUpInside)
        return tarjeta
    }
}

final class Leccion: PantallaEducapp {
    private let tema: Tema
    private let lector = AVSpeechSynthesizer()
    private var audio: UIButton!

    init(tema: Tema) {
        self.tema = tema
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { return nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        lector.delegate = self
        encabezado(tema.nombre)
        icono(tema.icono)
        audio = boton("Escuchar lección", secundario: true) { [weak self] in self?.alternarAudio() }
        contenido.addArrangedSubview(etiqueta(tema.titulo, estilo: .title2))
        contenido.addArrangedSubview(etiqueta(tema.leccion))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lector.stopSpeaking(at: .immediate)
        actualizarAudio("Escuchar lección")
    }

    private func alternarAudio() {
        if lector.isSpeaking {
            lector.stopSpeaking(at: .immediate)
            actualizarAudio("Escuchar lección")
        } else {
            let lectura = AVSpeechUtterance(string: "\(tema.titulo). \(tema.leccion)")
            lectura.voice = AVSpeechSynthesisVoice(language: "es-MX")
            lector.speak(lectura)
            actualizarAudio("Detener lectura")
        }
    }

    private func actualizarAudio(_ titulo: String) {
        audio.configuration?.title = titulo
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
