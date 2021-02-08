// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

/// Enum that represents the side of the shape to display the arrow on.
enum BubblePosition {
  /// A position that represents the top side of the shape.
  top,

  /// A position that represents the bottom side of the shape.
  bottom,

  /// A position that represents the left side of the shape.
  left,

  /// A position that represents the right side of the shape.
  right,
}

/// Enum that represents the alignment of the arrow.
enum BubbleAlignment {
  /// An alignment that is used to place the arrow to the start edge
  /// of the shape.
  start,

  /// An alignment that is used to place the arrow to the middle of the shape.
  center,

  /// An alignment that is used to place the arrow to the end edge
  /// of the shape.
  end,
}

/// A shape border with the arrow.
class BubbleShapeBorder extends ShapeBorder {
  /// A side of the shape to display the arrow on.
  final BubblePosition position;

  /// An alignment of the arrow.
  final BubbleAlignment alignment;

  /// A size of the arrow. Absolute value is used.
  final Size arrowSize;

  /// An offset of the arrow. Can be a negative.
  ///
  /// If an arrow is on the horizontal side of the box, then the positive offset
  /// shifts the arrow to the right, the negative offset shifts to the left.
  /// If an arrow is on the vertical side of the box, then the positive offset
  /// shifts the arrow to the bottom, the negative offset shifts to the top.
  final double offset;

  /// A radius of the border of this shape. Absolute value is used.
  final BorderRadius borderRadius;

  /// Creates a new instance of the [BubbleShapeBorder].
  ///
  /// The [position] defaults to the [BubblePosition.bottom].
  /// The [alignment] defaults to the [BubbleAlignment.center].
  /// The [arrowSize] defaults to the [Size.square] of `10.0`.
  /// The [offset] defaults to the `0.0`.
  /// The [borderRadius] defaults to the [BorderRadius.zero].
  ///
  /// The [position], the [arrowSize], the [offset] and the [borderRadius]
  /// must not be null.
  /// If the [alignment] is null, the arrow is centered.
  const BubbleShapeBorder({
    this.position = BubblePosition.bottom,
    this.alignment = BubbleAlignment.center,
    this.arrowSize = const Size.square(10.0),
    this.offset = 0.0,
    this.borderRadius = BorderRadius.zero,
  })  : assert(position != null),
        assert(arrowSize != null),
        assert(offset != null),
        assert(borderRadius != null);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  /// Indicates whether this arrow on the horizontal axis.
  bool get _isHorizontal =>
      position == BubblePosition.top || position == BubblePosition.bottom;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    final path = Path();

    final limitedArrowSize = Size(
      min(arrowSize.width.abs(), rect.width),
      min(arrowSize.height.abs(), rect.height),
    );

    final bubbleRect = _createBubbleRect(rect, limitedArrowSize.height);
    final limitedBorderRadius = _limitBorderRadius(
      rect.size,
      limitedArrowSize,
    );

    path.addRRect(
      limitedBorderRadius.resolve(textDirection).toRRect(bubbleRect),
    );

    final rectSize = _isHorizontal ? rect.width : rect.height;
    final bubbleRectSideSize = _getRectSide(bubbleRect);
    final originalRectSideSize = _getRectSide(rect);

    final arrowPath = _getArrowPath(
      arrowWidth: limitedArrowSize.width,
      rectSize: rectSize,
      bubbleRectSideSize: bubbleRectSideSize,
      originalRectSideSize: originalRectSideSize,
    );

