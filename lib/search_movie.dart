import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './movie.dart';
import './view_details_movie.dart';
import 'package:rxdart/rxdart.dart'; // Add this for stream combination
import 'dart:developer' as developer;

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({super.key});

  @override
  _SearchMoviePageState createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim(); // Keep original input
        _isLoading = _searchQuery.isNotEmpty; // Show loading when typing starts
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Movies',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _searchQuery.isEmpty
                  ? const Center(
                      child: Text(
                        'Start typing to search movies...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : StreamBuilder<List<QuerySnapshot>>(
                      stream: CombineLatestStream.list([
                        FirebaseFirestore.instance
                            .collection('Movies')
                            .where('movie_name',
                                isGreaterThanOrEqualTo: _searchQuery.toLowerCase())
                            .where('movie_name',
                                isLessThanOrEqualTo: '${_searchQuery.toLowerCase()}\uf8ff')
                            .snapshots(),
                        FirebaseFirestore.instance
                            .collection('Movies')
                            .where('movie_name',
                                isGreaterThanOrEqualTo: _searchQuery.toUpperCase())
                            .where('movie_name',
                                isLessThanOrEqualTo: '${_searchQuery.toUpperCase()}\uf8ff')
                            .snapshots(),
                      ]),
                      builder: (context, snapshot) {
                        if (_isLoading && snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.blueAccent),
                          );
                        }
                        if (snapshot.hasError) {
                          developer.log('Search error: ${snapshot.error}');
                          return const Center(child: Text('Error loading movies'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No movies found'));
                        }

                        // Combine results from both queries and remove duplicates
                        final allDocs = snapshot.data!
                            .expand((qs) => qs.docs)
                            .toSet(); // Use Set to avoid duplicates
                        final movies = allDocs
                            .map((doc) => Movie.fromFirestore(doc))
                            .where((movie) => movie.movieName
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();

                        // Reset loading state once data is loaded
                        if (_isLoading) {
                          Future.delayed(Duration.zero, () {
                            setState(() => _isLoading = false);
                          });
                        }

                        if (movies.isEmpty) {
                          return const Center(child: Text('No matching movies found'));
                        }

                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return _buildMovieCard(context, movies[index]);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ViewDetailsMovie(movie: movie),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.movieImage.isNotEmpty
                    ? movie.movieImage
                    : 'https://via.placeholder.com/150',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  developer.log('Image load error for ${movie.movieName}: $error');
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.movieName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}