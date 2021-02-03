import 'dart:io';

import 'package:ci_integration/client/buildkite/buildkite_client.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_artifacts_page.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_build_state.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_builds_page.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:test/test.dart';

import 'test_utils/mock/buildkite_mock_server.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildkiteClient", () {
    const testPageNumber = 1;
    const buildNumber = 1;
    const organizationSlug = 'organization_slug';
    const pipelineSlug = 'pipeline_slug';
    const notFound = 'not_found';

    final authorization = ApiKeyAuthorization(
      HttpHeaders.authorizationHeader,
      'token',
    );

    final buildkiteMockServer = BuildkiteMockServer();
    BuildkiteClient client;

    setUpAll(() async {
      await buildkiteMockServer.start();

      client = BuildkiteClient(
        buildkiteApiUrl: buildkiteMockServer.url,
        organizationSlug: organizationSlug,
        authorization: authorization,
      );
    });

    tearDownAll(() async {
      client.close();

      await buildkiteMockServer.close();
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
      const buildkiteApiUrl = "buildkiteApiUrl";

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
        final basePath =
            "${buildkiteMockServer.url}/organizations/$organizationSlug/";

        final clientBasePath = client.basePath;

        expect(clientBasePath, equals(basePath));
      },
    );

    test(
      ".fetchBuilds() fails with an error if there is no pipeline with such slug",
      () async {
        final result = await client.fetchBuilds(notFound);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".fetchBuilds() applies the default per page parameter if it is not specified",
      () async {
        final interactionResult = await client.fetchBuilds(pipelineSlug);

        final page = interactionResult.result;

        expect(page.perPage, isNotNull);
      },
    );

    test(
      ".fetchBuilds() returns a builds page with the given per page parameter",
      () async {
        const expectedPerPage = 3;

        final interactionResult = await client.fetchBuilds(
          pipelineSlug,
          perPage: expectedPerPage,
        );
        final buildkiteBuildsPage = interactionResult.result;

        expect(buildkiteBuildsPage.perPage, equals(expectedPerPage));
      },
    );

    test(
      ".fetchBuilds() fetches the first page if the given page parameter is null",
      () async {
        final interactionResult = await client.fetchBuilds(
          pipelineSlug,
          page: null,
        );
        final buildkiteBuildsPage = interactionResult.result;

        expect(buildkiteBuildsPage.page, equals(1));
      },
    );

    test(
      ".fetchBuilds() fetches the first page if the given page parameter is less than zero",
      () async {
        final interactionResult = await client.fetchBuilds(
          pipelineSlug,
          page: -1,
        );
        final buildkiteBuildsPage = interactionResult.result;

        expect(buildkiteBuildsPage.page, equals(1));
      },
    );

    test(
      ".fetchBuilds() fetches the first page if the given page parameter is zero",
      () async {
        final interactionResult = await client.fetchBuilds(
          pipelineSlug,
          page: 0,
        );
        final buildkiteBuildsPage = interactionResult.result;

        expect(buildkiteBuildsPage.page, equals(1));
      },
    );

    test(
      ".fetchBuilds() returns a builds page with the given page parameter",
      () async {
        const expectedPage = 2;

        final interactionResult = await client.fetchBuilds(
          pipelineSlug,
          page: expectedPage,
        );
        final buildkiteBuildsPage = interactionResult.result;

        expect(buildkiteBuildsPage.page, equals(expectedPage));
      },
    );

    test(
      ".fetchBuilds() returns a builds page with the next page url",
      () async {
        final interactionResult = await client.fetchBuilds(pipelineSlug);
        final buildkiteBuildsPage = interactionResult.result;

        expect(buildkiteBuildsPage.nextPageUrl, isNotNull);
      },
    );

    test(
      ".fetchBuilds() returns a builds page with the null next page url if there are no more pages available",
      () async {
        final interactionResult = await client.fetchBuilds(
          pipelineSlug,
          perPage: 100,
        );
        final buildkiteBuildsPage = interactionResult.result;

        expect(buildkiteBuildsPage.nextPageUrl, isNull);
      },
    );

    test(
      ".fetchBuilds() returns a builds page with a list of builds",
      () async {
        final interactionResult = await client.fetchBuilds(pipelineSlug);
        final builds = interactionResult.result.values;

        expect(builds, isNotNull);
      },
    );

    test(
      ".fetchBuilds() returns a builds page containing builds with the given state",
      () async {
        const expectedState = BuildkiteBuildState.finished;

        final result = await client.fetchBuilds(
          pipelineSlug,
          state: expectedState,
        );

        final builds = result.result.values;

        expect(
          builds,
          everyElement(
            isA<BuildkiteBuild>().having(
              (run) => run.state,
              'state',
              equals(expectedState),
            ),
          ),
        );
      },
    );

    test(
      ".fetchBuilds() returns a builds page containing builds with the finished at after the given finished from",
      () async {
        final finishedFrom = DateTime(2020);

        final result = await client.fetchBuilds(
          pipelineSlug,
          finishedFrom: finishedFrom,
        );

        final builds = result.result.values;

        expect(
          builds,
          everyElement(
            isA<BuildkiteBuild>().having(
              (run) => run.finishedAt,
              'finished_from',
              greaterThanOrEqualTo(finishedFrom),
            ),
          ),
        );
      },
    );

    test(
      ".fetchBuildsNext() returns a next builds page after the given one",
      () async {
        final interactionResult = await client.fetchBuilds(
          pipelineSlug,
          page: testPageNumber,
        );
        final buildsPage = interactionResult.result;

        final nextInteractionResult = await client.fetchBuildsNext(buildsPage);
        final nextBuildsPage = nextInteractionResult.result;

        expect(nextBuildsPage.page, equals(testPageNumber + 1));
      },
    );

    test(
      ".fetchBuildsNext() returns an error if the given page is the last page",
      () async {
        const buildsPage = BuildkiteBuildsPage(nextPageUrl: null);

        final nextInteractionResult = await client.fetchBuildsNext(buildsPage);

        expect(nextInteractionResult.isError, isTrue);
      },
    );

    test(
      ".fetchArtifacts() fails if an associated build with such number is not found",
      () async {
        final interactionResult = await client.fetchArtifacts(pipelineSlug, 10);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".fetchArtifacts() applies the default per page parameter if it is not specified",
      () async {
        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
        );

        final page = interactionResult.result;

        expect(page.perPage, isNotNull);
      },
    );

    test(
      ".fetchArtifacts() returns an artifacts page with the given per page parameter",
      () async {
        const expectedPerPage = 3;

        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
          perPage: expectedPerPage,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.perPage, equals(expectedPerPage));
      },
    );

    test(
      ".fetchArtifacts() fetches the first page if the given page parameter is null",
      () async {
        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
          page: null,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.page, equals(1));
      },
    );

    test(
      ".fetchArtifacts() fetches the first page if the given page parameter is less than zero",
      () async {
        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
          page: -1,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.page, equals(1));
      },
    );

    test(
      ".fetchArtifacts() fetches the first page if the given page parameter is zero",
      () async {
        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
          page: 0,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.page, equals(1));
      },
    );

    test(
      ".fetchArtifacts() returns an artifacts page with the given page parameter",
      () async {
        const expectedPage = 2;

        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
          page: expectedPage,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.page, equals(expectedPage));
      },
    );

    test(
      ".fetchArtifacts() returns an artifacts page with the next page url",
      () async {
        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.nextPageUrl, isNotNull);
      },
    );

    test(
      ".fetchArtifacts() returns an artifacts page with the null next page url if there are no more pages available",
      () async {
        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
          perPage: 100,
        );
        final artifactsPage = interactionResult.result;

        expect(artifactsPage.nextPageUrl, isNull);
      },
    );

    test(
      ".fetchArtifacts() returns an artifacts page with a list of artifacts",
      () async {
        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
        );
        final artifacts = interactionResult.result.values;

        expect(artifacts, isNotNull);
      },
    );

    test(
      ".fetchArtifactsNext() returns a next artifacts page after the given one",
      () async {
        final interactionResult = await client.fetchArtifacts(
          pipelineSlug,
          buildNumber,
          page: testPageNumber,
        );
        final artifactsPage = interactionResult.result;

        final nextInteractionResult = await client.fetchArtifactsNext(
          artifactsPage,
        );
        final nextArtifactsPage = nextInteractionResult.result;

        expect(nextArtifactsPage.page, equals(testPageNumber + 1));
      },
    );

    test(
      ".fetchArtifactsNext() returns an error if the given page is the last page",
      () async {
        const artifactsPage = BuildkiteArtifactsPage(nextPageUrl: null);

        final nextInteractionResult = await client.fetchArtifactsNext(
          artifactsPage,
        );

        expect(nextInteractionResult.isError, isTrue);
      },
    );

    test(
      ".fetchToken() throws an ArgumentError if the given auth is null",
      () async {
        expect(
          () => client.fetchToken(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".fetchToken() returns a buildkite token if the given authorization is valid",
      () async {
        final interactionResult = await client.fetchToken(authorization);
        final token = interactionResult.result;

        expect(token, isNotNull);
      },
    );

    test(
      ".fetchToken() returns an error result if the given authorization is not valid",
      () async {
        final invalidAuthorization = BearerAuthorization('invalidToken');

        final result = await client.fetchToken(invalidAuthorization);

        expect(result.isError, isTrue);
      },
    );

    test(
      ".fetchOrganization() returns a buildkite organization",
      () async {
        final interactionResult = await client.fetchOrganization(
          organizationSlug,
        );
        final organization = interactionResult.result;

        expect(organization, isNotNull);
      },
    );

    test(
      ".fetchOrganization() returns an error result if there is no organization with the given slug",
      () async {
        final interactionResult = await client.fetchOrganization(notFound);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".fetchPipeline() returns a buildkite pipeline",
      () async {
        final interactionResult = await client.fetchPipeline(
          pipelineSlug,
        );
        final organization = interactionResult.result;

        expect(organization, isNotNull);
      },
    );

    test(
      ".fetchPipeline() returns an error result if there is no pipeline with the given slug",
      () async {
        final interactionResult = await client.fetchPipeline(notFound);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".downloadArtifact() returns null if the given url is null",
      () async {
        final interactionResult = await client.downloadArtifact(null);

        expect(interactionResult, isNull);
      },
    );

    test(
      ".downloadArtifact() fails with an error if the artifact associated with the given download url is not found",
      () async {
        final downloadUrl =
            '${client.basePath}pipelines/$pipelineSlug/builds/$buildNumber/artifacts/$notFound/download';

        final interactionResult = await client.downloadArtifact(downloadUrl);

        expect(interactionResult.isError, isTrue);
      },
    );
  });
}
