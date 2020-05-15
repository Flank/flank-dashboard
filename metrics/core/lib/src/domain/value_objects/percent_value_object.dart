import '../../../metrics_core.dart';

/// A [ValueObject] represents a percent.
class PercentValueObject extends ValueObject<double> {
  @override
  final double value;

  /// Creates the [PercentValueObject] with the given [value].
  ///
  /// The [value] must be non-null and from 0.0, inclusive, to 1.0, inclusive.
  PercentValueObject(this.value) {
    ArgumentError.checkNotNull(value);

    if (value < 0.0 || value > 1.0) {
      throw ArgumentError(
          "The percent value should be in bounds from 0.0 inclusive to 1.0 inclusive");
    }
  }
}
