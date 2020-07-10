import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("DropdownMenu", () {
    const items = ['1', '2', '3'];

    final selectionMenuFinder = find.byWidgetPredicate(
      (widget) => widget is SelectionMenu,
    );

    testWidgets(
      "throws an AssertionError if the itemBuilder parameter is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed(itemBuilder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the buttonBuilder parameter is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownMenuTestbed(buttonBuilder: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the menuBuilder parameter is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed(menuBuilder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "uses an empty list as a default if the items parameter is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed());

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        expect(selectionMenuWidget.itemsList, equals([]));
      },
    );

    testWidgets(
      "uses a linear animation curve as a default if the menuAnimationCurve parameter is null",
      (tester) async {
        const expectedAnimationCurve = Curves.linear;

        await tester.pumpWidget(const _DropdownMenuTestbed(
          menuAnimationCurve: null,
        ));

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        final animationCurves =
            selectionMenuWidget.componentsConfiguration.menuAnimationCurves;

        expect(animationCurves.forward, equals(expectedAnimationCurve));
        expect(animationCurves.reverse, equals(expectedAnimationCurve));
      },
    );

    testWidgets(
      "uses a zero duration as a default if the menuAnimationDuration parameter is null",
      (tester) async {
        const expectedDuration = Duration();

        await tester.pumpWidget(const _DropdownMenuTestbed(
          menuAnimationDuration: null,
        ));

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        final animationDurations =
            selectionMenuWidget.componentsConfiguration.menuAnimationDurations;

        expect(animationDurations.forward, equals(expectedDuration));
        expect(animationDurations.reverse, equals(expectedDuration));
      },
    );

    testWidgets(
      "uses a minimum interactive dimension constant as a default if the itemHeight parameter is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed(itemHeight: null));

        final dropdownMenuWidget = tester.widget<DropdownMenu>(
          find.byWidgetPredicate(
            (widget) => widget is DropdownMenu,
          ),
        );

        expect(dropdownMenuWidget.itemHeight, equals(kMinInteractiveDimension));
      },
    );

    testWidgets(
      "uses a zero padding as a default if the menuPadding parameter is not specified",
      (tester) async {
        final menuWidget = Container(
          height: 30.0,
          color: Colors.red,
        );

        await tester.pumpWidget(_DropdownMenuTestbed(
          menuBuilder: (data) {
            if (data.menuState == MenuState.OpeningStart) {
              data.opened();
            }
            return menuWidget;
          },
        ));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );

        await tester.pumpAndSettle();

        final menuPadding = tester.widget<Padding>(
          find.ancestor(
            of: find.byWidget(menuWidget),
            matching: find.byType(Padding),
          ),
        );

        expect(menuPadding.padding, equals(EdgeInsets.zero));
      },
    );

    testWidgets(
      "delegates the given items to the SelectionMenu widget",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed(items: items));

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        expect(selectionMenuWidget.itemsList, equals(items));
      },
    );

    testWidgets(
      "delegates the given initiallySelectedItemIndex parameter to the SelectionMenu widget",
      (tester) async {
        const expectedIndex = 1;

        await tester.pumpWidget(
          const _DropdownMenuTestbed(
            items: items,
            initiallySelectedItemIndex: expectedIndex,
          ),
        );

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        expect(
          selectionMenuWidget.initiallySelectedItemIndex,
          equals(expectedIndex),
        );
      },
    );

    testWidgets(
      "builds widgets that correspond to the given items using the given itemBuilder",
      (tester) async {
        await tester.pumpWidget(_DropdownMenuTestbed(
          items: items,
          itemBuilder: (_, item) => _DropdownTestItem(item: item),
        ));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );
        await tester.pumpAndSettle();

        final itemWidgets = tester.widgetList<_DropdownTestItem>(
          find.byType(_DropdownTestItem),
        );

        final actualItems = itemWidgets.map((item) => item.item).toList();

        expect(items, equals(actualItems));
      },
    );

    testWidgets(
      "calls the given onItemSelected callback on tap on the dropdown item",
      (tester) async {
        String tappedItem;
        final expectedTappedItem = items.first;

        await tester.pumpWidget(_DropdownMenuTestbed(
          items: items,
          itemBuilder: (_, item) => _DropdownTestItem(item: item),
          onItemSelected: (item) {
            tappedItem = item;
          },
        ));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(_DropdownTestItem).first);

        expect(tappedItem, equals(expectedTappedItem));
      },
    );

    testWidgets(
      "delegates the menu animation curves with the given menuAnimationCurve parameter to the SelectionMenu widget",
      (tester) async {
        const expectedAnimationCurve = Curves.ease;

        await tester.pumpWidget(const _DropdownMenuTestbed(
          menuAnimationCurve: expectedAnimationCurve,
        ));

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        final animationCurves =
            selectionMenuWidget.componentsConfiguration.menuAnimationCurves;

        expect(animationCurves.forward, expectedAnimationCurve);
        expect(animationCurves.reverse, expectedAnimationCurve);
      },
    );

    testWidgets(
      "delegates the menu animation durations to the SelectionMenu widget",
      (tester) async {
        const expectedAnimationDuration = Duration(milliseconds: 700);

        await tester.pumpWidget(const _DropdownMenuTestbed(
          menuAnimationDuration: expectedAnimationDuration,
        ));

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        final animationDurations =
            selectionMenuWidget.componentsConfiguration.menuAnimationDurations;

        expect(animationDurations.forward, expectedAnimationDuration);
        expect(animationDurations.reverse, expectedAnimationDuration);
      },
    );

    testWidgets(
      "builds the DropdownMenu widget using the given menuBuilder",
      (tester) async {
        final menuWidget = Container(
          height: 30.0,
          color: Colors.black,
        );

        await tester.pumpWidget(_DropdownMenuTestbed(
          menuBuilder: (_) {
            return menuWidget;
          },
        ));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );
        await tester.pumpAndSettle();

        expect(find.byWidget(menuWidget), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given menuPadding to the DropdownMenu widget",
      (tester) async {
        const expectedPadding = EdgeInsets.all(8.0);
        final menuWidget = Container(
          height: 30.0,
          color: Colors.red,
        );

        await tester.pumpWidget(_DropdownMenuTestbed(
          menuPadding: expectedPadding,
          menuBuilder: (data) {
            if (data.menuState == MenuState.OpeningStart) {
              data.opened();
            }
            return menuWidget;
          },
        ));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );
        await tester.pumpAndSettle();

        final menuPadding = tester.widget<Padding>(
          find.ancestor(
            of: find.byWidget(menuWidget),
            matching: find.byType(Padding),
          ),
        );

        expect(menuPadding.padding, equals(expectedPadding));
      },
    );

    testWidgets(
      "builds a dropdown button using the buttonBuilder function",
      (tester) async {
        const buttonWidget = Text("Select item");

        await tester.pumpWidget(_DropdownMenuTestbed(
          buttonBuilder: (_, __) => buttonWidget,
        ));

        expect(find.byWidget(buttonWidget), findsOneWidget);
      },
    );

    testWidgets(
      "creates box constraints for the dropdown menu with the maxHeight equals to the height of all items",
      (tester) async {
        const itemHeight = 15.0;
        final expectedMaxHeight = itemHeight * items.length;

        await tester.pumpWidget(const _DropdownMenuTestbed(
          itemHeight: itemHeight,
          items: items,
        ));

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        final menuPositionAndSize = selectionMenuWidget
            .componentsConfiguration.menuPositionAndSizeComponent
            .builder(null);

        expect(
          menuPositionAndSize.constraints.maxHeight,
          equals(expectedMaxHeight),
        );
      },
    );

    testWidgets(
      "closes a dropdown menu with dropdown items after tap on the menu item",
      (tester) async {
        await tester.pumpWidget(_DropdownMenuTestbed(
          items: items,
          itemBuilder: (_, item) => _DropdownTestItem(item: item),
        ));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );
        await tester.pumpAndSettle();

        expect(find.byType(_DropdownTestItem), findsWidgets);

        await tester.tap(find.byType(_DropdownTestItem).first);
        await tester.pumpAndSettle();

        expect(find.byType(_DropdownTestItem), findsNothing);
      },
    );

    testWidgets(
      "closes a dropdown menu with dropdown items after tap outside of the menu",
      (tester) async {
        final menuWidget = Container(
          height: 30.0,
          color: Colors.red,
        );

        await tester.pumpWidget(_DropdownMenuTestbed(
          menuBuilder: (data) {
            if (data.menuState == MenuState.OpeningStart) {
              data.opened();
            } else if (data.menuState == MenuState.ClosingEnd) {
              data.closed();
            }

            return menuWidget;
          },
        ));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );
        await tester.pumpAndSettle();

        expect(find.byWidget(menuWidget), findsOneWidget);

        await tester.tap(
          find.byType(MetricsThemedTestbed),
        );
        await tester.pumpAndSettle();

        expect(find.byWidget(menuWidget), findsNothing);
      },
    );
  });
}

