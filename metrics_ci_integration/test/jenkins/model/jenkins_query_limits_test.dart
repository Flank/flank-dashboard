import 'package:ci_integration/jenkins/model/jenkins_query_limits.dart';
import 'package:test/test.dart';

void main() {
  group('JenkinsQueryLimits', () {
    test('checkValue() should throw ArgumentError if a number is null', () {
      expect(() => JenkinsQueryLimits.checkValue(null), throwsArgumentError);
    });

    test('checkValue() should throw ArgumentError if a number is negative', () {
      expect(() => JenkinsQueryLimits.checkValue(-1), throwsArgumentError);
    });

    test('checkValue() should validate the given number', () {
      expect(() => JenkinsQueryLimits.checkValue(1), returnsNormally);
    });

    test(
      'checkRange() should throw ArgumentError if the begin value is null',
      () {
        expect(
            () => JenkinsQueryLimits.checkRange(null, 1), throwsArgumentError);
      },
    );

    test(
      'checkRange() should throw ArgumentError if the end value is null',
      () {
        expect(
            () => JenkinsQueryLimits.checkRange(1, null), throwsArgumentError);
      },
    );

    test(
      'checkRange() should throw ArgumentError if the begin value is negative',
      () {
        expect(() => JenkinsQueryLimits.checkRange(-1, 1), throwsArgumentError);
      },
    );

    test(
      'checkRange() should throw ArgumentError if the end value is negative',
      () {
        expect(() => JenkinsQueryLimits.checkRange(1, -1), throwsArgumentError);
      },
    );

    test(
      'checkRange() should throw ArgumentError if the end value is less '
      'than the begin one',
      () {
        expect(() => JenkinsQueryLimits.checkRange(2, 1), throwsArgumentError);
      },
    );

    test('checkRange() should validate the given rande', () {
      expect(() => JenkinsQueryLimits.checkRange(1, 2), returnsNormally);
    });

    test('.empty() should create an empty range specifier', () {
      const limits = JenkinsQueryLimits.empty();
      const expected = '';
      final actual = limits.toQuery();

      expect(actual, equals(expected));
    });

    test('.at(n) should create a range specifier for n-th element - {n}', () {
      final limits = JenkinsQueryLimits.at(1);
      const expected = '{1}';
      final actual = limits.toQuery();

      expect(actual, equals(expected));
    });

    test(
      '.startAfter(n) should create a range specifier from the '
      'n-th element (exclusive) to the end - {n+1,}',
      () {
        final limits = JenkinsQueryLimits.startAfter(1);
        const expected = '{2,}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      '.startAt(n) should create a range specifier from the '
      'n-th element (inclusive) to the end - {n,}',
      () {
        final limits = JenkinsQueryLimits.startAt(1);
        const expected = '{1,}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      '.endBefore(n) should create a range specifier from the begin '
      'to the n-th element (exclusive) - {,n}',
      () {
        final limits = JenkinsQueryLimits.endBefore(1);
        const expected = '{,1}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      '.endAt(n) should create a range specifier from the begin '
      'to the n-th element (inclusive) - {,n+1}',
      () {
        final limits = JenkinsQueryLimits.endAt(1);
        const expected = '{,2}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      '.between(n, m) should create a range specifier from the n-th element '
      '(inclusive) to the m-th element (exclusive) - {n,m}',
      () {
        final limits = JenkinsQueryLimits.between(1, 3);
        const expected = '{1,3}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      '.betweenInclusive(n, m) should create a range specifier from the n-th '
      'element (inclusive) to the m-th element (inclusive) - {n,m+1}',
      () {
        final limits = JenkinsQueryLimits.betweenInclusive(1, 3);
        const expected = '{1,4}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      '.betweenInclusive(n, m) should create a range specifier from the n-th '
      'element (exclusive) to the m-th element (exclusive) - {n+1,m}',
      () {
        final limits = JenkinsQueryLimits.betweenExclusive(1, 3);
        const expected = '{2,3}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      '.fromQuery() should throw FormatException if the query '
      'is not a range-specifier',
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('test'),
          throwsFormatException,
        );
      },
    );

    test(
      '.fromQuery() should throw FormatException on an empty '
      'range-specifier {}',
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{}'),
          throwsFormatException,
        );
      },
    );

    test(
      '.fromQuery() should throw FormatException on a range-specifier for the '
      'range with negative edges',
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{-2}'),
          throwsFormatException,
        );
      },
    );

    test(
      '.fromQuery() should throw FormatException on a range-specifier for the '
      'range with no integer edges',
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{test,test}'),
          throwsFormatException,
        );
      },
    );

    test(
      '.fromQuery() should throw FormatException on invalid range-specifier',
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{,,3}'),
          throwsFormatException,
        );
      },
    );

    test(
      '.fromQuery() should parse a query with valid range-specifier',
      () {
        final limits = JenkinsQueryLimits.fromQuery('{2,3}');

        expect(limits.lower, equals(2));
        expect(limits.upper, equals(3));
      },
    );
  });
}
