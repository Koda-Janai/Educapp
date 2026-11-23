import UIKit

class PantallaEducapp: UIViewController {
    static let azul = UIColor(red: 35 / 255, green: 54 / 255, blue: 68 / 255, alpha: 1)

    @IBOutlet private weak var desplazamiento: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        let limite = desplazamiento.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor)
        limite.isActive = true
    }

    func desplazarAlInicio() {
        desplazamiento.setContentOffset(.zero, animated: false)
    }

    func alternarVisibilidad(_ campo: UITextField, boton: UIButton) {
        campo.isSecureTextEntry.toggle()
        boton.setTitle(campo.isSecureTextEntry ? "Mostrar" : "Ocultar", for: .normal)
    }

    func aviso(_ titulo: String, _ mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
