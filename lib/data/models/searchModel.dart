import 'package:streamnest/data/models/movie.dart';

class SearchModel {
  final List<Movie> movies;
  final List<String> tags;
  final List<SearchCastMember> castMembers;

  SearchModel({
    required this.movies,
    required this.tags,
    required this.castMembers,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      movies:
          (json['movies'] as List?)?.map((e) => Movie.fromJson(e)).toList() ??
          [],
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      castMembers:
          (json['castMembers'] as List?)
              ?.map((e) => SearchCastMember.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'movies': movies.map((e) => e.toJson()).toList(),
  //     'tags': tags,
  //     'castMembers': castMembers.map((e) => e.toJson()).toList(),
  //   };
  // }
}

// class SearchMovie {
//   final int id;
//   final String title;
//   final String posterPath;
//   final String slug;
//   final double rank;

//   SearchMovie({
//     required this.id,
//     required this.title,
//     required this.posterPath,
//     required this.slug,
//     required this.rank,
//   });

//   factory SearchMovie.fromJson(Map<String, dynamic> json) {
//     return SearchMovie(
//       id: json['id'] ?? 0,
//       title: (json['title'] ?? '').toString(),
//       posterPath: (json['posterPath'] ?? '').toString(),
//       slug: (json['slug'] ?? '').toString(),
//       rank: (json['rank'] is num) ? json['rank'].toDouble() : 0.0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'posterPath': posterPath,
//       'slug': slug,
//       'rank': rank,
//     };
//   }
// }

class SearchCastMember {
  final int id;
  final int tmdbId;
  final String name;
  final String? profilePath;

  SearchCastMember({
    required this.id,
    required this.tmdbId,
    required this.name,
    this.profilePath,
  });

  factory SearchCastMember.fromJson(Map<String, dynamic> json) {
    return SearchCastMember(
      id: json['id'] ?? 0,
      tmdbId: json['tmdbId'] ?? 0,
      name: (json['name'] ?? '').toString(),
      profilePath: json['profilePath']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tmdbId': tmdbId,
      'name': name,
      'profilePath': profilePath,
    };
  }
}
