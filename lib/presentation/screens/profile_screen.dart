import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_typography.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: AppTypography.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to settings
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 32),

            // Quick Stats
            _buildQuickStats(),
            const SizedBox(height: 32),

            // Settings Sections
            _buildSettingsSections(context),
            const SizedBox(height: 32),

            // Account Actions
            _buildAccountActions(context),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.textInverse,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textInverse.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textInverse.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Premium Member',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          IconButton(
            onPressed: () {
              // Navigate to edit profile
            },
            icon: const Icon(Icons.edit, color: AppColors.textInverse),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.favorite,
            title: 'Favorites',
            value: '24',
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.bookmark,
            title: 'Watchlist',
            value: '12',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.history,
            title: 'Watched',
            value: '156',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Theme Settings
        _buildSettingsCard(
          title: 'Appearance',
          subtitle: 'Customize your app theme',
          icon: Icons.palette,
          onTap: () {
            _showThemeDialog(context);
          },
        ),

        const SizedBox(height: 12),

        // Notifications
        _buildSettingsCard(
          title: 'Notifications',
          subtitle: 'Manage your notifications',
          icon: Icons.notifications,
          onTap: () {
            // Navigate to notifications settings
          },
        ),

        const SizedBox(height: 12),

        // Language
        _buildSettingsCard(
          title: 'Language',
          subtitle: 'English (US)',
          icon: Icons.language,
          onTap: () {
            // Navigate to language settings
          },
        ),

        const SizedBox(height: 12),

        // Video Quality
        _buildSettingsCard(
          title: 'Video Quality',
          subtitle: 'Auto (Recommended)',
          icon: Icons.high_quality,
          onTap: () {
            // Navigate to video quality settings
          },
        ),

        const SizedBox(height: 12),

        // Download Settings
        _buildSettingsCard(
          title: 'Downloads',
          subtitle: 'Manage offline content',
          icon: Icons.download,
          onTap: () {
            // Navigate to download settings
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textTertiary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Help & Support
        _buildActionCard(
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          icon: Icons.help,
          onTap: () {
            // Navigate to help
          },
        ),

        const SizedBox(height: 12),

        // About
        _buildActionCard(
          title: 'About',
          subtitle: 'App version and information',
          icon: Icons.info,
          onTap: () {
            // Navigate to about
          },
        ),

        const SizedBox(height: 12),

        // Privacy Policy
        _buildActionCard(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          icon: Icons.privacy_tip,
          onTap: () {
            // Navigate to privacy policy
          },
        ),

        const SizedBox(height: 12),

        // Terms of Service
        _buildActionCard(
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          icon: Icons.description,
          onTap: () {
            // Navigate to terms
          },
        ),

        const SizedBox(height: 24),

        // Logout Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Logout'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.textTertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.textTertiary, size: 20),
        ),
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textTertiary,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    // Theme switching removed - using single color theme
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Theme customization is not available'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform logout
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
