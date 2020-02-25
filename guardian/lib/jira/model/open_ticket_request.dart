import 'package:guardian/jira/model/jira_entity_property.dart';

class OpenTicketRequest {
  final String projectId;
  final String testcaseKey;
  final List<JiraEntityProperty> properties;

  OpenTicketRequest({this.projectId, this.testcaseKey, this.properties});
}
