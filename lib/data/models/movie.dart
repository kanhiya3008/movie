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
    return MovieCollectionResponse(
      movies: (json['movies'] as List? ?? [])
          .map((x) => Movie.fromJson(x ?? {}))
          .toList(),
      collection: Collection.fromJson(json['collection'] ?? {}),
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
    );
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
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      releaseDate: json['releaseDate'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      posterPath: json['posterPath'] ?? '',
      slug: json['slug'] ?? '',
      rating: json['rating'],
      trailerYtId: json['trailerYtId'],
      teaserYtId: json['teaserYtId'],
      audienceRating: json['audience_rating'] ?? '0.0',
      collections: (json['collections'] as List? ?? [])
          .map((x) => CollectionItem.fromJson(x ?? {}))
          .toList(),
      streamingPlatforms: (json['streamingPlatforms'] as List? ?? [])
          .map((x) => StreamingPlatform.fromJson(x ?? {}))
          .toList(),
      crew: (json['crew'] as List? ?? [])
          .map((x) => Crew.fromJson(x ?? {}))
          .toList(),
      cast: (json['cast'] as List? ?? [])
          .map((x) => Cast.fromJson(x ?? {}))
          .toList(),
    );
  }
}

class Collection {
  final int id;
  final String tag;
  final String name;

  Collection({required this.id, required this.tag, required this.name});

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] ?? 0,
      tag: json['tag'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class CollectionItem {
  final int movieId;
  final int priority;

  CollectionItem({required this.movieId, required this.priority});

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    return CollectionItem(
      movieId: json['movieId'] ?? 0,
      priority: json['priority'] ?? 0,
    );
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
    return StreamingPlatform(
      id: json['id'] ?? 0,
      iosUrl: json['iosUrl'] ?? '',
      androidUrl: json['androidUrl'] ?? '',
      webUrl: json['webUrl'] ?? '',
      type: json['type'] ?? '',
      movieId: json['movieId'] ?? 0,
      platformId: json['platformId'] ?? 0,
      platform: json['platform'] != null
          ? Platform.fromJson(json['platform'])
          : null,
      countries: (json['countries'] as List? ?? [])
          .map((x) => CountryAvailability.fromJson(x ?? {}))
          .toList(),
    );
  }
}

class Platform {
  final int id;
  final String name;
  final String logo;

  Platform({required this.id, required this.name, required this.logo});

  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
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
    return CountryAvailability(
      id: json['id'] ?? 0,
      countryId: json['countryId'] ?? 0,
      country: json['country'] != null
          ? Country.fromJson(json['country'])
          : null,
    );
  }
}

class Country {
  final int id;
  final String countryCode;
  final String name;

  Country({required this.id, required this.countryCode, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      countryCode: json['countryCode'] ?? '',
      name: json['name'] ?? '',
    );
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
    return Crew(
      id: json['id'] ?? 0,
      job: json['job'] ?? '',
      department: json['department'] ?? '',
      creditId: json['credit_id'] ?? '',
      person: Person.fromJson(json['person'] ?? {}),
    );
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
    return Cast(
      id: json['id'] ?? 0,
      castId: json['cast_id'] ?? 0,
      character: json['character'] ?? '',
      order: json['order'] ?? 0,
      person: Person.fromJson(json['person'] ?? {}),
    );
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
    return Person(
      adult: json['adult'] ?? false,
      gender: json['gender'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'],
      tmdbId: json['tmdb_id'] ?? 0,
      personId: json['person_id'] ?? 0,
    );
  }
}
