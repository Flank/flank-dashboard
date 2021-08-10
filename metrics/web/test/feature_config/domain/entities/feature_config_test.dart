// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/feature_config/domain/entities/feature_config.dart';

void main() {
  group("FeatureConfig", () {
    const isPasswordSignInOptionEnabled = true;
    const isDebugMenuEnabled = true;
    const isPublicDashboardEnabled = true;

    test(
      "creates an instance with the given parameters",
      () {
        const config = FeatureConfig(
          isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
          isPublicDashboardEnabled: isPublicDashboardEnabled,
        );

        expect(
          config.isPasswordSignInOptionEnabled,
          equals(isPasswordSignInOptionEnabled),
        );
        expect(config.isDebugMenuEnabled, equals(isDebugMenuEnabled));
        expect(
          config.isPublicDashboardEnabled,
          equals(isPublicDashboardEnabled),
        );
      },
    );

    test(
      "equals to another FeatureConfig with the same parameters",
      () {
        const expected = FeatureConfig(
          isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
          isPublicDashboardEnabled: isPublicDashboardEnabled,
        );

        const featureConfig = FeatureConfig(
          isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
          isPublicDashboardEnabled: isPublicDashboardEnabled,
        );

        expect(featureConfig, equals(expected));
      },
    );
  });
}
