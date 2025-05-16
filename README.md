# LDSW 3.6 y 3.7 - PokeAPI con HTTP y Firebase

Este proyecto abarca dos actividades del curso:
- **Actividad 3.6**: Implementación de peticiones HTTP utilizando Flutter y la API pública de Pokémon (PokeAPI).
- **Actividad 3.7**: Integración de Firebase para almacenar el historial de búsquedas de Pokémon.

## Funcionalidad

### Actividad 3.6 - HTTP con PokeAPI
- Permite buscar cualquier Pokémon por su nombre.
- Muestra el nombre e imagen del Pokémon consultado.
- Realiza solicitudes HTTP usando el paquete [`http`](https://pub.dev/packages/http).
- Manejo de errores en caso de nombre incorrecto o fallo de conexión.

### Actividad 3.7 - Integración de Firebase
- Almacena automáticamente el historial de búsquedas en Firebase Firestore.
- Permite ver y reutilizar búsquedas anteriores desde la pestaña de historial.
- Interfaz con pestañas para navegar entre búsqueda y historial.
- Configuración completa de Firebase para Android e iOS.

## Tecnologías utilizadas

### Actividad 3.6
- Flutter 3.29.x
- Dart
- Paquete `http` para solicitudes HTTP

### Actividad 3.7
- Firebase Firestore para almacenamiento de datos
- Firebase Core para la configuración base
- Firebase Authentication (preparado para futuras implementaciones)

## Estructura del proyecto

### Archivos principales (Actividad 3.6)
- **lib/main.dart**: Punto de entrada principal de la aplicación y lógica de consulta HTTP

### Archivos añadidos (Actividad 3.7)
- **lib/firebase_options.dart**: Configuración de Firebase
- **lib/models/pokemon_model.dart**: Modelo de datos para Pokémon
- **lib/services/firebase_service.dart**: Servicios para interactuar con Firebase
- **android/app/google-services.json**: Configuración de Firebase para Android
- **ios/Runner/GoogleService-Info.plist**: Configuración de Firebase para iOS

## Cómo ejecutar

1. Clona el repositorio:

   ```bash
   git clone https://github.com/epickatif/ldsw_3_6_http_pokeapi.git
   cd ldsw_3_6_http_pokeapi
   ```

2. Instala dependencias:

   ```bash
   flutter pub get
   ```

3. Ejecuta la app:

   ```bash
   flutter run
   ```

4. Selecciona el dispositivo donde quieres ejecutar la aplicación (Chrome, Edge o Windows).

## Ejemplos para probar la aplicación

Para facilitar las pruebas, aquí hay algunos nombres de Pokémon que puede buscar:

| Nombre      | Descripción                                |
|-------------|--------------------------------------------|
| pikachu     | El Pokémon más conocido, tipo eléctrico    |
| charizard   | Pokémon tipo fuego/volador, muy popular    |
| bulbasaur   | Pokémon inicial tipo planta/veneno         |
| squirtle    | Pokémon inicial tipo agua                  |
| mewtwo      | Pokémon legendario tipo psíquico           |
| eevee       | Pokémon con múltiples evoluciones          |
| snorlax     | Pokémon grande que siempre está durmiendo  |
| gengar      | Pokémon tipo fantasma/veneno               |

### Instrucciones para probar la base de datos:

1. Busque varios Pokémon de la lista anterior (o cualquier otro)
2. Cambie a la pestaña "Historial" para ver las búsquedas guardadas en Firebase
3. Haga clic en cualquier Pokémon del historial para volver a buscarlo
4. Observe cómo las búsquedas se guardan automáticamente y están disponibles incluso después de reiniciar la aplicación

## Estado del proyecto

- **Actividad 3.6**: ✅ Finalizada y funcional. La aplicación puede realizar consultas HTTP a la PokeAPI y mostrar los resultados.
- **Actividad 3.7**: ✅ Finalizada y funcional. La aplicación está completamente integrada con Firebase para almacenar y recuperar el historial de búsquedas de Pokémon.
