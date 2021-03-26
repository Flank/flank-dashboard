// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_instance_info.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsInstanceInfo", () {
    const version = "version";
    const instanceInfoMap = {
      'x-jenkins': version,
    };
    const instanceInfo = JenkinsInstanceInfo(version: version);

    test(
      "creates an instance with the given parameters",
      () {
        const instanceInfo = JenkinsInstanceInfo(version: version);

        expect(instanceInfo.version, equals(version));
      },
    );

    test(
      ".fromMap() returns null if the given map is null",
      () {
        final instanceInfo = JenkinsInstanceInfo.fromMap(null);

        expect(instanceInfo, isNull);
      },
    );

    test(
      ".fromMap() creates an instance from the given map",
      () {
        final actualInstanceInfo = JenkinsInstanceInfo.fromMap(instanceInfoMap);

        expect(actualInstanceInfo, equals(instanceInfo));
      },
    );

    test(
      ".toMap() converts an instance to the map",
      () {
        final map = instanceInfo.toMap();

        expect(map, equals(instanceInfoMap));
      },
    );

    test(
      ".toString() contains the map representaton of the jenkins info instance",
      () {
        final map = '${instanceInfo.toMap()}';

        expect(instanceInfo.toString(), contains(map));
      },
    );
  });
}
