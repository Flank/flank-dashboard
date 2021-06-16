// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/navigation/constants/default_routes.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:provider/provider.dart';

/// The application side menu widget.
class MetricsDrawer extends StatelessWidget {
  /// Creates a [MetricsDrawer].
  const MetricsDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationNotifier = Provider.of<NavigationNotifier>(
      context,
      listen: false,
    );

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
                title: const Text(CommonStrings.darkTheme),
                onChanged: (_) => model.toggleTheme(),
              );
            },
          ),
          ListTile(
            title: const Text(CommonStrings.projectGroups),
            onTap: () => navigationNotifier.push(DefaultRoutes.projectGroups),
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
  }
}
