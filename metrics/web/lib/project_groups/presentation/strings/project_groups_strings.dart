/// Holds the strings for the project groups screen.
class ProjectGroupsStrings {
  static const String addProjectGroup = 'Add new group';
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

  static String getProjectSelectionError(int count) =>
      'Not more than $count projects can be selected for one project group.';
}
