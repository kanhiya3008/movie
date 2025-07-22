class FeedModel {
  final int id;
  final int userId;
  final String title;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? seenAt;
  final Movie? movie;
  final List<Author> authors;

  FeedModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.seenAt,
    required this.movie,
    required this.authors,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      seenAt: json['seenAt'] != null ? DateTime.tryParse(json['seenAt']) : null,
      movie: json['movie'] != null ? Movie.fromJson(json['movie']) : null,
      authors:
          (json['authors'] as List<dynamic>?)
              ?.map((e) => Author.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class MovieGenre {
  final int id;
  final String name;

  MovieGenre({required this.id, required this.name});

  factory MovieGenre.fromJson(Map<String, dynamic> json) {
    return MovieGenre(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class Author {
  final int id;
  final String email;
  final String? username;
  final String firstName;
  final String lastName;
  final String avatarUrl;

  Author({
    required this.id,
    required this.email,
    this.username,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}

class MovieCollectionResponse {
  final List<Movie> movies;
  final Collection collection;
  final int currentPage;
  final int pageSize;

  MovieCollectionResponse({
    required this.movies,
    required this.collection,
    required this.currentPage,
    required this.pageSize,
  });

  factory MovieCollectionResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Parse movies list
      final moviesList = json['movies'] as List? ?? [];
      final movies = moviesList.where((x) => x != null).map((x) {
        return Movie.fromJson(x);
      }).toList();

      // Parse collection
      final collection = Collection.fromJson(json['collection'] ?? {});

      // Parse currentPage
      final currentPage = json['currentPage'] is int
          ? json['currentPage']
          : int.tryParse(json['currentPage']?.toString() ?? '1') ?? 1;

      // Parse pageSize
      final pageSize = json['pageSize'] is int
          ? json['pageSize']
          : int.tryParse(json['pageSize']?.toString() ?? '20') ?? 20;

      return MovieCollectionResponse(
        movies: movies,
        collection: collection,
        currentPage: currentPage,
        pageSize: pageSize,
      );
    } catch (e, stackTrace) {
      rethrow;
    }
  }
}

class Movie {
  final int id;
  final String title;
  final String releaseDate;
  final String description;
  final int duration;
  final String posterPath;
  final String slug;
  final dynamic rating;
  final String? trailerYtId;
  final String? teaserYtId;
  final String audienceRating;
  final List<CollectionItem> collections;
  final List<StreamingPlatform> streamingPlatforms;
  final List<Crew> crew;
  final List<Cast> cast;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.description,
    required this.duration,
    required this.posterPath,
    required this.slug,
    this.rating,
    this.trailerYtId,
    this.teaserYtId,
    required this.audienceRating,
    required this.collections,
    required this.streamingPlatforms,
    required this.crew,
    required this.cast,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    try {
      // Parse basic fields
      final id = json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0;

      final title = json['title'] ?? 'No Title';

      final releaseDate = json['releaseDate'] ?? '';

      final description = json['description'] ?? '';

      final duration = json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? '0') ?? 0;

      final posterPath = json['posterPath'] ?? '';

      final slug = json['slug'] ?? '';

      final rating = json['rating'];

      final trailerYtId = json['trailerYtId'];

      final teaserYtId = json['teaserYtId'];

      final audienceRating = json['audience_rating'] ?? '0.0';

      // Parse collections
      final collectionsList = json['collections'] as List? ?? [];
      final collections = collectionsList.where((x) => x != null).map((x) {
        return CollectionItem.fromJson(x);
      }).toList();

      // Parse streaming platforms
      final streamingPlatformsList = json['streamingPlatforms'] as List? ?? [];
      final streamingPlatforms = streamingPlatformsList
          .where((x) => x != null)
          .map((x) {
            return StreamingPlatform.fromJson(x);
          })
          .toList();

      // Parse crew
      final crewList = json['crew'] as List? ?? [];
      final crew = crewList.where((x) => x != null).map((x) {
        return Crew.fromJson(x);
      }).toList();

      // Parse cast
      final castList = json['cast'] as List? ?? [];
      final cast = castList.where((x) => x != null).map((x) {
        return Cast.fromJson(x);
      }).toList();

      return Movie(
        id: id,
        title: title,
        releaseDate: releaseDate,
        description: description,
        duration: duration,
        posterPath: posterPath,
        slug: slug,
        rating: rating,
        trailerYtId: trailerYtId,
        teaserYtId: teaserYtId,
        audienceRating: audienceRating,
        collections: collections,
        streamingPlatforms: streamingPlatforms,
        crew: crew,
        cast: cast,
      );
    } catch (e, stackTrace) {
      rethrow;
    }
  }
}

class Collection {
  final int id;
  final String tag;
  final String name;

  Collection({required this.id, required this.tag, required this.name});

  factory Collection.fromJson(Map<String, dynamic> json) {
    try {
      return Collection(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        tag: json['tag'] ?? '',
        name: json['name'] ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }
}

class CollectionItem {
  final int movieId;
  final int priority;

  CollectionItem({required this.movieId, required this.priority});

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    try {
      return CollectionItem(
        movieId: json['movieId'] is int
            ? json['movieId']
            : int.tryParse(json['movieId']?.toString() ?? '0') ?? 0,
        priority: json['priority'] is int
            ? json['priority']
            : int.tryParse(json['priority']?.toString() ?? '0') ?? 0,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class StreamingPlatform {
  final int id;
  final String iosUrl;
  final String androidUrl;
  final String webUrl;
  final String type;
  final int movieId;
  final int platformId;
  final Platform? platform;
  final List<CountryAvailability> countries;

  StreamingPlatform({
    required this.id,
    required this.iosUrl,
    required this.androidUrl,
    required this.webUrl,
    required this.type,
    required this.movieId,
    required this.platformId,
    this.platform,
    required this.countries,
  });

  factory StreamingPlatform.fromJson(Map<String, dynamic> json) {
    try {
      return StreamingPlatform(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        iosUrl: json['iosUrl'] ?? '',
        androidUrl: json['androidUrl'] ?? '',
        webUrl: json['webUrl'] ?? '',
        type: json['type'] ?? '',
        movieId: json['movieId'] is int
            ? json['movieId']
            : int.tryParse(json['movieId']?.toString() ?? '0') ?? 0,
        platformId: json['platformId'] is int
            ? json['platformId']
            : int.tryParse(json['platformId']?.toString() ?? '0') ?? 0,
        platform: json['platform'] != null
            ? Platform.fromJson(json['platform'])
            : null,
        countries: (json['countries'] as List? ?? [])
            .where((x) => x != null)
            .map((x) => CountryAvailability.fromJson(x))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}

class Platform {
  final int id;
  final String name;
  final String logo;

  Platform({required this.id, required this.name, required this.logo});

  factory Platform.fromJson(Map<String, dynamic> json) {
    try {
      return Platform(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name'] ?? '',
        logo: json['logo'] ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }
}

class CountryAvailability {
  final int id;
  final int countryId;
  final Country? country;

  CountryAvailability({
    required this.id,
    required this.countryId,
    this.country,
  });

  factory CountryAvailability.fromJson(Map<String, dynamic> json) {
    try {
      return CountryAvailability(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        countryId: json['countryId'] is int
            ? json['countryId']
            : int.tryParse(json['countryId']?.toString() ?? '0') ?? 0,
        country: json['country'] != null
            ? Country.fromJson(json['country'])
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class Country {
  final int id;
  final String countryCode;
  final String name;

  Country({required this.id, required this.countryCode, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    try {
      return Country(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        countryCode: json['countryCode'] ?? '',
        name: json['name'] ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }
}

class Crew {
  final int id;
  final String job;
  final String department;
  final String creditId;
  final Person person;

  Crew({
    required this.id,
    required this.job,
    required this.department,
    required this.creditId,
    required this.person,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    try {
      return Crew(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        job: json['job'] ?? '',
        department: json['department'] ?? '',
        creditId: json['credit_id'] ?? '',
        person: Person.fromJson(json['person'] ?? {}),
      );
    } catch (e) {
      rethrow;
    }
  }
}

class Cast {
  final int id;
  final int castId;
  final String character;
  final int order;
  final Person person;

  Cast({
    required this.id,
    required this.castId,
    required this.character,
    required this.order,
    required this.person,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    try {
      return Cast(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        castId: json['cast_id'] is int
            ? json['cast_id']
            : int.tryParse(json['cast_id']?.toString() ?? '0') ?? 0,
        character: json['character'] ?? '',
        order: json['order'] is int
            ? json['order']
            : int.tryParse(json['order']?.toString() ?? '0') ?? 0,
        person: Person.fromJson(json['person'] ?? {}),
      );
    } catch (e) {
      rethrow;
    }
  }
}

class Person {
  final bool adult;
  final int gender;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final int tmdbId;
  final int personId;

  Person({
    required this.adult,
    required this.gender,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.tmdbId,
    required this.personId,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    try {
      return Person(
        adult: json['adult'] ?? false,
        gender: json['gender'] is int
            ? json['gender']
            : int.tryParse(json['gender']?.toString() ?? '0') ?? 0,
        knownForDepartment: json['known_for_department'] ?? '',
        name: json['name'] ?? '',
        originalName: json['original_name'] ?? '',
        popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
        profilePath: json['profile_path'],
        tmdbId: json['tmdb_id'] is int
            ? json['tmdb_id']
            : int.tryParse(json['tmdb_id']?.toString() ?? '0') ?? 0,
        personId: json['person_id'] is int
            ? json['person_id']
            : int.tryParse(json['person_id']?.toString() ?? '0') ?? 0,
      );
    } catch (e) {
      rethrow;
    }
  }
}
