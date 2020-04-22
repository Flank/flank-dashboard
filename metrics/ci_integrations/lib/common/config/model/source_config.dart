import 'package:ci_integration/common/config/model/config.dart';

/// An abstract class representing the source configurations.
abstract class SourceConfig extends Config {
  /// Used to identify a project in a source this config belongs to.
  String get sourceProjectId;
}
