// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// Holds the strings for the project groups screen.
class ProjectGroupsStrings {
  static const String addProjectGroup = 'Add new group';
  static const String createProjectGroup = 'Create group';
  static const String editProjectGroup = 'Edit group';
  static const String deleteProjectGroup = 'Delete group';
  static const String noProjects = 'No projects';
  static const String nameYourGroup = 'Name your group';
  static const String saveChanges = 'Save changes';
  static const String delete = 'Delete';
  static const String createGroup = 'Create group';
  static const String chooseProjectToAdd = 'Choose project to add';
  static const String projectGroupNameRequired =
      'Project group name is required';
  static const String creatingProjectGroup = 'Creating group...';
  static const String savingProjectGroup = 'Saving changes...';
  static const String deletingProjectGroup = 'Deleting group...';
  static const String deleteConfirmation = 'Are you sure you want to delete';
  static const String deleteConfirmationQuestion = 'project group?';
  static const String noSearchResults = 'No search results...';

  static String getProjectsCount(int count) => '$count projects';

  static String getSelectedCount(int count) => '$count selected';

  static String getProjectGroupNameLimitExceeded(int count) =>
      'The name exceeds $count characters limit';

  static String getProjectsLimitExceeded(int count) =>
      'Not more than $count projects can be selected for one project group.';

  static String getCreatedProjectGroupMessage(String name) =>
      '"$name" project group was created';

  static String getEditedProjectGroupMessage(String name) =>
      '"$name" project group was edited';

  static String getDeletedProjectGroupMessage(String name) =>
      '"$name" project group was deleted';
}
