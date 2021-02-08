// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
    if (!uri.hasScheme) {
      throw const FormatException('URL should have scheme component');
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

  /// Removes the slash (`/`) from the end of the given [path].
  ///
  /// If the given [path] does not end with the slash symbol, returns unchanged
  /// value.
  ///
  /// Throws [ArgumentError] is the given [path] is `null`.
  static String removeTrailingSlash(String path) {
    ArgumentError.checkNotNull(path, 'path');

    if (path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }

    return path;
  }

  /// Transforms [path] replacing separators with additional path segments
  /// specified by [replacement].
  ///
  /// Throws [ArgumentError] if either [path] or [replacement] is `null`.
  /// Example:
  /// ```dart
  ///   const path = 'path/to/something';
  ///   final result = UrlUtils.replacePathSeparators(path, 'test');
  ///   // prints `test/path/test/to/test/something`
  ///   print(result);
  /// ```
  static String replacePathSeparators(String path, String replacement) {
    ArgumentError.checkNotNull(path, 'path');
    ArgumentError.checkNotNull(replacement, 'onMatch');
    final _path = path.splitMapJoin('/', onMatch: (_) => '/$replacement/');
    return '$replacement/$_path';
  }
}
