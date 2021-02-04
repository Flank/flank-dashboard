// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/util/validator/number_validator.dart';
import 'package:equatable/equatable.dart';

/// A class representing a range specifier for array-type properties in
/// Jenkins API requests.
class JenkinsQueryLimits extends Equatable {
  /// The lower bound of a range specified.
  final int lower;

  /// The upper bound of a range specified.
  final int upper;

  @override
  List<Object> get props => [lower, upper];

  /// Creates a range specifier with given [lower] and [upper] bounds.
  const JenkinsQueryLimits._({this.lower, this.upper});

  /// Checks [number] to be valid string representing a range-specifier edge.
  static bool _checkValueString(
    String number, {
    bool allowEmpty = true,
  }) {
    if (number == null) return false;
    if (allowEmpty && number.isEmpty) return true;
    final result = int.tryParse(number);
    return result != null && result >= 0;
  }

  /// Creates an empty range specifier with no edges.
  ///
  /// Requests with no range-specifier set will fetch the full data list.
  const JenkinsQueryLimits.empty() : this._();

  /// Parses a [query] with range-specifier to an instance of [JenkinsQueryLimits].
  ///
  /// Throws [FormatException] if parsing fails.
  factory JenkinsQueryLimits.fromQuery(String query) {
    if (query.startsWith('{') && query.endsWith('}')) {
      final limits = query
          .split(',')
          .map((substring) => substring.replaceAll(RegExp(r'[\{\}]'), ''))
          .toList();

      final limitsValid = limits.length < 3 &&
          limits.every((limit) {
            return _checkValueString(limit, allowEmpty: limits.length != 1);
          });

      if (!limitsValid) {
        throw FormatException('Wrong format for the range specifier $query');
      }

      if (limits.length == 1) {
        final limit = limits.first;
        final result = int.parse(limit);
        return JenkinsQueryLimits.at(result);
      } else {
        final lower = limits[0].isEmpty ? 0 : int.parse(limits[0]);
        final upper = limits[1].isEmpty ? 0 : int.parse(limits[1]);
        NumberValidator.checkPositiveRange(lower, upper);
        return JenkinsQueryLimits._(
          lower: lower,
          upper: upper,
        );
      }
    } else {
      throw FormatException('Query is not a range specifier $query');
    }
  }

  /// Creates a range specifier for the n-th element where `n` [number].
  ///
  /// The [number] must be non-negative and non-null. Otherwise,
  /// throws the [ArgumentError].
  ///
  /// Specifies the `{number}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.at(3)` stands for the third element.
  factory JenkinsQueryLimits.at(int number) {
    NumberValidator.checkPositive(number);
    return JenkinsQueryLimits._(lower: number, upper: number);
  }

  /// Creates a range specifier for the left-edged range (exclusive).
  ///
  /// The [number] must be non-negative and non-null. Otherwise,
  /// throws the [ArgumentError].
  ///
  /// Specifies the `{number+1,}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.startAfter(3)` stands for the range from the third
  ///     element (exclusive) to the end.
  factory JenkinsQueryLimits.startAfter(int number) {
    NumberValidator.checkPositive(number);
    return JenkinsQueryLimits._(lower: number + 1);
  }

  /// Creates a range specifier for the left-edged range (inclusive).
  ///
  /// The [number] must be non-negative and non-null. Otherwise,
  /// throws the [ArgumentError].
  ///
  /// Specifies the `{number,}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.startAt(3)` stands for the range from the third
  ///     element (inclusive) to the end.
  factory JenkinsQueryLimits.startAt(int number) {
    NumberValidator.checkPositive(number);
    return JenkinsQueryLimits._(lower: number);
  }

  /// Creates a range specifier for the right-edged range (exclusive).
  ///
  /// The [number] must be non-negative and non-null. Otherwise,
  /// throws the [ArgumentError].
  ///
  /// Specifies the `{,number}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.endBefore(3)` stands for the range from the begin
  ///     to the third element (exclusive).
  factory JenkinsQueryLimits.endBefore(int number) {
    NumberValidator.checkPositive(number);
    return JenkinsQueryLimits._(upper: number);
  }

  /// Creates a range specifier for the right-edged range (inclusive).
  ///
  /// The [number] must be non-negative and non-null. Otherwise,
  /// throws the [ArgumentError].
  ///
  /// Specifies the `{,number+1}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.endAt(3)` stands for the range from the begin
  ///     to the third element (inclusive).
  factory JenkinsQueryLimits.endAt(int number) {
    NumberValidator.checkPositive(number);
    return JenkinsQueryLimits._(upper: number + 1);
  }

  /// Creates a range specifier for the left-edged (inclusive) and
  /// right-edged (exclusive) range.
  ///
  /// Both [begin] and [end] must be non-negative and non-null, and the [begin]
  /// value must be greater than or equal to [end]. Otherwise, throws
  /// the [ArgumentError].
  ///
  /// Specifies the `{begin,end}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.between(3, 10)` stands for the range from the
  ///     third element (inclusive) to the tenth element (exclusive).
  factory JenkinsQueryLimits.between(int begin, int end) {
    NumberValidator.checkPositiveRange(begin, end);
    return JenkinsQueryLimits._(lower: begin, upper: end);
  }

  /// Converts an instance to the range specifier for Jenkins API.
  ///
  /// Returns empty string for the empty range.
  /// For example:
  /// ```dart
  ///   final limits = JenkinsQueryLimits.between(3, 10);
  ///   print(limits.toQuery()); // prints {3,10}
  /// ```
  String toQuery() {
    if (lower == null && upper == null) {
      return '';
    }

    if (lower != null && lower == upper) {
      return '{$lower}';
    }

    final lowerString = lower == null ? '' : lower.toString();
    final upperString = upper == null ? '' : upper.toString();

    return '{$lowerString,$upperString}';
  }

  @override
  String toString() {
    return 'JenkinsQueryLimits ${toQuery()}';
  }
}
