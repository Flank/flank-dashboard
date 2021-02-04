import 'package:ci_integration/client/buildkite/models/buildkite_organization.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_pipeline.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/source/buildkite/config/validation_delegate/buildkite_source_validation_delegate.dart';
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

    final client = BuildkiteCLientMock();
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
      ".validateAuth() returns an error if the interaction with the client is an error",
      () async {
        when(
          client.fetchToken(auth),
        ).thenErrorWith();

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isError, isTrue);
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
      ".validateAuth() returns a successful interaction with the buildkite token if the given authorization is valid",
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
      ".validateSourceProjectId() returns an error if the interaction with the client is an error",
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
      ".validateSourceProjectId() returns a successful interaction with the buildkite pipeline if the given pipeline slug is valid",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenSuccessWith(buildkitePipeline);

        final interactionResult = await delegate.validateSourceProjectId(
          pipelineSlug,
        );
        final pipeline = interactionResult.result;

        expect(pipeline, equals(buildkitePipeline));
      },
    );

    test(
      ".validateOrganization() returns an error if the interaction with the client is an error",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenErrorWith();

        final interactionResult = await delegate.validateOrganization(
          organizationSlug,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateOrganization() returns an error if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenSuccessWith(null);

        final interactionResult = await delegate.validateOrganization(
          organizationSlug,
        );

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateOrganization() returns a successful interaction with the buildkite organization if the given organization slug is valid",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenSuccessWith(buildkiteOrganization);

        final interactionResult = await delegate.validateOrganization(
          organizationSlug,
        );
        final organization = interactionResult.result;

        expect(organization, equals(buildkiteOrganization));
      },
    );
  });
}