    path.addPath(arrowPath, Offset.zero);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  /// Creates the [Rect] using the [arrowHeight] as [rect] indent, based on
  /// the [position].
  Rect _createBubbleRect(Rect rect, double arrowHeight) {
    final spacingLeft = position == BubblePosition.left ? arrowHeight : 0.0;
    final spacingTop = position == BubblePosition.top ? arrowHeight : 0.0;
    final spacingRight = position == BubblePosition.right ? arrowHeight : 0.0;
    final spacingBottom = position == BubblePosition.bottom ? arrowHeight : 0.0;

    final double left = spacingLeft + rect.left;
    final double top = spacingTop + rect.top;
    final double right = rect.right - spacingRight;
    final double bottom = rect.bottom - spacingBottom;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  /// Constrains the [borderRadius] based on the [arrowSize], the [rectSize]
  /// and the [position].
  ///
  /// If the border coincides with the arrow, limits the [borderRadius], to be
  /// not greater than the half of the [rectSize] minus the corresponding [arrowSize],
  /// otherwise to be not greater than the half of the [rectSize].
  BorderRadius _limitBorderRadius(
    Size rectSize,
    Size arrowSize,
  ) {
    final arrowX = _isHorizontal ? arrowSize.width : arrowSize.height;
    final arrowY = _isHorizontal ? arrowSize.height : arrowSize.width;
    final maxBorderRadiusX = (rectSize.width - arrowX) / 2.0;
    final maxBorderRadiusY = (rectSize.height - arrowY) / 2.0;
    final maxReverseBorderRadiusX =
        _isHorizontal ? rectSize.width / 2.0 : maxBorderRadiusX;
    final maxReverseBorderRadiusY =
        _isHorizontal ? maxBorderRadiusY : rectSize.height / 2.0;

    final isTopLeft =
        position == BubblePosition.top || position == BubblePosition.left;
    final isTopRight =
        position == BubblePosition.top || position == BubblePosition.right;
    final isBottomLeft =
        position == BubblePosition.bottom || position == BubblePosition.left;
    final isBottomRight =
        position == BubblePosition.bottom || position == BubblePosition.right;

    final topLeftX = min(
      borderRadius.topLeft.x.abs(),
      isTopLeft ? maxBorderRadiusX : maxReverseBorderRadiusX,
    );
    final topLeftY = min(
      borderRadius.topLeft.y.abs(),
      isTopLeft ? maxBorderRadiusY : maxReverseBorderRadiusY,
    );

    final topRightX = min(
      borderRadius.topRight.x.abs(),
      isTopRight ? maxBorderRadiusX : maxReverseBorderRadiusX,
    );
    final topRightY = min(
      borderRadius.topRight.y.abs(),
      isTopRight ? maxBorderRadiusY : maxReverseBorderRadiusY,
    );

    final bottomLeftX = min(
      borderRadius.bottomLeft.x.abs(),
      isBottomLeft ? maxBorderRadiusX : maxReverseBorderRadiusX,
    );
    final bottomLeftY = min(
      borderRadius.bottomLeft.y.abs(),
      isBottomLeft ? maxBorderRadiusY : maxReverseBorderRadiusY,
    );

    final bottomRightX = min(
      borderRadius.bottomRight.x.abs(),
      isBottomRight ? maxBorderRadiusX : maxReverseBorderRadiusX,
    );
    final bottomRightY = min(
      borderRadius.bottomRight.y.abs(),
      isBottomRight ? maxBorderRadiusY : maxReverseBorderRadiusY,
    );

    return BorderRadius.only(
      topLeft: Radius.elliptical(topLeftX, topLeftY),
      topRight: Radius.elliptical(topRightX, topRightY),
      bottomLeft: Radius.elliptical(bottomLeftX, bottomLeftY),
      bottomRight: Radius.elliptical(bottomRightX, bottomRightY),
    );
  }

  /// Returns the rect side according to the [position].
  double _getRectSide(Rect rect) {
    switch (position) {
      case BubblePosition.top:
        return rect.top;
      case BubblePosition.bottom:
        return rect.bottom;
      case BubblePosition.left:
        return rect.left;
      case BubblePosition.right:
        return rect.right;
      default:
        return 0.0;
    }
  }

  /// Returns a [Path] of the arrow on the [bubbleRectSideSize].
  Path _getArrowPath({
    double arrowWidth,
    double rectSize,
    double originalRectSideSize,
    double bubbleRectSideSize,
  }) {
    final path = Path();

    final halfArrowWidth = arrowWidth / 2.0;
    final arrowPositionPercent = _getArrowPositionPercent(
      rectSize,
      halfArrowWidth,
    );
    final arrowCenter = rectSize * arrowPositionPercent;
    final arrowOffset = _limitArrowOffset(
      arrowCenter,
      halfArrowWidth,
      rectSize,
    );
    final arrowCenterPosition = arrowCenter + arrowOffset;
    final arrowStartPosition = arrowCenterPosition - halfArrowWidth;
    final arrowEndPosition = arrowCenterPosition + halfArrowWidth;

    if (_isHorizontal) {
      path.moveTo(arrowStartPosition, bubbleRectSideSize);
      path.lineTo(arrowStartPosition, bubbleRectSideSize);
      path.lineTo(arrowCenter + arrowOffset, originalRectSideSize);
      path.lineTo(arrowEndPosition, bubbleRectSideSize);
    } else {
      path.moveTo(bubbleRectSideSize, arrowStartPosition);
      path.lineTo(bubbleRectSideSize, arrowStartPosition);
      path.lineTo(originalRectSideSize, arrowCenter + arrowOffset);
      path.lineTo(bubbleRectSideSize, arrowEndPosition);
    }

    return path;
  }

  /// Calculates the relative position of the arrow on the current side.
  double _getArrowPositionPercent(double rectSideSize, double halfArrowWidth) {
    switch (alignment) {
      case BubbleAlignment.start:
        return halfArrowWidth / rectSideSize;
      case BubbleAlignment.center:
        return 0.5;
      case BubbleAlignment.end:
        return (rectSideSize - halfArrowWidth) / rectSideSize;
      default:
        return 0.5;
    }
  }

  /// Constrains the [offset], based on the [halfArrowWidth], the [arrowCenter]
  /// and the current [rectSize].
  ///
  /// Limits the offset to not allow to shift the arrow outside of the box.
  double _limitArrowOffset(
    double arrowCenter,
    double halfArrowWidth,
    double rectSize,
  ) {
    if (arrowCenter + offset + halfArrowWidth > rectSize) {
      return rectSize - halfArrowWidth - arrowCenter;
    } else if (arrowCenter + offset - halfArrowWidth < 0.0) {
      return halfArrowWidth - arrowCenter;
    }

    return offset;
  }
}
