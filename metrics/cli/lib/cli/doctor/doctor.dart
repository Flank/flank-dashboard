// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:cli/cli/doctor/factory/doctor_factory.dart';
import 'package:cli/cli/doctor/model/doctor_target_validation_result.dart';
import 'package:cli/common/model/services/services.dart';
import 'package:cli/services/common/info_service.dart';
import 'package:cli/services/common/service/model/mapper/service_name_mapper.dart';
import 'package:cli/services/firebase/firebase_service.dart';
import 'package:cli/services/flutter/flutter_service.dart';
import 'package:cli/services/gcloud/gcloud_service.dart';
import 'package:cli/services/git/git_service.dart';
import 'package:cli/services/npm/npm_service.dart';
import 'package:cli/services/sentry/sentry_service.dart';
import 'package:cli/util/dependencies/dependencies.dart';
import 'package:cli/util/dependencies/dependency.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides an ability to check whether all required third-party
/// services are available and get their versions.
class Doctor {
  /// A [Dependencies] that holds all third-party [Dependency]s.
  final Dependencies _dependencies;

  /// A service that provides methods for working with Flutter.
  final FlutterService _flutterService;

  /// A service that provides methods for working with GCloud.
  final GCloudService _gcloudService;

  /// A service that provides methods for working with Npm.
  final NpmService _npmService;

  /// A class that provides methods for working with the Git.
  final GitService _gitService;

  /// A class that provides methods for working with the Firebase.
  final FirebaseService _firebaseService;

  /// A class that provides methods for working with the Sentry.
  final SentryService _sentryService;

  /// A [ServiceNameMapper] this class uses to map service names.
  final ServiceNameMapper _serviceNameMapper = const ServiceNameMapper();

  /// Creates a new instance of the [Doctor] with the given services.
  ///
  /// Throws an [ArgumentError] if the given [services] is `null`.
  /// Throws an [ArgumentError] if the given [dependencies] is `null`.
  /// Throws an [ArgumentError] if the given [Services.flutterService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.gcloudService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.npmService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.gitService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.firebaseService] is `null`.
  /// Throws an [ArgumentError] if the given [Services.sentryService] is `null`.
  Doctor({
    Services services,
    Dependencies dependencies,
  })  : _flutterService = services?.flutterService,
        _gcloudService = services?.gcloudService,
        _npmService = services?.npmService,
        _gitService = services?.gitService,
        _firebaseService = services?.firebaseService,
        _sentryService = services?.sentryService,
        _dependencies = dependencies {
    ArgumentError.checkNotNull(services, 'services');
    ArgumentError.checkNotNull(_dependencies, 'dependencies');
    ArgumentError.checkNotNull(_flutterService, 'flutterService');
    ArgumentError.checkNotNull(_gcloudService, 'gcloudService');
    ArgumentError.checkNotNull(_npmService, 'npmService');
    ArgumentError.checkNotNull(_gitService, 'gitService');
    ArgumentError.checkNotNull(_firebaseService, 'firebaseService');
    ArgumentError.checkNotNull(_sentryService, 'sentryService');
  }

  /// Returns the [ValidationResult] of versions checking for the required
  /// third-party services.
  Future<ValidationResult> checkVersions() async {
    final services = [
      _flutterService,
      _gcloudService,
      _npmService,
      _gitService,
      _firebaseService,
      _sentryService,
    ];

    final targets = <ValidationTarget>[];

    for (final service in services) {
      final target = _serviceNameMapper.unmap(service.serviceName);

      targets.add(target);
    }

    final resultBuilder = ValidationResultBuilder.forTargets(targets);

    for (final service in services) {
      final result = await _validateVersion(service);

      resultBuilder.setResult(result);
    }

    return resultBuilder.build();
  }

  /// Checks version of the third-party [service].
  ///
  /// Catches all thrown exceptions to be able to proceed with checking the
  /// version of all the rest services.
  Future<TargetValidationResult> _validateVersion(InfoService service) async {
    final validationTarget = _serviceNameMapper.unmap(service.serviceName);
    final serviceName = validationTarget.name;
    final dependency = _dependencies.getFor(serviceName);
    final recommendedVersion = dependency.recommendedVersion;
    final installUrl = dependency.installUrl;

    try {
      final processResult = await service.version();

      final stdout = processResult.stdout;
      final currentVersion = stdout is List<int>
          ? const Utf8Decoder().convert(stdout).replaceAll('\n', ' ').trim()
          : stdout.toString().replaceAll('\n', ' ').trim();

      final stderr = processResult.stderr;
      final error = stderr is List<int>
          ? const Utf8Decoder().convert(stderr)
          : stderr.toString();

      final versionValid = currentVersion.contains(recommendedVersion);
      final commandHasError = error != null && error.isNotEmpty;

      if (versionValid && !commandHasError) {
        return DoctorTargetValidationResult.successful(
          validationTarget,
          recommendedVersion,
        );
      }

      return DoctorTargetValidationResult.warning(
        validationTarget,
        currentVersion,
        versionValid ? null : recommendedVersion,
        versionValid ? null : installUrl,
        commandHasError ? error : null,
      );
    } catch (exception) {
      return DoctorTargetValidationResult.failure(
        validationTarget,
        recommendedVersion,
        installUrl,
        exception,
      );
    }
  }
}

Future<void> main() async {
  final doctorFactory = DoctorFactory();
  final doctor = doctorFactory.create();
  final result = await doctor.checkVersions();

  ValidationResultPrinter(stdout).print(result);

  exit(0);
}
