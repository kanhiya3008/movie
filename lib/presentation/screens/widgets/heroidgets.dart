import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamnest/core/utils/constFunction.dart';
import 'package:streamnest/data/models/movie.dart';
import 'package:streamnest/presentation/providers/movie_provider.dart';
import 'package:streamnest/presentation/screens/heroShimmerEffect.dart';
import 'package:streamnest/presentation/theme/app_colors.dart';
import 'package:streamnest/presentation/theme/app_typography.dart';
import 'package:streamnest/presentation/widgets/movie_card.dart';
import 'package:streamnest/presentation/widgets/shimmer_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:streamnest/core/constants/font_constants.dart';

void showYoutubePopup1(BuildContext context, String videoId) {
  String id = extractYoutubeId(videoId);

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadHtmlString(_getYouTubeEmbedHTML(id));

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
            src="https://www.youtube.com/embed/$videoId?autoplay=1&mute=1&rel=0&modestbranding=1&showinfo=0&controls=1&fs=1"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
            allowfullscreen>
        </iframe>
    </div>
</body>
</html>
    ''';
}

Widget buildMovieTab(
  Movie movie,
  bool isLoading,
  String? error,
  BuildContext context,
) {
  final ScrollController streamingScrollController = ScrollController();
  if (isLoading) {
    return buildMovieTabShimmer(context);
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
    child: Container(
      // color: AppColors.herobackground,
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
                                  fontWeight: FontConstants.bold,
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
                                  backgroundColor: AppColors.containerColor,
                                  foregroundColor: AppColors.textInverse,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,

                                  'Login to Find % Match',
                                  style: AppTypography.labelSmall.copyWith(
                                    fontWeight: FontConstants.semiBold,
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
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.people,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${movie.audienceRating}',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontConstants.semiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Star Rating View
                        Row(
                          children: List.generate(5, (index) {
                            final ratingOutOf10 =
                                double.tryParse(movie.audienceRating) ?? 0.0;
                            final ratingOutOf5 =
                                ratingOutOf10 /
                                2; // Convert from 10-point to 5-star scale
                            final filledStars = ratingOutOf5.floor();
                            final hasHalfStar =
                                ratingOutOf5 - filledStars >= 0.5;

                            IconData starIcon;
                            Color starColor;

                            if (index < filledStars) {
                              // Fully filled star
                              starIcon = Icons.star;
                              starColor = Colors.amber;
                            } else if (index == filledStars && hasHalfStar) {
                              // Half filled star
                              starIcon = Icons.star_half;
                              starColor = Colors.amber;
                            } else {
                              // Empty star
                              starIcon = Icons.star_border;
                              starColor = AppColors.textSecondary;
                            }

                            return Icon(starIcon, size: 20, color: starColor);
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
                                  color: AppColors.containerColor,
                                  borderRadius: BorderRadius.circular(2),
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
                                  color: AppColors.containerColor,
                                  borderRadius: BorderRadius.circular(2),
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
                                  color: AppColors.containerColor,
                                  borderRadius: BorderRadius.circular(2),
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                      label: Text(
                        'Watch Trailer',
                        style: AppTypography.bodyMedium1.copyWith(
                          fontWeight: FontConstants.semiBold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff4d7fff),
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
                      label: Text(
                        'See Similar',
                        style: AppTypography.bodyMedium1.copyWith(
                          fontWeight: FontConstants.semiBold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.containerColor,
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
          // Cast Preview and Streaming OTT - Row Layout
          if (movie.cast.isNotEmpty ||
              (movie.streamingPlatforms ?? []).isNotEmpty) ...[
            SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cast Preview - Left Side
                if (movie.cast.isNotEmpty) ...[
                  GestureDetector(
                    onTap: () {
                      _showCastBottomSheet(context, movie);
                    },
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width / 2.4,

                      child: Stack(
                        children: [
                          // First 3 cast members
                          ...movie.cast.take(3).toList().asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final castMember = entry.value;
                            final screenWidth = MediaQuery.of(
                              context,
                            ).size.width;
                            final avatarSpacing = screenWidth < 360
                                ? 32.0
                                : screenWidth < 480
                                ? 36.0
                                : 40.0;
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
                                  radius:
                                      MediaQuery.of(context).size.width < 360
                                      ? 25
                                      : MediaQuery.of(context).size.width < 480
                                      ? 28
                                      : 32,
                                  backgroundColor: AppColors.primaryLight,
                                  child: castMember.person.profilePath != null
                                      ? ClipOval(
                                          child: Image.network(
                                            "https://image.tmdb.org/t/p/original${castMember.person.profilePath}",
                                            fit: BoxFit.cover,
                                            width:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width <
                                                    360
                                                ? 50
                                                : MediaQuery.of(
                                                        context,
                                                      ).size.width <
                                                      480
                                                ? 56
                                                : 64,
                                            height:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width <
                                                    360
                                                ? 50
                                                : MediaQuery.of(
                                                        context,
                                                      ).size.width <
                                                      480
                                                ? 56
                                                : 64,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Text(
                                                    castMember
                                                            .person
                                                            .name
                                                            .isNotEmpty
                                                        ? castMember
                                                              .person
                                                              .name[0]
                                                              .toUpperCase()
                                                        : '?',
                                                    style: AppTypography
                                                        .labelMedium
                                                        .copyWith(
                                                          color: AppColors
                                                              .textPrimary,
                                                          fontWeight:
                                                              FontConstants
                                                                  .semiBold,
                                                        ),
                                                  );
                                                },
                                          ),
                                        )
                                      : Text(
                                          castMember.person.name.isNotEmpty
                                              ? castMember.person.name[0]
                                                    .toUpperCase()
                                              : '?',
                                          style: AppTypography.labelMedium
                                              .copyWith(
                                                color: AppColors.textPrimary,
                                                fontWeight:
                                                    FontConstants.semiBold,
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
                                  ? 96.0
                                  : MediaQuery.of(context).size.width < 480
                                  ? 108.0
                                  : 120.0, // Responsive position
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.background,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width < 360
                                      ? 25
                                      : MediaQuery.of(context).size.width < 480
                                      ? 28
                                      : 32,
                                  backgroundColor: AppColors.primaryLight,
                                  child: Text(
                                    '+${movie.cast.length - 3}',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontConstants.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Streaming OTT Platforms - Right Side
                if ((movie.streamingPlatforms ?? []).isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Stack(
                        children: [
                          ListView.builder(
                            key: const PageStorageKey('streaming_platforms'),
                            controller: streamingScrollController,
                            scrollDirection: Axis.horizontal,
                            reverse: true, // Show from right to left
                            itemCount: (movie.streamingPlatforms ?? []).length,
                            itemBuilder: (context, index) {
                              final platform =
                                  (movie.streamingPlatforms ?? [])[index];
                              return Container(
                                width: 50,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  children: [
                                    // Platform Icon
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(
                                            0.3,
                                          ),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child:
                                            platform.platform?.logo != null &&
                                                platform
                                                    .platform!
                                                    .logo
                                                    .isNotEmpty
                                            ? Image.network(
                                                platform.platform!.logo,
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        color: AppColors.primary
                                                            .withOpacity(0.1),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.tv,
                                                            size: 20,
                                                            color: AppColors
                                                                .primary,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                              )
                                            : Container(
                                                color: AppColors.primary
                                                    .withOpacity(0.1),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.tv,
                                                    size: 20,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Platform Type Text
                                    Text(
                                      (platform.type ?? '').isNotEmpty
                                          ? '${platform.type![0].toUpperCase()}${platform.type!.substring(1).toLowerCase()}'
                                          : '',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Arrow Button - Right Side
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 30,

                              child: Center(
                                child: Container(
                                  width: 24,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // Scroll to the left (show more platforms since ListView is reversed)
                                      streamingScrollController.animateTo(
                                        streamingScrollController.offset - 100,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],

          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 12 : 16),

          // Description
          Text(
            'Why you might like this',
            style: AppTypography.bodyMedium1.copyWith(
              fontWeight: FontConstants.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 6 : 8),
          buildDescriptionSection(movie.description),

          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 16 : 24),
          Text(
            'Synopsis',
            style: AppTypography.bodyMedium1.copyWith(
              fontWeight: FontConstants.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 6 : 8),
          buildDescriptionSection(movie.description),

          // // Genres
          // if (movie.collections.isNotEmpty) ...[
          //   Text(
          //     'Genres',
          //     style: AppTypography.titleMedium.copyWith(
          //       fontWeight: FontConstants.bold,
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
          //       fontWeight: FontConstants.bold,
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
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
          const SizedBox(height: 24),
        ],
      ),
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
          fontWeight: FontConstants.semiBold,
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

Widget buildCastTab(
  Movie movie,
  bool isLoading,
  String? error,
  BuildContext context,
) {
  // Use cast data from the movie object
  final cast = movie.cast;

  if (cast.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 48, color: AppColors.textTertiary),
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
          'Cast',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontConstants.bold,
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

        // Cast Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: cast.length,
          itemBuilder: (context, index) {
            final castMember = cast[index];

            return Column(
              children: [
                // Profile Image - Round Circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: castMember.person.profilePath != null
                        ? Image.network(
                            castMember.person.profilePath!.startsWith('http')
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
                                    style: AppTypography.titleLarge.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontConstants.bold,
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
                                    ? castMember.person.name[0].toUpperCase()
                                    : '?',
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontConstants.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),

                // Cast Member Name
                Text(
                  castMember.person.name,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontConstants.semiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                // Character Name
                if (castMember.character.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'as ${castMember.character}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            );
          },
        ),

        const SizedBox(height: 32),

        // Crew Section
        Text(
          'Crew Highlights',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontConstants.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${movie.crew.length} crew members',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Crew List
        ...movie.crew.map((crewMember) {
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            // padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  crewMember.job + ":",
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  crewMember.person.name,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}

// Shimmer effect for cast tab loading
Widget _buildCastTabShimmer(BuildContext context) {
  return SingleChildScrollView(
    child: ShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cast Header
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.card.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.card.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),

          // Cast List
          ...List.generate(
            3,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.7),
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
                      color: AppColors.card.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Cast Member Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Container(
                          height: 20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.card.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.card.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            2,
                            (index) => Container(
                              margin: EdgeInsets.only(right: index < 1 ? 8 : 0),
                              width: 80,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColors.card.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            2,
                            (index) => Container(
                              margin: EdgeInsets.only(right: index < 1 ? 8 : 0),
                              width: 100,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColors.card.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
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
            ),
          ),

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
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.card.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.card.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
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
            fontWeight: FontConstants.bold,
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
                  fontWeight: FontConstants.semiBold,
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

Widget buildSimilarMoviesTab(
  Movie movie,
  bool isLoading,
  String? error,
  BuildContext context,
) {
  // Trigger API call when tab is accessed
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final movieProvider = context.read<MovieProvider>();
    if (movieProvider.similarMovies.isEmpty &&
        !movieProvider.isLoadingSimilar) {
      movieProvider.loadSimilarMovies(movie.id.toString());
    }
  });

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
          crossAxisCount: 3,
          childAspectRatio: 0.6,
          crossAxisSpacing: 12,
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
        text:
            description ??
            "Log in to see why our AI thinks you'll love this, based on your past movie choices and preferences.",
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
          color: AppColors.heroDescription,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: AppTypography.bodyMedium1.copyWith(
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
                    fontWeight: FontConstants.semiBold,
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
                    fontWeight: FontConstants.bold,
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

void _showCastBottomSheet(BuildContext context, Movie movie) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                  'Cast & Crew',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontConstants.bold,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cast Section
                  if (movie.cast.isNotEmpty) ...[
                    Text(
                      'Cast',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontConstants.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...movie.cast
                        .map(
                          (castMember) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Cast member image
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryLight,
                                  ),
                                  child: ClipOval(
                                    child: castMember.person.profilePath != null
                                        ? Image.network(
                                            castMember.person.profilePath!
                                                    .startsWith('http')
                                                ? castMember.person.profilePath!
                                                : 'https://image.tmdb.org/t/p/w200${castMember.person.profilePath}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Center(
                                                    child: Text(
                                                      castMember
                                                              .person
                                                              .name
                                                              .isNotEmpty
                                                          ? castMember
                                                                .person
                                                                .name[0]
                                                                .toUpperCase()
                                                          : '?',
                                                      style: AppTypography
                                                          .titleMedium
                                                          .copyWith(
                                                            color: AppColors
                                                                .textPrimary,
                                                            fontWeight:
                                                                FontConstants
                                                                    .bold,
                                                          ),
                                                    ),
                                                  );
                                                },
                                          )
                                        : Center(
                                            child: Text(
                                              castMember.person.name.isNotEmpty
                                                  ? castMember.person.name[0]
                                                        .toUpperCase()
                                                  : '?',
                                              style: AppTypography.titleMedium
                                                  .copyWith(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontWeight:
                                                        FontConstants.bold,
                                                  ),
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Cast member details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        castMember.person.name,
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              fontWeight:
                                                  FontConstants.semiBold,
                                            ),
                                      ),
                                      if (castMember.character.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'as ${castMember.character}',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    const SizedBox(height: 24),
                  ],

                  // Crew Section
                  if (movie.crew.isNotEmpty) ...[
                    Text(
                      'Crew',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontConstants.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...movie.crew
                        .map(
                          (crewMember) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Crew member image
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryLight,
                                  ),
                                  child: ClipOval(
                                    child: crewMember.person.profilePath != null
                                        ? Image.network(
                                            crewMember.person.profilePath!
                                                    .startsWith('http')
                                                ? crewMember.person.profilePath!
                                                : 'https://image.tmdb.org/t/p/w200${crewMember.person.profilePath}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Center(
                                                    child: Text(
                                                      crewMember
                                                              .person
                                                              .name
                                                              .isNotEmpty
                                                          ? crewMember
                                                                .person
                                                                .name[0]
                                                                .toUpperCase()
                                                          : '?',
                                                      style: AppTypography
                                                          .bodyMedium
                                                          .copyWith(
                                                            color: AppColors
                                                                .textPrimary,
                                                            fontWeight:
                                                                FontConstants
                                                                    .bold,
                                                          ),
                                                    ),
                                                  );
                                                },
                                          )
                                        : Center(
                                            child: Text(
                                              crewMember.person.name.isNotEmpty
                                                  ? crewMember.person.name[0]
                                                        .toUpperCase()
                                                  : '?',
                                              style: AppTypography.bodyMedium
                                                  .copyWith(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontWeight:
                                                        FontConstants.bold,
                                                  ),
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Crew member details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        crewMember.person.name,
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              fontWeight:
                                                  FontConstants.semiBold,
                                            ),
                                      ),
                                      if (crewMember.job.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          crewMember.job,
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],

                  // Movie Description
                  const SizedBox(height: 24),
                  Text(
                    'Synopsis',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontConstants.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      movie.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