/// A testbed class needed to test the [DropdownMenu] widget.
class _DropdownMenuTestbed extends StatelessWidget {
  /// A [Curve] of the menu opening animation.
  final Curve menuAnimationCurve;

  /// A [Duration] of the menu opening animation.
  final Duration menuAnimationDuration;

  /// A list of items to select from.
  final List<String> items;

  /// A height of the item in items list.
  final double itemHeight;

  /// An [AnimationBuilder] needed to build the dropdown menu widget.
  final AnimationBuilder menuBuilder;

  /// A [DropdownItemBuilder] needed to build a single dropdown menu item.
  final DropdownItemBuilder<String> itemBuilder;

  /// A [DropdownItemBuilder] needed to build a dropdown button.
  final DropdownItemBuilder<String> buttonBuilder;

  /// A [ValueChanged] callback called when selecting an item from the list.
  final ValueChanged<String> onItemSelected;

  /// An initially selected item index in the given [items] list.
  final int initiallySelectedItemIndex;

  /// An [EdgeInsets] describing empty space around the menu popup.
  final EdgeInsets menuPadding;

  /// Creates an instance of this testbed.
  ///
  /// If the [itemBuilder] is not specified, the default item builder used.
  /// If the [buttonBuilder] is not specified, the default button builder used.
  /// If the [menuBuilder] is not specified, the default menu builder used.
  const _DropdownMenuTestbed({
    Key key,
    this.itemBuilder = _itemBuilder,
    this.buttonBuilder = _buttonBuilder,
    this.menuBuilder = _menuBuilder,
    this.onItemSelected,
    this.initiallySelectedItemIndex,
    this.items,
    this.itemHeight,
    this.menuAnimationCurve,
    this.menuAnimationDuration,
    this.menuPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: DropdownMenu(
        itemBuilder: itemBuilder,
        buttonBuilder: buttonBuilder,
        menuBuilder: menuBuilder,
        items: items,
        itemHeight: itemHeight,
        menuAnimationDuration: menuAnimationDuration,
        menuAnimationCurve: menuAnimationCurve,
        initiallySelectedItemIndex: initiallySelectedItemIndex,
        onItemSelected: onItemSelected,
        menuPadding: menuPadding,
      ),
    );
  }

  /// A default item builder used if the [itemBuilder] is not specified.
  static Widget _itemBuilder(BuildContext context, String item) {
    return _DropdownTestItem(item: item);
  }

  /// A default button builder used if the [buttonBuilder] is not specified.
  static Widget _buttonBuilder(BuildContext context, String item) {
    return Container(
      height: 30.0,
      color: Colors.grey,
    );
  }

  /// A default menu builder used if the [menuBuilder] is not specified.
  static Widget _menuBuilder(AnimationComponentData data) {
    if (data.menuState == MenuState.OpeningStart) {
      data.opened();
    } else if (data.menuState == MenuState.ClosingEnd) {
      data.closed();
    }

    return Container(
      child: data.child,
    );
  }
}

/// A dropdown item widget used in tests.
class _DropdownTestItem extends StatelessWidget {
  /// An [item] to display.
  final String item;

  /// Creates a new instance of this widget with the given [item].
  const _DropdownTestItem({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(item ?? '');
  }
}
