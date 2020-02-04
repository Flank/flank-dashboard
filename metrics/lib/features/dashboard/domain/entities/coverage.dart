import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// Represents the project coverage.
class Coverage extends Equatable {
  final double percent;

  const Coverage({@required this.percent})
      : assert(percent != null && percent >= 0 && percent <= 1);

  @override
  List<Object> get props => [percent];
}
