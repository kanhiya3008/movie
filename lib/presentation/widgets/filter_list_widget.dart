import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../providers/filter_data_provider.dart';
import '../../data/models/filterModel.dart';

class FilterListWidget extends StatefulWidget {
  final Function(String, String, String)?
  onFilterSelected; // category, label, value
  final String? selectedCategory;
  final String? selectedValue;

  const FilterListWidget({
    super.key,
    this.onFilterSelected,
    this.selectedCategory,
    this.selectedValue,
  });

  @override
  State<FilterListWidget> createState() => _FilterListWidgetState();
}

class _FilterListWidgetState extends State<FilterListWidget> {
  Map<String, List<Map<String, dynamic>>> filterCategories = {};
  String? selectedCategory;
  String? selectedValue;
  String? selectedLabel;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
    selectedValue = widget.selectedValue;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFilterCategories();
    });
  }

  void _loadFilterCategories() {
    final filterDataProvider = Provider.of<FilterDataProvider>(
      context,
      listen: false,
    );

    if (filterDataProvider.hasData) {
      final filterData = filterDataProvider.filterData?.data?.filter;
      if (filterData != null) {
        final categories = <String, List<Map<String, dynamic>>>{};

        // Dynamically extract all keys from the filter object
        final filterMap = filterData.toJson();

        for (String key in filterMap.keys) {
          final value = filterMap[key];
          if (value is List && value.isNotEmpty) {
            List<Map<String, dynamic>> options = [];

            // Handle different data structures in the filter values
            for (var item in value) {
              if (item is Map<String, dynamic>) {
                Map<String, dynamic> option = {};

                // Handle objects with label/value structure
                if (item.containsKey('label')) {
                  final label = item['label']?.toString() ?? '';
                  final value = item['value']?.toString() ?? '';
                  if (label.isNotEmpty) {
                    option['label'] = label;
                    option['value'] = value;
                    options.add(option);
                  }
                } else if (item.containsKey('name')) {
                  // Handle objects with name structure (like genresV1)
                  final name = item['name']?.toString() ?? '';
                  final value = item['value']?.toString() ?? '';
                  if (name.isNotEmpty) {
                    option['label'] = name;
                    option['value'] = value;
                    options.add(option);
                  }
                }
              } else if (item is String) {
                // Handle simple string values
                if (item.isNotEmpty) {
                  options.add({'label': item, 'value': item});
                }
              }
            }

            if (options.isNotEmpty) {
              // Convert key to readable format (e.g., "genres" -> "Genres")
              final categoryName = key.replaceAllMapped(
                RegExp(r'^[a-z]|[A-Z]'),
                (match) => match.group(0)!.toUpperCase(),
              );
              categories[categoryName] = options;
            }
          }
        }

        setState(() {
          filterCategories = categories;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterDataProvider>(
      builder: (context, filterDataProvider, child) {
        // Update filter categories when data changes
        if (filterDataProvider.hasData && filterCategories.isEmpty) {
          _loadFilterCategories();
        }

        return Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filterCategories.length,
            itemBuilder: (context, index) {
              final categoryName = filterCategories.keys.elementAt(index);
              final isSelected = selectedCategory == categoryName;

              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categoryName;
                      selectedValue = null;
                      selectedLabel = null;
                    });
                    // Show filter options for this category
                    _showFilterOptions(
                      categoryName,
                      filterCategories[categoryName]!,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.primaryDark,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryLight
                            : AppColors.textSecondary.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryLight.withOpacity(0.3),
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
                          categoryName,
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? AppTypography.semiBold
                                : AppTypography.medium,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showFilterOptions(String category, List<Map<String, dynamic>> options) {
    String? tempSelectedValue;
    String? tempSelectedLabel;
    List<String> tempSelectedCheckboxes = [];
    List<String> tempSelectedPlatforms = [];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Function to update radio button selection
          void updateRadioSelection(String? value, String? label) {
            setDialogState(() {
              tempSelectedValue = value;
              tempSelectedLabel = label;
            });
          }

          // Function to update checkbox selection
          void updateCheckboxSelection(String value, bool isSelected) {
            setDialogState(() {
              if (isSelected) {
                tempSelectedCheckboxes.add(value);
              } else {
                tempSelectedCheckboxes.remove(value);
              }
            });
          }

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Select $category',
                          style: AppTypography.titleLarge.copyWith(
                            fontWeight: AppTypography.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Custom content based on category
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: category.toLowerCase() == 'availability'
                          ? _buildAvailabilityFilter(
                              options,
                              tempSelectedValue,
                              tempSelectedLabel,
                              tempSelectedCheckboxes,
                              tempSelectedPlatforms,
                              updateRadioSelection,
                              updateCheckboxSelection,
                            )
                          : category.toLowerCase() == 'languages'
                          ? _buildLanguageFilter(
                              options,
                              tempSelectedCheckboxes,
                              updateCheckboxSelection,
                            )
                          : category.toLowerCase() == 'ratings'
                          ? _buildRatingFilter(
                              options,
                              tempSelectedValue,
                              tempSelectedLabel,
                              updateRadioSelection,
                            )
                          : category.toLowerCase() == 'releaseyears' ||
                                category.toLowerCase() == 'year'
                          ? _buildReleaseYearFilter(
                              options,
                              tempSelectedValue,
                              tempSelectedLabel,
                              updateRadioSelection,
                            )
                          : category.toLowerCase() == 'duration'
                          ? _buildDurationFilter(
                              options,
                              tempSelectedValue,
                              tempSelectedLabel,
                              updateRadioSelection,
                            )
                          : _buildDefaultFilter(
                              category,
                              options,
                              tempSelectedValue,
                              tempSelectedLabel,
                              updateRadioSelection,
                            ),
                    ),
                  ),

                  // Bottom buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Reset Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setDialogState(() {
                                tempSelectedValue = null;
                                tempSelectedLabel = null;
                                tempSelectedCheckboxes.clear();
                                tempSelectedPlatforms.clear();
                              });
                            },
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
                              'Reset',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Apply Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                (tempSelectedValue != null ||
                                    tempSelectedCheckboxes.isNotEmpty ||
                                    tempSelectedPlatforms.isNotEmpty)
                                ? () {
                                    setState(() {
                                      selectedValue = tempSelectedValue;
                                      selectedLabel = tempSelectedLabel;
                                    });

                                    // For availability filter, combine all selections
                                    if (category.toLowerCase() ==
                                        'availability') {
                                      final allSelections = <String>[];
                                      if (tempSelectedValue != null) {
                                        allSelections.add(tempSelectedValue!);
                                      }
                                      allSelections.addAll(
                                        tempSelectedCheckboxes,
                                      );
                                      allSelections.addAll(
                                        tempSelectedPlatforms,
                                      );

                                      widget.onFilterSelected?.call(
                                        category,
                                        allSelections.join(', '),
                                        allSelections.join(','),
                                      );
                                    } else {
                                      widget.onFilterSelected?.call(
                                        category,
                                        tempSelectedLabel ?? '',
                                        tempSelectedValue ?? '',
                                      );
                                    }
                                    Navigator.pop(context);
                                  }
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
                              'Apply',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailabilityFilter(
    List<Map<String, dynamic>> options,
    String? tempSelectedValue,
    String? tempSelectedLabel,
    List<String> tempSelectedCheckboxes,
    List<String> tempSelectedPlatforms,
    Function(String?, String?) updateRadioSelection,
    Function(String, bool) updateCheckboxSelection,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // More Platforms Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showPlatformSelection(
                tempSelectedPlatforms,
                updateRadioSelection,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                'More Platforms',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Radio buttons for first two options
          if (options.length >= 2) ...[
            Text(
              'Availability Type',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: AppTypography.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...options.take(2).map((option) {
              final label = option['label'] ?? '';
              final value = option['value'] ?? '';
              final isSelected = tempSelectedValue == value;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: value,
                  groupValue: tempSelectedValue,
                  onChanged: (newValue) {
                    updateRadioSelection(newValue, label);
                  },
                  activeColor: Colors.blue,
                ),
                title: Text(
                  label,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                onTap: () {
                  updateRadioSelection(value, label);
                },
              );
            }).toList(),
          ],

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: AppColors.textSecondary, thickness: 1),
          ),

          // Checkboxes for remaining options
          if (options.length > 2) ...[
            Text(
              'Additional Options',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: AppTypography.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...options.skip(2).map((option) {
              final label = option['label'] ?? '';
              final value = option['value'] ?? '';
              final isSelected = tempSelectedCheckboxes.contains(value);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Checkbox(
                  value: isSelected,
                  onChanged: (checked) {
                    updateCheckboxSelection(value, checked == true);
                  },
                  activeColor: Colors.blue,
                ),
                title: Text(
                  label,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                onTap: () {
                  updateCheckboxSelection(value, !isSelected);
                },
              );
            }).toList(),
          ],

          // Selected platforms display
          if (tempSelectedPlatforms.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Selected Platforms',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: AppTypography.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tempSelectedPlatforms.map((platform) {
                return Chip(
                  label: Text(platform),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    tempSelectedPlatforms.remove(platform);
                  },
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  deleteIconColor: Colors.blue,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingFilter(
    List<Map<String, dynamic>> options,
    String? tempSelectedValue,
    String? tempSelectedLabel,
    Function(String?, String?) updateRadioSelection,
  ) {
    // Extract custom range if selected
    double customStart = 0.0;
    double customEnd = 10.0;
    if (tempSelectedValue != null &&
        tempSelectedValue.startsWith('custom_range_')) {
      final parts = tempSelectedValue
          .replaceFirst('custom_range_', '')
          .split('_');
      if (parts.length == 2) {
        final start = double.tryParse(parts[0]);
        final end = double.tryParse(parts[1]);
        if (start != null && end != null) {
          customStart = start;
          customEnd = end;
        }
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final label = option['label'] ?? '';
        final value = option['value'] ?? '';
        final isSelected =
            tempSelectedValue == value ||
            (tempSelectedValue != null &&
                tempSelectedValue.startsWith('custom_range_') &&
                label.toLowerCase().contains('custom'));

        // Check if this is a custom range option
        final isCustomRange =
            label.toLowerCase().contains('custom') ||
            value.toLowerCase().contains('custom');

        if (isCustomRange) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: value,
                  groupValue:
                      tempSelectedValue?.startsWith('custom_range_') == true
                      ? value
                      : tempSelectedValue,
                  onChanged: (newValue) {
                    updateRadioSelection(
                      'custom_range_${customStart}_${customEnd}',
                      label,
                    );
                  },
                  activeColor: Colors.blue,
                ),
                title: Text(
                  label,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                onTap: () {
                  updateRadioSelection(
                    'custom_range_${customStart}_${customEnd}',
                    label,
                  );
                },
              ),
              if (isSelected) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'From: ${customStart.toStringAsFixed(1)}',
                            style: AppTypography.bodyMedium,
                          ),
                          Text(
                            'To: ${customEnd.toStringAsFixed(1)}',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: RangeValues(customStart, customEnd),
                        min: 0.0,
                        max: 10.0,
                        divisions: 100,
                        labels: RangeLabels(
                          customStart.toStringAsFixed(1),
                          customEnd.toStringAsFixed(1),
                        ),
                        activeColor: Colors.blue,
                        onChanged: (range) {
                          updateRadioSelection(
                            'custom_range_${range.start}_${range.end}',
                            'Custom Range: ${range.start.toStringAsFixed(1)} - ${range.end.toStringAsFixed(1)}',
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '10',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        }

        // Handle regular options
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Radio<String>(
            value: value,
            groupValue: tempSelectedValue,
            onChanged: (newValue) {
              updateRadioSelection(newValue, label);
            },
            activeColor: Colors.blue,
          ),
          title: Text(
            label,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: AppTypography.medium,
            ),
          ),
          onTap: () {
            updateRadioSelection(value, label);
          },
        );
      },
    );
  }

  Widget _buildReleaseYearFilter(
    List<Map<String, dynamic>> options,
    String? tempSelectedValue,
    String? tempSelectedLabel,
    Function(String?, String?) updateRadioSelection,
  ) {
    // Get current year
    final currentYear = DateTime.now().year;

    // Extract custom year range if selected
    double customStart = 1900.0;
    double customEnd = currentYear.toDouble();
    if (tempSelectedValue != null &&
        tempSelectedValue.startsWith('custom_year_')) {
      final parts = tempSelectedValue
          .replaceFirst('custom_year_', '')
          .split('_');
      if (parts.length == 2) {
        final start = double.tryParse(parts[0]);
        final end = double.tryParse(parts[1]);
        if (start != null && end != null) {
          customStart = start;
          customEnd = end;
        }
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: options.length + 1, // +1 for custom year
      itemBuilder: (context, index) {
        // Handle custom year option
        if (index == options.length) {
          final customYearOptionValue = 'custom_year';
          final customYearLabel = 'Custom Range';
          final isCustomSelected =
              tempSelectedValue == customYearOptionValue ||
              (tempSelectedValue != null &&
                  tempSelectedValue.startsWith('custom_year_'));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: customYearOptionValue,
                  groupValue: tempSelectedValue,
                  onChanged: (newValue) {
                    updateRadioSelection(
                      'custom_year_${customStart.toInt()}_${customEnd.toInt()}',
                      customYearLabel,
                    );
                  },
                  activeColor: Colors.blue,
                ),
                title: Text(
                  customYearLabel,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                onTap: () {
                  updateRadioSelection(
                    'custom_year_${customStart.toInt()}_${customEnd.toInt()}',
                    customYearLabel,
                  );
                },
              ),
              // Show range slider only when custom year is selected
              if (isCustomSelected) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'From: ${customStart.toInt()}',
                            style: AppTypography.bodyMedium,
                          ),
                          Text(
                            'To: ${customEnd.toInt()}',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: RangeValues(customStart, customEnd),
                        min: 1900.0,
                        max: currentYear.toDouble(),
                        divisions: currentYear - 1900,
                        labels: RangeLabels(
                          customStart.toInt().toString(),
                          customEnd.toInt().toString(),
                        ),
                        activeColor: Colors.blue,
                        onChanged: (range) {
                          updateRadioSelection(
                            'custom_year_${range.start.toInt()}_${range.end.toInt()}',
                            'Custom Range: ${range.start.toInt()} - ${range.end.toInt()}',
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1900',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '$currentYear',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        }

        // Handle regular options
        final option = options[index];
        final label = option['label'] ?? '';
        final value = option['value'] ?? '';
        final isSelected = tempSelectedValue == value;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Radio<String>(
            value: value,
            groupValue: tempSelectedValue,
            onChanged: (newValue) {
              updateRadioSelection(newValue, label);
            },
            activeColor: Colors.blue,
          ),
          title: Text(
            label,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: AppTypography.medium,
            ),
          ),
          onTap: () {
            updateRadioSelection(value, label);
          },
        );
      },
    );
  }

  Widget _buildDurationFilter(
    List<Map<String, dynamic>> options,
    String? tempSelectedValue,
    String? tempSelectedLabel,
    Function(String?, String?) updateRadioSelection,
  ) {
    // Extract custom duration value if selected
    double customDurationValue = 120.0;
    if (tempSelectedValue != null &&
        tempSelectedValue.startsWith('custom_duration_')) {
      final valueStr = tempSelectedValue.replaceFirst('custom_duration_', '');
      final parsedValue = double.tryParse(valueStr);
      if (parsedValue != null) {
        customDurationValue = parsedValue;
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: options.length + 1, // +1 for custom duration
      itemBuilder: (context, index) {
        // Handle custom duration option
        if (index == options.length) {
          final customDurationOptionValue = 'custom_duration';
          final customDurationLabel = 'Custom Range';
          final isCustomSelected =
              tempSelectedValue == customDurationOptionValue ||
              (tempSelectedValue != null &&
                  tempSelectedValue.startsWith('custom_duration_'));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: customDurationOptionValue,
                  groupValue: tempSelectedValue,
                  onChanged: (newValue) {
                    updateRadioSelection(newValue, customDurationLabel);
                  },
                  activeColor: Colors.blue,
                ),
                title: Text(
                  customDurationLabel,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                onTap: () {
                  updateRadioSelection(
                    customDurationOptionValue,
                    customDurationLabel,
                  );
                },
              ),
              // Show range slider only when custom duration is selected
              if (isCustomSelected) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            '${customDurationValue.toInt()} min',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: AppTypography.medium,
                            ),
                          ),
                        ],
                      ),
                      //  const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: AppColors.textSecondary
                              .withOpacity(0.3),
                          thumbColor: Colors.blue,
                          overlayColor: Colors.blue.withOpacity(0.2),
                          valueIndicatorColor: Colors.blue,
                          valueIndicatorTextStyle: AppTypography.titleSmall
                              .copyWith(
                                color: Colors.white,
                                fontWeight: AppTypography.semiBold,
                              ),
                        ),
                        child: Slider(
                          value: customDurationValue,
                          min: 0.0,
                          max: 500.0,
                          divisions: 50, // 10-minute intervals
                          label: '${customDurationValue.toInt()} minutes',
                          onChanged: (value) {
                            // Update the custom duration value
                            final customValue =
                                'custom_duration_${value.toInt()}';
                            updateRadioSelection(
                              customValue,
                              'Custom Range: ${value.toInt()} minutes',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        }

        // Handle regular options
        final option = options[index];
        final label = option['label'] ?? '';
        final value = option['value'] ?? '';
        final isSelected = tempSelectedValue == value;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Radio<String>(
            value: value,
            groupValue: tempSelectedValue,
            onChanged: (newValue) {
              updateRadioSelection(newValue, label);
            },
            activeColor: Colors.blue,
          ),
          title: Text(
            label,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: AppTypography.medium,
            ),
          ),
          onTap: () {
            updateRadioSelection(value, label);
          },
        );
      },
    );
  }

  Widget _buildLanguageFilter(
    List<Map<String, dynamic>> options,
    List<String> tempSelectedCheckboxes,
    Function(String, bool) updateCheckboxSelection,
  ) {
    List<Map<String, dynamic>> filteredOptions = List.from(options);
    String searchQuery = '';

    return StatefulBuilder(
      builder: (context, setSearchState) => Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search languages...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (query) {
                setSearchState(() {
                  searchQuery = query;
                  if (query.isEmpty) {
                    filteredOptions = List.from(options);
                  } else {
                    filteredOptions = options
                        .where(
                          (option) => option['label']!
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()),
                        )
                        .toList();
                  }
                });
              },
            ),
          ),

          // Languages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              itemCount: filteredOptions.length,
              itemBuilder: (context, index) {
                final option = filteredOptions[index];
                final label = option['label'] ?? '';
                final value = option['value'] ?? '';
                final isSelected = tempSelectedCheckboxes.contains(value);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (checked) {
                      updateCheckboxSelection(value, checked == true);
                    },
                    activeColor: Colors.blue,
                  ),
                  title: Text(
                    label,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: isSelected
                          ? AppTypography.semiBold
                          : AppTypography.medium,
                    ),
                  ),
                  onTap: () {
                    updateCheckboxSelection(value, !isSelected);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultFilter(
    String category,
    List<Map<String, dynamic>> options,
    String? tempSelectedValue,
    String? tempSelectedLabel,
    Function(String?, String?) updateRadioSelection,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final label = option['label'] ?? '';
        final value = option['value'] ?? '';
        final isSelected = tempSelectedValue == value;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            label,
            style: AppTypography.titleMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: isSelected
                  ? AppTypography.semiBold
                  : AppTypography.medium,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check, color: AppColors.primary, size: 20)
              : null,
          onTap: () {
            updateRadioSelection(value, label);
          },
        );
      },
    );
  }

  void _showPlatformSelection(
    List<String> tempSelectedPlatforms,
    Function(String?, String?) updateParentState,
  ) {
    final filterDataProvider = Provider.of<FilterDataProvider>(
      context,
      listen: false,
    );
    List<Map<String, dynamic>> allPlatforms = [];

    if (filterDataProvider.hasData) {
      final platforms = filterDataProvider.streamingPlatforms;
      if (platforms != null) {
        allPlatforms = platforms
            .map((p) => {'name': p.name ?? '', 'logo': p.logo ?? ''})
            .where((p) => p['name']!.isNotEmpty)
            .toList();
      }
    }

    List<Map<String, dynamic>> filteredPlatforms = List.from(allPlatforms);
    String searchQuery = '';
    List<String> localSelectedPlatforms = List.from(tempSelectedPlatforms);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSearchState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Select Platforms',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search box
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search platforms...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (query) {
                      setSearchState(() {
                        searchQuery = query;
                        if (query.isEmpty) {
                          filteredPlatforms = List.from(allPlatforms);
                        } else {
                          filteredPlatforms = allPlatforms
                              .where(
                                (platform) => platform['name']!
                                    .toLowerCase()
                                    .contains(query.toLowerCase()),
                              )
                              .toList();
                        }
                      });
                    },
                  ),
                ),

                // Platforms list
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    itemCount: filteredPlatforms.length,
                    itemBuilder: (context, index) {
                      final platform = filteredPlatforms[index];
                      final name = platform['name'] ?? '';
                      final logo = platform['logo'] ?? '';
                      final isSelected = localSelectedPlatforms.contains(name);

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: logo.isNotEmpty
                            ? SizedBox(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    logo,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.tv,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.tv,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                        title: Text(
                          name,
                          style: AppTypography.titleMedium.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? AppTypography.semiBold
                                : AppTypography.medium,
                          ),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (checked) {
                            setSearchState(() {
                              if (checked == true) {
                                localSelectedPlatforms.add(name);
                              } else {
                                localSelectedPlatforms.remove(name);
                              }
                            });
                          },
                          activeColor: AppColors.primaryLight,
                        ),
                        onTap: () {
                          setSearchState(() {
                            if (isSelected) {
                              localSelectedPlatforms.remove(name);
                            } else {
                              localSelectedPlatforms.add(name);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),

                // Done button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Update the parent dialog's state with the selected platforms
                        tempSelectedPlatforms.clear();
                        tempSelectedPlatforms.addAll(localSelectedPlatforms);
                        Navigator.pop(context);
                      },
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
                        'Done',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
