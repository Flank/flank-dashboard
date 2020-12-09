import 'package:meta/meta.dart';
import 'package:metrics/instant_config/presentation/view_models/instant_config_view_model.dart';

/// A view model that represents an instant config for the renderer display feature.
class RendererDisplayInstantConfigViewModel extends InstantConfigViewModel {
  /// Creates a new instance of the [RendererDisplayInstantConfigViewModel]
  /// with the given [isEnabled] value.
  const RendererDisplayInstantConfigViewModel({
    @required bool isEnabled,
  }) : super(isEnabled: isEnabled);
}
