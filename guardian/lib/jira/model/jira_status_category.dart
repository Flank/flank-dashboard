import 'package:equatable/equatable.dart';

class JiraStatusCategory extends Equatable {
  final String self;
  final int id;
  final String key;
  final String colorName;
  final String name;

  const JiraStatusCategory({
    this.self,
    this.id,
    this.key,
    this.colorName,
    this.name,
  });

  factory JiraStatusCategory.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return JiraStatusCategory(
      self: json['self'] as String,
      id: json['id'] as int,
      key: json['key'] as String,
      colorName: json['colorName'] as String,
      name: json['name'] as String,
    );
  }

  static List<JiraStatusCategory> listFromJson(List<dynamic> list) {
    return list?.map((json) {
      return JiraStatusCategory.fromJson(json as Map<String, dynamic>);
    })?.toList();
  }

  @override
  List<Object> get props => [self, id, key, colorName, name];

  @override
  String toString() {
    return '$runtimeType { $props }';
  }
}
