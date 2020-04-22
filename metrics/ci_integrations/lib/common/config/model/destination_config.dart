import 'package:ci_integration/common/config/model/config.dart';

/// An abstract class representing the destination configurations.
abstract class DestinationConfig extends Config {
  /// Used to identify a project in a destination storage
  /// this config belongs to.
  String get destinationProjectId;
}
