import 'dart:io';

import 'package:ci_integration/common/authorization/authorization.dart';
import 'package:ci_integration/jenkins/client/jenkins_client.dart';
import 'package:test/test.dart';

import '../test_utils/jenkins_mock_server.dart';

void main() {
  group('JenkinsClient', () {
    const localhostUrl = 'http://localhost:8080';
    final jenkinsMockServer = JenkinsMockServer();
    final authorization = BasicAuthorization('test', 'test');
    JenkinsClient jenkinsClient;
    JenkinsClient unauthorizedJenkinsClient;

    setUpAll(() async {
      await jenkinsMockServer.init();

      unauthorizedJenkinsClient = JenkinsClient(
        jenkinsUrl: jenkinsMockServer.url,
      );

      jenkinsClient = JenkinsClient(
        jenkinsUrl: jenkinsMockServer.url,
        authorization: authorization,
      );
    });

    tearDownAll(() async {
      await jenkinsMockServer.close();
      unauthorizedJenkinsClient.close();
      jenkinsClient.close();
    });

    test(
      'should throw ArgumentError creating a client instance with a null URL',
      () {
        expect(() => JenkinsClient(jenkinsUrl: null), throwsArgumentError);
      },
    );

    test(
      'should throw ArgumentError creating a client instance with an empty URL',
      () {
        expect(() => JenkinsClient(jenkinsUrl: ''), throwsArgumentError);
      },
    );

    test(
      'buildJenkinsApiUrl() should throw ArgumentError if a URL is null',
      () {
        expect(
          () => jenkinsClient.buildJenkinsApiUrl(null),
          throwsArgumentError,
        );
      },
    );

    test(
      'buildJenkinsApiUrl() should throw FormatException if a URL is invalid',
      () {
        expect(
          () => jenkinsClient.buildJenkinsApiUrl('test'),
          throwsFormatException,
        );
      },
    );

    test(
      'buildJenkinsApiUrl() should add default path to Jenkins JSON API '
      'if no provided',
      () {
        final result = jenkinsClient.buildJenkinsApiUrl(localhostUrl);
        const expected = '$localhostUrl/api/json';

        expect(result, equals(expected));
      },
    );

    test(
      'buildJenkinsApiUrl() should not add query parameters if not provided',
      () {
        final result = jenkinsClient.buildJenkinsApiUrl(localhostUrl);
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isFalse);
      },
    );

    test(
      'buildJenkinsApiUrl() should not add query parameters if an empty '
      'tree query provided',
      () {
        final result = jenkinsClient.buildJenkinsApiUrl(
          localhostUrl,
          treeQuery: '',
        );
        final actual = Uri.parse(result).hasQuery;

        expect(actual, isFalse);
      },
    );

    test(
      'buildJenkinsApiUrl() should build a valid URL from parts provided',
      () {
        final result = jenkinsClient.buildJenkinsApiUrl(
          '$localhostUrl/',
          path: '/job/test/job/test/1/',
          treeQuery: 'number,url,timestamp,duration,artifacts',
        );
        final uri = Uri.parse('$localhostUrl/job/test/job/test/1').replace(
          queryParameters: {'tree': 'number,url,timestamp,duration,artifacts'},
        );
        final expected = uri.toString();

        expect(result, equals(expected));
      },
    );

    test(
      'headers should contain the "content-type" header with an '
      'application-json value',
      () {
        final headers = jenkinsClient.headers;

        expect(
          headers,
          containsPair(HttpHeaders.contentTypeHeader, ContentType.json.value),
        );
      },
    );

    test(
      'headers should contain the "accept" header with an '
      'application-json value',
      () {
        final headers = jenkinsClient.headers;

        expect(
          headers,
          containsPair(HttpHeaders.acceptHeader, ContentType.json.value),
        );
      },
    );

    test(
      'headers should include authorization related header if provided',
      () {
        final headers = jenkinsClient.headers;
        final authHeader = authorization.toMap().entries.first;

        expect(
          headers,
          containsPair(authHeader.key, authHeader.value),
        );
      },
    );

    test(
      'headers should not include authorization related header if client '
      'is not authorized',
      () {
        final headers = unauthorizedJenkinsClient.headers;
        final expectedHeaders = {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.acceptHeader: ContentType.json.value,
        };

        expect(headers, equals(expectedHeaders));
      },
    );
  });
}
