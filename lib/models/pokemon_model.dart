import 'package:cloud_firestore/cloud_firestore.dart';

class PokemonModel {
  final String name;
  final String imageUrl;
  final DateTime searchedAt;

  PokemonModel({
    required this.name,
    required this.imageUrl,
    required this.searchedAt,
  });

  // Convertir a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'searchedAt': searchedAt,
    };
  }

  // Crear un objeto desde un mapa de Firestore
  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      searchedAt: (map['searchedAt'] as Timestamp).toDate(),
    );
  }
}
