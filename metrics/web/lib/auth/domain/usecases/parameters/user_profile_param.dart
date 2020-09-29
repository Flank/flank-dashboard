import 'package:flutter/cupertino.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';

/// A class that represents the user profile parameter.
@immutable
class UserProfileParam {
  /// An unique identifier of this user.
  final String id;

  /// A selected [ThemeType] of this user.
  final ThemeType selectedTheme;

  /// Create a new instance of the [UserProfileParam].
  ///
  /// The [id] and [selectedTheme] must not be `null`.
  UserProfileParam({
    @required this.id,
    @required this.selectedTheme,
  }) {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(selectedTheme, 'selectedTheme');
  }
}
