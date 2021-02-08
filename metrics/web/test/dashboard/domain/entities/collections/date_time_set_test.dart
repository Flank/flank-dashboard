// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set_entry.dart';
import 'package:test/test.dart';

void main() {
  test(
    "Creates the set of elements with the unique date",
    () {
      final currentTimestamp = DateTime.now();
      final testData = [
        _DateTimeSetData(
          date: currentTimestamp,
        ),
        _DateTimeSetData(
          date: currentTimestamp,
        ),
      ];

      final dateTimeSet = DateTimeSet.from(testData);

      expect(dateTimeSet.length, 1);
    },
  );

  test(
    "Creates the set of elements from the list of elements with unique dates",
    () {
      final testData = [
        _DateTimeSetData(
          date: DateTime(2019),
        ),
        _DateTimeSetData(
          date: DateTime(2020),
        ),
      ];

      final dateTimeSet = DateTimeSet.from(testData);

      expect(dateTimeSet.length, 2);
    },
  );

  test(
    "Not changes the set on adding an element if an entity with the same date exists",
    () {
      final currentDate = DateTime.now();

      final initialDateTimeSet = DateTimeSet.from([
        _DateTimeSetData(
          date: currentDate,
          id: '1',
        ),
      ]);

      final dateTimeSet = DateTimeSet.from(initialDateTimeSet);

      dateTimeSet.add(
        _DateTimeSetData(
          date: currentDate,
          id: '2',
        ),
      );

      expect(initialDateTimeSet, equals(dateTimeSet));
    },
  );

  test("The null value could be added to set", () {
    final dateTimeSet = DateTimeSet.from([
      _DateTimeSetData(
        date: DateTime.now(),
        id: '2',
      ),
    ]);

    dateTimeSet.add(null);

    expect(dateTimeSet, contains(isNull));
  });
}

class _DateTimeSetData extends DateTimeSetEntry {
  @override
  final DateTime date;
  final String id;

  _DateTimeSetData({
    this.date,
    this.id,
  });
}
