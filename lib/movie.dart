import 'package:cloud_firestore/cloud_firestore.dart';
class Movie {
  final String movieName; // Display name (e.g., "PUSHPA")
  final String movieImage;
  final String movieNameLowercase; // Lowercase for searching (e.g., "pushpa")

  Movie({
    required this.movieName,
    required this.movieImage,
    required this.movieNameLowercase,
  });

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Movie(
      movieName: data['movie_name'] ?? '', // Updated to movie_name
      movieImage: data['movie_image'] ?? '',
      movieNameLowercase: data['movie_name_lowercase'] ?? '', // Updated to movie_name_lowercase
    );
  }
}