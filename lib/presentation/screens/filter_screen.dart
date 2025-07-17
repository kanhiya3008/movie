import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../providers/filter_data_provider.dart';
import '../../data/models/filterModel.dart';
import 'home_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String searchQuery = '';
  List<String> filteredChannels = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered channels when data is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFilteredChannels();
    });
  }

  void _updateFilteredChannels() {
    final filterDataProvider = Provider.of<FilterDataProvider>(
      context,
      listen: false,
    );
    if (filterDataProvider.hasData) {
      final platforms = filterDataProvider.streamingPlatforms;
      if (platforms != null) {
        setState(() {
          filteredChannels = platforms
              .map((p) => p.name ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
        });
      }
    }
  }

  void _filterChannels(String query) {
    setState(() {
      searchQuery = query;
      final filterDataProvider = Provider.of<FilterDataProvider>(
        context,
        listen: false,
      );
      if (filterDataProvider.hasData) {
        final platforms = filterDataProvider.streamingPlatforms;
        if (platforms != null) {
          final allChannels = platforms
              .map((p) => p.name ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
          if (query.isEmpty) {
            filteredChannels = List.from(allChannels);
          } else {
            filteredChannels = allChannels
                .where(
                  (channel) =>
                      channel.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
          }
        }
      }
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  List<String> _getOrderedPreferences(FilterDataProvider filterDataProvider) {
    List<String> preferenceOptions = [];

    if (filterDataProvider.hasData) {
      // Use actual genres from API
      final genres = filterDataProvider.genres;
      if (genres != null) {
        preferenceOptions = genres
            .map((g) => g.label ?? '')
            .where((label) => label.isNotEmpty)
            .toList();
      }
    }

    // Fallback to default options if no API data
    if (preferenceOptions.isEmpty) {
      preferenceOptions = [
        'New Releases',
        'Popular Movies',
        'Award Winners',
        'Critically Acclaimed',
        'Action & Adventure',
        'Comedy',
        'Drama',
        'Horror',
        'Romance',
        'Sci-Fi & Fantasy',
        'Documentaries',
        'Anime',
        'TV Shows',
        'Original Content',
      ];
    }

    // Create a list that combines selected and unselected preferences
    // Selected preferences come first in their selection order
    return [
      ...filterDataProvider.preferenceOrder, // Selected preferences in order
      ...preferenceOptions.where(
        (pref) => !filterDataProvider.preferenceOrder.contains(pref),
      ), // Unselected preferences
    ];
  }

  List<String> _getOrderedOtherFactors(FilterDataProvider filterDataProvider) {
    List<String> otherFactorsOptions = [];

    if (filterDataProvider.hasData) {
      // Use actual characteristics from API
      final characteristics =
          filterDataProvider.filterData?.data?.characteristics;
      if (characteristics != null) {
        otherFactorsOptions = characteristics
            .map((c) => c.label ?? '')
            .where((label) => label.isNotEmpty)
            .toList();
      }
    }

    // Fallback to default options if no API data
    if (otherFactorsOptions.isEmpty) {
      otherFactorsOptions = [
        'Cast',
        'Crew',
        'Popularity',
        'Recency',
        'Critic Ratings',
        'Audience Rating',
        'Awards',
      ];
    }

    // Create a list that combines selected and unselected other factors
    // Selected factors come first in their selection order
    return [
      ...filterDataProvider.otherFactorsOrder, // Selected factors in order
      ...otherFactorsOptions.where(
        (factor) => !filterDataProvider.otherFactorsOrder.contains(factor),
      ), // Unselected factors
    ];
  }

  Widget _buildOtherFactorsSelector(FilterDataProvider filterDataProvider) {
    // Generate random colors for other factors (different from preferences)
    final List<Color> randomColors = [
      Colors.deepPurple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];

    // Get other factors options from FilterDataProvider
    List<String> otherFactorsOptions = [];

    if (filterDataProvider.hasData) {
      final characteristics =
          filterDataProvider.filterData?.data?.characteristics;
      if (characteristics != null) {
        otherFactorsOptions = characteristics
            .map((c) => c.label ?? '')
            .where((label) => label.isNotEmpty)
            .toList();
      }
    }

    // Fallback to default options if no API data
    if (otherFactorsOptions.isEmpty) {
      otherFactorsOptions = [
        'Cast',
        'Crew',
        'Popularity',
        'Recency',
        'Critic Ratings',
        'Audience Rating',
        'Awards',
      ];
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getOrderedOtherFactors(filterDataProvider)
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final factor = entry.value;
                  final isSelected = filterDataProvider.otherFactorsOrder
                      .contains(factor);
                  final originalIndex = otherFactorsOptions.indexOf(factor);
                  final color =
                      randomColors[originalIndex % randomColors.length];
                  final selectedIndex = isSelected
                      ? filterDataProvider.otherFactorsOrder.indexOf(factor)
                      : -1;

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        filterDataProvider.removeOtherFactor(factor);
                      } else {
                        filterDataProvider.addOtherFactor(factor);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? color : AppColors.card,
                        border: Border.all(
                          color: isSelected
                              ? color
                              : AppColors.textSecondary.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            factor,
                            style: AppTypography.labelMedium.copyWith(
                              color: isSelected
                                  ? AppColors.textInverse
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? AppTypography.semiBold
                                  : AppTypography.medium,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.textInverse.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${selectedIndex + 1}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textInverse,
                                  fontWeight: AppTypography.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                })
                .toList(),
          ),
        ),

        // Clear All Other Factors Button
        if (filterDataProvider.otherFactorsOrder.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                filterDataProvider.clearAllOtherFactors();
              },
              icon: const Icon(Icons.clear_all, size: 18),
              label: Text(
                'Clear All Other Factors',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterDataProvider>(
      builder: (context, filterDataProvider, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.background,

            body: Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          title: 'Region of Residence',
                          subtitle: 'Skip',
                          child: _buildRegionSelector(filterDataProvider),
                        ),

                        const SizedBox(height: 24),

                        // OTT Channel Selection
                        _buildSection(
                          title: 'OTT Channels',
                          subtitle: '',
                          child: _buildChannelSelector(filterDataProvider),
                        ),

                        const SizedBox(height: 24),

                        // Preference Order
                        _buildSection(
                          title: 'Content Preferences',
                          subtitle: '',
                          child: _buildPreferenceSelector(filterDataProvider),
                        ),

                        const SizedBox(height: 24),

                        // Other Factors
                        _buildSection(
                          title: 'Other Factors',
                          subtitle: '',
                          child: _buildOtherFactorsSelector(filterDataProvider),
                        ),

                        const SizedBox(
                          height: 100,
                        ), // Extra padding for bottom buttons
                      ],
                    ),
                  ),
                ),

                // Fixed bottom buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Skip Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _navigateToHome,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              side: BorderSide(
                                color: AppColors.textSecondary.withOpacity(0.3),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Set Preferences Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                filterDataProvider.selectedRegion != null &&
                                    filterDataProvider
                                        .selectedChannels
                                        .isNotEmpty
                                ? _navigateToHome
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textInverse,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Set Preferences',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: AppTypography.bold,
              ),
            ),
            Spacer(),
            Text(
              subtitle,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: AppTypography.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildRegionSelector(FilterDataProvider filterDataProvider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: filterDataProvider.selectedRegion,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintText: 'Select your region',
        ),
        items:
            filterDataProvider.countries?.map((country) {
              return DropdownMenuItem(
                value: country.name ?? '',
                child: Text(country.name ?? ''),
              );
            }).toList() ??
            [],
        onChanged: (value) {
          if (value != null) {
            filterDataProvider.setRegion(value);
          }
        },
      ),
    );
  }

  Widget _buildChannelSelector(FilterDataProvider filterDataProvider) {
    return Column(
      children: [
        // Search Field
        TextField(
          onChanged: _filterChannels,
          decoration: InputDecoration(
            hintText: 'Search OTT channels...',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: TextStyle(color: AppColors.textPrimary),
        ),

        const SizedBox(height: 16),

        // Selected Channels
        if (filterDataProvider.selectedChannels.isNotEmpty) ...[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: filterDataProvider.selectedChannels.map((channel) {
              // Find the platform data to get the logo
              final platform = filterDataProvider.streamingPlatforms
                  ?.firstWhere(
                    (p) => p.name == channel,
                    orElse: () => StreamingPlatform(),
                  );

              return Container(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    // Square image container
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: platform?.logo != null
                            ? Image.network(
                                platform!.logo!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.primary.withOpacity(0.1),
                                    child: Icon(
                                      Icons.tv,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: Icon(
                                  Icons.tv,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                      ),
                    ),
                    // Red minus button positioned inside the container
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => filterDataProvider.removeChannel(channel),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Channel List
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: filteredChannels.length,
            itemBuilder: (context, index) {
              final channel = filteredChannels[index];
              final isSelected = filterDataProvider.selectedChannels.contains(
                channel,
              );

              // Find the platform data to get the logo
              final platform = filterDataProvider.streamingPlatforms
                  ?.firstWhere(
                    (p) => p.name == channel,
                    orElse: () => StreamingPlatform(),
                  );

              return ListTile(
                leading: platform?.logo != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(platform!.logo!),
                        radius: 20,
                      )
                    : CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        radius: 20,
                        child: Icon(
                          Icons.tv,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                title: Text(channel),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    if (isSelected) {
                      filterDataProvider.removeChannel(channel);
                    } else {
                      filterDataProvider.addChannel(channel);
                    }
                  },
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                ),
                onTap: () {
                  if (isSelected) {
                    filterDataProvider.removeChannel(channel);
                  } else {
                    filterDataProvider.addChannel(channel);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceSelector(FilterDataProvider filterDataProvider) {
    // Generate random colors for preferences
    final List<Color> randomColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.deepOrange,
      Colors.lightBlue,
      Colors.lime,
      Colors.deepPurple,
    ];

    // Get preference options from FilterDataProvider
    List<String> preferenceOptions = [];

    if (filterDataProvider.hasData) {
      final genres = filterDataProvider.genres;
      if (genres != null) {
        preferenceOptions = genres
            .map((g) => g.label ?? '')
            .where((label) => label.isNotEmpty)
            .toList();
      }
    }

    // Fallback to default options if no API data
    if (preferenceOptions.isEmpty) {
      preferenceOptions = [
        'New Releases',
        'Popular Movies',
        'Award Winners',
        'Critically Acclaimed',
        'Action & Adventure',
        'Comedy',
        'Drama',
        'Horror',
        'Romance',
        'Sci-Fi & Fantasy',
        'Documentaries',
        'Anime',
        'TV Shows',
        'Original Content',
      ];
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getOrderedPreferences(filterDataProvider)
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final preference = entry.value;
                  final isSelected = filterDataProvider.preferenceOrder
                      .contains(preference);
                  final originalIndex = preferenceOptions.indexOf(preference);
                  final color =
                      randomColors[originalIndex % randomColors.length];
                  final selectedIndex = isSelected
                      ? filterDataProvider.preferenceOrder.indexOf(preference)
                      : -1;

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        filterDataProvider.removePreference(preference);
                      } else {
                        filterDataProvider.addPreference(preference);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? color : AppColors.card,
                        border: Border.all(
                          color: isSelected
                              ? color
                              : AppColors.textSecondary.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            preference,
                            style: AppTypography.labelMedium.copyWith(
                              color: isSelected
                                  ? AppColors.textInverse
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? AppTypography.semiBold
                                  : AppTypography.medium,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.textInverse.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${selectedIndex + 1}',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textInverse,
                                  fontWeight: AppTypography.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                })
                .toList(),
          ),
        ),

        // Clear All Preferences Button
        if (filterDataProvider.preferenceOrder.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                filterDataProvider.clearAllPreferences();
              },
              icon: const Icon(Icons.clear_all, size: 18),
              label: Text(
                'Clear All Preferences',
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
