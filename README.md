# LDSW 3.6 HTTP - PokeAPI

Este proyecto es parte de la actividad 3.6 del curso, y muestra cómo realizar peticiones HTTP utilizando Flutter y la API pública de Pokémon (PokeAPI).

## Funcionalidad

- Permite buscar cualquier Pokémon por su nombre.
- Muestra el nombre e imagen del Pokémon consultado.
- Realiza solicitudes HTTP usando el paquete [`http`](https://pub.dev/packages/http).
- Manejo de errores en caso de nombre incorrecto o fallo de conexión.

## Tecnologías utilizadas

- Flutter 3.29.x
- Dart
- Paquete `http` para solicitudes HTTP

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

3. Asegúrate de tener acceso a Internet. Si usas Android, revisa que `AndroidManifest.xml` tenga el permiso:

   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

4. Ejecuta la app:

   ```bash
   flutter run
   ```

## Estado

Actividad finalizada y funcional.
