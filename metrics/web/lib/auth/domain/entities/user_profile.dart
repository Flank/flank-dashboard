// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';

/// An entity representing the user profile.
class UserProfile extends Equatable {
  /// A unique identifier of this user.
  final String id;

  /// A selected [ThemeType] for the user profile.
  final ThemeType selectedTheme;

  @override
  List<Object> get props => [id, selectedTheme];

  /// Creates a new instance of the [UserProfile].
  ///
  /// The [id] and [selectedTheme] must not be null.
  UserProfile({
    @required this.id,
    @required this.selectedTheme,
  }) {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(selectedTheme, 'selectedTheme');
  }
}
