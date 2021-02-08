// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/theme_type.dart';
import 'package:metrics/auth/domain/entities/user_profile.dart';
import 'package:test/test.dart';

void main() {
  group("UserProfile", () {
    const selectedTheme = ThemeType.dark;
    const id = 'id';

    test("throws an ArgumentError if the given id is null", () {
      expect(
        () => UserProfile(id: null, selectedTheme: selectedTheme),
        throwsArgumentError,
      );
    });

    test("throws an ArgumentError if the given selected theme is null", () {
      expect(
        () => UserProfile(id: id, selectedTheme: null),
        throwsArgumentError,
      );
    });

    test("successfully creates a new instance with the given parameters", () {
      final profile = UserProfile(id: id, selectedTheme: selectedTheme);

      expect(profile.id, equals(id));
      expect(profile.selectedTheme, equals(selectedTheme));
    });
  });
}
