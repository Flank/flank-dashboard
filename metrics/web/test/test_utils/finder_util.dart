// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/base/presentation/widgets/rive_animation.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/widgets/build_status_view.dart';

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

  /// Finds the [SvgImage] in the widget tree under tests using the given [tester].
  static SvgImage findSvgImage(WidgetTester tester) {
    return tester.widget<SvgImage>(find.byType(SvgImage));
  }

  /// Finds the [SvgPicture] in the widget tree under tests using the given [tester].
  static SvgPicture findSvgPicture(WidgetTester tester) {
    return tester.widget<SvgPicture>(find.byType(SvgPicture));
  }

  /// Finds the [Image] in the widget tree under tests using the given [tester].
  static Image findImage(WidgetTester tester) {
    return tester.widget<Image>(find.byType(Image));
  }

  /// Finds the [TextField] in the widget tree under tests using the given [tester].
  static TextField findTextField(WidgetTester tester) {
    return tester.widget<TextField>(find.byType(TextField));
  }

  /// Finds the [InfoDialog] in the widget tree under tests using the given [tester].
  static InfoDialog findInfoDialog(WidgetTester tester) {
    return tester.widget<InfoDialog>(find.byType(InfoDialog));
  }

  /// Finds the [RiveAnimation] in the widget tree under tests using the given [tester].
  static RiveAnimation findRiveAnimation(WidgetTester tester) {
    return tester.widget<RiveAnimation>(find.byType(RiveAnimation));
  }

  /// Finds the [BuildStatusView] in the widget tree under tests using the given [tester].
  static BuildStatusView findBuildStatusView(WidgetTester tester) {
    return tester.widget<BuildStatusView>(find.byType(BuildStatusView));
  }
}
