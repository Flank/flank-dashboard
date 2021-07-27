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
    const dependency = Dependency(
      recommendedVersion: recommendedVersion,
      installUrl: installUrl,
    );

    final dependenciesMap = {
      service: {
        'recommended_version': dependency.recommendedVersion,
        'install_url': dependency.installUrl,
      }
    };
    final dependencies = <String, Dependency>{'service': dependency};

    test(
      "throws an ArgumentError if the given map is null",
      () {
        expect(() => Dependencies(null), throwsArgumentError);
      },
    );

    test(
      "creates a new instance with the given parameters",
      () {
        expect(() => Dependencies(dependencies), returnsNormally);
      },
    );

    test(
      ".fromMap() returns null if the given map is null",
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
        final actualDependency = dependencies.getFor(service);

        expect(actualDependency, equals(dependency));
      },
    );
  });
}
