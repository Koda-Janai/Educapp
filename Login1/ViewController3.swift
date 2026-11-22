import UIKit

class ViewController3: PantallaEducapp {
    var cuenta: Cuenta?
    var alGuardar: ((Cuenta) -> Void)?

    private var usuario: UITextField!
    private var nombre: UITextField!
    private var apellido: UITextField!
    private var edad: UITextField!
    private var direccion: UITextField!
    private var contrasena: UITextField!
    private var confirmacion: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let edicion = cuenta != nil
        if presentingViewController != nil || navigationController?.viewControllers.first === self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel, target: self, action: #selector(cancelar)
            )
        }

        encabezado(edicion ? "Actualizar datos" : "Registra tu cuenta")
        usuario = campo("Nombre de usuario")
        usuario.autocapitalizationType = .none
        usuario.autocorrectionType = .no
        nombre = campo("Nombre")
        apellido = campo("Apellido")
        edad = campo("Edad")
        edad.keyboardType = .numberPad
        direccion = campo("Dirección")
        contenido.addArrangedSubview(etiqueta(edicion ? "Actualiza tu contraseña" : "Crea una contraseña", estilo: .headline))
        contrasena = campo(edicion ? "Nueva contraseña (opcional)" : "Contraseña", seguro: true)
        contrasena.textContentType = .newPassword
        confirmacion = campo("Confirmar contraseña", seguro: true)
        confirmacion.textContentType = .newPassword

        if let cuenta = cuenta {
            usuario.text = cuenta.usuario
            nombre.text = cuenta.nombre
            apellido.text = cuenta.apellido
            edad.text = String(cuenta.edad)
            direccion.text = cuenta.direccion
        }
        boton(edicion ? "Actualizar" : "Registrarse") { [weak self] in self?.guardar() }
    }

    @objc private func cancelar() {
        dismiss(animated: true)
    }

    private func guardar() {
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
