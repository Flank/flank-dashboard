// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/decoration/bubble_shape_border.dart';

import '../../../test_utils/matcher_util.dart';

void main() {
  group("BubbleShapeBorder", () {
    test(
      "creates a new instance with the default values if the parameters are not specified",
      () {
        const bubbleShapeBorder = BubbleShapeBorder();

        expect(bubbleShapeBorder.position, isNotNull);
        expect(bubbleShapeBorder.alignment, isNotNull);
        expect(bubbleShapeBorder.arrowSize, isNotNull);
        expect(bubbleShapeBorder.offset, isNotNull);
        expect(bubbleShapeBorder.borderRadius, isNotNull);
      },
    );

    test("throws an AssertionError if the given position is null", () {
      expect(
        () => BubbleShapeBorder(position: null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the given arrow size is null", () {
      expect(
        () => BubbleShapeBorder(arrowSize: null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the given offset is null", () {
      expect(
        () => BubbleShapeBorder(offset: null),
        MatcherUtil.throwsAssertionError,
      );
    });

    test("throws an AssertionError if the given border radius is null", () {
      expect(
        () => BubbleShapeBorder(borderRadius: null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
