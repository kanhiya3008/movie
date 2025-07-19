import 'dart:convert';
import 'package:dio/dio.dart';

class StreamNestApiService {
  final Dio _dio;

  StreamNestApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.streamnest.tv',
              connectTimeout: Duration(seconds: 30), // Increased timeout
              receiveTimeout: Duration(seconds: 30), // Increased timeout
              headers: {
                'Content-Type': 'application/json',
                // Add other default headers here (e.g., auth)
              },
            ),
          );

  Future<Response> get(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch app initialization data including filters
  Future<Response> getAppInitData() async {
    try {
      print('Fetching app initialization data');
      print('URL: https://api.streamnest.tv/appinit');
      return await _dio.get('/appinit');
    } catch (e) {
      print('DioException for app init data: $e');
      rethrow;
    }
  }

  /// Fetch movie details by slug
  Future<Response> getMovieDetails(String slug) async {
    try {
      print('Fetching movie details for slug: $slug');
      print('URL: https://api.streamnest.tv/movies/$slug');
      return await _dio.get('/movies/$slug');
    } catch (e) {
      print('DioException for movie details: $e');
      rethrow;
    }
  }

  /// Fetch similar movies for a given movie ID
  Future<Response> getSimilarMovies(String movieId) async {
    try {
      print('Fetching similar movies for movie: $movieId');
      print('URL: https://api.streamnest.tv/movies/$movieId/similar');
      return await _dio.get('/movies/$movieId/similar');
    } catch (e) {
      print('DioException for similar movies: $e');
      rethrow;
    }
  }

  /// Fetch cast information for a given movie ID
  Future<Response> getMovieCast(String movieId) async {
    try {
      print('Fetching cast for movie: $movieId');
      print('URL: https://api.streamnest.tv/movies/$movieId/cast');
      return await _dio.get('/movies/$movieId/cast');
    } catch (e) {
      print('DioException for cast: $e');
      rethrow;
    }
  }

  /// Fetch featured movies for carousel
  Future<Response> getFeaturedMovies() async {
    try {
      print('Fetching featured movies for carousel');
      print('URL: https://api.streamnest.tv/movies/featured');
      return await _dio.get('/movies/featured');
    } catch (e) {
      print('DioException for featured movies: $e');
      rethrow;
    }
  }

  /// Fetch hero filter movies
  Future<Response> getHeroFilterMovies(
    Map<String, dynamic> filterParams,
  ) async {
    try {
      print('Fetching hero filter movies');
      print('URL: https://api.streamnest.tv/movies/filter/hero');
      print('Filter params: $filterParams');
      return await _dio.post('/movies/filter/hero', data: filterParams);
    } catch (e) {
      print('DioException for hero filter movies: $e');
      rethrow;
    }
  }
}
