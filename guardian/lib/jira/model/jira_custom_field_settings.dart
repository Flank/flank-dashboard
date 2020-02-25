import 'package:guardian/jira/model/jira_field_type.dart';
import 'package:guardian/jira/model/jira_searcher_key.dart';

/// A class for configuring a custom field's type and it searcher key to make it
/// usable in search queries.
///
/// Provides constructors for valid settings of each type available
/// (https://developer.atlassian.com/cloud/jira/platform/rest/v3/#api-rest-api-3-field-post)
class JiraCustomFieldSettings {
  /// The type of the custom field.
  ///
  /// Available types with their description are listed in [JiraFieldType].
  final String type;

  /// Used to define the way the field is searched in Jira.
  ///
  /// Available types with their description are listed in [JiraSearcherKey].
  final String searcherKey;

  JiraCustomFieldSettings._(this.type, this.searcherKey);

  /// Creates settings for a field with [JiraFieldType.cascadingSelect] type.
  JiraCustomFieldSettings.cascadingSelect()
      : this._(
          JiraFieldType.cascadingSelect,
          JiraSearcherKey.cascadingSelectSearcher,
        );

  /// Creates settings for a field with [JiraFieldType.datePicker] type.
  JiraCustomFieldSettings.datePicker()
      : this._(JiraFieldType.datePicker, JiraSearcherKey.dateRange);

  /// Creates settings for a field with [JiraFieldType.dateTime] type.
  JiraCustomFieldSettings.dateTime()
      : this._(JiraFieldType.dateTime, JiraSearcherKey.dateTimeRange);

  /// Creates settings for a field with [JiraFieldType.float] type.
  ///
  /// A [searchableExact] is used to define which of the numeric searchers use
  /// for the field. If `true` then [JiraSearcherKey.exactNumber] is used,
  /// otherwise [JiraSearcherKey.numberRange] is used.
  /// Defaults to `true`.
  JiraCustomFieldSettings.float({bool searchableExact = true})
      : this._(
          JiraFieldType.float,
          searchableExact
              ? JiraSearcherKey.exactNumber
              : JiraSearcherKey.numberRange,
        );

  /// Creates settings for a field with [JiraFieldType.groupPicker] type.
  JiraCustomFieldSettings.groupPicker()
      : this._(JiraFieldType.groupPicker, JiraSearcherKey.groupPickerSearcher);

  /// Creates settings for a field with [JiraFieldType.importId] type.
  ///
  /// A [searchableExact] is used to define which of the numeric searchers use
  /// for the field. If `true` then [JiraSearcherKey.exactNumber] is used,
  /// otherwise [JiraSearcherKey.numberRange] is used.
  /// Defaults to `true`.
  JiraCustomFieldSettings.importId({bool searchableExact = true})
      : this._(
          JiraFieldType.importId,
          searchableExact
              ? JiraSearcherKey.exactNumber
              : JiraSearcherKey.numberRange,
        );

  /// Creates settings for a field with [JiraFieldType.labels] type.
  JiraCustomFieldSettings.labels()
      : this._(JiraFieldType.labels, JiraSearcherKey.labelSearcher);

  /// Creates settings for a field with [JiraFieldType.multiCheckboxes] type.
  JiraCustomFieldSettings.multiCheckboxes()
      : this._(
          JiraFieldType.multiCheckboxes,
          JiraSearcherKey.multiSelectSearcher,
        );

  /// Creates settings for a field with [JiraFieldType.multiGroupPicker] type.
  JiraCustomFieldSettings.multiGroupPicker()
      : this._(
          JiraFieldType.multiGroupPicker,
          JiraSearcherKey.multiSelectSearcher,
        );

  /// Creates settings for a field with [JiraFieldType.multiSelect] type.
  JiraCustomFieldSettings.multiSelect()
      : this._(JiraFieldType.multiSelect, JiraSearcherKey.multiSelectSearcher);

  /// Creates settings for a field with [JiraFieldType.multiUserPicker] type.
  JiraCustomFieldSettings.multiUserPicker()
      : this._(
          JiraFieldType.multiUserPicker,
          JiraSearcherKey.userPickerGroupSearcher,
        );

  /// Creates settings for a field with [JiraFieldType.multiVersion] type.
  JiraCustomFieldSettings.multiVersion()
      : this._(JiraFieldType.multiVersion, JiraSearcherKey.versionSearcher);

  /// Creates settings for a field with [JiraFieldType.project] type.
  JiraCustomFieldSettings.project()
      : this._(JiraFieldType.project, JiraSearcherKey.projectSearcher);

  /// Creates settings for a field with [JiraFieldType.radioButtons] type.
  JiraCustomFieldSettings.radioButtons()
      : this._(JiraFieldType.radioButtons, JiraSearcherKey.multiSelectSearcher);

  /// Creates settings for a field with [JiraFieldType.readOnlyField] type.
  JiraCustomFieldSettings.readOnlyField()
      : this._(JiraFieldType.readOnlyField, JiraSearcherKey.textSearcher);

  /// Creates settings for a field with [JiraFieldType.select] type.
  JiraCustomFieldSettings.select()
      : this._(JiraFieldType.select, JiraSearcherKey.multiSelectSearcher);

  /// Creates settings for a field with [JiraFieldType.textArea] type.
  JiraCustomFieldSettings.textArea()
      : this._(JiraFieldType.textArea, JiraSearcherKey.textSearcher);

  /// Creates settings for a field with [JiraFieldType.textField] type.
  JiraCustomFieldSettings.textField()
      : this._(JiraFieldType.textField, JiraSearcherKey.textSearcher);

  /// Creates settings for a field with [JiraFieldType.url] type.
  JiraCustomFieldSettings.url()
      : this._(JiraFieldType.url, JiraSearcherKey.exactTextSearcher);

  /// Creates settings for a field with [JiraFieldType.userPicker] type.
  JiraCustomFieldSettings.userPicker()
      : this._(
          JiraFieldType.userPicker,
          JiraSearcherKey.userPickerGroupSearcher,
        );

  /// Creates settings for a field with [JiraFieldType.version] type.
  JiraCustomFieldSettings.version()
      : this._(JiraFieldType.version, JiraSearcherKey.versionSearcher);
}
