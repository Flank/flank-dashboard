// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/util/url/url_utils.dart';
import 'package:test/test.dart';

void main() {
  group("UrlUtils", () {
    const localhostUrl = 'http://localhost:8080';

    test(
      ".buildUrl() throws an ArgumentError if the given URL is null",
      () {
        expect(() => UrlUtils.buildUrl(null), throwsArgumentError);
      },
    );

    test(
      ".buildUrl() throws a FormatException if the given URL is invalid",
      () {
        expect(() => UrlUtils.buildUrl('test'), throwsFormatException);
      },
    );

    test(
      ".buildUrl() does not add query parameters if not provided",
      () {
        final result = UrlUtils.buildUrl(localhostUrl);
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isFalse);
      },
    );

    test(
      ".buildUrl() does not add query parameters if an empty map provided",
      () {
        final result = UrlUtils.buildUrl(localhostUrl, queryParameters: {});
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isFalse);
      },
    );

    test(
      ".buildUrl() adds query parameters if not empty map provided",
      () {
        final result = UrlUtils.buildUrl(
          localhostUrl,
          queryParameters: {'test': 'test'},
        );
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isTrue);
      },
    );

    test(
      ".buildUrl() builds a valid URL from parts provided",
      () {
        final result = UrlUtils.buildUrl(
          '$localhostUrl/',
          path: '/test/path/to',
          queryParameters: {'test': 'test'},
        );
        final uri = Uri.parse('$localhostUrl/test/path/to').replace(
          queryParameters: {'test': 'test'},
        );
        final expected = uri.toString();

        expect(result, equals(expected));
      },
    );

    test(
      ".removeTrailingSlash() throws an ArgumentError if the given path is null",
      () {
        expect(
          () => UrlUtils.removeTrailingSlash(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".removeTrailingSlash() returns unchanged string if the given path does not end with slash",
      () {
        const path = 'path';

        final result = UrlUtils.removeTrailingSlash(path);

        expect(result, equals(path));
      },
    );

    test(
      ".removeTrailingSlash() returns a string without trailing slash",
      () {
        const expectedPath = 'path';
        const path = 'path/';

        final result = UrlUtils.removeTrailingSlash(path);

        expect(result, equals(expectedPath));
      },
    );

    test(
      ".replacePathSeparators() throws an ArgumentError if the path is null",
      () {
        expect(
          () => UrlUtils.replacePathSeparators(null, ''),
          throwsArgumentError,
        );
      },
    );

    test(
      ".replacePathSeparators() throws an ArgumentError if the replacement is null",
      () {
        expect(
          () => UrlUtils.replacePathSeparators('', null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".replacePathSeparators() results with a path starting with the given replacement",
      () {
        final result = UrlUtils.replacePathSeparators('path', 'test');

        expect(result, equals('test/path'));
      },
    );

    test(
      ".replacePathSeparators() replaces path separators with the given replacement segment",
      () {
        final result = UrlUtils.replacePathSeparators('path/to', 'test');

        expect(result, equals('test/path/test/to'));
      },
    );
  });
}
