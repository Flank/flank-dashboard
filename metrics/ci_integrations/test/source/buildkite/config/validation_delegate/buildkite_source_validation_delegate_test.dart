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
        BuildkiteTokenScope.readAgents,
        BuildkiteTokenScope.readArtifacts
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
      ".validateAuth() delegates to .fetchToken() of the given client",
      () {
        delegate.validateAuth(auth);

        verify(client.fetchToken(auth)).called(1);
      },
    );

    test(
      ".validateAuth() returns a buildkite token",
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
      ".validateAuth() returns an error if fetching token fails",
      () async {
        when(
          client.fetchToken(auth),
        ).thenErrorWith();

        final interactionResult = await delegate.validateAuth(auth);

        expect(interactionResult.isError, isTrue);
      },
    );

    test(
      ".validateSourceProjectId() delegates to .fetchPipeline() of the given client",
      () {
        const sourceProjectId = 'id';

        delegate.validateSourceProjectId(sourceProjectId);

        verify(client.fetchPipeline(sourceProjectId)).called(1);
      },
    );

    test(
      ".validateSourceProjectId() returns a buildkite pipeline",
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
      ".validateSourceProjectId() returns an error if fetching buildkite pipeline fails",
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
      ".validateOrganization() delegates to .fetchOrganization() of the given client",
      () {
        const organizationSlug = 'slug';

        delegate.validateOrganization(organizationSlug);

        verify(client.fetchOrganization(organizationSlug)).called(1);
      },
    );

    test(
      ".validateOrganization() returns a buildkite organization",
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

    test(
      ".validateOrganization() returns an error if fetching buildkite organization fails",
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
  });
}
