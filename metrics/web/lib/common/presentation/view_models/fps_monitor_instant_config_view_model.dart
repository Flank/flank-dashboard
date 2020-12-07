import 'package:metrics/common/presentation/view_models/instant_config_view_model.dart';

/// A view model that represents an instant config for the FPS monitor feature.
class FPSMonitorInstantConfigViewModel extends InstantConfigViewModel {
  /// Creates a new instance of the [FPSMonitorInstantConfigViewModel] 
  /// with the given [isEnabled].
  const FPSMonitorInstantConfigViewModel({
    bool isEnabled,
  }) : super(isEnabled: isEnabled);
}
