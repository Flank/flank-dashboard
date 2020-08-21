import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';

/// A utility class needed to find widgets in the widget tree under tests.
class FinderUtil {
  /// Finds the [NetworkImage] in the widget tree under tests using the given [tester].
  static NetworkImage findNetworkImageWidget(WidgetTester tester) {
    final imageWidget = tester.widget<Image>(find.byType(Image));

    return imageWidget.image as NetworkImage;
  }

  /// Finds the [BoxDecoration] in the widget tree under tests using the given [tester].
  static BoxDecoration findBoxDecoration(WidgetTester tester) {
    final containerWidget = tester.widget<DecoratedContainer>(
      find.byType(DecoratedContainer),
    );

    return containerWidget.decoration as BoxDecoration;
  }

  /// Finds the [TextField] in the widget tree under tests using the given [tester].
  static TextField findTextField(WidgetTester tester) {
    return tester.widget<TextField>(find.byType(TextField));
  }

  /// Finds the [InfoDialog] in the widget tree under tests using the given [tester].
  static InfoDialog findInfoDialog(WidgetTester tester) {
    return tester.widget<InfoDialog>(find.byType(InfoDialog));
  }
}
