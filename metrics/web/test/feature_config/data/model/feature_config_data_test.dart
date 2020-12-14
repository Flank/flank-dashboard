import 'package:metrics/feature_config/data/model/feature_config_data.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("FeatureConfigData", () {
    const isPasswordSignInOptionEnabled = true;
    const isDebugMenuEnabled = true;

    const json = {
      'isPasswordSignInOptionEnabled': isPasswordSignInOptionEnabled,
      'isDebugMenuEnabled': isDebugMenuEnabled,
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
        final expectedConfig = FeatureConfigData(
          isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
        );

        final config = FeatureConfigData.fromJson(json);

        expect(config, equals(expectedConfig));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final config = FeatureConfigData(
          isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
        );

        expect(config.toJson(), equals(json));
      },
    );
  });
}
