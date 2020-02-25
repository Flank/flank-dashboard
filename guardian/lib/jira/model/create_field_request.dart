import 'package:guardian/jira/model/jira_custom_field_settings.dart';

class FieldRequest {
  final String name;
  final String description;
  final JiraCustomFieldSettings fieldSettings;

  FieldRequest({
    this.name,
    this.description,
    this.fieldSettings,
  });

  FieldRequest.testcase()
      : this(
          name: 'Flaky testcase key',
          description: 'An identifier for a testcase the issue related to.',
          fieldSettings: JiraCustomFieldSettings.readOnlyField(),
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': fieldSettings?.type,
      'searcherKey': fieldSettings?.searcherKey,
    };
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
