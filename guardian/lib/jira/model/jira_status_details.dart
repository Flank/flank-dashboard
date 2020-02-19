import 'package:equatable/equatable.dart';
import 'package:guardian/jira/model/jira_status_category.dart';

class JiraStatusDetails extends Equatable {
  final String self;
  final String description;
  final String iconUrl;
  final String name;
  final String id;
  final JiraStatusCategory statusCategory;

  const JiraStatusDetails({
    this.self,
    this.description,
    this.iconUrl,
    this.name,
    this.id,
    this.statusCategory,
  });

  factory JiraStatusDetails.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JiraStatusDetails(
      self: json['self'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      name: json['name'] as String,
      id: json['id'] as String,
      statusCategory: JiraStatusCategory.fromJson(
          json['statusCategory'] as Map<String, dynamic>),
    );
  }

  static List<JiraStatusDetails> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return JiraStatusDetails.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  @override
  List<Object> get props => [
        self,
        description,
        iconUrl,
        name,
        id,
        statusCategory,
      ];

  @override
  String toString() {
    return '$runtimeType { $props }';
  }
}
