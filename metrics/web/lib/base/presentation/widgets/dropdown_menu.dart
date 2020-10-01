import 'package:flutter/material.dart';
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
  /// If the [items.length] is greater than this number,
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

  /// Creates a dropdown menu widget.
  ///
  /// Builds the opened menu using the [menuBuilder]. The [menuBuilder] should
  /// call the [AnimationComponentData.opened] and [AnimationComponentData.closed]
  /// callbacks on menu open state changes.
  ///
  /// If [items] are null, an empty list used.
  /// If the [itemHeight] is null the [kMinInteractiveDimension] used.
  /// If the [menuPadding] is null the [EdgeInsets.zero] used.
  ///
  /// [itemBuilder], [buttonBuilder], [menuBuilder] 
  /// and [maxVisibleItems] must not be `null`.
  const DropdownMenu({
    Key key,
    @required this.menuBuilder,
    @required this.itemBuilder,
    @required this.buttonBuilder,
    @required this.maxVisibleItems,
    this.onItemSelected,
    this.initiallySelectedItemIndex,
    List<T> items,
    double itemHeight,
    EdgeInsets menuPadding,
  })  : items = items ?? const [],
        itemHeight = itemHeight ?? kMinInteractiveDimension,
        menuPadding = menuPadding ?? EdgeInsets.zero,
        assert(maxVisibleItems != null && maxVisibleItems > 0),
        assert(menuBuilder != null),
        assert(itemBuilder != null),
        assert(buttonBuilder != null),
        assert(maxVisibleItems != null),
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
              padding: EdgeInsets.zero,
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

    if (numberOfItems > maxVisibleItems) {
      return maxVisibleItems * itemHeight + itemHeight / 2;
    }

    return numberOfItems * itemHeight;
  }
}
