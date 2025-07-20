import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamnest/core/utils/constFunction.dart';
import 'package:streamnest/presentation/screens/widgets/heroidgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../data/models/movie.dart';
import '../providers/movie_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/movie_card.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    // Load detailed movie information and additional data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = context.read<MovieProvider>();

      // Load detailed movie information using slug
      if (widget.movie.slug.isNotEmpty) {
        movieProvider.loadMovieDetails(widget.movie.slug);
      }

      // Load similar movies and cast using movie ID
      movieProvider.loadSimilarMovies(widget.movie.id.toString());
      movieProvider.loadMovieCast(widget.movie.id.toString());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        // Use detailed movie data if available, otherwise fall back to passed movie
        final movie = movieProvider.movieDetails ?? widget.movie;
        final isLoadingDetails = movieProvider.isLoadingMovieDetails;
        final detailsError = movieProvider.movieDetailsError;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "StremNest",
              style: AppTypography.titleMedium.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // Toggle favorite
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // Toggle watchlist
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true, // Allow tabs to scroll if needed
              tabs: const [
                Tab(text: 'Movie'),
                Tab(text: 'Cast'),
                Tab(text: "Friend's Rating"),
                Tab(text: 'Similar Movies'),
              ],
              labelStyle: AppTypography.titleSmall.copyWith(
                fontWeight: AppTypography.semiBold,
              ),

              unselectedLabelStyle: AppTypography.labelSmall,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              tabAlignment: TabAlignment.center, // Center align tabs
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width < 360
                      ? 12.0
                      : MediaQuery.of(context).size.width < 480
                      ? 14.0
                      : 16.0,
                ),
                child: buildMovieTab(
                  movie,
                  isLoadingDetails,
                  detailsError,
                  context,
                ),
              ),
              buildCastTab(movie, isLoadingDetails, detailsError, context),
              buildFriendsRatingTab(),
              buildSimilarMoviesTab(
                movie,
                isLoadingDetails,
                detailsError,
                context,
              ),
            ],
          ),
        );
      },
    );
  }

  // YouTube Player
  //                 Expanded(
  //                   child: Container(
  //                     decoration: const BoxDecoration(
  //                       color: Colors.black,
  //                       borderRadius: BorderRadius.vertical(
  //                         bottom: Radius.circular(16),
  //                       ),
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: const BorderRadius.vertical(
  //                         bottom: Radius.circular(16),
  //                       ),
  //                       child: WebViewWidget(controller: controller),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
}

class YouTubeTrailerDialog extends StatefulWidget {
  final String trailerYtId;

  const YouTubeTrailerDialog({super.key, required this.trailerYtId});

  @override
  State<YouTubeTrailerDialog> createState() => _YouTubeTrailerDialogState();
}

class _YouTubeTrailerDialogState extends State<YouTubeTrailerDialog> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadHtmlString(_getYouTubeEmbedHTML(widget.trailerYtId));
  }

  String _getYouTubeEmbedHTML(String videoId) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #000;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }
        .video-container {
            position: relative;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        iframe {
            width: 100%;
            height: 100%;
            border: none;
            max-width: 100vw;
            max-height: 100vh;
        }
    </style>
</head>
<body>
    <div class="video-container">
        <iframe 
            src="https://www.youtube.com/embed/$videoId?autoplay=1&rel=0&modestbranding=1&showinfo=0&controls=1&fs=1"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
            allowfullscreen>
        </iframe>
    </div>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Text(
                    'Movie Trailer',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.card,
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // YouTube Player
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      WebViewWidget(controller: _controller),
                      if (_isLoading)
                        Container(
                          color: Colors.black,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading trailer...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
            ),
          ],
        ),
      ),
    );
  }
}
