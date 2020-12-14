import 'package:meta/meta.dart';
import 'package:metrics/feature_config/presentation/view_models/feature_config_view_model.dart';

/// A view model that represents a feature config for the debug menu feature.
class DebugMenuFeatureConfigViewModel extends FeatureConfigViewModel {
  /// Creates a new instance of the [DebugMenuFeatureConfigViewModel]
  /// with the given [isEnabled] value.
  const DebugMenuFeatureConfigViewModel({
    @required bool isEnabled,
  }) : super(isEnabled: isEnabled);
}
