import 'package:flutter/material.dart';
import 'package:streamnest/core/constants/font_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../widgets/section_header.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Content
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Feed Header
              const SectionHeader(
                title: 'Your Feed',
                subtitle: 'Personalized recommendations',
                showSeeAll: false,
              ),
              const SizedBox(height: 16),

              // Feed Content
              _buildFeedItem(
                title: 'Welcome to StreamNest',
                subtitle: 'Start exploring your favorite content',
                icon: Icons.movie,
              ),

              const SizedBox(height: 16),

              _buildFeedItem(
                title: 'Discover New Movies',
                subtitle: 'Find hidden gems and popular hits',
                icon: Icons.explore,
              ),

              const SizedBox(height: 16),

              _buildFeedItem(
                title: 'Create Your Watchlist',
                subtitle: 'Save movies you want to watch later',
                icon: Icons.bookmark_add,
              ),

              const SizedBox(height: 16),

              _buildFeedItem(
                title: 'Rate and Review',
                subtitle: 'Share your thoughts on movies',
                icon: Icons.star,
              ),

              const SizedBox(height: 100), // Bottom padding
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedItem({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontConstants.semiBold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
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
}
