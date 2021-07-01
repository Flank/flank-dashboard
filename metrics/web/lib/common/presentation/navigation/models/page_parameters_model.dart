// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';

/// An abstract class, that represents the application page parameters.
abstract class PageParametersModel extends Equatable {
  /// Converts the [PageParametersModel] to the [Map].
  Map<String, dynamic> toMap();
}
