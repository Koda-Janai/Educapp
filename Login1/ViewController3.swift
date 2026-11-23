import UIKit

class ViewController3: PantallaEducapp {
    var cuenta: Cuenta?
    var alGuardar: ((Cuenta) -> Void)?

    @IBOutlet private weak var usuario: UITextField!
    @IBOutlet private weak var nombre: UITextField!
    @IBOutlet private weak var apellido: UITextField!
    @IBOutlet private weak var edad: UITextField!
    @IBOutlet private weak var direccion: UITextField!
    @IBOutlet private weak var contrasena: UITextField!
    @IBOutlet private weak var confirmacion: UITextField!

    @IBOutlet private weak var encabezado: UILabel!
    @IBOutlet private weak var tituloClave: UILabel!
    @IBOutlet private weak var botonGuardar: UIButton!

    @IBAction private func mostrarContrasena(_ sender: UIButton) {
        alternarVisibilidad(sender.tag == 1 ? confirmacion : contrasena, boton: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let edicion = cuenta != nil
        if presentingViewController != nil || navigationController?.viewControllers.first === self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel, target: self, action: #selector(cancelar)
            )
        }

        if edicion {
            encabezado.text = "Actualizar datos"
            tituloClave.text = "Actualiza tu contraseña"
            contrasena.placeholder = "Nueva contraseña (opcional)"
            botonGuardar.setTitle("Actualizar", for: .normal)
        }

        if let cuenta = cuenta {
            usuario.text = cuenta.usuario
            nombre.text = cuenta.nombre
            apellido.text = cuenta.apellido
            edad.text = String(cuenta.edad)
            direccion.text = cuenta.direccion
        }
    }

    @objc private func cancelar() {
        dismiss(animated: true)
    }

    @IBAction private func guardar(_ sender: UIButton) {
        view.endEditing(true)
        do {
            let nueva = try datosDelFormulario()
            try Cuentas.guardar(nueva)
            if let navegacion = navigationController, navegacion.viewControllers.first !== self {
                alGuardar?(nueva)
                navegacion.popViewController(animated: true)
            } else {
                let accion = alGuardar
                dismiss(animated: true) { accion?(nueva) }
            }
        } catch {
            aviso("Revisa tus datos", error.localizedDescription)
        }
    }

    private func datosDelFormulario() throws -> Cuenta {
        let datos = [usuario, nombre, apellido, edad, direccion].map {
            ($0?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        guard datos.allSatisfy({ !$0.isEmpty }) else { throw ErrorCuenta.campos }
        guard let edad = Int(datos[3]), (1...120).contains(edad) else { throw ErrorCuenta.edad }
        let clave = contrasena.text ?? ""
        let repeticion = confirmacion.text ?? ""
        let claveFinal: String
        if let cuenta = cuenta, clave.isEmpty, repeticion.isEmpty {
            claveFinal = cuenta.contrasena
        } else {
            guard clave.count >= 8 else { throw ErrorCuenta.contrasena }
            guard clave == repeticion else { throw ErrorCuenta.confirmacion }
            claveFinal = clave
        }
        return Cuenta(id: cuenta?.id ?? UUID(), usuario: datos[0], nombre: datos[1],
                      apellido: datos[2], edad: edad, direccion: datos[4], contrasena: claveFinal)
    }
}
