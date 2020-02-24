import 'package:guardian/jira/model/jira_entity_property.dart';

class SearchTicketsRequest {
  final String projectId;
  final List<JiraEntityProperty> properties;
  final String resolution;
  final String status;

  SearchTicketsRequest({
    this.projectId,
    this.properties,
    this.resolution,
    this.status,
  });

  String toJql() {
    String jql = '';

    if (projectId != null) {
      jql += 'project = $projectId';
    }

    if (properties != null) {
      final props = properties.map((property) {
        return 'issue.property[${property.key}] = "${property.value}"';
      }).join(' and ');
      jql = '${jql == null ? '' : '$jql and '}$props';
    }

    if (resolution != null) {
      jql = '${jql == null ? '' : '$jql and '}resolution = $resolution';
    }

    if (status != null) {
      jql = '${jql == null ? '' : '$jql and '}status = $status';
    }

    return jql;
  }
}
