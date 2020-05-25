import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;

  const CardContainer({
    this.height = 220.0,
    this.width = 380.0,
    @required this.child,
  }) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: Container(
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
