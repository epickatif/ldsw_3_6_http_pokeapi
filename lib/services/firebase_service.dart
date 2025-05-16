import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemon_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'pokemon_searches';

  // Guardar un Pokémon buscado en Firestore
  Future<void> savePokemonSearch(PokemonModel pokemon) async {
    try {
      await _firestore.collection(_collectionName).add(pokemon.toMap());
    } catch (e) {
      print('Error al guardar la búsqueda: $e');
      throw e;
    }
  }

  // Obtener el historial de búsquedas
  Stream<List<PokemonModel>> getPokemonSearchHistory() {
    return _firestore
        .collection(_collectionName)
        .orderBy('searchedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PokemonModel.fromMap(data);
      }).toList();
    });
  }

  // Eliminar una búsqueda del historial
  Future<void> deletePokemonSearch(String documentId) async {
    try {
      await _firestore.collection(_collectionName).doc(documentId).delete();
    } catch (e) {
      print('Error al eliminar la búsqueda: $e');
      throw e;
    }
  }
}
