import 'package:equatable/equatable.dart';
import 'package:guardian/jira/model/jira_issue_bean.dart';

class JiraSearchResults extends Equatable {
  final String expand;
  final int startAt;
  final int maxResults;
  final int total;
  final List<JiraIssueBean> issues;
  final List<String> warningMessages;

  const JiraSearchResults({
    this.expand,
    this.startAt,
    this.maxResults,
    this.total,
    this.issues,
    this.warningMessages,
  });

  factory JiraSearchResults.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JiraSearchResults(
      expand: json['expand'] as String,
      startAt: json['startAt'] as int,
      maxResults: json['maxResults'] as int,
      total: json['total'] as int,
      issues: JiraIssueBean.listFromJson(json['issues'] as List<dynamic>),
      warningMessages: json['warningMessages'] as List<String>,
    );
  }

  @override
  List<Object> get props => [
        expand,
        startAt,
        maxResults,
        total,
        issues,
        warningMessages,
      ];

  @override
  String toString() {
    return '$runtimeType { $props }';
  }
}
