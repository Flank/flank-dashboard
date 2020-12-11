import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/feature_config/domain/entities/feature_config.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("FeatureConfig", () {
    test(
      "creates an instance with the given parameters",
      () {
        const isPasswordSignInOptionEnabled = true;
        const isDebugMenuEnabled = true;

        final config = FeatureConfig(
          isPasswordSignInOptionEnabled: isPasswordSignInOptionEnabled,
          isDebugMenuEnabled: isDebugMenuEnabled,
        );

        expect(config.isPasswordSignInOptionEnabled,
            equals(isPasswordSignInOptionEnabled));
        expect(config.isDebugMenuEnabled, equals(isDebugMenuEnabled));
      },
    );
  });
}
