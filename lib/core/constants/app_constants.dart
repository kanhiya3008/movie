class AppConstants {
  // App Information
  static const String appName = 'StreamNest';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your ultimate streaming companion';

  // API Configuration
  static const String baseUrl = 'https://api.streamnest.com';
  static const String apiVersion = '/v1';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String profileEndpoint = '/user/profile';
  static const String moviesEndpoint = '/movies';
  static const String seriesEndpoint = '/series';
  static const String searchEndpoint = '/search';
  static const String favoritesEndpoint = '/favorites';
  static const String watchlistEndpoint = '/watchlist';
  static const String recommendationsEndpoint = '/recommendations';
  static const String genresEndpoint = '/genres';
  static const String trendingEndpoint = '/trending';
  static const String popularEndpoint = '/popular';
  static const String upcomingEndpoint = '/upcoming';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_completed';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  static const double defaultElevation = 4.0;
  static const double smallElevation = 2.0;
  static const double largeElevation = 8.0;

  // Image Placeholders
  static const String moviePlaceholder =
      'https://via.placeholder.com/300x450/6366F1/FFFFFF?text=Movie';
  static const String seriesPlaceholder =
      'https://via.placeholder.com/300x450/10B981/FFFFFF?text=Series';
  static const String userPlaceholder =
      'https://via.placeholder.com/100x100/6366F1/FFFFFF?text=User';
  static const String bannerPlaceholder =
      'https://via.placeholder.com/1200x400/6366F1/FFFFFF?text=Banner';

  // Video Quality Options
  static const List<String> videoQualities = [
    'Auto',
    '1080p',
    '720p',
    '480p',
    '360p',
  ];

  // Subtitle Languages
  static const List<String> subtitleLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
  ];

  // Audio Languages
  static const List<String> audioLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
  ];

  // Content Ratings
  static const List<String> contentRatings = [
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17',
    'TV-Y',
    'TV-Y7',
    'TV-G',
    'TV-PG',
    'TV-14',
    'TV-MA',
  ];

  // Genres
  static const List<String> movieGenres = [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'History',
    'Horror',
    'Music',
    'Mystery',
    'Romance',
    'Science Fiction',
    'Thriller',
    'War',
    'Western',
  ];

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String forbiddenError = 'Access denied.';
  static const String notFoundError = 'Resource not found.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String unknownError = 'An unknown error occurred.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String logoutSuccess = 'Logout successful!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  static const String favoriteAddedSuccess = 'Added to favorites!';
  static const String favoriteRemovedSuccess = 'Removed from favorites!';
  static const String watchlistAddedSuccess = 'Added to watchlist!';
  static const String watchlistRemovedSuccess = 'Removed from watchlist!';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength =
      'Password must be at least 8 characters';
  static const String passwordMaxLength =
      'Password must be less than 50 characters';
  static const String nameRequired = 'Name is required';
  static const String nameMinLength = 'Name must be at least 2 characters';
  static const String nameMaxLength = 'Name must be less than 50 characters';
  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // Onboarding Messages
  static const List<String> onboardingTitles = [
    'Welcome to StreamNest',
    'Discover Amazing Content',
    'Personalized Experience',
    'Start Streaming',
  ];

  static const List<String> onboardingDescriptions = [
    'Your ultimate streaming companion with thousands of movies and TV shows.',
    'Explore a vast library of content from around the world.',
    'Get personalized recommendations based on your preferences.',
    'Ready to start your streaming journey? Let\'s go!',
  ];
}
