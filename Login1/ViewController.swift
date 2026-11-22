import UIKit

class ViewController: PantallaEducapp {
    private var usuario: UITextField!
    private var contrasena: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        icono("person.crop.circle.fill")
        encabezado("Iniciar sesión")
        usuario = campo("Nombre de usuario")
        usuario.textContentType = .username
        usuario.autocapitalizationType = .none
        usuario.autocorrectionType = .no
        contrasena = campo("Contraseña", seguro: true)
        contrasena.textContentType = .password
        boton("Iniciar sesión") { [weak self] in self?.ingresar() }
        boton("Crear una cuenta", secundario: true) { [weak self] in self?.registrar() }
    }

    private func registrar() {
        guard let formulario = storyboard?.instantiateViewController(withIdentifier: "Registro") as? ViewController3 else {
            return
        }
        formulario.alGuardar = { [weak self] cuenta in
            self?.usuario.text = cuenta.usuario
            self?.contrasena.text = ""
            self?.contrasena.becomeFirstResponder()
        }
        present(UINavigationController(rootViewController: formulario), animated: true)
    }

    private func ingresar() {
        view.endEditing(true)
        let nombre = (usuario.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let clave = contrasena.text ?? ""
        do {
            guard let cuenta = try Cuentas.leer().first(where: {
                $0.usuario.caseInsensitiveCompare(nombre) == .orderedSame && $0.contrasena == clave
            }) else {
                aviso("No se pudo iniciar sesión", "Revisa tu nombre de usuario y contraseña.")
                return
            }
            contrasena.text = ""
            abrirEducapp(cuenta)
        } catch {
            aviso("No se pudo iniciar sesión", error.localizedDescription)
        }
    }

    private func abrirEducapp(_ cuenta: Cuenta) {
        guard let temas = storyboard?.instantiateViewController(withIdentifier: "Temas") as? Temas,
              let perfil = storyboard?.instantiateViewController(withIdentifier: "Perfil") as? PantallaBienvenida else {
            return
        }
        perfil.cuenta = cuenta

        let pestanas = UITabBarController()
        pestanas.overrideUserInterfaceStyle = .light
        pestanas.modalPresentationStyle = .fullScreen
        pestanas.viewControllers = [
            pestana(temas, titulo: "Lecciones", icono: "house.fill"),
            pestana(perfil, titulo: "Perfil", icono: "person.fill"),
            pestana(Quiz(), titulo: "Quiz", icono: "flag.fill")
        ]
        let apariencia = UITabBarAppearance()
        apariencia.configureWithOpaqueBackground()
        apariencia.backgroundColor = PantallaEducapp.azul
        for elemento in [apariencia.stackedLayoutAppearance, apariencia.inlineLayoutAppearance,
                         apariencia.compactInlineLayoutAppearance] {
            elemento.selected.iconColor = .white
            elemento.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            elemento.normal.iconColor = UIColor(white: 0.78, alpha: 1)
            elemento.normal.titleTextAttributes = [.foregroundColor: UIColor(white: 0.78, alpha: 1)]
        }
        pestanas.tabBar.standardAppearance = apariencia
        pestanas.tabBar.scrollEdgeAppearance = apariencia
        present(pestanas, animated: true)
    }

    private func pestana(_ pantalla: UIViewController, titulo: String, icono: String) -> UINavigationController {
        let navegacion = UINavigationController(rootViewController: pantalla)
        navegacion.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), tag: 0)
        navegacion.navigationBar.tintColor = PantallaEducapp.azul
        return navegacion
    }
}
