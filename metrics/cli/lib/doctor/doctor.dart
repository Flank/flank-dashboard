// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/firebase/firebase_command.dart';
import 'package:cli/cli/git/git_command.dart';
import 'package:cli/common/model/services.dart';
import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';

/// A class that provides an ability to check whether all required third-party
/// services are available and get their version.
class Doctor {
  /// A service that provides methods for working with Flutter.
  final FlutterService _flutterService;

  /// A service that provides methods for working with GCloud.
  final GCloudService _gcloudService;

  /// A class that provides methods for working with the Firebase.
  final FirebaseCommand _firebaseCommand;

  /// A class that provides methods for working with the Git.
  final GitCommand _gitCommand;

  /// Creates a new instance of the [Doctor] with the given services.
  ///
  /// Throws an [ArgumentError] if the given [services] is `null`.
  /// Throws an [ArgumentError] if the given [firebaseCommand] is `null`.
  /// Throws an [ArgumentError] if the given [gitCommand] is `null`.
  Doctor({
    Services services,
    FirebaseCommand firebaseCommand,
    GitCommand gitCommand,
  })  : _gcloudService = services?.gcloudService,
        _flutterService = services?.flutterService,
        _firebaseCommand = firebaseCommand,
        _gitCommand = gitCommand {
    ArgumentError.checkNotNull(services, 'services');
    ArgumentError.checkNotNull(_firebaseCommand, 'firebaseCommand');
    ArgumentError.checkNotNull(_gitCommand, 'gitCommand');
  }

  /// Checks versions of the required third-party services.
  Future<void> checkVersions() async {
    try {
      await _flutterService.version();
    } catch (_, __) {}
    try {
      await _firebaseCommand.version();
    } catch (_, __) {}
    try {
      await _gcloudService.version();
    } catch (_, __) {}
    try {
      await _gitCommand.version();
    } catch (_, __) {}
  }
}
