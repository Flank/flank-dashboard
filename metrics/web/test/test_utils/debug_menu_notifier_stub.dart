import 'package:flutter/material.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/view_models/fps_monitor_local_config_view_model.dart';

/// Stub implementation of the [DebugMenuNotifier].
///
/// Provides test implementation of the [DebugMenuNotifier] methods.
class DebugMenuNotifierStub extends ChangeNotifier
    implements DebugMenuNotifier {
  @override
  FpsMonitorLocalConfigViewModel get fpsMonitorLocalConfigViewModel =>
      const FpsMonitorLocalConfigViewModel(isEnabled: true);

  @override
  bool get isLoading => false;

  @override
  bool get isInitialized => true;

  @override
  String get updateConfigError => null;

  @override
  Future<void> initializeLocalConfig() async {}

  @override
  void initializeDefaults() {}

  @override
  Future<void> toggleFpsMonitor() async {}
}
