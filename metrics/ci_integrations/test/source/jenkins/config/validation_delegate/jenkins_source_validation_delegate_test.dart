// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_instance_info.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_user.dart';
import 'package:ci_integration/source/jenkins/config/validation_delegate/jenkins_source_validation_delegate.dart';
import 'package:ci_integration/source/jenkins/strings/jenkins_strings.dart';
import 'package:ci_integration/util/authorization/authorization.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/extensions/interaction_result_answer.dart';
import '../../test_utils/jenkins_client_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("JenkinsSourceValidationDelegate", () {
    const url = 'url';
    final auth = BearerAuthorization('token');
    const jobName = 'job';

    const nullVersionInstanceInfo = JenkinsInstanceInfo(version: null);

    const anonymousUser = JenkinsUser(anonymous: true);
    const unauthenticatedUser = JenkinsUser(authenticated: false);
    const anonymousUnauthenticatedUser = JenkinsUser(
      authenticated: false,
      anonymous: true,
    );
    const user = JenkinsUser(
      name: 'user',
      authenticated: true,
      anonymous: false,
    );

    final client = JenkinsClientMock();
    final delegate = JenkinsSourceValidationDelegate(client);

    tearDown(() {
      reset(client);
    });

    test(
      "throws an ArgumentError if the given jenkins client is null",
      () {
        expect(
          () => JenkinsSourceValidationDelegate(null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given jenkins client",
      () {
        expect(
          () => JenkinsSourceValidationDelegate(client),
          returnsNormally,
        );
      },
    );

    test(
      ".validateJenkinsUrl() returns a failure field validation result, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenErrorWith();

        final result = await delegate.validateJenkinsUrl(url);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateJenkinsUrl() returns a field validation result with the 'not a jenkins url' additional context, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenErrorWith();

        final result = await delegate.validateJenkinsUrl(url);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(JenkinsStrings.notAJenkinsUrl));
      },
    );

    test(
      ".validateJenkinsUrl() returns a failure field validation result, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenSuccessWith(null);

        final result = await delegate.validateJenkinsUrl(url);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateJenkinsUrl() returns a field validation result with the 'not a jenkins url' additional context, if the result of interaction with the client is null",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenSuccessWith(null);

        final result = await delegate.validateJenkinsUrl(url);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(JenkinsStrings.notAJenkinsUrl));
      },
    );

    test(
      ".validateJenkinsUrl() returns a failure field validation result, if the fetched instance info has the version equal to null",
      () async {
        when(
          client.fetchJenkinsInstanceInfo(url),
        ).thenSuccessWith(nullVersionInstanceInfo);

        final result = await delegate.validateJenkinsUrl(url);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateJenkinsUrl() returns a field validation result with the 'not a jenkins url' additional context, if the fetched instance info has the version equal to null",
      () async {
        when(
          client.fetchJenkinsInstanceInfo(url),
        ).thenSuccessWith(nullVersionInstanceInfo);

        final result = await delegate.validateJenkinsUrl(url);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(JenkinsStrings.notAJenkinsUrl));
      },
    );

    test(
      ".validateJenkinsUrl() returns a successful field validation result, if the given jenkins url is valid",
      () async {
        const info = JenkinsInstanceInfo(version: '1.0');
        when(client.fetchJenkinsInstanceInfo(url)).thenSuccessWith(info);

        final result = await delegate.validateJenkinsUrl(url);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateAuth() returns a failure field validation result, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsUser(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'auth invalid' additional context, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsUser(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(JenkinsStrings.authInvalid));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'auth invalid' additional context, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(JenkinsStrings.authInvalid));
      },
    );

    test(
      ".validateAuth() returns a success field validation result, if the user associated with the given auth is anonymous",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(anonymousUser);

        final result = await delegate.validateAuth(auth);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'anonymous user' additional context, if the fetched user is anonymous",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(anonymousUser);

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(additionalContext, contains(JenkinsStrings.anonymousUser));
      },
    );

    test(
      ".validateAuth() returns a success field validation result, if the user associated with the given auth is unauthenticated",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(unauthenticatedUser);

        final result = await delegate.validateAuth(auth);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'unauthenticated user' additional context, if the fetched user is unauthenticated",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(unauthenticatedUser);

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(additionalContext, contains(JenkinsStrings.unauthenticatedUser));
      },
    );

    test(
      ".validateAuth() returns a successful field validation result, if the user associated with the given auth is unauthenticated and anonymous",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(anonymousUnauthenticatedUser);

        final result = await delegate.validateAuth(auth);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'unauthenticated user' and 'anonymous user' additional contexts, if the fetched user is unauthenticated and anonymous",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(anonymousUnauthenticatedUser);

        final result = await delegate.validateAuth(auth);
        final additionalContext = result.additionalContext;

        expect(
          additionalContext,
          stringContainsInOrder([
            JenkinsStrings.anonymousUser,
            JenkinsStrings.unauthenticatedUser,
          ]),
        );
      },
    );

    test(
      ".validateAuth() returns a successful field validation result, if the given auth is valid",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(user);

        final result = await delegate.validateAuth(auth);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateJobName() returns a failure field validation result, if the interaction with the client is not successful",
      () async {
        when(client.fetchJob(jobName)).thenErrorWith();

        final result = await delegate.validateJobName(jobName);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateJobName() returns a field validation result with the 'job does not exist' additional context, if the interaction with the client is not successful",
      () async {
        when(client.fetchJob(jobName)).thenErrorWith();

        final result = await delegate.validateJobName(jobName);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(JenkinsStrings.jobDoesNotExist));
      },
    );

    test(
      ".validateJobName() returns a failure field validation result, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJob(jobName)).thenSuccessWith(null);

        final result = await delegate.validateJobName(jobName);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateJobName() returns a field validation result with the 'job does not exist' additional context, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJob(jobName)).thenSuccessWith(null);

        final result = await delegate.validateJobName(jobName);
        final additionalContext = result.additionalContext;

        expect(additionalContext, equals(JenkinsStrings.jobDoesNotExist));
      },
    );

    test(
      ".validateJobName() returns a successful field validation result, if the given job name is valid",
      () async {
        const job = JenkinsJob(name: 'job');
        when(client.fetchJob(jobName)).thenSuccessWith(job);

        final result = await delegate.validateJobName(jobName);

        expect(result.isSuccess, isTrue);
      },
    );
  });
}
