import UIKit

class PantallaBienvenida: PantallaEducapp {
    var cuenta: Cuenta?

    @IBOutlet private weak var usuario: UILabel!
    @IBOutlet private weak var nombre: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarDatos()
    }

    private func mostrarDatos() {
        guard let cuenta = cuenta else { return }
        usuario.text = "@\(cuenta.usuario)"
        nombre.text = "\(cuenta.nombre) \(cuenta.apellido)"
    }

    @IBAction private func cerrarSesion(_ sender: UIButton) {
        tabBarController?.dismiss(animated: true)
    }

    @IBAction private func editar(_ sender: UIButton) {
        guard let formulario = storyboard?.instantiateViewController(withIdentifier: "Registro") as? ViewController3 else {
            return
        }
        formulario.cuenta = cuenta
        formulario.alGuardar = { [weak self] cuenta in
            self?.cuenta = cuenta
            self?.mostrarDatos()
        }
        navigationController?.pushViewController(formulario, animated: true)
    }
}
