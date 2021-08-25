// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/feature_config/presentation/models/public_dashboard_feature_config_model.dart';
import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

void main() {
  group(
    "PublicDashboardFeatureConfigModel",
    () {
      const isEnabled = true;

      test(
        "throws an AssertionError if isEnabled parameter is null",
        () {
          expect(
            () => PublicDashboardFeatureConfigModel(isEnabled: null),
            throwsAssertionError,
          );
        },
      );

      test(
        "equals to another PublicDashboardFeatureConfigModel with the same parameters",
        () {
          const firstFeatureConfigModel =
              PublicDashboardFeatureConfigModel(isEnabled: isEnabled);
          const secondFeatureConfigModel =
              PublicDashboardFeatureConfigModel(isEnabled: isEnabled);

          expect(firstFeatureConfigModel, equals(secondFeatureConfigModel));
        },
      );
    },
  );
}
