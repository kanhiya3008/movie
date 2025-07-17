class FilterModelResponse {
  FilterModelResponse({this.status, this.message, this.data});

  final bool? status;
  final String? message;
  final Data? data;

  factory FilterModelResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FilterModelResponse();
    return FilterModelResponse(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.countries,
    this.detectedCountryCode,
    this.streamingPlatforms,
    this.railType,
    this.genres,
    this.genresV1,
    this.characteristics,
    this.filter,
  });

  final List<DataCountry>? countries;
  final String? detectedCountryCode;
  final List<StreamingPlatform>? streamingPlatforms;
  final List<String>? railType;
  final List<Characteristic>? genres;
  final List<GenresV1>? genresV1;
  final List<Characteristic>? characteristics;
  final Filter? filter;

  factory Data.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Data();
    return Data(
      countries: (json["countries"] as List?)
          ?.map((x) => DataCountry.fromJson(x))
          .toList(),
      detectedCountryCode: json["detectedCountryCode"],
      streamingPlatforms: (json["streamingPlatforms"] as List?)
          ?.map((x) => StreamingPlatform.fromJson(x))
          .toList(),
      railType: (json["railType"] as List?)?.map((x) => x.toString()).toList(),
      genres: (json["genres"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
      genresV1: (json["genresV1"] as List?)
          ?.map((x) => GenresV1.fromJson(x))
          .toList(),
      characteristics: (json["characteristics"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
      filter: json["filter"] == null ? null : Filter.fromJson(json["filter"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "countries": countries?.map((x) => x.toJson()).toList(),
    "detectedCountryCode": detectedCountryCode,
    "streamingPlatforms": streamingPlatforms?.map((x) => x.toJson()).toList(),
    "railType": railType,
    "genres": genres?.map((x) => x.toJson()).toList(),
    "genresV1": genresV1?.map((x) => x.toJson()).toList(),
    "characteristics": characteristics?.map((x) => x.toJson()).toList(),
    "filter": filter?.toJson(),
  };
}

class Characteristic {
  Characteristic({this.label, this.value});

  final String? label;
  final String? value;

  factory Characteristic.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Characteristic();
    return Characteristic(label: json["label"], value: json["value"]);
  }

  Map<String, dynamic> toJson() => {"label": label, "value": value};
}

class DataCountry {
  DataCountry({this.id, this.countryCode, this.name});

  final int? id;
  final String? countryCode;
  final String? name;

  factory DataCountry.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DataCountry();
    return DataCountry(
      id: json["id"],
      countryCode: json["countryCode"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "countryCode": countryCode,
    "name": name,
  };
}

class Filter {
  Filter({
    this.genres,
    this.genresV1,
    this.languages,
    this.ageSuitability,
    this.duration,
    this.availability,
    this.releaseYears,
    this.ratings,
  });

  final List<Characteristic>? genres;
  final List<GenresV1>? genresV1;
  final List<Characteristic>? languages;
  final List<Characteristic>? ageSuitability;
  final List<Characteristic>? duration;
  final List<Characteristic>? availability;
  final List<Characteristic>? releaseYears;
  final List<Characteristic>? ratings;

  factory Filter.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Filter();
    return Filter(
      genres: (json["genres"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
      genresV1: (json["genresV1"] as List?)
          ?.map((x) => GenresV1.fromJson(x))
          .toList(),
      languages: (json["languages"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
      ageSuitability: (json["ageSuitability"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
      duration: (json["duration"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
      availability: (json["availability"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
      releaseYears: (json["releaseYears"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
      ratings: (json["ratings"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "genres": genres?.map((x) => x.toJson()).toList(),
    "genresV1": genresV1?.map((x) => x.toJson()).toList(),
    "languages": languages?.map((x) => x.toJson()).toList(),
    "ageSuitability": ageSuitability?.map((x) => x.toJson()).toList(),
    "duration": duration?.map((x) => x.toJson()).toList(),
    "availability": availability?.map((x) => x.toJson()).toList(),
    "releaseYears": releaseYears?.map((x) => x.toJson()).toList(),
    "ratings": ratings?.map((x) => x.toJson()).toList(),
  };
}

class GenresV1 {
  GenresV1({this.name, this.label, this.value, this.subGenres});

  final String? name;
  final String? label;
  final String? value;
  final List<Characteristic>? subGenres;

  factory GenresV1.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GenresV1();
    return GenresV1(
      name: json["name"],
      label: json["label"],
      value: json["value"],
      subGenres: (json["subGenres"] as List?)
          ?.map((x) => Characteristic.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "label": label,
    "value": value,
    "subGenres": subGenres?.map((x) => x.toJson()).toList(),
  };
}

class StreamingPlatform {
  StreamingPlatform({this.id, this.name, this.logo, this.countries});

  final int? id;
  final String? name;
  final String? logo;
  final List<StreamingPlatformCountry>? countries;

  factory StreamingPlatform.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StreamingPlatform();
    return StreamingPlatform(
      id: json["id"],
      name: json["name"],
      logo: json["logo"],
      countries: (json["countries"] as List?)
          ?.map((x) => StreamingPlatformCountry.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
    "countries": countries?.map((x) => x.toJson()).toList(),
  };
}

class StreamingPlatformCountry {
  StreamingPlatformCountry({this.streamingPlatformsId, this.countryId});

  final int? streamingPlatformsId;
  final int? countryId;

  factory StreamingPlatformCountry.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StreamingPlatformCountry();
    return StreamingPlatformCountry(
      streamingPlatformsId: json["streaming_platforms_id"],
      countryId: json["country_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "streaming_platforms_id": streamingPlatformsId,
    "country_id": countryId,
  };
}
