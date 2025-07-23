import 'package:flutter/material.dart';
import 'package:streamnest/data/models/searchModel.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/font_constants.dart';
import 'package:dio/dio.dart';
import 'package:streamnest/presentation/screens/movie_details_screen.dart';
import 'package:streamnest/presentation/screens/search_results_screen.dart';

// --- Models ---

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  SearchModel? _searchResults;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });
    try {
      final response = await Dio().get(
        'https://api.streamnest.tv/movies/search?query=$query',
      );
      if (response.statusCode == 200) {
        setState(() {
          _searchResults = SearchModel.fromJson(response.data);
        });
      }
    } catch (e) {
      // handle error
      setState(() {
        _searchResults = null;
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Search',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontConstants.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                if (value.length >= 3) {
                  _performSearch(value);
                } else {
                  setState(() {
                    _searchResults = null;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Search movies, TV shows, actors...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _searchResults = null;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.containerColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Search Results
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) return _buildEmptyState();
    if (_isSearching) return _buildLoadingState();
    if (_searchResults == null) return _buildNoResultsState();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movies Row
          if (_searchResults!.movies.isNotEmpty) ...[
            Text(
              'Movies',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontConstants.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.28,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 4),
                scrollDirection: Axis.horizontal,
                itemCount: _searchResults!.movies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final movie = _searchResults!.movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailsScreen(movie: movie),
                        ),
                      );
                    },
                    child: Container(
                      // width: 110,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie.posterPath,
                              // width: 100,
                              height: MediaQuery.of(context).size.height * 0.21,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 100,
                                height:
                                    MediaQuery.of(context).size.height * 0.21,
                                color: AppColors.card,
                                child: const Icon(Icons.movie, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: Text(
                              movie.title,
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontConstants.semiBold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Cast Row
          if (_searchResults!.castMembers.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text(
              'Cast',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontConstants.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 4),
                scrollDirection: Axis.horizontal,
                itemCount: _searchResults!.castMembers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final cast = _searchResults!.castMembers[index];
                  return Container(
                    //  width: 70,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              cast.profilePath != null &&
                                  cast.profilePath!.isNotEmpty
                              ? NetworkImage(cast.profilePath!)
                              : null,
                          child:
                              (cast.profilePath == null ||
                                  cast.profilePath!.isEmpty)
                              ? const Icon(Icons.person, size: 28)
                              : null,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 60,
                          child: Text(
                            cast.name,
                            style: AppTypography.labelSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],

          // Tags Row
          if (_searchResults!.tags.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text(
              'Tags',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontConstants.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _searchResults!.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                );
              }).toList(),
            ),
          ],
          if (_searchResults!.movies.isNotEmpty) ...[
            const SizedBox(height: 16),
            // See All Movies Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SearchResultsScreen(searchQuery: _searchQuery),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textInverse,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See All Movies',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontConstants.semiBold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Search for your favorite content',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontConstants.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find movies, TV shows, actors, and more',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text('Searching...'),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No results found',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontConstants.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or check your spelling',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            result['image'],
            width: 60,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 80,
                color: AppColors.textSecondary.withOpacity(0.2),
                child: const Icon(Icons.movie, color: AppColors.textSecondary),
              );
            },
          ),
        ),
        title: Text(
          result['title'],
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontConstants.semiBold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result['type'],
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontConstants.semiBold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  result['year'],
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.accent),
                const SizedBox(width: 4),
                Text(
                  result['rating'],
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontConstants.semiBold,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Navigate to details screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing details for ${result['title']}'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}
