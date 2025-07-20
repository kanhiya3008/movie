// Shimmer effect for movie tab loading
import 'package:flutter/material.dart';
import 'package:streamnest/presentation/theme/app_colors.dart';
import 'package:streamnest/presentation/widgets/shimmer_widgets.dart';

Widget buildMovieTabShimmer(BuildContext context) {
  return SingleChildScrollView(
    child: ShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Image and Content
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Movie Poster shimmer
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
                      color: AppColors.card.withOpacity(0.7),
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width < 360 ? 6 : 8,
                  ),

                  // Right Side: Content shimmer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie title shimmer
                        Container(
                          height: 20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.card.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Login button shimmer
                        Container(
                          height: 30,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.card.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Rating container shimmer
                        Container(
                          height: 25,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.card.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Star rating shimmer
                        Row(
                          children: List.generate(
                            5,
                            (index) => Container(
                              margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.card.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Action containers shimmer
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.card.withOpacity(0.7),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width < 360
                                  ? 4
                                  : 8,
                            ),
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.card.withOpacity(0.7),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width < 360
                                  ? 4
                                  : 8,
                            ),
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.card.withOpacity(0.7),
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

              // Action buttons shimmer
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.card.withOpacity(0.7),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 360 ? 8 : 12,
                  ),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.card.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Cast and streaming section shimmer
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cast section shimmer
              SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width / 2.4,
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.card.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Streaming platforms shimmer
              Expanded(
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.card.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description section shimmer
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

          const SizedBox(height: 24),

          // Synopsis section shimmer
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

          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}
