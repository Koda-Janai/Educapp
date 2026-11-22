struct Tema {
    let nombre: String
    let icono: String
    let color: UInt32
    let titulo: String
    let leccion: String
    let pregunta: String
    let correcta: String
    let distractores: [String]
    let explicacion: String

    static let catalogo = [
        Tema(
            nombre: "Series", icono: "tv.fill", color: 0xF6CE60,
            titulo: "¿Qué es una serie?",
            leccion: "Una serie es una historia audiovisual dividida en episodios. Los episodios pueden agruparse en temporadas, que organizan etapas de la historia o conjuntos de capítulos.",
            pregunta: "¿Cómo suele llamarse el conjunto de episodios de una etapa de la serie?",
            correcta: "Temporada", distractores: ["Escena", "Tráiler", "Guion"],
            explicacion: "Una temporada reúne episodios. Una escena es una parte de un episodio y un tráiler es un avance."
        ),
        Tema(
            nombre: "Historia", icono: "building.columns.fill", color: 0xE8754C,
            titulo: "El origen de las civilizaciones",
            leccion: "La agricultura favoreció los asentamientos permanentes. Al producir y almacenar alimentos, algunas comunidades pudieron sostener poblaciones mayores y especializar sus oficios.",
            pregunta: "¿Qué actividad favoreció los asentamientos permanentes?",
            correcta: "La agricultura", distractores: ["La navegación espacial", "La fotografía", "La imprenta"],
            explicacion: "El cultivo y el almacenamiento de alimentos hicieron posible que muchas comunidades se quedaran en un lugar."
        ),
        Tema(
            nombre: "Deportes", icono: "soccerball", color: 0x55BFAE,
            titulo: "El fútbol",
            leccion: "En el fútbol juegan dos equipos. En la modalidad de once, cada equipo comienza normalmente con once futbolistas, entre ellos un portero. Gana quien marca más goles.",
            pregunta: "¿Cuántos jugadores tiene normalmente cada equipo al empezar un partido de fútbol once?",
            correcta: "Once", distractores: ["Siete", "Quince", "Nueve"],
            explicacion: "El fútbol once se juega normalmente con once integrantes por equipo, incluido el portero."
        ),
        Tema(
            nombre: "Química", icono: "flask.fill", color: 0xB7CC51,
            titulo: "Los átomos",
            leccion: "Un átomo contiene un núcleo rodeado por electrones. El número de protones del núcleo identifica el elemento químico, aunque el número de neutrones o electrones pueda variar.",
            pregunta: "¿Qué partícula determina el número atómico de un elemento?",
            correcta: "El protón", distractores: ["El neutrón", "El electrón", "El fotón"],
            explicacion: "El número atómico corresponde al número de protones del núcleo."
        ),
        Tema(
            nombre: "Cine", icono: "film.fill", color: 0xC8D4DE,
            titulo: "La producción cinematográfica",
            leccion: "En una película, la preproducción organiza el guion, el reparto y el rodaje. Después de filmar, la posproducción incluye el montaje de las imágenes y el trabajo de sonido.",
            pregunta: "¿En qué etapa se realiza habitualmente el montaje de las imágenes?",
            correcta: "Posproducción", distractores: ["Preproducción", "Casting", "Distribución"],
            explicacion: "El montaje reúne y ordena el material filmado durante la posproducción."
        ),
        Tema(
            nombre: "Música", icono: "music.note", color: 0xF4AD66,
            titulo: "La familia de los instrumentos",
            leccion: "Los instrumentos se pueden agrupar por cómo producen sonido. Una guitarra hace vibrar cuerdas, una flauta pone en vibración una columna de aire y un tambor usa una membrana.",
            pregunta: "¿A qué familia pertenece la guitarra?",
            correcta: "Cuerda", distractores: ["Viento", "Percusión", "Electrónica"],
            explicacion: "La guitarra suena al hacer vibrar sus cuerdas."
        ),
        Tema(
            nombre: "Filosofía", icono: "lightbulb.fill", color: 0x78BC63,
            titulo: "¿Qué es la filosofía?",
            leccion: "La filosofía examina preguntas sobre temas como la realidad, el conocimiento y la conducta. La ética estudia cómo razonar sobre lo correcto, las decisiones y la forma de vivir.",
            pregunta: "¿Qué rama estudia las preguntas sobre cómo debemos actuar?",
            correcta: "Ética", distractores: ["Geometría", "Fonética", "Cartografía"],
            explicacion: "La ética examina las razones para actuar de cierta manera y los criterios para evaluar la conducta."
        ),
        Tema(
            nombre: "Arte", icono: "paintpalette.fill", color: 0xE78BB7,
            titulo: "Las técnicas y materiales del arte",
            leccion: "Las artes visuales emplean técnicas y materiales distintos. Un collage se forma al combinar y fijar elementos como recortes de papel, fotografías o tela sobre una superficie.",
            pregunta: "¿Qué técnica consiste en fijar recortes y otros materiales sobre una superficie?",
            correcta: "Collage", distractores: ["Acuarela", "Grabado", "Escultura"],
            explicacion: "El collage compone una imagen reuniendo y pegando materiales diferentes."
        ),
        Tema(
            nombre: "Matemáticas", icono: "function", color: 0xE55762,
            titulo: "Las operaciones básicas",
            leccion: "La multiplicación representa la suma repetida cuando trabajamos con números naturales. Por ejemplo, tres grupos de cuatro objetos suman doce objetos.",
            pregunta: "¿Cuánto es 3 × 4?",
            correcta: "12", distractores: ["7", "16", "10"],
            explicacion: "Tres grupos de cuatro equivalen a 4 + 4 + 4, que suma 12."
        ),
        Tema(
            nombre: "Videojuegos", icono: "gamecontroller.fill", color: 0x9B81D3,
            titulo: "Los géneros de videojuegos",
            leccion: "Los géneros describen qué hace el jugador. En un juego de plataformas, desplazarse y saltar entre superficies suele ser central. En un juego de estrategia, pesa más la planificación.",
            pregunta: "¿Qué género suele centrarse en saltar entre superficies?",
            correcta: "Plataformas", distractores: ["Estrategia", "Simulación de gestión", "Deportes"],
            explicacion: "El desplazamiento y el salto entre superficies son mecánicas típicas de los juegos de plataformas."
        ),
        Tema(
            nombre: "Física", icono: "atom", color: 0x4CAAD3,
            titulo: "El movimiento y la velocidad",
            leccion: "La rapidez media es la distancia total recorrida dividida entre el tiempo empleado. Si se recorren 100 metros en 20 segundos, la rapidez media es de 5 metros por segundo.",
            pregunta: "¿Cuál es la rapidez media al recorrer 100 metros en 20 segundos?",
            correcta: "5 m/s", distractores: ["20 m/s", "100 m/s", "80 m/s"],
            explicacion: "La división de 100 metros entre 20 segundos da 5 metros por segundo."
        )
    ]
}
