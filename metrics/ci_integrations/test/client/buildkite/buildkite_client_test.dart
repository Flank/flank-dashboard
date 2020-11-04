import 'dart:io';

import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

void main() {
  group("BuildkiteClient", () {
    const buildkiteApiUrl = "buildkiteApiUrl";
    const organizationSlug = "orgSlug";
    final authorization = BearerAuthorization("token");

    BuildkiteClient client;

    setUpAll(() {
      client = BuildkiteClient(
        buildkiteApiUrl: buildkiteApiUrl,
        organizationSlug: organizationSlug,
        authorization: authorization,
      );
    });

    tearDownAll(() {
      client.close();
    });

    test("throws an ArgumentError if the given Buildkite API URL is null", () {
      expect(
        () => BuildkiteClient(
          buildkiteApiUrl: null,
          organizationSlug: organizationSlug,
          authorization: authorization,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given Buildkite API URL is empty", () {
      expect(
        () => BuildkiteClient(
          buildkiteApiUrl: '',
          organizationSlug: organizationSlug,
          authorization: authorization,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given organization slug is null", () {
      expect(
        () => BuildkiteClient(
          organizationSlug: null,
          authorization: authorization,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given organization slug is empty", () {
      expect(
        () => BuildkiteClient(
          organizationSlug: '',
          authorization: authorization,
        ),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given authorization is null", () {
      expect(
        () => BuildkiteClient(
          authorization: null,
          organizationSlug: organizationSlug,
        ),
        throwsArgumentError,
      );
    });

    test("creates an instance with the given values", () {
      final client = BuildkiteClient(
        buildkiteApiUrl: buildkiteApiUrl,
        organizationSlug: organizationSlug,
        authorization: authorization,
      );

      expect(client.buildkiteApiUrl, equals(buildkiteApiUrl));
      expect(client.organizationSlug, equals(organizationSlug));
      expect(client.authorization, equals(authorization));
    });

    test(
      ".headers contain a 'content-type' header with the content type json value",
      () {
        final expectedHeaderValue = ContentType.json.value;

        final headers = client.headers;

        expect(
          headers,
          containsPair(HttpHeaders.contentTypeHeader, expectedHeaderValue),
        );
      },
    );

    test(
      ".headers contain an 'accept' header with the content type json value",
      () {
        final expectedHeaderValue = ContentType.json.value;

        final headers = client.headers;

        expect(
          headers,
          containsPair(HttpHeaders.acceptHeader, expectedHeaderValue),
        );
      },
    );

    test(".headers contain an authorization info", () {
      final headers = client.headers;

      final authHeader = authorization.toMap().entries.first;

      expect(headers, containsPair(authHeader.key, authHeader.value));
    });

    test(
      ".basePath returns a base path to the Buildkite API using the given values",
      () {
        const basePath = "$buildkiteApiUrl/organizations/$organizationSlug/";

        final clientBasePath = client.basePath;

        expect(clientBasePath, equals(basePath));
      },
    );
  });
}
