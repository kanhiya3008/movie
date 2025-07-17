class CollectionEndpoint {
  final String title;

  CollectionEndpoint({required this.title});

  factory CollectionEndpoint.fromJson(Map<String, dynamic> json) {
    return CollectionEndpoint(title: json['title']);
  }
}
