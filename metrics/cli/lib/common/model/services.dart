// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/firebase/service/firebase_service.dart';
import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';
import 'package:cli/git/service/git_service.dart';
import 'package:cli/npm/service/npm_service.dart';
import 'package:cli/sentry/service/sentry_service.dart';

/// A class that holds services needed to deploy the Metrics application.
class Services {
  /// A service that provides methods for working with Flutter.
  final FlutterService flutterService;

  /// A service that provides methods for working with GCloud.
  final GCloudService gcloudService;

  /// A service that provides methods for working with Npm.
  final NpmService npmService;

  /// A service that provides methods for working with Git.
  final GitService gitService;

  /// A service that provides methods for working with Firebase.
  final FirebaseService firebaseService;

  /// A service that provides methods for working with Sentry.
  final SentryService sentryService;

  /// Creates a new instance of the [Services] with the given services.
  ///
  /// Throws an [ArgumentError] if the given [flutterService] is `null`.
  /// Throws an [ArgumentError] if the given [gcloudService] is `null`.
  /// Throws an [ArgumentError] if the given [npmService] is `null`.
  /// Throws an [ArgumentError] if the given [gitService] is `null`.
  /// Throws an [ArgumentError] if the given [firebaseService] is `null`.
  /// Throws an [ArgumentError] if the given [sentryService] is `null`.
  Services({
    this.flutterService,
    this.gcloudService,
    this.npmService,
    this.gitService,
    this.firebaseService,
    this.sentryService,
  }) {
    ArgumentError.checkNotNull(flutterService, 'flutterService');
    ArgumentError.checkNotNull(gcloudService, 'gcloudService');
    ArgumentError.checkNotNull(npmService, 'npmService');
    ArgumentError.checkNotNull(gitService, 'gitService');
    ArgumentError.checkNotNull(firebaseService, 'firebaseService');
    ArgumentError.checkNotNull(sentryService, 'sentryService');
  }
}
