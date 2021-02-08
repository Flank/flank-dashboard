// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';

/// A class that represents the user profile parameter.
@immutable
class UserProfileParam {
  /// A unique identifier of the user profile.
  final String id;

  /// A selected [ThemeType] for the user profile.
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
