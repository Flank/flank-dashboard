import 'package:equatable/equatable.dart';

class JiraCreatedIssue extends Equatable {
  final String id;
  final String key;
  final String self;

  const JiraCreatedIssue({
    this.id,
    this.key,
    this.self,
  });

  factory JiraCreatedIssue.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JiraCreatedIssue(
      id: json['id'] as String,
      key: json['key'] as String,
      self: json['self'] as String,
    );
  }

  @override
  List<Object> get props => [id, key, self];

  @override
  String toString() {
    return '$runtimeType { $props }';
  }
}
