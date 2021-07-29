// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/models/page_parameters_model.dart';

/// A base class for [ChangeNotifier]s that provides an ability to handle
/// page parameters.
abstract class PageNotifier extends ChangeNotifier {
  /// Provides the page's [PageParametersModel].
  PageParametersModel get pageParameters;

  /// Updates the [PageParametersModel] for the specific page using the given
  /// [parameters].
  void handlePageParameters(PageParametersModel parameters);
}
