// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/service/model/service_name.dart';
import 'package:cli/services/firebase/firebase_service.dart';
import 'package:cli/services/flutter/flutter_service.dart';
import 'package:cli/services/gcloud/gcloud_service.dart';
import 'package:cli/services/git/git_service.dart';
import 'package:cli/services/npm/npm_service.dart';
import 'package:cli/services/sentry/sentry_service.dart';

/// A class that provides methods for mapping service names.
class ServiceNameMapper {
  /// A [FirebaseService] name.
  static const String firebase = 'firebase';

  /// A [FlutterService] name.
  static const String flutter = 'flutter';

  /// A [GCloudService] name.
  static const String gcloud = 'gcloud';

  /// A [GitService] name.
  static const String git = 'git';

  /// An [NpmService] name.
  static const String npm = 'npm';

  /// A [SentryService] name.
  static const String sentry = 'sentry';

  /// Creates a new instance of the [ServiceNameMapper]
  const ServiceNameMapper();

  /// Maps the given [name] to the [ServiceName].
  ServiceName map(String name) {
    switch (name) {
      case firebase:
        return ServiceName.firebase;
      case flutter:
        return ServiceName.flutter;
      case gcloud:
        return ServiceName.gcloud;
      case git:
        return ServiceName.git;
      case npm:
        return ServiceName.npm;
      case sentry:
        return ServiceName.sentry;
      default:
        return null;
    }
  }

  /// Unmaps the given [name] to the [String].
  String unmap(ServiceName name) {
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
