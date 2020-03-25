import 'package:ci_integration/jenkins/client/model/jenkins_query_limits.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsQueryLimits", () {
    test(".empty() should create an empty range specifier", () {
      const limits = JenkinsQueryLimits.empty();
      const expected = '';
      final actual = limits.toQuery();

      expect(actual, equals(expected));
    });

    test(
      ".at(n) should throw ArgumentError trying to create a range specifier for a null number",
      () {
        expect(() => JenkinsQueryLimits.at(null), throwsArgumentError);
      },
    );

    test(
      ".at(n) should throw ArgumentError trying to create a range specifier for a negative number",
      () {
        expect(() => JenkinsQueryLimits.at(-1), throwsArgumentError);
      },
    );

    test(".at(n) should create a range specifier for n-th element - {n}", () {
      final limits = JenkinsQueryLimits.at(1);
      const expected = '{1}';
      final actual = limits.toQuery();

      expect(actual, equals(expected));
    });

    test(
      ".startAfter(n) should throw ArgumentError trying to create a range specifier for a null number",
      () {
        expect(() => JenkinsQueryLimits.startAfter(null), throwsArgumentError);
      },
    );

    test(
      ".startAfter(n) should throw ArgumentError trying to create a range specifier for a negative number",
      () {
        expect(() => JenkinsQueryLimits.startAfter(-1), throwsArgumentError);
      },
    );

    test(
      ".startAfter(n) should create a range specifier from the n-th element (exclusive) to the end - {n+1,}",
      () {
        final limits = JenkinsQueryLimits.startAfter(1);
        const expected = '{2,}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".startAt(n) should throw ArgumentError trying to create a range specifier for a null number",
      () {
        expect(() => JenkinsQueryLimits.startAt(null), throwsArgumentError);
      },
    );

    test(
      ".startAt(n) should throw ArgumentError trying to create a range specifier for a negative number",
      () {
        expect(() => JenkinsQueryLimits.startAt(-1), throwsArgumentError);
      },
    );

    test(
      ".startAt(n) should create a range specifier from the n-th element (inclusive) to the end - {n,}",
      () {
        final limits = JenkinsQueryLimits.startAt(1);
        const expected = '{1,}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".endBefore(n) should throw ArgumentError trying to create a range specifier for a null number",
      () {
        expect(() => JenkinsQueryLimits.endBefore(null), throwsArgumentError);
      },
    );

    test(
      ".endBefore(n) should throw ArgumentError trying to create a range specifier for a negative number",
      () {
        expect(() => JenkinsQueryLimits.endBefore(-1), throwsArgumentError);
      },
    );

    test(
      ".endBefore(n) should create a range specifier from the begin to the n-th element (exclusive) - {,n}",
      () {
        final limits = JenkinsQueryLimits.endBefore(1);
        const expected = '{,1}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".endAt(n) should throw ArgumentError trying to create a range specifier for a null number",
      () {
        expect(() => JenkinsQueryLimits.endAt(null), throwsArgumentError);
      },
    );

    test(
      ".endAt(n) should throw ArgumentError trying to create a range specifier for a negative number",
      () {
        expect(() => JenkinsQueryLimits.endAt(-1), throwsArgumentError);
      },
    );

    test(
      ".endAt(n) should create a range specifier from the begin to the n-th element (inclusive) - {,n+1}",
      () {
        final limits = JenkinsQueryLimits.endAt(1);
        const expected = '{,2}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".between(n, m) should throw ArgumentError trying to create a range specifier with a null begin edge",
      () {
        expect(() => JenkinsQueryLimits.between(null, 1), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) should throw ArgumentError trying to create a range specifier with a null end edge",
      () {
        expect(() => JenkinsQueryLimits.between(1, null), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) should throw ArgumentError trying to create a range specifier with a negative begin edge",
      () {
        expect(() => JenkinsQueryLimits.between(-1, 1), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) should throw ArgumentError trying to create a range specifier with a negative end edge",
      () {
        expect(() => JenkinsQueryLimits.between(1, -1), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) should throw ArgumentError trying to create a range specifier with an end edge less than a begin one",
      () {
        expect(() => JenkinsQueryLimits.between(3, 1), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) should create a range specifier from the n-th element (inclusive) to the m-th element (exclusive) - {n,m}",
      () {
        final limits = JenkinsQueryLimits.between(1, 3);
        const expected = '{1,3}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".fromQuery() should throw FormatException if the query is not a range-specifier",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('test'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() should throw FormatException on an empty range-specifier {}",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{}'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() should throw FormatException on a range-specifier for the range with negative edges",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{-2}'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() should throw FormatException on a range-specifier for the range with no integer edges",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{test,test}'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() should throw FormatException on invalid range-specifier",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{,,3}'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() should throw ArgumentError trying to parse query with a range-specifier having an end value less than a begin one",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{3,2}'),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fromQuery() should parse a query with valid range-specifier",
      () {
        final limits = JenkinsQueryLimits.fromQuery('{2,3}');

        expect(limits.lower, equals(2));
        expect(limits.upper, equals(3));
      },
    );
  });
}
