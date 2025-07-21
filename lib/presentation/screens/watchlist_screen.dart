import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamnest/core/constants/font_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
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
                    selectedColor: AppColors.warning,
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
        //Expanded(child: _buildWatchlistContent()),
      ],
    );
  }

  // Widget _buildWatchlistContent() {
  //   return Consumer<MovieProvider>(
  //     builder: (context, movieProvider, child) {
  //       final watchlist = movieProvider.watchlist;

  //       if (watchlist.isEmpty) {
  //         return _buildEmptyState();
  //       }

  //       return SingleChildScrollView(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SectionHeader(
  //               title: 'Watch List',
  //               subtitle: 'Content you want to watch',
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
  //                     child: Text('Sort by Date Added'),
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
  //               itemCount: watchlist.length,
  //               itemBuilder: (context, index) {
  //                 final movie = watchlist[index];
  //                 return MovieCard(
  //                   title: movie.title,
  //                   posterPath:
  //                       movie.posterUrl ?? AppConstants.moviePlaceholder,
  //                   rating: movie.rating ?? 0.0,
  //                   isFavorite: movie.isFavorite,
  //                   isInWatchlist: true,
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
                Icons.bookmark_border,
                size: 60,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Watch List Yet',
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontConstants.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add movies and series to your watch list to see them here',
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
