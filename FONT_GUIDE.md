# Font Guide - StreamNest App

## Overview
This app now uses Google Fonts for a modern, consistent typography system. The primary font is **Inter**, which is clean, modern, and highly readable.

### Primary Style: Name-Desktop/Body/MediumRegular
- **Font Family**: Inter
- **Font Size**: 14px
- **Font Weight**: Medium (500)
- **Letter Spacing**: 0.25
- **Usage**: Primary body text throughout the app

## Font Families Available

### Primary Fonts
- **Inter** - Primary font for all text (clean, modern, highly readable)
- **Poppins** - Secondary font for accents and special text
- **Roboto** - Alternative option
- **Open Sans** - Clean and readable
- **Lato** - Modern and friendly
- **Montserrat** - Elegant and modern

## How to Use Fonts

### 1. Using AppTypography (Recommended)
The easiest way to use fonts is through the `AppTypography` class:

```dart
import 'package:your_app/presentation/theme/app_typography.dart';

Text(
  'Hello World',
  style: AppTypography.headlineLarge,
)

// Name-Desktop/Body/MediumRegular style
Text(
  'Body text here',
  style: AppTypography.bodyMedium, // Inter, 14px, Medium weight
)

Text(
  'Button text',
  style: AppTypography.buttonMedium,
)
```

### 2. Using FontUtils
For custom font styles or different font families:

```dart
import 'package:your_app/core/utils/font_utils.dart';

// Using Inter font
Text(
  'Inter font text',
  style: FontUtils.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
)

// Using Poppins font
Text(
  'Poppins font text',
  style: FontUtils.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
)

// Quick access methods
Text(
  'Heading 1',
  style: FontUtils.heading1,
)

// Name-Desktop/Body/MediumRegular style
Text(
  'Body text',
  style: FontUtils.bodyText, // Inter, 14px, Medium weight
)

// Or use the specific method
Text(
  'Body text',
  style: FontUtils.nameDesktopBodyMediumRegular,
)
```

### 3. Using FontConstants
For consistent font sizes and weights:

```dart
import 'package:your_app/core/constants/font_constants.dart';

Text(
  'Custom text',
  style: TextStyle(
    fontSize: FontConstants.titleLarge,
    fontWeight: FontConstants.medium,
    letterSpacing: FontConstants.letterSpacingWide,
  ),
)
```

## Font Sizes Available

### Display Text
- `displayLarge`: 57px
- `displayMedium`: 45px
- `displaySmall`: 36px

### Headlines
- `headlineLarge`: 32px
- `headlineMedium`: 28px
- `headlineSmall`: 24px

### Titles
- `titleLarge`: 20px
- `titleMedium`: 16px
- `titleSmall`: 14px

### Body Text
- `bodyLarge`: 16px
- `bodyMedium`: 14px (Name-Desktop/Body/MediumRegular - Inter, Medium weight)
- `bodySmall`: 12px

### Labels
- `labelLarge`: 14px
- `labelMedium`: 12px
- `labelSmall`: 11px

### Buttons
- `buttonLarge`: 16px
- `buttonMedium`: 14px
- `buttonSmall`: 12px

### Captions
- `caption`: 12px
- `overline`: 10px

## Font Weights Available

- `light`: 300
- `regular`: 400
- `medium`: 500
- `semiBold`: 600
- `bold`: 700
- `extraBold`: 800

## Letter Spacing Options

- `letterSpacingTight`: -0.25
- `letterSpacingNormal`: 0.0
- `letterSpacingWide`: 0.15
- `letterSpacingWider`: 0.25
- `letterSpacingWidest`: 0.5
- `letterSpacingExtraWide`: 1.5

## Best Practices

### 1. Use AppTypography for Consistency
Always use `AppTypography` styles for standard text elements to maintain consistency across the app.

### 2. Choose Appropriate Font Sizes
- Use `displayLarge` for hero text and main headlines
- Use `headlineLarge/Medium/Small` for section headers
- Use `titleLarge/Medium/Small` for card titles and important text
- Use `bodyLarge/Medium/Small` for regular content
- Use `labelLarge/Medium/Small` for form labels and small text
- Use `buttonLarge/Medium/Small` for button text

### 3. Font Family Guidelines
- **Inter**: Use for all primary text (headlines, body, buttons, labels)
- **Poppins**: Use for special accents, quotes, or decorative text
- **Other fonts**: Use sparingly for specific design needs

### 4. Font Weight Guidelines
- **Light (300)**: Rarely used, only for very subtle text
- **Regular (400)**: Default for body text and most content
- **Medium (500)**: Use for titles and important text
- **SemiBold (600)**: Use for headlines and emphasis
- **Bold (700)**: Use for main headlines and strong emphasis
- **ExtraBold (800)**: Use sparingly for maximum impact

## Examples

### Movie Title
```dart
Text(
  'The Dark Knight',
  style: AppTypography.headlineMedium,
)
```

### Movie Description (Name-Desktop/Body/MediumRegular)
```dart
Text(
  'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham...',
  style: AppTypography.bodyMedium, // Inter, 14px, Medium weight
)
```

### Rating Text
```dart
Text(
  '8.9/10',
  style: AppTypography.titleMedium.copyWith(
    color: AppColors.primary,
  ),
)
```

### Button Text
```dart
ElevatedButton(
  onPressed: () {},
  child: Text(
    'Watch Now',
    style: AppTypography.buttonMedium,
  ),
)
```

### Custom Styled Text
```dart
Text(
  'Special Quote',
  style: FontUtils.poppins(
    fontSize: FontConstants.titleLarge,
    fontWeight: FontConstants.medium,
    fontStyle: FontStyle.italic,
    color: AppColors.primary,
  ),
)
```

## Migration from Old Font System

If you have existing text styles, replace them with the new system:

### Before
```dart
Text(
  'Old style',
  style: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
)
```

### After
```dart
Text(
  'New style',
  style: AppTypography.titleMedium,
)
```

This new font system provides better consistency, readability, and maintainability across your entire app! 