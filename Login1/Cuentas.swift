import Foundation
import Security

struct Cuenta: Codable {
    let id: UUID
    var usuario: String
    var nombre: String
    var apellido: String
    var edad: Int
    var direccion: String
    var contrasena: String
}

enum Cuentas {
    private static let consulta: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: (Bundle.main.bundleIdentifier ?? "Educapp") + ".cuentas",
        kSecAttrAccount as String: "cuentas-locales"
    ]

    static func leer() throws -> [Cuenta] {
        var solicitud = consulta
        solicitud[kSecReturnData as String] = true
        solicitud[kSecMatchLimit as String] = kSecMatchLimitOne
        var resultado: CFTypeRef?
        let estado = SecItemCopyMatching(solicitud as CFDictionary, &resultado)
        if estado == errSecItemNotFound {
            return []
        }
        guard estado == errSecSuccess, let datos = resultado as? Data else {
            throw ErrorCuenta.almacenamiento
        }
        return try JSONDecoder().decode([Cuenta].self, from: datos)
    }

    static func guardar(_ cuenta: Cuenta) throws {
        var cuentas = try leer()
        guard !cuentas.contains(where: {
            $0.id != cuenta.id && $0.usuario.caseInsensitiveCompare(cuenta.usuario) == .orderedSame
        }) else {
            throw ErrorCuenta.duplicada
        }

        if let indice = cuentas.firstIndex(where: { $0.id == cuenta.id }) {
            cuentas[indice] = cuenta
        } else {
            cuentas.append(cuenta)
        }

        let datos = try JSONEncoder().encode(cuentas)
        let cambios = [kSecValueData as String: datos]
        var estado = SecItemUpdate(consulta as CFDictionary, cambios as CFDictionary)
        if estado == errSecItemNotFound {
            var nueva = consulta
            nueva[kSecValueData as String] = datos
            nueva[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            estado = SecItemAdd(nueva as CFDictionary, nil)
        }
        guard estado == errSecSuccess else { throw ErrorCuenta.almacenamiento }
    }
}

enum ErrorCuenta: LocalizedError {
    case campos, edad, contrasena, confirmacion, duplicada, almacenamiento

    var errorDescription: String? {
        switch self {
        case .campos: return "Completa los datos de la cuenta."
        case .edad: return "Ingresa una edad válida entre 1 y 120."
        case .contrasena: return "Usa una contraseña de al menos 8 caracteres."
        case .confirmacion: return "Las contraseñas deben coincidir."
        case .duplicada: return "Ese nombre de usuario ya está en uso."
        case .almacenamiento: return "No se pudo acceder a las cuentas en este dispositivo."
        }
    }
}
