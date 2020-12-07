import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/state/instant_config_notifier.dart';
import 'package:metrics/common/presentation/view_models/renderer_display_instant_config_view_model.dart';
import 'package:metrics/common/presentation/view_models/login_form_instant_config_view_model.dart';
import 'package:metrics/common/presentation/view_models/fps_monitor_instant_config_view_model.dart';

/// Stub implementation of the [InstantConfigNotifier].
///
/// Provides test implementation of the [InstantConfigNotifier] methods.
class InstantConfigNotifierStub extends ChangeNotifier
    implements InstantConfigNotifier {
  @override
  LoginFormInstantConfigViewModel get loginFormInstantConfigViewModel =>
      const LoginFormInstantConfigViewModel(isEnabled: true);

  @override
  FPSMonitorInstantConfigViewModel get fpsMonitorInstantConfigViewModel =>
      const FPSMonitorInstantConfigViewModel(isEnabled: true);

  @override
  RendererDisplayInstantConfigViewModel
      get rendererDisplayInstantConfigViewModel =>
          const RendererDisplayInstantConfigViewModel(isEnabled: true);

  @override
  Future<void> initializeInstantConfig() async {}

  @override
  bool get isLoading => false;

  @override
  void setDefaults({
    bool isLoginFormEnabled,
    bool isFpsMonitorEnabled,
    bool isRendererDisplayEnabled,
  }) {}
}
