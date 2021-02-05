import 'package:ci_integration/client/buildkite/models/buildkite_organization.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_pipeline.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
import 'package:ci_integration/source/buildkite/strings/buildkite_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/extensions/interaction_result_answer.dart';
import '../../test_utils/buildkite_client_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("BuildkiteSourceValidationDelegate", () {
    const organizationSlug = 'organization_slug';
    const pipelineSlug = 'pipeline_slug';

    const buildkiteToken = BuildkiteToken(
      scopes: [
        BuildkiteTokenScope.readBuilds,
      ],
    );
    const readBuildsAndArtifactsScopes = [
      BuildkiteTokenScope.readBuilds,
      BuildkiteTokenScope.readArtifacts
    ];

    const buildkiteOrganization = BuildkiteOrganization(
      id: 'id',
      name: 'name',
      slug: organizationSlug,
    );

    const buildkitePipeline = BuildkitePipeline(
      id: 'id',
      name: 'name',
      slug: pipelineSlug,
    );

    final auth = BearerAuthorization('token');

    final client = BuildkiteClientMock();
    final delegate = BuildkiteSourceValidationDelegate(client);

    tearDown(() {
      reset(client);
    });

    test(
      "throws an ArgumentError if the given client is null",
      () {
        expect(
          () => BuildkiteSourceValidationDelegate(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given client",
      () {
        expect(
          () => BuildkiteSourceValidationDelegate(client),
          returnsNormally,
        );
      },
    );

    test(
      ".validateAuth() returns an error if the interaction with the client is not successful",
      () async {
        when(
          client.fetchToken(auth),
        ).thenErrorWith();

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateAuth() returns an interaction with the token invalid message if the interaction with the client is not successful",
      () async {
        when(
          client.fetchToken(auth),
        ).thenErrorWith();

        final interactionResult = await delegate.validateAuth(auth);
        final message = interactionResult.message;

        expect(message, equals(BuildkiteStrings.tokenInvalid));
      },
    );

    test(
      ".validateAuth() returns an error if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateAuth() returns an interaction with the token invalid message if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateAuth(auth);
        final message = interactionResult.message;

        expect(message, equals(BuildkiteStrings.tokenInvalid));
      },
    );

    test(
      ".validateAuth() returns an error if the fetched token does not have the read builds token scope",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(const BuildkiteToken(scopes: []));

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateAuth() returns an interaction with the token does not have read builds scope message if the fetched token does not have the read builds token scope",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(const BuildkiteToken(scopes: []));

        final interactionResult = await delegate.validateAuth(auth);
        final message = interactionResult.message;

        expect(
          message,
          equals(BuildkiteStrings.tokenDoesNotHaveReadBuildsScope),
        );
      },
    );

    test(
      ".validateAuth() returns a successful interaction if the fetched token is valid, but does not have the read artifacts scope",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(buildkiteToken);

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateAuth() returns an interaction containing the fetched Buildkite token if the fetched token is valid, but does not have the read artifacts scope",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(buildkiteToken);

        final interactionResult = await delegate.validateAuth(auth);
        final token = interactionResult.result;

        expect(token, equals(buildkiteToken));
      },
    );

    test(
      ".validateAuth() returns an interaction with the token does not have read artifacts scope message if the fetched is valid, but token does not have the read artifacts token scope",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(buildkiteToken);

        final interactionResult = await delegate.validateAuth(auth);
        final message = interactionResult.message;

        expect(
          message,
          equals(BuildkiteStrings.tokenDoesNotHaveReadArtifactsScope),
        );
      },
    );

    test(
      ".validateAuth() returns a successful interaction if the fetched Buildkite token has the read builds and read artifacts scopes",
      () async {
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(
          const BuildkiteToken(scopes: readBuildsAndArtifactsScopes),
        );

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateAuth() returns an interaction containing the fetched Buildkite token if the fetched Buildkite token has the read builds and read artifacts scopes",
      () async {
        const buildkiteToken = BuildkiteToken(
          scopes: readBuildsAndArtifactsScopes,
        );
        when(
          client.fetchToken(auth),
        ).thenSuccessWith(buildkiteToken);

        final interactionResult = await delegate.validateAuth(auth);
        final token = interactionResult.result;

        expect(token, equals(buildkiteToken));
      },
    );

    test(
      ".validateSourceProjectId() returns an error if the interaction with the client is not successful",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenErrorWith();

        final interactionResult = await delegate.validateSourceProjectId(
          pipelineSlug,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateSourceProjectId() returns an interaction with the pipeline not found message if the interaction with the client is not successful",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenErrorWith();

        final interactionResult = await delegate.validateSourceProjectId(
          pipelineSlug,
        );
        final message = interactionResult.message;

        expect(message, equals(BuildkiteStrings.pipelineNotFound));
      },
    );

    test(
      ".validateSourceProjectId() returns an error if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateSourceProjectId(
          pipelineSlug,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateSourceProjectId() returns an interaction with the pipeline not found message if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateSourceProjectId(
          pipelineSlug,
        );
        final message = interactionResult.message;

        expect(message, equals(BuildkiteStrings.pipelineNotFound));
      },
    );

    test(
      ".validateSourceProjectId() returns a successful interaction if the given pipeline slug is valid",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenSuccessWith(buildkitePipeline);

        final interactionResult = await delegate.validateSourceProjectId(
          pipelineSlug,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );

    test(
      ".validateOrganizationSlug() returns an error if the interaction with the client is not successful",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenErrorWith();

        final interactionResult = await delegate.validateOrganizationSlug(
          organizationSlug,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateOrganizationSlug() returns an interaction with the organization not found message if the interaction with the client is not successful",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenErrorWith();

        final interactionResult = await delegate.validateOrganizationSlug(
          organizationSlug,
        );
        final message = interactionResult.message;

        expect(message, equals(BuildkiteStrings.organizationNotFound));
      },
    );

    test(
      ".validateOrganizationSlug() returns an error if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateOrganizationSlug(
          organizationSlug,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateOrganizationSlug() returns an interaction with the organization not found message if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateOrganizationSlug(
          organizationSlug,
        );
        final message = interactionResult.message;

        expect(message, equals(BuildkiteStrings.organizationNotFound));
      },
    );

    test(
      ".validateOrganizationSlug() returns a successful interaction if the given organization slug is valid",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenSuccessWith(buildkiteOrganization);

        final interactionResult = await delegate.validateOrganizationSlug(
          organizationSlug,
        );

        expect(interactionResult.isSuccess, isTrue);
      },
    );
  });
}
