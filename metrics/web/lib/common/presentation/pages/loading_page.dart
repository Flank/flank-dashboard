// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/models/auth_state.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/platform_brightness_observer.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:metrics/feature_config/domain/entities/feature_config.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:provider/provider.dart';

/// A page that shows until the authentication status is unknown.
class LoadingPage extends StatefulWidget {
  /// Creates a new instance of the [LoadingPage].
  const LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  /// Duration of the `metrics` text animation.
  static const _animationDuration = Duration(seconds: 1);

  /// Animation controller of the `metrics` text.
  AnimationController _animationController;

  /// An [AuthNotifier] this page uses to remove added listeners
  /// in the [dispose] method.
  AuthNotifier _authNotifier;

  /// A [FeatureConfigNotifier] this page uses to initialize the [FeatureConfig]
  /// and remove added listeners in the [dispose] method.
  FeatureConfigNotifier _featureConfigNotifier;

  /// A [DebugMenuNotifier] this page uses to initialize
  /// the [LocalConfig] and remove added listeners in the [dispose] method.
  DebugMenuNotifier _debugMenuNotifier;

  /// An [AuthState] that represents the current authentication state
  /// of the user.
  AuthState _authState;

  /// Indicates whether a feature config is initialized or not.
  bool _isFeatureConfigInitialized = false;

  /// Indicates whether a local config is initialized or not.
  bool _isLocalConfigInitialized = false;

  /// Indicates whether a user is logged in or not.
  bool get _isLoggedIn =>
      _authState == AuthState.loggedIn || _authState == AuthState.loggedOut;

  /// Indicates whether the application is finished initializing.
  bool get _isInitialized =>
      _authNotifier.isInitialized &&
      _isLoggedIn != null &&
      _isFeatureConfigInitialized &&
      _isLocalConfigInitialized;

  @override
  void initState() {
    super.initState();

    _initAnimation();

    _authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    _subscribeToAuthUpdates();
    _subscribeToFeatureConfigUpdates();
    _subscribeToDebugMenuNotifierUpdates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authNotifierListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlatformBrightnessObserver(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (_, __) {
            return Opacity(
              opacity: _animationController.value,
              child: const Center(
                child: Text(
                  CommonStrings.metrics,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Starts the repeated 'metrics' text animation.
  void _initAnimation() {
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.repeat(reverse: true);
    });
  }

  /// Subscribes to authentication updates.
  void _subscribeToAuthUpdates() {
    _authNotifier.addListener(_authNotifierListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authNotifier.subscribeToAuthenticationUpdates();
    });
  }

  /// Subscribes to feature config updates.
  void _subscribeToFeatureConfigUpdates() {
    _featureConfigNotifier = Provider.of<FeatureConfigNotifier>(
      context,
      listen: false,
    );

    _featureConfigNotifier.addListener(_featureConfigNotifierListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _featureConfigNotifier.initializeConfig();
    });
  }

  /// Subscribes to [DebugMenuNotifier] updates.
  void _subscribeToDebugMenuNotifierUpdates() {
    _debugMenuNotifier = Provider.of<DebugMenuNotifier>(context, listen: false);

    _debugMenuNotifier.addListener(_debugMenuNotifierListener);
  }

  /// Updates the [_isLoggedIn] value depending on the [AuthNotifier] state.
  void _authNotifierListener() {
    _authState = _authNotifier.authState;

    _handleIsInitializedChanged();
  }

  /// Updates the [_isFeatureConfigInitialized] value depending
  /// on the [FeatureConfigNotifier] state.
  ///
  /// Calls [_initializeLocalConfig] when the [FeatureConfig] is initialized.
  void _featureConfigNotifierListener() {
    _isFeatureConfigInitialized = _featureConfigNotifier.isInitialized &&
        !_featureConfigNotifier.isLoading;

    if (_isFeatureConfigInitialized) {
      _initializeLocalConfig();
    }

    _handleIsInitializedChanged();
  }

  /// Initializes the [LocalConfig] using the [DebugMenuNotifier].
  ///
  /// If the Debug Menu feature is enabled, delegates
  /// to the [DebugMenuNotifier.initializeLocalConfig] method.
  /// Otherwise, delegates to the [DebugMenuNotifier.initializeDefaults].
  void _initializeLocalConfig() {
    final isDebugMenuEnabled =
        _featureConfigNotifier.debugMenuFeatureConfigViewModel.isEnabled;

    if (isDebugMenuEnabled) {
      _debugMenuNotifier.initializeLocalConfig();
    } else {
      _debugMenuNotifier.initializeDefaults();
    }
  }

  /// Updates the [_isLocalConfigInitialized] value
  /// depending on the [DebugMenuNotifier] state.
  void _debugMenuNotifierListener() {
    _isLocalConfigInitialized =
        _debugMenuNotifier.isInitialized && !_debugMenuNotifier.isLoading;

    _handleIsInitializedChanged();
  }

  /// Handles the application initialization state changes.
  void _handleIsInitializedChanged() {
    if (!_isInitialized) return;

    final notifier = Provider.of<NavigationNotifier>(context, listen: false);

    Router.neglect(context, () {
      notifier.handleAppInitialized(
          isAppInitialized: true, authState: _authState);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _authNotifier.removeListener(_authNotifierListener);
    _featureConfigNotifier.removeListener(_featureConfigNotifierListener);
    _debugMenuNotifier.removeListener(_debugMenuNotifierListener);
    super.dispose();
  }
}
