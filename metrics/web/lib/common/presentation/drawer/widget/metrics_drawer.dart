import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
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
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(),
          ),
          Consumer<ThemeNotifier>(
            builder: (context, model, _) {
              return HandCursor(
                child: CheckboxListTile(
                  value: model.isDark,
                  title: const Text(CommonStrings.darkTheme),
                  onChanged: (_) => model.changeTheme(),
                ),
              );
            },
          ),
          HandCursor(
            child: ListTile(
              title: const Text(CommonStrings.projectGroups),
              onTap: () => Navigator.popAndPushNamed(
                context,
                RouteName.projectGroup,
              ),
            ),
          ),
          HandCursor(
            child: ListTile(
              title: const Text(CommonStrings.logOut),
              onTap: () => _signOut(context),
            ),
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
        context, RouteName.login, (Route<dynamic> route) => false);
  }
}
