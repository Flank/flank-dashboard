// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_query_limits.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsQueryLimits", () {
    test(".empty() creates an empty range specifier", () {
      const limits = JenkinsQueryLimits.empty();
      const expected = '';
      final actual = limits.toQuery();

      expect(actual, equals(expected));
    });

    test(
      ".at(n) throws an ArgumentError if the given number is null",
      () {
        expect(() => JenkinsQueryLimits.at(null), throwsArgumentError);
      },
    );

    test(
      ".at(n) throws an ArgumentError if the given number is negative",
      () {
        expect(() => JenkinsQueryLimits.at(-1), throwsArgumentError);
      },
    );

    test(".at(n) creates a range specifier for n-th element - {n}", () {
      final limits = JenkinsQueryLimits.at(1);
      const expected = '{1}';
      final actual = limits.toQuery();

      expect(actual, equals(expected));
    });

    test(
      ".startAfter(n) throws an ArgumentError if the given number is null",
      () {
        expect(() => JenkinsQueryLimits.startAfter(null), throwsArgumentError);
      },
    );

    test(
      ".startAfter(n) throws an ArgumentError if the given number is negative",
      () {
        expect(() => JenkinsQueryLimits.startAfter(-1), throwsArgumentError);
      },
    );

    test(
      ".startAfter(n) creates a range specifier from the n-th element (exclusive) to the end - {n+1,}",
      () {
        final limits = JenkinsQueryLimits.startAfter(1);
        const expected = '{2,}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".startAt(n) throws an ArgumentError if the given number is null",
      () {
        expect(() => JenkinsQueryLimits.startAt(null), throwsArgumentError);
      },
    );

    test(
      ".startAt(n) throws an ArgumentError if the given number is negative",
      () {
        expect(() => JenkinsQueryLimits.startAt(-1), throwsArgumentError);
      },
    );

    test(
      ".startAt(n) creates a range specifier from the n-th element (inclusive) to the end - {n,}",
      () {
        final limits = JenkinsQueryLimits.startAt(1);
        const expected = '{1,}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".endBefore(n) throws an ArgumentError if the given number is null",
      () {
        expect(() => JenkinsQueryLimits.endBefore(null), throwsArgumentError);
      },
    );

    test(
      ".endBefore(n) throws an ArgumentError if the given number is negative",
      () {
        expect(() => JenkinsQueryLimits.endBefore(-1), throwsArgumentError);
      },
    );

    test(
      ".endBefore(n) creates a range specifier from the begin to the n-th element (exclusive) - {,n}",
      () {
        final limits = JenkinsQueryLimits.endBefore(1);
        const expected = '{,1}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".endAt(n) throws an ArgumentError if the given number is null",
      () {
        expect(() => JenkinsQueryLimits.endAt(null), throwsArgumentError);
      },
    );

    test(
      ".endAt(n) throws an ArgumentError if the given number is negative",
      () {
        expect(() => JenkinsQueryLimits.endAt(-1), throwsArgumentError);
      },
    );

    test(
      ".endAt(n) creates a range specifier from the begin to the n-th element (inclusive) - {,n+1}",
      () {
        final limits = JenkinsQueryLimits.endAt(1);
        const expected = '{,2}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".between(n, m) throws an ArgumentError if the given begin edge is null",
      () {
        expect(() => JenkinsQueryLimits.between(null, 1), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) throws an ArgumentError if the given end edge is null",
      () {
        expect(() => JenkinsQueryLimits.between(1, null), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) throws an ArgumentError if the given begin edge is negative",
      () {
        expect(() => JenkinsQueryLimits.between(-1, 1), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) throws an ArgumentError if the given end edge is negative",
      () {
        expect(() => JenkinsQueryLimits.between(1, -1), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) throws an ArgumentError if the given end edge is less than a begin one",
      () {
        expect(() => JenkinsQueryLimits.between(3, 1), throwsArgumentError);
      },
    );

    test(
      ".between(n, m) creates a range specifier from the n-th element (inclusive) to the m-th element (exclusive) - {n,m}",
      () {
        final limits = JenkinsQueryLimits.between(1, 3);
        const expected = '{1,3}';
        final actual = limits.toQuery();

        expect(actual, equals(expected));
      },
    );

    test(
      ".fromQuery() throws a FormatException if the query is not a range-specifier",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('test'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() throws a FormatException on an empty range-specifier {}",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{}'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() throws a FormatException on a range-specifier for the range with negative edges",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{-2}'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() throws a FormatException on a range-specifier for the range with no integer edges",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{test,test}'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() throws a FormatException on invalid range-specifier",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{,,3}'),
          throwsFormatException,
        );
      },
    );

    test(
      ".fromQuery() throws an ArgumentError if the given end value is less than a begin one",
      () {
        expect(
          () => JenkinsQueryLimits.fromQuery('{3,2}'),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fromQuery() parses a query with valid range-specifier",
      () {
        final limits = JenkinsQueryLimits.fromQuery('{2,3}');

        expect(limits.lower, equals(2));
        expect(limits.upper, equals(3));
      },
    );
  });
}
