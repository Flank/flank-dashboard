import 'package:flutter/cupertino.dart';
import 'package:metrics/instant_config/presentation/view_models/instant_config_view_model.dart';

/// A view model that represents an instant config for the FPS monitor feature.
class FpsMonitorInstantConfigViewModel extends InstantConfigViewModel {
  /// Creates a new instance of the [FpsMonitorInstantConfigViewModel]
  /// with the given [isEnabled] value.
  const FpsMonitorInstantConfigViewModel({
    @required bool isEnabled,
  }) : super(isEnabled: isEnabled);
}
