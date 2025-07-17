import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamnest/core/utils/constFunction.dart';
import 'package:streamnest/data/models/movie.dart';
import 'package:streamnest/presentation/providers/movie_provider.dart';
import 'package:streamnest/presentation/theme/app_colors.dart';
import 'package:streamnest/presentation/theme/app_typography.dart';
import 'package:streamnest/presentation/widgets/movie_card.dart';
import 'package:webview_flutter/webview_flutter.dart';

void showYoutubePopup1(BuildContext context, String videoId) {
  String id = extractYoutubeId(videoId);
  final String youtubeUrl =
      'https://www.youtube.com/embed/$id?autoplay=1&mute=1';
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(youtubeUrl));

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Official Trailer'),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 300,
          child: WebViewWidget(controller: controller),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );
    },
  );
}

Widget buildMovieTab(
  Movie movie,
  bool isLoading,
  String? error,
  BuildContext context,
) {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (error != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load movie details',
            style: AppTypography.titleMedium.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Section: Image and Content
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Movie Poster - Responsive sizing
                Container(
                  width: MediaQuery.of(context).size.width < 360
                      ? 100
                      : MediaQuery.of(context).size.width < 480
                      ? 110
                      : 120,
                  height: MediaQuery.of(context).size.width < 360
                      ? 150
                      : MediaQuery.of(context).size.width < 480
                      ? 165
                      : 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      movie.posterPath.startsWith('http')
                          ? movie.posterPath
                          : 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.card,
                          child: const Icon(
                            Icons.movie,
                            size: 40,
                            color: AppColors.textTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width < 360 ? 6 : 8,
                ),

                // Right Side: Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First Row: Movie Name and Login Button
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: AppTypography.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width < 360
                                ? 8
                                : 12,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle login to find match
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login to find % match'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryLight,
                                foregroundColor: AppColors.textInverse,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,

                                'Login to Find % Match',
                                style: AppTypography.labelSmall.copyWith(
                                  fontWeight: AppTypography.semiBold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Rating Value with Icon
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '8.5',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: AppTypography.semiBold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rating',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Star Rating View
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star : Icons.star_border,
                            size: 20,
                            color: index < 4
                                ? Colors.amber
                                : AppColors.textSecondary,
                          );
                        }),
                      ),

                      const SizedBox(height: 8),

                      // Three Action Containers
                      Row(
                        children: [
                          // Seen Container
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 12,
                                    color: AppColors.textPrimary,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Seen',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: AppTypography.medium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width < 360
                                ? 4
                                : 8,
                          ),
                          // Interest Container
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 12,
                                    color: AppColors.textPrimary,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Interest',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: AppTypography.medium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width < 360
                                ? 4
                                : 8,
                          ),
                          // Watch List Container
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.bookmark_border,
                                    size: 12,
                                    color: AppColors.textPrimary,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Watch List',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: AppTypography.medium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Rating Section
                      if (movie.rating != null) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: AppColors.textInverse,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    movie.rating.toString(),
                                    style: AppTypography.labelMedium.copyWith(
                                      color: AppColors.textInverse,
                                      fontWeight: AppTypography.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'User Rating',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle watch trailer
                      if (movie.trailerYtId != null &&
                          movie.trailerYtId!.isNotEmpty) {
                        showYoutubePopup1(context, movie.trailerYtId!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Trailer not available for this movie',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow, size: 20),
                    label: Text(
                      'Watch Trailer',
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: AppColors.textInverse,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width < 360 ? 8 : 12,
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle see similar
                      // _tabController.animateTo(
                      //   3,
                      // ); // Switch to Similar Movies tab
                    },
                    icon: const Icon(Icons.movie, size: 20),
                    label: Text(
                      'See Similar',
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Cast Preview - Stacked Layout
        if (movie.cast.isNotEmpty) ...[
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 12 : 16),
          Text(
            'Cast',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: AppTypography.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 6 : 8),

          SizedBox(
            height: 80,
            child: Stack(
              children: [
                // First 3 cast members
                ...movie.cast.take(3).toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final castMember = entry.value;
                  final screenWidth = MediaQuery.of(context).size.width;
                  final avatarSpacing = screenWidth < 360
                      ? 28.0
                      : screenWidth < 480
                      ? 32.0
                      : 35.0;
                  final offset = index * avatarSpacing;

                  return Positioned(
                    left: offset,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width < 360
                            ? 25
                            : MediaQuery.of(context).size.width < 480
                            ? 28
                            : 30,
                        backgroundColor: AppColors.primaryLight,
                        child: castMember.person.profilePath != null
                            ? ClipOval(
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/original${castMember.person.profilePath}",
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width < 360
                                      ? 50
                                      : MediaQuery.of(context).size.width < 480
                                      ? 56
                                      : 60,
                                  height:
                                      MediaQuery.of(context).size.width < 360
                                      ? 50
                                      : MediaQuery.of(context).size.width < 480
                                      ? 56
                                      : 60,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      castMember.person.name.isNotEmpty
                                          ? castMember.person.name[0]
                                                .toUpperCase()
                                          : '?',
                                      style: AppTypography.labelMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: AppTypography.semiBold,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Text(
                                castMember.person.name.isNotEmpty
                                    ? castMember.person.name[0].toUpperCase()
                                    : '?',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: AppTypography.semiBold,
                                ),
                              ),
                      ),
                    ),
                  );
                }),

                // +X remaining indicator
                if (movie.cast.length > 3)
                  Positioned(
                    left: MediaQuery.of(context).size.width < 360
                        ? 84.0
                        : MediaQuery.of(context).size.width < 480
                        ? 96.0
                        : 105.0, // Responsive position
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width < 360
                            ? 25
                            : MediaQuery.of(context).size.width < 480
                            ? 28
                            : 30,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          '+${movie.cast.length - 3}',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          //  const SizedBox(height: 8),
          // Text(
          //   '${movie.cast.length} cast members',
          //   style: AppTypography.labelSmall.copyWith(
          //     color: AppColors.textSecondary,
          //   ),
          // ),
        ],

        SizedBox(height: MediaQuery.of(context).size.width < 360 ? 12 : 16),

        // Description
        Text(
          'Why you might like this',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: AppTypography.bold,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.width < 360 ? 6 : 8),
        buildDescriptionSection(movie.description),

        SizedBox(height: MediaQuery.of(context).size.width < 360 ? 16 : 24),
        Text(
          'Synopsis',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: AppTypography.bold,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.width < 360 ? 6 : 8),
        buildDescriptionSection(movie.description),

        // // Genres
        // if (movie.collections.isNotEmpty) ...[
        //   Text(
        //     'Genres',
        //     style: AppTypography.titleMedium.copyWith(
        //       fontWeight: AppTypography.bold,
        //     ),
        //   ),

        //   const SizedBox(height: 8),
        //   Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children: movie.collections
        //         .take(5)
        //         .map(
        //           (collection) => Container(
        //             padding: const EdgeInsets.symmetric(
        //               horizontal: 12,
        //               vertical: 6,
        //             ),
        //             decoration: BoxDecoration(
        //               color: AppColors.card,
        //               borderRadius: BorderRadius.circular(20),
        //               border: Border.all(
        //                 color: AppColors.primary.withOpacity(0.3),
        //               ),
        //             ),
        //             child: Text(
        //               collection.movieId.toString(),
        //               style: AppTypography.labelSmall.copyWith(
        //                 color: AppColors.primary,
        //               ),
        //             ),
        //           ),
        //         )
        //         .toList(),
        //   ),
        // ],
        SizedBox(height: MediaQuery.of(context).size.width < 360 ? 16 : 24),

        //  const SizedBox(height: 24),

        // // Additional Details
        // if (movie.audienceRating.isNotEmpty) ...[
        //   Text(
        //     'Audience Rating',
        //     style: AppTypography.titleMedium.copyWith(
        //       fontWeight: AppTypography.bold,
        //     ),
        //   ),
        //   const SizedBox(height: 8),
        //   Container(
        //     padding: const EdgeInsets.all(12),
        //     decoration: BoxDecoration(
        //       color: AppColors.card,
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     child: Text(
        //       movie.audienceRating,
        //       style: AppTypography.bodyMedium.copyWith(
        //         color: AppColors.textSecondary,
        //       ),
        //     ),
        //   ),
        // ],

        // const SizedBox(height: 24),

        // // Streaming Platforms
        // if (movie.streamingPlatforms.isNotEmpty) ...[
        //   Text(
        //     'Available On',
        //     style: AppTypography.titleMedium.copyWith(
        //       fontWeight: AppTypography.bold,
        //     ),
        //   ),
        //   const SizedBox(height: 8),
        //   Wrap(
        //     spacing: 8,
        //     runSpacing: 8,
        //     children: movie.streamingPlatforms
        //         .take(5)
        //         .map(
        //           (platform) => Container(
        //             padding: const EdgeInsets.symmetric(
        //               horizontal: 12,
        //               vertical: 6,
        //             ),
        //             decoration: BoxDecoration(
        //               color: AppColors.accent.withOpacity(0.1),
        //               borderRadius: BorderRadius.circular(20),
        //               border: Border.all(
        //                 color: AppColors.accent.withOpacity(0.3),
        //               ),
        //             ),
        //             child: Text(
        //               platform.platform?.name ?? 'Unknown',
        //               style: AppTypography.labelSmall.copyWith(
        //                 color: AppColors.accent,
        //               ),
        //             ),
        //           ),
        //         )
        //         .toList(),
        //   ),
        // ],
      ],
    ),
  );
}

