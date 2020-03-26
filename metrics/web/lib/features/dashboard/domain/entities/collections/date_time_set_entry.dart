import 'package:meta/meta.dart';
import 'package:metrics/features/dashboard/domain/entities/collections/date_time_set.dart';

/// Represents the element of the [DateTimeSet].
@immutable
abstract class DateTimeSetEntry {
  DateTime get date;
}
