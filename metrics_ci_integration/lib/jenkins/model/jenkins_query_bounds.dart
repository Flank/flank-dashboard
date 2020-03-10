/// A class representing a range specifier for array-type properties in
/// Jenkins API requests.
class JenkinsQueryLimits {
  /// The lower bound of a range specified.
  final int _lower;

  /// The lower bound of a range specified.
  final int _upper;

  /// Creates a range specifier with given [lower] and [upper] bounds.
  const JenkinsQueryLimits._({int lower, int upper})
      : _lower = lower,
        _upper = upper;

  /// Checks [number] to be non-`null` positive integer;
  ///
  /// Throws [ArgumentError] if the [number] either is `null`
  /// or [num.isNegative].
  static void _checkValue(int number) {
    if (number == null) {
      throw ArgumentError.notNull('number');
    } else if (number.isNegative) {
      throw ArgumentError.value(number, 'number', 'must be positive');
    }
  }

  /// Checks the range edges [begin] and [end] to be non-`null` positive
  /// integers and [end] to be greater than or equal to [begin].
  ///
  /// Throws [ArgumentError] if:
  ///   * one of [begin] or [end] is null;
  ///   * one of [begin] or [end] is negative;
  ///   * [end] is less than [begin].
  static void _checkRange(int begin, int end) {
    if (begin == null || end == null) {
      throw ArgumentError('both begin and end must be specified');
    } else if (begin.isNegative || end.isNegative) {
      throw ArgumentError('both begin and end must be positive');
    } else if (end < begin) {
      throw ArgumentError('end must be greater than or equal to begin');
    }
  }

  /// Creates an empty range specifier with no edges.
  ///
  /// Requests with no range-specifier set will fetch the full data list.
  const JenkinsQueryLimits.empty() : this._();

  /// Creates a range specifier for the n-th element
  /// where `n` is a given [number].
  ///
  /// Specifies the `{number}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.at(3)` stands for the third element.
  factory JenkinsQueryLimits.at(int number) {
    _checkValue(number);
    return JenkinsQueryLimits._(lower: number, upper: number);
  }

  /// Creates a range specifier for the left-edged range (exclusive).
  ///
  /// Specifies the `{number+1,}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.startAfter(3)` stands for the range from third
  ///     element (exclusive) to the end.
  factory JenkinsQueryLimits.startAfter(int number) {
    _checkValue(number);
    return JenkinsQueryLimits._(lower: number + 1);
  }

  /// Creates a range specifier for the left-edged range (inclusive).
  ///
  /// Specifies the `{number,}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.startAt(3)` stands for the range from third
  ///     element (inclusive) to the end.
  factory JenkinsQueryLimits.startAt(int number) {
    _checkValue(number);
    return JenkinsQueryLimits._(lower: number);
  }

  /// Creates a range specifier for the right-edged range (exclusive).
  ///
  /// Specifies the `{,number}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.endBefore(3)` stands for the range from the begin
  ///     to the third element (exclusive).
  factory JenkinsQueryLimits.endBefore(int number) {
    _checkValue(number);
    return JenkinsQueryLimits._(upper: number);
  }

  /// Creates a range specifier for the right-edged range (inclusive).
  ///
  /// Specifies the `{,number+1}` range.
  /// For example:
  ///   * `JenkinsQueryLimits.endAt(3)` stands for the range from the begin
  ///     to the third element (inclusive).
  factory JenkinsQueryLimits.endAt(int number) {
    _checkValue(number);
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
    _checkRange(begin, end);
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
    _checkRange(begin, end);
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
    _checkRange(begin, end);
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
    if (_lower == null && _upper == null) {
      return '';
    }

    if (_lower != null && _lower == _upper) {
      return '{$_lower}';
    }

    final lowerString = _lower == null ? '' : _lower.toString();
    final upperString = _upper == null ? '' : _upper.toString();

    return '{$lowerString,$upperString}';
  }

  @override
  String toString() {
    return '$runtimeType ${toQuery()}';
  }
}
