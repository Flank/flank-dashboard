import 'package:flutter/cupertino.dart';
import 'package:metrics/instant_config/presentation/view_models/instant_config_view_model.dart';

/// A view model that represents an instant config for the debug menu feature.
class DebugMenuInstantConfigViewModel extends InstantConfigViewModel {
  /// Creates a new instance of the [DebugMenuInstantConfigViewModel]
  /// with the given [isEnabled] value.
  const DebugMenuInstantConfigViewModel({
    @required bool isEnabled,
  }) : super(isEnabled: isEnabled);
}
