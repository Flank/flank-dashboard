import 'package:metrics/auth/domain/entities/theme_type.dart';
import 'package:metrics/auth/presentation/models/user_profile_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matcher_util.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("UserProfileModel", () {
    const id = 'id';
    const selectedTheme = ThemeType.dark;

    test("throws an AssertionError if the given id is null", () {
      expect(
        () => UserProfileModel(id: null, selectedTheme: selectedTheme),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the given selected theme is null", () {
      expect(
        () => UserProfileModel(id: id, selectedTheme: null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("creates an instance with the given parameters", () {
      final userProfileModel = UserProfileModel(
        id: id,
        selectedTheme: selectedTheme,
      );

      expect(userProfileModel.id, equals(id));
      expect(userProfileModel.selectedTheme, equals(selectedTheme));
    });

    test(
      "equals to another user profile model with the same parameters",
      () {
        final firstUserProfileModel = UserProfileModel(
          id: id,
          selectedTheme: selectedTheme,
        );

        final secondUserProfileModel = UserProfileModel(
          id: id,
          selectedTheme: selectedTheme,
        );

        expect(
          firstUserProfileModel,
          equals(secondUserProfileModel),
        );
      },
    );

    test(
      ".copyWith() creates a new instance with the same fields if called without params",
      () {
        final firstUserProfileModel = UserProfileModel(
          id: id,
          selectedTheme: selectedTheme,
        );

        final secondProfileModel = firstUserProfileModel.copyWith();

        expect(firstUserProfileModel, equals(secondProfileModel));
      },
    );

    test(
      ".copyWith() creates a copy of an instance with the given fields replaced with the new values",
      () {
        const selectedTheme = ThemeType.light;

        final firstUserProfileModel = UserProfileModel(
          id: id,
          selectedTheme: selectedTheme,
        );

        final copiedUserProfileModel = firstUserProfileModel.copyWith(
          selectedTheme: selectedTheme,
        );

        expect(
          copiedUserProfileModel.id,
          equals(firstUserProfileModel.id),
        );
        expect(copiedUserProfileModel.selectedTheme, equals(selectedTheme));
      },
    );
  });
}
