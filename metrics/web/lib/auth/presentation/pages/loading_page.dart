import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/platform_brightness_observer.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:provider/provider.dart';

/// A page that shows until the authentication status is unknown.
class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  /// Duration of the `metrics` text animation.
  static const _animationDuration = Duration(seconds: 1);

  /// Animation controller of the `metrics` text.
  AnimationController _animationController;

  /// An [AuthNotifier] needed to remove added listeners in the [dispose] method.
  AuthNotifier _authNotifier;

  /// An [InstantConfigNotifier] needed to initialize the [InstantConfig] and
  /// remove added listeners in the [dispose] method.
  InstantConfigNotifier _instantConfigNotifier;

  /// Indicates whether the [_authNotifier] and [_instantConfigNotifier]
  /// are loaded.
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    _initAnimation();

    _subscribeToAuthUpdates();
    _subscribeToInstantConfigUpdates();
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
    _authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    _authNotifier.addListener(_authNotifierListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authNotifier.subscribeToAuthenticationUpdates();
    });
  }

  /// Subscribes to instant config updates.
  void _subscribeToInstantConfigUpdates() {
    _instantConfigNotifier = Provider.of<InstantConfigNotifier>(
      context,
      listen: false,
    );

    _instantConfigNotifier.addListener(_instantConfigNotifierListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _instantConfigNotifier.initializeInstantConfig();
    });
  }

  /// Updates the [_isLoaded] and delegates navigating to [_navigateIfLoaded].
  void _authNotifierListener() {
    _updateIsLoaded();

    _navigateIfLoaded();
  }

  /// Updates the [_isLoaded] and delegates navigating to [_navigateIfLoaded].
  void _instantConfigNotifierListener() {
    _updateIsLoaded();

    _navigateIfLoaded();
  }

  /// Sets the [_isLoaded] to `true` if the [_authNotifier] and
  /// [_instantConfigNotifier] are loaded.
  ///
  /// Otherwise, sets the [_isLoaded] to `false`.
  void _updateIsLoaded() {
    final isAuthNotifierLoaded = _authNotifier.isLoggedIn != null;
    final isInstantConfigNotifierLoaded = !_instantConfigNotifier.isLoading;

    _isLoaded = isAuthNotifierLoaded && isInstantConfigNotifierLoaded;
  }

  /// Navigates to either the dashboard or the login page depending
  /// on [_authNotifier.isLoggedIn] status.
  ///
  /// Does not navigate if [_authNotifier] or [_instantConfigNotifier]
  /// is in loading state.
  void _navigateIfLoaded() {
    if (!_isLoaded) return;

    final isLoggedIn = _authNotifier.isLoggedIn;

    if (isLoggedIn) {
      _navigateTo(RouteName.dashboard);
    } else {
      _navigateTo(RouteName.login);
    }
  }

  /// Navigates to [routeName] and removes all underlying routes.
  void _navigateTo(String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (_) => false,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _authNotifier.removeListener(_authNotifierListener);
    _instantConfigNotifier.removeListener(_instantConfigNotifierListener);
    super.dispose();
  }
}
