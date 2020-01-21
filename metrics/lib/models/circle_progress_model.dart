import 'package:flutter/material.dart';

class CircleProgressModel {
  final double data;

  CircleProgressModel({
   @required this.data,
  })
  :assert(data!=null && data>=0&& data<=1);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CircleProgressModel && o.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
