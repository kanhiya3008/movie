class Movie {
  final String id;
  final String title;
  final String overview;
  final String posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final DateTime releaseDate;
  final List<String> genres;
  final String originalLanguage;
  final String originalTitle;
  final bool adult;
  final String? tagline;
  final int runtime;
  final List<String> productionCompanies;
  final List<String> productionCountries;
  final List<String> spokenLanguages;
  final double popularity;
  final String status;
  final double? budget;
  final double? revenue;
  final Map<String, dynamic> videos;
  final Map<String, dynamic> credits;
  final List<String> keywords;
  final List<String> recommendations;
  final bool isFavorite;
  final bool isInWatchlist;
  final DateTime? lastWatched;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genres,
    required this.originalLanguage,
    required this.originalTitle,
    required this.adult,
    this.tagline,
    required this.runtime,
    required this.productionCompanies,
    required this.productionCountries,
    required this.spokenLanguages,
    required this.popularity,
    required this.status,
    this.budget,
    this.revenue,
    required this.videos,
    required this.credits,
    required this.keywords,
    required this.recommendations,
    this.isFavorite = false,
    this.isInWatchlist = false,
    this.lastWatched,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    int? voteCount,
    DateTime? releaseDate,
    List<String>? genres,
    String? originalLanguage,
    String? originalTitle,
    bool? adult,
    String? tagline,
    int? runtime,
    List<String>? productionCompanies,
    List<String>? productionCountries,
    List<String>? spokenLanguages,
    double? popularity,
    String? status,
    double? budget,
    double? revenue,
    Map<String, dynamic>? videos,
    Map<String, dynamic>? credits,
    List<String>? keywords,
    List<String>? recommendations,
    bool? isFavorite,
    bool? isInWatchlist,
    DateTime? lastWatched,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      adult: adult ?? this.adult,
      tagline: tagline ?? this.tagline,
      runtime: runtime ?? this.runtime,
      productionCompanies: productionCompanies ?? this.productionCompanies,
      productionCountries: productionCountries ?? this.productionCountries,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      popularity: popularity ?? this.popularity,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      videos: videos ?? this.videos,
      credits: credits ?? this.credits,
      keywords: keywords ?? this.keywords,
      recommendations: recommendations ?? this.recommendations,
      isFavorite: isFavorite ?? this.isFavorite,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      lastWatched: lastWatched ?? this.lastWatched,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
      'releaseDate': releaseDate.toIso8601String(),
      'genres': genres,
      'originalLanguage': originalLanguage,
      'originalTitle': originalTitle,
      'adult': adult,
      'tagline': tagline,
      'runtime': runtime,
      'productionCompanies': productionCompanies,
      'productionCountries': productionCountries,
      'spokenLanguages': spokenLanguages,
      'popularity': popularity,
      'status': status,
      'budget': budget,
      'revenue': revenue,
      'videos': videos,
      'credits': credits,
      'keywords': keywords,
      'recommendations': recommendations,
      'isFavorite': isFavorite,
      'isInWatchlist': isInWatchlist,
      'lastWatched': lastWatched?.toIso8601String(),
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['posterPath'] as String,
      backdropPath: json['backdropPath'] as String?,
      voteAverage: (json['voteAverage'] as num).toDouble(),
      voteCount: json['voteCount'] as int,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      genres: List<String>.from(json['genres'] as List),
      originalLanguage: json['originalLanguage'] as String,
      originalTitle: json['originalTitle'] as String,
      adult: json['adult'] as bool,
      tagline: json['tagline'] as String?,
      runtime: json['runtime'] as int,
      productionCompanies: List<String>.from(
        json['productionCompanies'] as List,
      ),
      productionCountries: List<String>.from(
        json['productionCountries'] as List,
      ),
      spokenLanguages: List<String>.from(json['spokenLanguages'] as List),
      popularity: (json['popularity'] as num).toDouble(),
      status: json['status'] as String,
      budget: json['budget'] as double?,
      revenue: json['revenue'] as double?,
      videos: Map<String, dynamic>.from(json['videos'] as Map),
      credits: Map<String, dynamic>.from(json['credits'] as Map),
      keywords: List<String>.from(json['keywords'] as List),
      recommendations: List<String>.from(json['recommendations'] as List),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isInWatchlist: json['isInWatchlist'] as bool? ?? false,
      lastWatched: json['lastWatched'] != null
          ? DateTime.parse(json['lastWatched'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, voteAverage: $voteAverage)';
  }
}
