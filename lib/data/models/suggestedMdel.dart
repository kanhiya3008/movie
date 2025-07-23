class SuggestedUser {
  final int id;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final MatchInfo? matchesReceived;

  SuggestedUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    this.matchesReceived,
  });

  factory SuggestedUser.fromJson(Map<String, dynamic> json) {
    return SuggestedUser(
      id: json['id'] ?? 0,
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      avatarUrl: (json['avatarUrl'] ?? '').toString(),
      matchesReceived: json['matchesReceived'] != null
          ? MatchInfo.fromJson(json['matchesReceived'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'matchesReceived': matchesReceived?.toJson(),
    };
  }
}

class MatchInfo {
  final int id;
  final String percentage;

  MatchInfo({required this.id, required this.percentage});

  factory MatchInfo.fromJson(Map<String, dynamic> json) {
    return MatchInfo(
      id: json['id'] ?? 0,
      percentage: (json['percentage'] ?? '0.0').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'percentage': percentage};
  }
}
