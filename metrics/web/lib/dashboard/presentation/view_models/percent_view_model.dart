import 'package:equatable/equatable.dart';

/// A view model that contains the data for the percent displaying widgets.
class PercentViewModel extends Equatable {
  /// The percent value.
  final double value;

  @override
  List<Object> get props => [value];

  /// Creates the [PercentViewModel] with the given percent [value].
  const PercentViewModel(this.value);
}
