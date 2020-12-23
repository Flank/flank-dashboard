import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/debug_menu/presentation/view_models/local_config_fps_monitor_view_model.dart';
import 'package:metrics/debug_menu/presentation/view_models/rendered_display_view_model.dart';

/// Stub implementation of the [DebugMenuNotifier].
///
/// Provides test implementation of the [DebugMenuNotifier] methods.
class DebugMenuNotifierStub extends ChangeNotifier
    implements DebugMenuNotifier {
  @override
  LocalConfigFpsMonitorViewModel get localConfigFpsMonitorViewModel =>
      const LocalConfigFpsMonitorViewModel(isEnabled: true);

  @override
  bool get isLoading => false;

  @override
  bool get isInitialized => true;

  @override
  String get updateConfigError => null;

  @override
  RendererDisplayViewModel get rendererDisplayViewModel =>
      const RendererDisplayViewModel(currentRenderer: CommonStrings.skia);

  @override
  Future<void> initializeLocalConfig() async {}

  @override
  void initializeDefaults() {}

  @override
  Future<void> toggleFpsMonitor() async {}
}
