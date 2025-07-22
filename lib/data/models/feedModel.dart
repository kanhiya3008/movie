// import 'package:streamnest/data/models/movie.dart';

// class FeedModel {
//   final int id;
//   final int userId;
//   final String title;
//   final String content;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final DateTime? seenAt;
//   final Movie? movie;
//   final List<Author> authors;

//   FeedModel({
//     required this.id,
//     required this.userId,
//     required this.title,
//     required this.content,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.seenAt,
//     required this.movie,
//     required this.authors,
//   });

//   factory FeedModel.fromJson(Map<String, dynamic> json) {
//     return FeedModel(
//       id: json['id'] ?? 0,
//       userId: json['userId'] ?? 0,
//       title: (json['title'] ?? '').toString(),
//       content: (json['content'] ?? '').toString(),
//       createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
//       seenAt: json['seenAt'] != null ? DateTime.tryParse(json['seenAt']) : null,
//       movie: json['movie'] != null ? Movie.fromJson(json['movie']) : null,
//       authors: (json['authors'] as List?)
//               ?.map((e) => Author.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userId': userId,
//       'title': title,
//       'content': content,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       'seenAt': seenAt?.toIso8601String(),
//       'movie': movie?.toJson(),
//       'authors': authors.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class Movie {
//   final int id;
//   final String title;
//   final String? releaseDate;
//   final String description;
//   final int duration;
//   final String posterPath;
//   final String slug;
//   final int tmdbId;
//   final String imdbId;
//   final String imdbRating;
//   final String rottenTomatoRating;
//   final String rating;
//   final String metacriticRating;
//   final String trailerYtId;
//   final String teaserYtId;
//   final bool adult;
//   final List<Cast> cast;
//   final List<MovieGenre> movieGenres;
//    final List<StreamingPlatform> streamingPlatforms;

//   Movie({
//     required this.id,
//     required this.title,
//     this.releaseDate,
//     required this.description,
//     required this.duration,
//     required this.posterPath,
//     required this.slug,
//     required this.tmdbId,
//     required this.imdbId,
//     required this.imdbRating,
//     required this.rottenTomatoRating,
//     required this.rating,
//     required this.metacriticRating,
//     required this.trailerYtId,
//     required this.teaserYtId,
//     required this.adult,
//     required this.cast,
//     required this.movieGenres,
//     required this.streamingPlatforms,
//   });

//   factory Movie.fromJson(Map<String, dynamic> json) {
//     return Movie(
//       id: json['id'] ?? 0,
//       title: (json['title'] ?? '').toString(),
//       releaseDate: json['releaseDate']?.toString(),
//       description: (json['description'] ?? '').toString(),
//       duration: json['duration'] ?? 0,
//       posterPath: (json['posterPath'] ?? '').toString(),
//       slug: (json['slug'] ?? '').toString(),
//       tmdbId: json['tmdbId'] ?? 0,
//       imdbId: (json['imdbId'] ?? '').toString(),
//       imdbRating: (json['imdbRating'] ?? '').toString(),
//       rottenTomatoRating: (json['rottenTomatoRating'] ?? '').toString(),
//       rating: (json['rating'] ?? '').toString(),
//       metacriticRating: (json['metacriticRating'] ?? '').toString(),
//       trailerYtId: (json['trailerYtId'] ?? '').toString(),
//       teaserYtId: (json['teaserYtId'] ?? '').toString(),
//       adult: json['adult'] ?? false,
//       cast: (json['cast'] as List?)
//               ?.map((e) => Cast.fromJson(e))
//               .toList() ??
//           [],
//       movieGenres: (json['movieGenres'] as List?)
//               ?.map((e) => MovieGenre.fromJson(e))
//               .toList() ??
//           [],
//         streamingPlatformsList = (json['streamingPlatforms'] as List?)
//               ?.map((e) => StreamingPlatform.fromJson(e))
//               .toList() ??
//           [],

//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'releaseDate': releaseDate,
//       'description': description,
//       'duration': duration,
//       'posterPath': posterPath,
//       'slug': slug,
//       'tmdbId': tmdbId,
//       'imdbId': imdbId,
//       'imdbRating': imdbRating,
//       'rottenTomatoRating': rottenTomatoRating,
//       'rating': rating,
//       'metacriticRating': metacriticRating,
//       'trailerYtId': trailerYtId,
//       'teaserYtId': teaserYtId,
//       'adult': adult,
//       'cast': cast.map((e) => e.toJson()).toList(),
//       'movieGenres': movieGenres.map((e) => e.toJson()).toList(),
//       'streamingPlatforms': streamingPlatforms.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class Cast {
//   final int id;
//   final String name;
//   final String character;
//   final String? profilePath;
//   final int order;

//   Cast({
//     required this.id,
//     required this.name,
//     required this.character,
//     this.profilePath,
//     required this.order,
//   });

//   factory Cast.fromJson(Map<String, dynamic> json) {
//     return Cast(
//       id: json['id'] ?? 0,
//       name: (json['name'] ?? '').toString(),
//       character: (json['character'] ?? '').toString(),
//       profilePath: json['profile_path']?.toString(),
//       order: json['order'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'character': character,
//       'profile_path': profilePath,
//       'order': order,
//     };
//   }
// }

// class MovieGenre {
//   final int id;
//   final String name;

//   MovieGenre({
//     required this.id,
//     required this.name,
//   });

//   factory MovieGenre.fromJson(Map<String, dynamic> json) {
//     return MovieGenre(
//       id: json['id'] ?? 0,
//       name: (json['name'] ?? '').toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }

// class Author {
//   final int id;
//   final String email;
//   final String? username;
//   final String firstName;
//   final String lastName;
//   final String avatarUrl;

//   Author({
//     required this.id,
//     required this.email,
//     this.username,
//     required this.firstName,
//     required this.lastName,
//     required this.avatarUrl,
//   });

//   factory Author.fromJson(Map<String, dynamic> json) {
//     return Author(
//       id: json['id'] ?? 0,
//       email: (json['email'] ?? '').toString(),
//       username: json['username']?.toString(),
//       firstName: (json['firstName'] ?? '').toString(),
//       lastName: (json['lastName'] ?? '').toString(),
//       avatarUrl: (json['avatarUrl'] ?? '').toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'username': username,
//       'firstName': firstName,
//       'lastName': lastName,
//       'avatarUrl': avatarUrl,
//     };
//   }
// }
