import 'package:equatable/equatable.dart';
import 'package:guardian/jira/model/jira_status_details.dart';

class JiraIssueTransition extends Equatable {
  final String id;
  final String name;
  final JiraStatusDetails to;
  final bool hasScreen;
  final bool isGlobal;
  final bool isInitial;
  final bool isAvailable;
  final bool isConditional;
  final Map<String, dynamic> fields;
  final String expand;

  const JiraIssueTransition({
    this.id,
    this.name,
    this.to,
    this.hasScreen,
    this.isGlobal,
    this.isInitial,
    this.isAvailable,
    this.isConditional,
    this.fields,
    this.expand,
  });

  factory JiraIssueTransition.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JiraIssueTransition(
      id: json['id'] as String,
      name: json['name'] as String,
      to: JiraStatusDetails.fromJson(json['to'] as Map<String, dynamic>),
      hasScreen: json['hasScreen'] as bool,
      isGlobal: json['isGlobal'] as bool,
      isInitial: json['isInitial'] as bool,
      isAvailable: json['isAvailable'] as bool,
      isConditional: json['isConditional'] as bool,
      expand: json['expand'] as String,
    );
  }

  static List<JiraIssueTransition> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return JiraIssueTransition.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  @override
  List<Object> get props => [
        id,
        name,
        to,
        hasScreen,
        isGlobal,
        isInitial,
        isAvailable,
        isConditional,
        expand,
      ];

  @override
  String toString() {
    return '$runtimeType { $props }';
  }
}
