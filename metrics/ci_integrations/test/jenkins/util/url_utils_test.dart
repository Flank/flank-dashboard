import 'package:ci_integration/jenkins/util/url_utils.dart';
import 'package:test/test.dart';

void main() {
  group("UrlUtils", () {
    const localhostUrl = 'http://localhost:8080';

    test(
      ".buildUrl() should throw ArgumentError if a URL is null",
      () {
        expect(() => UrlUtils.buildUrl(null), throwsArgumentError);
      },
    );

    test(
      ".buildUrl() should throw FormatException if a URL is invalid",
      () {
        expect(() => UrlUtils.buildUrl('test'), throwsFormatException);
      },
    );

    test(
      ".buildUrl() should not add query parameters if not provided",
      () {
        final result = UrlUtils.buildUrl(localhostUrl);
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isFalse);
      },
    );

    test(
      ".buildUrl() should not add query parameters if empty map provided",
      () {
        final result = UrlUtils.buildUrl(localhostUrl, queryParameters: {});
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isFalse);
      },
    );

    test(
      ".buildUrl() should add query parameters if not empty map provided",
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
      ".buildUrl() should build a valid URL from parts provided",
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
      ".replacePathSeparators() should throw ArgumentError if the path is null",
      () {
        expect(
          () => UrlUtils.replacePathSeparators(null, ''),
          throwsArgumentError,
        );
      },
    );

    test(
      ".replacePathSeparators() should throw ArgumentError if the replacement is null",
      () {
        expect(
          () => UrlUtils.replacePathSeparators('', null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".replacePathSeparators() should result with path starting with the given replacement",
      () {
        final result = UrlUtils.replacePathSeparators('path', 'test');

        expect(result, equals('test/path'));
      },
    );

    test(
      ".replacePathSeparators() should replace path separators with the given replacement segment",
      () {
        final result = UrlUtils.replacePathSeparators('path/to', 'test');

        expect(result, equals('test/path/test/to'));
      },
    );
  });
}
