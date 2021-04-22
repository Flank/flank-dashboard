// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/metrics_config.dart';
import 'package:test/test.dart';

void main() {
  group("MetricsConfig", () {
    const clientId = 'clientId';
    const sentryDsn = 'sentryDsn';
    const sentryEnvironment = 'sentryEnvironment';
    const sentryRelease = 'sentryRelease';

    test("creates an instance with the given values", () {
      final config = MetricsConfig(
        googleSignInClientId: clientId,
        sentryDsn: sentryDsn,
        sentryEnvironment: sentryEnvironment,
        sentryRelease: sentryRelease,
      );

      expect(config.googleSignInClientId, equals(clientId));
      expect(config.sentryDsn, equals(sentryDsn));
      expect(config.sentryEnvironment, equals(sentryEnvironment));
      expect(config.sentryRelease, equals(sentryRelease));
    });

    test(".toMap() converts an instance to the map", () {
      final config = MetricsConfig(
        googleSignInClientId: clientId,
        sentryDsn: sentryDsn,
        sentryEnvironment: sentryEnvironment,
        sentryRelease: sentryRelease,
      );
      const expectedMap = {
        MetricsConfig.googleSignInClientIdName: clientId,
        MetricsConfig.sentryDsnName: sentryDsn,
        MetricsConfig.sentryEnvironmentName: sentryEnvironment,
        MetricsConfig.sentryReleaseName: sentryRelease,
      };

      expect(config.toMap(), equals(expectedMap));
    });
  });
}
