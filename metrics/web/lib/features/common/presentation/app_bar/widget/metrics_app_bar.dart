import 'package:flutter/material.dart';
import 'package:metrics/features/auth/service/user_service.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// The application [AppBar] widget.
class MetricsAppBar extends StatelessWidget with PreferredSizeWidget {
  MetricsAppBar({
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          StateBuilder(
            models: [Injector.getAsReactive<UserService>()],
            builder: (context, ReactiveModel<UserService> model) {
              if (model.state.user != null) {
                return Text('Welcome ${model.state.user.email}');
              }

              return const Text('');
            },
          ),
        ],
      ),
    );
  }
}
