// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';

/// A base class for a strategy that provides the
/// text to display and action to perform on the dialog of
/// the project group.
abstract class ProjectGroupDialogStrategy {
  /// A title text to display on the dialog.
  String get title;

  /// A text to display on the dialog.
  String get text;

  /// A text to display on the dialog on loading.
  String get loadingText;

  /// A text to notify a user about an [action] successfully finished.
  String getSuccessfulActionMessage(String groupName);

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
