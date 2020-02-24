import 'package:equatable/equatable.dart';
import 'package:guardian/jira/model/jira_entity_property.dart';

class JiraIssueBean extends Equatable {
  final String expand;
  final String id;
  final String self;
  final String key;
  final List<JiraEntityProperty> properties;

  const JiraIssueBean({
    this.expand,
    this.id,
    this.self,
    this.key,
    this.properties,
  });

  factory JiraIssueBean.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JiraIssueBean(
      expand: json['expand'] as String,
      id: json['id'] as String,
      self: json['self'] as String,
      key: json['key'] as String,
      properties:
          JiraEntityProperty.listFromJson(json['properties'] as List<dynamic>),
    );
  }

  static List<JiraIssueBean> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return JiraIssueBean.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  @override
  List<Object> get props => [expand, id, self, key, properties];

  @override
  String toString() {
    return '$runtimeType { $props }';
  }
}
