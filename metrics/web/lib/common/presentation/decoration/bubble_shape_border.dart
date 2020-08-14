import 'dart:math';
import 'package:flutter/material.dart';

/// Enum that represents the side of the shape to display the arrow on.
enum BubblePosition { bottom, top, left, right }

/// Enum that represents the alignment of the arrow.
enum BubbleAlignment { start, center, end }

/// A shape border with the arrow.
class BubbleShapeBorder extends ShapeBorder {
  /// A side of the shape to display the arrow on.
  final BubblePosition position;

  /// An alignment of the arrow.
  final BubbleAlignment alignment;

  /// A size of the arrow.
  final Size arrowSize;

  /// An offset of the arrow.
  /// Sets the shift horizontally or vertically depending on the [position].
  /// Can be a negative.
  final double offset;

  /// A radius of the border of this shape.
  final double borderRadius;

  /// Creates a new instance of the [BubbleShapeBorder].
  ///
  /// The [position] defaults to the [BubblePosition.bottom].
  /// The [alignment] defaults to the [BubbleAlignment.center].
  /// The [arrowSize] defaults to the [Size.square] of 10.0.
  /// The [offset] default value is 0.0.
  /// The [borderRadius] default value is 12.0.
  const BubbleShapeBorder({
    this.position = BubblePosition.bottom,
    this.alignment = BubbleAlignment.center,
    this.arrowSize = const Size.square(10.0),
    this.offset = 0.0,
    this.borderRadius = 12.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  /// Indicates whether this arrow on the vertical axis.
  bool get _isVertical =>
      position == BubblePosition.top || position == BubblePosition.bottom;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    final path = Path();

    final topLeftDiameter = max(borderRadius, 0);
    final topRightDiameter = max(borderRadius, 0);
    final bottomLeftDiameter = max(borderRadius, 0);
    final bottomRightDiameter = max(borderRadius, 0);

    final spacingLeft = position == BubblePosition.left ? arrowSize.width : 0.0;
    final spacingTop = position == BubblePosition.top ? arrowSize.height : 0.0;
    final spacingRight =
        position == BubblePosition.right ? arrowSize.width : 0.0;
    final spacingBottom =
        position == BubblePosition.bottom ? arrowSize.height : 0.0;

    final double left = spacingLeft + rect.left;
    final double top = spacingTop + rect.top;
    final double right = rect.right - spacingRight;
    final double bottom = rect.bottom - spacingBottom;

    final arrowPositionPercent = _getArrowPositionPercent(rect.size);
    final double centerX = (rect.left + rect.right) * arrowPositionPercent;
    final double centerY = (rect.bottom - rect.top) * arrowPositionPercent;

    path.moveTo(left + topLeftDiameter / 2.0, top);

    if (position == BubblePosition.top) {
      path.lineTo(centerX - arrowSize.width + offset, top);
      path.lineTo(centerX + offset, rect.top);
      path.lineTo(centerX + arrowSize.width + offset, top);
    }

    path.lineTo(right - topRightDiameter / 2.0, top);
    path.quadraticBezierTo(right, top, right, top + topRightDiameter / 2);

    if (position == BubblePosition.right) {
      path.lineTo(right, centerY - arrowSize.height + offset);
      path.lineTo(rect.right, centerY + offset);
      path.lineTo(right, centerY + arrowSize.height + offset);
    }

    path.lineTo(right, bottom - bottomRightDiameter / 2);
    path.quadraticBezierTo(
      right,
      bottom,
      right - bottomRightDiameter / 2,
      bottom,
    );

    if (position == BubblePosition.bottom) {
      path.lineTo(centerX + arrowSize.width + offset, bottom);
      path.lineTo(centerX + offset, rect.bottom);
      path.lineTo(centerX - arrowSize.width + offset, bottom);
    }

    path.lineTo(left + bottomLeftDiameter / 2, bottom);
    path.quadraticBezierTo(left, bottom, left, bottom - bottomLeftDiameter / 2);

    if (position == BubblePosition.left) {
      path.lineTo(left, centerY - arrowSize.height + offset);
      path.lineTo(rect.left, centerY + offset);
      path.lineTo(left, centerY + arrowSize.height + offset);
    }

    path.lineTo(left, top + topLeftDiameter / 2);
    path.quadraticBezierTo(left, top, left + topLeftDiameter / 2, top);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  /// Calculates the relative position of the arrow.
  double _getArrowPositionPercent(Size size) {
    final width = size.width;
    final height = size.height;

    switch (alignment) {
      case BubbleAlignment.start:
        return _isVertical
            ? arrowSize.width / width
            : arrowSize.height / height;
      case BubbleAlignment.center:
        return 0.5;
      case BubbleAlignment.end:
        return _isVertical
            ? (width - arrowSize.width) / width
            : (height - arrowSize.height) / height;
      default:
        return 0.5;
    }
  }
}
