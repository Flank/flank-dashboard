import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a feature config parameter.
class FeatureConfigParam extends Equatable {
  /// Indicates whether the password sign-in option is enabled.
  final bool isPasswordSignInOptionEnabled;

  /// Indicates whether the debug menu feature is enabled.
  final bool isDebugMenuEnabled;

  @override
  List<Object> get props => [
        isPasswordSignInOptionEnabled,
        isDebugMenuEnabled,
      ];

  /// Creates a new instance of the [FeatureConfigParam]
  /// with the given config parameters.
  ///
  /// Throws an [ArgumentError] if one of the required parameters is `null`.
  FeatureConfigParam({
    @required this.isPasswordSignInOptionEnabled,
    @required this.isDebugMenuEnabled,
  }) {
    ArgumentError.checkNotNull(
        isPasswordSignInOptionEnabled, 'isPasswordSignInOptionEnabled');
    ArgumentError.checkNotNull(isDebugMenuEnabled, 'isDebugMenuEnabled');
  }
}
