import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// The application side menu widget.
class MetricsDrawer extends StatefulWidget {
  const MetricsDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MetricsDrawerState createState() => _MetricsDrawerState();
}

class _MetricsDrawerState extends State<MetricsDrawer> {
  StreamSubscription _loggedInStreamSubscription;

  @override
  void initState() {
    final userStore = Injector.get<UserStore>();
    /// Subscribes on a user authentication's status updates
    _loggedInStreamSubscription = userStore.loggedInStream.listen((isUserLoggedIn) {
      if (isUserLoggedIn is bool && !isUserLoggedIn) {
        /// Remove all the routes below the pushed 'login' route to prevent
        /// accidental navigate back to the dashboard page
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.login, (Route<dynamic> route) => false);
      }
    });
    super.initState();
  }

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
          StateBuilder<UserStore>(
            models: [Injector.getAsReactive<UserStore>()],
            builder: (context, ReactiveModel<UserStore> userStoreRM) {
              return ListTile(
                key: const Key('Logout'),
                title: const Text(CommonStrings.logOut),
                onTap: () => signOut(userStoreRM),
              );
            },
          )
        ],
      ),
    );
  }

  /// Signs out a user from the app
  Future<void> signOut (ReactiveModel<UserStore> storeRM) async {
    await storeRM.setState((userStore) => userStore.signOut());
  }

  void _changeTheme(ReactiveModel<ThemeStore> model, ThemeStore snapshot) {
    model.setState(
      (model) => snapshot.isDark = !snapshot.isDark,
    );
  }

  @override
  void dispose() {
    _loggedInStreamSubscription.cancel();
    super.dispose();
  }
}
