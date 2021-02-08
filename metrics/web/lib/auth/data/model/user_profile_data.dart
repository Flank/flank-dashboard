// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';
import 'package:metrics/auth/domain/entities/user_profile.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents the [UserProfile] entity.
class UserProfileData extends UserProfile implements DataModel {
  /// Creates the [UserProfileData] with the given [id] and [selectedTheme].
  UserProfileData({
    @required String id,
    @required ThemeType selectedTheme,
  }) : super(id: id, selectedTheme: selectedTheme);

  /// Creates the [UserProfileData] using the [json] and the [documentId].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory UserProfileData.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    if (json == null) return null;

    final selectedThemeValue = json['selectedTheme'] as String;
    final selectedTheme = ThemeType.values.firstWhere(
      (element) => '$element' == selectedThemeValue,
      orElse: () => null,
    );

    return UserProfileData(
      id: documentId,
      selectedTheme: selectedTheme,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'selectedTheme': selectedTheme.toString(),
    };
  }
}
