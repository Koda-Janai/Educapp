import UIKit

class PantallaEducapp: UIViewController {
    static let azul = UIColor(red: 35 / 255, green: 54 / 255, blue: 68 / 255, alpha: 1)
    static let pizarra = UIColor(red: 72 / 255, green: 89 / 255, blue: 103 / 255, alpha: 1)
    private let desplazamiento = UIScrollView()
    let contenido = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        desplazamiento.keyboardDismissMode = .interactive
        desplazamiento.translatesAutoresizingMaskIntoConstraints = false
        contenido.axis = .vertical
        contenido.spacing = 14
        contenido.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(desplazamiento)
        desplazamiento.addSubview(contenido)

        let area = view.safeAreaLayoutGuide
        let documento = desplazamiento.contentLayoutGuide
        NSLayoutConstraint.activate([
            desplazamiento.topAnchor.constraint(equalTo: area.topAnchor),
            desplazamiento.leadingAnchor.constraint(equalTo: area.leadingAnchor),
            desplazamiento.trailingAnchor.constraint(equalTo: area.trailingAnchor),
            desplazamiento.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            contenido.topAnchor.constraint(equalTo: documento.topAnchor, constant: 20),
            contenido.bottomAnchor.constraint(equalTo: documento.bottomAnchor, constant: -24),
            contenido.leadingAnchor.constraint(equalTo: documento.leadingAnchor, constant: 20),
            contenido.trailingAnchor.constraint(equalTo: documento.trailingAnchor, constant: -20),
            contenido.widthAnchor.constraint(equalTo: desplazamiento.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }

    func limpiarContenido() {
        for vista in contenido.arrangedSubviews {
            contenido.removeArrangedSubview(vista)
            vista.removeFromSuperview()
        }
        desplazamiento.setContentOffset(.zero, animated: false)
    }

    func etiqueta(_ texto: String, estilo: UIFont.TextStyle = .body, centrada: Bool = false) -> UILabel {
        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.textColor = PantallaEducapp.azul
        etiqueta.font = UIFont.preferredFont(forTextStyle: estilo)
        etiqueta.adjustsFontForContentSizeCategory = true
        etiqueta.numberOfLines = 0
        etiqueta.textAlignment = centrada ? .center : .natural
        return etiqueta
    }

    func encabezado(_ texto: String, color: UIColor = PantallaEducapp.azul) {
        let tarjeta = UIView()
        tarjeta.backgroundColor = color
        tarjeta.layer.cornerRadius = 12
        let titulo = etiqueta(texto, estilo: .title2, centrada: true)
        let fuente = UIFont.preferredFont(forTextStyle: .title2)
        if let serif = fuente.fontDescriptor.withDesign(.serif) {
            titulo.font = UIFont(descriptor: serif, size: 0)
        }
        titulo.textColor = .white
        titulo.accessibilityTraits.insert(.header)
        titulo.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(titulo)
        NSLayoutConstraint.activate([
            titulo.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 16),
            titulo.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -16),
            titulo.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 16),
            titulo.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -16)
        ])
        contenido.addArrangedSubview(tarjeta)
    }

    func icono(_ nombre: String) {
        let imagen = UIImageView(image: UIImage(systemName: nombre))
        imagen.tintColor = PantallaEducapp.azul
        imagen.contentMode = .scaleAspectFit
        imagen.heightAnchor.constraint(equalToConstant: 70).isActive = true
        contenido.addArrangedSubview(imagen)
    }

    func campo(_ titulo: String, seguro: Bool = false) -> UITextField {
        let campo = UITextField()
        campo.placeholder = titulo
        campo.accessibilityLabel = titulo
        campo.borderStyle = .roundedRect
        campo.backgroundColor = .secondarySystemBackground
        campo.font = .preferredFont(forTextStyle: .body)
        campo.adjustsFontForContentSizeCategory = true
        campo.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        campo.isSecureTextEntry = seguro
        if seguro {
            let boton = UIButton(type: .system)
            boton.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
            boton.tintColor = PantallaEducapp.azul
            boton.setImage(UIImage(systemName: "eye"), for: .normal)
            boton.accessibilityLabel = "Mostrar contraseña"
            boton.addAction(UIAction { [weak campo, weak boton] _ in
                guard let campo = campo else { return }
                campo.isSecureTextEntry.toggle()
                let oculta = campo.isSecureTextEntry
                boton?.setImage(UIImage(systemName: oculta ? "eye" : "eye.slash"), for: .normal)
                boton?.accessibilityLabel = oculta ? "Mostrar contraseña" : "Ocultar contraseña"
            }, for: .touchUpInside)
            campo.rightView = boton
            campo.rightViewMode = .always
        }
        contenido.addArrangedSubview(campo)
        return campo
    }

    @discardableResult
    func boton(_ titulo: String, secundario: Bool = false, accion: @escaping () -> Void) -> UIButton {
        let boton = UIButton(type: .system)
        var configuracion: UIButton.Configuration = secundario ? .tinted() : .filled()
        configuracion.title = titulo
        configuracion.titleAlignment = .center
        configuracion.baseBackgroundColor = PantallaEducapp.azul
        configuracion.baseForegroundColor = secundario ? PantallaEducapp.azul : .white
        configuracion.cornerStyle = .capsule
        configuracion.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        boton.configuration = configuracion
        boton.titleLabel?.numberOfLines = 0
        boton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        boton.addAction(UIAction { _ in accion() }, for: .touchUpInside)
        contenido.addArrangedSubview(boton)
        return boton
    }

    func aviso(_ titulo: String, _ mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
