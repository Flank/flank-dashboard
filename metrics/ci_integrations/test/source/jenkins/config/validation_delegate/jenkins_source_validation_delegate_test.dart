// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_instance_info.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_job.dart';
import 'package:ci_integration/client/jenkins/model/jenkins_user.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:ci_integration/source/jenkins/config/model/jenkins_source_validation_target.dart';
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
      ".validateJenkinsUrl() returns a target validation result with a jenkins url validation target, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenErrorWith();

        final result = await delegate.validateJenkinsUrl(url);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.url));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with an invalid config field validation conclusion, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenErrorWith();

        final result = await delegate.validateJenkinsUrl(url);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with the 'not a jenkins url' description, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenErrorWith();

        final result = await delegate.validateJenkinsUrl(url);
        final description = result.description;

        expect(description, equals(JenkinsStrings.notAJenkinsUrl));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with a jenkins url validation target, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenSuccessWith(null);

        final result = await delegate.validateJenkinsUrl(url);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.url));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with an invalid config field validation conclusion, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenSuccessWith(null);

        final result = await delegate.validateJenkinsUrl(url);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with the 'not a jenkins url' description, if the result of interaction with the client is null",
      () async {
        when(client.fetchJenkinsInstanceInfo(url)).thenSuccessWith(null);

        final result = await delegate.validateJenkinsUrl(url);
        final description = result.description;

        expect(description, equals(JenkinsStrings.notAJenkinsUrl));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with a jenkins url validation target, if the fetched instance info has the version equal to null",
      () async {
        when(
          client.fetchJenkinsInstanceInfo(url),
        ).thenSuccessWith(nullVersionInstanceInfo);

        final result = await delegate.validateJenkinsUrl(url);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.url));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with an invalid config field validation conclusion, if the fetched instance info has the version equal to null",
      () async {
        when(
          client.fetchJenkinsInstanceInfo(url),
        ).thenSuccessWith(nullVersionInstanceInfo);

        final result = await delegate.validateJenkinsUrl(url);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with the 'not a jenkins url' description, if the fetched instance info has the version equal to null",
      () async {
        when(
          client.fetchJenkinsInstanceInfo(url),
        ).thenSuccessWith(nullVersionInstanceInfo);

        final result = await delegate.validateJenkinsUrl(url);
        final description = result.description;

        expect(description, equals(JenkinsStrings.notAJenkinsUrl));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with a jenkins url validation target, if the given jenkins url is valid",
      () async {
        const info = JenkinsInstanceInfo(version: '1.0');
        when(client.fetchJenkinsInstanceInfo(url)).thenSuccessWith(info);

        final result = await delegate.validateJenkinsUrl(url);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.url));
      },
    );

    test(
      ".validateJenkinsUrl() returns a target validation result with a valid config field validation conclusion, if the given jenkins url is valid",
      () async {
        const info = JenkinsInstanceInfo(version: '1.0');
        when(client.fetchJenkinsInstanceInfo(url)).thenSuccessWith(info);

        final result = await delegate.validateJenkinsUrl(url);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a jenkins api key validation target, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsUser(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid config field validation conclusion, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsUser(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'auth invalid' description, if the interaction with the client is not successful",
      () async {
        when(client.fetchJenkinsUser(auth)).thenErrorWith();

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(description, equals(JenkinsStrings.authInvalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a jenkins api key validation target, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid config field validation conclusion, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'auth invalid' description, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(null);

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(description, equals(JenkinsStrings.authInvalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a jenkins api key validation target, if the user associated with the given auth is anonymous",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(anonymousUser);

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a valid config field validation conclusion, if the user associated with the given auth is anonymous",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(anonymousUser);

        final result = await delegate.validateAuth(auth);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'anonymous user' description, if the fetched user is anonymous",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(anonymousUser);

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(description, contains(JenkinsStrings.anonymousUser));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a jenkins api key validation target, if the user associated with the given auth is unauthenticated",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(unauthenticatedUser);

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a valid config field validation conclusion, if the user associated with the given auth is unauthenticated",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(unauthenticatedUser);

        final result = await delegate.validateAuth(auth);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'unauthenticated user' description, if the fetched user is unauthenticated",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(unauthenticatedUser);

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(description, contains(JenkinsStrings.unauthenticatedUser));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a jenkins api key validation target, if the user associated with the given auth is unauthenticated and anonymous",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(anonymousUnauthenticatedUser);

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a valid config field validation conclusion, if the user associated with the given auth is unauthenticated and anonymous",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(anonymousUnauthenticatedUser);

        final result = await delegate.validateAuth(auth);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'unauthenticated user' and 'anonymous user' descriptions, if the fetched user is unauthenticated and anonymous",
      () async {
        when(
          client.fetchJenkinsUser(auth),
        ).thenSuccessWith(anonymousUnauthenticatedUser);

        final result = await delegate.validateAuth(auth);
        final description = result.description;

        expect(
          description,
          stringContainsInOrder([
            JenkinsStrings.anonymousUser,
            JenkinsStrings.unauthenticatedUser,
          ]),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with a jenkins api key validation target, if the given auth is valid",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(user);

        final result = await delegate.validateAuth(auth);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.apiKey));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a valid config field validation conclusion, if the given auth is valid",
      () async {
        when(client.fetchJenkinsUser(auth)).thenSuccessWith(user);

        final result = await delegate.validateAuth(auth);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateJobName() returns a target validation result with a jenkins job name validation target, if the interaction with the client is not successful",
      () async {
        when(client.fetchJob(jobName)).thenErrorWith();

        final result = await delegate.validateJobName(jobName);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.jobName));
      },
    );

    test(
      ".validateJobName() returns a target validation result with an invalid config field validation conclusion, if the interaction with the client is not successful",
      () async {
        when(client.fetchJob(jobName)).thenErrorWith();

        final result = await delegate.validateJobName(jobName);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateJobName() returns a target validation result with the 'job does not exist' description, if the interaction with the client is not successful",
      () async {
        when(client.fetchJob(jobName)).thenErrorWith();

        final result = await delegate.validateJobName(jobName);
        final description = result.description;

        expect(description, equals(JenkinsStrings.jobDoesNotExist));
      },
    );

    test(
      ".validateJobName() returns a target validation result with a jenkins job name validation target, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJob(jobName)).thenSuccessWith(null);

        final result = await delegate.validateJobName(jobName);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.jobName));
      },
    );

    test(
      ".validateJobName() returns a target validation result with an invalid config field validation conclusion, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJob(jobName)).thenSuccessWith(null);

        final result = await delegate.validateJobName(jobName);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateJobName() returns a target validation result with the 'job does not exist' description, if the result of the interaction with the client is null",
      () async {
        when(client.fetchJob(jobName)).thenSuccessWith(null);

        final result = await delegate.validateJobName(jobName);
        final description = result.description;

        expect(description, equals(JenkinsStrings.jobDoesNotExist));
      },
    );

    test(
      ".validateJobName() returns a target validation result with a jenkins job name validation target, if the given job name is valid",
      () async {
        const job = JenkinsJob(name: 'job');
        when(client.fetchJob(jobName)).thenSuccessWith(job);

        final result = await delegate.validateJobName(jobName);
        final target = result.target;

        expect(target, equals(JenkinsSourceValidationTarget.jobName));
      },
    );

    test(
      ".validateJobName() returns a target validation result with a valid config field validation conclusion, if the given job name is valid",
      () async {
        const job = JenkinsJob(name: 'job');
        when(client.fetchJob(jobName)).thenSuccessWith(job);

        final result = await delegate.validateJobName(jobName);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );
  });
}
