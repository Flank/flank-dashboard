// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/cli/doctor/model/doctor_target_validation_result.dart';
import 'package:cli/cli/doctor/model/doctor_validation_conclusion.dart';
import 'package:cli/cli/doctor/strings/doctor_strings.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group("DoctorTargetValidationResult", () {
    const target = ValidationTarget(name: 'target');
    const recommendedVersion = '1';
    const currentVersion = '1.1';
    const installUrl = 'installUrl';
    const error = 'error';

    final installMessage = DoctorStrings.installMessage(
      target.name,
      installUrl,
    );

    test(
      ".successful() throws an AssertionError if the given target is null",
      () {
        expect(
          () => DoctorTargetValidationResult.successful(
            null,
            recommendedVersion,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      ".successful() creates an instance with the successful doctor validation conclusion",
      () {
        final result = DoctorTargetValidationResult.successful(
          target,
          recommendedVersion,
        );

        expect(result.conclusion, DoctorValidationConclusion.successful());
      },
    );

    test(
      ".successful() creates an instance with a null description",
      () {
        final result = DoctorTargetValidationResult.successful(
          target,
          recommendedVersion,
        );

        expect(result.description, isNull);
      },
    );

    test(
      ".successful() creates an instance with a details map containing a recommended version",
      () {
        final result = DoctorTargetValidationResult.successful(
          target,
          recommendedVersion,
        );

        expect(
          result.details,
          containsPair(DoctorStrings.version, recommendedVersion),
        );
      },
    );

    test(
      ".successful() creates an instance with a null context",
      () {
        final result = DoctorTargetValidationResult.successful(
          target,
          recommendedVersion,
        );

        expect(result.context, isNull);
      },
    );

    test(
      ".successful() creates an instance with the given parameters",
      () {
        final expectedDetails = {
          DoctorStrings.version: recommendedVersion,
        };

        final result = DoctorTargetValidationResult.successful(
          target,
          recommendedVersion,
        );

        expect(result.target, equals(target));
        expect(result.details, equals(expectedDetails));
      },
    );

    test(
      ".failure() throws an AssertionError if the given target is null",
      () {
        expect(
          () => DoctorTargetValidationResult.failure(
            null,
            recommendedVersion,
            installUrl,
            error,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      ".failure() creates an instance with the failure doctor validation conclusion",
      () {
        final result = DoctorTargetValidationResult.failure(
          target,
          recommendedVersion,
          installUrl,
          error,
        );

        expect(result.conclusion, DoctorValidationConclusion.failure());
      },
    );

    test(
      ".failure() creates an instance with the 'not installed' description",
      () {
        final result = DoctorTargetValidationResult.failure(
          target,
          recommendedVersion,
          installUrl,
          error,
        );

        expect(result.description, equals(DoctorStrings.notInstalled));
      },
    );

    test(
      ".failure() creates an instance with a details map containing a recommended version",
      () {
        final result = DoctorTargetValidationResult.failure(
          target,
          recommendedVersion,
          installUrl,
          error,
        );

        expect(
          result.details,
          containsPair(DoctorStrings.recommendedVersion, recommendedVersion),
        );
      },
    );

    test(
      ".failure() creates an instance with a context map containing process output",
      () {
        const executable = 'executable';
        const arguments = <String>[];
        const error = ProcessException(
          executable,
          arguments,
        );
        const expectedFailureMessage =
            '\$ $executable \n${DoctorStrings.commandNotFound} $executable';

        final result = DoctorTargetValidationResult.failure(
          target,
          recommendedVersion,
          installUrl,
          error,
        );
        final context = result.context;

        expect(
          context,
          containsPair(DoctorStrings.processOutput, expectedFailureMessage),
        );
      },
    );

    test(
      ".failure() creates an instance with a context map containing process output and recommended version",
      () {
        final result = DoctorTargetValidationResult.failure(
          target,
          recommendedVersion,
          installUrl,
          error,
        );
        final context = result.context;

        expect(context, containsPair(DoctorStrings.processOutput, error));
        expect(
          context,
          containsPair(DoctorStrings.recommendations, installMessage),
        );
      },
    );

    test(
      ".failure() creates an instance with the given parameters",
      () {
        final expectedDetails = {
          DoctorStrings.recommendedVersion: recommendedVersion,
        };
        final expectedContext = {
          DoctorStrings.processOutput: error,
          DoctorStrings.recommendations: installMessage
        };

        final result = DoctorTargetValidationResult.failure(
          target,
          recommendedVersion,
          installUrl,
          error,
        );

        expect(result.target, equals(target));
        expect(result.details, equals(expectedDetails));
        expect(result.context, equals(expectedContext));
      },
    );

    test(
      ".warning() throws an AssertionError if the given target is null",
      () {
        expect(
          () => DoctorTargetValidationResult.warning(null, currentVersion),
          throwsAssertionError,
        );
      },
    );

    test(
      ".warning() creates an instance with the warning doctor validation conclusion",
      () {
        final result = DoctorTargetValidationResult.warning(
          target,
          currentVersion,
        );

        expect(result.conclusion, DoctorValidationConclusion.warning());
      },
    );

    test(
      ".warning() creates an instance with the details map containing current version",
      () {
        final result = DoctorTargetValidationResult.warning(
          target,
          currentVersion,
        );

        expect(
          result.details,
          containsPair(DoctorStrings.version, currentVersion),
        );
      },
    );

    test(
      ".warning() creates an instance with the details map containing recommended version if the given recommended version is not null",
      () {
        final result = DoctorTargetValidationResult.warning(
          target,
          currentVersion,
          recommendedVersion: recommendedVersion,
        );

        expect(
          result.details,
          containsPair(DoctorStrings.recommendedVersion, recommendedVersion),
        );
      },
    );

    test(
      ".warning() creates an instance with the context map containing warning if the given install url is not null",
      () {
        final result = DoctorTargetValidationResult.warning(
          target,
          currentVersion,
          installUrl: installUrl,
        );

        expect(
          result.context,
          containsPair(DoctorStrings.warning, DoctorStrings.versionMismatch),
        );
      },
    );

    test(
      ".warning() creates an instance with the context map containing recommendations if the given install url is not null",
      () {
        final result = DoctorTargetValidationResult.warning(
          target,
          currentVersion,
          installUrl: installUrl,
        );

        expect(
          result.context,
          containsPair(
            DoctorStrings.recommendations,
            DoctorStrings.updateMessage(installUrl),
          ),
        );
      },
    );

    test(
      ".warning() creates an instance with the context map containing command error if the given error is not null",
      () {
        final result = DoctorTargetValidationResult.warning(
          target,
          currentVersion,
          error: error,
        );

        expect(
          result.context,
          containsPair(
            DoctorStrings.commandError,
            error,
          ),
        );
      },
    );

    test(
      ".warning() creates an instance with the given parameters",
      () {
        final expectedDetails = {
          DoctorStrings.version: currentVersion,
          DoctorStrings.recommendedVersion: recommendedVersion,
        };
        final expectedContext = {
          DoctorStrings.warning: DoctorStrings.versionMismatch,
          DoctorStrings.recommendations:
              DoctorStrings.updateMessage(installUrl),
          DoctorStrings.commandError: error,
        };

        final result = DoctorTargetValidationResult.warning(
          target,
          currentVersion,
          recommendedVersion: recommendedVersion,
          installUrl: installUrl,
          error: error,
        );

        expect(result.target, equals(target));
        expect(result.details, equals(expectedDetails));
        expect(result.context, equals(expectedContext));
      },
    );
  });
}
