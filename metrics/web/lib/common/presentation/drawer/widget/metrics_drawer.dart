import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:provider/provider.dart';

import '../../routes/route_generator.dart';

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
          Consumer<ThemeNotifier>(
            builder: (context, model, _) {
              return CheckboxListTile(
                value: model.isDark,
                title: const Text('Dark theme'),
                onChanged: (_) => model.changeTheme(),
              );
            },
          ),
          ListTile(
            title: const Text('Project groups'),
            onTap: () =>
                Navigator.pushNamed(context, RouteGenerator.projectGroupPage),
          ),
          ListTile(
            title: const Text(CommonStrings.logOut),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }

  /// Signs out a user from the app.
  Future<void> _signOut(BuildContext context) async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    await authNotifier.signOut();
    await Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.login, (Route<dynamic> route) => false);
  }
}
