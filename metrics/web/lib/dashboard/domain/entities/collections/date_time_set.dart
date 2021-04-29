// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set_entry.dart';

/// Represents the set of the [DateTimeSetEntry]s with elements
/// in set unique by [DateTimeSetEntry.date].
///
/// Inherits all behavior from [LinkedHashSet] - the default [Set] implementation,
/// except equality and hashCode functions.
class DateTimeSet<T extends DateTimeSetEntry> extends DelegatingSet<T> {
  /// Creates an empty [DateTimeSet].
  DateTimeSet()
      : super(LinkedHashSet<T>(
          equals: (entry1, entry2) => entry1?.date == entry2?.date,
          hashCode: (entry) => entry?.date.hashCode,
        ));

  /// Creates the [DateTimeSet] that contains all elements from [iterable] with
  /// unique date.
  factory DateTimeSet.from(Iterable<T> iterable) {
    final set = DateTimeSet<T>();

    for (final entry in iterable) {
      set.add(entry);
    }

    return set;
  }
}
