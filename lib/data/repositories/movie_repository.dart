import 'package:streamnest/data/models/collectionModel.dart';
import 'package:streamnest/data/models/movie.dart';
import 'package:streamnest/data/models/feedModel.dart';
import '../datasources/streamnest_api_service.dart';

class MovieRepository {
  final StreamNestApiService _apiService;

  MovieRepository({StreamNestApiService? apiService})
    : _apiService = apiService ?? StreamNestApiService();

  Future<List<String>> fetchCollectionEndpoints() async {
    print('🌐 Calling user-collections API to get endpoints...');
    final response = await _apiService.get(
      'https://api.streamnest.tv/movies/user-collections',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = response.data;
      final endpoints = data.map((e) => e.toString()).toList();
      print('📋 Received endpoints from user-collections API: $endpoints');
      return endpoints;
    } else {
      print('❌ Failed to load collection endpoints: ${response.statusCode}');
      throw Exception("Failed to load collection endpoints");
    }
  }

  Future<MovieCollectionResponse> fetchCollection(
    String endpoint, {
    Map<String, dynamic>? filterParams,
  }) async {
    // Default request body
    final requestBody = {
      "ageSuitability": null,
      "availability": {
        "filter": filterParams?['availability']?['filter'] ?? "",
        "platforms": filterParams?['availability']?['platforms'] ?? [],
        "modifications": filterParams?['availability']?['modifications'] ?? [],
      },
      "duration": filterParams?['duration'] ?? null,
      "genre": filterParams?['genre'] ?? null,
      "languages": filterParams?['languages'] ?? [],
      "rating": filterParams?['rating'] ?? null,
      "limit": 20,
    };

    // Debug print to see what's being sent
    print('Request body: $requestBody');

    final response = await _apiService.post(
      "https://api.streamnest.tv/movies/filter/$endpoint",
      requestBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;

      if (data != null && data is Map<String, dynamic>) {
        try {
          // // Check if movies key exists and its type
          // if (data.containsKey('movies')) {
          //   print('Movies key exists, type: ${data['movies'].runtimeType}');
          //   if (data['movies'] is List) {
          //     print('Movies list length: ${(data['movies'] as List).length}');
          //   }
          // }

          // // Check if collection key exists
          // if (data.containsKey('collection')) {
          //   print(
          //     'Collection key exists, type: ${data['collection'].runtimeType}',
          //   );
          // }

          final result = MovieCollectionResponse.fromJson(data);
          //  print('Successfully parsed MovieCollectionResponse for $endpoint');
          return result;
        } catch (e, stackTrace) {
          // print('Error parsing MovieCollectionResponse for $endpoint: $e');
          // print('Stack trace: $stackTrace');
          // print('Data structure: $data');
          throw Exception("Failed to parse collection response: $e");
        }
      } else {
        // print(
        //   'Invalid data format for $endpoint. Expected Map, got: ${data.runtimeType}',
        // );
        throw Exception("Invalid data format received from server.");
      }
    } else {
      // print('API error for $endpoint: ${response.statusCode}');
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

  Future<List<FeedModel>> fetchFeedMovies(
    Map<String, dynamic> filterParams,
  ) async {
    try {
      // Create the same request body structure as fetchCollection
      final requestBody = {
        "ageSuitability": filterParams['ageSuitability'] ?? null,
        "availability": {
          "filter": filterParams['availability']?['filter'] ?? "",
          "platforms": filterParams['availability']?['platforms'] ?? [],
          "modifications": filterParams['availability']?['modifications'] ?? [],
        },
        "duration": filterParams['duration'] ?? null,
        "genre": filterParams['genre'] ?? null,
        "languages": filterParams['languages'] ?? [],
        "rating": filterParams['rating'] ?? null,
        "limit": 20,
      };

      print('Fetching feed movies with request body: $requestBody');

      final response = await _apiService.post('/feed', requestBody);

      final data = response.data;
      print('Raw feed response:');
      print(data);
      print('Type of data: ${data.runtimeType}');

      if (data is List) {
        return data.map((item) => FeedModel.fromJson(item)).toList();
      } else {
        throw Exception(
          "Feed API did not return a list. Type: ${data?.runtimeType}",
        );
      }
    } catch (e) {
      print('Error in repository for feed movies: $e');
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

  /// Fetch hero filter movies
  Future<List<Movie>> fetchHeroFilterMovies(
    Map<String, dynamic> filterParams,
  ) async {
    try {
      // Create the same request body structure as fetchCollection
      final requestBody = {
        "ageSuitability": filterParams['ageSuitability'] ?? null,
        "availability": {
          "filter": filterParams['availability']?['filter'] ?? "",
          "platforms": filterParams['availability']?['platforms'] ?? [],
          "modifications": filterParams['availability']?['modifications'] ?? [],
        },
        "duration": filterParams['duration'] ?? null,
        "genre": filterParams['genre'] ?? null,
        "languages": filterParams['languages'] ?? [],
        "rating": filterParams['rating'] ?? null,
        "limit": 20,
      };

      print('Fetching hero filter movies with request body: $requestBody');

      final response = await _apiService.post(
        '/movies/filter/hero',
        requestBody,
      );

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
            "Invalid hero filter movies data format received from server.",
          );
        }
      } else {
        throw Exception(
          "Failed to fetch hero filter movies: ${response.statusCode}",
        );
      }
    } catch (e) {
      print('Error in repository for hero filter movies: $e');
      throw Exception("Network error: $e");
    }
  }
}
