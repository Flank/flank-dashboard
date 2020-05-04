import '../../../arguments/model/user_credentials.dart';
import '../../common/model/environment.dart';

/// A class that represents the `flutter drive` process environment.
class FlutterDriveEnvironment implements Environment {
  /// User credentials needed to log in to the application under tests.
  final UserCredentials credentials;

  /// Creates the [Environment] with the given credentials.
  FlutterDriveEnvironment({this.credentials});

  @override
  Map<String, String> toMap() {
    return credentials?.toMap();
  }
}
