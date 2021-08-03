// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/buildkite/models/buildkite_organization.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_pipeline.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token.dart';
import 'package:ci_integration/client/buildkite/models/buildkite_token_scope.dart';
import 'package:ci_integration/source/buildkite/config/model/buildkite_source_validation_target.dart';
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
      scopes: [BuildkiteTokenScope.readBuilds],
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
      ".validateAuth() returns a target validation result with an access token target if the interaction with the client is not successful",
      () async {
        when(client.fetchToken(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(BuildkiteSourceValidationTarget.accessToken));
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid conclusion if the interaction with the client is not successful",
      () async {
        when(client.fetchToken(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);

        expect(result.isInvalid, isTrue);
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'token invalid' description if the interaction with the client is not successful",
      () async {
        when(client.fetchToken(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(description, equals(BuildkiteStrings.tokenInvalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with an access token target if the result of an interaction with the client is null",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(BuildkiteSourceValidationTarget.accessToken));
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid conclusion if the result of an interaction with the client is null",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);

        expect(result.isInvalid, isTrue);
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'token invalid' description if the result of an interaction with the client is null",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(description, equals(BuildkiteStrings.tokenInvalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with an access token target if the fetched token does not have the read builds token scope",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(
          const BuildkiteToken(scopes: []),
        );

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(BuildkiteSourceValidationTarget.accessToken));
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid conclusion if the fetched token does not have the read builds token scope",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(
          const BuildkiteToken(scopes: []),
        );

        final result = await delegate.validateAuth(auth);

        expect(result.isInvalid, isTrue);
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'token does not have read builds scope' description if the fetched token does not have the read builds token scope",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(
          const BuildkiteToken(scopes: []),
        );

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(
          description,
          equals(BuildkiteStrings.tokenDoesNotHaveReadBuildsScope),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with an access token target if the fetched token is valid, but the token does not have the read artifacts token scope",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(buildkiteToken);

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(BuildkiteSourceValidationTarget.accessToken));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a valid conclusion if the fetched token is valid, but the token does not have the read artifacts token scope",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(buildkiteToken);

        final result = await delegate.validateAuth(auth);

        expect(result.isValid, isTrue);
      },
    );

    test(
      ".validateAuth() returns a target validation result with the fetched Buildkite token data if the fetched token is valid, but the token does not have the read artifacts token scope",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(buildkiteToken);

        final result = await delegate.validateAuth(auth);
        final token = result.data;

        expect(token, equals(buildkiteToken));
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'token does not have read artifacts scope' description if the fetched token is valid, but the token does not have the read artifacts token scope",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(buildkiteToken);

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(
          description,
          equals(BuildkiteStrings.tokenDoesNotHaveReadArtifactsScope),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with an access token target if the fetched token has the read builds and read artifacts token scopes",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(
          const BuildkiteToken(scopes: readBuildsAndArtifactsScopes),
        );

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(BuildkiteSourceValidationTarget.accessToken));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a valid conclusion if the fetched token has the read builds and read artifacts token scopes",
      () async {
        when(client.fetchToken(auth)).thenSuccessWith(
          const BuildkiteToken(scopes: readBuildsAndArtifactsScopes),
        );

        final result = await delegate.validateAuth(auth);

        expect(result.isValid, isTrue);
      },
    );

    test(
      ".validateAuth() returns a target validation result with the fetched Buildkite token data if the fetched token has the read builds and read artifacts token scopes",
      () async {
        const buildkiteToken = BuildkiteToken(
          scopes: readBuildsAndArtifactsScopes,
        );
        when(client.fetchToken(auth)).thenSuccessWith(buildkiteToken);

        final result = await delegate.validateAuth(auth);
        final token = result.data;

        expect(token, equals(buildkiteToken));
      },
    );

    test(
      ".validatePipelineSlug() returns a target validation result with a pipeline slug target if the result of an interaction with the client is not successful",
      () async {
        when(client.fetchPipeline(pipelineSlug)).thenErrorWith();

        final result = await delegate.validatePipelineSlug(pipelineSlug);
        final target = result.target;

        expect(target, equals(BuildkiteSourceValidationTarget.pipelineSlug));
      },
    );

    test(
      ".validatePipelineSlug() returns a target validation result with an invalid conclusion if the result of an interaction with the client is not successful",
      () async {
        when(client.fetchPipeline(pipelineSlug)).thenErrorWith();

        final result = await delegate.validatePipelineSlug(pipelineSlug);

        expect(result.isInvalid, isTrue);
      },
    );

    test(
      ".validatePipelineSlug() returns a target validation result with the 'pipeline not found' description if the interaction with the client is not successful",
      () async {
        when(client.fetchPipeline(pipelineSlug)).thenErrorWith();

        final result = await delegate.validatePipelineSlug(pipelineSlug);
        final description = result.description;

        expect(description, equals(BuildkiteStrings.pipelineNotFound));
      },
    );

    test(
      ".validatePipelineSlug() returns a target validation result with a pipeline slug target if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenSuccessWith(null);

        final result = await delegate.validatePipelineSlug(pipelineSlug);
        final target = result.target;

        expect(target, equals(BuildkiteSourceValidationTarget.pipelineSlug));
      },
    );

    test(
      ".validatePipelineSlug() returns a target validation result with an invalid conclusion if the result of an interaction with the client is null",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenSuccessWith(null);

        final result = await delegate.validatePipelineSlug(pipelineSlug);

        expect(result.isInvalid, isTrue);
      },
    );

    test(
      ".validatePipelineSlug() returns a target validation result with the 'pipeline not found' description if the result of an interaction with the client is null",
      () async {
        when(client.fetchPipeline(pipelineSlug)).thenSuccessWith(null);

        final result = await delegate.validatePipelineSlug(pipelineSlug);
        final description = result.description;

        expect(description, equals(BuildkiteStrings.pipelineNotFound));
      },
    );

    test(
      ".validatePipelineSlug() returns a target validation result with a pipeline slug target if the given pipeline slug is valid",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenSuccessWith(buildkitePipeline);

        final result = await delegate.validatePipelineSlug(pipelineSlug);
        final target = result.target;

        expect(target, equals(BuildkiteSourceValidationTarget.pipelineSlug));
      },
    );

    test(
      ".validatePipelineSlug() returns a target validation result with a valid conclusion if the given pipeline slug is valid",
      () async {
        when(
          client.fetchPipeline(pipelineSlug),
        ).thenSuccessWith(buildkitePipeline);

        final result = await delegate.validatePipelineSlug(pipelineSlug);

        expect(result.isValid, isTrue);
      },
    );

    test(
      ".validateOrganizationSlug() returns a target validation result with an organization slug target if the interaction with the client is not successful",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenErrorWith();

        final result = await delegate.validateOrganizationSlug(
          organizationSlug,
        );
        final target = result.target;

        expect(
          target,
          equals(BuildkiteSourceValidationTarget.organizationSlug),
        );
      },
    );

    test(
      ".validateOrganizationSlug() returns a target validation result with an invalid conclusion if the interaction with the client is not successful",
      () async {
        when(client.fetchOrganization(organizationSlug)).thenErrorWith();

        final result = await delegate.validateOrganizationSlug(
          organizationSlug,
        );

        expect(result.isInvalid, isTrue);
      },
    );

    test(
      ".validateOrganizationSlug() returns a target validation result with the 'organization not found' description if the interaction with the client is not successful",
      () async {
        when(client.fetchOrganization(organizationSlug)).thenErrorWith();

        final result = await delegate.validateOrganizationSlug(
          organizationSlug,
        );
        final description = result.description;

        expect(description, equals(BuildkiteStrings.organizationNotFound));
      },
    );

    test(
      ".validateOrganizationSlug() returns a target validation result with an organization slug target if the result of an interaction with the client is null",
      () async {
        when(client.fetchOrganization(organizationSlug)).thenSuccessWith(null);

        final result = await delegate.validateOrganizationSlug(
          organizationSlug,
        );
        final target = result.target;

        expect(
          target,
          equals(BuildkiteSourceValidationTarget.organizationSlug),
        );
      },
    );

    test(
      ".validateOrganizationSlug() returns a target validation result with an invalid conclusion if the result of an interaction with the client is null",
      () async {
        when(client.fetchOrganization(organizationSlug)).thenSuccessWith(null);

        final result = await delegate.validateOrganizationSlug(
          organizationSlug,
        );

        expect(result.isInvalid, isTrue);
      },
    );

    test(
      ".validateOrganizationSlug() returns a target validation result with the 'organization not found' description if the result of an interaction with the client is null",
      () async {
        when(client.fetchOrganization(organizationSlug)).thenSuccessWith(null);

        final result = await delegate.validateOrganizationSlug(
          organizationSlug,
        );
        final description = result.description;

        expect(description, equals(BuildkiteStrings.organizationNotFound));
      },
    );

    test(
      ".validateOrganizationSlug() returns a target validation result with an organization slug target if the given organization slug is valid",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenSuccessWith(buildkiteOrganization);

        final result = await delegate.validateOrganizationSlug(
          organizationSlug,
        );
        final target = result.target;

        expect(
          target,
          equals(BuildkiteSourceValidationTarget.organizationSlug),
        );
      },
    );

    test(
      ".validateOrganizationSlug() returns a target validation result with a valid conclusion if the given organization slug is valid",
      () async {
        when(
          client.fetchOrganization(organizationSlug),
        ).thenSuccessWith(buildkiteOrganization);

        final result = await delegate.validateOrganizationSlug(
          organizationSlug,
        );

        expect(result.isValid, isTrue);
      },
    );
  });
}
