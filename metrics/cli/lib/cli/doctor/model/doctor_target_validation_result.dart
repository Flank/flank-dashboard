// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/cli/doctor/doctor.dart';
import 'package:cli/cli/doctor/model/doctor_validation_conclusion.dart';
import 'package:cli/cli/doctor/strings/doctor_strings.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [TargetValidationResult] within the [Doctor]
/// versions checking process.
class DoctorTargetValidationResult<T> extends TargetValidationResult<T> {
  /// Creates a new instance of the [DoctorTargetValidationResult]
  /// with the given parameters.
  const DoctorTargetValidationResult._({
    ValidationTarget target,
    ValidationConclusion conclusion,
    String description,
    Map<String, dynamic> details,
    Map<String, dynamic> context,
    T data,
  }) : super(
          target: target,
          conclusion: conclusion,
          description: description,
          details: details,
          context: context,
          data: data,
        );

  /// Creates a new instance of the [DoctorTargetValidationResult]
  /// with the given parameters and [DoctorTargetValidationResult.successful]
  /// result.
  ///
  /// Represents a successful doctor target validation result.
  factory DoctorTargetValidationResult.successful(
    ValidationTarget target,
    String recommendedVersion,
  ) {
    return DoctorTargetValidationResult._(
      target: target,
      conclusion: DoctorValidationConclusion.successful(),
      details: {DoctorStrings.version: recommendedVersion},
    );
  }

  /// Creates a new instance of the [DoctorTargetValidationResult]
  /// with the given parameters and [DoctorTargetValidationResult.failure]
  /// result.
  ///
  /// Represents a failure doctor target validation result.
  factory DoctorTargetValidationResult.failure(
    ValidationTarget target,
    String recommendedVersion,
    String installUrl,
    dynamic error,
  ) {
    final targetName = target?.name;
    final installMessage = DoctorStrings.installMessage(
      targetName,
      installUrl,
    );
    final context = {
      DoctorStrings.processOutput: _createFailureMessage(error),
      DoctorStrings.recommendations: installMessage,
    };

    return DoctorTargetValidationResult._(
      target: target,
      conclusion: DoctorValidationConclusion.failure(),
      description: DoctorStrings.notInstalled,
      details: {DoctorStrings.recommendedVersion: recommendedVersion},
      context: context,
    );
  }

  /// Creates a new instance of the [DoctorTargetValidationResult]
  /// with the given parameters and [DoctorTargetValidationResult.warning]
  /// result.
  ///
  /// Represents a warning doctor target validation result.
  factory DoctorTargetValidationResult.warning(
    ValidationTarget target,
    String currentVersion, {
    String recommendedVersion,
    String installUrl,
    dynamic error,
  }) {
    final details = _createWarningDetails(currentVersion, recommendedVersion);
    final context = _createWarningContext(installUrl, error);

    return DoctorTargetValidationResult._(
      target: target,
      conclusion: DoctorValidationConclusion.warning(),
      details: details,
      context: context,
    );
  }

  /// Creates warning details map using the given [currentVersion]
  /// and [recommendedVersion].
  ///
  /// If the given [recommendedVersion] is not `null`,
  /// returns a details map with [DoctorStrings.version] key.
  static Map<String, dynamic> _createWarningDetails(
    String currentVersion,
    String recommendedVersion,
  ) {
    final details = {
      DoctorStrings.version: currentVersion,
    };

    if (recommendedVersion != null) {
      details[DoctorStrings.recommendedVersion] = recommendedVersion;
    }

    return details;
  }

  /// Creates warning context map using the given [installUrl] and [error].
  ///
  /// If the given [installUrl] is not `null`,
  /// returns a context map with [DoctorStrings.warning]
  /// and [DoctorStrings.recommendations] keys.
  ///
  /// If the given [error] is not `null`, returns a context map
  /// with [DoctorStrings.commandError] key.
  static Map<String, dynamic> _createWarningContext(
    String installUrl,
    dynamic error,
  ) {
    final updateMessage = DoctorStrings.updateMessage(installUrl);

    final context = <String, dynamic>{};
    if (installUrl != null) {
      context[DoctorStrings.warning] = DoctorStrings.versionMismatch;
      context[DoctorStrings.recommendations] = updateMessage;
    }
    if (error != null) {
      context[DoctorStrings.commandError] = _createFailureMessage(error);
    }

    return context;
  }

  /// Creates the failure message using the given [error].
  static String _createFailureMessage(dynamic error) {
    if (error is ProcessException) {
      final executable = error.executable;
      final arguments = error.arguments.fold('', (p, e) => '$p $e');

      return '\$ $executable $arguments\n${DoctorStrings.commandNotFound} $executable';
    }

    return error.toString();
  }
}
