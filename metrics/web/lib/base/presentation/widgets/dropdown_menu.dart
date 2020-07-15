import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

/// A [Function] used to build a dropdown menu item.
typedef DropdownItemBuilder<T> = Widget Function(BuildContext context, T item);

/// A dropdown menu widget.
class DropdownMenu<T> extends StatefulWidget {
  /// A list of items to select from.
  final List<T> items;

  /// A height of the item in items list.
  final double itemHeight;

  /// An [AnimationBuilder] needed to build the dropdown menu widget.
  ///
  /// Should call the [AnimationComponentData.opened] once menu opening finished
  /// and [AnimationComponentData.closed] once menu closing finished
  final AnimationBuilder menuBuilder;

  /// A [DropdownItemBuilder] needed to build a single dropdown menu item.
  final DropdownItemBuilder<T> itemBuilder;

  /// A [DropdownItemBuilder] needed to build a dropdown button.
  final DropdownItemBuilder<T> buttonBuilder;

  /// A [ValueChanged] callback called when selecting an item from the list.
  final ValueChanged<T> onItemSelected;

  /// An initially selected item index in the given [items] list.
  final int initiallySelectedItemIndex;

  /// An [EdgeInsets] representing an empty space around the dropdown menu.
  final EdgeInsets menuPadding;

  /// Creates a [DropdownMenu] widget.
  ///
  /// If [items] are null, an empty list used.
  /// If the [itemHeight] is null the [kMinInteractiveDimension] used.
  /// If the [menuPadding] is null the [EdgeInsets.zero] used.
  ///
  /// [itemBuilder], [buttonBuilder] and [menuBuilder] must not be null.
  const DropdownMenu({
    Key key,
    @required this.itemBuilder,
    @required this.buttonBuilder,
    @required this.menuBuilder,
    this.onItemSelected,
    this.initiallySelectedItemIndex,
    List<T> items,
    double itemHeight,
    EdgeInsets menuPadding,
  })  : items = items ?? const [],
        itemHeight = itemHeight ?? kMinInteractiveDimension,
        menuPadding = menuPadding ?? EdgeInsets.zero,
        assert(itemBuilder != null),
        assert(buttonBuilder != null),
        assert(menuBuilder != null),
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
                  widget.items.length * widget.itemHeight,
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
            return GestureDetector(
              onTap: data.triggerMenu,
              child: widget.buttonBuilder(context, data.selectedItem as T),
            );
          },
        ),
      ),
    );
  }
}
