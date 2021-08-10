// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/feature_config/data/model/feature_config_data.dart';
import 'package:test/test.dart';

void main() {
  group("FeatureConfigData", () {
    const isPasswordSignInOptionEnabled = true;
    const isDebugMenuEnabled = true;
    const isPublicDashboardFeatureEnabled = true;

    const json = {
      'isPasswordSignInOptionEnabled': isPasswordSignInOptionEnabled,
      'isDebugMenuEnabled': isDebugMenuEnabled,
      'isPublicDashboardEnabled': isPublicDashboardFeatureEnabled
    };

    test(
      ".fromJson() returns null if the given json is null",
      () {
        final config = FeatureConfigData.fromJson(null);

        expect(config, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        const expectedConfig = FeatureConfigData(
            isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
            isDebugMenuEnabled: isDebugMenuEnabled,
            isPublicDashboardFeatureEnabled: isPublicDashboardFeatureEnabled);

        final config = FeatureConfigData.fromJson(json);

        expect(config, equals(expectedConfig));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        const config = FeatureConfigData(
            isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
            isDebugMenuEnabled: isDebugMenuEnabled,
            isPublicDashboardFeatureEnabled: isPublicDashboardFeatureEnabled);

        expect(config.toJson(), equals(json));
      },
    );
  });
}
