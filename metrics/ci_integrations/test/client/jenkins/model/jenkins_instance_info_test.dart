// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/jenkins/model/jenkins_instance_info.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsInstanceInfo", () {
    const version = "version";
    const instanceInfoJson = {
      'X-Jenkins': version,
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
      ".fromJson() returns null if the given json is null",
      () {
        final instanceInfo = JenkinsInstanceInfo.fromJson(null);

        expect(instanceInfo, isNull);
      },
    );

    test(
      ".fromJson() creates an instance from the given json",
      () {
        final actualInstanceInfo =
            JenkinsInstanceInfo.fromJson(instanceInfoJson);

        expect(actualInstanceInfo, equals(instanceInfo));
      },
    );

    test(
      ".listFromJson() returns null if the given list is null",
      () {
        final list = JenkinsInstanceInfo.listFromJson(null);

        expect(list, isNull);
      },
    );

    test(
      ".listFromJson() returns an empty list if the given one is empty",
      () {
        final list = JenkinsInstanceInfo.listFromJson([]);

        expect(list, isEmpty);
      },
    );

    test(
      ".listFromJson() creates a list of Jenkins instance infos from the given list of JSON encodable objects",
      () {
        const anotherJson = {
          'X-Jenkins': '',
        };
        const anotherInstanceInfo = JenkinsInstanceInfo(
          version: '',
        );
        const jsonList = [instanceInfoJson, anotherJson];
        const expectedList = [instanceInfo, anotherInstanceInfo];

        final instanceList = JenkinsInstanceInfo.listFromJson(jsonList);

        expect(instanceList, equals(expectedList));
      },
    );

    test(
      ".toJson() converts an instance to the json encodable map",
      () {
        final json = instanceInfo.toJson();

        expect(json, equals(instanceInfoJson));
      },
    );
  });
}
