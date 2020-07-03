import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/app_bar/widget/metrics_app_bar.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/scaffold/widget/metrics_scaffold.dart';
import 'package:metrics/common/presentation/widgets/metrics_page_title.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group("MetricsScaffold", () {
    const drawer = Drawer();

    testWidgets(
      "throws an AssertionError if trying to create without a body",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsScaffoldTestbed(body: null));
        });

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given body",
      (WidgetTester tester) async {
        const body = Text('body text');

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsScaffoldTestbed(body: body));
        });

        expect(find.byWidget(body), findsOneWidget);
      },
    );

    testWidgets(
      "constraints width to the dimensions config content width",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsScaffoldTestbed());
        });

        final container = tester.widget<Container>(find.byType(Container));

        expect(
          container.constraints,
          equals(
            BoxConstraints.tight(
              Size.fromWidth(DimensionsConfig.contentWidth),
            ),
          ),
        );
      },
    );

    testWidgets("applies the given padding", (WidgetTester tester) async {
      const body = SizedBox();
      const padding = EdgeInsets.all(4.0);

      await mockNetworkImagesFor(() {
        return tester.pumpWidget(const _MetricsScaffoldTestbed(
          body: body,
          padding: padding,
        ));
      });

      final widget = tester.widget<Padding>(
        find.ancestor(
          of: find.byWidget(body),
          matching: find.byType(Padding),
        ),
      );

      expect(widget.padding, equals(padding));
    });

    testWidgets(
      "hides the metrics page tile widget if the body title is null",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsScaffoldTestbed(
              bodyTitle: null,
            ),
          );
        });

        expect(find.byType(MetricsPageTitle), findsNothing);
      },
    );

    testWidgets(
      "displays the given body title in the metrics page title widget if the body title is not null",
      (WidgetTester tester) async {
        const bodyTitle = 'bodyTitle';

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsScaffoldTestbed(bodyTitle: bodyTitle),
          );
        });

        expect(
          find.widgetWithText(MetricsPageTitle, bodyTitle),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains the MetricsAppBar",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsScaffoldTestbed());
        });

        expect(find.byType(MetricsAppBar), findsOneWidget);
      },
    );

    testWidgets(
      "places the drawer on the right side of the Scaffold",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _MetricsScaffoldTestbed(drawer: drawer),
          );
        });

        final scaffoldWidget = tester.widget<Scaffold>(find.byType(Scaffold));

        expect(scaffoldWidget.endDrawer, drawer);
      },
    );

    testWidgets(
      "opens the given drawer on tap on the ink well widget",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _MetricsScaffoldTestbed(
            drawer: drawer,
          ));
        });

        await tester.tap(
          find.descendant(
            of: find.byType(MetricsAppBar),
            matching: find.byType(InkWell),
          ),
        );

        await tester.pump();

        expect(find.byWidget(drawer), findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsScaffold] widget.
class _MetricsScaffoldTestbed extends StatelessWidget {
  /// A primary content of this scaffold.
  final Widget body;

  /// A panel that slides in horizontally from the edge of
  /// a Scaffold to show navigation links in an application.
  final Widget drawer;

  /// A general padding around the [body].
  final EdgeInsets padding;

  /// A title for the body of this scaffold.
  final String bodyTitle;

  /// Creates the [_MetricsScaffoldTestbed].
  ///
  /// The [body] defaults to the sized box widget.
  /// The [padding] defaults to the [EdgeInsets.zero].
  /// The [bodyTitle] defaults to the `title`.
  const _MetricsScaffoldTestbed({
    Key key,
    this.drawer,
    this.body = const SizedBox(),
    this.padding = EdgeInsets.zero,
    this.bodyTitle = 'title',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MetricsScaffold(
        body: body,
        bodyTitle: bodyTitle,
        padding: padding,
        drawer: drawer,
      ),
    );
  }
}
