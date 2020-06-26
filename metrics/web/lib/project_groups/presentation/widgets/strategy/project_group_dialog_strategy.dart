import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';

/// A base class for a [ProjectGroupDialog] strategy that provides the 
/// text to display and action to perform on the project group of 
/// the dialog.
abstract class ProjectGroupDialogStrategy {
  /// A title text to display on the dialog.
  String get title;

  /// A text to display on the dialog.
  String get text;

  /// A text to display on the dialog on loading.
  String get loadingText;

  /// Performs a specific method of the given [notifier] on the
  /// project group specified by the given
  /// [groupId], [groupName] and [projectIds].
  Future<void> action(
    ProjectGroupsNotifier notifier,
    String groupId,
    String groupName,
    List<String> projectIds,
  );
}
