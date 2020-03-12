import 'package:meta/meta.dart';

/// A class representing a range specifier for array-type properties in
/// Jenkins API requests.
class JenkinsQueryLimits {
  /// The lower bound of a range specified.
  final int lower;

  /// The lower bound of a range specified.
  final int upper;

  /// Creates a range specifier with given [lower] and [upper] bounds.
  const JenkinsQueryLimits._({this.lower, this.upper});

  /// Checks [number] to be non-`null` positive integer;
  ///
  /// Throws [ArgumentError] if the [number] either is `null`
  /// or [num.isNegative].
  @visibleForTesting
  static void checkValue(int number) {
    if (number == null) {
      throw ArgumentError.notNull('number');
    } else if (number.isNegative) {
      throw ArgumentError.value(number, 'number', 'must be non-negative');
    }
  }

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

  /// Checks the range edges [begin] and [end] to be non-`null` positive
  /// integers and [end] to be greater than or equal to [begin].
  ///
  /// Throws [ArgumentError] if:
  ///   * one of [begin] or [end] is null;
  ///   * one of [begin] or [end] is negative;
  ///   * [end] is less than [begin].
  @visibleForTesting
  static void checkRange(int begin, int end) {
    if (begin == null || end == null) {
      throw ArgumentError('both begin and end must be specified');
    } else if (begin.isNegative || end.isNegative) {
      throw ArgumentError('both begin and end must be non-negative');
    } else if (end < begin) {
      throw ArgumentError('end must be greater than or equal to begin');
    }
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

      final limitsValid = (limits.length == 1 &&
              _checkValueString(limits.first, allowEmpty: false)) ||
          (limits.length < 3 && limits.every(_checkValueString));

      if (!limitsValid) {
        throw FormatException('Wrong format for the range specifier $query');
      }

      if (limits.length == 1) {
        final limit = limits.first;
        final result = int.parse(limit);
        return JenkinsQueryLimits.at(result);
      } else {
        return JenkinsQueryLimits._(
          lower: limits[0].isEmpty ? 0 : int.parse(limits[0]),
          upper: limits[1].isEmpty ? 0 : int.parse(limits[1]),
        );
      }
    } else {
      throw FormatException('Query is not a range specifier $query');
    }
  }

  /// Creates a range specifier for the n-th element
  /// where `n` is a given [number].
  ///
  /// Specifies the `{number}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.at(3)` stands for the third element.
  factory JenkinsQueryLimits.at(int number) {
    checkValue(number);
    return JenkinsQueryLimits._(lower: number, upper: number);
  }

  /// Creates a range specifier for the left-edged range (exclusive).
  ///
  /// Specifies the `{number+1,}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.startAfter(3)` stands for the range from the third
  ///     element (exclusive) to the end.
  factory JenkinsQueryLimits.startAfter(int number) {
    checkValue(number);
    return JenkinsQueryLimits._(lower: number + 1);
  }

  /// Creates a range specifier for the left-edged range (inclusive).
  ///
  /// Specifies the `{number,}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.startAt(3)` stands for the range from the third
  ///     element (inclusive) to the end.
  factory JenkinsQueryLimits.startAt(int number) {
    checkValue(number);
    return JenkinsQueryLimits._(lower: number);
  }

  /// Creates a range specifier for the right-edged range (exclusive).
  ///
  /// Specifies the `{,number}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.endBefore(3)` stands for the range from the begin
  ///     to the third element (exclusive).
  factory JenkinsQueryLimits.endBefore(int number) {
    checkValue(number);
    return JenkinsQueryLimits._(upper: number);
  }

  /// Creates a range specifier for the right-edged range (inclusive).
  ///
  /// Specifies the `{,number+1}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.endAt(3)` stands for the range from the begin
  ///     to the third element (inclusive).
  factory JenkinsQueryLimits.endAt(int number) {
    checkValue(number);
    return JenkinsQueryLimits._(upper: number + 1);
  }

  /// Creates a range specifier for the left-edged (inclusive) and
  /// right-edged (exclusive) range.
  ///
  /// Specifies the `{begin,end}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.between(3, 10)` stands for the range from the
  ///     third element (inclusive) to the tenth element (exclusive).
  factory JenkinsQueryLimits.between(int begin, int end) {
    checkRange(begin, end);
    return JenkinsQueryLimits._(lower: begin, upper: end);
  }

  /// Creates a range specifier for the left-edged (inclusive) and
  /// right-edged (inclusive) range.
  ///
  /// Specifies the `{begin,end+1}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.betweenInclusive(3, 10)` stands for the range from
  ///     the third element (inclusive) to the tenth element (inclusive).
  factory JenkinsQueryLimits.betweenInclusive(int begin, int end) {
    checkRange(begin, end);
    return JenkinsQueryLimits._(lower: begin, upper: end + 1);
  }

  /// Creates a range specifier for the left-edged (exclusive) and
  /// right-edged (exclusive) range.
  ///
  /// Specifies the `{begin+1,end}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.betweenInclusive(3, 10)` stands for the range from
  ///     the third element (exclusive) to the tenth element (exclusive).
  factory JenkinsQueryLimits.betweenExclusive(int begin, int end) {
    checkRange(begin, end);
    return JenkinsQueryLimits._(lower: begin + 1, upper: end);
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
    return '$runtimeType ${toQuery()}';
  }
}
