import 'package:flutter/material.dart';
import 'package:streamnest/core/constants/font_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discover',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontConstants.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Genres Section
            const SectionHeader(
              title: 'Genres',
              subtitle: 'Explore by category',
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: AppConstants.movieGenres.length,
              itemBuilder: (context, index) {
                final genre = AppConstants.movieGenres[index];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Navigate to genre page
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Text(
                          genre,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontConstants.semiBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Trending Now
            const SectionHeader(
              title: 'Trending Now',
              subtitle: 'What\'s popular this week',
              showSeeAll: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16),
                    child: MovieCard(
                      title: 'Trending ${index + 1}',
                      posterPath: AppConstants.moviePlaceholder,
                      rating: 4.0 + (index * 0.1),
                      onTap: () {
                        // Navigate to movie details
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // New Releases
            const SectionHeader(
              title: 'New Releases',
              subtitle: 'Fresh content just added',
              showSeeAll: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16),
                    child: MovieCard(
                      title: 'New Release ${index + 1}',
                      posterPath: AppConstants.moviePlaceholder,
                      rating: 3.8 + (index * 0.1),
                      onTap: () {
                        // Navigate to movie details
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Top Rated
            const SectionHeader(
              title: 'Top Rated',
              subtitle: 'Highest rated content',
              showSeeAll: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 16),
                    child: MovieCard(
                      title: 'Top Rated ${index + 1}',
                      posterPath: AppConstants.moviePlaceholder,
                      rating: 4.5 + (index * 0.1),
                      onTap: () {
                        // Navigate to movie details
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }
}
