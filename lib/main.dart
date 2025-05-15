import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

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

class _PokeHomeState extends State<PokeHome> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? pokemon;
  bool isLoading = false;
  String? error;

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
        setState(() {
          pokemon = {
            'name': data['name'],
            'image': data['sprites']['front_default'],
          };
        });
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
      ),
      body: Padding(
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
    );
  }
}
