/// An util class for working with URLs.
class UrlUtils {
  /// Creates a valid URL from parts provided.
  ///
  /// Throws [ArgumentError] if [url] is null. Throws [FormatException] if
  /// [url] has no authority (see [Uri.authority]).
  static String buildUrl(
    String url, {
    String path = '',
    Map<String, String> queryParameters = const {},
  }) {
    if (url == null) throw ArgumentError('URL must not be null');

    Uri uri = Uri.parse(url);
    if (!uri.hasAuthority) {
      throw const FormatException('URL should have authority component');
    }

    final _path = Uri.parse(path);
    final urlSegments = uri.pathSegments.where((s) => s.isNotEmpty);
    final pathSegments = _path.pathSegments.where((s) => s.isNotEmpty);

    uri = uri.replace(
      pathSegments: [
        ...urlSegments,
        ...pathSegments,
      ],
      queryParameters: queryParameters == null || queryParameters.isEmpty
          ? null
          : queryParameters,
    );

    return uri.toString();
  }
}
