import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../core/constants/font_constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showSeeAll = false,
    this.onSeeAllTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontConstants.bold,
                ),
              ),
              // if (subtitle != null) ...[
              //   const SizedBox(height: 4),
              //   Text(
              //     subtitle!,
              //     style: AppTypography.bodyMedium.copyWith(
              //       color: AppColors.textSecondary,
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
        // if (trailing != null) trailing!,
        // if (showSeeAll)
        //   TextButton(
        //     onPressed: onSeeAllTap,
        //     child: Text(
        //       'See All',
        //       style: AppTypography.labelMedium.copyWith(
        //         color: AppColors.textPrimary,
        //         fontWeight: FontConstants.semiBold,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
