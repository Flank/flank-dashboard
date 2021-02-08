// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// Extends the [DateTime] with date getter.
extension Date on DateTime {
  /// Creates the [DateTime] with only date included.
  DateTime get date => DateTime(year, month, day);
}
