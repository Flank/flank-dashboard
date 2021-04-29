// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/dropdown_body.dart';
import 'package:metrics/base/presentation/widgets/dropdown_item.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

/// A [Function] used to build a dropdown menu item.
typedef DropdownItemBuilder<T> = Widget Function(BuildContext context, T item);

/// A customizable dropdown menu widget.
///
/// Based on [SelectionMenu] widget. Usually used with [DropdownItem]s
/// and displays a [DropdownBody] in open state.
class DropdownMenu<T> extends StatefulWidget {
  /// An [AnimationBuilder] needed to build the dropdown menu widget.
  ///
  /// Should call the [AnimationComponentData.opened] once menu opening finished
  /// and [AnimationComponentData.closed] once menu closing finished.
  final AnimationBuilder menuBuilder;

  /// A [DropdownItemBuilder] needed to build a single dropdown menu item.
  final DropdownItemBuilder<T> itemBuilder;

  /// A [DropdownItemBuilder] needed to build a dropdown button.
  final DropdownItemBuilder<T> buttonBuilder;

  /// A number of maximum visible items when the menu is open.
  ///
  /// If the length of the [items] is greater than this number,
  /// the [maxVisibleItems] and a half of the next item will be visible.
  /// Otherwise all items will be visible.
  final int maxVisibleItems;

  /// A [ValueChanged] callback called when selecting an item from the list.
  final ValueChanged<T> onItemSelected;

  /// An initially selected item index in the given [items] list.
  final int initiallySelectedItemIndex;

  /// A list of items to select from.
  final List<T> items;

  /// A height of the item in items list.
  final double itemHeight;

  /// An [EdgeInsets] representing an empty space around the dropdown menu.
  final EdgeInsets menuPadding;

  /// An [EdgeInsets] representing an empty space around the dropdown menu list.
  final EdgeInsets listPadding;

  /// Creates a dropdown menu widget.
  ///
  /// Builds the opened menu using the [menuBuilder]. The [menuBuilder] should
  /// call the [AnimationComponentData.opened] and [AnimationComponentData.closed]
  /// callbacks on menu open state changes.
  ///
  /// If the [maxVisibleItems] is not specified, the default value of `5` used.
  /// If [items] are null, an empty list used.
  /// If the [itemHeight] is null the [kMinInteractiveDimension] used.
  /// If the [menuPadding] is null the [EdgeInsets.zero] used.
  /// If the [listPadding] is null the [EdgeInsets.zero] used.
  ///
  /// [itemBuilder], [buttonBuilder] and [menuBuilder] must not be `null`.
  const DropdownMenu({
    Key key,
    @required this.menuBuilder,
    @required this.itemBuilder,
    @required this.buttonBuilder,
    this.maxVisibleItems = 5,
    this.onItemSelected,
    this.initiallySelectedItemIndex,
    List<T> items,
    double itemHeight,
    EdgeInsets menuPadding,
    EdgeInsets listPadding,
  })  : items = items ?? const [],
        itemHeight = itemHeight ?? kMinInteractiveDimension,
        menuPadding = menuPadding ?? EdgeInsets.zero,
        listPadding = listPadding ?? EdgeInsets.zero,
        assert(maxVisibleItems != null && maxVisibleItems > 0),
        assert(menuBuilder != null),
        assert(itemBuilder != null),
        assert(buttonBuilder != null),
        super(key: key);

  @override
  _DropdownMenuState<T> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<DropdownMenu<T>> {
  @override
  Widget build(BuildContext context) {
    return SelectionMenu<T>(
      itemsList: widget.items,
      initiallySelectedItemIndex:
          widget.items.isEmpty ? null : widget.initiallySelectedItemIndex,
      itemBuilder: (_, item, onItemSelected) {
        return GestureDetector(
          onTap: onItemSelected,
          child: widget.itemBuilder(context, item),
        );
      },
      onItemSelected: (item) => widget.onItemSelected?.call(item),
      componentsConfiguration: DropdownComponentsConfiguration(
        menuPositionAndSizeComponent: MenuPositionAndSizeComponent(
          builder: (data) {
            return MenuPositionAndSize(
              positionOffset: Offset.zero,
              constraints: BoxConstraints.loose(
                Size(
                  data?.triggerPositionAndSize?.size?.width ?? 0.0,
                  _calculateMenuHeight(),
                ),
              ),
            );
          },
        ),
        animationComponent: AnimationComponent(
          builder: (data) {
            return Padding(
              padding: widget.menuPadding,
              child: widget.menuBuilder(data),
            );
          },
        ),
        listViewComponent: ListViewComponent(
          builder: (data) {
            return ListView.builder(
              padding: widget.listPadding,
              itemCount: data.itemCount,
              itemBuilder: data.itemBuilder,
            );
          },
        ),
        triggerComponent: TriggerComponent(
          builder: (data) {
            return TappableArea(
              onTap: data.triggerMenu,
              builder: (context, isHovered, child) => child,
              child: widget.buttonBuilder(context, data.selectedItem as T),
            );
          },
        ),
      ),
    );
  }

  /// Calculates a height of the menu by the given items,
  /// itemHeight and maxVisibleItems.
  double _calculateMenuHeight() {
    final numberOfItems = widget.items.length;
    final itemHeight = widget.itemHeight;
    final maxVisibleItems = widget.maxVisibleItems;
    final verticalPadding = widget.listPadding.bottom + widget.listPadding.top;

    if (numberOfItems > maxVisibleItems) {
      return maxVisibleItems * itemHeight +
          itemHeight / 2 +
          widget.listPadding.top;
    }

    return numberOfItems * itemHeight + verticalPadding;
  }
}
