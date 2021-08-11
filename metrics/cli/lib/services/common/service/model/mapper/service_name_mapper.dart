// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/service/model/service_name.dart';
import 'package:cli/services/firebase/firebase_service.dart';
import 'package:cli/services/flutter/flutter_service.dart';
import 'package:cli/services/gcloud/gcloud_service.dart';
import 'package:cli/services/git/git_service.dart';
import 'package:cli/services/npm/npm_service.dart';
import 'package:cli/services/sentry/sentry_service.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that provides methods for mapping service names.
class ServiceNameMapper {
  /// A [FirebaseService] validation target.
  static const firebase = ValidationTarget(
    name: 'firebase',
    description: 'CLI',
  );

  /// A [FlutterService] validation target.
  static const flutter = ValidationTarget(
    name: 'flutter',
    description: 'CLI',
  );

  /// A [GCloudService] validation target.
  static const gcloud = ValidationTarget(
    name: 'gcloud',
    description: 'CLI',
  );

  /// A [GitService] validation target.
  static const git = ValidationTarget(
    name: 'git',
    description: 'CLI',
  );

  /// An [NpmService] validation target.
  static const npm = ValidationTarget(
    name: 'npm',
    description: 'package manager',
  );

  /// A [SentryService] validation target.
  static const sentry = ValidationTarget(
    name: 'sentry-cli',
    description: 'CLI',
  );

  /// Creates a new instance of the [ServiceNameMapper].
  const ServiceNameMapper();

  /// Maps the given [target] to the [ServiceName].
  ServiceName map(ValidationTarget target) {
    if (target == firebase) {
      return ServiceName.firebase;
    } else if (target == flutter) {
      return ServiceName.flutter;
    } else if (target == gcloud) {
      return ServiceName.gcloud;
    } else if (target == git) {
      return ServiceName.git;
    } else if (target == npm) {
      return ServiceName.npm;
    } else if (target == sentry) {
      return ServiceName.sentry;
    } else {
      return null;
    }
  }

  /// Unmaps the given [name] to the [ValidationTarget].
  ValidationTarget unmap(ServiceName name) {
    switch (name) {
      case ServiceName.firebase:
        return firebase;
      case ServiceName.flutter:
        return flutter;
      case ServiceName.gcloud:
        return gcloud;
      case ServiceName.git:
        return git;
      case ServiceName.npm:
        return npm;
      case ServiceName.sentry:
        return sentry;
      default:
        return null;
    }
  }
}
