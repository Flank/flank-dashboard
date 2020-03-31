import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../auth/service/user_service.dart';

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
          StateBuilder<UserService>(
            models: [Injector.getAsReactive<UserService>()],
            builder: (context, ReactiveModel<UserService> model) {
              return FlatButton(
                onPressed: () {
                  print(model.state.user);
                  model
                      .setState((state) => state.signOut())
                      .then((value) => Navigator.pushNamed(context, '/login'));
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
