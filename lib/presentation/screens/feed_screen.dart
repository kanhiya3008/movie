import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamnest/core/constants/font_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../widgets/section_header.dart';
import '../providers/movie_provider.dart';
import 'widgets/heroidgets.dart';
import '../../data/models/movie.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    // Call loadFeedMovies with default/empty filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = context.read<MovieProvider>();
      movieProvider.loadFeedMovies({
        "availability": null,
        "genre": [],
        "releaseYear": "",
        "languages": [],
        "rating": "",
        "duration": "",
        "ageSuitability": [],
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.isLoadingFeed) {
          return const Center(child: CircularProgressIndicator());
        }
        if (movieProvider.feedError != null) {
          return Center(
            child: Text(
              movieProvider.feedError!,
              style: AppTypography.titleMedium.copyWith(color: AppColors.error),
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            // Content
            SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Feed Items
                  ...movieProvider.feedItems.map((item) {
                    final movie = item.movie;
                    final title = item.title;
                    final content = item.content;
                    final authors = item.authors;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Container(
                        color: AppColors.herobackground,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (authors.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      // First author avatar
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundImage: NetworkImage(
                                          authors[0].avatarUrl,
                                        ),
                                        backgroundColor: AppColors.primary
                                            .withOpacity(0.1),
                                      ),
                                      if (authors.length > 1) ...[
                                        const SizedBox(width: 4),
                                        Text(
                                          '+${authors.length - 1}',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontConstants.bold,
                                              ),
                                        ),
                                      ],
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (title.isNotEmpty)
                                            Text(
                                              title,
                                              style: AppTypography.titleSmall
                                                  .copyWith(
                                                    fontWeight:
                                                        FontConstants.bold,
                                                  ),
                                            ),
                                          if (content.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: Text(
                                                content,
                                                style: AppTypography.labelSmall
                                                    .copyWith(
                                                      fontWeight: FontConstants
                                                          .semiBold,
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              if (movie != null)
                                buildMovieTab(movie, false, null, context),
                              if (movie == null)
                                Text(
                                  'No movie data',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (movieProvider.feedMovies.isEmpty)
                    Center(
                      child: Text(
                        'No feed movies found.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 100), // Bottom padding
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
