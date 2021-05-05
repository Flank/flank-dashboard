// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("DropdownMenu", () {
    const items = ['1', '2', '3'];
    const itemHeight = 15.0;
    const listPadding = EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0);

    final selectionMenuFinder = find.byWidgetPredicate(
      (widget) => widget is SelectionMenu,
    );

    testWidgets(
      "throws an AssertionError if the item builder parameter is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed(itemBuilder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the button builder parameter is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownMenuTestbed(buttonBuilder: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the menu builder parameter is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed(menuBuilder: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the max visible items parameter is null",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownMenuTestbed(maxVisibleItems: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the max visible items parameter is zero",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownMenuTestbed(maxVisibleItems: 0),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the max visible items parameter is negative",
      (tester) async {
        await tester.pumpWidget(
          const _DropdownMenuTestbed(maxVisibleItems: -4),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "uses an empty list as a default if the items parameter is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed(items: null));

        final selectionMenuWidget = tester.widget<SelectionMenu>(
          selectionMenuFinder,
        );

        expect(selectionMenuWidget.itemsList, equals([]));
      },
    );

    testWidgets(
      "uses a minimum interactive dimension constant as a default if the item height parameter is null",
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
      "uses a zero padding as a default if the menu padding parameter is null",
      (tester) async {
        final menuWidget = Container(
          height: 30.0,
          color: Colors.red,
        );

        await tester.pumpWidget(_DropdownMenuTestbed(
          menuPadding: null,
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
      "applies a zero list padding if the given list padding is null",
      (tester) async {
        await tester.pumpWidget(const _DropdownMenuTestbed(listPadding: null));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );

        await tester.pumpAndSettle();

        final listViewWidget = tester.widget<ListView>(find.byType(ListView));

        expect(listViewWidget.padding, equals(EdgeInsets.zero));
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
      "delegates the given initially selected item index parameter to the SelectionMenu widget",
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

        expect(actualItems, equals(items));
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
      "builds the DropdownMenu widget using the given menuBuilder",
      (tester) async {
        final menuWidget = Container(
          height: 30.0,
          color: Colors.black,
        );

        await tester.pumpWidget(_DropdownMenuTestbed(
          menuBuilder: (_) => menuWidget,
        ));

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );
        await tester.pumpAndSettle();

        expect(find.byWidget(menuWidget), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given menu padding to the DropdownMenu widget",
      (tester) async {
        const expectedPadding = EdgeInsets.all(8.0);
        final menuWidget = Container(
          height: 30.0,
          color: Colors.red,
        );

        await tester.pumpWidget(_DropdownMenuTestbed(
          menuPadding: expectedPadding,
          menuBuilder: (_) => menuWidget,
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
      "applies the given list padding to the list view",
      (tester) async {
        const expectedPadding = EdgeInsets.all(8.0);

        await tester.pumpWidget(
          const _DropdownMenuTestbed(listPadding: expectedPadding),
        );

        await tester.tap(
          find.byWidgetPredicate((widget) => widget is DropdownMenu),
        );

        await tester.pumpAndSettle();

        final listViewWidget = tester.widget<ListView>(find.byType(ListView));

        expect(listViewWidget.padding, equals(expectedPadding));
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
      "height equals to the height of all items if their number is less than the given max visible items",
      (tester) async {
        final expectedMaxHeight =
            itemHeight * items.length + listPadding.top + listPadding.bottom;

        await tester.pumpWidget(const _DropdownMenuTestbed(
          itemHeight: itemHeight,
          maxVisibleItems: 4,
          items: items,
          listPadding: listPadding,
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
      "height equals to the sum of max visible items and a half if items more than max visible items",
      (tester) async {
        const maxVisibleItems = 2;
        final expectedMaxHeight =
            itemHeight * maxVisibleItems + itemHeight / 2 + listPadding.top;

        await tester.pumpWidget(const _DropdownMenuTestbed(
          itemHeight: itemHeight,
          items: items,
          maxVisibleItems: maxVisibleItems,
          listPadding: listPadding,
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

        await tester.tap(selectionMenuFinder);
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
        await tester.pumpWidget(_DropdownMenuTestbed(
          items: items,
          itemBuilder: (_, item) => _DropdownTestItem(item: item),
        ));

        await tester.tap(selectionMenuFinder);
        await tester.pumpAndSettle();

        expect(find.byType(_DropdownTestItem), findsWidgets);

        await tester.tapAt(Offset.zero);
        await tester.pumpAndSettle();

        expect(find.byType(_DropdownTestItem), findsNothing);
      },
    );
  });
}

/// A testbed class needed to test the [DropdownMenu] widget.
class _DropdownMenuTestbed extends StatelessWidget {
  /// A number of maximum visible items when the menu is open.
  ///
  /// If the length of the [items] is greater than this number,
  /// the [maxVisibleItems] and a half of the next item will be visible.
  /// Otherwise all items will be visible.
  final int maxVisibleItems;

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

  /// An [EdgeInsets] representing an empty space around the dropdown menu list.
  final EdgeInsets listPadding;

  /// Creates an instance of this testbed.
  ///
  /// If the [itemBuilder] is not specified, the default item builder used.
  /// If the [buttonBuilder] is not specified, the default button builder used.
  /// If the [menuBuilder] is not specified, the default menu builder used.
  /// If the [maxVisibleItems] is not specified, the default value of `5` used.
  const _DropdownMenuTestbed({
    Key key,
    this.itemBuilder = _itemBuilder,
    this.buttonBuilder = _buttonBuilder,
    this.menuBuilder = _menuBuilder,
    this.maxVisibleItems = 5,
    this.onItemSelected,
    this.initiallySelectedItemIndex,
    this.items,
    this.itemHeight,
    this.menuPadding,
    this.listPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DropdownMenu(
          itemBuilder: itemBuilder,
          buttonBuilder: buttonBuilder,
          menuBuilder: menuBuilder,
          items: items,
          itemHeight: itemHeight,
          maxVisibleItems: maxVisibleItems,
          initiallySelectedItemIndex: initiallySelectedItemIndex,
          onItemSelected: onItemSelected,
          menuPadding: menuPadding,
          listPadding: listPadding,
        ),
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
