// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';

/// A class that represents a user profile model used to
/// transfer data between [ChangeNotifier]s.
class UserProfileModel extends Equatable {
  /// A unique identifier of this user profile.
  final String id;

  /// A selected theme of this user profile.
  final ThemeType selectedTheme;

  @override
  List<Object> get props => [id, selectedTheme];

  /// Creates the [UserProfileModel] with the given [id] and the [selectedTheme].
  ///
  /// The [selectedTheme] must not be null.
  const UserProfileModel({
    @required this.selectedTheme,
    this.id,
  }) : assert(selectedTheme != null);

  /// Returns a new instance of the [UserProfileModel] that is a combination
  /// of this user profile model and the given [userProfileModel].
  ///
  /// If the given [userProfileModel] is `null`, returns this user profile model.
  UserProfileModel merge(UserProfileModel userProfileModel) {
    if (userProfileModel == null) return this;

    return copyWith(
      id: userProfileModel.id,
      selectedTheme: userProfileModel.selectedTheme,
    );
  }

  /// Creates the new instance of the [UserProfileModel]
  /// based on the current instance.
  ///
  /// If any of the passed parameters are `null`, or parameter isn't specified,
  /// the value will be copied from the current instance.
  UserProfileModel copyWith({
    String id,
    ThemeType selectedTheme,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }
}
