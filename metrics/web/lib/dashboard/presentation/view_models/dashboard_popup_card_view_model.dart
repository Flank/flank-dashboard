import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A view model that represents the data of the build
/// to display in the [DashboardPopupCard].
class DashboardPopupCardViewModel extends Equatable {
  /// The abstract value of the build.
  ///
  /// Usually stands for the duration of the build this view model belongs to.
  /// But can be any other integer parameter of the build.
  final int value;

  /// The [DateTime] when the build is started.
  final DateTime startDate;

  @override
  List<Object> get props => [value, startDate];

  /// Creates a new instance of the [DashboardPopupCardViewModel].
  ///
  /// The [value] must not be null.
  /// The [startDate] must not be null.
  const DashboardPopupCardViewModel({
    @required this.value,
    @required this.startDate,
  })  : assert(value != null),
        assert(startDate != null);
}
