// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/sentry_web_config.dart';
import 'package:cli/common/model/web_metrics_config.dart';
import 'package:test/test.dart';

void main() {
  group("WebMetricsConfig", () {
    const clientId = 'clientId';
    const sentryDsn = 'sentryDsn';
    const sentryEnvironment = 'sentryEnvironment';
    const sentryRelease = 'sentryRelease';
    const sentryWebConfig = SentryWebConfig(
      dsn: sentryDsn,
      environment: sentryEnvironment,
      release: sentryRelease,
    );

    test(
      "creates an instance with the given values",
      () {
        final config = WebMetricsConfig(
          googleSignInClientId: clientId,
          sentryWebConfig: sentryWebConfig,
        );

        expect(config.googleSignInClientId, equals(clientId));
        expect(config.sentryWebConfig, equals(sentryWebConfig));
      },
    );

    test(
      ".toMap() converts an instance to the map",
      () {
        final config = WebMetricsConfig(
          googleSignInClientId: clientId,
          sentryWebConfig: sentryWebConfig,
        );
        final expectedMap = {
          WebMetricsConfig.googleSignInClientIdName: clientId,
          WebMetricsConfig.sentryDsnName: sentryDsn,
          WebMetricsConfig.sentryEnvironmentName: sentryEnvironment,
          WebMetricsConfig.sentryReleaseName: sentryRelease,
        };

        expect(config.toMap(), equals(expectedMap));
      },
    );
  });
}
