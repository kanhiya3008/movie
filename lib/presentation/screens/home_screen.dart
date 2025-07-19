import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:streamnest/presentation/screens/widgets/heroidgets.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../providers/theme_provider.dart';
import '../providers/movie_provider.dart';
import '../providers/filter_data_provider.dart';
import '../widgets/section_header.dart';
import '../widgets/filter_list_widget.dart';
import '../../data/models/movie.dart';
import 'feed_screen.dart';
import 'movies_screen.dart';
import 'like_screen.dart';
import 'watchlist_screen.dart';
import 'movie_details_screen.dart';
import 'search_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const FeedScreen(),
    const MoviesScreen(),
    const LikeScreen(),
    const WatchlistScreen(),
  ];

  final List<String> _screenTitles = [
    'StreamNest',
    'Feed',
    'Movies',
    'Like',
    'Watch List',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? Image.asset(
                'assets/Streamnest-01.png',
                height: 32,
                fit: BoxFit.contain,
              )
            : Text(
                _screenTitles[_currentIndex],
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: AppTypography.bold,
                ),
              ),
        centerTitle: false,
        actions: [
          // Search Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),

          // Sign Up Button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textInverse,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
              ),
              child: Text(
                'Sign Up',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _screens[_currentIndex],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(icon: Icons.home, title: 'Home', index: 0),
                  _buildDrawerItem(
                    icon: Icons.rss_feed,
                    title: 'Feed',
                    index: 1,
                  ),
                  _buildDrawerItem(
                    icon: Icons.movie,
                    title: 'Movies',
                    index: 2,
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite,
                    title: 'Like',
                    index: 3,
                  ),
                  _buildDrawerItem(
                    icon: Icons.bookmark,
                    title: 'Watch List',
                    index: 4,
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    icon: Icons.search,
                    title: 'Search',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to search screen
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings screen
                    },
                  ),
                ],
              ),
            ),

            // User Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border(
                  top: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.textInverse,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: AppTypography.semiBold,
                          ),
                        ),
                        Text(
                          'Premium Member',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Logout Button
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Show logout dialog
                    },
                    icon: const Icon(Icons.logout, color: AppColors.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    int? index,
    VoidCallback? onTap,
  }) {
    final isSelected = index != null && _currentIndex == index;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.textInverse : AppColors.textSecondary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          fontWeight: isSelected
              ? AppTypography.semiBold
              : AppTypography.medium,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      onTap:
          onTap ??
          () {
            setState(() {
              _currentIndex = index!;
            });
            Navigator.pop(context);
          },
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late PageController _pageController;
  int _currentCarouselIndex = 0;
  Timer? _autoSlideTimer;
  String? _selectedCategory;
  String? _selectedValue;
  String? _selectedLabel;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize page controller for carousel
    _pageController = PageController(viewportFraction: 0.85);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations immediately
    _fadeController.forward();
    _slideController.forward();

    // Load all collections when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set loading state immediately
      context.read<MovieProvider>().setLoading(true);

      // Then load the data
      context.read<MovieProvider>().loadAllCollections();

      // Load hero filter movies for carousel
      final defaultFilterParams = {
        "ageSuitability": null,
        "availability": null,
        "duration": null,
        "genre": null,
        "languages": null,
        "rating": null,
        "releaseYear": null,
      };
      context.read<MovieProvider>().loadHeroFilterMovies(defaultFilterParams);
    });
  }

  void _onFilterSelected(String category, String label, String value) {
    setState(() {
      _selectedCategory = category;
      _selectedValue = value;
      _selectedLabel = label;
    });

    // Here you can implement the logic to filter movies based on the selected category, label and value
    print('Selected filter: $category - $label ($value)');

    // Build filter parameters for hero API call
    final filterParams = _buildFilterParams(category, value);

    // Call hero filter API with the selected filters
    context.read<MovieProvider>().loadHeroFilterMovies(filterParams);
  }

  Map<String, dynamic> _buildFilterParams(String category, String value) {
    // Start with default filter params
    final filterParams = <String, dynamic>{
      "ageSuitability": null,
      "availability": null,
      "duration": null,
      "genre": null,
      "languages": null,
      "rating": null,
      "releaseYear": null,
    };

    // Update the appropriate filter based on the selected category
    switch (category.toLowerCase()) {
      case 'agesuitability':
        filterParams['ageSuitability'] = value;
        break;
      case 'availability':
        filterParams['availability'] = value;
        break;
      case 'duration':
        filterParams['duration'] = value;
        break;
      case 'genresv1':
        filterParams['genre'] = value;
        break;
      case 'languages':
        filterParams['languages'] = value;
        break;
      case 'ratings':
        filterParams['rating'] = value;
        break;
      case 'releaseyears':
        filterParams['releaseYear'] = value;
        break;
    }

    return filterParams;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        // Show error message if there's an error
        if (movieProvider.error != null) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.error.withOpacity(0.1),
                              AppColors.error.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline,
                                size: 48,
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Oops! Something went wrong',
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: AppTypography.bold,
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              movieProvider.error!,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                movieProvider.loadAllCollections();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: AppColors.textInverse,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return CustomScrollView(
          slivers: [
            // Filter List Widget
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FilterListWidget(onFilterSelected: _onFilterSelected),
                ),
              ),
            ),

            // Featured Carousel
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildFeaturedCarousel(movieProvider),
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Show empty state if no collections
                  if (!movieProvider.isLoading &&
                      movieProvider.collections.isEmpty)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 32),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.movie,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No collections available',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check back later for new content',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._buildAllCollectionsSections(movieProvider),

                  const SizedBox(height: 100), // Bottom padding
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startAutoSlide(int totalItems) {
    _autoSlideTimer?.cancel();
    if (totalItems > 1) {
      _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (mounted) {
          if (_currentCarouselIndex < totalItems - 1) {
            _currentCarouselIndex++;
          } else {
            _currentCarouselIndex = 0;
          }
          _pageController.animateToPage(
            _currentCarouselIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  List<Widget> _buildAllCollectionsSections(MovieProvider movieProvider) {
    final List<Widget> sections = [];

    // If loading, show skeleton loaders for each collection
    if (movieProvider.isLoading) {
      // Show skeleton loaders for common collection types
      final skeletonCollections = [
        'Trending Movies',
        'Newly Added',
        'Just Released',
        'Fan Favorites',
        'Popular Shows',
        'Action Movies',
      ];

      for (int i = 0; i < skeletonCollections.length; i++) {
        sections.addAll([
          // Collection Header Skeleton
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: SectionHeader(
                  title: skeletonCollections[i].toUpperCase(),
                  subtitle: 'Loading...',
                  showSeeAll: false,
                ),
              ),
            ),
          ),

          // Movies Grid Skeleton
          Container(
            height: 300,
            margin: const EdgeInsets.only(bottom: 32),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6, // Show 6 skeleton cards
              itemBuilder: (context, index) {
                return Container(
                  width: 180,
                  margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
                  child: _buildSkeletonMovieCard(index),
                );
              },
            ),
          ),
        ]);
      }
    } else {
      // Show actual collections when data is loaded
      for (int i = 0; i < movieProvider.collectionEndpoints.length; i++) {
        final endpoint = movieProvider.collectionEndpoints[i];
        final collection = movieProvider.collections[endpoint];

        if (collection != null && collection.movies.isNotEmpty) {
          sections.addAll([
            // Collection Header with staggered animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: SectionHeader(
                    title: collection.collection.name.toUpperCase(),
                    subtitle: "",
                    // ${collection.movies.length} movies available',
                    showSeeAll: true,
                    onSeeAllTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'View all ${collection.collection.name}',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Movies Grid with enhanced styling
            Container(
              height: MediaQuery.of(context).size.height * 0.24,
              margin: const EdgeInsets.only(bottom: 32),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: collection.movies.length,
                itemBuilder: (context, index) {
                  final movie = collection.movies[index];
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.only(
                      right: 16,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: _buildEnhancedMovieCard(movie, index),
                  );
                },
              ),
            ),
          ]);
        }
      }
    }

    return sections;
  }

  Widget _buildSkeletonMovieCard(int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.card,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skeleton Poster with shimmer
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Shimmer effect
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.textSecondary.withOpacity(0.1),
                                    AppColors.textSecondary.withOpacity(0.3),
                                    AppColors.textSecondary.withOpacity(0.1),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // Loading indicator
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Loading...',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Skeleton Info
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Skeleton Title
                          Container(
                            height: 16,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 12,
                            width: 120,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedMovieCard(Movie movie, int index) {
    // Construct full image URL if it's a relative path
    final imageUrl = movie.posterPath.startsWith('http')
        ? movie.posterPath
        : 'https://image.tmdb.org/t/p/w500${movie.posterPath}';

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
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
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.card,
                            AppColors.card.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Movie Poster with overlay
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                // Background Image
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                  ),
                                  child: movie.posterPath.isNotEmpty
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: AppColors.card,
                                                  child: const Icon(
                                                    Icons.movie,
                                                    size: 40,
                                                    color:
                                                        AppColors.textTertiary,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          color: AppColors.card,
                                          child: const Icon(
                                            Icons.movie,
                                            size: 40,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                ),

                                // Gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),

                                // Rating badge
                                if (movie.rating != null)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 12,
                                            color: AppColors.textInverse,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            movie.rating.toString(),
                                            style: AppTypography.labelSmall
                                                .copyWith(
                                                  color: AppColors.textInverse,
                                                  fontWeight:
                                                      AppTypography.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Play button overlay
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black38,

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: AppColors.textInverse,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Movie Info
                          // Expanded(
                          //   flex: 1,
                          //   child: Container(
                          //     padding: const EdgeInsets.all(12),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           movie.title,
                          //           style: AppTypography.labelMedium.copyWith(
                          //             fontWeight: AppTypography.semiBold,
                          //           ),
                          //           maxLines: 2,
                          //           overflow: TextOverflow.ellipsis,
                          //         ),
                          //         const SizedBox(height: 4),
                          //         Row(
                          //           children: [
                          //             Icon(
                          //               Icons.access_time,
                          //               size: 12,
                          //               color: AppColors.textSecondary,
                          //             ),
                          //             const SizedBox(width: 4),
                          //             Text(
                          //               '${movie.duration} min',
                          //               style: AppTypography.labelSmall
                          //                   .copyWith(
                          //                     color: AppColors.textSecondary,
                          //                   ),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedCarousel(MovieProvider movieProvider) {
    // Show loading state for carousel
    if (movieProvider.isLoadingFeatured) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical:
              MediaQuery.of(context).size.height * 0.02, // 2% of screen height
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loading skeleton
            Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.6, // 60% of screen height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.card,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Use hero filter movies from API, fallback to featured movies if empty
    List<Movie> featuredMovies = movieProvider.heroFilterMovies;

    if (featuredMovies.isEmpty) {
      // Fallback to featured movies
      featuredMovies = movieProvider.featuredMovies;
    }

    if (featuredMovies.isEmpty && movieProvider.collections.isNotEmpty) {
      // Fallback to first collection's movies
      featuredMovies = movieProvider.collections.values.first.movies
          .take(5)
          .toList();
    }

    if (featuredMovies.isEmpty) {
      return const SizedBox.shrink();
    }

    // Start auto-sliding when carousel is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlide(featuredMovies.length);
    });

    return Container(
      // margin: EdgeInsets.symmetric(
      //   horizontal: 16,
      //   vertical:
      //       MediaQuery.of(context).size.height * 0.02, // 2% of screen height
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel with navigation arrows
          Container(
            height:
                MediaQuery.of(context).size.height *
                0.78, // 78% of screen height
            //  padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: [
                // PageView with auto-sliding
                PageView.builder(
                  controller: _pageController,
                  itemCount: featuredMovies.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentCarouselIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final movie = featuredMovies[index];
                    return _buildCarouselItem(movie);
                  },
                ),

                // Left Arrow Button
                if (_currentCarouselIndex > 0)
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                // Right Arrow Button
                if (_currentCarouselIndex < featuredMovies.length - 1)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(
                          Icons.chevron_right,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(Movie movie) {
    final imageUrl = movie.posterPath.startsWith('http')
        ? movie.posterPath
        : 'https://image.tmdb.org/t/p/w500${movie.posterPath}';

    // Calculate responsive margin based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth < 360
        ? 2.0
        : screenWidth < 480
        ? 4.0
        : screenWidth < 600
        ? 6.0
        : 10.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: buildMovieTab(movie, false, null, context),
        ),
      ),
    );
  }
}
