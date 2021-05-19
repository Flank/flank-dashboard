// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:functions/factory/build_day_status_field_factory.dart';
import 'package:functions/mappers/build_day_status_field_name_mapper.dart';
import 'package:functions/models/build_day_status_field_name.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("BuildDayStatusFieldFactory", () {
    const buildStatus = BuildStatus.successful;
    const buildDayStatusFieldName = BuildDayStatusFieldName.successful;
    const incrementCount = 1;
    final buildDayStatusFieldFactory = BuildDayStatusFieldFactory();

    test(
      "throws an ArgumentError if the given build day status field name mapper is null",
      () {
        expect(
          () => BuildDayStatusFieldFactory(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() throws an ArgumentError if the given build status is null",
      () {
        expect(
          () => buildDayStatusFieldFactory.create(
            buildStatus: null,
            incrementCount: incrementCount,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() throws an ArgumentError if the given increment count is null",
      () {
        expect(
          () => buildDayStatusFieldFactory.create(
            buildStatus: buildStatus,
            incrementCount: null,
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      ".create() creates a BuildDayStatusField using the given build day status field name mapper",
      () {
        final statusFieldMapper = _BuildDayStatusFieldNameMapperMock();
        final buildDayStatusFieldFactory = BuildDayStatusFieldFactory(
          statusFieldMapper,
        );

        when(statusFieldMapper.map(any)).thenReturn(buildDayStatusFieldName);

        buildDayStatusFieldFactory.create(
          buildStatus: buildStatus,
          incrementCount: incrementCount,
        );

        verify(statusFieldMapper.map(buildStatus)).called(1);
      },
    );

    test(
      ".create() creates a BuildDayStatusField with the given parameters",
      () {
        final expectedStatusFieldValue = Firestore.fieldValues.increment(1);

        final buildDayStatusField = buildDayStatusFieldFactory.create(
          buildStatus: buildStatus,
          incrementCount: incrementCount,
        );

        expect(buildDayStatusField.name, equals(buildDayStatusFieldName));
        expect(
          buildDayStatusField.value.toString(),
          equals(expectedStatusFieldValue.toString()),
        );
      },
    );
  });
}

class _BuildDayStatusFieldNameMapperMock extends Mock
    implements BuildDayStatusFieldNameMapper {}
