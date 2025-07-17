import 'package:flutter/foundation.dart';
import '../../data/repositories/movie_repository.dart';
import '../../data/models/movie.dart';

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

  // Cast state
  List<Cast> _movieCast = [];
  bool _isLoadingCast = false;
  String? _castError;

  // Featured movies state
  List<Movie> _featuredMovies = [];
  bool _isLoadingFeatured = false;
  String? _featuredError;

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

  // Cast getters
  List<Cast> get movieCast => _movieCast;
  bool get isLoadingCast => _isLoadingCast;
  String? get castError => _castError;

  // Featured movies getters
  List<Movie> get featuredMovies => _featuredMovies;
  bool get isLoadingFeatured => _isLoadingFeatured;
  String? get featuredError => _featuredError;

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

  /// Set similar movies error
  void _setSimilarError(String error) {
    _similarError = error;
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
}
