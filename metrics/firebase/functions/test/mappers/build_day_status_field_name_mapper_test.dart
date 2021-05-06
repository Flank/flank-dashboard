// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:functions/mappers/build_day_status_field_name_mapper.dart';
import 'package:functions/models/build_day_status_field_name.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDayStatusFieldNameMapper", () {
    const statusFieldMapper = BuildDayStatusFieldNameMapper();

    test(
      ".map() maps the BuildStatus.successful to the successful field name value",
      () {
        const expectedFieldName = BuildDayStatusFieldName.successful;

        final fieldName = statusFieldMapper.map(BuildStatus.successful);

        expect(fieldName, equals(expectedFieldName));
      },
    );

    test(
      ".map() maps the BuildStatus.failed to the failed field name value",
      () {
        const expectedFieldName = BuildDayStatusFieldName.failed;

        final fieldName = statusFieldMapper.map(BuildStatus.failed);

        expect(fieldName, equals(expectedFieldName));
      },
    );

    test(
      ".map() maps the BuildStatus.unknown to the unknown field name value",
      () {
        const expectedFieldName = BuildDayStatusFieldName.unknown;

        final fieldName = statusFieldMapper.map(BuildStatus.unknown);

        expect(fieldName, equals(expectedFieldName));
      },
    );

    test(
      ".map() maps the BuildStatus.inProgress to the inProgress field name value",
      () {
        const expectedFieldName = BuildDayStatusFieldName.inProgress;

        final fieldName = statusFieldMapper.map(BuildStatus.inProgress);

        expect(fieldName, equals(expectedFieldName));
      },
    );

    test(
      ".map() maps the null build status to the unknown field name value",
      () {
        const expectedFieldName = BuildDayStatusFieldName.unknown;

        final fieldName = statusFieldMapper.map(null);

        expect(fieldName, equals(expectedFieldName));
      },
    );
  });
}
