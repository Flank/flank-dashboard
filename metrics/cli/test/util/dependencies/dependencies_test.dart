// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/util/dependencies/dependencies.dart';
import 'package:cli/util/dependencies/dependency.dart';
import 'package:test/test.dart';

void main() {
  group("Dependencies", () {
    const recommendedVersion = '1';
    const installUrl = 'url.com';
    const service = 'service';
    const dependencyMap = {
      'recommended_version': recommendedVersion,
      'install_url': installUrl,
    };
    const dependenciesMap = {
      service: {
        'recommended_version': recommendedVersion,
        'install_url': installUrl,
      }
    };
    final dependency = Dependency.fromMap(dependencyMap);
    final dependencies = <String, Dependency>{'service': dependency};

    test(
      "creates a new instance with the given parameters",
      () {
        expect(() => Dependencies(dependencies), returnsNormally);
      },
    );

    test(
      ".fromMap() returns null if the given json is null",
      () {
        final dependencies = Dependencies.fromMap(null);

        expect(dependencies, isNull);
      },
    );

    test(
      ".fromMap() creates an instance from the given map",
      () {
        final dependencies = Dependencies.fromMap(dependenciesMap);

        expect(dependencies, isA<Dependencies>());
      },
    );

    test(
      "equals to another Dependencies with the same parameters",
      () {
        final dependencies = Dependencies.fromMap(dependenciesMap);
        final anotherDependencies = Dependencies.fromMap(dependenciesMap);

        expect(dependencies, equals(anotherDependencies));
      },
    );

    test(
      ".getFor() returns a dependency for the given service",
      () {
        final dependencies = Dependencies.fromMap(dependenciesMap);
        final dependency = dependencies.getFor(service);

        expect(dependency, isA<Dependency>());
        expect(dependency.recommendedVersion, equals(recommendedVersion));
        expect(dependency.installUrl, equals(installUrl));
      },
    );
  });
}
