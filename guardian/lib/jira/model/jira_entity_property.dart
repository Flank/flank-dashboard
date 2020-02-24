import 'package:equatable/equatable.dart';

class JiraEntityProperty extends Equatable {
  final String key;
  final dynamic value;

  const JiraEntityProperty({this.key, this.value});

  factory JiraEntityProperty.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JiraEntityProperty(
      key: json['key'] as String,
      value: json['value'],
    );
  }

  static List<JiraEntityProperty> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return JiraEntityProperty.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  @override
  List<Object> get props => [key, value];

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
