// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/feature_config/domain/entities/feature_config.dart';

void main() {
  group("FeatureConfig", () {
    test(
      "creates an instance with the given parameters",
      () {
        const isPasswordSignInOptionEnabled = true;
        const isDebugMenuEnabled = true;
        const isPublicDashboardFeatureEnabled = true;

        const config = FeatureConfig(
            isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
            isDebugMenuEnabled: isDebugMenuEnabled,
            isPublicDashboardFeatureEnabled: isPublicDashboardFeatureEnabled);

        expect(config.isPasswordSignInOptionEnabled,
            equals(isPasswordSignInOptionEnabled));
        expect(config.isDebugMenuEnabled, equals(isDebugMenuEnabled));
        expect(config.isPublicDashboardFeatureEnabled,
            equals(isPublicDashboardFeatureEnabled));
      },
    );
  });
}
