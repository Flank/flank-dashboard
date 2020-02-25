/// A class that stores valid values for a custom field type.
abstract class JiraFieldType {
  /// The prefix to be set before specific type separated from it by a colon.
  static const String _prefix =
      'com.atlassian.jira.plugin.system.customfieldtypes';

  /// Allows multiple values to be selected using two select lists.
  static const String cascadingSelect = '$_prefix:cascadingselect';

  /// Stores a date using a picker control.
  static const String datePicker = '$_prefix:datepicker';

  /// Stores a date with a time component.
  static const String dateTime = '$_prefix:datetime';

  /// Stores and validates a numeric (floating point) input.
  static const String float = '$_prefix:float';

  /// Stores a user group using a picker control.
  static const String groupPicker = '$_prefix:grouppicker';

  /// A read-only field that stores the previous ID of the issue from the
  /// system that it was imported from.
  static const String importId = '$_prefix:importid';

  /// Stores labels.
  static const String labels = '$_prefix:labels';

  /// Stores multiple values using checkboxes.
  static const String multiCheckboxes = '$_prefix:multicheckboxes';

  /// Stores multiple user groups using a picker control.
  static const String multiGroupPicker = '$_prefix:multigrouppicker';

  /// Stores multiple values using a select list.
  static const String multiSelect = '$_prefix:multiselect';

  /// Stores multiple users using a picker control.
  static const String multiUserPicker = '$_prefix:multiuserpicker';

  /// Stores multiple versions from the versions available in a project
  /// using a picker control.
  static const String multiVersion = '$_prefix:multiversion';

  /// Stores a project from a list of projects that the user is permitted
  /// to view.
  static const String project = '$_prefix:project';

  /// Stores a value using radio buttons.
  static const String radioButtons = '$_prefix:radiobuttons';

  /// Stores a read-only text value, which can only be populated via the API.
  static const String readOnlyField = '$_prefix:readonlyfield';

  /// Stores a value from a configurable list of options.
  static const String select = '$_prefix:select';

  /// Stores a long text string using a multiline text area.
  static const String textArea = '$_prefix:textarea';

  /// Stores a text string using a single-line text box.
  static const String textField = '$_prefix:textfield';

  /// Stores a URL.
  static const String url = '$_prefix:url';

  /// Stores a user using a picker control.
  static const String userPicker = '$_prefix:userpicker';

  /// Stores a version using a picker control.
  static const String version = '$_prefix:version';
}
