import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/user_metrics_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
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
          StateBuilder<UserMetricsStore>(
            models: [Injector.getAsReactive<UserMetricsStore>()],
            builder:
                (context, ReactiveModel<UserMetricsStore> userMetricsStore) {
              return FlatButton(
                key: const Key('Logout'),
                onPressed: () async {
                  await userMetricsStore.setState((state) => state.signOut());
                  /// Remove all the routes below the pushed 'login' route to prevent
                  /// accidental navigate back to the dashboard page
                  await Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (Route<dynamic> route) => false);
                },
                child: const Text('Log out'),
              );
            },
          )
        ],
      ),
    );
  }

  void _changeTheme(ReactiveModel<ThemeStore> model, ThemeStore snapshot) {
    model.setState(
      (model) => snapshot.isDark = !snapshot.isDark,
    );
  }
}
