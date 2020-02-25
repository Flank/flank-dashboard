import 'package:guardian/jira/model/jira_field_type.dart';

/// A class that stores valid values for a custom field searcher key.
abstract class JiraSearcherKey {
  /// The prefix to be set before specific searcher key separated from it by a
  /// colon.
  static const String _prefix =
      'com.atlassian.jira.plugin.system.customfieldtypes';

  /// Searcher for the cascading select fields.
  ///
  /// Must be used with [JiraFieldType.cascadingSelect].
  static const String cascadingSelectSearcher =
      '$_prefix:cascadingselectsearcher';

  /// Searcher for fields that store date data.
  ///
  /// Must be used with [JiraFieldType.datePicker].
  static const String dateRange = '$_prefix:daterange';

  /// Searcher for fields that store date with time component.
  ///
  /// Must be used with [JiraFieldType.dateTime].
  static const String dateTimeRange = '$_prefix:datetimerange';

  /// Searcher for fields that store numeric data.
  /// Stands for searching exact numbers.
  ///
  /// Must be used with the following types:
  ///   - [JiraFieldType.float]
  ///   - [JiraFieldType.importId]
  static const String exactNumber = '$_prefix:exactnumber';

  /// Searcher for fields that store text data. Stands for searching exact text.
  ///
  /// Must be used with [JiraFieldType.url].
  static const String exactTextSearcher = '$_prefix:exacttextsearcher';

  /// Searcher for fields that store user group.
  ///
  /// Must be used with [JiraFieldType.groupPicker].
  static const String groupPickerSearcher = '$_prefix:grouppickersearcher';

  /// Searcher for fields that store labels.
  ///
  /// Must be used with [JiraFieldType.labels].
  static const String labelSearcher = '$_prefix:labelsearcher';

  /// Searcher for fields that stores multiple values.
  ///
  /// Must be used with the following types:
  ///   - [JiraFieldType.multiCheckboxes]
  ///   - [JiraFieldType.multiGroupPicker]
  ///   - [JiraFieldType.multiSelect]
  ///   - [JiraFieldType.radioButtons]
  ///   - [JiraFieldType.select]
  static const String multiSelectSearcher = '$_prefix:multiselectsearcher';

  /// Searcher for fields that store numeric data.
  /// Stands for searching numbers in range.
  ///
  /// Must be used with the following types:
  ///   - [JiraFieldType.float]
  ///   - [JiraFieldType.importId]
  static const String numberRange = '$_prefix:numberrange';

  /// Searcher for fields that store project.
  ///
  /// Must be used with [JiraFieldType.project].
  static const String projectSearcher = '$_prefix:projectsearcher';

  /// Searcher for fields that store text data. Stands for searching text that
  /// contains expression passed as parameter in query.
  ///
  /// Must be used with the following types:
  ///   - [JiraFieldType.readOnlyField]
  ///   - [JiraFieldType.textArea]
  ///   - [JiraFieldType.textField]
  static const String textSearcher = '$_prefix:textsearcher';

  /// Searcher for fields that store user data.
  ///
  /// Must be used with the following types:
  ///   - [JiraFieldType.userPicker]
  ///   - [JiraFieldType.multiUserPicker]
  static const String userPickerGroupSearcher =
      '$_prefix:userpickergroupsearcher';

  /// Searcher for fields that store a version.
  ///
  /// Must be used with the following types:
  ///   - [JiraFieldType.multiVersion]
  ///   - [JiraFieldType.version]
  static const String versionSearcher = '$_prefix:versionsearcher';
}
