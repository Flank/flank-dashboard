import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/navigation/models/page_parameters_model.dart';

/// The [ChangeNotifier] that provides an ability to handle page parameters.
abstract class PageNotifier extends ChangeNotifier {
  /// Provides the application's [PageParametersModel].
  PageParametersModel get parameters;

  /// Handles the application's page parameters using the given [parameters].
  void handlePageParameters(PageParametersModel parameters);
}
