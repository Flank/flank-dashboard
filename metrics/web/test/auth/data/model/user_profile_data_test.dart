// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/data/model/user_profile_data.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';
import 'package:test/test.dart';

void main() {
  group("UserProfileData", () {
    const id = 'id';
    const selectedTheme = ThemeType.dark;
    final json = {'selectedTheme': selectedTheme.toString()};

    test(".fromJson() returns null if the given json is null", () {
      final userProfile = UserProfileData.fromJson(null, id);

      expect(userProfile, isNull);
    });

    test(".fromJson() creates an instance from a json map", () {
      final expectedUserProfile = UserProfileData(
        id: id,
        selectedTheme: selectedTheme,
      );

      final userProfile = UserProfileData.fromJson(json, id);

      expect(userProfile, equals(expectedUserProfile));
    });

    test(".toJson() converts an instance to the json encodable map", () {
      final userProfileData = UserProfileData(
        id: id,
        selectedTheme: selectedTheme,
      );

      expect(userProfileData.toJson(), equals(json));
    });
  });
}
