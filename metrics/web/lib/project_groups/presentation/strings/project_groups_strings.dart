/// Holds the strings for the project groups screen.
class ProjectGroupsStrings {
  static const String projectGroups = 'Project Groups';
  static const String addProjectGroup = 'Add new group';
  static const String editProjectGroup = 'Edit group';
  static const String deleteProjectGroup = 'Delete group';
  static const String noProjects = 'No projects';
  static const String nameYourStrings = 'Name your group';
  static const String saveChanges = 'Save changes';
  static const String createGroup = 'Create group';
  static const String chooseProjectToAdd = 'Choose project to add';
  static const String projectGroupNameRequired =
      'Project group name is required';
  static const String creatingProjectGroup = 'Creating group...';
  static const String savingProjectGroup = 'Saving changes...';
  static const String deletingProjectGroup = 'Deleting group...';

  static String getDeleteTextConfirmation(String name) {
    return 'Delete $name project group?';
  } 
  static String getProjectsCount(int count) => '$count projects';
  static String getSelectedCount(int count) => '$count selected';
}
