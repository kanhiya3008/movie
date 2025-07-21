import 'package:flutter/material.dart';
import 'package:streamnest/core/constants/font_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Library',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontConstants.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Favorites'),
            Tab(text: 'Watchlist'),
            Tab(text: 'History'),
          ],
          labelStyle: AppTypography.labelMedium.copyWith(
            fontWeight: FontConstants.semiBold,
          ),
          unselectedLabelStyle: AppTypography.labelMedium,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritesTab(),
          _buildWatchlistTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return _buildContentTab(
      title: 'Favorites',
      subtitle: 'Your favorite movies and series',
      items: List.generate(
        8,
        (index) => {
          'title': 'Favorite Movie ${index + 1}',
          'posterPath': AppConstants.moviePlaceholder,
          'rating': 4.2 + (index * 0.1),
          'type': index % 2 == 0 ? 'Movie' : 'Series',
        },
      ),
    );
  }

  Widget _buildWatchlistTab() {
    return _buildContentTab(
      title: 'Watchlist',
      subtitle: 'Content you want to watch',
      items: List.generate(
        6,
        (index) => {
          'title': 'Watchlist Item ${index + 1}',
          'posterPath': AppConstants.moviePlaceholder,
          'rating': 3.8 + (index * 0.1),
          'type': index % 2 == 0 ? 'Movie' : 'Series',
        },
      ),
    );
  }

  Widget _buildHistoryTab() {
    return _buildContentTab(
      title: 'Watch History',
      subtitle: 'Recently watched content',
      items: List.generate(
        10,
        (index) => {
          'title': 'Watched Item ${index + 1}',
          'posterPath': AppConstants.moviePlaceholder,
          'rating': 4.0 + (index * 0.1),
          'type': index % 2 == 0 ? 'Movie' : 'Series',
          'watchedAt': DateTime.now().subtract(Duration(days: index)),
        },
      ),
    );
  }

  Widget _buildContentTab({
    required String title,
    required String subtitle,
    required List<Map<String, dynamic>> items,
  }) {
    if (items.isEmpty) {
      return _buildEmptyState(title, subtitle);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                // Handle sort/filter options
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'sort_name',
                  child: Text('Sort by Name'),
                ),
                const PopupMenuItem(
                  value: 'sort_rating',
                  child: Text('Sort by Rating'),
                ),
                const PopupMenuItem(
                  value: 'sort_date',
                  child: Text('Sort by Date'),
                ),
                const PopupMenuItem(
                  value: 'filter_movies',
                  child: Text('Movies Only'),
                ),
                const PopupMenuItem(
                  value: 'filter_series',
                  child: Text('Series Only'),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return MovieCard(
                title: item['title'] as String,
                posterPath: item['posterPath'] as String,
                rating: item['rating'] as double,
                isFavorite: true,
                onTap: () {
                  // Navigate to details
                },
                onFavoriteToggle: () {
                  // Remove from favorites
                  setState(() {
                    items.removeAt(index);
                  });
                },
              );
            },
          ),
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
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
              child: Icon(
                _getEmptyStateIcon(),
                size: 60,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No $title Yet',
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontConstants.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to discover or search
                _tabController.animateTo(0);
              },
              child: const Text('Start Exploring'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    switch (_selectedTabIndex) {
      case 0:
        return Icons.favorite_border;
      case 1:
        return Icons.bookmark_border;
      case 2:
        return Icons.history;
      default:
        return Icons.favorite_border;
    }
  }
}
