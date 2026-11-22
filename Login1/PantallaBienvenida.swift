import UIKit

class PantallaBienvenida: PantallaEducapp {
    var cuenta: Cuenta?

    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarDatos()
    }

    private func mostrarDatos() {
        guard let cuenta = cuenta else { return }
        limpiarContenido()
        encabezado("Perfil", color: PantallaEducapp.pizarra)
        icono("person.crop.circle.fill")
        contenido.addArrangedSubview(etiqueta("@\(cuenta.usuario)", estilo: .title2, centrada: true))
        contenido.addArrangedSubview(etiqueta("\(cuenta.nombre) \(cuenta.apellido)", centrada: true))
        boton("Actualizar datos") { [weak self] in self?.editar() }
        boton("Cerrar sesión", secundario: true) { [weak self] in
            self?.tabBarController?.dismiss(animated: true)
        }
    }

    private func editar() {
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
