// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/feature_config/domain/usecases/parameters/feature_config_param.dart';
import 'package:test/test.dart';

void main() {
  group("FeatureConfigParam", () {
    const isPasswordSignInOptionEnabled = false;
    const isDebugMenuEnabled = true;
    const isPublicDashboardEnabled = true;

    test(
      "throws an ArgumentError if the given is password sign in option enabled is null",
      () {
        expect(
          () => FeatureConfigParam(
            isPasswordSignInOptionEnabled: null,
            isDebugMenuEnabled: isDebugMenuEnabled,
            isPublicDashboardEnabled: isPublicDashboardEnabled,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given is debug menu enabled is null",
      () {
        expect(
          () => FeatureConfigParam(
            isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
            isDebugMenuEnabled: null,
            isPublicDashboardEnabled: isPublicDashboardEnabled,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given is public dashboard enabled is null",
      () {
        expect(
          () => FeatureConfigParam(
            isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
            isDebugMenuEnabled: isDebugMenuEnabled,
            isPublicDashboardEnabled: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given values",
      () {
        final param = FeatureConfigParam(
            isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
            isDebugMenuEnabled: isDebugMenuEnabled,
            isPublicDashboardEnabled: isPublicDashboardEnabled);

        expect(param.isPasswordSignInOptionEnabled,
            equals(isPasswordSignInOptionEnabled));
        expect(param.isDebugMenuEnabled, equals(isDebugMenuEnabled));
        expect(
            param.isPublicDashboardEnabled, equals(isPublicDashboardEnabled));
      },
    );
  });
}
