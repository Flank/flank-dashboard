import 'package:meta/meta.dart';
import 'package:metrics/dashboard/domain/entities/collections/date_time_set.dart';

/// Represents the element of the [DateTimeSet].
@immutable
abstract class DateTimeSetEntry {
  /// A [DateTime] value.
  DateTime get date;
}
