import UIKit

class ViewController: PantallaEducapp {
    @IBOutlet private weak var usuario: UITextField!
    @IBOutlet private weak var contrasena: UITextField!

    @IBAction private func mostrarContrasena(_ sender: UIButton) {
        alternarVisibilidad(contrasena, boton: sender)
    }

    @IBAction private func registrar(_ sender: UIButton) {
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

    @IBAction private func ingresar(_ sender: UIButton) {
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
              let perfil = storyboard?.instantiateViewController(withIdentifier: "Perfil") as? PantallaBienvenida,
              let quiz = storyboard?.instantiateViewController(withIdentifier: "Quiz") as? Quiz else {
            return
        }
        perfil.cuenta = cuenta

        let pestanas = UITabBarController()
        pestanas.overrideUserInterfaceStyle = .light
        pestanas.modalPresentationStyle = .fullScreen
        pestanas.viewControllers = [
            pestana(temas, titulo: "Lecciones", icono: "house.fill"),
            pestana(perfil, titulo: "Perfil", icono: "person.fill"),
            pestana(quiz, titulo: "Quiz", icono: "flag.fill")
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
