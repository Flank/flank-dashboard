/// Extends the [DateTime] with date getter.
extension Date on DateTime {
  /// Creates the [DateTime] with only date included.
  DateTime get date => DateTime(year, month, day);
}
