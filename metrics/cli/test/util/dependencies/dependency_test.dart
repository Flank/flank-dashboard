// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/util/dependencies/dependency.dart';
import 'package:test/test.dart';

void main() {
  group("Dependency", () {
    const recommendedVersion = '1';
    const installUrl = 'url.com';
    const dependencyMap = {
      'recommended_version': recommendedVersion,
      'install_url': installUrl,
    };

    test(
      "creates a new instance with the given parameters",
      () {
        const dependency = Dependency(
          recommendedVersion: recommendedVersion,
          installUrl: installUrl,
        );

        expect(dependency.recommendedVersion, equals(recommendedVersion));
        expect(dependency.installUrl, equals(installUrl));
      },
    );

    test(
      ".fromMap() returns null if the given json is null",
      () {
        final dependency = Dependency.fromMap(null);

        expect(dependency, isNull);
      },
    );

    test(
      ".fromMap() creates an instance from the given map",
      () {
        final dependency = Dependency.fromMap(dependencyMap);

        expect(dependency, isA<Dependency>());
        expect(dependency.recommendedVersion, equals(recommendedVersion));
        expect(dependency.installUrl, equals(installUrl));
      },
    );

    test(
      "equals to another Dependency with the same parameters",
      () {
        final dependency = Dependency.fromMap(dependencyMap);
        final anotherDependency = Dependency.fromMap(dependencyMap);

        expect(dependency, equals(anotherDependency));
      },
    );
  });
}
