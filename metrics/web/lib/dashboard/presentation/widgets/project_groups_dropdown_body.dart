import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:selection_menu/components_configurations.dart';

/// A widget that displays a project groups dropdown body.
class ProjectGroupsDropdownBody extends StatelessWidget {
  /// An [EdgeInsets] of the dropdown body.
  static const double _baseDropdownPadding = 4.0;

  /// An [AnimationComponentData] that provides an information
  /// about dropdown body animation.
  final AnimationComponentData data;

  /// Whether to add or remove the bottom padding of the dropdown body.
  final bool isBottomPadding;

  /// Creates the [ProjectGroupsDropdownBody] with the given [data].
  ///
  /// The [data] must not be `null`.
  const ProjectGroupsDropdownBody({
    Key key,
    @required this.data,
    this.isBottomPadding = true,
  })  : assert(data != null),
        assert(isBottomPadding != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MetricsTheme.of(context).dropdownTheme;
    final dropdownBottomPadding = isBottomPadding ? _baseDropdownPadding : 0.0;
    final dropdownHeight = data.constraints.maxHeight +
        _baseDropdownPadding +
        dropdownBottomPadding;

    return DropdownBody(
      state: data.menuState,
      builder: (context, animation) {
        return FadeTransition(
          opacity: animation,
          child: Container(
            width: 212.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0.0, 8.0),
                  blurRadius: 16.0,
                  color: theme.shadowColor,
                ),
              ],
            ),
            child: Card(
              margin: const EdgeInsets.only(top: 4.0),
              color: theme.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              elevation: 0.0,
              child: Padding(
                key: UniqueKey(),
                padding: EdgeInsets.fromLTRB(
                  1.0,
                  4.0,
                  1.0,
                  dropdownBottomPadding,
                ),
                child: data.child,
              ),
            ),
          ),
        );
      },
      animationDuration: DurationConstants.animation,
      maxHeight: dropdownHeight,
      maxWidth: 212.0,
      onOpenStateChanged: _onOpenStateChanges,
    );
  }

  /// Listens to opened state changes.
  void _onOpenStateChanges(bool isOpen) {
    if (isOpen) {
      data.opened();
    } else {
      data.closed();
    }
  }
}
