// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
// import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:functions/mappers/build_day_status_field_name_mapper.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDayStatusFieldNameMapper", () {
    const mapper = BuildDayStatusFieldNameMapper();

    test(
      ".map() maps the BuildStatus.successful to the successful field name value",
      () {
        const expectedFieldName = 'successful';

        final fieldName = mapper.map(BuildStatus.successful);

        expect(fieldName, equals(expectedFieldName));
      },
    );

    test(
      ".map() maps the BuildStatus.failed to the failed field name value",
      () {
        const expectedFieldName = 'failed';

        final fieldName = mapper.map(BuildStatus.failed);

        expect(fieldName, equals(expectedFieldName));
      },
    );

    test(
      ".map() maps the BuildStatus.unknown to the unknown field name value",
      () {
        const expectedFieldName = 'unknown';

        final fieldName = mapper.map(BuildStatus.unknown);

        expect(fieldName, equals(expectedFieldName));
      },
    );

    test(
      ".map() maps the BuildStatus.inProgress to the inProgress field name value",
      () {
        const expectedFieldName = 'inProgress';

        final fieldName = mapper.map(BuildStatus.inProgress);

        expect(fieldName, equals(expectedFieldName));
      },
    );
  });
}
