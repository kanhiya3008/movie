String extractYoutubeId(String url) {
  final RegExp regExp = RegExp(
    r"(?:v=|\/)([0-9A-Za-z_-]{11}).*",
    caseSensitive: false,
    multiLine: false,
  );

  final match = regExp.firstMatch(url);
  return match != null && match.groupCount >= 1 ? match.group(1)! : '';
}
