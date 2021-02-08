// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/domain/entities/theme_type.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_profile_param.dart';
import 'package:test/test.dart';

void main() {
  group("UserProfileParam", () {
    const selectedTheme = ThemeType.dark;
    const id = 'id';

    test(
      "throws an ArgumentError if the given id is null",
      () {
        expect(
          () => UserProfileParam(id: null, selectedTheme: selectedTheme),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given selected theme is null",
      () {
        expect(
          () => UserProfileParam(id: id, selectedTheme: null),
          throwsArgumentError,
        );
      },
    );

    test(
      "successfully creates a new instance with the given params",
      () {
        final profile = UserProfileParam(id: id, selectedTheme: selectedTheme);

        expect(profile.id, equals(id));
        expect(profile.selectedTheme, equals(selectedTheme));
      },
    );
  });
}
