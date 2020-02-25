import 'package:equatable/equatable.dart';

class JiraFieldDetails extends Equatable {
  final String id;
  final String key;
  final String name;
  final bool custom;
  final bool orderable;
  final bool navigable;
  final bool searchable;
  final List<String> clauseNames;

  const JiraFieldDetails({
    this.id,
    this.key,
    this.name,
    this.custom,
    this.orderable,
    this.navigable,
    this.searchable,
    this.clauseNames,
  });

  factory JiraFieldDetails.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JiraFieldDetails(
      id: json['id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      custom: json['custom'] as bool,
      orderable: json['orderable'] as bool,
      navigable: json['navigable'] as bool,
      searchable: json['searchable'] as bool,
      clauseNames: json['clauseNames'] == null
          ? null
          : List<String>.from(json['clauseNames'] as List),
    );
  }

  static List<JiraFieldDetails> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return JiraFieldDetails.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  @override
  List<Object> get props => [
        id,
        key,
        name,
        custom,
        orderable,
        navigable,
        searchable,
        clauseNames,
      ];

  @override
  String toString() {
    return '$runtimeType { $props }';
  }
}