Widget buildDetailItem(String label, String value, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label: ',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
          fontWeight: AppTypography.semiBold,
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Widget buildCastTab() {
  return Consumer<MovieProvider>(
    builder: (context, movieProvider, child) {
      if (movieProvider.isLoadingCast) {
        return const Center(child: CircularProgressIndicator());
      }

      if (movieProvider.castError != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Failed to load cast',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movieProvider.castError!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      final cast = movieProvider.movieCast;
      if (cast.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 48,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                'No cast information available',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cast Header
            Text(
              'Cast & Crew',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${cast.length} cast members',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Cast List
            ...cast.asMap().entries.map((entry) {
              final index = entry.key;
              final castMember = entry.value;
              final isEven = index % 2 == 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isEven
                      ? AppColors.card
                      : AppColors.card.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: castMember.person.profilePath != null
                            ? Image.network(
                                castMember.person.profilePath!.startsWith(
                                      'http',
                                    )
                                    ? castMember.person.profilePath!
                                    : 'https://image.tmdb.org/t/p/w200${castMember.person.profilePath}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.primary.withOpacity(0.1),
                                    child: Center(
                                      child: Text(
                                        castMember.person.name.isNotEmpty
                                            ? castMember.person.name[0]
                                                  .toUpperCase()
                                            : '?',
                                        style: AppTypography.titleLarge
                                            .copyWith(
                                              color: AppColors.primary,
                                              fontWeight: AppTypography.bold,
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: Center(
                                  child: Text(
                                    castMember.person.name.isNotEmpty
                                        ? castMember.person.name[0]
                                              .toUpperCase()
                                        : '?',
                                    style: AppTypography.titleLarge.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: AppTypography.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Cast Member Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            castMember.person.name,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: AppTypography.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Character Name
                          if (castMember.character.isNotEmpty) ...[
                            Text(
                              'as ${castMember.character}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: AppTypography.semiBold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                          ],

                          // Additional Details
                          Row(
                            children: [
                              // Department
                              if (castMember
                                  .person
                                  .knownForDepartment
                                  .isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    castMember.person.knownForDepartment,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: AppTypography.semiBold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],

                              // Order (if available)
                              if (castMember.order > 0) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Order: ${castMember.order}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: AppTypography.semiBold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Popularity (if available)
                          if (castMember.person.popularity > 0) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Popularity: ${castMember.person.popularity.toStringAsFixed(1)}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Action Button
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle cast member actions
                        switch (value) {
                          case 'view_profile':
                            // Navigate to actor profile
                            break;
                          case 'other_movies':
                            // Show other movies by this actor
                            break;
                          case 'add_favorite':
                            // Add to favorite actors
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view_profile',
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 8),
                              Text('View Profile'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'other_movies',
                          child: Row(
                            children: [
                              Icon(Icons.movie),
                              SizedBox(width: 8),
                              Text('Other Movies'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'add_favorite',
                          child: Row(
                            children: [
                              Icon(Icons.favorite_border),
                              SizedBox(width: 8),
                              Text('Add to Favorites'),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 32),

            // Cast Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cast Summary',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: AppTypography.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This movie features ${cast.length} talented cast members. The cast includes both established actors and rising stars, bringing their unique talents to create an unforgettable cinematic experience.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildFriendsRatingTab() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.people, size: 64, color: AppColors.textTertiary),
        const SizedBox(height: 16),
        Text(
          'Friend Ratings',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'See what your friends think about this movie',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Coming Soon',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Friend rating feature will be available in the next update',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildSimilarMoviesTab() {
  return Consumer<MovieProvider>(
    builder: (context, movieProvider, child) {
      if (movieProvider.isLoadingSimilar) {
        return const Center(child: CircularProgressIndicator());
      }

      if (movieProvider.similarError != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Failed to load similar movies',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movieProvider.similarError!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      final similarMovies = movieProvider.similarMovies;
      if (similarMovies.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie_outlined,
                size: 48,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                'No similar movies found',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: similarMovies.length,
        itemBuilder: (context, index) {
          final movie = similarMovies[index];
          return MovieCard(
            title: movie.title,
            posterPath: movie.posterPath.startsWith('http')
                ? movie.posterPath
                : 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            rating: movie.rating is double
                ? movie.rating as double
                : double.tryParse(movie.rating.toString()) ?? 0.0,
            movie: movie,
          );
        },
      );
    },
  );
}

Widget buildDescriptionSection(String description) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final textSpan = TextSpan(
        text: description,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: 3,
      );

      textPainter.layout(maxWidth: constraints.maxWidth);

      final isTextOverflowing = textPainter.didExceedMaxLines;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (isTextOverflowing) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => showFullDescription(description, context),
                child: Text(
                  'Read More',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    },
  );
}

void showFullDescription(String description, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Synopsis',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: AppTypography.bold,
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
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                description,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
