import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'models/pokemon_model.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LDSW 3.6 HTTP - PokeAPI',
      home: const PokeHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PokeHome extends StatefulWidget {
  const PokeHome({super.key});

  @override
  State<PokeHome> createState() => _PokeHomeState();
}

class _PokeHomeState extends State<PokeHome> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic>? pokemon;
  bool isLoading = false;
  String? error;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchPokemon(String name) async {
    if (name.isEmpty) {
      setState(() {
        error = 'Por favor ingresa un nombre de Pokémon';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase().trim()}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pokemonData = {
          'name': data['name'],
          'image': data['sprites']['front_default'],
        };

        setState(() {
          pokemon = pokemonData;
        });

        // Guardar la búsqueda en Firebase
        try {
          await _firebaseService.savePokemonSearch(
            PokemonModel(
              name: pokemonData['name'],
              imageUrl: pokemonData['image'],
              searchedAt: DateTime.now(),
            ),
          );
        } catch (e) {
          print('Error al guardar en Firebase: $e');
          // No mostramos este error al usuario para no interrumpir la experiencia
        }
      } else {
        setState(() {
          error = 'Pokémon no encontrado.';
          pokemon = null;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error al conectar con la API: ${e.toString()}';
        pokemon = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca tu Pokémon'),
        backgroundColor: Colors.redAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Buscar'),
            Tab(icon: Icon(Icons.history), text: 'Historial'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'LDSW 3.6 - Consulta de Pokémon por nombre',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Pokémon',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => fetchPokemon(_controller.text),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading) const CircularProgressIndicator(),
                if (error != null)
                  Text(error!, style: const TextStyle(color: Colors.red)),
                if (pokemon != null) ...[
                  Text(
                    pokemon!['name'].toString().toUpperCase(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Image.network(pokemon!['image']),
                ],
              ],
            ),
          ),

          // Pestaña de historial
          StreamBuilder<List<PokemonModel>>(
            stream: _firebaseService.getPokemonSearchHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar el historial: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final pokemonList = snapshot.data ?? [];

              if (pokemonList.isEmpty) {
                return const Center(
                  child: Text('No hay búsquedas en el historial'),
                );
              }

              return ListView.builder(
                itemCount: pokemonList.length,
                itemBuilder: (context, index) {
                  final pokemon = pokemonList[index];
                  return ListTile(
                    leading: Image.network(
                      pokemon.imageUrl,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                    title: Text(pokemon.name.toUpperCase()),
                    subtitle: Text(
                      'Buscado el ${_formatDate(pokemon.searchedAt)}',
                    ),
                    onTap: () {
                      _controller.text = pokemon.name;
                      fetchPokemon(pokemon.name);
                      _tabController.animateTo(0); // Cambiar a la pestaña de búsqueda
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
