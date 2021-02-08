// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the code coverage entity.
class Coverage extends Equatable {
  /// The code coverage percent.
  final Percent percent;

  @override
  List<Object> get props => [percent];

  /// Creates the [Coverage] with the given [percent].
  const Coverage({
    this.percent,
  });
}
