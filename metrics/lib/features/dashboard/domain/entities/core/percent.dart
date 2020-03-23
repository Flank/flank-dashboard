import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the percent.
@immutable
class Percent extends Equatable {
  final double value;

  /// Creates the [Percent] with the given [value].
  ///
  /// The [value] must be non-null and from 0.0, inclusive, to 1.0, inclusive.
  const Percent(this.value)
      : assert(value != null),
        assert(value >= 0.0 && value <= 1.0);

  @override
  List<Object> get props => [value];
}
