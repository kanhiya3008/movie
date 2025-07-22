import 'package:flutter/foundation.dart';
import '../../data/repositories/movie_repository.dart';
import '../../data/models/movie.dart';
import '../../data/models/feedModel.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepository _repository;

  // State variables
  List<String> _collectionEndpoints = [];
  Map<String, MovieCollectionResponse> _collections = {};
  bool _isLoading = false;
  String? _error;

  // Movie details state
  Movie? _movieDetails;
  bool _isLoadingMovieDetails = false;
  String? _movieDetailsError;

  // Similar movies state
  List<Movie> _similarMovies = [];
  bool _isLoadingSimilar = false;
  String? _similarError;

  List<FeedModel> _feedItems = [];
  bool _isLoadingFeed = false;
  String? _feedError;

  // Cast state
  List<Cast> _movieCast = [];
  bool _isLoadingCast = false;
  String? _castError;

  // Featured movies state
  List<Movie> _featuredMovies = [];
  bool _isLoadingFeatured = false;
  String? _featuredError;

  // Hero filter movies state
  List<Movie> _heroFilterMovies = [];
  bool _isLoadingHeroFilter = false;
  String? _heroFilterError;

  MovieProvider({MovieRepository? repository})
    : _repository = repository ?? MovieRepository();

  // Getters
  List<String> get collectionEndpoints => _collectionEndpoints;
  Map<String, MovieCollectionResponse> get collections => _collections;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Movie details getters
  Movie? get movieDetails => _movieDetails;
  bool get isLoadingMovieDetails => _isLoadingMovieDetails;
  String? get movieDetailsError => _movieDetailsError;

  // Similar movies getters
  List<Movie> get similarMovies => _similarMovies;
  bool get isLoadingSimilar => _isLoadingSimilar;
  String? get similarError => _similarError;

  List<FeedModel> get feedItems => _feedItems;
  // Remove the feedMovies getter, as FeedModel already exposes .movie
  // If you want to keep it:
  List<Movie> get feedMovies =>
      _feedItems.map((f) => f.movie).whereType<Movie>().toList();

  bool get isLoadingFeed => _isLoadingFeed;
  String? get feedError => _feedError;

  // Cast getters
  List<Cast> get movieCast => _movieCast;
  bool get isLoadingCast => _isLoadingCast;
  String? get castError => _castError;

  // Featured movies getters
  List<Movie> get featuredMovies => _featuredMovies;
  bool get isLoadingFeatured => _isLoadingFeatured;
  String? get featuredError => _featuredError;

  // Hero filter movies getters
  List<Movie> get heroFilterMovies => _heroFilterMovies;
  bool get isLoadingHeroFilter => _isLoadingHeroFilter;
  String? get heroFilterError => _heroFilterError;

  /// Load all collection endpoints
  Future<void> loadCollectionEndpoints() async {
    setLoading(true);
    _clearError();

    try {
      _collectionEndpoints = await _repository.fetchCollectionEndpoints();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Load all collections with their movies
  Future<void> loadAllCollections() async {
    setLoading(true);
    _clearError();

    try {
      // First get all collection endpoints
      _collectionEndpoints = await _repository.fetchCollectionEndpoints();

      // Then fetch each collection
      for (final endpoint in _collectionEndpoints) {
        try {
          final collection = await _repository.fetchCollection(endpoint);
          _collections[endpoint] = collection;
        } catch (e) {
          print('Error fetching collection $endpoint: $e');
          // Continue with other collections even if one fails
        }
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Load all collections with filter parameters
  Future<void> loadAllCollectionsWithFilters(
    Map<String, dynamic> filterParams,
  ) async {
    setLoading(true);
    _clearError();

    print('🎯 Filter parameters received: $filterParams');

    try {
      // First get all collection endpoints
      print('🔍 Fetching collection endpoints from user_collections API...');
      _collectionEndpoints = await _repository.fetchCollectionEndpoints();
      print(
        '📋 Found ${_collectionEndpoints.length} collection endpoints: $_collectionEndpoints',
      );

      // Then fetch each collection with filters
      print('🚀 Starting to fetch all collections with filters...');
      for (final endpoint in _collectionEndpoints) {
        try {
          print('📡 Calling fetchCollection for endpoint: $endpoint');
          final collection = await _repository.fetchCollection(
            endpoint,
            filterParams: filterParams,
          );
          _collections[endpoint] = collection;
          print('✅ Successfully fetched collection for: $endpoint');
        } catch (e) {
          print('❌ Error fetching collection $endpoint: $e');
          // Continue with other collections even if one fails
        }
      }

      print(
        '🎉 All collections fetched! Total collections: ${_collections.length}',
      );
      notifyListeners();
    } catch (e) {
      print('💥 Error in loadAllCollectionsWithFilters: $e');
      _setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Load movie details by slug
  Future<void> loadMovieDetails(String slug) async {
    _setLoadingMovieDetails(true);
    _clearMovieDetailsError();

    try {
      _movieDetails = await _repository.fetchMovieDetails(slug);
      notifyListeners();
    } catch (e) {
      _setMovieDetailsError(e.toString());
    } finally {
      _setLoadingMovieDetails(false);
    }
  }

  /// Load similar movies for a given movie ID
  Future<void> loadSimilarMovies(String movieId) async {
    _setLoadingSimilar(true);
    _clearSimilarError();

    try {
      _similarMovies = await _repository.fetchSimilarMovies(movieId);
      notifyListeners();
    } catch (e) {
      _setSimilarError(e.toString());
    } finally {
      _setLoadingSimilar(false);
    }
  }

  Future<void> loadFeedMovies(Map<String, dynamic> filterParams) async {
    _setLoadingFeed(true);
    _clearFeedError();

    try {
      _feedItems = await _repository.fetchFeedMovies(filterParams);
      print('Feed items loaded:');
      print(_feedItems);
      notifyListeners();
    } catch (e) {
      _setFeedError(e.toString());
    } finally {
      _setLoadingFeed(false);
    }
  }

  /// Load cast information for a given movie ID
  Future<void> loadMovieCast(String movieId) async {
    _setLoadingCast(true);
    _clearCastError();

    try {
      _movieCast = await _repository.fetchMovieCast(movieId);
      notifyListeners();
    } catch (e) {
      _setCastError(e.toString());
    } finally {
      _setLoadingCast(false);
    }
  }

  /// Load featured movies for carousel
  Future<void> loadFeaturedMovies() async {
    _setLoadingFeatured(true);
    _clearFeaturedError();

    try {
      _featuredMovies = await _repository.fetchFeaturedMovies();
      notifyListeners();
    } catch (e) {
      _setFeaturedError(e.toString());
    } finally {
      _setLoadingFeatured(false);
    }
  }

  /// Load hero filter movies
  Future<void> loadHeroFilterMovies(Map<String, dynamic> filterParams) async {
    _setLoadingHeroFilter(true);
    _clearHeroFilterError();

    try {
      _heroFilterMovies = await _repository.fetchHeroFilterMovies(filterParams);
      notifyListeners();
    } catch (e) {
      _setHeroFilterError(e.toString());
    } finally {
      _setLoadingHeroFilter(false);
    }
  }

  /// Load hero filter movies with filter parameters
  Future<void> loadHeroFilterMoviesWithFilters(
    Map<String, dynamic> filterParams,
  ) async {
    _setLoadingHeroFilter(true);
    _clearHeroFilterError();

    try {
      print('🎯 Loading hero filter movies with filter params: $filterParams');
      _heroFilterMovies = await _repository.fetchHeroFilterMovies(filterParams);
      print(
        '✅ Successfully loaded ${_heroFilterMovies.length} hero filter movies',
      );
      notifyListeners();
    } catch (e) {
      print('❌ Error loading hero filter movies: $e');
      _setHeroFilterError(e.toString());
    } finally {
      _setLoadingHeroFilter(false);
    }
  }

  /// Clear error
  void _clearError() {
    _error = null;
  }

  /// Set error
  void _setError(String error) {
    _error = error;
  }

  /// Clear movie details error
  void _clearMovieDetailsError() {
    _movieDetailsError = null;
  }

  /// Set movie details error
  void _setMovieDetailsError(String error) {
    _movieDetailsError = error;
  }

  /// Clear similar movies error
  void _clearSimilarError() {
    _similarError = null;
  }

  void _clearFeedError() {
    _feedError = null;
  }

  /// Set similar movies error
  void _setSimilarError(String error) {
    _similarError = error;
  }

  void _setFeedError(String error) {
    _feedError = error;
  }

  /// Clear cast error
  void _clearCastError() {
    _castError = null;
  }

  /// Set cast error
  void _setCastError(String error) {
    _castError = error;
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set movie details loading state
  void _setLoadingMovieDetails(bool loading) {
    _isLoadingMovieDetails = loading;
    notifyListeners();
  }

  /// Set similar movies loading state
  void _setLoadingSimilar(bool loading) {
    _isLoadingSimilar = loading;
    notifyListeners();
  }

  /// Set feed movies loading state
  void _setLoadingFeed(bool loading) {
    _isLoadingFeed = loading;
    notifyListeners();
  }

  /// Set cast loading state
  void _setLoadingCast(bool loading) {
    _isLoadingCast = loading;
    notifyListeners();
  }

  /// Clear featured movies error
  void _clearFeaturedError() {
    _featuredError = null;
  }

  /// Set featured movies error
  void _setFeaturedError(String error) {
    _featuredError = error;
  }

  /// Set featured movies loading state
  void _setLoadingFeatured(bool loading) {
    _isLoadingFeatured = loading;
    notifyListeners();
  }

  /// Clear hero filter error
  void _clearHeroFilterError() {
    _heroFilterError = null;
  }

  /// Set hero filter error
  void _setHeroFilterError(String error) {
    _heroFilterError = error;
  }

  /// Set hero filter loading state
  void _setLoadingHeroFilter(bool loading) {
    _isLoadingHeroFilter = loading;
    notifyListeners();
  }
}
