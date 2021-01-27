/// An util class that provides methods for validating numbers.
class NumberValidator {
  /// Checks the given [number] to be non-`null` positive integer.
  ///
  /// Throws an [ArgumentError] if the [number] either is `null`
  /// or [num.isNegative].
  static void checkPositive(int number) {
    if (number == null) {
      throw ArgumentError.notNull('number');
    } else if (number.isNegative) {
      throw ArgumentError.value(number, 'number', 'must be non-negative');
    }
  }

  /// Checks the range edges [begin] and [end] to be non-`null` positive
  /// integers and [end] to be greater than or equal to [begin].
  ///
  /// Throws an [ArgumentError] if:
  ///   * one of [begin] or [end] is null;
  ///   * one of [begin] or [end] is negative;
  ///   * [end] is less than [begin].
  static void checkPositiveRange(int begin, int end) {
    if (begin == null || end == null) {
      throw ArgumentError('both begin and end must be specified');
    } else if (begin.isNegative || end.isNegative) {
      throw ArgumentError('both begin and end must be non-negative');
    } else if (end < begin) {
      throw ArgumentError('end must be greater than or equal to begin');
    }
  }

  /// Checks the given [number] to be greater than the given [numberToCompare].
  ///
  /// Throws an [ArgumentError] if:
  ///   * one of the [number] or [numberToCompare] is `null`;
  ///   * [number] is not grater than [numberToCompare].
  static void checkGreaterThan(int number, int numberToCompare) {
    if (number == null || numberToCompare == null) {
      throw ArgumentError(
        'both given number and number to compare must be specified',
      );
    } else if (number <= numberToCompare) {
      throw ArgumentError.value(
        number,
        'number',
        'must be grater than $numberToCompare',
      );
    }
  }
}
