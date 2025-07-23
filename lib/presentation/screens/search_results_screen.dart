import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../core/constants/font_constants.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';
import '../../data/models/movie.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Movie> _allMovies = [];
  bool _isLoading = true;
  String? _error;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAllSearchResults();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllSearchResults() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('Fetching all search results for: ${widget.searchQuery}');

      // Call the search API to get all results
      final response = await Dio().get(
        'https://api.streamnest.tv/movies/search?query=${Uri.encodeComponent(widget.searchQuery)}',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('Search results API response:');
        print(data);

        if (data is Map<String, dynamic> && data.containsKey('movies')) {
          final moviesList = data['movies'] as List;
          setState(() {
            _allMovies = moviesList
                .map((movieData) => Movie.fromJson(movieData))
                .toList();
            _isLoading = false;
          });
          print(
            'Loaded ${_allMovies.length} movies for search: ${widget.searchQuery}',
          );
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print('Error fetching search results: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Results for "${widget.searchQuery}"',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontConstants.semiBold,
          ),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_allMovies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_allMovies.length} movies',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_allMovies.isEmpty) {
      return _buildEmptyState();
    }

    return _buildMoviesGrid();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Searching for "${widget.searchQuery}"...',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontConstants.semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Failed to load search results',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchAllSearchResults,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Try Again',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontConstants.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No movies found',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontConstants.semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No movies found for "${widget.searchQuery}"',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid() {
    return RefreshIndicator(
      onRefresh: _fetchAllSearchResults,
      color: AppColors.primary,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _allMovies.length,
        itemBuilder: (context, index) {
          final movie = _allMovies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(movie: movie),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie poster
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        movie.posterPath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.cardLight,
                            child: const Icon(
                              Icons.movie,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Movie info
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontConstants.semiBold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (movie.releaseDate.isNotEmpty)
                            Text(
                              _extractYearFromDate(movie.releaseDate),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _extractYearFromDate(String dateString) {
    try {
      final date = DateTime.tryParse(dateString);
      return date?.year.toString() ?? '';
    } catch (e) {
      return '';
    }
  }
}
