import 'package:flutter/material.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/base/presentation/decoration/bubble_shape_border.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/toggle/widgets/toggle.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:provider/provider.dart';

/// A widget that displays a metrics user menu with specific shape.
class MetricsUserMenu extends StatelessWidget {
  /// Creates the [MetricsUserMenu].
  const MetricsUserMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const arrowWidth = 10.0;
    const arrowHeight = 5.0;
    const itemPadding = EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0);
    final userMenuTheme = MetricsTheme.of(context).userMenuTheme;
    final userMenuTextStyle = userMenuTheme.contentTextStyle;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 8.0),
            blurRadius: 12.0,
            color: userMenuTheme.shadowColor,
          ),
        ],
      ),
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.zero,
        color: userMenuTheme.backgroundColor,
        shape: BubbleShapeBorder(
          borderRadius: BorderRadius.circular(4.0),
          arrowSize: const Size(arrowWidth, arrowHeight),
          alignment: BubbleAlignment.end,
          position: BubblePosition.top,
          offset: -8.0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: arrowHeight).add(
            const EdgeInsets.symmetric(vertical: 12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: itemPadding.copyWith(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Consumer<ThemeNotifier>(
                  builder: (context, model, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            CommonStrings.lightTheme,
                            style: userMenuTextStyle,
                          ),
                        ),
                        Toggle(
                          value: !model.isDark,
                          onToggle: (_) => model.toggleTheme(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: itemPadding,
                child: TappableArea(
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteName.projectGroup,
                  ),
                  builder: (context, isHovered, child) => child,
                  child: Text(
                    CommonStrings.projectGroups,
                    style: userMenuTextStyle,
                  ),
                ),
              ),
              Selector<FeatureConfigNotifier, bool>(
                selector: (_, notifier) {
                  return notifier.debugMenuFeatureConfigViewModel.isEnabled;
                },
                builder: (_, isDebugMenuEnabled, __) {
                  if (isDebugMenuEnabled) {
                    return Padding(
                      padding: itemPadding,
                      child: TappableArea(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteName.debugMenu,
                        ),
                        builder: (context, isHovered, child) => child,
                        child: Text(
                          CommonStrings.debugMenu,
                          style: userMenuTextStyle,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              Divider(
                color: userMenuTheme.dividerColor,
                thickness: 1.0,
                height: 25.0,
              ),
              Padding(
                padding: itemPadding,
                child: TappableArea(
                  onTap: () => _signOut(context),
                  builder: (context, isHovered, child) => child,
                  child: Text(
                    CommonStrings.logOut,
                    style: userMenuTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Signs out a user from the app.
  Future<void> _signOut(BuildContext context) async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final analyticsNotifier =
        Provider.of<AnalyticsNotifier>(context, listen: false);

    await authNotifier.signOut();
    await analyticsNotifier.resetUser();
    await Navigator.pushNamedAndRemoveUntil(
      context,
      RouteName.login,
      (Route<dynamic> route) => false,
    );
  }
}
