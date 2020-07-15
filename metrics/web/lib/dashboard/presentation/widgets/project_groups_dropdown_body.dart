import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:selection_menu/components_configurations.dart';

/// A widget that displays a project groups dropdown body.
class ProjectGroupsDropdownBody extends StatelessWidget {
  /// An [AnimationComponentData] that provides an information
  /// about dropdown body animation.
  final AnimationComponentData data;

  /// Creates the [ProjectGroupsDropdownBody] with the given [data].
  ///
  /// The [data] must not be `null`.
  const ProjectGroupsDropdownBody({
    Key key,
    @required this.data,
  })  : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownBody(
      data: data,
      builder: (_, child) {
        return Container(
          width: 212.0,
          child: Card(
            margin: const EdgeInsets.only(top: 4.0),
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 1.0,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
