import 'package:flutter/foundation.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:metrics/instant_config/presentation/view_models/debug_menu_instant_config_view_model.dart';
import 'package:metrics/instant_config/presentation/view_models/fps_monitor_instant_config_view_model.dart';
import 'package:metrics/instant_config/presentation/view_models/login_form_instant_config_view_model.dart';
import 'package:metrics/instant_config/presentation/view_models/renderer_display_instant_config_view_model.dart';

/// Stub implementation of the [InstantConfigNotifier].
///
/// Provides test implementation of the [InstantConfigNotifier] methods.
class InstantConfigNotifierStub extends ChangeNotifier
    implements InstantConfigNotifier {
  @override
  LoginFormInstantConfigViewModel get loginFormInstantConfigViewModel =>
      const LoginFormInstantConfigViewModel(isEnabled: true);

  @override
  FpsMonitorInstantConfigViewModel get fpsMonitorInstantConfigViewModel =>
      const FpsMonitorInstantConfigViewModel(isEnabled: true);

  @override
  RendererDisplayInstantConfigViewModel
      get rendererDisplayInstantConfigViewModel =>
          const RendererDisplayInstantConfigViewModel(isEnabled: true);

  @override
  DebugMenuInstantConfigViewModel get debugMenuInstantConfigViewModel =>
      const DebugMenuInstantConfigViewModel(isEnabled: true);

  @override
  Future<void> initializeInstantConfig() async {}

  @override
  bool get isLoading => false;

  @override
  bool get isInitialized => true;

  @override
  void setDefaults({
    bool isLoginFormEnabled = false,
    bool isFpsMonitorEnabled = false,
    bool isRendererDisplayEnabled = false,
    bool isDebugMenuEnabled = false,
  }) {}
}
