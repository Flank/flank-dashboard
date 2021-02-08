// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/builder/jenkins_url_builder.dart';
import 'package:ci_integration/client/jenkins/constants/jenkins_constants.dart';
import 'package:ci_integration/client/jenkins/constants/tree_query.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("JenkinsUrlBuilder", () {
    const builder = JenkinsUrlBuilder();
    const baseUrl = 'http://test.com';
    const testPath = '/test/path';
    const treeQuery = TreeQuery.build;
    final encodedTreeQuery = Uri.encodeQueryComponent(TreeQuery.build);

    test(".build() builds url with the given parameters", () {
      final expected = '$baseUrl$testPath${JenkinsConstants.jsonApiPath}?'
          'tree=$encodedTreeQuery';

      final result = builder.build(
        baseUrl,
        path: testPath,
        treeQuery: treeQuery,
      );

      expect(result, equals(expected));
    });

    test(".build() adds the given tree query parameter", () {
      final expected = '$baseUrl${JenkinsConstants.jsonApiPath}?'
          'tree=$encodedTreeQuery';

      final result = builder.build(
        baseUrl,
        treeQuery: treeQuery,
      );

      expect(result, equals(expected));
    });

    test(
      ".build() does not add the given tree query parameter if it is null",
      () {
        const expected = '$baseUrl${JenkinsConstants.jsonApiPath}';

        final result = builder.build(
          baseUrl,
          treeQuery: null,
        );

        expect(result, equals(expected));
      },
    );

    test(
      ".build() does not add the given tree query parameter if it is empty",
      () {
        const expected = '$baseUrl${JenkinsConstants.jsonApiPath}';

        final result = builder.build(
          baseUrl,
          treeQuery: '',
        );

        expect(result, equals(expected));
      },
    );

    test(".build() adds json api path to the given url", () {
      const expected = '$baseUrl${JenkinsConstants.jsonApiPath}';

      final result = builder.build(baseUrl);

      expect(result, equals(expected));
    });

    test(
      ".build() adds json api path to the given url if the given path is null",
      () {
        const expected = '$baseUrl${JenkinsConstants.jsonApiPath}';

        final result = builder.build(
          baseUrl,
          path: null,
        );

        expect(result, equals(expected));
      },
    );

    test(
      ".build() adds json api path to the given url if the given path is empty",
      () {
        const expected = '$baseUrl${JenkinsConstants.jsonApiPath}';

        final result = builder.build(
          baseUrl,
          path: '',
        );

        expect(result, equals(expected));
      },
    );

    test(".build() adds json api path to the given path", () {
      const expected = '$baseUrl$testPath${JenkinsConstants.jsonApiPath}';

      final result = builder.build(
        baseUrl,
        path: testPath,
      );

      expect(result, equals(expected));
    });

    test(
      ".build() adds json api path to the given path with trailing slash",
      () {
        const expected = '$baseUrl$testPath${JenkinsConstants.jsonApiPath}';

        final result = builder.build(
          baseUrl,
          path: '$testPath/',
        );

        expect(result, equals(expected));
      },
    );

    test(
      ".build() does not add json api path to the given path if the path is already point to api",
      () {
        const path = '$testPath${JenkinsConstants.jsonApiPath}';
        const expected = '$baseUrl$path';

        final result = builder.build(
          baseUrl,
          path: path,
        );

        expect(result, equals(expected));
      },
    );

    test(
      ".build() does not add json api path to the given path if the path is already point to api with trailing slash",
      () {
        const path = '$testPath${JenkinsConstants.jsonApiPath}';
        const expected = '$baseUrl$path';

        final result = builder.build(
          baseUrl,
          path: '$path/',
        );

        expect(result, equals(expected));
      },
    );
  });
}
