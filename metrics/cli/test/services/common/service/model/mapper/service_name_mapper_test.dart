// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/service/model/mapper/service_name_mapper.dart';
import 'package:cli/services/common/service/model/service_name.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("ServiceNameMapper", () {
    const mapper = ServiceNameMapper();

    test(
      ".map() maps the firebase service name to the ServiceName.firebase",
      () {
        const expectedName = ServiceName.firebase;

        final name = mapper.map(ServiceNameMapper.firebase);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".map() maps the flutter service name to the ServiceName.flutter",
      () {
        const expectedName = ServiceName.flutter;

        final name = mapper.map(ServiceNameMapper.flutter);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".map() maps the gcloud service name to the ServiceName.gcloud",
      () {
        const expectedName = ServiceName.gcloud;

        final name = mapper.map(ServiceNameMapper.gcloud);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".map() maps the git service name to the ServiceName.git",
      () {
        const expectedName = ServiceName.git;

        final name = mapper.map(ServiceNameMapper.git);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".map() maps the npm service name to the ServiceName.npm",
      () {
        const expectedName = ServiceName.npm;

        final name = mapper.map(ServiceNameMapper.npm);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".map() maps the sentry service name to the ServiceName.sentry",
      () {
        const expectedName = ServiceName.sentry;

        final name = mapper.map(ServiceNameMapper.sentry);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".map() maps the not specified service name to null",
      () {
        final name = mapper.map(const ValidationTarget(name: 'Test'));

        expect(name, isNull);
      },
    );

    test(
      ".map() maps the null service name to null",
      () {
        final name = mapper.map(null);

        expect(name, isNull);
      },
    );

    test(
      ".unmap() unmaps the ServiceName.firebase to the firebase service name",
      () {
        const expectedName = ServiceNameMapper.firebase;

        final name = mapper.unmap(ServiceName.firebase);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".unmap() unmaps the ServiceName.flutter to the flutter service name",
      () {
        const expectedName = ServiceNameMapper.flutter;

        final name = mapper.unmap(ServiceName.flutter);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".unmap() unmaps the ServiceName.gcloud to the gcloud service name",
      () {
        const expectedName = ServiceNameMapper.gcloud;

        final name = mapper.unmap(ServiceName.gcloud);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".unmap() unmaps the ServiceName.git to the git service name",
      () {
        const expectedName = ServiceNameMapper.git;

        final name = mapper.unmap(ServiceName.git);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".unmap() unmaps the ServiceName.npm to the npm service name",
      () {
        const expectedName = ServiceNameMapper.npm;

        final name = mapper.unmap(ServiceName.npm);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".unmap() unmaps the ServiceName.sentry to the sentry service name",
      () {
        const expectedName = ServiceNameMapper.sentry;

        final name = mapper.unmap(ServiceName.sentry);

        expect(name, equals(expectedName));
      },
    );

    test(
      ".unmap() unmaps the null to null",
      () {
        final name = mapper.unmap(null);

        expect(name, isNull);
      },
    );
  });
}
