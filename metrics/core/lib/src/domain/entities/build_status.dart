import 'package:metrics_core/src/domain/entities/build.dart';

/// Represents the status the [Build] has been finished with.
enum BuildStatus {
  /// Indicates a successful result of the [Build].
  successful,

  /// Indicates a failed result of the [Build].
  failed,

  /// Indicates an unknown result of the [Build].
  unknown,
}
