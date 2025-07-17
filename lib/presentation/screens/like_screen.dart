import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Movies', 'Series', 'Recently Added'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Chips
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: AppColors.error,
                    checkmarkColor: AppColors.textInverse,
                    backgroundColor: AppColors.card,
                    labelStyle: AppTypography.labelMedium,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Content
        //  Expanded(child: _buildLikedContent()),
      ],
    );
  }

  // Widget _buildLikedContent() {
  //   return Consumer<MovieProvider>(
  //     builder: (context, movieProvider, child) {
  //       final favorites = movieProvider.favorites;

  //       if (favorites.isEmpty) {
  //         return _buildEmptyState();
  //       }

  //       return SingleChildScrollView(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SectionHeader(
  //               title: 'Liked Content',
  //               subtitle: 'Your favorite movies and series',
  //               trailing: PopupMenuButton<String>(
  //                 onSelected: (value) {
  //                   // Handle sort options
  //                 },
  //                 itemBuilder: (context) => [
  //                   const PopupMenuItem(
  //                     value: 'sort_name',
  //                     child: Text('Sort by Name'),
  //                   ),
  //                   const PopupMenuItem(
  //                     value: 'sort_rating',
  //                     child: Text('Sort by Rating'),
  //                   ),
  //                   const PopupMenuItem(
  //                     value: 'sort_date',
  //                     child: Text('Sort by Date Liked'),
  //                   ),
  //                   const PopupMenuItem(
  //                     value: 'filter_movies',
  //                     child: Text('Movies Only'),
  //                   ),
  //                   const PopupMenuItem(
  //                     value: 'filter_series',
  //                     child: Text('Series Only'),
  //                   ),
  //                 ],
  //                 child: const Icon(Icons.more_vert),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             GridView.builder(
  //               shrinkWrap: true,
  //               physics: const NeverScrollableScrollPhysics(),
  //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2,
  //                 childAspectRatio: 0.7,
  //                 crossAxisSpacing: 16,
  //                 mainAxisSpacing: 16,
  //               ),
  //               itemCount: favorites.length,
  //               itemBuilder: (context, index) {
  //                 final movie = favorites[index];
  //                 return MovieCard(
  //                   title: movie.title,
  //                   posterPath:
  //                       movie.posterUrl ?? AppConstants.moviePlaceholder,
  //                   rating: movie.rating ?? 0.0,
  //                   isFavorite: true,
  //                   isInWatchlist: movie.isInWatchlist,
  //                   onTap: () {
  //                     // Navigate to details
  //                   },
  //                   onFavoriteToggle: () => movieProvider.toggleFavorite(movie),
  //                   onWatchlistToggle: () =>
  //                       movieProvider.toggleWatchlist(movie),
  //                 );
  //               },
  //             ),
  //             const SizedBox(height: 100), // Bottom padding
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Liked Content Yet',
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: AppTypography.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start liking movies and series to see them here',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to discover or movies
              },
              child: const Text('Start Exploring'),
            ),
          ],
        ),
      ),
    );
  }
}
