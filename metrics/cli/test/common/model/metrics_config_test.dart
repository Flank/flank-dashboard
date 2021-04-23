// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/metrics_config.dart';
import 'package:cli/sentry/model/sentry_config.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsConfig", () {
    const clientId = 'clientId';
    const sentryDsn = 'sentryDsn';
    const sentryEnvironment = 'sentryEnvironment';
    const sentryRelease = 'sentryRelease';
    const sentryConfig = SentryConfig(
      dsn: sentryDsn,
      environment: sentryEnvironment,
      release: sentryRelease,
    );

    test("creates an instance with the given values", () {
      final config = MetricsConfig(
        googleSignInClientId: clientId,
        sentryConfig: sentryConfig,
      );

      expect(config.googleSignInClientId, equals(clientId));
      expect(config.sentryConfig, equals(sentryConfig));
    });

    test(".toMap() converts an instance to the map", () {
      final config = MetricsConfig(
        googleSignInClientId: clientId,
        sentryConfig: sentryConfig,
      );
      final expectedMap = {
        MetricsConfig.googleSignInClientIdName: clientId,
        ...sentryConfig.toMap(),
      };

      expect(config.toMap(), equals(expectedMap));
    });
  });
}
