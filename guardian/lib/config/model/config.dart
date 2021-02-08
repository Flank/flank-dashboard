// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:meta/meta.dart';

abstract class Config {
  final String filename;

  Config(this.filename);

  List<ConfigField> get fields;

  void readFromMap(Map<String, dynamic> map);

  void readFromArgs(ArgResults argResults);

  Map<String, dynamic> toMap();

  Config copy();

  @override
  String toString() {
    return fields.map((field) => '${field.name} = ${field.value}').join('\n');
  }
}

class ConfigField<T> {
  final String name;
  final String description;
  final T value;
  final T Function(String) setter;

  ConfigField({
    @required this.name,
    @required this.description,
    @required this.setter,
    this.value,
  });

  String editFieldString({
    bool showEmptyValue = false,
  }) {
    var valuePart = '';
    if (value != null) {
      valuePart = ' ($value)';
    } else if (showEmptyValue) {
      valuePart = ' (null)';
    }

    return '$description$valuePart: ';
  }
}
