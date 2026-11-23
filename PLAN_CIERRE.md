# Plan de cierre de Educapp

El proyecto conserva el target IniciodeSesionOct, UIKit, los controladores originales y Main.storyboard como punto de arranque. Las seis escenas tienen sus controles y restricciones de Auto Layout en Interface Builder. La navegación principal tiene tres pestañas, Lecciones, Perfil y Quiz. La implementación toma como referencia el [diseño de Educapp en Figma](https://www.figma.com/design/aTMtzR7Ppk6f9Iya5Gyuo2/261119_EducappXcode_EquipoDinamita?node-id=0-1).

## 1. Compilar y verificar el flujo en macOS

- [ ] Abrir Login1.xcodeproj en Xcode con un SDK que admita el objetivo iOS 26.5 del proyecto. Seleccionar IniciodeSesionOct y ejecutar primero en un simulador iPhone.
- [ ] En la primera ejecución, crear una cuenta. Las cuentas son locales al dispositivo y se guardan en el Llavero.
- [ ] Probar formularios vacíos, edades inválidas, contraseñas distintas, un nombre de usuario duplicado y credenciales incorrectas.
- [ ] Crear una cuenta, entrar, editar nombre de usuario y contraseña, cerrar sesión, reabrir la app y acceder con las credenciales nuevas.
- [ ] Buscar “quimica” y “Química”, revisar el estado sin resultados y abrir las 11 lecciones. Probar iniciar y detener la lectura y salir de la pantalla mientras se reproduce.
- [ ] Completar el quiz con aciertos y errores, comprobar el resultado sobre 11 y verificar que el siguiente intento reinicia el contador.

## 2. Completar el contenido y la revisión visual

- [ ] Comparar en simulador acceso, registro, perfil, catálogo, lección, pregunta, retroalimentación y resultado con los frames de Figma.
- [ ] Exportar los banners e imágenes definitivas del diseño e integrarlos en Assets.xcassets. La versión actual usa símbolos del sistema en las lecciones y el perfil.
- [ ] Completar y revisar los apartados de cada lección y aprobar el banco de preguntas. El catálogo actual incluye una lectura breve y una pregunta de muestra por categoría. El audio se genera con la voz del sistema.
- [ ] Validar contraste, navegación con VoiceOver, texto grande, pantallas compactas y formularios con teclado abierto.

## 3. Preparar la entrega

- [ ] Confirmar si la distribución requiere cuentas compartidas entre dispositivos, recuperación o sincronización. El flujo implementado usa cuentas locales.
- [ ] Incorporar el icono definitivo, configurar firma y generar un archivo desde Xcode para la vía de entrega acordada.
- [ ] Cerrar la entrega cuando compile, se haya probado de inicio a fin en iPhone y se hayan aprobado el contenido y los recursos visuales.

Consulta el [README](README.md) para preparar Xcode. GitHub Actions comprueba la compilación y el arranque en iOS 26.5. Los recorridos interactivos de esta lista se verifican desde Xcode.
