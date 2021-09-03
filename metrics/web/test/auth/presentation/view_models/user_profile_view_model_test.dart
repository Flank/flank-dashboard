// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/view_models/user_profile_view_model.dart';

void main() {
  group("UserProfileViewModel", () {
    const isAnonymous = true;

    test("throws an AssertionError if the 'isAnonymous' is null", () {
      expect(
        () => UserProfileViewModel(
          isAnonymous: null,
        ),
        throwsAssertionError,
      );
    });

    test("creates an instance with the given parameters", () {
      const metric = UserProfileViewModel(isAnonymous: isAnonymous);

      expect(metric.isAnonymous, equals(isAnonymous));
    });

    test(
      "equals to another BuildResultMetricViewModel with the same parameters",
      () {
        const expected = UserProfileViewModel(isAnonymous: isAnonymous);

        const userProfile = UserProfileViewModel(isAnonymous: isAnonymous);

        expect(userProfile, equals(expected));
      },
    );
  });
}
