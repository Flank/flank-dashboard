// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import '../../../arguments/model/user_credentials.dart';
import '../../common/model/environment.dart';

/// A class that represents the `flutter drive` process environment.
class FlutterDriveEnvironment implements Environment {
  /// User credentials needed to log in to the application under test.
  final UserCredentials userCredentials;

  /// Creates the [Environment] with the given credentials.
  FlutterDriveEnvironment({this.userCredentials});

  @override
  Map<String, String> toMap() {
    return userCredentials?.toMap();
  }
}
