import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/decoration/bubble_shape_border.dart';

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
  });
}
