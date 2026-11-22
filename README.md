# Educapp

Educapp es una app para iPhone escrita en Swift con UIKit. Usa `Main.storyboard` para iniciar la app y definir las escenas de acceso, registro, perfil y lecciones. Los controladores construyen la interfaz con Auto Layout en Swift.

## Requisitos

- Una Mac con **macOS Tahoe 26.2 o posterior dentro de la serie 26** para usar Xcode 26.6.
- **Xcode 26.6** con soporte para iOS. Es la versión usada en la verificación de GitHub Actions.
- **iOS 26.5** como versión mínima de la app. Para probarla en la Mac, instala el simulador iOS 26.5 desde **Xcode → Settings → Components**.

Consulta los [requisitos oficiales de Xcode](https://developer.apple.com/xcode/system-requirements/) y la [guía de instalación de componentes](https://developer.apple.com/documentation/xcode/downloading-and-installing-additional-xcode-components).

## Ejecutar en Xcode

1. Clona el repositorio o descarga el código desde **Code → Download ZIP**.
2. Abre `Login1.xcodeproj`.
3. Selecciona el esquema **IniciodeSesionOct** y el destino **iPhone 17 (iOS 26.5)**.
4. Presiona **⌘R**. En la pantalla inicial, elige **Crear una cuenta** y usa datos de prueba.
5. Inicia sesión y revisa las pestañas **Lecciones**, **Perfil** y **Quiz**.

Para ejecutar en un iPhone físico con iOS 26.5 o posterior, conecta el dispositivo, selecciona tu equipo en **Signing & Capabilities** y elige el iPhone como destino. Cambia el identificador de paquete si Xcode informa que está ocupado.

## Verificación

[GitHub Actions](https://github.com/Koda-Janai/Educapp/actions) compila el proyecto en macOS con Xcode 26.6 y con el mínimo de iOS configurado en el proyecto. Instala y abre la app en un iPhone 17 con iOS 26.5 y comprueba que el proceso siga activo. El [plan de cierre](PLAN_CIERRE.md) incluye las pruebas manuales de registro, Llavero, lecciones y quiz.
