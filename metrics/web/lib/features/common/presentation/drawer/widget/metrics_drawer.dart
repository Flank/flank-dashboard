import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// The application side menu widget.
class MetricsDrawer extends StatelessWidget {
  const MetricsDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(),
          ),
          StateBuilder<ThemeStore>(
            models: [Injector.getAsReactive<ThemeStore>()],
            builder: (context, model) {
              final snapshot = model.snapshot.data;

              return CheckboxListTile(
                value: snapshot.isDark,
                title: const Text('Dark theme'),
                onChanged: (_) => _changeTheme(model, snapshot),
              );
            },
          ),
          StateBuilder<AuthStore>(
            models: [Injector.getAsReactive<AuthStore>()],
            builder:
                (context, ReactiveModel<AuthStore> authStoreReactiveModel) {
              return ListTile(
                title: const Text(CommonStrings.logOut),
                onTap: () => _signOut(context, authStoreReactiveModel),
              );
            },
          )
        ],
      ),
    );
  }

  /// Signs out a user from the app.
  Future<void> _signOut(
    BuildContext context,
    ReactiveModel<AuthStore> authStoreReactiveModel,
  ) async {
    StreamSubscription _loggedInStreamSubscription;

    _loggedInStreamSubscription = authStoreReactiveModel.state.loggedInStream
        .listen((isUserLoggedIn) async {
      if (isUserLoggedIn != null && !isUserLoggedIn) {
        await Injector.get<ProjectMetricsStore>().unsubscribeFromProjects();

        await Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.login, (Route<dynamic> route) => false);

        await _loggedInStreamSubscription.cancel();
      }
    });

    await authStoreReactiveModel.setState((store) => store.signOut());
  }

  void _changeTheme(ReactiveModel<ThemeStore> model, ThemeStore snapshot) {
    model.setState(
      (model) => snapshot.isDark = !snapshot.isDark,
    );
  }
}
