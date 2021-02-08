// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

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
