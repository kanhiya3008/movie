import 'package:streamnest/data/models/collectionModel.dart';
import 'package:streamnest/data/models/movie.dart';
import '../datasources/streamnest_api_service.dart';

class MovieRepository {
  final StreamNestApiService _apiService;

  MovieRepository({StreamNestApiService? apiService})
    : _apiService = apiService ?? StreamNestApiService();

  Future<List<String>> fetchCollectionEndpoints() async {
    final response = await _apiService.get(
      'https://api.streamnest.tv/movies/user-collections',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = response.data;
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load collection endpoints");
    }
  }

  Future<MovieCollectionResponse> fetchCollection(String endpoint) async {
    final response = await _apiService.post(
      "https://api.streamnest.tv/movies/filter/$endpoint",
      {
        // "availability": null,
        // "genre": [],
        // "releaseYear": "",
        // "languages": [],
        // "rating": "",
        // "duration": "",
        // "ageSuitability": [],
        "limit": 20,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;

      if (data != null && data is Map<String, dynamic>) {
        return MovieCollectionResponse.fromJson(data);
      } else {
        throw Exception("Invalid data format received from server.");
      }
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  }

  /// Fetch movie details by slug
  Future<Movie> fetchMovieDetails(String slug) async {
    try {
      final response = await _apiService.getMovieDetails(slug);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data != null && data is Map<String, dynamic>) {
          return Movie.fromJson(data);
        } else {
          throw Exception(
            "Invalid movie details data format received from server.",
          );
        }
      } else {
        throw Exception(
          "Failed to fetch movie details: ${response.statusCode}",
        );
      }
    } catch (e) {
      print('Error in repository for movie details: $e');
      throw Exception("Network error: $e");
    }
  }

  /// Fetch similar movies for a given movie ID
  Future<List<Movie>> fetchSimilarMovies(String movieId) async {
    try {
      final response = await _apiService.getSimilarMovies(movieId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data != null &&
            data is Map<String, dynamic> &&
            data['movies'] != null) {
          final List<dynamic> moviesData = data['movies'];
          return moviesData.map((json) => Movie.fromJson(json)).toList();
        } else {
          // If the API returns a different format, try to parse as a list
          if (data is List) {
            return data.map((json) => Movie.fromJson(json)).toList();
          }
          throw Exception(
            "Invalid similar movies data format received from server.",
          );
        }
      } else {
        throw Exception(
          "Failed to fetch similar movies: ${response.statusCode}",
        );
      }
    } catch (e) {
      print('Error in repository for similar movies: $e');
      throw Exception("Network error: $e");
    }
  }

  /// Fetch cast information for a given movie ID
  Future<List<Cast>> fetchMovieCast(String movieId) async {
    try {
      final response = await _apiService.getMovieCast(movieId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data != null &&
            data is Map<String, dynamic> &&
            data['cast'] != null) {
          final List<dynamic> castData = data['cast'];
          return castData.map((json) => Cast.fromJson(json)).toList();
        } else {
          // If the API returns a different format, try to parse as a list
          if (data is List) {
            return data.map((json) => Cast.fromJson(json)).toList();
          }
          throw Exception("Invalid cast data format received from server.");
        }
      } else {
        throw Exception("Failed to fetch cast: ${response.statusCode}");
      }
    } catch (e) {
      print('Error in repository for cast: $e');
      throw Exception("Network error: $e");
    }
  }

  /// Fetch featured movies for carousel
  Future<List<Movie>> fetchFeaturedMovies() async {
    try {
      final response = await _apiService.getFeaturedMovies();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data != null &&
            data is Map<String, dynamic> &&
            data['movies'] != null) {
          final List<dynamic> moviesData = data['movies'];
          return moviesData.map((json) => Movie.fromJson(json)).toList();
        } else {
          // If the API returns a different format, try to parse as a list
          if (data is List) {
            return data.map((json) => Movie.fromJson(json)).toList();
          }
          throw Exception(
            "Invalid featured movies data format received from server.",
          );
        }
      } else {
        throw Exception(
          "Failed to fetch featured movies: ${response.statusCode}",
        );
      }
    } catch (e) {
      print('Error in repository for featured movies: $e');
      throw Exception("Network error: $e");
    }
  }
}
