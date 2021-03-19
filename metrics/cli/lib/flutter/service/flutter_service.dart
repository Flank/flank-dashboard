import 'package:cli/interfaces/service/info_service.dart';

/// An abstract class for Flutter service that provides methods
/// for working with Flutter.
abstract class FlutterService extends InfoService {
  /// Builds a Flutter web application in the given [appPath].
  Future<void> build(String appPath);
}
